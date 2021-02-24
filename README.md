# DJANGO-CMS (DEV ENV)
To play with a dev env, the idea is to build it automatically using an Infra-as-a-code approach.

 For this repo I wanted to use go to one place to configure the server. Following this principle, the main place to edit the server config will be the shared/exports file. 


## Usage
- Pre-generate your `USER_ADM` Password hash
`mkpasswd -m sha-512`. This utility comes with `whois` so you might want to `apt install whois`.
- Copy the output to the `USER_PASS` variable at `provisioning.sh`. 
- Put the public key you want to login with on the `./files/` folder. The name of the key must match the username defined on the `USER_ADM` at `provisioning.sh`.
- Put all your Jinja templates at the `./templates/` folder



## Variables description

