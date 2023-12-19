This is Task 1 of the XenonStack hiring process.
# Overall Architecture:

- The script is structured as a collection of functions, each serving a specific purpose.
- The main internsctl() function serves as the entry point and routes user-provided commands to their corresponding functions.
- Each individual function performs its defined task and typically outputs information or performs actions on the system.
# Components:

**Main Function (internsctl):**
- Takes commands and arguments as input.
- Handles options like --help and --version.
- Routes subcommands like cpu, memory, user, and file to their respective functions.
  
**Subcommand Functions:**
- get_cpu_info(): Executes lscpu command to display CPU information.
- get_memory_info(): Executes free command to display memory information.
- create_user(username): Creates a new user with the specified username and sets a default password.
- list_users(option): Lists all users or only users with sudo privileges based on the option.
- file_getinfo(file, options): Displays information about a specified file and supports options like --size, --permissions, etc.
  
**Helper Functions:**
- file_getinfo_help(): Displays help message for the file getinfo command.
- display_help(): Displays general help message for the entire internsctl script.

# Flow:

- User executes internsctl with a command and optional arguments.
- The main function checks the command and routes it to the appropriate subcommand function.
- The subcommand function performs its intended operation and displays information or performs actions.
- If an error occurs, an appropriate error message is displayed.
