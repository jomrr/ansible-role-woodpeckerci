# role: ansible-role-woocpeckerci
# file: Makefile

# Makefile for role management and testing

.PHONY: check
check:
	@pre-commit run --all-files

.PHONY: checkout-dev
checkout-dev:
	@git checkout dev

.PHONY: clean
clean:
	@rm -rf .tox/

.PHONY: converge
converge:
	@molecule converge

.PHONY: destroy
destroy:
	@molecule destroy

.PHONY: merge-feature-to-dev
merge-feature-to-dev: check
	@git checkout dev
	@git merge $(FEATURE)
	@git branch -d $(FEATURE)

.PHONY: prepare-release
prepare-release: clean check
	@git push origin dev
	@git checkout main
	@git merge dev
	@git push origin main
	@git checkout dev

.PHONY: start-feature
start-feature:
	@git checkout -b $(FEATURE) dev

.PHONY: test
test:
	@molecule test

.PHONY: tox
tox:
	@tox -v run-parallel
