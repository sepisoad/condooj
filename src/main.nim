when defined EXECUTE_CLI:
  import cli
  discard cli.run()

else:
  import test
  test.run()