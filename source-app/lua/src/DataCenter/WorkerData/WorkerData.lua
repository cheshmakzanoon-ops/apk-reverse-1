local WorkerData = BaseClass("WorkerData")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.uid = nil
  self.firstName = nil
  self.lastName = nil
  self.modelId = nil
  self.wordIds = nil
  self.quality = nil
  self.status = nil
  self.effectDict = {}
  self.wellBuildUuid = nil
  self.dispatchingBuildUid = nil
  self.workingBuildList = nil
  self.state = WorkerState.RESIDENTA
  self.workingBuildMap = {}
  self.isUIPlaneShow = 1
  self.star = 0
  self.rank = 1
  self.cfgId = 0
  self._source = nil
end

local function __delete(self)
  self.uid = nil
  self.firstName = nil
  self.lastName = nil
  self.modelId = nil
  self.wordIds = nil
  self.quality = nil
  self.status = nil
  self.effectDict = nil
  self.wellBuildUuid = nil
  self.dispatchingBuildUid = nil
  self.workingBuildList = nil
  self.state = nil
  self.workingBuildMap = nil
  self.isUIPlaneShow = nil
  self.star = nil
  self.rank = nil
  self.rankPower = nil
  self._source = nil
end

local function UpdateInfo(self, message)
  if not message then
    return
  end
  if message.uid then
    self.uid = message.uid
  end
  if message.firstName then
    self.firstName = message.firstName
  end
  if message.lastName then
    self.lastName = message.lastName
  end
  if message.model then
    self.modelId = message.model
    local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(self.modelId)
    self.appearCfg = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId)
    if not self.appearCfg and message.cfgId then
      Logger.LogError("worker\229\164\150\232\167\130\230\137\190\228\184\141\229\136\176,configId\239\188\154" .. message.cfgId)
    end
  end
  if message.wordIds then
    self.wordIds = message.wordIds
  end
  if message.quality then
    self.quality = tonumber(message.quality)
  end
  if message.source then
    self._source = message.source
  end
  if message.clientState then
    if self._source == "BATTLE_PVE_TRIGGER" and message.clientState == 0 then
      Logger.LogInfo("[WorkersSource_BATTLE_PVE_TRIGGER]")
      DataCenter.GainWorkerManager:AddPveWorker(self)
    elseif self.clientState == 0 and message.clientState ~= 0 and self._source == "BATTLE_PVE_TRIGGER" then
      Logger.LogInfo("[WorkersSource_BATTLE_PVE_TRIGGER]")
      DataCenter.GainWorkerManager:RemovePveWorker(self)
    end
    self.clientState = message.clientState
  end
  if message.status then
    self.status = message.status
  end
  if message.effect then
    for k, v in pairs(message.effect) do
      local effectId = tonumber(k)
      local effectValue = tonumber(v)
      self.effectDict[effectId] = effectValue
    end
  end
  if message.rank then
    self.rank = message.rank
  end
  if message.cfgId then
    self.cfgId = tonumber(message.cfgId)
    local template = DataCenter.WorkerTemplateManager:GetTemplateById(self.cfgId)
    if not template then
      return
    end
    self.workingBuildList = template.workingBuildList
    self.workingBuildMap = template.workingBuildMap
    local effects = template.effects
    self.peculiarity = effects[1]
    self.peculiarityVlue = effects[2]
    local effectLine = LocalController:instance():getLine(TableName.LW_Effect_Number, tonumber(self.peculiarity))
    self.peculiarityText = Localization:GetString(effectLine.name)
    self.power = template.power
    self.isUIPlaneShow = template.isShow
    self.star = template.star
  end
  self.rankPower = nil
end

local function HandleEffect(self, effects)
  for k, v in pairs(effects) do
    local effectId = tonumber(k)
    local effectValue = tonumber(v)
    self.effectDict[effectId] = effectValue
  end
end

local function GetAppearCfg(self)
  return self.appearCfg
end

local function GetHalfIconPath(self)
  return UIUtil.GetFullPath(LoadPath.HeroIconsBigPath, self.appearCfg.half_icon_path)
end

local function UpdateState(self)
  if self.dispatchingBuildUid then
    self.state = WorkerState.WORKER
  else
    self.state = WorkerState.RESIDENTA
  end
end

local function SetDispatching(self, buildUid, buildItemId)
  if buildItemId == BuildingTypes.LW_BUILD_LIBRARY then
    self.wellBuildUuid = buildUid
    if buildUid == nil then
      self.dispatchingBuildUid = nil
    end
  else
    self.dispatchingBuildUid = buildUid
  end
  UpdateState(self)
end

local function GetState(self)
  return self.state
end

local function GetDispatchingUid(self)
  if self.state == WorkerState.WORKER then
    return self.dispatchingBuildUid
  end
end

local function GetWorkerProperty(self, effectId)
  return self.effectDict[effectId] and self.effectDict[effectId] or 0
end

local function GetName(self)
  return Localization:GetString(self.firstName) .. " " .. Localization:GetString(self.lastName)
end

local function GetCharacterList(self)
  if string.IsNullOrEmpty(self.wordIds) then
    return {}
  end
  local characterList = {}
  local tempList = string.split(self.wordIds, "|")
  if tempList ~= nil then
    for _, num in pairs(tempList) do
      local id = tonumber(num)
      if id ~= nil then
        local specialQuality = GetTableData(TableName.HeroSpecial, id, "quality")
        local speicalName = GetTableData(TableName.HeroSpecial, id, "name")
        local effectStr = ""
        local specialEffects = GetTableData(TableName.HeroSpecial, id, "effect")
        if specialEffects ~= nil then
          local index = 1
          for k, v in pairs(specialEffects) do
            local value = ""
            if 0 < v then
              value = "+" .. HeroUtils.GetFormattedPropertyValue(k, v)
            else
              value = HeroUtils.GetFormattedPropertyValue(k, v)
            end
            if index == 1 then
              effectStr = effectStr .. string.format("%s : %s ", Localization:GetString(HeroUtils.GetHeroPropertyNameId(k)), value)
            else
              effectStr = effectStr .. string.format([[

%s : %s ]], Localization:GetString(HeroUtils.GetHeroPropertyNameId(k)), value)
            end
            index = index + 1
          end
        end
        local characterItem = {
          id = id,
          quality = specialQuality,
          name = speicalName,
          effectStr = effectStr
        }
        table.insert(characterList, characterItem)
      end
    end
  end
  return characterList
end

local function IsCanWork(self, buildItemId)
  local ret = self.workingBuildMap[buildItemId] or false
  return ret
end

local function UpdateRankPower(self, message)
  if message.rank or message.cfgId then
    self.rankPower = self.power
    if self.star and self.star > 0 then
      local rankTemp = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(self.cfgId, self.rank)
      if rankTemp then
        self.rankPower = self.power + rankTemp.power
      end
    end
  end
end

local function getter_rankPower(self)
  self.rankPower = self.power
  if self.star and self.star > 0 then
    local rankTemp = DataCenter.WorkerRankTemplateManager:GetTemplateByIdAndRank(self.cfgId, self.rank)
    if rankTemp then
      self.rankPower = self.power + rankTemp.power
    end
  end
  return self.rankPower
end

function WorkerData:GetAttributeSource()
  Logger.LogInfo("[WorkersSourceLog] " .. tostring(self._source))
  return self._source or ""
end

function WorkerData.getters:source()
  return self:GetAttributeSource()
end

WorkerData.__init = __init
WorkerData.__delete = __delete
WorkerData.SetDispatching = SetDispatching
WorkerData.GetState = GetState
WorkerData.GetDispatchingUid = GetDispatchingUid
WorkerData.GetAppearCfg = GetAppearCfg
WorkerData.GetHalfIconPath = GetHalfIconPath
WorkerData.UpdateInfo = UpdateInfo
WorkerData.HandleEffect = HandleEffect
WorkerData.GetWorkerProperty = GetWorkerProperty
WorkerData.GetName = GetName
WorkerData.GetCharacterList = GetCharacterList
WorkerData.IsCanWork = IsCanWork
WorkerData.UpdateRankPower = UpdateRankPower
WorkerData.getters.rankPower = getter_rankPower
return WorkerData
