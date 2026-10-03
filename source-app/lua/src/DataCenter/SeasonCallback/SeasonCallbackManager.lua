local SeasonCallbackManager = BaseClass("SeasonCallbackManager")
local SeasonCallbackData = require("DataCenter.SeasonCallback.SeasonCallbackData")
local SeasonCallbackEffectObj = require("DataCenter.SeasonCallback.SeasonCallbackEffectObj")

function SeasonCallbackManager:__init()
  self.activityId = nil
  self.map = nil
  self.thumbs = nil
  self.thumbsInit = nil
  self.cityAllEffect = {}
  self.valueCache = {}
  self._queryTimeCache = {}
  self:AddListener()
end

function SeasonCallbackManager:__delete()
  self.activityId = nil
  self.map = nil
  self.thumbs = nil
  self.thumbsInit = nil
  for i, effect in pairs(self.cityAllEffect) do
    if effect then
      effect:Delete()
      effect = nil
    end
  end
  self.cityAllEffect = nil
  self.valueCache = nil
  self._queryTimeCache = nil
  self:RemoveListener()
  self:ClearReplaceRecord()
end

function SeasonCallbackManager:Startup()
end

function SeasonCallbackManager:AddListener()
  EventManager:GetInstance():AddListenerWithSelf(EventId.UserSkinUpdate, self.OnUserSkinUpdate, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.BUILD_IN_VIEW, self.OnCityBuildInView, self)
  EventManager:GetInstance():AddListenerWithSelf(EventId.BUILD_OUT_VIEW, self.OnCityBuildOutView, self)
end

function SeasonCallbackManager:RemoveListener()
  EventManager:GetInstance():RemoveListener2(EventId.UserSkinUpdate, self.OnUserSkinUpdate, self)
  EventManager:GetInstance():RemoveListener2(EventId.BUILD_IN_VIEW, self.OnCityBuildInView, self)
  EventManager:GetInstance():RemoveListener2(EventId.BUILD_OUT_VIEW, self.OnCityBuildOutView, self)
  EventManager:GetInstance():RemoveListener2(EventId.OnEnterWorld, self.UpdatePrefabReplace, self)
  EventManager:GetInstance():RemoveListener2(EventId.OnEnterCity, self.UpdatePrefabReplace, self)
end

function SeasonCallbackManager:InitData(data)
  local isSeasonActivity, isSeasonPreActivity = DataCenter.SeasonDataManager:IsActivityForSeason(data.id)
  if isSeasonPreActivity ~= SeasonUtil.IsInSeasonPrepareMode() then
    return
  end
  self.activityId = data.id
  self:InitMap()
  self:ClearReplaceRecord()
  self:CheckPrefabReplace()
end

function SeasonCallbackManager:GetConfigData(configId)
end

function SeasonCallbackManager:GetConfigDataByServerId(serverId)
end

function SeasonCallbackManager:GetConfigDataByCallbackId(callbackType, callbackId, checkOpen_, includePrepare_)
  if not (callbackType and callbackId) or not self.map then
    return
  end
  local group = self:GetActivityGroup(includePrepare_)
  callbackId = tonumber(callbackId)
  for k, v in pairs(self.map) do
    if group == v.group and callbackType == v.type and (not checkOpen_ or v:IsOpen()) then
      for i = 1, #v.callback_id_list do
        if v.callback_id_list[i] == callbackId then
          return v
        end
      end
    end
  end
end

function SeasonCallbackManager:IsActive(includePrepare)
  return SeasonUtil.IsSeasonActivityOpen(self.activityId, nil, includePrepare)
end

function SeasonCallbackManager:GetActivityData(includePrepare)
  if not self:IsActive(includePrepare) then
    return
  end
  return DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
end

function SeasonCallbackManager:GetActivityGroup(includePrepare)
  local activityData = self:GetActivityData(includePrepare)
  if not activityData then
    return
  end
  return activityData.para and tonumber(activityData.para) or 0
end

function SeasonCallbackManager:GetFirstData(callbackType, group_)
  if not self.map then
    return
  end
  group_ = group_ or self:GetActivityGroup()
  for k, v in pairs(self.map) do
    if group_ == v.group and callbackType == v.type then
      return v
    end
  end
end

function SeasonCallbackManager:InitMap()
  local activityData = self:GetActivityData(true)
  if activityData == nil or activityData.subActArr == nil then
    return
  end
  self.map = {}
  for i = 1, #activityData.subActArr do
    local netData = activityData.subActArr[i]
    local id = netData.subActId
    local line = id and LocalController:instance():getLine(TableName.SeasonCallback, id)
    if line then
      local data = self.map[id]
      if data == nil then
        data = SeasonCallbackData.New(line, netData)
        self.map[id] = data
      end
      data:UpdateData(netData)
    else
      Logger.LogError("SeasonCallbackManager:GetSeasonCallbackList error, subActId is nil, subActId = " .. id)
    end
  end
end

function SeasonCallbackManager:GetSeasonCallbackList()
  local result = {}
  local index = 1
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local nextTime = 0
  if self.map then
    for k, v in pairs(self.map) do
      if curTime >= v.startTime and curTime <= v.endTime then
        result[index] = v
        index = index + 1
      elseif curTime < v.startTime and (nextTime == 0 or nextTime > v.startTime) then
        nextTime = v.startTime
      end
    end
    table.sort(result, function(a, b)
      return a.priority > b.priority
    end)
  end
  return result, nextTime
end

function SeasonCallbackManager:HasView()
  if not self.activityId then
    return false
  end
  local key = string.format("SeasonCallbackView_%s_%s", self.activityId, SeasonUtil.GetSeasonId())
  return Setting:GetPrivateBool(key, false)
end

function SeasonCallbackManager:SetView()
  if not self.activityId or self:HasView() then
    return
  end
  local key = string.format("SeasonCallbackView_%s_%s", self.activityId, SeasonUtil.GetSeasonId())
  Setting:SetPrivateBool(key, true)
end

function SeasonCallbackManager:TryQueryCallbackValue()
  if not self.map then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  for k, v in pairs(self.map) do
    if v.type == SeasonCallbackType.SystemBuff then
      local effectId = tonumber(v.effect)
      if effectId then
        local lastTime = self._queryTimeCache[effectId] or 0
        if 10000 <= curTime - lastTime then
          self._queryTimeCache[effectId] = curTime
          if effectId == SeasonCallbackSpecialEffect.PvpSoldierDeathReduce then
            SFSNetwork.SendMessage(MsgDefines.QuerySeasonCallbackPvpReduceNum)
          end
        end
      end
    end
  end
end

function SeasonCallbackManager:SetCallbackData(effectId, data)
  self.valueCache[effectId] = data
  EventManager:GetInstance():Broadcast(EventId.SeasonCallbackValueChange)
end

function SeasonCallbackManager:GetCallbackData(callbackData)
  local effectId = callbackData and tonumber(callbackData.effect)
  if not effectId then
    return nil
  end
  return self.valueCache[effectId]
end

function SeasonCallbackManager:GetCallbackDescValue(callbackData)
  if not callbackData then
    return 0
  end
  local data = self:GetCallbackData(callbackData)
  local effectId = tonumber(callbackData.effect)
  if callbackData.type == SeasonCallbackType.SystemBuff and effectId == SeasonCallbackSpecialEffect.PvpSoldierDeathReduce then
    local total = 0
    if data then
      for i = 1, #data do
        local item = data[i]
        if item and item.count then
          total = total + item.count
        end
      end
    end
    return total
  end
  return 0
end

function SeasonCallbackManager:TryQueryThumbsMessage()
  local activityData = self:GetActivityData()
  local activityId = activityData and activityData.id
  if not activityId then
    return
  end
  if self.thumbsInit and self.thumbsInit[activityId] then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.QueryThumbs, activityId)
end

function SeasonCallbackManager:OnQueryThumbsInfoUpdate(activityId)
  if self.thumbsInit == nil then
    self.thumbsInit = {}
  end
  self.thumbsInit[activityId] = true
end

function SeasonCallbackManager:SetThumbsInfo(record, activityId)
  if record == nil then
    return
  end
  if self.thumbs == nil then
    self.thumbs = {}
  end
  local data = self.thumbs[activityId]
  if data == nil then
    data = {}
    self.thumbs[activityId] = data
  end
  data[record] = true
end

function SeasonCallbackManager:IfShowThumbsInfo(targetUid, skinId)
  local activityData = self:GetActivityData()
  local activityId = activityData and activityData.id
  if not activityId then
    return false
  end
  if self.thumbsInit == nil then
    return false
  end
  local data = self:GetConfigDataByCallbackId(SeasonCallbackType.Base, skinId)
  if data == nil then
    return false
  end
  local dic = self.thumbs and self.thumbs[activityId]
  if dic == nil then
    return true, data
  end
  if dic[targetUid] then
    return false
  end
  return true, data
end

local function GetBuildModelByPointId(pointId)
  if not CS.SceneManager.World then
    return
  end
  return CS.SceneManager.World:GetBuildingByPoint(pointId)
end

function SeasonCallbackManager:OnCityBuildInView(bUuid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(bUuid)
  if buildData.itemId == BuildingTypes.FUN_BUILD_MAIN then
    if buildData:IsUpgradeFinish() then
      return
    end
    local skinId = DataCenter.DecorationDataManager:GetCurrentSkinByType(DecorationType.DecorationType_Main_City)
    local template = DataCenter.DecorationTemplateManager:GetTemplate(skinId)
    if template == nil then
      return
    end
    local seasonData = self:GetConfigDataByCallbackId(SeasonCallbackType.Base, skinId)
    self:CityBuildUpdate(bUuid, buildData, seasonData)
    return
  end
  if buildData:GetIsDecorate() then
    local seasonData = self:GetConfigDataByCallbackId(SeasonCallbackType.Decoration, buildData.itemId)
    self:CityBuildUpdate(bUuid, buildData, seasonData)
    return
  end
end

function SeasonCallbackManager:CityBuildUpdate(bUuid, buildData, seasonData)
  if not seasonData then
    self:OnBuildOutView(bUuid, self.cityAllEffect)
    return
  end
  local cityObj = GetBuildModelByPointId(buildData.pointId)
  if cityObj == nil then
    return
  end
  local effectObj = self.cityAllEffect[bUuid]
  if effectObj then
    effectObj:SetData(bUuid, cityObj, seasonData.callback_show, seasonData.callback_show_offset)
  else
    self.cityAllEffect[bUuid] = SeasonCallbackEffectObj.New()
    self.cityAllEffect[bUuid]:SetData(bUuid, cityObj, seasonData.callback_show, seasonData.callback_show_offset)
  end
end

function SeasonCallbackManager:OnCityBuildOutView(bUuid)
  self:OnBuildOutView(bUuid, self.cityAllEffect)
end

function SeasonCallbackManager:OnUserSkinUpdate(type)
  if type == DecorationType.DecorationType_Main_City then
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
    local self = DataCenter.BuildEffectManager
    self.OnCityBuildInView(buildData.uuid)
  end
end

function SeasonCallbackManager:OnBuildOutView(bUuid, dic)
  if dic[bUuid] then
    dic[bUuid]:Delete()
    dic[bUuid] = nil
  end
end

function SeasonCallbackManager:CheckPrefabReplace()
  if not self.map or not self:IsActive() then
    return
  end
  local group = self:GetActivityGroup()
  for k, v in pairs(self.map) do
    if group == v.group and SeasonCallbackType.Decoration == v.type and v.callback_id_list[1] and not string.IsNullOrEmpty(v.callback_model) then
      if v:IsOpen() then
        self:ReplaceDecoration(v, v.callback_id_list[1], v.callback_model)
      else
        self:ResetDecoration(v.callback_id_list[1])
      end
    end
  end
  if self.replaceRecord then
    EventManager:GetInstance():RemoveListener2(EventId.OnEnterWorld, self.UpdatePrefabReplace, self)
    EventManager:GetInstance():AddListenerWithSelf(EventId.OnEnterWorld, self.UpdatePrefabReplace, self)
    EventManager:GetInstance():RemoveListener2(EventId.OnEnterCity, self.UpdatePrefabReplace, self)
    EventManager:GetInstance():AddListenerWithSelf(EventId.OnEnterCity, self.UpdatePrefabReplace, self)
  end
end

function SeasonCallbackManager:GetReplaceRecord(decorationId)
  return self.replaceRecord and self.replaceRecord[decorationId]
end

function SeasonCallbackManager:ClearReplaceRecord()
  if self.replaceRecord then
    for k, v in pairs(self.replaceRecord) do
      self:ResetDecoration(k)
    end
    self.replaceRecord = nil
  end
end

function SeasonCallbackManager:UpdatePrefabReplace()
  if self.replaceRecord == nil then
    return
  end
  local removeList
  for k, v in pairs(self.replaceRecord) do
    if not v.callbackData:IsOpen() then
      if removeList == nil then
        removeList = {}
      end
      table.insert(removeList, k)
    end
  end
  if removeList then
    for i = 1, #removeList do
      self:ResetDecoration(removeList[i])
    end
  end
end

function SeasonCallbackManager:ReplaceDecoration(callbackData, decorationId, model)
  if self.replaceRecord == nil then
    self.replaceRecord = {}
  elseif self.replaceRecord[decorationId] then
    return
  end
  self.replaceRecord[decorationId] = {callbackData = callbackData, model = model}
end

function SeasonCallbackManager:ResetDecoration(decorationId)
  if self.replaceRecord == nil or not self.replaceRecord[decorationId] then
    return
  end
  self.replaceRecord[decorationId] = nil
end

function SeasonCallbackManager:GetAllActiveEffects()
  if not self.map then
    return nil
  end
  local result
  local group = self:GetActivityGroup()
  for _, v in pairs(self.map) do
    if group == v.group then
      if not string.IsNullOrEmpty(v.effect) and v:IsEffectWearActive() then
        if result == nil then
          result = {}
        end
        table.insert(result, {
          effect = v.effect,
          effect_num = v.effect_num
        })
      end
      if not string.IsNullOrEmpty(v.effect_gain) and v:IsEffectGainActive() then
        if result == nil then
          result = {}
        end
        table.insert(result, {
          effect = v.effect_gain,
          effect_num = v.effect_gain_num
        })
      end
    end
  end
  return result
end

return SeasonCallbackManager
