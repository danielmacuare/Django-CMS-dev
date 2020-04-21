#!/usr/bin/env python3
import os
import re
import yaml
from pathlib import Path
from jinja2 import Environment, FileSystemLoader, PackageLoader, StrictUndefined
from termcolor import colored

# Docs: https://jinja.palletsprojects.com/en/2.11.x/api/#basics


ERROR_RED = colored("ERROR:", "red")
WRN_PREFIX = colored("WARNING:", "cyan")
SUCCESS_GREEN = colored("SUCCESS:", "green")
SHARED_DIR = os.environ["SHARED_DIR"]

# Functions
def get_templates_list(templates_path=f"{SHARED_DIR}/templates/"):
    """
    Checks the files on the templates_path and generates a list with their names
    Args:
        templates_path (str): complete path name of the location where templates are.
    
    Returns:
        None
    """
    # print(templates_path)
    templates_list = [x.as_posix() for x in Path(templates_path).rglob("*.j2")]
    # print(templates_list)
    return templates_list


def render_yaml_template(jinja_templates, yaml_file):
    """
    This takes a yam file with all yor vars, a Jinja template and renders an output file
    Args:
        yaml_file (str): YAML containing the variables neccessary to render the output
        jinja_templates (list): Jinja templates used to render the output
        output (str): 

    Returns:
        None
    """

    with open(yaml_file, "r") as file:
        try:
            print(f'{colored("- [READING]:", "green")} YAML (Vars) at "{yaml_file}"\n')
            data = yaml.safe_load(file)
        except yaml.YAMLError as err:
            print(err)
    # print(data)
    templates_dir = f"{SHARED_DIR}/templates"
    # print(templates_dir)
    env = Environment(
        loader=FileSystemLoader(searchpath=templates_dir),
        trim_blocks=True,
        lstrip_blocks=True,
        undefined=StrictUndefined,
    )
    for templ in jinja_templates:
        try:
            print(f'- [READING]: J2 Template at "{templ}"')
            file_name = os.path.basename(templ)
            template = env.get_template(name=file_name)
            out_data = template.render(data)
            # print(out_data)
            pattern = re.compile(f"(.*).j2")
            file_no_ext = pattern.match(file_name).group(1)
            # DINAMICAALLY GENERATE A BASH SCRIP .sh OR A CONFIG FILE
            with open(templ, "r") as f:
                if "/bin/bash" in f.readline():
                    extension = ".sh"
                    output_dir = f"{SHARED_DIR}/files/sh_scripts/"
                else:
                    extension = ""
                    output_dir = f"{SHARED_DIR}/files/configs/"

            file_path = output_dir + file_no_ext + extension
            with open(file_path, "w") as file:
                file.write(out_data)
            print(
                f'{colored("- [SUCCESS]:", "green")} A new file has been created'
                f' at: "{file_path}"\n'
            )
        except Exception as err:
            print(f"\t{ERROR_RED} at: {err}\n")


def main():
    jinja_templates = get_templates_list()
    print(f"{colored('### RENDERING ALL THE TEMPLATES ###', 'red')}")
    render_yaml_template(jinja_templates, yaml_file=f"{SHARED_DIR}/config.yaml")


if __name__ == "__main__":
    main()
