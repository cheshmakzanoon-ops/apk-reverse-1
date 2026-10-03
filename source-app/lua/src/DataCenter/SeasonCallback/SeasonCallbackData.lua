local SeasonCallbackData = BaseClass("SeasonCallbackData")

function SeasonCallbackData:__init(info, netData)
  self.id = info.id
  self.group = info:getValue("group")
  self.priority = info:getValue("priority")
  self.type = info:getValue("type")
  self.name = info:getValue("name")
  self.desc = info:getValue("desc")
  self.desc_1 = info:getValue("desc_1")
  self.desc_2 = info:getValue("desc_2")
  self.activity_show = info:getValue("activity_show")
  self.icon = info:getValue("icon")
  self.icon_name = info:getValue("icon_name")
  self.error_tips = info:getValue("error_tips")
  self.banner = info:getValue("banner")
  self.like_reward_tips = info:getValue("like_reward_tips")
  self.callback_model = info:getValue("callback_model")
  self.effect = info:getValue("effect")
  self.effect_num = info:getValue("effect_num")
  self.effect_gain = info:getValue("effect_gain")
  self.effect_gain_num = info:getValue("effect_gain_num")
  local callback_id = info:getValue("callback_id")
  self.callback_id_list = {}
  if type(callback_id) == "string" then
    local list = string.split(callback_id, "|")
    if list then
      for i, v in pairs(list) do
        self.callback_id_list[i] = toInt(v)
      end
    end
  end
  self.callback_show = info:getValue("callback_show")
  local offset = info:getValue("callback_show_offset")
  self.callback_show_offset = {}
  if offset and type(offset) == "string" then
    local list = string.split(offset, ",")
    if list then
      self.callback_show_offset.x = list[1] and tonumber(list[1])
      self.callback_show_offset.y = list[2] and tonumber(list[2])
      self.callback_show_offset.z = list[3] and tonumber(list[3])
    end
  end
end

function SeasonCallbackData:UpdateData(netData)
  local activitySeasonData = DataCenter.SeasonCallbackManager:GetActivityData(true)
  self.startTime = netData.showStartTime or netData.startTime
  self.endTime = activitySeasonData and activitySeasonData.endTime
end

function SeasonCallbackData:IsOpen()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.startTime and curTime < self.startTime then
    return false
  end
  if self.endTime and curTime > self.endTime then
    return false
  end
  return true
end

function SeasonCallbackData:GetFirstCallbackId()
  return self.callback_id_list[1]
end

function SeasonCallbackData:IsEffectGainActive()
  if not self:IsOpen() then
    return false
  end
  if self.type == SeasonCallbackType.Base then
    local skinId = self.callback_id_list[1]
    if not skinId then
      return false
    end
    return DataCenter.DecorationDataManager:IsUnlock(skinId)
  end
  if self.type == SeasonCallbackType.Drone then
    local skinId = self.callback_id_list[1]
    if not skinId then
      return false
    end
    return DataCenter.DecorationDataManager:IsUnlock(skinId)
  end
  if self.type == SeasonCallbackType.Decoration then
    local itemId = self.callback_id_list[1]
    if not itemId then
      return false
    end
    local list = DataCenter.BuildManager:GetFunbuildListByItemID(itemId)
    return list ~= nil and table.count(list) > 0
  end
  return true
end

function SeasonCallbackData:IsEffectWearActive()
  if not self:IsOpen() then
    return false
  end
  if self.type == SeasonCallbackType.Base then
    local skinId = self.callback_id_list[1]
    if not skinId then
      return false
    end
    local curSkinId = DataCenter.DecorationDataManager:GetCurrentSkinByType(DecorationType.DecorationType_Main_City)
    return curSkinId == skinId
  end
  if self.type == SeasonCallbackType.Drone then
    local skinId = self.callback_id_list[1]
    if not skinId then
      return false
    end
    local curSkinId = DataCenter.DecorationDataManager:GetCurrentSkinByType(DecorationType.DecorationType_TacticalWeapon)
    return curSkinId == skinId
  end
  if self.type == SeasonCallbackType.Decoration then
    local itemId = self.callback_id_list[1]
    if not itemId then
      return false
    end
    return DataCenter.BuildManager:GetFunbuildByItemID(itemId) ~= nil
  end
  return true
end

return SeasonCallbackData
