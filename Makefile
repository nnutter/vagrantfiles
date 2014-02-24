.PHONY: clean up

up:
	librarian-puppet install
	vagrant up --no-provision
	vagrant sandbox on
	vagrant provision

rebuild:
	vagrant sandbox rollback
	$(MAKE) up
