#!/bin/bash

# update_current_work.sh - Simple tool to update the current work status
# This status will be automatically included in all KI-UEBERGABE documents

STATUS_FILE="/Users/ninaklee/Projects/hero8/Dokumentation/Status/CURRENT_ACTIVE_WORK.md"
TEMP_FILE="/tmp/current_work_temp.md"

# Ensure the status directory exists
mkdir -p "/Users/ninaklee/Projects/hero8/Dokumentation/Status"

# Check if the file already exists
if [ ! -f "$STATUS_FILE" ]; then
    # Create a template if it doesn't exist
    cat > "$STATUS_FILE" << 'TEMPLATE'
## CURRENT ACTIVE WORK: [Main Task Description]

### Status: [PLANNING/IN PROGRESS/BLOCKED/COMPLETED]
[Brief overview of where we are in the process]

### Current Step
- [Current specific activity]
- [Details about what has just been done]
- [What is currently being worked on]

### [Task-Specific Section]
- [Relevant details about the current work]
- [Important context]
- [Any specific challenges]

### Immediate Next Actions
1. [Next immediate step]
2. [Following step]
3. [Future steps]

### Blocking Issues
- [Any issues preventing progress]
- [Dependencies]
TEMPLATE
fi

echo "Updating current work status. Opening editor..."
echo "Make your changes and save the file."

# Open the file in the default editor
if [ -n "$EDITOR" ]; then
    $EDITOR "$STATUS_FILE"
elif command -v nano &> /dev/null; then
    nano "$STATUS_FILE"
elif command -v vim &> /dev/null; then
    vim "$STATUS_FILE"
else
    echo "No suitable text editor found. Please edit the file manually at:"
    echo "$STATUS_FILE"
    exit 1
fi

echo "Current work status updated. This will be included in your next KI-UEBERGABE."
echo "Running git commit to save changes..."

# Commit the changes
cd "/Users/ninaklee/Projects/hero8"
git add "$STATUS_FILE"
git commit -m "Update current work status"

echo "Status updated and committed!"
