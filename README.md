# Logic Pro Backup

## Overview

`logic_pro_backup.sh` is a utility bash script designed to simplify the process of backing up and restoring Logic Pro settings. It ensures that your custom configurations, preferences, and audio settings are safely stored and can be restored whenever needed.

## Features

- **Backup Logic Pro Settings**:
  - Creates a zip archive containing essential Logic Pro settings and preferences.
  - Includes paths such as:
    - `$HOME/Library/Application Support/Logic`
    - `$HOME/Library/Preferences/com.apple.logic.pro.cs`
    - `$HOME/Library/Preferences/com.apple.logic10.plist`
    - `$HOME/Music/Audio Music Apps`

- **Restore Logic Pro Settings**:
  - Extracts a backup archive to restore Logic Pro settings.
  - Prompts for confirmation before overwriting existing settings.

## Usage

### Backup
```bash
./logic_pro_backup.sh --backup /path/to/folder/destination
```

### Restore
```bash
./logic_pro_backup.sh --restore /path/to/logic_pro_backup.zip
```

## Requirements

- Bash shell
- `zip` and `unzip` utilities installed on your system

## Error Handling

- Validates the existence of the destination directory for backup and the backup file for restore.
- Provides clear error messages for invalid inputs or failed operations.

## License

This project is licensed under the MIT License. See the script header for details.

## Author

Created by Vasco Nunes.
