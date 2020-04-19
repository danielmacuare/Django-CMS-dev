#!/usr/bin/env python3
import re
import yaml
from jinja2 import Environment, FileSystemLoader, PackageLoader

# Docs: https://jinja.palletsprojects.com/en/2.11.x/api/#basics

# Functions
def render_yaml_template(jinja_templates, yaml_file, output_dir="files/"):
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
            data = yaml.safe_load(file)
        except yaml.YAMLError as err:
            print(err)
    # print(data)

    env = Environment(
        loader=FileSystemLoader(searchpath="./templates"),
        trim_blocks=True,
        lstrip_blocks=True,
    )
    for templ in jinja_templates:
        try:
            template = env.get_template(name=templ)
            out_data = template.render(data)
            # print(out_data)
            pattern = re.compile(f"(.*).j2")
            filename = pattern.match(templ).group(1)
            # print(filename)
            file_path = output_dir + filename
            with open(file_path, "w") as file:
                file.write(out_data)
        except Exception as err:
            print(err)


def main():
    jinja_templates = ["sshd_config.j2", "fail2ban.j2"]
    render_yaml_template(jinja_templates, yaml_file="config.yaml")


if __name__ == "__main__":
    main()
