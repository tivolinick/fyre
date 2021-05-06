#!/bin/sh

fyredir=~/.fyre
hostsfile="${fyredir}/hosts"

if [ ! -d ${fyredir} ] ; then
  mkdir ${fyredir}
  if [ -f creds ] ; then
    cp creds ${fyredir}/creds
  fi
fi
if [ -f ${hostsfile} ] ; then
  mv ${hostsfile} ${hostsfile}-$(date '+%y%m%d')
fi

# https://api.fyre.ibm.com/rest/v1/?operation=query&request=show[cluster|node]details&[cluster|node]_name=[cluster|node]_name
# https://api.fyre.ibm.com/rest/v1/?operation=query&request=showclusterdetails
 

clusters=$(./getit 'https://api.fyre.ibm.com/rest/v1/?operation=query&request=showclusters')
clnames=$(echo ${clusters}| jq -r '.clusters[] | (.name)')

for cl in ${clnames} ; do
  echo Cluster:${cl}
  clusterinfo=$(./getit "https://api.fyre.ibm.com/rest/v1/?operation=query&request=showclusterdetails&cluster_name=$cl")
  echo $clusterinfo | jq
  ips=$(echo ${clusterinfo}| jq -r ".${cl}[] | (.publicip,.node)")
  # echo ${clusterinfo}| jq -r ".${cl}[] | (.publicip,.node)"
  # echo  IPS:$ips
  found=""
  for h in ${ips} ; do
    if [ ${found} ] ; then
      echo "${found} ${h}" >> ${hostsfile}
      echo "${found} ${h}"
      found=""
    fi
    if [ "`echo ${h} | grep '9\.'`"  != '' ] ;then
      found=${h}
      # echo FOUND: $h
    # else
      # nodeinfo=$(./getit "https://api.fyre.ibm.com/rest/v1/?operation=query&request=shownodedetails&node_name=$h")
      # echo $nodeinfo | jq
    fi
  done
done

