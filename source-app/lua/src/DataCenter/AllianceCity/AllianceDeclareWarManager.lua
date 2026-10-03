local AllianceDeclareWarManager = BaseClass("AllianceDeclareWarManager")
local alarmKeyPre = "CityFightAlarm"
local alarmMainTopBeforeStartTime = 180000
local alarmFullScreenBeforeStartTime = 10000

function AllianceDeclareWarManager:__init()
  self.list = {}
  self.listCross = {}
  self.bubbleUuid = 0
  self.tipUuid = 0
  self.isNew = true
  self.declareTimes = 0
  self.cityParam = {}
  self.__delayTimer = nil
  UpdateManager:GetInstance():AddUpdate(self.OnUpdate)
end

function AllianceDeclareWarManager:__delete()
  UpdateManager:GetInstance():RemoveUpdate(self.OnUpdate)
  self.bubbleUuid = nil
  self.tipUuid = 0
  self.isNew = nil
  self.cityParam = nil
  self.alarmDeclareInfo = nil
  if self.__delayTimer ~= nil then
    self.__delayTimer:Stop()
    self.__delayTimer = nil
  end
end

function AllianceDeclareWarManager:InitSend()
  SFSNetwork.SendMessage(MsgDefines.AllianceDeclareWarGet)
end

function AllianceDeclareWarManager:Init(message)
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  self.list = {}
  self.listCross = {}
  if message then
    local seasonType = SeasonUtil.GetSeasonType()
    for k, v in pairs(message) do
      if v then
        if seasonType == SeasonMapType.NineNation then
          table.insert(self.list, v)
          table.insert(self.listCross, v)
        elseif v.serverId == nil or v.serverId == loginServerId then
          table.insert(self.list, v)
        else
          table.insert(self.listCross, v)
        end
      end
    end
  end
  self.k6 = self:GetConfigData("k6")
  self.isNew = self:GetSelfDeclareWarData()
  self:OnDeclareInfoChanged()
  EventManager:GetInstance():Broadcast(EventId.DeclareWar)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  self:CheckSetAlarmDeclareWar()
  self:OnDeclareInfoChanged()
end

function AllianceDeclareWarManager:GetConfigData(key)
  if SeasonUtil.IsInSeason() then
    local theType = SeasonUtil.GetSeasonType()
    if theType == SeasonMapType.NineNation then
      return LuaEntry.DataConfig:TryGetNum("season_new_s5_city", key)
    end
    if theType == SeasonMapType.Darkness then
      return LuaEntry.DataConfig:TryGetNum("season_new_s4_city", key)
    end
    if theType == SeasonMapType.Mummy then
      return LuaEntry.DataConfig:TryGetNum("season_new_s3_city", key)
    end
    if theType == SeasonMapType.Snow then
      return LuaEntry.DataConfig:TryGetNum("season_new_s2_city", key)
    end
    if theType == SeasonMapType.CityStronghold then
      return LuaEntry.DataConfig:TryGetNum("season_new_s1_city", key)
    end
    if theType == SeasonMapType.Desert then
      return LuaEntry.DataConfig:TryGetNum("lw_season_alliance_declare_war", key)
    end
  end
  return LuaEntry.DataConfig:TryGetNum("alliance_declare_war", key)
end

function AllianceDeclareWarManager:CheckIsCanDeclare(message)
  if message.allianceCityDeclareTimes then
    self.declareTimes = message.allianceCityDeclareTimes
    if self.cityParam then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldDeclareWar, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, self.cityParam.cityId, self.cityParam.pointId, self.cityParam.uuid, self.cityParam.serverId)
      self.cityParam = nil
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshCityDeclareCount)
  end
end

function AllianceDeclareWarManager:SetWarCityParam(param)
  self.cityParam = param
end

function AllianceDeclareWarManager:GetDeclareTime()
  return self.declareTimes
end

function AllianceDeclareWarManager:CheckSetAlarmDeclareWar()
  self.alarmDeclareInfo = self:GetSelfAlarmDeclareWarData()
  if self.alarmDeclareInfo then
    self.alarmDeclareTop = true
    self.alarmDeclareFullScreen = true
  else
    self.alarmDeclareTop = false
    self.alarmDeclareFullScreen = false
  end
end

function AllianceDeclareWarManager:CreateWar(message)
  table.insert(self.list, message)
  self:SetWarState(true)
  local cityId = toInt(message.content)
  local serverId = toInt(message.serverId or LuaEntry.Player:GetSelfServerId())
  local cityData = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, serverId)
  local cityLoc = string.split(cityData.location, "|")
  local v2 = Vector2.New(tonumber(cityLoc[1]), tonumber(cityLoc[2]))
  local worldPos = SceneUtils.TileToWorld(v2)
  worldPos.x = worldPos.x
  worldPos.z = worldPos.z
  local posIndex = SceneUtils.WorldToTileIndex(worldPos)
  local str = string.SubStr(message.anno, 1, 25)
  str = str .. "..."
  DataCenter.WorldFavoDataManager:TryAddAllianceMask(posIndex * 10 + 1, LuaEntry.Player:GetCurServerId(), MarkType.Alliance_Attack, str)
  local cityInfo = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(cityId, serverId)
  if cityInfo ~= nil then
    local allianceId = cityInfo.aId or cityInfo.allianceId
    if not string.IsNullOrEmpty(allianceId) then
      EventManager:GetInstance():Broadcast(EventId.MakeWorldColorDirty, allianceId)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.DeclareWar)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  EventManager:GetInstance():Broadcast(EventId.SendAllianceDeclareWar, {
    cityId = cityData.id,
    pointId = posIndex
  })
  self:CheckSetAlarmDeclareWar()
  self:OnDeclareInfoChanged()
end

function AllianceDeclareWarManager:DeleteWar(message)
  local allianceInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  for i = 1, #self.list do
    local theInfo = self.list[i]
    if theInfo and theInfo.uuid == message.uuid then
      if theInfo.aId == allianceInfo.uid then
        self:SetWarState(false)
        self.bubbleUuid = 0
        self.tipUuid = 0
        local cityId = toInt(theInfo.content)
        local serverId = toInt(theInfo.serverId or LuaEntry.Player:GetSelfServerId())
        local cityInfo = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(cityId, serverId)
        if cityInfo ~= nil then
          local allianceId = cityInfo.aId or cityInfo.allianceId
          if not string.IsNullOrEmpty(allianceId) then
            EventManager:GetInstance():Broadcast(EventId.MakeWorldColorDirty, allianceId)
          end
        end
      else
        local cityId = toInt(theInfo.content)
        local cityInfo = DataCenter.WorldAllianceCityDataManager:GetMyAlCityInfo(cityId)
        if cityInfo ~= nil then
          EventManager:GetInstance():Broadcast(EventId.MakeWorldColorDirty, theInfo.aId)
        end
      end
      table.remove(self.list, i)
      break
    end
  end
  DataCenter.AllianceWarEventDataManager:PullWarEventData()
  EventManager:GetInstance():Broadcast(EventId.DeclareWar)
  DataCenter.WorldFavoDataManager:TryDelAllianceMask(MarkType.Alliance_Attack)
  self:CheckSetAlarmDeclareWar()
end

function AllianceDeclareWarManager:OnDeclareInfoChanged()
  if self.__delayTimer ~= nil then
    self.__delayTimer:Stop()
    self.__delayTimer = nil
  end
  local declareInfo = self:GetSelfDeclareWarData()
  if declareInfo and declareInfo.uuid and self.tipUuid ~= declareInfo.uuid then
    self.tipUuid = declareInfo.uuid
  end
  if declareInfo and declareInfo.content then
    local protectTime = DataCenter.WorldAllianceCityDataManager:GetCityProtectTime(tonumber(declareInfo.content))
    local now = UITimeManager:GetInstance():GetServerTime()
    if protectTime > now then
      local delay = math.modf((protectTime - now) / 1000)
      self.__delayTimer = TimerManager:GetInstance():DelayInvoke(function()
        DataCenter.ActivityTipsManager:Enqueue(MainUITipCondition.CityWar)
        EventManager:GetInstance():Broadcast(EventId.DeclareWar_InfoChanged)
        self.__delayTimer = nil
      end, delay)
      EventManager:GetInstance():Broadcast(EventId.DeclareWar_InfoChanged)
    else
      DataCenter.ActivityTipsManager:Enqueue(MainUITipCondition.CityWar)
      EventManager:GetInstance():Broadcast(EventId.DeclareWar_InfoChanged)
    end
  else
    EventManager:GetInstance():Broadcast(EventId.DeclareWar_InfoChanged)
  end
end

function AllianceDeclareWarManager:IsDeclareWarStart()
  local declareInfo = self:GetSelfDeclareWarData()
  if declareInfo and declareInfo.content then
    local protectTime = DataCenter.WorldAllianceCityDataManager:GetCityProtectTime(tonumber(declareInfo.content))
    local now = UITimeManager:GetInstance():GetServerTime()
    if protectTime <= now and now < declareInfo.et then
      return true
    end
  end
  return false
end

function AllianceDeclareWarManager:GetAllianceDeclareWarData()
  return self.list
end

function AllianceDeclareWarManager:GetWarDataByCityId(cityId)
  local list = {}
  for i = 1, #self.list do
    if self.list[i].content == tostring(cityId) then
      table.insert(list, self.list[i])
    end
  end
  return list
end

function AllianceDeclareWarManager:GetSelfDeclareWarData()
  local seasonType = SeasonUtil.GetSeasonType()
  local alId = LuaEntry.Player:GetAllianceUid()
  for i = 1, #self.list do
    if self.list[i].aId == alId then
      return self.list[i]
    end
  end
  if seasonType == SeasonMapType.NineNation and self.listCross ~= nil then
    for i = 1, #self.listCross do
      if self.listCross[i].aId == alId then
        return self.listCross[i]
      end
    end
  end
  return nil
end

function AllianceDeclareWarManager:GetSelfBeDeclareWarData()
  local alId = LuaEntry.Player:GetAllianceUid()
  local CrossOccupyCityList = DataCenter.SeasonDataManager.CrossOccupyCityList or {}
  local beDeclareWar = {}
  for _, data in ipairs(self.list) do
    if data and data.aId ~= alId then
      local cityId = toInt(data.content)
      local cityInfo = DataCenter.WorldAllianceCityDataManager:GetMyAlCityInfo(cityId)
      if cityInfo ~= nil then
        table.insert(beDeclareWar, data)
      end
    end
  end
  for _, data in ipairs(self.listCross) do
    if data and data.aId ~= alId then
      local cityId = toInt(data.content)
      local serverId = toInt(data.serverId)
      for _, v in pairs(CrossOccupyCityList) do
        if toInt(v.cityId) == cityId and toInt(v.serverId) == serverId then
          table.insert(beDeclareWar, data)
        end
      end
    end
  end
  return beDeclareWar
end

function AllianceDeclareWarManager:GetSelfAlarmDeclareWarData()
  local selfDeclareWarData = self:GetSelfDeclareWarData()
  if selfDeclareWarData then
    local cityId = selfDeclareWarData.content
    local cityConfig = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
    local cityLevel = cityConfig.level
    local alarmKey = alarmKeyPre .. cityLevel
    local hasAlarmed = CommonUtil.PlayerPrefsGetBool(alarmKey, false)
    local protectTime = DataCenter.WorldAllianceCityDataManager:GetCityProtectTime(tonumber(cityId))
    local now = UITimeManager:GetInstance():GetServerTime()
    local inProtectTime = protectTime > now
    if inProtectTime and not hasAlarmed then
      return selfDeclareWarData
    end
  end
  return nil
end

function AllianceDeclareWarManager:GetAlDeclareWarData(alId)
  for i = 1, #self.list do
    if self.list[i].aId == alId then
      return self.list[i]
    end
  end
  return nil
end

function AllianceDeclareWarManager:IsSelfDeclare(cityId)
  local myData = self:GetSelfDeclareWarData()
  return myData and tonumber(myData.content) == cityId
end

function AllianceDeclareWarManager:CheckWarIsNew()
  if self.isNew then
    return true
  end
  return false
end

function AllianceDeclareWarManager:SetWarState(state)
  self.isNew = state
end

function AllianceDeclareWarManager:CheckIsShowBubble()
  local data = self:GetSelfDeclareWarData()
  if data then
    if self.bubbleUuid == nil or self.bubbleUuid == 0 then
      self.bubbleUuid = data.uuid
      return true
    elseif self.bubbleUuid == data.uuid then
      return false
    end
  end
  return false
end

function AllianceDeclareWarManager:GetDeclareState()
  local declareInfo = self:GetSelfDeclareWarData()
  return self:GetDeclareStateByDeclareInfo(declareInfo)
end

function AllianceDeclareWarManager:GetDeclareStateByDeclareInfo(declareInfo)
  if declareInfo and declareInfo.content then
    local protectTime = DataCenter.WorldAllianceCityDataManager:GetCityProtectTime(tonumber(declareInfo.content))
    local now = UITimeManager:GetInstance():GetServerTime()
    if protectTime > now then
      return DeclareWarState.PreDeclare, declareInfo
    else
      return DeclareWarState.Formal, declareInfo
    end
  end
  return DeclareWarState.None, declareInfo
end

function AllianceDeclareWarManager:GetDeclareStateByCityId(cityId)
  local declareInfo
  for i = 1, #self.list do
    if self.list[i].content == tostring(cityId) then
      declareInfo = self.list[i]
      break
    end
  end
  return self:GetDeclareStateByDeclareInfo(declareInfo)
end

function AllianceDeclareWarManager:GetRandomComrade()
end

function AllianceDeclareWarManager:GetFormalDeclareTsByAlliId(allianceId)
  local declareInfo
  for i = 1, #self.list do
    if self.list[i].aId == allianceId then
      declareInfo = self.list[i]
      break
    end
  end
  if not declareInfo then
    return 0
  end
  local protectTime = DataCenter.WorldAllianceCityDataManager:GetCityProtectTime(tonumber(declareInfo.content))
  return protectTime
end

function AllianceDeclareWarManager:GetCityPointIdByAlliId(allianceId)
  local declareInfo
  for i = 1, #self.list do
    if self.list[i].aId == allianceId then
      declareInfo = self.list[i]
      break
    end
  end
  if not declareInfo then
    return 0
  end
  local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(tonumber(declareInfo.content))
  return cityMeta:GetPointId()
end

function AllianceDeclareWarManager:CanPreDeclare()
  return not DataCenter.ActivityListDataManager:CheckIfActivityOpen(EnumActivity.SeasonCrossDeclareWarActivity.Type)
end

function AllianceDeclareWarManager.OnUpdate()
  local self = DataCenter.AllianceDeclareWarManager
  if self.alarmDeclareInfo then
    local cityId = self.alarmDeclareInfo.content
    local protectTime = DataCenter.WorldAllianceCityDataManager:GetCityProtectTime(tonumber(cityId))
    local now = UITimeManager:GetInstance():GetServerTime()
    if self.alarmDeclareTop and protectTime < now + alarmMainTopBeforeStartTime then
      self.alarmDeclareTop = false
      EventManager:GetInstance():Broadcast(EventId.CityFightAlarm)
    end
    if self.alarmDeclareFullScreen and protectTime < now + alarmFullScreenBeforeStartTime then
      self.alarmDeclareFullScreen = false
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWCityFightCountTimeToGo)
    end
    if protectTime < now then
      local cityConfig = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
      local cityLevel = cityConfig.level
      local alarmKey = alarmKeyPre .. cityLevel
      CommonUtil.PlayerPrefsSetBool(alarmKey, true)
      self.alarmDeclareInfo = nil
    end
  end
end

function AllianceDeclareWarManager:CanAttackStronghold(serverId, level)
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType == SeasonMapType.NineNation and serverId ~= LuaEntry.Player:GetSourceServerId() then
    local declareActivity = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonCrossDeclareWarActivity.Type)
    if declareActivity ~= nil then
      local levelMin = checknumber(declareActivity.para_3)
      if level < levelMin then
        return false
      end
    end
  end
  return true
end

function AllianceDeclareWarManager:CanDeclareCity(serverId, level)
  local seasonType = SeasonUtil.GetSeasonType()
  if seasonType == SeasonMapType.NineNation and serverId ~= LuaEntry.Player:GetSourceServerId() then
    local declareActivity = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonCrossDeclareWarActivity.Type)
    if declareActivity ~= nil then
      local levelMin = checknumber(declareActivity.para_4)
      if level < levelMin then
        return false
      end
    end
  end
  return true
end

return AllianceDeclareWarManager
