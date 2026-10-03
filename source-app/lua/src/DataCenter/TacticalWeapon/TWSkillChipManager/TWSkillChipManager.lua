local TWSkillChipManager = BaseClass("TWSkillChipManager")
local Localization = CS.GameEntry.Localization
local TWSkillChipInfo = require("DataCenter.TacticalWeapon.TWSkillChipManager.TWSkillChipInfo")

function TWSkillChipManager:__init()
  self.skillChipInfos = {}
  self.masterSets = {}
  self.chipInfoEquipMap = {}
  self.unlockedMasterSets = {}
  self.typeChipDic = {}
  self.heroTypeChipDic = {}
  self.chipPreviewTime = LongMaxValue
  self.chipOpenTime = LongMaxValue
  self.chipUnlock = false
  self.chipSeriesDicData = {}
  EventManager:GetInstance():AddListener(EventId.RefreshItems, self.OnRefreshItems)
  self.addListeners = true
end

function TWSkillChipManager:__delete()
  self.skillChipInfos = nil
  self.masterSets = nil
  self.chipInfoEquipMap = nil
  self.unlockedMasterSets = nil
  self.typeChipDic = nil
  self.heroTypeChipDic = nil
  self.chipPreviewTime = nil
  self.chipOpenTime = nil
  self.chipUnlock = nil
  self.chipSeriesDicData = nil
  if self.addListeners then
    EventManager:GetInstance():RemoveListener(EventId.RefreshItems, self.OnRefreshItems)
  end
end

function TWSkillChipManager:ClearData()
  self.skillChipInfos = {}
  self.masterSets = {}
  self.unlockedMasterSets = {}
  self.typeChipDic = {}
  self.heroTypeChipDic = {}
  self.chipPreviewTime = LongMaxValue
  self.chipOpenTime = LongMaxValue
  self.chipUnlock = false
end

function TWSkillChipManager:RequestInitInfo()
end

function TWSkillChipManager:GetChipInfo(uuid)
  return self.skillChipInfos[uuid]
end

function TWSkillChipManager:RemoveFromMasterGroup(uuid, type, masterSet)
  if masterSet == nil or masterSet <= 0 then
    return
  end
  local masterGroup = self.masterSets[masterSet]
  if masterGroup and masterGroup[type] == uuid then
    masterGroup[type] = nil
  end
end

function TWSkillChipManager:RemoveFromEquipMap(uuid)
  self.chipInfoEquipMap[uuid] = nil
end

function TWSkillChipManager:AddToMasterGroup(uuid, type, masterSet)
  if masterSet == nil or masterSet <= 0 then
    return
  end
  local masterGroup = self.masterSets[masterSet]
  if masterGroup == nil then
    masterGroup = {}
    self.masterSets[masterSet] = masterGroup
  end
  masterGroup[type] = uuid
end

function TWSkillChipManager:AddToEquipMap(uuid, chipInfo)
  self.chipInfoEquipMap[uuid] = chipInfo
end

function TWSkillChipManager:RemoveChipInfo(uuid)
  local chipInfo = self:GetChipInfo(uuid)
  if chipInfo then
    local masterSet = chipInfo.masterSet
    local type = chipInfo:GetType()
    if 0 < masterSet then
      self:RemoveFromMasterGroup(uuid, type, masterSet)
    end
    if self.typeChipDic[chipInfo:GetType()] then
      self.typeChipDic[chipInfo:GetType()][chipInfo:GetUUID()] = nil
    end
    if self.heroTypeChipDic[chipInfo:GetHeroType()] then
      self.heroTypeChipDic[chipInfo:GetHeroType()][chipInfo:GetUUID()] = nil
    end
    local chipSeries = chipInfo:GetChipSeries()
    if chipSeries then
      local seriesData = self.chipSeriesDicData[chipSeries]
      if seriesData then
        local list = seriesData.chipListDic[chipInfo:GetQuality()]
        local removeIndex = -1
        for i, v in ipairs(list) do
          if v and v:GetUUID() == chipInfo:GetUUID() then
            removeIndex = i
            break
          end
        end
        if 0 < removeIndex then
          table.remove(list, removeIndex)
        end
        seriesData.chipListDic[chipInfo:GetQuality()] = list
        for i, quality in ipairs(seriesData.qualityList) do
          local infoList = seriesData.chipListDic[quality]
          if infoList == nil or #infoList <= 0 then
            break
          end
          seriesData.maxQuality = i
        end
        self.chipSeriesDicData[chipSeries] = seriesData
      end
    end
    self.skillChipInfos[uuid] = nil
  end
end

function TWSkillChipManager:UpdateChipInfo(chipInfo)
  if not chipInfo then
    return
  end
  local uuid = chipInfo.uuid
  if chipInfo.num <= 0 then
    self:RemoveChipInfo(uuid)
  else
    local isNewChip = false
    local skillChipInfo = self:GetChipInfo(uuid)
    if skillChipInfo == nil then
      skillChipInfo = TWSkillChipInfo.New()
      isNewChip = true
    end
    local prevMasterSet = skillChipInfo.masterSet
    skillChipInfo:UpdateInfo(chipInfo)
    self.skillChipInfos[uuid] = skillChipInfo
    if self.typeChipDic[skillChipInfo:GetType()] == nil then
      self.typeChipDic[skillChipInfo:GetType()] = {}
    end
    if isNewChip then
      local chipSeries = skillChipInfo:GetChipSeries()
      if chipSeries then
        local seriesData = self.chipSeriesDicData[chipSeries]
        if not seriesData then
          seriesData = {}
          seriesData.maxQuality = 3
          seriesData.qualityList = {
            1,
            2,
            3,
            4,
            5,
            6,
            7
          }
          seriesData.chipListDic = {}
        end
        local quality = skillChipInfo:GetQuality()
        if quality > seriesData.maxQuality then
          seriesData.maxQuality = quality
        end
        local chipList = seriesData.chipListDic[quality]
        chipList = chipList or {}
        table.insert(chipList, skillChipInfo)
        seriesData.chipListDic[quality] = chipList
        self.chipSeriesDicData[chipSeries] = seriesData
      end
    end
    self.typeChipDic[skillChipInfo:GetType()][skillChipInfo:GetUUID()] = skillChipInfo
    if self.heroTypeChipDic[skillChipInfo:GetHeroType()] == nil then
      self.heroTypeChipDic[skillChipInfo:GetHeroType()] = {}
    end
    self.heroTypeChipDic[skillChipInfo:GetHeroType()][skillChipInfo:GetUUID()] = skillChipInfo
    local masterSet = skillChipInfo.masterSet
    local type = skillChipInfo:GetType()
    if 0 < prevMasterSet and prevMasterSet ~= masterSet then
      self:RemoveFromMasterGroup(uuid, type, prevMasterSet)
      self:RemoveFromEquipMap(uuid)
    end
    if 0 < masterSet then
      self:AddToMasterGroup(uuid, type, masterSet)
      self:AddToEquipMap(uuid, skillChipInfo)
    end
  end
end

function TWSkillChipManager:IsMaxQualityInSeries(series, quality)
  local seriesData = self.chipSeriesDicData[series]
  if seriesData then
    return 3 < quality and quality >= seriesData.maxQuality
  end
  return true
end

function TWSkillChipManager:UpdateChipsInfo(message, broadcastEvent)
  if message == nil then
    return
  end
  if message.deletes ~= nil then
    for _, v in pairs(message.deletes) do
      self:RemoveChipInfo(v)
    end
  end
  if message.droneSkillArr ~= nil then
    for _, v in pairs(message.droneSkillArr) do
      self:UpdateChipInfo(v)
    end
  elseif message.updates ~= nil then
    for _, v in pairs(message.updates) do
      self:UpdateChipInfo(v)
    end
  elseif message.changes ~= nil then
    for _, v in pairs(message.changes) do
      self:UpdateChipInfo(v)
    end
  end
  if message.skillChipGroup ~= nil then
    for _, v in pairs(message.skillChipGroup) do
      if self.unlockedMasterSets then
        self.unlockedMasterSets[v] = true
      end
    end
  end
  local unlockInfoChange = false
  if message.chipPreviewTime then
    self.chipPreviewTime = message.chipPreviewTime
    unlockInfoChange = true
  end
  if message.chipOpenTime then
    self.chipOpenTime = message.chipOpenTime
    unlockInfoChange = true
  end
  if message.chipUnlock then
    self.chipUnlock = message.chipUnlock == 1
    unlockInfoChange = true
  end
  if broadcastEvent == nil then
    broadcastEvent = true
  end
  if broadcastEvent then
    EventManager:GetInstance():Broadcast(EventId.TWSkillUpdate)
    self:OnSkillChipUpdate()
    if unlockInfoChange then
      EventManager:GetInstance():Broadcast(EventId.TWSkillUnlockTimeUpdate)
    end
  end
end

function TWSkillChipManager:GetChipsByMasterSet(masterSet)
  local masterGroup = self.masterSets[masterSet]
  if masterGroup == nil then
    return {}
  end
  local chips = {}
  for _, v in pairs(masterGroup) do
    local chipInfo = self:GetChipInfo(v)
    if chipInfo then
      chips[chipInfo:GetType()] = chipInfo
    end
  end
  return chips
end

function TWSkillChipManager:GetChipsInfoByMasterSet(masterSet)
  local masterGroup = self.masterSets[masterSet]
  if masterGroup == nil then
    return {}
  end
  local chips = {}
  for _, v in pairs(masterGroup) do
    local chipInfo = self:GetChipInfo(v)
    if chipInfo then
      local chip = {}
      chip.star = chipInfo:GetStar()
      chip.lv = chipInfo:GetLevel()
      chip.cfgId = chipInfo:GetId()
      chip.type = chipInfo:GetType()
      table.insert(chips, chip)
    end
  end
  table.sort(chips, function(a, b)
    return a.type < b.type
  end)
  return chips
end

function TWSkillChipManager:IsSetUnlocked(masterSet)
  if self.unlockedMasterSets[masterSet] and self.unlockedMasterSets[masterSet] == true then
    return true
  else
    return false
  end
  return false
end

function TWSkillChipManager:GetUnlockMasterSets()
  local arr = {}
  for k, v in pairs(self.unlockedMasterSets) do
    table.insert(arr, k)
  end
  table.sort(arr, function(a, b)
    return a < b
  end)
  return arr
end

function TWSkillChipManager:GetChipsByType(type)
  return self.typeChipDic[type] or {}
end

function TWSkillChipManager:GetChipsByHeroType(heroType)
  return self.heroTypeChipDic[heroType] or {}
end

function TWSkillChipManager:GetChipSeriesDicData()
  return self.chipSeriesDicData
end

function TWSkillChipManager:GetChipSeriesData(chipSeries)
  return self.chipSeriesDicData[chipSeries]
end

function TWSkillChipManager:GetAllChips()
  return self.skillChipInfos or {}
end

function TWSkillChipManager:IsFunctionUnlock()
  return self.chipUnlock
end

function TWSkillChipManager:GetSetPower(masterSet)
  local chips = self:GetChipsByMasterSet(masterSet)
  local power = 0
  for _, v in pairs(chips) do
    power = power + v:GetPower()
  end
  return power
end

function TWSkillChipManager:GetSetSkillPower(masterSet)
  local chips = self:GetChipsByMasterSet(masterSet)
  local power = 0
  for _, v in pairs(chips) do
    power = power + v:GetPowerV2()
  end
  return power
end

function TWSkillChipManager:GetChipPreviewTime()
  return self.chipPreviewTime or LongMaxValue
end

function TWSkillChipManager:GetChipOpenTime()
  return self.chipOpenTime or LongMaxValue
end

function TWSkillChipManager:GetSkillChipUnlockRemainTime()
  if self.chipOpenTime == nil or self.chipOpenTime == LongMaxValue then
    return 0
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local remainTime = self:GetChipOpenTime() - curTime
  if remainTime < 0 then
    remainTime = 0
  end
  return remainTime
end

function TWSkillChipManager:GetNextUnlockSetId()
  if not self.unlockedMasterSets then
    return nil
  end
  local nextUnlockSetId
  for i = 1, 4 do
    if not self.unlockedMasterSets[i] then
      nextUnlockSetId = i
      break
    end
  end
  return nextUnlockSetId
end

function TWSkillChipManager:GetUnlockSetCost(index)
  if self.unlockCost == nil then
    self.unlockCost = {}
    local costStr = LuaEntry.DataConfig:TryGetStr("TacticalWeapon_config", "k7", "")
    local unlockCost = string.split(costStr, ";")
    if unlockCost then
      for i = 1, #unlockCost do
        table.insert(self.unlockCost, tonumber(unlockCost[i]))
      end
    end
  end
  if self.unlockCost[index] then
    return self.unlockCost[index]
  else
    return 0
  end
end

function TWSkillChipManager:CollectAllChipsAttrs()
  local properties = {}
  if self.masterSets then
    for setId, chips in pairs(self.masterSets) do
      for _, chipId in pairs(chips) do
        local chip = self:GetChipInfo(chipId)
        if chip then
          local chipProperties = chip:GetProperties()
          for k, v in pairs(chipProperties) do
            if properties[k] then
              properties[k] = properties[k] + v
            else
              properties[k] = v
            end
          end
        end
      end
    end
  end
  return properties
end

function TWSkillChipManager:CollectAllChipsSkillPower()
  local power = 0
  if self.masterSets then
    for setId, chips in pairs(self.masterSets) do
      for _, chipId in pairs(chips) do
        local chip = self:GetChipInfo(chipId)
        if chip then
          power = power + chip:GetSkillPower()
        end
      end
    end
  end
  return power
end

function TWSkillChipManager:GetGuaranteedBoxData()
  if self.guaranteedBoxData == nil then
    local guarantId = LuaEntry.DataConfig:TryGetNum("TacticalWeapon_config", "k8", 0)
    self.guaranteedBoxData = DataCenter.GuaranteedBoxTemplateManager:GetTemplate(guarantId)
  end
  return self.guaranteedBoxData
end

function TWSkillChipManager:GetEquipChipInfoMap()
  return self.chipInfoEquipMap
end

function TWSkillChipManager:OnRefreshItems()
  EventManager:GetInstance():Broadcast(EventId.TWSkillChipRefreshBubble)
end

function TWSkillChipManager:OnSkillChipUpdate()
  EventManager:GetInstance():Broadcast(EventId.TWSkillChipRefreshBubble)
end

return TWSkillChipManager
