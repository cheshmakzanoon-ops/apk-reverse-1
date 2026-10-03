local AllianceMineManager = BaseClass("AllianceMineManager")
local AllianceMineData = require("DataCenter.AllianceMine.AllianceMineData")
local AllianceMineTemplate = require("DataCenter.AllianceMine.AllianceMineTemplate")
local WorldMarchData = require("DataCenter.WorldMarchDataManager.WorldMarchData")
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource

function AllianceMineManager:__init()
  self.allianceMilitaryCenter = nil
  self.allianceCarrier = nil
  self.allianceMilitaryAttachmentList = nil
  self.allianceFlagDic = {}
  self.allianceFlagUuidToId = {}
  self.alMineTemplateDic = {}
  self.fullTemplateDic = {}
  self.allianceMineInfoDic = {}
  self.allianceActMineInfo = nil
  self.allianceS0CityFightMineInfo = nil
  self.allianceCenterDic = {}
  self.allianceCenterUuidToId = {}
  self.allianceFrontDic = {}
  self.allianceFrontUuidToId = {}
  self.marchInfo = {}
  self.selfPoint = 0
  self.allianceFlagPlaceTime = 0
  self.allianceFlagDestroyStartTime = 0
  self.allianceFrontDestroyStartTime = {}
  self.actMineRes = 0
  self.allianceActMemberNum = 0
  self.allianceDonateCount = 0
  self.furnaceInfos = {}
end

function AllianceMineManager:__delete()
  self.allianceMilitaryCenter = nil
  self.allianceCarrier = nil
  self.allianceMilitaryAttachmentList = nil
  self.allianceFlagDic = {}
  self.allianceFlagUuidToId = {}
  self.alMineTemplateDic = {}
  self.allianceMineInfoDic = {}
  self.allianceActMineInfo = nil
  self.allianceS0CityFightMineInfo = nil
  self.allianceCenterDic = {}
  self.allianceCenterUuidToId = {}
  self.allianceFrontDic = {}
  self.allianceFrontUuidToId = {}
  self.selfPoint = 0
  self.allianceFlagPlaceTime = 0
  self.allianceFlagDestroyStartTime = 0
  self.allianceFrontDestroyStartTime = {}
end

function AllianceMineManager:InitTemplates()
  if self.now_season_index == nil or self.now_season_type == nil or self.now_season_group == nil or table.count(self.alMineTemplateDic) == 0 then
  else
    return
  end
  local season_index = 0
  local season_type = 0
  local season_group = 11
  local config = DataCenter.SeasonDataManager:GetSeasonConfig()
  if config and config.alliance_building ~= nil and config.alliance_building ~= "" and config.alliance_building ~= 0 then
    season_group = toInt(config.alliance_building)
    season_index = toInt(config.season)
    season_type = toInt(config.type)
  end
  local name = TableName.AllianceMine
  local ConfigCache = CS.GameEntry.ConfigCache
  local fullTemplateDic = self.fullTemplateDic or {}
  local alMineTemplateDic = self.alMineTemplateDic or {}
  LocalController:instance():visitTable(name, function(id, line)
    local meta = AllianceMineTemplate.New()
    meta:InitData(line, season_index, season_type, season_group)
    fullTemplateDic[id] = meta
  end)
  for id, meta in pairs(self.fullTemplateDic) do
    if meta.type == AllianceBuildType.ZombieRush or meta.type == AllianceBuildType.SiegeCamp or meta.season_group == season_group then
      local dictRow = {
        id = id,
        type = meta.type,
        model = meta.model,
        res_size = meta.res_size,
        offter_range = meta.offter_range
      }
      ConfigCache:UpdateTemplateData(name, id, dictRow)
      alMineTemplateDic[id] = meta
    end
  end
  self.alMineTemplateDic = alMineTemplateDic
  self.fullTemplateDic = fullTemplateDic
  self.now_season_index = season_index
  self.now_season_type = season_type
  self.now_season_group = season_group
end

function AllianceMineManager:RequestAllianceMineInfo(needDetail)
  if LuaEntry.Player:IsInAlliance() then
    SFSNetwork.SendMessage(MsgDefines.GetAllAllianceMineList, needDetail)
  end
end

function AllianceMineManager:OnLeaveAlliance()
  self.militaryCenterBuildInfos = nil
  self.allianceMilitaryCenter = nil
  self.allianceCarrier = nil
  self.allianceFlagDic = {}
  self.allianceFlagUuidToId = {}
  self.allianceMineInfoDic = {}
  self.allianceActMineInfo = nil
  self.allianceS0CityFightMineInfo = nil
  self.allianceCenterDic = {}
  self.allianceCenterUuidToId = {}
  self.allianceFrontDic = {}
  self.allianceFrontUuidToId = {}
  self.selfPoint = 0
  self.allianceFlagPlaceTime = 0
  self.allianceFlagDestroyStartTime = 0
  self.allianceFrontDestroyStartTime = {}
  self.actMineRes = 0
  self.allianceActMemberNum = 0
  EventManager:GetInstance():Broadcast(EventId.AllianceFlagUpdate)
  EventManager:GetInstance():Broadcast(EventId.AllianceCenterUpdate)
  EventManager:GetInstance():Broadcast(EventId.AllianceFrontUpdate)
  EventManager:GetInstance():Broadcast(EventId.AllianceActMineUpdate)
  EventManager:GetInstance():Broadcast(EventId.UpdateAllAllianceMineList)
  EventManager:GetInstance():Broadcast(EventId.UpdateMainAllianceRedCount)
end

function AllianceMineManager:FetchMilitaryCenterBuildInfo()
  local data = self.militaryCenterBuildInfos
  local now = UITimeManager:GetInstance():GetServerTime()
  if data == nil or data.now == nil or now - toInt(data.now) >= 3000 then
    SFSNetwork.SendMessage(MsgDefines.FetchMilitaryCenterBuildInfo)
  end
  return data
end

function AllianceMineManager:UpdateAllianceMineInfo(msg)
  DataCenter.AllianceBaseDataManager:UpdateResource(msg.alResItem)
  if msg.build_alliance_building_point then
    self.selfPoint = msg.build_alliance_building_point
  end
  if msg.isGreen then
    self.isMilitaryCenterGreen = msg.isGreen
  end
  if msg.alBuildings then
    local allianceMilitaryCenter, allianceCarrier
    local allianceFlagDic = {}
    local allianceFlagUuidToId = {}
    local allianceCenterDic = {}
    local allianceCenterUuidToId = {}
    local allianceFrontDic = {}
    local allianceFrontUuidToId = {}
    local allianceMineInfoDic = {}
    local allianceMilitaryAttachmentList = {}
    local allianceActMineInfo, allianceS0CityFightMineInfo
    for i, v in ipairs(msg.alBuildings) do
      local newInfo = AllianceMineData.New()
      newInfo:ParseData(v)
      local buildId = newInfo.buildId
      if WorldAllianceBuildUtil.IsAllianceCenterFlag(buildId) then
        if self.allianceFlagDic == nil or self.allianceFlagDic[newInfo.buildId] == nil then
          self:ShowNewBuildEffect(newInfo)
        end
        allianceFlagDic[newInfo.buildId] = newInfo
        allianceFlagUuidToId[newInfo.uuid] = newInfo.buildId
      elseif WorldAllianceBuildUtil.IsAllianceCenterGroup(buildId) then
        if self.allianceCenterDic == nil or self.allianceCenterDic[newInfo.buildId] == nil then
          self:ShowNewBuildEffect(newInfo)
        end
        allianceCenterUuidToId[newInfo.uuid] = newInfo.buildId
        allianceCenterDic[newInfo.buildId] = newInfo
      elseif WorldAllianceBuildUtil.IsAllianceFrontGroup(buildId) then
        allianceFrontUuidToId[newInfo.uuid] = newInfo.buildId
        allianceFrontDic[newInfo.buildId] = newInfo
      elseif WorldAllianceBuildUtil.IsAllianceMineGroup(buildId) == true then
        allianceMineInfoDic[newInfo.uuid] = newInfo
      elseif WorldAllianceBuildUtil.IsAllianceActMineGroup(buildId) == true then
        allianceActMineInfo = newInfo
      elseif WorldAllianceBuildUtil.IsAllianceS0DeclareBuild(buildId) == true then
        allianceS0CityFightMineInfo = newInfo
      end
      local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(buildId)
      if template ~= nil then
        if template.type == AllianceBuildType.StoveCenter or template.type == AllianceBuildType.MilitaryCenter or template.type == AllianceBuildType.MilitaryCenterS4 then
          allianceMilitaryCenter = newInfo
        elseif template.type == AllianceBuildType.Carrier then
          allianceCarrier = newInfo
        elseif template.type == AllianceBuildType.Attachment then
          table.insert(allianceMilitaryAttachmentList, newInfo)
        end
      end
    end
    if allianceMilitaryCenter or allianceCarrier then
      DataCenter.AllianceMineManager:FetchFurnaceInfos()
    end
    self.allianceMilitaryAttachmentList = allianceMilitaryAttachmentList
    self.allianceMilitaryCenter = allianceMilitaryCenter
    self.allianceCarrier = allianceCarrier
    self.allianceFlagDic = allianceFlagDic
    self.allianceFlagUuidToId = allianceFlagUuidToId
    self.allianceCenterDic = allianceCenterDic
    self.allianceCenterUuidToId = allianceCenterUuidToId
    self.allianceFrontDic = allianceFrontDic
    self.allianceFrontUuidToId = allianceFrontUuidToId
    self.allianceMineInfoDic = allianceMineInfoDic
    self.allianceActMineInfo = allianceActMineInfo
    self.allianceS0CityFightMineInfo = allianceS0CityFightMineInfo
    EventManager:GetInstance():Broadcast(EventId.AllianceFlagUpdate)
    EventManager:GetInstance():Broadcast(EventId.AllianceCenterUpdate)
    EventManager:GetInstance():Broadcast(EventId.AllianceFrontUpdate)
    EventManager:GetInstance():Broadcast(EventId.AllianceActMineUpdate)
    EventManager:GetInstance():Broadcast(EventId.UpdateAllAllianceMineList)
    EventManager:GetInstance():Broadcast(EventId.UpdateMainAllianceRedCount)
  end
end

function AllianceMineManager:ShowNewBuildEffect(newInfo)
  if not SceneUtils.GetIsInWorld() then
    return
  end
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local pointId = newInfo.pointId
  local serverId = self.curServerId or loginServerId
  local effectPathPut = "Assets/Main/Prefabs/World/Saiji/Eff_saiji_dsj_shengshi_zhanling.prefab"
  local request = ResourceManager:InstantiateAsync(effectPathPut)
  if request then
    request:completed("+", function(req)
      if request.isError then
        return
      end
      if request.gameObject then
        request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
        request.gameObject:SetActive(true)
        request.gameObject.transform.position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, serverId)
      end
    end)
  end
end

function AllianceMineManager:CanShowPlayerBuildList()
  if LuaEntry.Player:AtHomeNow() then
    for k, v in pairs(self.allianceCenterDic) do
      if v and v.status ~= AllianceMineStatus.Build then
        return true
      end
    end
  end
  return false
end

function AllianceMineManager:AddOneAllianceMineInfo(msg)
  if msg then
    local newInfo = AllianceMineData.New()
    newInfo:ParseData(msg)
    local buildId = newInfo.buildId
    if WorldAllianceBuildUtil.IsAllianceCenterFlag(buildId) then
      self.allianceFlagDic[newInfo.buildId] = newInfo
      self.allianceFlagUuidToId[newInfo.uuid] = newInfo.buildId
      EventManager:GetInstance():Broadcast(EventId.AllianceFlagUpdate)
    elseif WorldAllianceBuildUtil.IsAllianceCenterGroup(buildId) then
      self.allianceCenterUuidToId[newInfo.uuid] = newInfo.buildId
      self.allianceCenterDic[newInfo.buildId] = newInfo
      EventManager:GetInstance():Broadcast(EventId.OnUpdateOneAllianceCenter, newInfo.uuid)
    elseif WorldAllianceBuildUtil.IsAllianceFrontGroup(buildId) then
      self.allianceFrontUuidToId[newInfo.uuid] = newInfo.buildId
      self.allianceFrontDic[newInfo.buildId] = newInfo
      EventManager:GetInstance():Broadcast(EventId.OnUpdateOneAllianceFront, newInfo.uuid)
    elseif WorldAllianceBuildUtil.IsAllianceMineGroup(buildId) == true then
      self.allianceMineInfoDic[newInfo.uuid] = newInfo
      EventManager:GetInstance():Broadcast(EventId.OnAddOneAllianceMine, newInfo.uuid)
    elseif WorldAllianceBuildUtil.IsAllianceActMineGroup(buildId) == true then
      self.allianceActMineInfo = newInfo
      EventManager:GetInstance():Broadcast(EventId.AllianceActMineUpdate)
    elseif WorldAllianceBuildUtil.IsAllianceS0DeclareBuild(buildId) == true then
      self.allianceS0CityFightMineInfo = newInfo
    end
    EventManager:GetInstance():Broadcast(EventId.UpdateMainAllianceRedCount)
  end
end

function AllianceMineManager:UpdateMinInfo(data)
  if data ~= nil then
    if WorldAllianceBuildUtil.IsAllianceCenterFlag(data.buildId) then
      self.allianceFlagDic[data.buildId] = data
      self.allianceFlagUuidToId[data.uuid] = data.buildId
      EventManager:GetInstance():Broadcast(EventId.AllianceFlagUpdate)
    elseif WorldAllianceBuildUtil.IsAllianceFrontGroup(data.buildId) then
      self.allianceFrontUuidToId[data.uuid] = data.buildId
      self.allianceFrontDic[data.buildId] = data
    elseif WorldAllianceBuildUtil.IsAllianceCenterGroup(data.buildId) then
      self.allianceCenterUuidToId[data.uuid] = data.buildId
      self.allianceCenterDic[data.buildId] = data
    elseif WorldAllianceBuildUtil.IsAllianceMineGroup(data.buildId) == true then
      self.allianceMineInfoDic[data.uuid] = data
    elseif WorldAllianceBuildUtil.IsAllianceActMineGroup(data.buildId) == true then
      self.allianceActMineInfo = data
    elseif WorldAllianceBuildUtil.IsAllianceS0DeclareBuild(buildId) == true then
      self.allianceS0CityFightMineInfo = data
    end
  end
end

function AllianceMineManager:DelOneAllianceMineInfo(msg)
  if msg and msg.uuid then
    local tempUuid = msg.uuid
    local buildId
    if self.allianceFlagDic and self.allianceFlagUuidToId[tempUuid] ~= nil then
      buildId = self.allianceFlagUuidToId[tempUuid]
      self.allianceFlagDic[buildId] = nil
      self.allianceFlagUuidToId[tempUuid] = nil
      EventManager:GetInstance():Broadcast(EventId.AllianceFlagUpdate)
    elseif self.allianceCenterUuidToId[tempUuid] ~= nil then
      buildId = self.allianceCenterUuidToId[tempUuid]
      self.allianceCenterDic[buildId] = nil
      EventManager:GetInstance():Broadcast(EventId.OnDeleteOneAllianceCenter, tempUuid)
    elseif self.allianceFrontUuidToId[tempUuid] ~= nil then
      buildId = self.allianceFrontUuidToId[tempUuid]
      self.allianceFrontDic[buildId] = nil
      EventManager:GetInstance():Broadcast(EventId.OnDeleteOneAllianceFront, tempUuid)
    elseif self.allianceActMineInfo ~= nil and self.allianceActMineInfo.uuid == tempUuid then
      self.allianceActMineInfo = nil
    elseif self.allianceS0CityFightMineInfo and self.allianceS0CityFightMineInfo.uuid == tempUuid then
      self.allianceS0CityFightMineInfo = nil
    else
      self.allianceMineInfoDic[tempUuid] = nil
      EventManager:GetInstance():Broadcast(EventId.OnDelOneAllianceMine, tempUuid)
    end
    if buildId ~= nil then
      local template = self:GetAllianceMineTemplate(buildId)
      UIUtil.ShowTips(Localization:GetString("season_tips004", Localization:GetString(template.name)))
    end
    EventManager:GetInstance():Broadcast(EventId.UpdateMainAllianceRedCount)
  end
end

function AllianceMineManager:UpdateAlMineScoreChange(t)
  if t.build_alliance_building_point then
    self.selfPoint = t.build_alliance_building_point
  end
end

function AllianceMineManager:GetPoint()
  return self.selfPoint
end

function AllianceMineManager:GetAlMineBuildList()
  self:InitTemplates()
  local myList = {}
  local cacheDic = {}
  local value = table.values(self.alMineTemplateDic)
  table.sort(value, function(a, b)
    return a.id < b.id
  end)
  for i = 1, #value do
    local v = value[i]
    if WorldAllianceBuildUtil.IsAllianceMineGroup(v.id) == true then
      local tempInfo = self:GetMineInfoById(v.id)
      if tempInfo then
        table.insert(myList, v)
      end
      if not cacheDic[v.collectTypeK] then
        if v.level == 1 then
          cacheDic[v.collectTypeK] = v
        end
      elseif self:CheckIfConditionFits(v) and cacheDic[v.collectTypeK].level < v.level then
        cacheDic[v.collectTypeK] = v
      end
    end
  end
  for i, v in pairs(myList) do
    cacheDic[v.collectTypeK] = v
  end
  local list = table.values(cacheDic)
  table.sort(list, function(a, b)
    local aInfo = self:GetMineInfoById()
    local bInfo = self:GetMineInfoById()
    if aInfo ~= nil and bInfo == nil then
      return true
    end
    if aInfo == nil and bInfo ~= nil then
      return false
    end
    return a.id < b.id
  end)
  return list
end

function AllianceMineManager:CanPutAnyAlCenterBuild()
  if CrossServerUtil:GetIsCrossServer() then
    return false
  end
  if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    return false
  end
  self:InitTemplates()
  local allFit, fitDic, mineInfo
  for i, v in pairs(self.alMineTemplateDic) do
    if WorldAllianceBuildUtil.IsAllianceCenterGroup(v.id) == true then
      mineInfo = self:GetAllianceCenterDataByBuildId(v.id)
      if mineInfo == nil then
        allFit, fitDic = self:CheckIfConditionFits(v)
        if allFit then
          return true
        end
      end
    end
  end
  return false
end

function AllianceMineManager:GetAlCenterFlagList()
  local cacheDic = {}
  self:InitTemplates()
  for i, v in pairs(self.alMineTemplateDic) do
    if WorldAllianceBuildUtil.IsAllianceCenterFlag(v.id) then
      cacheDic[v.id] = v
    end
  end
  local list = table.values(cacheDic)
  table.sort(list, function(a, b)
    return a.id < b.id
  end)
  return list
end

function AllianceMineManager:GetAlCenterBuildList()
  local cacheDic = {}
  self:InitTemplates()
  for i, v in pairs(self.alMineTemplateDic) do
    if WorldAllianceBuildUtil.IsAllianceCenterGroup(v.id) == true then
      cacheDic[v.id] = v
    end
  end
  local list = table.values(cacheDic)
  table.sort(list, function(a, b)
    return a.id < b.id
  end)
  return list
end

function AllianceMineManager:GetAlFrontBuildList()
  local cacheDic = {}
  self:InitTemplates()
  for i, v in pairs(self.alMineTemplateDic) do
    if WorldAllianceBuildUtil.IsAllianceFrontGroup(v.id) == true then
      cacheDic[v.id] = v
    end
  end
  local list = table.values(cacheDic)
  table.sort(list, function(a, b)
    return a.id < b.id
  end)
  return list
end

function AllianceMineManager:GetShowRedDotNum()
  local canShowRedDot = false
  if DataCenter.AllianceBaseDataManager:IsR4orR5() and LuaEntry.DataConfig:CheckSwitch("alliance_res_build") == true and table.count(self.allianceMineInfoDic) <= 0 then
    self:InitTemplates()
    for i, v in pairs(self.alMineTemplateDic) do
      if WorldAllianceBuildUtil.IsAllianceMineGroup(v.id) == true and canShowRedDot == false and self:CheckIfConditionFits(v) then
        local tempInfo = self:GetMineInfoById(v.id)
        if tempInfo == nil then
          canShowRedDot = true
        end
      end
    end
  end
  return canShowRedDot
end

function AllianceMineManager:GetShowAllianceCityRedDotNum()
  local canShowRedDot = false
  if DataCenter.AllianceBaseDataManager:IsR4orR5() and SeasonUtil.IsInSeasonDesertMode() then
    self:InitTemplates()
    for i, v in pairs(self.alMineTemplateDic) do
      if WorldAllianceBuildUtil.IsAllianceCenterGroup(v.id) == true and canShowRedDot == false and self:CheckIfConditionFits(v) then
        local tempInfo = self:GetAllianceCenterDataByBuildId(v.id)
        if tempInfo == nil then
          canShowRedDot = true
        end
      end
    end
  end
  return canShowRedDot
end

function AllianceMineManager:GetAllianceMineInfoByUuid(uuid)
  return self.allianceMineInfoDic[uuid]
end

function AllianceMineManager:GetAllianceMineRestSoldierNum(uuid)
  local restNum = 0
  local data = self.allianceMineInfoDic[uuid]
  if data ~= nil then
    restNum = data.soldierMax - data.soldierNum
  end
  return restNum
end

function AllianceMineManager:GetMineInfoById(mineId)
  for i, v in pairs(self.allianceMineInfoDic) do
    if v.buildId == mineId then
      return v
    end
  end
  return nil
end

function AllianceMineManager:GetAllianceCenterDataByBuildId(buildId)
  if self.allianceFlagDic and self.allianceFlagDic[buildId] then
    return self.allianceFlagDic[buildId]
  end
  if self.allianceCenterDic and self.allianceCenterDic[buildId] then
    return self.allianceCenterDic[buildId]
  end
  return nil
end

function AllianceMineManager:GetAllianceFrontDataByBuildId(buildId)
  return self.allianceFrontDic[buildId]
end

function AllianceMineManager:CheckIfHasAllianceCenter()
  return table.count(self.allianceCenterDic)
end

function AllianceMineManager:GetMyAlMines()
  return self.allianceMineInfoDic
end

function AllianceMineManager:CheckIfConditionFits(mineTemplate, condType)
  if condType then
    if WorldAllianceBuildUtil.IsAllianceCenterFlag(mineTemplate.id) == true then
      return true, ""
    end
    return self:GetConditionInfo(mineTemplate, condType)
  else
    if WorldAllianceBuildUtil.IsAllianceCenterFlag(mineTemplate.id) == true then
      return true, {}
    end
    local all_ok = true
    local all_dict = {}
    local desc, ok
    for _, v in pairs(AlMineConditionType) do
      ok, desc = self:GetConditionInfo(mineTemplate, v)
      if not ok then
        all_ok = false
      end
      all_dict[v] = {status = ok, desc = desc}
    end
    return all_ok, all_dict
  end
end

function AllianceMineManager:GetConditionInfo(mineTemplate, ConditionType)
  local desc = ""
  local ok = false
  if WorldAllianceBuildUtil.IsAllianceFrontGroup(mineTemplate.id) == true then
    return ok, desc
  end
  local limit = mineTemplate.conditions[ConditionType]
  if ConditionType == AlMineConditionType.MemberCount then
    if limit ~= nil and 0 < limit then
      local limitMember = 0
      local allianceInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      if allianceInfo then
        limitMember = toInt(allianceInfo.curMember)
      end
      ok = limit <= limitMember
      desc = string.format(Localization:GetString("803044") .. "%s/%s", limitMember, limit)
    else
      ok = true
    end
  elseif ConditionType == AlMineConditionType.Power then
    if limit ~= nil and 0 < limit then
      local allianceInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      if allianceInfo then
        ok = limit <= tonumber(allianceInfo.fightPower)
      end
      desc = Localization:GetString("2000042", string.GetFormattedStr(limit), string.GetFormattedStr(limit))
    else
      ok = true
    end
  elseif ConditionType == AlMineConditionType.RuinLv then
    if limit ~= nil and 0 < limit then
      local myAlCities = DataCenter.WorldAllianceCityDataManager:GetCitiesByAlId(LuaEntry.Player.allianceId)
      if myAlCities ~= nil then
        ok = limit <= table.count(myAlCities)
      end
      desc = Localization:GetString("season_building_UI100", limit)
    else
      ok = true
    end
  elseif ConditionType == AlMineConditionType.PreBuild then
    if limit ~= nil and 0 < limit then
      local build = self:GetAllianceCenterDataByBuildId(limit)
      if build ~= nil and build.status ~= AllianceMineStatus.Build then
        ok = true
      end
      local temp = self:GetAllianceMineTemplate(limit)
      if temp ~= nil then
        local name = Localization:GetString(temp.name)
        local str = Localization:GetString("season_alliance_building_condition_tips002")
        desc = string.format("%s(<i>%s</i>)", str, name)
      end
    else
      ok = true
    end
  elseif ConditionType == AlMineConditionType.CityLevel then
    if limit ~= nil and 0 < limit then
      local ownMaxLv = 0
      local myAlCities = DataCenter.WorldAllianceCityDataManager:GetCitiesByAlId(LuaEntry.Player.allianceId)
      if myAlCities ~= nil then
        for i, v in pairs(myAlCities) do
          local config = DataCenter.AllianceCityTemplateManager:GetTemplate(v)
          if ownMaxLv < config.level then
            ownMaxLv = config.level
          end
        end
      end
      ok = limit <= toInt(ownMaxLv)
      desc = Localization:GetString("803045", limit)
    else
      ok = true
    end
  elseif ConditionType == AlMineConditionType.Trends then
    if mineTemplate.limit_trends ~= nil then
      desc = "\229\137\141\231\189\174\230\157\161\228\187\182\239\188\140\229\164\169\228\184\139\229\164\167\229\138\191"
    end
    ok = true
  elseif ConditionType == AlMineConditionType.Science and mineTemplate.limit_alliance_tec ~= nil then
    local buff_id = mineTemplate.limit_alliance_tec.k
    local science_id = mineTemplate.limit_alliance_tec.science_id
    local info = DataCenter.AllianceScienceTemplateManager:GetAlScienceInfo(science_id)
    if info then
      local result = LuaEntry.Effect:GetGameEffect(buff_id)
      local str1 = Localization:GetString("season_alliance_building_condition_tips001")
      local str2 = Localization:GetString(info.name)
      desc = string.format("%s(<i>%s</i>)", str1, str2)
      ok = result ~= 0
    else
      desc = ""
      ok = true
    end
  end
  return ok, desc
end

function AllianceMineManager:GetAllianceMineSlotCountForConstruct(uuid)
  local mineData = self.allianceMineInfoDic[uuid]
  local retMax = 0
  if mineData ~= nil then
    retMax = mineData.soldierMax - mineData.soldierNum
  end
  return retMax
end

function AllianceMineManager:CheckIfHasMarch(pointId)
  local pointInfo = CS.SceneManager.World:GetPointInfo(pointId)
  if pointInfo then
    local selfMarchList = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
    for _, march in pairs(selfMarchList) do
      if (march:GetMarchTargetType() == MarchTargetType.COLLECT_ALLIANCE_BUILD_RESOURCE or march:GetMarchTargetType() == MarchTargetType.BUILD_ALLIANCE_BUILDING or march:GetMarchTargetType() == MarchTargetType.ASSISTANCE_COLLECT_ACT_ALLIANCE_MINE) and march.targetUuid == pointInfo.uuid and (march:GetMarchStatus() == MarchStatus.COLLECTING or march:GetMarchStatus() == MarchStatus.BUILD_ALLIANCE_BUILDING or march:GetMarchStatus() == MarchStatus.COLLECTING_ASSISTANCE) then
        return true, march
      end
    end
  end
  return false
end

function AllianceMineManager:GetAllianceMineTemplate(templateId)
  local theId = toInt(templateId)
  local ret = self.fullTemplateDic[theId]
  if ret == nil and 0 < theId then
    self:InitTemplates()
  end
  return self.fullTemplateDic[theId]
end

function AllianceMineManager:GetAllianceFlagData()
  return self.allianceFlagDic
end

function AllianceMineManager:ExistAllianceFlagInServer(serverId)
  local nServerId = toInt(serverId)
  if self.ActCrossAttackDesertInfo then
    for i, v in ipairs(self.ActCrossAttackDesertInfo) do
      if v and v.serverId == nServerId then
        return true
      end
    end
  end
  if self.allianceFlagDic then
    for i, v in pairs(self.allianceFlagDic) do
      if v and v.curServerId == nServerId then
        return true
      end
    end
  end
  return false
end

function AllianceMineManager:GetAllianceActMineInfo()
  return self.allianceActMineInfo
end

function AllianceMineManager:GetAllianceS0CityFightDecalreMineInfo()
  return self.allianceS0CityFightMineInfo
end

function AllianceMineManager:GetAlCenterByPointIndex(pointId)
  if self.allianceMilitaryCenter and self.allianceMilitaryCenter.pointId == pointId then
    return self.allianceMilitaryCenter
  end
  if self.allianceCarrier and self.allianceCarrier.pointId == pointId then
    return self.allianceCarrier
  end
  if self.allianceFlagDic then
    for _, v in pairs(self.allianceFlagDic) do
      if v and v.pointId == pointId then
        return v
      end
    end
  end
  if self.allianceCenterDic then
    for _, v in pairs(self.allianceCenterDic) do
      if v and v.pointId == pointId then
        return v
      end
    end
  end
  return nil
end

function AllianceMineManager:GetAllianceFlagPlaceTime()
  local count = self.allianceFlagPlaceTime
  if self.allianceFlagDic ~= nil then
    count = count + 1
  end
  return count
end

function AllianceMineManager:GetAllianceFlagDestroyTime()
  return self.allianceFlagDestroyStartTime
end

function AllianceMineManager:RefreshAllianceFlagTime(message)
  if message.placeTime ~= nil then
    self.allianceFlagPlaceTime = message.placeTime
  end
  if message.destroyTime ~= nil then
    self.allianceFlagDestroyStartTime = message.destroyTime
  end
  EventManager:GetInstance():Broadcast(EventId.AllianceFlagUpdate)
end

function AllianceMineManager:RefreshAllianceFrontTime(message)
  self.allianceFrontDestroyStartTime = {}
  if message.timeArr ~= nil then
    local arr = message.timeArr
    for k, v in pairs(arr) do
      local buildId = v.buildId
      local destroyTime = v.destroyTime
      if buildId ~= nil and destroyTime ~= nil and 0 < destroyTime then
        self.allianceFrontDestroyStartTime[buildId] = destroyTime
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.AllianceFrontUpdate)
end

function AllianceMineManager:GetAllianceFrontDestroyStartTime(buildId)
  return self.allianceFrontDestroyStartTime[buildId]
end

function AllianceMineManager:IsPointInAllianceCenterRange(pointId, allianceCenterId)
  if pointId == nil or pointId <= 0 then
    return false
  end
  local allianceCenterData = DataCenter.AllianceMineManager:GetAllianceCenterDataByBuildId(allianceCenterId)
  if allianceCenterData ~= nil and allianceCenterData.status ~= AllianceMineStatus.Build then
    local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(allianceCenterData.buildId)
    if template ~= nil then
      local size = template.offter_range
      local posV2 = allianceCenterData.posV2
      local targetV2 = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
      local distanceX = math.abs(posV2.x - targetV2.x + 1)
      local distanceY = math.abs(posV2.y - targetV2.y + 1)
      if size >= distanceX and size >= distanceY then
        return true
      end
    end
  end
  return false
end

function AllianceMineManager:FetchFurnaceInfos()
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.furnaceInfos ~= nil and self.furnaceInfosLastTime ~= nil and now - self.furnaceInfosLastTime < 3000 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.GetStoveCenterInfo)
end

function AllianceMineManager:UpdateFurnaceInfos(furnaceInfos)
  if furnaceInfos then
    local open_cd = LuaEntry.DataConfig:TryGetNum("s2_alliance_center", "k2", 10) * 60000
    local overload_cd = LuaEntry.DataConfig:TryGetNum("s2_alliance_center", "k3", 10) * 60000
    local coal_donate_limit = LuaEntry.DataConfig:TryGetNum("s2_alliance_center", "k4", 20)
    for k, v in ipairs(furnaceInfos) do
      if v then
        if v.openTime and v.openTime ~= 0 then
          v.openTimeNext = v.openTime + open_cd
        end
        if v.overLoadTime and v.overLoadTime ~= 0 then
          v.overLoadTimeNext = v.overLoadTime + overload_cd
        end
        v.coal_donate_limit = coal_donate_limit or 20
      end
    end
    self.furnaceInfos = furnaceInfos
    self.furnaceInfosLastTime = UITimeManager:GetInstance():GetServerTime()
    EventManager:GetInstance():DelayBroadcast(1, EventId.AllianceStoveCenterUpdate)
  end
end

function AllianceMineManager:GetAllianceStoveCenter()
  return self.allianceMilitaryCenter
end

function AllianceMineManager:GetAllianceCenterAttachmentList()
  return self.allianceMilitaryAttachmentList
end

function AllianceMineManager:IsAllianceCenterHasProduce()
  if self.militaryCenterBuildInfos == nil or self.allianceMilitaryAttachmentList == nil then
    return false
  end
  local buildInfos = self.militaryCenterBuildInfos
  if buildInfos == nil or buildInfos.info == nil then
    return false
  end
  for _, buildData in pairs(self.allianceMilitaryAttachmentList) do
    if buildData.buildId and buildData.level and buildData.status == AllianceMineStatus.Normal and not buildData:Injuried() then
      for k, v in pairs(buildInfos.info) do
        if v and v.buildId == buildData.buildId and toInt(v.num) > 0 then
          return true
        end
      end
    end
  end
  return false
end

function AllianceMineManager:GetAllianceStoveCenterStatus()
  local ret
  if self.allianceMilitaryCenter and self.furnaceInfos then
    local uuid = self.allianceMilitaryCenter.uuid
    for k, v in pairs(self.furnaceInfos) do
      if v.buildingUuid == uuid then
        ret = v
      end
    end
  end
  return ret
end

function AllianceMineManager:GetAllianceStoveCenterCarrier()
  return self.allianceCarrier
end

function AllianceMineManager:SetActMineResNum(message)
  if message.res ~= nil then
    self.actMineRes = message.res
  end
end

function AllianceMineManager:SetAllianceActMember(message)
  if message.member ~= nil then
    self.allianceActMemberNum = message.member
  end
end

function AllianceMineManager:GetAllianceActMember()
  return self.allianceActMemberNum
end

function AllianceMineManager:GetActMineResNum()
  return self.actMineRes
end

function AllianceMineManager:SetBuildIdActive(buildId, cool_down)
  self.theActiveBuildId = buildId
  self.theActiveBuildCD = cool_down
end

function AllianceMineManager:GetLastActiveBuildInfo()
  return self.theActiveBuildId, self.theActiveBuildCD
end

return AllianceMineManager
