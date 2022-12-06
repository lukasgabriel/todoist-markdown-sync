# Project Notes

Hierarchy:
Project > Subproject(s) > Section > Task > Subtask

Project has Folder and "Main page" with all contained sections, tasks, subtasks linked.

Subproject has Folder and "Main page" with link back to parent project and all contained sections, tasks, subtasks linked.

Section doesn't have own folder, just exists on (sub-)project main page as separator and as metadata field

Task has own folder with a "main page" in it.
If task has subtask, it's a folder with a "main page" cotaining the task info and all subtasks linked.

Attachments are dumped into the task's folder. The task's note gets a link to the attachment(s). All attachments get the ID of the Task they belong to in brackets in the filename.

Subtasks have their own note with link back to parent task and all subtask info.
If a subtask has attachments, it doesn't get its own folder, rather the attachments go into the parent task folder and the subtask file gets a link to the attachment(s).

Labels don't get a folder or a file, they just exist in the metadata of the tasks and subtasks.

Comments don't get their own file, but are handled as YAML fields. That also means that comments disappear from Obsidian when they are deleted in Todoist.

Filters and views can and will not get synced.


The YAML metadata is always overwritten with the newest info from Todoist, any changes made here are lost (except for completed, archived anddeleted tasks, but don't change any metadata in Obsidian and expect it to stay.)
The contents of the Note (everything below the YAML frontmatter separator) are never touched. The only thing that is written there by the script are the inline dataview fields and such. But they pull their info from the YAML frontmatter itself so the script doesn't change anything there, it just writes it once when the file is initially created.


Folders all live in "Todoist" folder with the metadata file governing sync and a log file documenting all actions the script takes. Server also has log file that doesn't roll over, Obsidian Vault's log file rolls over after 7 days.

So the resulting structure is as follows:

- Obsidian Vault
	- Todoist
		- Todoist Sync Metadata
			- (File) Sync Log
			- (File) Metadata File (is this necessary?)
		- Project 1 (ProjectID)
			- (File) Project Main Page (ProjectID)
			- Task without attachments or subtasks (TaskID)
				- (File) Task file (TaskID)
			- Task with attachments but no subtasks (TaskID)
				- (File) Task file (TaskID)
				- (File) Attachment 1 (TaskID)
			- Task with subtasks but no attachments (TaskID)
				- (File) Task main page (TaskID)
				- (File) Subtask 1 (TaskID)
			- Task with subtasks and attachments (TaskID)
				- (File) Task main page (TaskID)
				- (File) Subtask 1 with Attachments (TaskID)
				- (File) Attachment 2 (TaskID)
				- (File) Subtask Attachment 1 (TaskID)
			- Subproject 1 (ProjectID)
				- (File) Subproject Main Page (ProjectID)
				- ...same structure as parent project
				- Subproject Second Level (ProjectID)
					- ...
				- ...
	- Other Obsidan Folders...


When an element is completed, archived OR deleted, it stays in Obsidian. This is partly by choice (completed & archived), partly due to a limitation of the Todoist REST API (only the Sync API sends archived elements, but it doesn't have a Python library, so it's more of a pain to use.)

Possible workaround: Only sync things that are not in the "Inbox" or don't have any labels. So stuff is less likely to get synced if it's not a real task but rather a quick reminder I put in and quickly deleted again. Implement as command line flag so it can be switched on or off.


Todoist folder is not meant for outright browsing and modification, but for linking from other pages.


The script adds a comment to each project and task/subtask with a link to the corresponding obsidian file (with some sort of tag so the corresponding comment isn't synced back to Obsidian), no other modification on the Todoist side is done.


Purpose:
Allow for Todoist tasks to have a permanent file representation in the Obsidian Vault where one can add notes, link from and to other notes, and keep all this info around even after the Todoist task has long been completed or forgotten.


All files and folders have their Todoist ID in the name in brackets.
Example: 


Step-by-step:
1. Run periodically and downloads a complete list of todoist tasks, sections, labels, projects, and attachments.
3. Save every object to a corresponding dict (one dict for every type of object) with the Object's Todoist ID as key and the object as value.
4. Iterate over the projects dict and check if there's a folder for each project that has no parent ID.
	1. If there's a folder, do nothing for now.
	2. If there is no folder, create one including a "Main page" markdown file inside it.
5. Overwrite all YAML metadata in the main page file of the project.
6. Check Todoist API if there are comments on this project and fill that YAML field if there are.
	1. If the "comment" is an attachment, download the file from the linked URL and put it into the project's folder (overwrite old file).
7. Create an inline dataview block displaying all relevant project metadata.
8. Create an inline dataview block displaying all comments on this project.
9. Create an inline dataview block with a query that displays a table of all tasks that have this project as their project ID but have no section ID (and no parent ID?).
10. Iterate over the sections dict and get all sections that have their project ID set as this project's ID.
11. Create an inline dataview block for each of these sections with a query that displays a table of all tasks that have this section's ID as their section id.
12. Iterate over all tasks and check if there is a folder for each task that has its project ID as this project's ID.
	1. Same as with new project
13. Overwrite all YAML metadata in the main page file of the task.
14. Check Todoist API if there are comments on this task and fill that YAML field if there are.
	1. If the "comment" is an attachment, download the file from the linked URL and put it into the task's folder (overwrite old file).
15. Create an inline dataview block displaying all relevant task metadata.
16. Create an inline dataview block displaying all comments on this project.
17. Create an inline dataview block with a query that displays a table of all tasks that have their parent ID as this task's ID.
18. Iterate over all tasks and and create file (if not there) for each task that has its parent ID as this task's ID.
	1. Create all the inline fields, overwrite metadata, yada yada.
19. Iterate over the projects dict and check if there is a folder inside the parent project's folder for every project that has this project's ID as its parent ID.
	1. From here on, same procedure as for the parent project, up until the Todoist max project nesting depth.


Now we're left with a read-only representation of the state of our Todoist account in our Obsidian vault, with YAML metadata that can be queried with dataview and a hierarchical structure that makes browsing easy. And every project and task file can be edited, linked and added to/from.


Caveats: 
- Pretty much no two-way sync, just Todoist -> Obsidian
	- This is a bonus in my opinion
- Creates _a lot_ of files and folders.
	- See "further ideas"
- No deletion of deleted Todoist elements
- 


Further ideas:
"Pruning" function that removes files that have not been edited in Obsidian, have not been linked to from other pages outside of Todoist folder, and that are X days old. Could keep all the "functionality" of the script but immensely reduce the "cluttering factor".