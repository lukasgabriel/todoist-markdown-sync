# Todoist Markdown Sync

A Python script that downloads your Todoist tasks and project structure as markdown files with all their metadata contained in a YAML frontmatter.
This is mainly intended for facilitating sync (based on individual pages) with Obsidian without the need for an Obsidian plugin.

Here's how it's gonna work:
1. The script (periodically) pulls all Projects, Tasks, Labels, Comments, etc. from the Todoist API.
2. It creates a folder for all new projects and files for all new tasks.
3. It updates those pages that already exist and moves the completed tasks to a 'Completed' Folder
4. It adds all contents to the body and all metadata to the YAML frontmatter of the file.

