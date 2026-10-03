local HeroStationManager = BaseClass("HeroStationManager")
local HeroStationData = require("DataCenter.HeroStation.HeroStationData")
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting

local function __init(self)
end

local function __delete(self)
  self:DeleteData()
end

local function InitData(self, message)
  self.SWITCH_ON = LuaEntry.DataConfig:CheckSwitch("hero_station")
  self.NEED_MAIN_LV = LuaEntry.DataConfig:TryGetNum("building_zone", "k2")
  self.NEED_TASK_ID = LuaEntry.DataConfig:TryGetStr("building_zone", "k3")
  self.HERO_COUNT = LuaEntry.DataConfig:TryGetNum("building_zone", "k4")
  self.SKILL_COUNT = 3
  self.CHAT_DURATION = 3
  self.heroStations = {}
  self.stationSkills = {}
  self.stationIdList = {}
  self.stationDataDict = {}
  self.usingSkillIdQueue = {}
  self.usingSkillParamDict = {}
  self.extraEffectOldValDict = {}
  self.warningStationId = nil
  self.skillAdditionalValDict = {}
  self:InitFromMessage(message)
  for _, skillTemplate in pairs(DataCenter.HeroStationSkillTemplateManager:GetTemplateDict()) do
    if not table.hasvalue(self.stationIdList) then
      table.insert(self.stationIdList, skillTemplate.stationId)
    end
  end
  table.sort(self.stationIdList)
  for _, stationId in ipairs(self:GetStationIdList()) do
    local stationData = HeroStationData.New()
    stationData:Init(stationId, self.heroStations[stationId])
    self:SetStationData(stationId, stationData)
  end
  self:CheckStationEffectOldVal()
  self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction, self, false, false, false)
  self.timer:Start()
end

local function DeleteData(self)
  self.SWITCH_ON = nil
  self.NEED_MAIN_LV = nil
  self.NEED_TASK_ID = nil
  self.HERO_COUNT = nil
  self.SKILL_COUNT = nil
  self.CHAT_DURATION = nil
  self.stationDataDict = nil
  self.timer:Stop()
  self.timer = nil
  self.usingSkillIdQueue = nil
  self.usingSkillParamDict = nil
  self.extraEffectOldValDict = nil
  self.warningStationId = nil
end

local function InitFromMessage(self, message)
  if message.heroStations then
    self:UpdateHeroStations(message.heroStations)
  end
  if message.stationSkills then
    self:UpdateStationSkills(message.stationSkills)
  end
end

local function UpdateHeroStations(self, heroStations)
  for _, heroStation in pairs(heroStations) do
    self.heroStations[heroStation.stationId] = heroStation
  end
end

local function UpdateHeroStation(self, heroStation)
  self.heroStations[heroStation.stationId] = heroStation
end

local function UpdateStationSkills(self, stationSkills)
  for _, stationSkill in pairs(stationSkills) do
    self.stationSkills[stationSkill.skillId] = stationSkill
  end
end

local function UpdateStationSkill(self, stationSkill)
  self.stationSkills[stationSkill.skillId] = stationSkill
end

local function TimerAction(self)
  if not self:Enabled() then
    return
  end
  for _, stationId in ipairs(self:GetStationIdList()) do
    local stationData = self:GetStationData(stationId)
    if stationData ~= nil then
      local skillId = self:GetStationFirstUsableSkillId(stationId)
      local usable = skillId ~= nil
      if not (not usable or stationData.skillUsableCache) or not usable and stationData.skillUsableCache then
        stationData.skillUsableCache = usable
        EventManager:GetInstance():Broadcast(EventId.HeroStationUpdate)
      end
    end
  end
end

local function Enabled(self)
  if not self.SWITCH_ON then
    return false
  end
  if DataCenter.BuildManager.MainLv >= self.NEED_MAIN_LV then
    return true
  end
  local taskInfo = DataCenter.TaskManager:FindTaskInfo(self.NEED_TASK_ID)
  if taskInfo ~= nil and taskInfo.state == TaskState.Received then
    return true
  end
  return false
end

local function GetStationIdList(self)
  return self.stationIdList
end

local function GetStationIdByBuildId(self, buildId)
  for stationId, stationData in pairs(self.stationDataDict) do
    if stationData.buildId == buildId then
      return stationId
    end
  end
  return nil
end

local function GetBuildIdByStationId(self, stationId)
  local stationData = self.stationDataDict[stationId]
  if stationData == nil then
    return nil
  end
  return stationData.buildId
end

local function GetBuildUuidByStationId(self, stationId)
  local buildId = self:GetBuildIdByStationId(stationId)
  local buildData = buildId and DataCenter.BuildManager:GetFunbuildByItemID(buildId)
  local bUuid = buildData and buildData.uuid
  return bUuid
end

local function GetSkillIdListByStationId(self, stationId, usableOnly)
  local stationData = self:GetStationData(stationId)
  if stationData == nil then
    return {}
  end
  if usableOnly then
    return stationData.usableSkillList
  else
    return stationData.skillList
  end
end

local function GetEffectTypeBySkillId(self, skillId)
  return HeroStationSkillEffectType[skillId]
end

local function GetSkillIdByEffectType(self, effectType)
  for k, v in pairs(HeroStationSkillEffectType) do
    if v == effectType then
      return k
    end
  end
  return nil
end

local function GetStationIdBySkillId(self, skillId)
  for _, stationData in pairs(self.stationDataDict) do
    if table.hasvalue(stationData.skillList, skillId) then
      return stationData.stationId
    end
  end
  return nil
end

local function GetStationIdByBuildUuid(self, bUuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData == nil then
    return nil
  end
  return self:GetStationIdByBuildId(buildData.itemId)
end

local function CanEngageSkill(self, skillId)
  local skillTemplate = DataCenter.HeroStationSkillTemplateManager:GetTemplate(skillId)
  local stationId = self:GetStationIdBySkillId(skillId)
  for _, condition in pairs(skillTemplate.condition) do
    if self:GetStationHeroQualityCount(stationId, condition.quality) < condition.count then
      return false
    end
  end
  return true
end

local function CanUseSkill(self, skillId)
  local skillTemplate = DataCenter.HeroStationSkillTemplateManager:GetTemplate(skillId)
  if not skillTemplate.usable then
    return false
  end
  if not self:CanEngageSkill(skillId) then
    return false
  end
  local skillCdTime = self:GetSkillCdTime(skillId)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if skillCdTime > curTime then
    return false
  end
  return true
end

local function GetStationFirstUsableSkillId(self, stationId)
  if not self:Enabled() then
    return nil
  end
  local skillIdList = self:GetSkillIdListByStationId(stationId, true)
  if table.IsNullOrEmpty(skillIdList) then
    return nil
  end
  for _, skillId in pairs(skillIdList) do
    if self:CanUseSkill(skillId) then
      return skillId
    end
  end
  return nil
end

local function UseStationSkill(self, stationId)
  local skillId = self:GetStationFirstUsableSkillId(stationId)
  if skillId ~= nil then
    local icon, heroUuid = self:GetStationSkillBubbleIcon(skillId)
    self.usingSkillParamDict[skillId] = {
      icon = icon,
      heroUuid = heroUuid,
      num = 0
    }
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Hero_Skill, false)
    SFSNetwork.SendMessage(MsgDefines.HeroStationUseSkillMessage, skillId)
  end
end

local function GetStationData(self, stationId)
  return self.stationDataDict[stationId]
end

local function SetStationData(self, stationId, stationData)
  self.stationDataDict[stationId] = stationData
end

local function GetStationHeroQualityCount(self, stationId, quality)
  local stationData = self:GetStationData(stationId)
  if stationData == nil then
    return 0
  end
  local heroUuids = stationData:GetHeroUuids()
  local count = 0
  for _, heroUuid in pairs(heroUuids) do
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    if heroData ~= nil and quality <= heroData.quality then
      count = count + 1
    end
  end
  return count
end

local function GetSkillCdTime(self, skillId)
  local skill = self.stationSkills[skillId]
  return skill and math.floor(skill.cdTime) or 0
end

local function GetHeroStationId(self, heroUuid)
  for _, stationData in pairs(self.stationDataDict) do
    for _, heroInfo in pairs(stationData.heroInfos) do
      if heroInfo.heroUuid == heroUuid then
        return stationData.stationId
      end
    end
  end
  return nil
end

local function GetHeroStationState(self, stationId, heroUuid)
  for _, stationData in pairs(self.stationDataDict) do
    for _, heroInfo in pairs(stationData.heroInfos) do
      if heroInfo.heroUuid == heroUuid then
        if stationData.stationId == stationId then
          return HeroStationState.Current
        else
          return HeroStationState.Other
        end
      else
        local heroData1 = DataCenter.HeroDataManager:GetHeroByUuid(heroInfo.heroUuid)
        local heroData2 = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
        if heroData1 and heroData2 and heroData1.heroId == heroData2.heroId then
          return HeroStationState.Namesake
        end
      end
    end
  end
  return HeroStationState.Idle
end

local function HasAvailableHero(self, stationId)
  local heroDataList = DataCenter.HeroDataManager:GetAllHeroList()
  for heroUuid, _ in pairs(heroDataList) do
    if self:GetHeroStationState(stationId, heroUuid) == HeroStationState.Idle then
      return true
    end
  end
  return false
end

local function HasAvailableSlot(self, stationId)
  local stationData = self:GetStationData(stationId)
  if stationData == nil then
    return false
  end
  local heroUuids = stationData:GetHeroUuids()
  for i = 1, self.HERO_COUNT do
    local unlocked = self:IsStationSlotUnlocked(stationId, i)
    if heroUuids[i] == nil and unlocked then
      return true
    end
  end
  return false
end

local function GetEmptySlotList(self, stationId)
  local stationData = self:GetStationData(stationId)
  if stationData == nil then
    return {}
  end
  local heroUuids = stationData:GetHeroUuids()
  local list = {}
  for i = 1, self.HERO_COUNT do
    local unlocked = self:IsStationSlotUnlocked(stationId, i)
    if heroUuids[i] == nil and unlocked then
      table.insert(list, i)
    end
  end
  return list
end

local function GetLockedSlotList(self, stationId)
  local list = {}
  for i = 1, self.HERO_COUNT do
    local unlocked = self:IsStationSlotUnlocked(stationId, i)
    if not unlocked then
      table.insert(list, i)
    end
  end
  return list
end

local function StationHasSkillEffect(self, stationId, skillEffectType)
  if stationId == nil then
    return false
  end
  local skillIdList = self:GetSkillIdListByStationId(stationId)
  for _, skillId in pairs(skillIdList) do
    if HeroStationSkillEffectType[skillId] == skillEffectType then
      return true
    end
  end
  return false
end

local function GetStationSkillBubbleIcon(self, skillId)
  local stationId = self:GetStationIdBySkillId(skillId)
  local stationData = self:GetStationData(stationId)
  if stationData == nil then
    return nil, nil
  end
  local skillCdTime = self:GetSkillCdTime(skillId)
  local heroUuids = stationData:GetHeroUuids()
  if table.IsNullOrEmpty(heroUuids) then
    return nil, nil
  end
  local heroUuidList = {}
  for _, heroUuid in pairs(heroUuids) do
    table.insert(heroUuidList, heroUuid)
  end
  local random = skillCdTime % table.count(heroUuidList) + 1
  local heroUuid = heroUuidList[random]
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
  return HeroUtils.GetHeroIconPath(heroData.modelId), heroUuid
end

local function SetStationHero(self, stationId, index, heroUuid)
  local stationData = self:GetStationData(stationId)
  if stationData ~= nil then
    stationData:SetHero(index, heroUuid)
    stationData.isDirty = true
  end
end

local function RemoveStationHero(self, stationId, index)
  local stationData = self:GetStationData(stationId)
  if stationData ~= nil then
    stationData:RemoveHero(index)
    stationData.isDirty = true
  end
end

local function GetStationHeroIndex(self, stationId, heroUuid)
  local stationData = self:GetStationData(stationId)
  if stationData == nil then
    return -1
  end
  for index, uuid in pairs(stationData:GetHeroUuids()) do
    if uuid == heroUuid then
      return index
    end
  end
end

local function Backup(self)
  for _, stationData in pairs(self.stationDataDict) do
    stationData:BackUpHeroInfos()
  end
end

local function Save(self)
  for _, stationData in pairs(self.stationDataDict) do
    if stationData.isDirty then
      SFSNetwork.SendMessage(MsgDefines.HeroStationSaveMessage, stationData:ToMessageParam())
      stationData.isDirty = false
      stationData:RestoreHeroInfos()
    end
  end
end

local function PlayResEffect(self, bUuid, bubble, resourceType, num)
  local effectPath = DataCenter.BuildManager:GetPickResPath(resourceType, PickResEffectLevel.High)
  local pos = bubble.gameObject.transform.position
  pos.y = 5
  local req = CS.GameEntry.Resource:InstantiateAsync(effectPath)
  req:completed("+", function()
    if req.isError then
      return
    end
    req.gameObject:SetActive(true)
    req.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    req.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    req.gameObject.transform:Set_position(pos.x, pos.y, pos.z)
    TimerManager:GetInstance():DelayInvoke(function()
      if req then
        req:Destroy()
      end
    end, 2)
    DataCenter.DecResourceEffectManager:DecOneItemEffect(pos, "", num, bUuid)
  end)
end

local function CalcEffectedValue(self, val, effectType)
  local x = 0
  if effectType ~= HeroStationEffectType.TradeCenterMoney then
    x = self:GetGameEffect(effectType)
  else
    x = self:GetEffectValue(effectType)
  end
  if effectType == HeroStationEffectType.GlobalMoney or effectType == HeroStationEffectType.HeroExp or effectType == HeroStationEffectType.TroopLimit then
    return val * (1 + x / 100)
  elseif effectType == HeroStationEffectType.StorageLimit or effectType == HeroStationEffectType.TradeCenterMoney then
    return val + x
  end
  return val
end

local function GetEffectValue(self, effectType)
  local skillId = self:GetSkillIdByEffectType(effectType)
  return self:GetSkillEffectValue(skillId)
end

local function GetSkillEffectValue(self, skillId, heroUuid, ignoreAddition)
  local val, str = 0, ""
  if skillId == nil then
    return val, str, prefix, suffix
  end
  if heroUuid ~= nil then
    val = self:CalcSkillEffectValue(skillId, heroUuid)
  else
    local stationId = self:GetStationIdBySkillId(skillId)
    local stationData = self:GetStationData(stationId)
    if stationData ~= nil then
      local heroUuids = stationData:GetHeroUuids()
      for _, hUuid in pairs(heroUuids) do
        val = val + self:GetSkillEffectValue(skillId, hUuid)
      end
      if not ignoreAddition then
        val = val + (self.skillAdditionalValDict[skillId] or 0)
      end
    end
  end
  local prefix, suffix = self:GetSkillEffectAffix(skillId)
  return val, prefix .. Mathf.Round(val) .. suffix
end

local function GetSkillEffectAffix(self, skillId)
  local prefix, suffix = "", ""
  if skillId == 1000 or skillId == 1002 or skillId == 1003 then
    suffix = "%"
  elseif skillId == 1001 then
    prefix = "+"
  end
  return prefix, suffix
end

local function CalcSkillEffectValue(self, skillId, heroUuid)
  local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
  if heroData == nil then
    return 0
  end
  local quality = heroData.quality
  local level = heroData.level
  local rank = heroData.curMilitaryRankId
  local skillTemplate = DataCenter.HeroStationSkillTemplateManager:GetTemplate(skillId)
  local k = skillTemplate.effect_k
  local c = skillTemplate.effect_c
  local p = skillTemplate.effect_para
  local val = 0
  if skillId == 1000 then
    val = math.floor(c[quality] + (level + rank) * k[1])
  elseif skillId == 1001 then
    val = math.floor(quality * k[1] + math.floor((level + rank) / k[2]) * k[3])
  elseif skillId == 1002 then
    val = math.floor(quality * k[1] + level * k[2] + rank * k[3])
  elseif skillId == 1003 then
    val = math.floor(c[quality] + (level + rank) * k[1])
  end
  return val
end

local function PushUsingSkillId(self, skillId)
  if not table.hasvalue(self.usingSkillIdQueue, skillId) then
    table.insert(self.usingSkillIdQueue, skillId)
  end
end

local function PopUsingSkillId(self)
  if table.count(self.usingSkillIdQueue) > 0 then
    return table.remove(self.usingSkillIdQueue, 1)
  else
    return nil
  end
end

local function PeekUsingSkillId(self)
  if table.count(self.usingSkillIdQueue) > 0 then
    return self.usingSkillIdQueue[1]
  else
    return nil
  end
end

local function GetExtraEffectOldValByViewName(self, viewName)
  return self.extraEffectOldValDict[viewName]
end

local function SetExtraEffectOldValByViewName(self, viewName, val)
  self.extraEffectOldValDict[viewName] = val
end

local function GetStationHeroValCacheDict(self, stationId)
  local valCacheDict = {}
  local str = Setting:GetString(LuaEntry.Player.uid .. SettingKeys.HERO_STATION_VAL_CACHE .. stationId, "")
  Logger.Log("Hero Station " .. stationId .. ", Get Val Cache: " .. str)
  if string.IsNullOrEmpty(str) then
    return valCacheDict
  end
  local caches = string.split(str, "|")
  for _, cache in ipairs(caches) do
    local spl = string.split(cache, ";")
    if #spl == 4 then
      local heroUuid = tonumber(spl[1])
      local quality = tonumber(spl[2])
      local level = tonumber(spl[3])
      local rank = 0
      local val = tonumber(spl[4])
      valCacheDict[heroUuid] = {
        quality = quality,
        level = level,
        rank = rank,
        val = val
      }
    elseif #spl == 5 then
      local heroUuid = tonumber(spl[1])
      local quality = tonumber(spl[2])
      local level = tonumber(spl[3])
      local rank = tonumber(spl[4])
      local val = tonumber(spl[5])
      valCacheDict[heroUuid] = {
        quality = quality,
        level = level,
        rank = rank,
        val = val
      }
    else
      return {}
    end
  end
  return valCacheDict
end

local function SetStationHeroValCacheDict(self, stationId, valCacheDict)
  if string.IsNullOrEmpty(valCacheDict) then
    return
  end
  local caches = {}
  for heroUuid, dict in pairs(valCacheDict) do
    local cache = heroUuid .. ";" .. dict.quality .. ";" .. dict.level .. ";" .. dict.rank .. ";" .. dict.val
    table.insert(caches, cache)
  end
  local str = string.join(caches, "|")
  Logger.Log("Hero Station " .. stationId .. ", Set Val Cache: " .. str)
  Setting:SetString(LuaEntry.Player.uid .. SettingKeys.HERO_STATION_VAL_CACHE .. stationId, str)
end

local function GetSkillIcon(self, skillId)
  local skillTemplate = DataCenter.HeroStationSkillTemplateManager:GetTemplate(skillId)
  return string.format(LoadPath.UIHeroStation, skillTemplate.icon)
end

local function GetStationSlotUnlockLevel(self, stationId, index)
  local stationData = self:GetStationData(stationId)
  if stationData == nil then
    return 0
  end
  return stationData and stationData.slotUnlockLevelDict[index] or 0
end

local function IsStationSlotUnlocked(self, stationId, index)
  return DataCenter.BuildManager.MainLv >= self:GetStationSlotUnlockLevel(stationId, index)
end

local function GetWarningStationId(self)
  return self.warningStationId
end

local function SetWarningStationId(self, stationId)
  if stationId == nil or self.warningStationId == nil or stationId < self.warningStationId then
    self.warningStationId = stationId
  end
end

local function CheckStationEffectOldVal(self)
  for _, stationId in ipairs(self:GetStationIdList()) do
    local stationData = self:GetStationData(stationId)
    if stationData ~= nil then
      local skillId = stationData.skillList[1]
      local oldVal = stationData.effectOldVal
      local newVal = self:GetSkillEffectValue(skillId)
      if oldVal ~= nil and oldVal < newVal then
        self:SetWarningStationId(stationId)
      end
      stationData.effectOldVal = newVal
    end
  end
end

local function ReCalcSkillAddition(self)
  self.skillAdditionalValDict = {}
  for _, stationId in ipairs(self:GetStationIdList()) do
    local stationData = self:GetStationData(stationId)
    if stationData ~= nil then
      for _, skillId in ipairs(stationData.skillList) do
        local effectType = self:GetEffectTypeBySkillId(skillId)
        if effectType ~= HeroStationEffectType.TradeCenterMoney then
          local totalVal = self:GetGameEffect(effectType)
          local val = self:GetSkillEffectValue(skillId, nil, true)
          self.skillAdditionalValDict[skillId] = totalVal - val
        end
      end
    end
  end
end

local function GetGameEffect(self, effectType)
  local x = 0
  if effectType == HeroStationEffectType.GlobalMoney then
    x = LuaEntry.Effect:GetGameEffect(EffectDefine.GLOBAL_MONEY_EXTRA_PERCENT)
  elseif effectType == HeroStationEffectType.StorageLimit then
    x = LuaEntry.Effect:GetGameEffect(EffectDefine.STORAGE_MAX_EXTRA)
  elseif effectType == HeroStationEffectType.HeroExp then
    x = LuaEntry.Effect:GetGameEffect(EffectDefine.GLOBAL_HERO_EXP_EXTRA_PERCENT)
  elseif effectType == HeroStationEffectType.TroopLimit then
    x = LuaEntry.Effect:GetGameEffect(EffectDefine.TROOP_LIMIT_EXTRA)
  end
  x = math.tointeger(x) or x
  return x
end

local function GetSkillAddition(self, skillId)
  return self.skillAdditionalValDict[skillId] or 0
end

local function HandleHeroStationSaveMessage(self, message)
  if message.heroStation == nil then
    return
  end
  self:UpdateHeroStation(message.heroStation)
  local stationId = message.heroStation.stationId
  local stationData = self:GetStationData(stationId)
  if stationData ~= nil then
    stationData:UpdateServerData(message.heroStation)
  end
  EventManager:GetInstance():Broadcast(EventId.HeroStationSave, stationId)
  EventManager:GetInstance():Broadcast(EventId.HeroStationUpdate)
end

local function HandleHeroStationUseSkillMessage(self, message)
  if message.stationSkill == nil then
    return
  end
  self:UpdateStationSkill(message.stationSkill)
  local skillId = message.stationSkill.skillId
  local num = message.num
  local stationId = self:GetStationIdBySkillId(skillId)
  local bUuid = self:GetBuildUuidByStationId(stationId)
  if skillId == 1000 then
    local bubble = DataCenter.BuildBubbleManager.allBuildBubble[bUuid]
    self:PlayResEffect(bUuid, bubble, ResourceType.Food, num)
    local tipInfo = {
      content = {
        [1] = {
          type = ComplexTipType.Hero,
          heroUuid = self.usingSkillParamDict[skillId].heroUuid
        },
        [2] = {
          type = ComplexTipType.Text,
          str = Localization:GetString("162102", num)
        },
        [3] = {
          type = ComplexTipType.Image,
          path = string.format(LoadPath.ItemPath, "item2003")
        }
      }
    }
    UIUtil.ShowComplexTip(tipInfo)
  end
  DataCenter.BuildBubbleManager:CheckShowBubble(bUuid)
  local stationData = self:GetStationData(stationData)
  if stationData ~= nil then
    stationData.skillUsableCache = false
  end
  self.usingSkillParamDict[skillId].num = num
  self:PushUsingSkillId(skillId)
  EventManager:GetInstance():Broadcast(EventId.HeroStationUseSkill, skillId)
end

local function HandleHeroStationUpdateMessage(self, message)
  if message.heroStation == nil then
    return
  end
  self:UpdateHeroStation(message.heroStation)
  local stationId = message.heroStation.stationId
  local stationData = self:GetStationData(stationId)
  if stationData ~= nil then
    stationData:UpdateServerData(message.heroStation)
  end
  EventManager:GetInstance():Broadcast(EventId.HeroStationUpdate)
end

HeroStationManager.__init = __init
HeroStationManager.__delete = __delete
HeroStationManager.InitData = InitData
HeroStationManager.DeleteData = DeleteData
HeroStationManager.InitFromMessage = InitFromMessage
HeroStationManager.UpdateHeroStations = UpdateHeroStations
HeroStationManager.UpdateHeroStation = UpdateHeroStation
HeroStationManager.UpdateStationSkills = UpdateStationSkills
HeroStationManager.UpdateStationSkill = UpdateStationSkill
HeroStationManager.TimerAction = TimerAction
HeroStationManager.Enabled = Enabled
HeroStationManager.GetStationIdList = GetStationIdList
HeroStationManager.GetStationIdByBuildId = GetStationIdByBuildId
HeroStationManager.GetBuildIdByStationId = GetBuildIdByStationId
HeroStationManager.GetBuildUuidByStationId = GetBuildUuidByStationId
HeroStationManager.GetSkillIdListByStationId = GetSkillIdListByStationId
HeroStationManager.GetEffectTypeBySkillId = GetEffectTypeBySkillId
HeroStationManager.GetSkillIdByEffectType = GetSkillIdByEffectType
HeroStationManager.GetStationIdBySkillId = GetStationIdBySkillId
HeroStationManager.GetStationIdByBuildUuid = GetStationIdByBuildUuid
HeroStationManager.CanEngageSkill = CanEngageSkill
HeroStationManager.CanUseSkill = CanUseSkill
HeroStationManager.GetStationFirstUsableSkillId = GetStationFirstUsableSkillId
HeroStationManager.UseStationSkill = UseStationSkill
HeroStationManager.GetStationData = GetStationData
HeroStationManager.SetStationData = SetStationData
HeroStationManager.GetStationHeroQualityCount = GetStationHeroQualityCount
HeroStationManager.GetSkillCdTime = GetSkillCdTime
HeroStationManager.GetHeroStationId = GetHeroStationId
HeroStationManager.GetHeroStationState = GetHeroStationState
HeroStationManager.HasAvailableHero = HasAvailableHero
HeroStationManager.HasAvailableSlot = HasAvailableSlot
HeroStationManager.GetEmptySlotList = GetEmptySlotList
HeroStationManager.GetLockedSlotList = GetLockedSlotList
HeroStationManager.StationHasSkillEffect = StationHasSkillEffect
HeroStationManager.GetStationSkillBubbleIcon = GetStationSkillBubbleIcon
HeroStationManager.SetStationHero = SetStationHero
HeroStationManager.GetStationHeroIndex = GetStationHeroIndex
HeroStationManager.RemoveStationHero = RemoveStationHero
HeroStationManager.Backup = Backup
HeroStationManager.Save = Save
HeroStationManager.PlayResEffect = PlayResEffect
HeroStationManager.CalcEffectedValue = CalcEffectedValue
HeroStationManager.GetEffectValue = GetEffectValue
HeroStationManager.GetSkillEffectValue = GetSkillEffectValue
HeroStationManager.GetSkillEffectAffix = GetSkillEffectAffix
HeroStationManager.CalcSkillEffectValue = CalcSkillEffectValue
HeroStationManager.PushUsingSkillId = PushUsingSkillId
HeroStationManager.PopUsingSkillId = PopUsingSkillId
HeroStationManager.PeekUsingSkillId = PeekUsingSkillId
HeroStationManager.GetExtraEffectOldValByViewName = GetExtraEffectOldValByViewName
HeroStationManager.SetExtraEffectOldValByViewName = SetExtraEffectOldValByViewName
HeroStationManager.GetStationHeroValCacheDict = GetStationHeroValCacheDict
HeroStationManager.SetStationHeroValCacheDict = SetStationHeroValCacheDict
HeroStationManager.GetSkillIcon = GetSkillIcon
HeroStationManager.GetStationSlotUnlockLevel = GetStationSlotUnlockLevel
HeroStationManager.IsStationSlotUnlocked = IsStationSlotUnlocked
HeroStationManager.GetWarningStationId = GetWarningStationId
HeroStationManager.SetWarningStationId = SetWarningStationId
HeroStationManager.CheckStationEffectOldVal = CheckStationEffectOldVal
HeroStationManager.ReCalcSkillAddition = ReCalcSkillAddition
HeroStationManager.GetGameEffect = GetGameEffect
HeroStationManager.GetSkillAddition = GetSkillAddition
HeroStationManager.HandleHeroStationSaveMessage = HandleHeroStationSaveMessage
HeroStationManager.HandleHeroStationUseSkillMessage = HandleHeroStationUseSkillMessage
HeroStationManager.HandleHeroStationUpdateMessage = HandleHeroStationUpdateMessage
return HeroStationManager
