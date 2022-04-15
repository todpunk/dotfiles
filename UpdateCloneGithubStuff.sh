#!/bin/bash

set -e
#set -x

# localvars is the preferred storage for config for our utilities
if [[ -f "${HOME}/.localvars" ]]; then
    source "${HOME}/.localvars"
fi
# Expects a directory where the structure is <DIR>/<Orgs>/<Repos>/
REPOSDIR=${REPOSDIR:-'${HOME}/repos'}
# Obviously change this to your user, this is for auth
GITHUB_USER=${GITHUB_USER:-'todpunk'}
# Your user is included by default, but you can adjust that as well.
GITHUB_USERS=${GITHUB_USERS:-'${GITHUB_USER}'}
GITHUB_ORGS=${GITHUB_ORGS:-'catalystsquad tnlcommunity'}
PERPAGE=10

if [[ -z "$GITHUB_PAT" ]]; then
    echo "Must provide GITHUB_PAT in environment" 1>&2
    exit 1
fi

# First update anything we've got already
for org in ${REPOSDIR}/*/
do
  echo "Org: ${org}"
  for repo in ${org}*/
  do
    # Skip symlinks
    [ -L "${d%/}" ] && continue
    if [ -d "${repo}" ]
    then
      cd "${repo}"
      if [[ -d .git ]]
      then
        branch_name=$(git symbolic-ref -q HEAD)
        branch_name=${branch_name##refs/heads/}
        branch_name=${branch_name:-HEAD}
        if [[ `git show-branch remotes/origin/${branch_name} | wc -l` == "1" ]]
        then
          echo "Updating ${repo}"
          set +e
          git pull
          set -e
        else 
          echo "Not updating ${repo}"
        fi
      fi
      cd -
    fi
  done
done

echo "Done with updates"

tmpfile=$(mktemp /tmp/gitupdater.XXXXXX)

echo "Checking Repos in Users"
for user in ${GITHUB_USERS} 
do
  echo "Checking repos for user: ${user}"
  BASEURL="https://api.github.com/users/${user}/repos"
  set +e
  LINKS=`curl -I -i -u "${GITHUB_USER}:${GITHUB_PAT}" -H "Accept: application/vnd.github.v3+json" -s ${BASEURL}?per_page=${PERPAGE} | grep -i link: 2>/dev/null`
  set -e
  if [ -z "$LINKS" ]
  then
    TOTALPAGES=1
  else
    TOTALPAGES=`echo ${LINKS} | sed 's/link: //g'|awk -F',' -v  ORS='\n' '{ for (i = 1; i <= NF; i++) print $i }'|grep -i last|awk '{print $1}' | tr -d '\<\>' | tr '\?\&' ' '|awk '{print $3}'| tr -d '=;page'`
  fi
  echo "Total Pages: ${TOTALPAGES}"
  i=1
  until [ $i -gt $TOTALPAGES ]
  do
    RESULT=`curl -s -u "${GITHUB_USER}:${GITHUB_PAT}" "${BASEURL}?per_page=${PERPAGE}&page=${i}" 2>&1`
    echo ${RESULT} > ${tmpfile}
    mkdir -p $user
    cd $user
    for repodata in `cat ${tmpfile} | jq '.[] | [.name, .ssh_url ] | @csv' | tr -d '\\\\\\"'`
    do
        reponame=$(echo $repodata | cut -f1 -d,)
        repourl=$(echo $repodata | cut -f2 -d,)

        echo "Repo stuff: ${reponame} $repourl}"

        [ -d "${reponame}" ] && continue
        git clone ${repourl}
    done
    cd -
    ((i=$i+1))
  done
done

echo "Checking Repos in Orgs"
for org in ${GITHUB_ORGS}
do
  echo "Checking repos for org: ${org}"
  BASEURL="https://api.github.com/orgs/${org}/repos"
  echo "Forming curl command"
  set +e
  LINKS=`curl -I -i -u "${GITHUB_USER}:${GITHUB_PAT}" -H "Accept: application/vnd.github.v3+json" -s ${BASEURL}?per_page=${PERPAGE} | grep -i link: 2>/dev/null`
  set -e
  if [ -z "$LINKS" ]
  then
    TOTALPAGES=1
  else
    TOTALPAGES=`echo ${LINKS} | sed 's/link: //g'|awk -F',' -v  ORS='\n' '{ for (i = 1; i <= NF; i++) print $i }'|grep -i last|awk '{print $1}' | tr -d '\<\>' | tr '\?\&' ' '|awk '{print $3}'| tr -d '=;page'`
  fi
  echo "Total Pages: ${TOTALPAGES}"
  i=1
  until [ $i -gt $TOTALPAGES ]
  do
    RESULT=`curl -s -u "${GITHUB_USER}:${GITHUB_PAT}" "${BASEURL}?per_page=${PERPAGE}&page=${i}" 2>&1`
    echo ${RESULT} > ${tmpfile}
    # Debug stuff I wanted to leave for posterity to fiddle with if the API changes
    #echo "Repo Name, SSH URL, Clone URL"
    #cat ${tmpfile} | jq '.[] | [.name, .ssh_url, .clone_url] | @csv' | tr -d '\\"'
    mkdir -p $org
    cd $org
    for repodata in `cat ${tmpfile} | jq '.[] | [.name, .ssh_url ] | @csv' | tr -d '\\\\\\"'`
    do
        reponame=$(echo $repodata | cut -f1 -d,)
        repourl=$(echo $repodata | cut -f2 -d,)

        echo "Repo stuff: ${reponame} $repourl}"

        [ -d "${reponame}" ] && continue
        git clone ${repourl}
    done
    cd -
    ((i=$i+1))
  done
done

rm "$tmpfile"

