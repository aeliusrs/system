-------------------------------------------------------------------------------
# Age Keys

AGE (pronounce like hague) is a modern encryption tool sponsored by Mozilla

## init with age key

init a simple key
```bash
age-keygen -o key.txt
cat key.txt
```

## init from ssh key
to generate an age key from ssh key you can use the tool `ssh-to-age`
```bash
#first generate a ssh key using ed25519
ssh-keygen -t ed25519 -f id_sops

#generate the age public key
ssh-to-age -i ./id_sops.pub > id_age.pub

#generate the age private key
ssh-to-age --private-key -i ./id_sops > id_age
```

## encrypt/decrypt using ssh key

```bash
age -R ~/.ssh/id_rsa.pub /etc/hosts > /tmp/hosts.age
age -d -i ~/.ssh/id_rsa /tmp/hosts.age
```

-------------------------------------------------------------------------------

# SOPS

## to encrypt
```bash
export SOPS_AGE_RECIPIENTS=$(< id_age.pub)
sops --encrypt --age ${SOPS_AGE_RECIPIENTS} secret.yaml
```

## to decrypt
```bash
export SOPS_AGE_KEY=$(cat id_age)
# or specify the absolute path to a file
export SOPS_AGE_KEY_FILE="$(pwd)/id_age"
sops --decrypt --input-type yaml --output-type yaml secret.encrypted.yaml
```

## simplify with config 

```bash
# create a config file
cat <<EOF > .sops.yaml
---
creation_rules:
  - path_regex: '[^/]+\.(yaml|json|env|ini|txt)$'
    key_groups:
      - age:
         - age1kp4vtrs3atv0q7s5yspk446f9eh2gunhjc28mzxeyxaz8c9a6ghqfkr65g
EOF
```

then simply run the follwing to encrypt/decrypt:
```bash
sops -e secrets.yaml > secrets.encrypted.yaml
export SOPS_AGE_KEY=$(cat id_age)
sops -d secrets.encrypted.yaml
```
