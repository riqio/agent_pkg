 #!/bin/bash

# this should be the locally installed jenkins username on the client side 
declare jenkins_username='admin'

# this should be the locally installed jenkins password on the client side
declare jenkins_password='releaseiq@123'

# this should be the locally installed jenkins url on the client 
declare jenkins_url='http://JenkinsServer:8080/'

# this should be the tenant id of the customer
declare tenant_id='9dd7d8fb-3802-4ba1-8738-de5fe74ab1a6'

# ideally this should be equal to $jenkins_url
# but sometimes due to internal network restrictations there might be a
# different address

# this should be the locally installed jenkins url on the client 
declare tenant_jenkins_url='http://JenkinsServer:8080/'


# this should be the admin-be url for the customer provisioned in the cloud
declare tenant_admin_be_url='https://rhea.api.releaseiq.io/admin-be/admin/api/settings/ci-tools'




new_token_value="$jenkins_username:$jenkins_password"

echo "new_token_value = $new_token_value"

status=$(curl --write-out '%{http_code}' --location --request POST "$tenant_admin_be_url" \
--header "X-RIQ-Tenant-ID: $tenant_id" \
--header "X-RIQ-Internal-Role: ApiAccess" \
--header 'Content-Type: application/json' \
--data-raw '{
   "pipelineSettings":[
      {
         "name":"Custom Script",
         "pipelineSettingTypeKey":"ci-tools",
         "settingsNamespaceKey":"pipeline-settings",
         "settings":{
            "toolType":"custom_script",
            "toolName":"'"$tenant_jenkins_url"'",
            "apiToken":"'"$new_token_value"'"
         }
      }
   ]
}')

echo "status = $status"

if [[ "$status" -eq "200" ]]
then
    echo "Api token created successfully!!"
else
    echo "Api request to $tenant_admin_be_url failed for token $token_value"
    exit 1
fi
