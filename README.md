### Requirements
- gpg

### Environment variables
```
export ENC_FILEPATH=private.json.gpg
export UNENC_FILEPATH=private.json
export GPG_PASSPHRASE=<the_passphrase>
```

### Encrypt
```
gpg --quiet --batch --yes --output $ENC_FILEPATH --symmetric --cipher-algo AES256 --passphrase=$GPG_PASSPHRASE $UNENC_FILEPATH
```

### Decrypt
```
gpg --quiet --batch --yes --decrypt --passphrase="$GPG_PASSPHRASE" --output $UNENC_FILEPATH $ENC_FILEPATH
```
