# todoist_markdown_sync.py

import re
import json

from typing import Union

from loguru import logger
from dotenv import dotenv_values
from sanitize_filename import sanitize

from todoist_api_python.api import TodoistAPI
from todoist_api_python.models import (
    Task,
    Project,
    Label,
    Section,
    Due,
    Collaborator,
    Attachment,
    Comment,
)


TODOIST_API_TOKEN = dotenv_values(".env")["TODOIST_API_TOKEN"]
api = TodoistAPI(TODOIST_API_TOKEN)

logger.add("todoist_markdown_sync.log", level="DEBUG")


tasks, projects, labels, sections = (
    api.get_tasks(),
    api.get_projects(),
    api.get_labels(),
    api.get_sections(),
)

project_dict, task_dict, label_dict, section_dict = (
    {project.id: project for project in projects},
    {task.id: task for task in tasks},
    {label.id: label for label in labels},
    {section.id: section for section in sections},
)


def filename(element: Task|Project|Label|Section|Comment|Attachment) -> str:
    # Todo: Filter out links. For now, just don't use them in your task names.

    if type(element) == Attachment:
        return element.file_name

    filename = element.content if type(element) in [Task, Comment] else element.name

    if len(filename) > 128:
        filename = filename[:128]

    filename = sanitize(filename + " (" + element.id + ")")
    return filename


# with open(f"./test-output/{filename}.md", "w", encoding="utf-8") as f:


# for task in tasks:
#    task_to_markdown(task)

