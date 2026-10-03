local LWSoundTemplateManager = BaseClass("LWSoundTemplateManager")
local LWSoundTemplate = require("DataCenter.LWSound.LWSoundTemplate")
local LWAudioMixerGroupTemplate = require("DataCenter.LWSound.LWAudioMixerGroupTemplate")
local LWSoundMaxInstancesTemplate = require("DataCenter.LWSound.LWSoundMaxInstancesTemplate")
local LWSoundServerTemplate = require("DataCenter.LWSound.LWSoundServerTemplate")
local NoTemplate = "NoTemplate"

local function __init(self)
  self.templateDict = {}
  self.groupInited = false
  self.groupTemplateDict = {}
  self.instanceTemplateDict = {}
  self.soundServerInited = false
  self.soundServerDict = {}
  self.parsed_server_ranges = {}
end

local function __delete(self)
  self.templateDict = nil
  self.groupTemplateDict = nil
  self.groupInited = nil
  self.instanceTemplateDict = nil
  self.soundServerInited = nil
  self.soundServerDict = nil
  self.parsed_server_ranges = nil
end

local function GetTemplate(self, soundId)
  local id = soundId
  local idByServer, isContinue = self:GetSoundServerId(soundId)
  if not isContinue and not idByServer then
    return
  end
  if idByServer then
    id = idByServer
  end
  id = tonumber(id)
  if id == nil then
    return nil
  end
  if self.templateDict[id] == NoTemplate then
    return nil
  end
  if self.templateDict[id] ~= nil then
    return self.templateDict[id]
  end
  local line = LocalController:instance():getLine(TableName.LW_Sound, id)
  if line ~= nil then
    local template = LWSoundTemplate.New()
    template:InitData(line)
    self.templateDict[id] = template
    return template
  else
    self.templateDict[id] = NoTemplate
    return nil
  end
end

local function LoadGroupTemplates(self)
  self.groupInited = true
  LocalController:instance():visitTable(TableName.LW_Sound_AudioMixer_Group, function(_, lineData)
    local template = LWAudioMixerGroupTemplate.New()
    template:InitData(lineData)
    self.groupTemplateDict[template.group] = template
  end)
end

local function GetGroupTempByName(self, name)
  if not self.groupInited then
    self:LoadGroupTemplates()
  end
  if self.groupTemplateDict[name] ~= nil then
    return self.groupTemplateDict[name]
  end
end

local function GetGroupTemplates(self)
  if not self.groupInited then
    self:LoadGroupTemplates()
  end
  return self.groupTemplateDict
end

local function GetSoundMaxInstancesTemp(self, id)
  id = tonumber(id)
  if id == nil then
    return nil
  end
  if self.instanceTemplateDict[id] == NoTemplate then
    return nil
  end
  if self.instanceTemplateDict[id] ~= nil then
    return self.instanceTemplateDict[id]
  end
  local line = LocalController:instance():getLine(TableName.LW_Sound_Max_Instances, id)
  if line ~= nil then
    local template = LWSoundMaxInstancesTemplate.New()
    template:InitData(line)
    self.instanceTemplateDict[id] = template
    return template
  else
    self.instanceTemplateDict[id] = NoTemplate
    return nil
  end
end

function LWSoundTemplateManager:LoadSoundServerTemplates()
  self.soundServerInited = true
  LocalController:instance():visitTable(TableName.LW_Sound_Server, function(_, lineData)
    local template = LWSoundServerTemplate.New()
    template:InitData(lineData)
    self.soundServerDict[template.id] = template
  end)
end

function LWSoundTemplateManager:GetSoundServerId(id)
  if not self.soundServerInited then
    self:LoadSoundServerTemplates()
  end
  local templates = self.soundServerDict[id]
  if not templates then
    return nil, true
  end
  local soundId, isContinue = templates:GetSoundId()
  return soundId, isContinue
end

function LWSoundTemplateManager:GetCacheServerRange(index)
  if not self.parsed_server_ranges then
    self.parsed_server_ranges = {}
  end
  if self.parsed_server_ranges[index] then
    return self.parsed_server_ranges[index]
  end
  local serverArrayStr = LuaEntry.DataConfig:TryGetStr("sound_server", "k" .. index)
  if string.IsNullOrEmpty(serverArrayStr) then
    self.parsed_server_ranges[index] = {}
    return {}
  end
  local configs = string.split(serverArrayStr, "|")
  local parsedRanges = {}
  for _, config in ipairs(configs) do
    local list = string.split(config, "-")
    if #list == 1 then
      local serverId = tonumber(list[1])
      if serverId then
        table.insert(parsedRanges, {startServer = serverId, endServer = serverId})
      end
    elseif #list == 2 then
      local startServer = tonumber(list[1])
      local endServer = tonumber(list[2])
      if startServer and endServer then
        table.insert(parsedRanges, {startServer = startServer, endServer = endServer})
      end
    end
  end
  self.parsed_server_ranges[index] = parsedRanges
  return parsedRanges
end

LWSoundTemplateManager.__init = __init
LWSoundTemplateManager.__delete = __delete
LWSoundTemplateManager.LoadGroupTemplates = LoadGroupTemplates
LWSoundTemplateManager.GetTemplate = GetTemplate
LWSoundTemplateManager.GetGroupTempByName = GetGroupTempByName
LWSoundTemplateManager.GetGroupTemplates = GetGroupTemplates
LWSoundTemplateManager.GetSoundMaxInstancesTemp = GetSoundMaxInstancesTemp
return LWSoundTemplateManager
