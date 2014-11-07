.PHONY: clean up

up:
	vagrant up --no-provision
	vagrant sandbox on
	vagrant provision

rebuild:
	vagrant sandbox rollback
	$(MAKE) up
