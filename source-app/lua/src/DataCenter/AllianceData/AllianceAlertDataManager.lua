local AllianceAlertDataManager = BaseClass("AllianceAlertDataManager")
local Localization = CS.GameEntry.Localization

function AllianceAlertDataManager:__init()
  self.allianceAlertList = {}
  self.alertNum = 0
end

function AllianceAlertDataManager:__delete()
  self.allianceAlertList = nil
  self.alertNum = nil
  self.redPointDirty = nil
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function AllianceAlertDataManager:InitData()
  SFSNetwork.SendMessage(MsgDefines.GetAllianceAlertInfo)
end

function AllianceAlertDataManager:ResetData()
  self.allianceAlertList = {}
  if self.alertNum > 0 then
    self.alertNum = 0
    self.redPointDirty = nil
    EventManager:GetInstance():Broadcast(EventId.UpdateAlertRedPoint)
  end
end

local function GetLastReadTimeS()
  local strKey = "lwalwarnrts" .. LuaEntry.Player.uid .. LuaEntry.Player.allianceId
  return CS.GameEntry.Setting:GetInt(strKey, 0) * 1000
end

function AllianceAlertDataManager:UpdateLastReadTimeS()
  if self.alertNum > 0 then
    self.alertNum = 0
    local strKey = "lwalwarnrts" .. LuaEntry.Player.uid .. LuaEntry.Player.allianceId
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    CS.GameEntry.Setting:SetInt(strKey, curTime)
    self.redPointDirty = nil
    EventManager:GetInstance():Broadcast(EventId.UpdateAlertRedPoint)
  end
end

function AllianceAlertDataManager:CalculateAlertNum()
  local lastNum = self.alertNum
  self.alertNum = 0
  local lastRTS = GetLastReadTimeS()
  for _, v in pairs(self.allianceAlertList) do
    if v.isAtk == 0 and lastRTS < v.startTime then
      self.alertNum = self.alertNum + 1
    end
  end
  if lastNum ~= self.alertNum then
    EventManager:GetInstance():Broadcast(EventId.UpdateAlertRedPoint)
  end
end

function AllianceAlertDataManager:InitAllianceAlertList(infos)
  self.allianceAlertList = {}
  if next(infos) then
    for _, v in ipairs(infos) do
      self.allianceAlertList[v.uuid] = v
    end
    self:CalculateAlertNum()
  end
  EventManager:GetInstance():BroadcastDeferred(EventId.UpdateAlertData)
end

function AllianceAlertDataManager:UpdateAllianceAlertList(info)
  if not self.allianceAlertList[info.uuid] then
    self.allianceAlertList[info.uuid] = info
    self:CalculateAlertNum()
  end
end

function AllianceAlertDataManager:GetAllianceAlertList()
  local ret = table.values(self.allianceAlertList)
  table.sort(ret, function(warningDataA, warningDataB)
    return toInt(warningDataA.startTime) < toInt(warningDataB.startTime)
  end)
  return ret
end

function AllianceAlertDataManager:GetAllianceAlertByIdList()
  return table.keys(self.allianceAlertList)
end

function AllianceAlertDataManager:GetAllianceAlertDataByKey(key)
  if self.allianceAlertList[key] then
    return self.allianceAlertList[key]
  end
  return nil
end

function AllianceAlertDataManager:UpdateMarchList(message)
end

function AllianceAlertDataManager:AddAlertInfo(info)
  if not self.allianceAlertList[info.uuid] then
    self.allianceAlertList[info.uuid] = info
    self:AddAlertNum(info)
    self:CheckAlertToBroadcast()
  end
end

function AllianceAlertDataManager:RemoveAlertInfo(info)
  if self.allianceAlertList[info.uuid] then
    self:SubAlertNum(self.allianceAlertList[info.uuid])
    self.allianceAlertList[info.uuid] = nil
    self:CheckAlertToBroadcast()
  end
end

function AllianceAlertDataManager:CheckAlertToBroadcast()
  local useCombineRefresh = LuaEntry.DataConfig:CheckSwitch("opt_push_alliance_alert")
  if not useCombineRefresh then
    self:TryBroadcastAlerRedPoint()
    EventManager:GetInstance():BroadcastDeferred(EventId.UpdateAlertData)
  elseif self.delayTimer == nil then
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.delayTimer = nil
      self:TryBroadcastAlerRedPoint()
      EventManager:GetInstance():BroadcastDeferred(EventId.UpdateAlertData)
    end, 1)
  end
end

function AllianceAlertDataManager:TryBroadcastAlerRedPoint()
  if self.redPointDirty then
    self.redPointDirty = nil
    EventManager:GetInstance():Broadcast(EventId.UpdateAlertRedPoint)
  end
end

function AllianceAlertDataManager:AddAlertNum(info)
  local lastRTS = GetLastReadTimeS()
  if info.isAtk == 0 and lastRTS < info.startTime then
    self.alertNum = self.alertNum + 1
    self.redPointDirty = true
  end
end

function AllianceAlertDataManager:SubAlertNum(info)
  local lastRTS = GetLastReadTimeS()
  if info.isAtk == 0 and lastRTS < info.startTime then
    self.alertNum = self.alertNum - 1
    self.redPointDirty = true
  end
end

function AllianceAlertDataManager:RemoveAlertKey(message)
  if self.allianceAlertList[message.uuid] then
    self.allianceAlertList[message.uuid] = nil
    EventManager:GetInstance():BroadcastDeferred(EventId.UpdateAlertData)
    self:CalculateAlertNum()
  end
end

function AllianceAlertDataManager:GetAlertNum()
  return self.alertNum
end

function AllianceAlertDataManager:GetTargetName(warningData)
  if warningData == nil then
    return ""
  end
  local targetType = warningData.target
  if targetType == MarchTargetType.ATTACK_DESERT or targetType == MarchTargetType.ATTACK_EMPTY_DESERT then
    if warningData.tDesertId then
      local meta = DataCenter.DesertTemplateManager:GetTemplate(warningData.tDesertId)
      if meta then
        if meta.level == 0 then
          return Localization:GetString(meta.name)
        end
        return Localization:GetString("140002", meta.level) .. " " .. Localization:GetString(meta.name)
      end
    end
    return Localization:GetString("110251")
  elseif targetType == MarchTargetType.ATTACK_BUILDING then
    local contentId = toInt(warningData.tSeasonBuildingId)
    if contentId ~= 0 then
      local level = contentId % BuildLevelCap
      local buildId = contentId - level
      local meta = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
      if meta == nil then
        meta = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
      end
      if meta then
        if level == nil or level == 0 then
          return Localization:GetString(meta.name)
        end
        return Localization:GetString("140002", level) .. " " .. Localization:GetString(meta.name)
      end
    end
    return Localization:GetString("458130")
  elseif targetType == MarchTargetType.ATTACK_ALLIANCE_BUILDING or targetType == MarchTargetType.DARK_KNIGHT_CITY and 0 < toInt(warningData.tBuildingId) then
    if warningData.tBuildingId then
      local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(warningData.tBuildingId)
      if meta then
        return Localization:GetString(meta.name)
      end
    end
    return Localization:GetString("458130")
  elseif targetType == MarchTargetType.ATTACK_CITY or targetType == MarchTargetType.ATTACK_WINTER_STORM_CITY or targetType == MarchTargetType.ATTACK_EPIDEMIC_CITY or targetType == MarchTargetType.ATTACK_ARMY_COLLECT then
    if not string.IsNullOrEmpty(warningData.tAllianceAbbr) then
      return Localization:GetString("311026", warningData.tAllianceAbbr, warningData.tName or warningData.tAllianceName or "???")
    elseif not string.IsNullOrEmpty(warningData.tName) then
      return warningData.tName
    elseif not string.IsNullOrEmpty(warningData.tAllianceName) then
      return warningData.tAllianceName
    else
      if targetType == MarchTargetType.ATTACK_ARMY_COLLECT and warningData.tResId ~= nil and 0 < warningData.tResId then
        local resCfg = DataCenter.GatherResourceTemplateManager:GetTemplate(warningData.tResId)
        if resCfg then
          return Localization:GetString("104290", resCfg.level, Localization:GetString(resCfg.name))
        end
      end
      return Localization:GetString(110245)
    end
  elseif targetType == MarchTargetType.ATTACK_METEORITE then
    if warningData.tResId and 0 < warningData.tResId then
      local config = DataCenter.ActMeteoriteBattleManager:GetEntityConfigById(warningData.tResId)
      if config then
        return Localization:GetString(config.name)
      else
        return Localization:GetString(110245)
      end
    else
      return Localization:GetString(110245)
    end
  elseif (targetType == MarchTargetType.ATTACK_ALLIANCE_CITY or targetType == MarchTargetType.ATTACK_THRONE or targetType == MarchTargetType.ATTACK_CITY_STRONGHOLD) and 0 < toInt(warningData.tAllianceCityId) then
    return Localization:GetString("311026", warningData.tAllianceAbbr, warningData.tAllianceName)
  elseif (targetType == MarchTargetType.DARK_KNIGHT_CITY or targetType == MarchTargetType.BEHEMOTH_ATTACK_CITY) and 0 < toInt(warningData.tAllianceCityId) then
    local template = DataCenter.AllianceCityTemplateManager:GetTemplate(warningData.tAllianceCityId)
    if template then
      return Localization:GetString("311026", warningData.tAllianceAbbr, Localization:GetString(template.name))
    end
    return Localization:GetString("311026", warningData.tAllianceAbbr, "")
  elseif targetType == MarchTargetType.RALLY_FOR_BUILDING or targetType == MarchTargetType.ATTACK_BUILDING or targetType == MarchTargetType.SCOUT_BUILDING or targetType == MarchTargetType.SCOUT_THRONE or targetType == MarchTargetType.ASSISTANCE_CITY or targetType == MarchTargetType.ASSISTANCE_WINTER_STORM_CITY or targetType == MarchTargetType.ASSISTANCE_EPIDEMIC_CITY or targetType == MarchTargetType.ASSISTANCE_BUILD or targetType == MarchTargetType.ASSISTANCE_THRONE or targetType == MarchTargetType.SCOUT_CITY or targetType == MarchTargetType.SCOUT_WINTER_STORM_CITY or targetType == MarchTargetType.SCOUT_EPIDEMIC_CITY then
    local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(self.targetUuid)
    if buildingData ~= nil then
      local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildingData.itemId)
      return Localization:GetString(buildTemplate.name)
    end
  elseif targetType == MarchTargetType.ATTACK_ROAD then
    if DataCenter.BoardManager:GetBoardData(warningData.targetUuid) ~= nil then
      return Localization:GetString("100308")
    end
  elseif targetType == MarchTargetType.ATTACK_ARMY or targetType == MarchTargetType.SCOUT_TROOP then
    return Localization:GetString("110020")
  elseif warningData.tStrongholdId and (targetType == MarchTargetType.ATTACK_CITY_STRONGHOLD or targetType == MarchTargetType.RALLY_CITY_STRONGHOLD or targetType == MarchTargetType.ASSISTANCE_CITY_STRONGHOLD or targetType == MarchTargetType.SCOUT_CITY_STRONGHOLD) then
    local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(warningData.tStrongholdId, LuaEntry.Player:GetCurServerId())
    if cityMeta then
      return Localization:GetString("311026", warningData.tAllianceAbbr, Localization:GetString(cityMeta.name))
    end
  elseif warningData.tMonsterId then
    local monsterTemplate = DataCenter.MonsterTemplateManager:GetMonsterTemplate(warningData.tMonsterId)
    if monsterTemplate then
      return Localization:GetString("311026", warningData.tAllianceAbbr, Localization:GetString(monsterTemplate.name))
    end
    return Localization:GetString("311026", warningData.tAllianceAbbr, Localization:GetString("110152"))
  elseif warningData.tCityAltarId then
    local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(warningData.tCityAltarId, LuaEntry.Player:GetCurServerId())
    if cityMeta then
      return Localization:GetString("311026", warningData.tAllianceAbbr, Localization:GetString(cityMeta.name))
    end
  end
  return ""
end

function AllianceAlertDataManager:GetTargetHeadIcon(warningData)
  if warningData == nil then
    return nil
  end
  local targetType = warningData.target
  if targetType == MarchTargetType.ATTACK_DESERT or targetType == MarchTargetType.ATTACK_EMPTY_DESERT then
    if warningData.tDesertId then
      local meta = DataCenter.DesertTemplateManager:GetTemplate(warningData.tDesertId)
      if meta then
        return string.format(LoadPath.SeasonDesert, meta.icon), 0.5
      end
    end
    return "Assets/Main/Sprites/SeasonDesert/massif_7.png", 0.5
  elseif targetType == MarchTargetType.ATTACK_BUILDING then
    local contentId = toInt(warningData.tSeasonBuildingId)
    if contentId ~= 0 then
      local level = contentId % BuildLevelCap
      local buildId = contentId - level
      local meta = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
      if meta == nil then
        meta = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
      end
      if meta then
        return meta:GetBuildIconOutCity(), 0.5
      end
    end
    return "Assets/Main/Sprites/BuildIconOutCity/pic745000_2_free.png", 0.5
  elseif targetType == MarchTargetType.ATTACK_ALLIANCE_BUILDING or targetType == MarchTargetType.DARK_KNIGHT_CITY and 0 < toInt(warningData.tBuildingId) then
    if warningData.tBuildingId then
      local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(warningData.tBuildingId)
      if meta then
        return meta:GetIconPath(), 0.5
      end
    end
    return "Assets/Main/Sprites/UI/UIAllianceNew/pic_alliance_center.png", 0.5
  elseif targetType == MarchTargetType.ATTACK_ARMY_COLLECT and warningData.tResId ~= nil and 0 < warningData.tResId then
    local resCfg = DataCenter.GatherResourceTemplateManager:GetTemplate(warningData.tResId)
    if resCfg then
      if resCfg.resource_type == ResourceType.Gold then
        return DataCenter.ResourceManager:GetResourceIconByType(resCfg.resource_type)
      end
      return resCfg.pic, 0.7
    end
  elseif targetType == MarchTargetType.ATTACK_METEORITE then
    if warningData.tResId and 0 < warningData.tResId then
      local config = DataCenter.ActMeteoriteBattleManager:GetEntityConfigById(warningData.tResId)
      if config then
        return config.pic, 0.7
      else
        return "Assets/Main/Sprites/ItemIcons/zxl_yunshi_tubiao1.png", 0.7
      end
    else
      return "Assets/Main/Sprites/ItemIcons/zxl_yunshi_tubiao1.png", 0.7
    end
  elseif (targetType == MarchTargetType.ATTACK_ALLIANCE_CITY or targetType == MarchTargetType.ATTACK_THRONE or targetType == MarchTargetType.ATTACK_CITY_STRONGHOLD or targetType == MarchTargetType.DARK_KNIGHT_CITY) and 0 < toInt(warningData.tAllianceCityId) then
    local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(warningData.tAllianceCityId)
    return meta:GetIconPath(false), 0.5
  elseif warningData.tStrongholdId and (targetType == MarchTargetType.ATTACK_CITY_STRONGHOLD or targetType == MarchTargetType.RALLY_CITY_STRONGHOLD or targetType == MarchTargetType.ASSISTANCE_CITY_STRONGHOLD or targetType == MarchTargetType.SCOUT_CITY_STRONGHOLD) then
    local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(warningData.tStrongholdId)
    return meta:GetIconPath(false), 0.5
  elseif warningData.tMonsterId then
    local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(warningData.tMonsterId)
    if monster then
      return UIUtil.GetFullPath(LoadPath.HeroIconsSmallPath, monster.pic), 0.5
    end
  elseif warningData.tCityAltarId and (targetType == MarchTargetType.ATTACK_CITY_ALTAR or targetType == MarchTargetType.ASSISTANCE_CITY_ALTAR) then
    local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(warningData.tCityAltarId, LuaEntry.Player:GetCurServerId())
    if meta then
      return meta:GetIconPath(false), 0.5
    end
  end
  return nil
end

return AllianceAlertDataManager
