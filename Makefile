PRIVATE_ENC_FILEPATH ?= private.json.gpg
PRIVATE_UNENC_FILEPATH ?= private.json
PUBLIC_FILEPATH ?= public.json

encrypt-private: $(PRIVATE_UNENC_FILEPATH)
	gpg --quiet --batch --yes --symmetric --passphrase=$(GPG_PASSPHRASE) --output $(PRIVATE_ENC_FILEPATH) $(PRIVATE_UNENC_FILEPATH)

decrypt-private: $(PRIVATE_ENC_FILEPATH)
	gpg --quiet --batch --yes --decrypt --passphrase="$(GPG_PASSPHRASE)" --output $(PRIVATE_UNENC_FILEPATH) $(PRIVATE_ENC_FILEPATH)

git-config:
	git config --global user.email "kumurabot@fossassam.tech"
	git config --global user.name "kumura-bot"

git-add-public: git-config
	git add $(PUBLIC_FILEPATH)

git-add-private: git-config
	git add $(PRIVATE_ENC_FILEPATH)

jq-add-record-private: $(PRIVATE_UNENC_FILEPATH)
	jq -c '. + [{"user": env.USERNAME,"email": env.EMAIL}]' < $(PRIVATE_UNENC_FILEPATH) > $(PRIVATE_UNENC_FILEPATH).tmp
	mv $(PRIVATE_UNENC_FILEPATH).tmp $(PRIVATE_UNENC_FILEPATH)

jq-add-record-public: $(PUBLIC_FILEPATH)
	jq -c '. + [env.USERNAME]' < $(PUBLIC_FILEPATH) > $(PUBLIC_FILEPATH).tmp
	mv $(PUBLIC_FILEPATH).tmp $(PUBLIC_FILEPATH)

clean:
	rm -rf private.json tags

.PHONY: git-config git-add-public git-add-private jq-add-record-public jq-add-record-private
