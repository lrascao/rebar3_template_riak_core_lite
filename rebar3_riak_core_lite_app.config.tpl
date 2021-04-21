{{=<% %>=}}
%% -*- mode: erlang; -*-
[
 { <% name %>, []},
  %% logger config
  {kernel, [

    % logger formatters
    {logger, [
      {handler, default, logger_std_h,
        #{level => info,
          formatter => {logger_formatter, #{single_line => false, max_size => 2048}},
          config => #{type => standard_io}}}
    ]},

    % main level
    {logger_level, info}
  ]},

  "releases/{{release_version}}/config/generated/riak_core.config"
].
<%={{ }}=%>
