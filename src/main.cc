#include "cli/cli_app.hh"
#include "gui/gui_app.hh"
#include "tests/tests.hh"

int main(int argc, char **argv)
{
#ifdef RUN_GUI_APP
	start_gui_app();
#elif RUN_CLI_APP
	start_cli_app();
#else
	run_all_tests();
#endif
	return 0;
}