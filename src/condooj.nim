when defined(RUN_AS_APP):
  import cli
  if false == cli.run():
    echo("Error: failed to start app")
else: #defined(RUN_AS_SERVICE)
  import service
  if false == service.run():
    echo("Error: failed to start service")