#!/bin/bash

# Prompt the user for an ASN number
read -p "Enter an ASN number: " asn

# Prompt the user for an output file name
read -p "Enter an output file name (or press Enter to use 'ips.out'): " output_file
output_file="${output_file:-ips.out}"

# Check if the 'prips' command is available
if ! command -v prips &> /dev/null; then
    echo "Error: 'prips' command not found. Please install it with 'apt-get install prips'." >&2
    exit 1
fi

# Get IP ranges associated with the ASN and append them to the specified output file
for range in $(whois -h whois.radb.net -- "-i origin $asn" | grep -Eo "([0-9.]+){4}/[0-9]+"); do
    prips $range >> "$output_file"
done

echo "IPs for ASN $asn have been added to $output_file"
