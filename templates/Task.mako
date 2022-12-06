## Task Main Page Mako template
<%page args="x, y, z='default'"/>
<% cssclass = todoist-markdown-sync %>
\
---
aliases: [${task.content}, ${filename}]
tags: ${task.labels}
cssclass: ${cssclass}
task_id: ${task.id}
task_project_id: ${task.project_id}
task_project_name: ${project_dict[task.project_id].name if task.project_id else 'None'}
task_section_id: ${task.section_id}
task_section_name: ${section_dict[task.section_id].name if task.section_id else 'None'}
task_content: ${task.content}
task_description: ${task.description}
task_is_completed: ${task.is_completed}
task_parent_id: ${task.parent_id}
task_parent_content: {task_dict[task.parent_id].content if task.parent_id else 'None'}
task_order: ${task.order}
task_priority: ${task.priority}
task_due_date: {task.due.date if task.due else 'None'}
task_is_recurring: {task.due.is_recurring if task.due else 'None'}
task_due_datetime: {task.due.datetime if task.due else 'None'}
task_due_string: {task.due.string if task.due else 'None'}
task_due_timezone: {task.due.timezone if task.due else 'None'}
task_url: ${task.url}
task_comment_count: ${task.comment_count}
task_created_at: ${task.created_at}
task_creator_id: ${task.creator_id}
task_assignee_id: ${task.assignee_id}
task_assigner_id: ${task.assigner_id}
---

# `= this.task_content`
# `= this.task_description`

```dataview
TABLE 
    task_content AS 'Task', 
    task_project_name AS 'Project', 
    task_due_date AS 'Due', 
    task_priority AS 'Priority', 
    task_url AS 'URL' 
WHERE 
    file.name = this.file.name
```