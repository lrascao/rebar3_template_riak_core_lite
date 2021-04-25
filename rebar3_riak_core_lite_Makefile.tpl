BASEDIR = $(shell pwd)
REBAR = rebar3
RELPATH = _build/default/rel/{{ name }}
PRODRELPATH = _build/prod/rel/{{ name }}
DEV1RELPATH = _build/dev1/rel/{{ name }}
DEV2RELPATH = _build/dev2/rel/{{ name }}
DEV3RELPATH = _build/dev3/rel/{{ name }}
APPNAME = {{ name }}
SHELL = /bin/bash

release:
	$(REBAR) release

console:
	cd $(RELPATH) && ./bin/{{ name }} console

prod-release:
	$(REBAR) as prod release

prod-console:
	cd $(PRODRELPATH) && ./bin/{{ name }} console

compile:
	$(REBAR) compile

clean:
	$(REBAR) clean

test:
	$(REBAR) ct

devrel1:
	$(REBAR) as dev1 release

devrel2:
	$(REBAR) as dev2 release

devrel3:
	$(REBAR) as dev3 release

devrel: devrel1 devrel2 devrel3

dev1-attach:
	NODENAME=tanodb1 $(BASEDIR)/_build/dev1/rel/{{ name }}/bin/$(APPNAME) attach

dev2-attach:
	NODENAME=tanodb2 $(BASEDIR)/_build/dev2/rel/{{ name }}/bin/$(APPNAME) attach

dev3-attach:
	NODENAME=tanodb3 $(BASEDIR)/_build/dev3/rel/{{ name }}/bin/$(APPNAME) attach

dev1-console:
	NODENAME=tanodb1 $(BASEDIR)/_build/dev1/rel/{{ name }}/bin/$(APPNAME) console

dev2-console:
	NODENAME=tanodb2 $(BASEDIR)/_build/dev2/rel/{{ name }}/bin/$(APPNAME) console

dev3-console:
	NODENAME=tanodb3 $(BASEDIR)/_build/dev3/rel/{{ name }}/bin/$(APPNAME) console

devrel-clean:
	rm -rf _build/dev*/rel

devrel-start:
	i=1 for d in $(BASEDIR)/_build/dev*; do $$d/rel/{{ name }}/bin/$(APPNAME) start; done

devrel-join:
	for d in $(BASEDIR)/_build/dev{2,3}; do $$d/rel/{{ name }}/bin/$(APPNAME) eval 'riak_core:join("{{ name }}1@127.0.0.1")'; done

devrel-cluster-plan:
	$(BASEDIR)/_build/dev1/rel/{{ name }}/bin/$(APPNAME) eval 'riak_core_claimant:plan()'

devrel-cluster-commit:
	$(BASEDIR)/_build/dev1/rel/{{ name }}/bin/$(APPNAME) eval 'riak_core_claimant:commit()'

devrel-status:
	$(BASEDIR)/_build/dev1/rel/{{ name }}/bin/$(APPNAME) eval 'riak_core_console:member_status([])'

devrel-ping:
	for d in $(BASEDIR)/_build/dev*; do $$d/rel/{{ name }}/bin/$(APPNAME) ping; true; done

devrel-stop:
	for d in $(BASEDIR)/_build/dev*; do $$d/rel/{{ name }}/bin/$(APPNAME) stop; true; done

start:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) start

stop:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) stop

attach:
	$(BASEDIR)/$(RELPATH)/bin/$(APPNAME) attach

