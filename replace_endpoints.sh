#!/bin/bash

# Set the directory to search in
DIR="/opt/zammad"  # The directory to search and replace in
REPORT_FILE="replace_report.log"  # The file where the report will be saved

# Function to perform the replacement with verbose output
replace_text() {
    local search_text="$1"
    local replace_text="$2"
    local dir="$3"

    echo "Starting replacement: $search_text to $replace_text"
    echo "----------------------------------------" >> "$REPORT_FILE"
    echo "Replacing '$search_text' with '$replace_text' in $dir" >> "$REPORT_FILE"
    
    # Count the number of occurrences before replacement
    before_count=$(grep -rl "$search_text" "$dir" | wc -l)
    echo "Files before replacement: $before_count" >> "$REPORT_FILE"

    # Perform the replacement using sed
    files_modified=0
    find "$dir" -type f -exec sed -i "s/$search_text/$replace_text/g" {} + 2>/dev/null
    files_modified=$(grep -rl "$replace_text" "$dir" | wc -l)

    # Count the number of occurrences after replacement
    after_count=$(grep -rl "$replace_text" "$dir" | wc -l)
    echo "Files after replacement: $after_count" >> "$REPORT_FILE"
    echo "Files modified: $files_modified" >> "$REPORT_FILE"
    echo "----------------------------------------" >> "$REPORT_FILE"

    # Report the result to the console
    echo "Replacement for '$search_text' to '$replace_text' completed."
    echo "Files modified: $files_modified"
}


# 1. Replace login.microsoftonline.com with login.partner.microsoftonline.cn
replace_text "login\.microsoftonline\.com" "login\.partner\.microsoftonline\.cn" "$DIR"

# 2. Replace outlook.office.com with partner.outlook.cn
replace_text "outlook\.office\.com" "partner\.outlook\.cn" "$DIR"

# 3. Replace outlook.office365.com with partner.outlook.cn
replace_text "outlook\.office365\.com" "partner\.outlook\.cn" "$DIR"

# 4. SMTP
replace_text "smtp\.office365\.com" "smtp\.partner\.outlook\.cn" "$DIR"

# Notify user of completion and location of the report
echo "Script execution complete. Report saved to $REPORT_FILE."
