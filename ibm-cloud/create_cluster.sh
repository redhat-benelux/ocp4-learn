export DataCenterZone=ams03
export ClusterName="my_openshift"

ibmcloud login -a https://api.eu-de.bluemix.net -r eu-de -u rahmed@redhat.com -p xxx -c 63cf37b8c3bb448cbf9b7507cc8ca57d -g benelux

export PublicVlanId=$(ibmcloud sl vlan list -d $DataCenterZone --output json | jq '.[] | select(.networkSpace=="PUBLIC")' | jq ."id")

export PrivateVlanId=$(ibmcloud sl vlan list -d $DataCenterZone --output json | jq '.[] | select(.networkSpace=="PRIVATE")' | jq ."id")

ibmcloud oc cluster create classic --name $ClusterName --location $DataCenterZone --version 4.3_openshift --flavor b3c.4x16.encrypted  --workers 3 --public-vlan $PublicVlanId --private-vlan $PrivateVlanId --public-service-endpoint

while [ "$(ibmcloud ks cluster ls --json | jq --arg ClusterName $ClusterName '.[] | select(.name==$ClusterName)'|  jq .'state')" != \""normal\"" ] ; do
  echo "not yet deployed, sleeping..."
  sleep 90
done

exit;
