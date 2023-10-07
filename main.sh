#!/bin/bash

# Check if the 'prips' command is available, and if not, install it
if ! command -v prips &> /dev/null; then
    read -p "'prips' command not found. Do you want to install it? (y/n): " install_prips
    if [ "$install_prips" = "y" ]; then
        sudo apt-get update
        sudo apt-get install -y prips
    else
        echo "You chose not to install 'prips'. Exiting."
        exit 1
    fi
fi

# Prompt the user for an ASN number
read -p "Enter an ASN number: " asn

# Prompt the user for an output file name
read -p "Enter an output file name (or press Enter to use 'ips.out'): " output_file
output_file="${output_file:-ips.out}"

# Get IP ranges associated with the ASN and append them to the specified output file
for range in $(whois -h whois.radb.net -- "-i origin $asn" | grep -Eo "([0-9.]+){4}/[0-9]+"); do
    prips $range >> "$output_file"
done

echo "IPs for ASN $asn have been added to $output_file"
