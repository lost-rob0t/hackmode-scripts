#!/usr/bin/env sh

# Input JSON file
input_file="$1"

# Loop through each line in the JSON file
while IFS= read -r line || [ -n "$line" ]; do
    # Extract type and data values using jq
    type_value=$(echo "$line" | jq -r '.type')
    data_value=$(echo "$line" | jq -r '.data')

    # Check if type is not empty
    if [ -n "$type_value" ]; then
        # Determine the output file based on the type
        output_file="${type_value}_output.txt"

        # Write the data to the corresponding file
        echo "$data_value" | anewer "$output_file" > /dev/null
    fi
done < "$input_file"
