{{=<% %>=}}
## Name of the node
-name ${NODENAME:-<% name %>}

## Cookie for distributed erlang
-setcookie <% name %>-cookie

## Include other generated VM options
-args_file releases/{{release_version}}/vm.generated.args
<%={{ }}=%>
