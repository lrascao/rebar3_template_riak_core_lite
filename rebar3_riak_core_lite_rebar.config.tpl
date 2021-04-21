{{=<% %>=}}
%% -*- mode: erlang; -*-
{deps, [
    {riak_core,
        {git, "https://github.com/lrascao/riak_core_lite",
            {branch, "feature/cuttlefish_schema"}}},
    %{riak_core, {pkg, riak_core_lite}},
    riak_core_lite_util
]}.

% this informs rebar3 that the rebar3_scuttler plugin will take over
% the release generation process, this is necessary so that it is able
% to inject the cuttlefish invocation to the pre-start release hook
{project_plugins, [
    {rebar3_scuttler,
        {git, "https://github.com/lrascao/rebar3_scuttler",
            {branch, "develop"}}}
]}.

{relx, [{release, { <% name %> , "0.1.0"},
         [<% name %>, sasl]},

        {dev_mode, true},
        {include_erts, false},
        {extended_start_script, true},

        {overlay, [
            {mkdir, "etc"},
            % this dir will contain the cuttlefish pre-start hook
            {mkdir, "bin/hooks"},
            {mkdir, "data/ring"},
            {mkdir, "log/sasl"},
            {template, "config/app.config",
                "releases/{{release_version}}/sys.config"},
            {template, "config/vm.args.src",
                "releases/{{release_version}}/vm.args.src"}
        ]},

        % start script hooks
        {extended_start_script_hooks, [
            {pre_start, [
              % besides our own pre start script, we're here adding
              % the one that was generated out of rebar3_scuttler,
              % this script will pick up any .schema file in share/schema
              % and generate a same named .config file in `output_dir`
              %
              % notice that the name here matches the one we defined above in
              % scuttler.pre_start_hook, it's just missing the `bin` prefix because
              % start script hooks are relative to the extended start script location.
              {custom, "hooks/pre_start_cuttlefish"}
            ]}
        ]}
]}.

% scuttler plugin opts
{scuttler, [
    % this is the human readable .conf file that the users of your application
    % will understand and edit in order to change configuration parameters,
    % it's location is relative to the root dir of the release
    % (ie. alongside bin, releases, etc)
    {conf_file, "etc/<% name %>.conf"},

    {schemas, [
           {vm_args, "releases/{{release_version}}/vm.generated.args"},
           {"{{deps_dir}}/riak_core/priv", "releases/{{release_version}}/schema/riak_core",
                "releases/{{release_version}}/config/generated/riak_core.config"}
    ]},
    % Specifies where you'd like rebar3_scuttler to generate
    % the pre start hook to. This is intended to be then added
    % to the extended_start_script_hooks/pre_start relx entry list
    % for it to be invoked prior to the release start
    % This script will take care of processing `.schema` and `.conf`
    % files in order to output `.config` files that you will be able
    % to include from your own.
    {pre_start_hook, "bin/hooks/pre_start_cuttlefish"}
]}.

{profiles, [
    {prod, [
        {relx, [
            {dev_mode, false},
            {include_erts, true}
        ]}
    ]},
    {dev1, [
        {relx, [
            {overlay, [
                {template, "config/dev1.conf",
                    "etc/<% name %>.conf"}
            ]}
        ]}
    ]},
    {dev2, [
        {relx, [
            {overlay, [
                {template, "config/dev2.conf",
                    "etc/<% name %>.conf"}
            ]}
        ]}
    ]},
    {dev3, [
        {relx, [
            {overlay, [
                {template, "config/dev3.conf",
                    "etc/<% name %>.conf"}
            ]}
        ]}
    ]}
]}.
<%={{ }}=%>
