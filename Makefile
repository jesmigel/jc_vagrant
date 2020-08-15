.PHONY: validate up down status clean

include makefile.env

_ENV=sample

validate:
	$(call vagrant_func,VAGRANT VALIDATE,validate)

up: 
	$(call vagrant_func,VAGRANT UP,up)

down:
	$(call vagrant_func,VAGRANT DOWN,halt)

status:
	$(call vagrant_func,VAGRANT STATUS,status)

clean:
	$(call vagrant_func,VAGRANT CLEAN,destroy,--force)
	rm -rf .vagrant

# VAGRANT FUNCTION
# 	$(1): Header
# 	$(2): Option
# 	$(3): Option Parameters
define vagrant_func
	@echo "$(1): [vagrant $(2)] $(3)"
	@echo "config: $(_CFG_FILE)"
	export _VAGRANT_CFG=$(_CFG_FILE) && vagrant $(2) $(3)
endef