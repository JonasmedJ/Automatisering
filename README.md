# Automatisering
Automatisering af diverse systemer

## Setup
This repository uses Ansible collections (e.g. `community.crypto`) and
roles.  Before running any playbooks make sure to install the
requirements:

```sh
ansible-galaxy collection install -r ansible/requirements.yml
# (future roles could also be added to requirements.yml)
```

The `ansible/roles/nginx` role previously declared `community.crypto` as
a role dependency; this is incorrect because it's a **collection**.  The
metadata now includes it under `collections:` so you won't see errors
like:

```
role 'community.crypto' was not found in ansible.legacy:...
```

The fix ensures the collection is pulled in automatically.
