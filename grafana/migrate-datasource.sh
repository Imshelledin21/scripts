#!/bin/bash

echo "Enter Source Grafana Instance URL (Include trailing /):"
read -r source_grafana_url
echo "Enter Source Grafana Instance API Key:"
read -r source_grafana_token
echo "Enter Target Grafana Instance URL (Include trailing /):"
read -r target_grafana_url
echo "Enter Target Grafana Instance API Key:"
read -r target_grafana_token

source_url="${source_grafana_url}api/datasources"
target_url="${target_grafana_url}api/datasources"

json_response=$(curl -s --insecure -H "Authorization: Bearer ${source_grafana_token}" -H "Content-Type: application/json" "${source_url}")


# Parse JSON response into a single-dimensional array of JSON strings
array=()
while IFS= read -r line; do
    array+=( "$line" )
done < <(echo "$json_response" | jq -c '.[]')

# Print the array elements
echo "Array elements:"
for element in "${array[@]}"; do
    post_response=$(curl -X POST --insecure -H "Content-Type: application/json" -H "Authorization: Bearer ${target_grafana_token}" "${target_url}" -d "${element}")

    echo "$post_response" | jq -c '.name'
    echo "$post_response" | jq -c '.message'
    echo "--------------------"
done