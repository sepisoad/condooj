##
## Auto Generated makefile by CodeLite IDE
## any manual changes will be erased      
##
## Debug
ProjectName            :=condooj
ConfigurationName      :=Debug
WorkspacePath          := "/home/sepisoad/Projects/git/condooj"
ProjectPath            := "/home/sepisoad/Projects/git/condooj"
IntermediateDirectory  :=./Debug
OutDir                 := $(IntermediateDirectory)
CurrentFileName        :=
CurrentFilePath        :=
CurrentFileFullPath    :=
User                   :=Sepehr Aryani
Date                   :=01/12/15
CodeLitePath           :="/home/sepisoad/.codelite"
LinkerName             :=/usr/bin/g++ 
SharedObjectLinkerName :=/usr/bin/g++ -shared -fPIC
ObjectSuffix           :=.o
DependSuffix           :=.o.d
PreprocessSuffix       :=.i
DebugSwitch            :=-g 
IncludeSwitch          :=-I
LibrarySwitch          :=-l
OutputSwitch           :=-o 
LibraryPathSwitch      :=-L
PreprocessorSwitch     :=-D
SourceSwitch           :=-c 
OutputFile             :=$(IntermediateDirectory)/$(ProjectName)
Preprocessors          :=$(PreprocessorSwitch)DEBUG $(PreprocessorSwitch)RUN_GUI_APP 
ObjectSwitch           :=-o 
ArchiveOutputSwitch    := 
PreprocessOnlySwitch   :=-E
ObjectsFileList        :="condooj.txt"
PCHCompileFlags        :=
MakeDirCommand         :=mkdir -p
LinkOptions            :=  
IncludePath            :=  $(IncludeSwitch). $(IncludeSwitch). 
IncludePCH             := 
RcIncludePath          := 
Libs                   := $(LibrarySwitch)oauth $(LibrarySwitch)curl $(LibrarySwitch)SDL2 
ArLibs                 :=  "oauth" "curl" "SDL2" 
LibPath                := $(LibraryPathSwitch). 

##
## Common variables
## AR, CXX, CC, AS, CXXFLAGS and CFLAGS can be overriden using an environment variables
##
AR       := /usr/bin/ar rcu
CXX      := /usr/bin/g++ 
CC       := /usr/bin/gcc 
CXXFLAGS :=  -g -O0 -Wall $(Preprocessors)
CFLAGS   :=  -g -O0 -Wall $(Preprocessors)
ASFLAGS  := 
AS       := /usr/bin/as 


##
## User defined environment variables
##
CodeLiteDir:=/usr/share/codelite
Objects0=$(IntermediateDirectory)/src_main.cc$(ObjectSuffix) $(IntermediateDirectory)/json_cJSON.cc$(ObjectSuffix) $(IntermediateDirectory)/dropbox_rest_utils.cc$(ObjectSuffix) $(IntermediateDirectory)/dropbox_dropbox.cc$(ObjectSuffix) $(IntermediateDirectory)/tests_tests.cc$(ObjectSuffix) $(IntermediateDirectory)/tests_test_runner.cc$(ObjectSuffix) $(IntermediateDirectory)/encryption_sha256.cc$(ObjectSuffix) $(IntermediateDirectory)/encryption_protection.cc$(ObjectSuffix) $(IntermediateDirectory)/encryption_aes.cc$(ObjectSuffix) $(IntermediateDirectory)/gui_gui_app.cc$(ObjectSuffix) \
	$(IntermediateDirectory)/cli_cli_app.cc$(ObjectSuffix) $(IntermediateDirectory)/app_app.cc$(ObjectSuffix) $(IntermediateDirectory)/config_config.cc$(ObjectSuffix) $(IntermediateDirectory)/user_user.cc$(ObjectSuffix) $(IntermediateDirectory)/utils_utils.cc$(ObjectSuffix) $(IntermediateDirectory)/imgui_imgui.cc$(ObjectSuffix) 



Objects=$(Objects0) 

##
## Main Build Targets 
##
.PHONY: all clean PreBuild PrePreBuild PostBuild
all: $(OutputFile)

$(OutputFile): $(IntermediateDirectory)/.d $(Objects) 
	@$(MakeDirCommand) $(@D)
	@echo "" > $(IntermediateDirectory)/.d
	@echo $(Objects0)  > $(ObjectsFileList)
	$(LinkerName) $(OutputSwitch)$(OutputFile) @$(ObjectsFileList) $(LibPath) $(Libs) $(LinkOptions)

$(IntermediateDirectory)/.d:
	@test -d ./Debug || $(MakeDirCommand) ./Debug

PreBuild:


##
## Objects
##
$(IntermediateDirectory)/src_main.cc$(ObjectSuffix): src/main.cc $(IntermediateDirectory)/src_main.cc$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "/home/sepisoad/Projects/git/condooj/src/main.cc" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/src_main.cc$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/src_main.cc$(DependSuffix): src/main.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/src_main.cc$(ObjectSuffix) -MF$(IntermediateDirectory)/src_main.cc$(DependSuffix) -MM "src/main.cc"

$(IntermediateDirectory)/src_main.cc$(PreprocessSuffix): src/main.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/src_main.cc$(PreprocessSuffix) "src/main.cc"

$(IntermediateDirectory)/json_cJSON.cc$(ObjectSuffix): src/json/cJSON.cc $(IntermediateDirectory)/json_cJSON.cc$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "/home/sepisoad/Projects/git/condooj/src/json/cJSON.cc" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/json_cJSON.cc$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/json_cJSON.cc$(DependSuffix): src/json/cJSON.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/json_cJSON.cc$(ObjectSuffix) -MF$(IntermediateDirectory)/json_cJSON.cc$(DependSuffix) -MM "src/json/cJSON.cc"

$(IntermediateDirectory)/json_cJSON.cc$(PreprocessSuffix): src/json/cJSON.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/json_cJSON.cc$(PreprocessSuffix) "src/json/cJSON.cc"

$(IntermediateDirectory)/dropbox_rest_utils.cc$(ObjectSuffix): src/dropbox/rest_utils.cc $(IntermediateDirectory)/dropbox_rest_utils.cc$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "/home/sepisoad/Projects/git/condooj/src/dropbox/rest_utils.cc" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/dropbox_rest_utils.cc$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/dropbox_rest_utils.cc$(DependSuffix): src/dropbox/rest_utils.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/dropbox_rest_utils.cc$(ObjectSuffix) -MF$(IntermediateDirectory)/dropbox_rest_utils.cc$(DependSuffix) -MM "src/dropbox/rest_utils.cc"

$(IntermediateDirectory)/dropbox_rest_utils.cc$(PreprocessSuffix): src/dropbox/rest_utils.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/dropbox_rest_utils.cc$(PreprocessSuffix) "src/dropbox/rest_utils.cc"

$(IntermediateDirectory)/dropbox_dropbox.cc$(ObjectSuffix): src/dropbox/dropbox.cc $(IntermediateDirectory)/dropbox_dropbox.cc$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "/home/sepisoad/Projects/git/condooj/src/dropbox/dropbox.cc" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/dropbox_dropbox.cc$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/dropbox_dropbox.cc$(DependSuffix): src/dropbox/dropbox.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/dropbox_dropbox.cc$(ObjectSuffix) -MF$(IntermediateDirectory)/dropbox_dropbox.cc$(DependSuffix) -MM "src/dropbox/dropbox.cc"

$(IntermediateDirectory)/dropbox_dropbox.cc$(PreprocessSuffix): src/dropbox/dropbox.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/dropbox_dropbox.cc$(PreprocessSuffix) "src/dropbox/dropbox.cc"

$(IntermediateDirectory)/tests_tests.cc$(ObjectSuffix): src/tests/tests.cc $(IntermediateDirectory)/tests_tests.cc$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "/home/sepisoad/Projects/git/condooj/src/tests/tests.cc" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/tests_tests.cc$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/tests_tests.cc$(DependSuffix): src/tests/tests.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/tests_tests.cc$(ObjectSuffix) -MF$(IntermediateDirectory)/tests_tests.cc$(DependSuffix) -MM "src/tests/tests.cc"

$(IntermediateDirectory)/tests_tests.cc$(PreprocessSuffix): src/tests/tests.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/tests_tests.cc$(PreprocessSuffix) "src/tests/tests.cc"

$(IntermediateDirectory)/tests_test_runner.cc$(ObjectSuffix): src/tests/test_runner.cc $(IntermediateDirectory)/tests_test_runner.cc$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "/home/sepisoad/Projects/git/condooj/src/tests/test_runner.cc" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/tests_test_runner.cc$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/tests_test_runner.cc$(DependSuffix): src/tests/test_runner.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/tests_test_runner.cc$(ObjectSuffix) -MF$(IntermediateDirectory)/tests_test_runner.cc$(DependSuffix) -MM "src/tests/test_runner.cc"

$(IntermediateDirectory)/tests_test_runner.cc$(PreprocessSuffix): src/tests/test_runner.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/tests_test_runner.cc$(PreprocessSuffix) "src/tests/test_runner.cc"

$(IntermediateDirectory)/encryption_sha256.cc$(ObjectSuffix): src/encryption/sha256.cc $(IntermediateDirectory)/encryption_sha256.cc$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "/home/sepisoad/Projects/git/condooj/src/encryption/sha256.cc" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/encryption_sha256.cc$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/encryption_sha256.cc$(DependSuffix): src/encryption/sha256.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/encryption_sha256.cc$(ObjectSuffix) -MF$(IntermediateDirectory)/encryption_sha256.cc$(DependSuffix) -MM "src/encryption/sha256.cc"

$(IntermediateDirectory)/encryption_sha256.cc$(PreprocessSuffix): src/encryption/sha256.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/encryption_sha256.cc$(PreprocessSuffix) "src/encryption/sha256.cc"

$(IntermediateDirectory)/encryption_protection.cc$(ObjectSuffix): src/encryption/protection.cc $(IntermediateDirectory)/encryption_protection.cc$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "/home/sepisoad/Projects/git/condooj/src/encryption/protection.cc" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/encryption_protection.cc$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/encryption_protection.cc$(DependSuffix): src/encryption/protection.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/encryption_protection.cc$(ObjectSuffix) -MF$(IntermediateDirectory)/encryption_protection.cc$(DependSuffix) -MM "src/encryption/protection.cc"

$(IntermediateDirectory)/encryption_protection.cc$(PreprocessSuffix): src/encryption/protection.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/encryption_protection.cc$(PreprocessSuffix) "src/encryption/protection.cc"

$(IntermediateDirectory)/encryption_aes.cc$(ObjectSuffix): src/encryption/aes.cc $(IntermediateDirectory)/encryption_aes.cc$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "/home/sepisoad/Projects/git/condooj/src/encryption/aes.cc" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/encryption_aes.cc$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/encryption_aes.cc$(DependSuffix): src/encryption/aes.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/encryption_aes.cc$(ObjectSuffix) -MF$(IntermediateDirectory)/encryption_aes.cc$(DependSuffix) -MM "src/encryption/aes.cc"

$(IntermediateDirectory)/encryption_aes.cc$(PreprocessSuffix): src/encryption/aes.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/encryption_aes.cc$(PreprocessSuffix) "src/encryption/aes.cc"

$(IntermediateDirectory)/gui_gui_app.cc$(ObjectSuffix): src/gui/gui_app.cc $(IntermediateDirectory)/gui_gui_app.cc$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "/home/sepisoad/Projects/git/condooj/src/gui/gui_app.cc" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/gui_gui_app.cc$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/gui_gui_app.cc$(DependSuffix): src/gui/gui_app.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/gui_gui_app.cc$(ObjectSuffix) -MF$(IntermediateDirectory)/gui_gui_app.cc$(DependSuffix) -MM "src/gui/gui_app.cc"

$(IntermediateDirectory)/gui_gui_app.cc$(PreprocessSuffix): src/gui/gui_app.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/gui_gui_app.cc$(PreprocessSuffix) "src/gui/gui_app.cc"

$(IntermediateDirectory)/cli_cli_app.cc$(ObjectSuffix): src/cli/cli_app.cc $(IntermediateDirectory)/cli_cli_app.cc$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "/home/sepisoad/Projects/git/condooj/src/cli/cli_app.cc" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/cli_cli_app.cc$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/cli_cli_app.cc$(DependSuffix): src/cli/cli_app.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/cli_cli_app.cc$(ObjectSuffix) -MF$(IntermediateDirectory)/cli_cli_app.cc$(DependSuffix) -MM "src/cli/cli_app.cc"

$(IntermediateDirectory)/cli_cli_app.cc$(PreprocessSuffix): src/cli/cli_app.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/cli_cli_app.cc$(PreprocessSuffix) "src/cli/cli_app.cc"

$(IntermediateDirectory)/app_app.cc$(ObjectSuffix): src/app/app.cc $(IntermediateDirectory)/app_app.cc$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "/home/sepisoad/Projects/git/condooj/src/app/app.cc" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/app_app.cc$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/app_app.cc$(DependSuffix): src/app/app.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/app_app.cc$(ObjectSuffix) -MF$(IntermediateDirectory)/app_app.cc$(DependSuffix) -MM "src/app/app.cc"

$(IntermediateDirectory)/app_app.cc$(PreprocessSuffix): src/app/app.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/app_app.cc$(PreprocessSuffix) "src/app/app.cc"

$(IntermediateDirectory)/config_config.cc$(ObjectSuffix): src/config/config.cc $(IntermediateDirectory)/config_config.cc$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "/home/sepisoad/Projects/git/condooj/src/config/config.cc" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/config_config.cc$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/config_config.cc$(DependSuffix): src/config/config.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/config_config.cc$(ObjectSuffix) -MF$(IntermediateDirectory)/config_config.cc$(DependSuffix) -MM "src/config/config.cc"

$(IntermediateDirectory)/config_config.cc$(PreprocessSuffix): src/config/config.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/config_config.cc$(PreprocessSuffix) "src/config/config.cc"

$(IntermediateDirectory)/user_user.cc$(ObjectSuffix): src/user/user.cc $(IntermediateDirectory)/user_user.cc$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "/home/sepisoad/Projects/git/condooj/src/user/user.cc" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/user_user.cc$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/user_user.cc$(DependSuffix): src/user/user.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/user_user.cc$(ObjectSuffix) -MF$(IntermediateDirectory)/user_user.cc$(DependSuffix) -MM "src/user/user.cc"

$(IntermediateDirectory)/user_user.cc$(PreprocessSuffix): src/user/user.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/user_user.cc$(PreprocessSuffix) "src/user/user.cc"

$(IntermediateDirectory)/utils_utils.cc$(ObjectSuffix): src/utils/utils.cc $(IntermediateDirectory)/utils_utils.cc$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "/home/sepisoad/Projects/git/condooj/src/utils/utils.cc" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/utils_utils.cc$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/utils_utils.cc$(DependSuffix): src/utils/utils.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/utils_utils.cc$(ObjectSuffix) -MF$(IntermediateDirectory)/utils_utils.cc$(DependSuffix) -MM "src/utils/utils.cc"

$(IntermediateDirectory)/utils_utils.cc$(PreprocessSuffix): src/utils/utils.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/utils_utils.cc$(PreprocessSuffix) "src/utils/utils.cc"

$(IntermediateDirectory)/imgui_imgui.cc$(ObjectSuffix): src/imgui/imgui.cc $(IntermediateDirectory)/imgui_imgui.cc$(DependSuffix)
	$(CXX) $(IncludePCH) $(SourceSwitch) "/home/sepisoad/Projects/git/condooj/src/imgui/imgui.cc" $(CXXFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/imgui_imgui.cc$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/imgui_imgui.cc$(DependSuffix): src/imgui/imgui.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/imgui_imgui.cc$(ObjectSuffix) -MF$(IntermediateDirectory)/imgui_imgui.cc$(DependSuffix) -MM "src/imgui/imgui.cc"

$(IntermediateDirectory)/imgui_imgui.cc$(PreprocessSuffix): src/imgui/imgui.cc
	@$(CXX) $(CXXFLAGS) $(IncludePCH) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/imgui_imgui.cc$(PreprocessSuffix) "src/imgui/imgui.cc"


-include $(IntermediateDirectory)/*$(DependSuffix)
##
## Clean
##
clean:
	$(RM) ./Debug/*$(ObjectSuffix)
	$(RM) ./Debug/*$(DependSuffix)
	$(RM) $(OutputFile)
	$(RM) ".build-debug/condooj"


