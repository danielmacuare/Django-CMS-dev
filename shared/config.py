#!/usr/bin/env python3
import re
import yaml
from jinja2 import Environment, FileSystemLoader, PackageLoader, StrictUndefined
from termcolor import colored

# Docs: https://jinja.palletsprojects.com/en/2.11.x/api/#basics


ERROR_RED = colored("ERROR:", "red")
WRN_PREFIX = colored("WARNING:", "cyan")
SUCCESS_GREEN = colored("SUCCESS:", "green")

# Functions
def render_yaml_template(jinja_templates, yaml_file, output_dir="files/configs/"):
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
    templates_dir = "./templates"
    env = Environment(
        loader=FileSystemLoader(searchpath=templates_dir),
        trim_blocks=True,
        lstrip_blocks=True,
        undefined=StrictUndefined,
    )
    for templ in jinja_templates:
        try:
            template_path = templates_dir + "/" + templ
            print(f'- [READING]: J2 Template at "{template_path}"')
            template = env.get_template(name=templ)
            out_data = template.render(data)
            # print(out_data)
            pattern = re.compile(f"(.*).j2")
            filename = pattern.match(templ).group(1)
            # print(filename)
            file_path = output_dir + filename
            with open(file_path, "w") as file:
                file.write(out_data)
            print(
                f'{colored("- [SUCCESS]:", "green")} A new file has been created'
                f'at "{file_path}"\n'
            )
        except Exception as err:
            print(err)


def main():
    jinja_templates = ["sshd_config.j2", "fail2ban.j2"]
    print(f"{colored('### RENDERING ALL THE TEMPLATES ###', 'red')}")
    render_yaml_template(jinja_templates, yaml_file="config.yaml")


if __name__ == "__main__":
    main()
