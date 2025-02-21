#!/bin/bash

# Prompt the user for their name
read -p "Enter your name: " UserName

# Defining the main directory
main_dir="submission_reminder_${UserName}"

# Define the subdirectories
app_dir="$main_dir/app"
config_dir="$main_dir/config"
modules_dir="$main_dir/modules"
assets_dir="$main_dir/assets"

# Creating directories
mkdir -p "$main_dir" "$app_dir" "$config_dir" "$modules_dir" "$assets_dir"

#-----------------------------------------------------------------------------------------------
# Input of file config.env
cat > "$config_dir/config.env" <<'EOF'
# This is the config file
ASSIGNMENT="Shell Navigation"
DAYS_REMAINING=2
EOF

#-----------------------------------------------------------------------------------------------
# Input of the functions in the file functions.sh
cat > "$modules_dir/functions.sh" <<'EOF'
#!/bin/bash

# Function to read submissions file and output students who have not submitted
function check_submissions {
    local submissions_file=$1
    echo "Checking submissions in $submissions_file"

    # Skip the header and iterate through the lines
    while IFS=, read -r student assignment status; do
        # Remove leading and trailing whitespace
        student=$(echo "$student" | xargs)
        assignment=$(echo "$assignment" | xargs)
        status=$(echo "$status" | xargs)

        # Check if assignment matches and status is 'not submitted'
        if [[ "$assignment" == "$ASSIGNMENT" && "$status" == "not submitted" ]]; then
            echo "Reminder: $student has not submitted the $ASSIGNMENT assignment!"
        fi
    done < <(tail -n +2 "$submissions_file") # Skip the header
}

EOF

#----------------------------------------------------------------------------------------------
# Creating the reminder script file reminder.sh
cat > "$app_dir/reminder.sh" <<'EOF'
#!/bin/bash

# Source environment variables and helper functions
source ./config/config.env
source ./modules/functions.sh

# Path to the submissions file
submissions_file="./assets/submissions.txt"

# Print remaining time and run the reminder function
echo "Assignment: $ASSIGNMENT"
echo "Days remaining to submit: $DAYS_REMAINING days"
echo "--------------------------------------------"

check_submissions $submissions_file
EOF

#---------------------------------------------------------------------------------
# Adding students to submissions.txt
cat >> "$assets_dir/submissions.txt" <<'EOF'
student, assignment, submission status
Chinemerem, Shell Navigation, not submitted
Chiagoziem, Git, submitted
Divine, Shell Navigation, not submitted
Anissa, Shell Basics, submitted
Maurice, Shell Navigation, not submitted
Tifare, Shell Basics, not submitted
Pascal, Shell Permissions, submitted
Marairi, Shell Navigation, submitted
Faith, Git, submitted
Armstong, Shell Basics, not submitted
Christian, Shell Navigation, submitted
Habeeb, Git, not submitted
Gilbert, Shell Permissions, submitted
Placide, Shell Basics, not submitted
EOF

#-------------------------------------------------------------------------------------
# Create the startup.sh script
cat > "$main_dir/startup.sh" <<'EOF'
#!/bin/bash
# Run the reminder script
bash app/reminder.sh
EOF

# Make the startup script executable
chmod a+x "$main_dir/startup.sh"
chmod a+x "$app_dir/reminder.sh"
chmod a+x "$modules_dir/functions.sh"

# Success message
echo "Environment setup complete! Run ./startup.sh inside $main_dir to test the application."
