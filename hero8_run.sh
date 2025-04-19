#!/bin/bash

# hero8_run.sh - Hauptskript für hero8-Operationen

command=$1
shift

case "$command" in
    update_docs)
        MESSAGE="$1"
        TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
        echo "Aktualisiere Dokumentation: $MESSAGE"
        
        DOC_FILE="/Users/ninaklee/Projects/hero8/Dokumentation/STATUS.md"
        mkdir -p "/Users/ninaklee/Projects/hero8/Dokumentation"
        
        echo "## Update: $TIMESTAMP" >> "$DOC_FILE"
        echo "- $MESSAGE" >> "$DOC_FILE"
        echo "" >> "$DOC_FILE"
        ;;
        
    push_changes)
        MESSAGE="$1"
        cd /Users/ninaklee/Projects/hero8
        git add .
        git commit -m "$MESSAGE"
        git push
        ;;
        
    transition)
        /Users/ninaklee/Projects/hero8/Skripts/Documentation/prepare_ki_transition.sh
        ;;
        
    *)
        echo "Verwendung: $0 {update_docs|push_changes|transition} [message]"
        exit 1
        ;;
esac
