##
## Auto Generated makefile by CodeLite IDE
## any manual changes will be erased      
##
## Debug
ProjectName            :=condooj
ConfigurationName      :=Debug
WorkspacePath          := "/home/sepisoad/Projects/github/condooj"
ProjectPath            := "/home/sepisoad/Projects/github/condooj"
IntermediateDirectory  :=./Debug
OutDir                 := $(IntermediateDirectory)
CurrentFileName        :=
CurrentFilePath        :=
CurrentFileFullPath    :=
User                   :=Sepehr Aryani
Date                   :=09/17/14
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
Preprocessors          :=
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
Libs                   := $(LibrarySwitch)oauth $(LibrarySwitch)curl 
ArLibs                 :=  "oauth" "curl" 
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
Objects0=$(IntermediateDirectory)/src_main.c$(ObjectSuffix) $(IntermediateDirectory)/json_cJSON.c$(ObjectSuffix) $(IntermediateDirectory)/dropbox_rest_utils.c$(ObjectSuffix) $(IntermediateDirectory)/dropbox_dropbox.c$(ObjectSuffix) 



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
$(IntermediateDirectory)/src_main.c$(ObjectSuffix): src/main.c $(IntermediateDirectory)/src_main.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/home/sepisoad/Projects/github/condooj/src/main.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/src_main.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/src_main.c$(DependSuffix): src/main.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/src_main.c$(ObjectSuffix) -MF$(IntermediateDirectory)/src_main.c$(DependSuffix) -MM "src/main.c"

$(IntermediateDirectory)/src_main.c$(PreprocessSuffix): src/main.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/src_main.c$(PreprocessSuffix) "src/main.c"

$(IntermediateDirectory)/json_cJSON.c$(ObjectSuffix): src/json/cJSON.c $(IntermediateDirectory)/json_cJSON.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/home/sepisoad/Projects/github/condooj/src/json/cJSON.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/json_cJSON.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/json_cJSON.c$(DependSuffix): src/json/cJSON.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/json_cJSON.c$(ObjectSuffix) -MF$(IntermediateDirectory)/json_cJSON.c$(DependSuffix) -MM "src/json/cJSON.c"

$(IntermediateDirectory)/json_cJSON.c$(PreprocessSuffix): src/json/cJSON.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/json_cJSON.c$(PreprocessSuffix) "src/json/cJSON.c"

$(IntermediateDirectory)/dropbox_rest_utils.c$(ObjectSuffix): src/dropbox/rest_utils.c $(IntermediateDirectory)/dropbox_rest_utils.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/home/sepisoad/Projects/github/condooj/src/dropbox/rest_utils.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/dropbox_rest_utils.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/dropbox_rest_utils.c$(DependSuffix): src/dropbox/rest_utils.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/dropbox_rest_utils.c$(ObjectSuffix) -MF$(IntermediateDirectory)/dropbox_rest_utils.c$(DependSuffix) -MM "src/dropbox/rest_utils.c"

$(IntermediateDirectory)/dropbox_rest_utils.c$(PreprocessSuffix): src/dropbox/rest_utils.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/dropbox_rest_utils.c$(PreprocessSuffix) "src/dropbox/rest_utils.c"

$(IntermediateDirectory)/dropbox_dropbox.c$(ObjectSuffix): src/dropbox/dropbox.c $(IntermediateDirectory)/dropbox_dropbox.c$(DependSuffix)
	$(CC) $(SourceSwitch) "/home/sepisoad/Projects/github/condooj/src/dropbox/dropbox.c" $(CFLAGS) $(ObjectSwitch)$(IntermediateDirectory)/dropbox_dropbox.c$(ObjectSuffix) $(IncludePath)
$(IntermediateDirectory)/dropbox_dropbox.c$(DependSuffix): src/dropbox/dropbox.c
	@$(CC) $(CFLAGS) $(IncludePath) -MG -MP -MT$(IntermediateDirectory)/dropbox_dropbox.c$(ObjectSuffix) -MF$(IntermediateDirectory)/dropbox_dropbox.c$(DependSuffix) -MM "src/dropbox/dropbox.c"

$(IntermediateDirectory)/dropbox_dropbox.c$(PreprocessSuffix): src/dropbox/dropbox.c
	@$(CC) $(CFLAGS) $(IncludePath) $(PreprocessOnlySwitch) $(OutputSwitch) $(IntermediateDirectory)/dropbox_dropbox.c$(PreprocessSuffix) "src/dropbox/dropbox.c"


-include $(IntermediateDirectory)/*$(DependSuffix)
##
## Clean
##
clean:
	$(RM) ./Debug/*$(ObjectSuffix)
	$(RM) ./Debug/*$(DependSuffix)
	$(RM) $(OutputFile)
	$(RM) ".build-debug/condooj"


