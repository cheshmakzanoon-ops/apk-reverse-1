local LWPopupManager = BaseClass("LWPopupManager", CEventable)
local LWPopupBaseData = require("DataCenter.LoginPopManager.LWPopupBaseData")
local LWPopupActivityData = require("DataCenter.LoginPopManager.LWPopupActivityData")

function LWPopupManager:__init()
  self.needShowPopupNotificationList = {}
  self.isDirtyPopupNotificationList = false
  self.needShowPopupActivityList = {}
  self.isDirtyPopupActivityList = false
  self:RegisterEvent(EventId.OnUnDelayPassDay, self.OnPassDay)
end

function LWPopupManager:__delete()
  self.popupNotificationCfgDict = nil
  self.needShowPopupNotificationList = nil
  self.isDirtyPopupNotificationList = nil
  self.popupNotificationMaxShowCount = nil
  self.needShowPopupActivityList = nil
  self.popupActivityCfgDict = nil
  self.isDirtyPopupActivityList = nil
end

function LWPopupManager:OnPassDay()
  self:ClearPopupNotificationByPassDay()
  self:ClearPopupActivityByPassDay()
end

function LWPopupManager:IsFunctionOnNewPopupStyle()
  local isFunctionOn = LuaEntry.DataConfig:CheckSwitch("login_popup")
  return isFunctionOn
end

function LWPopupManager:CheckIsValidTime(startTimeList, endTimeList)
  local curSeason = SeasonUtil.GetSeason()
  local curSeasonDay = SeasonUtil.GetSeasonDay()
  local isStart, isEnd = false, true
  if startTimeList and #startTimeList == 2 then
    isStart = curSeason > startTimeList[1] or startTimeList[1] == curSeason and curSeasonDay >= startTimeList[2]
  end
  if endTimeList and #endTimeList == 2 then
    isEnd = curSeason > endTimeList[1] or endTimeList[1] == curSeason and curSeasonDay > endTimeList[2]
  end
  local isValid = isStart and not isEnd
  return isValid
end

function LWPopupManager:GetPopupNotificationMaxShowCount()
  if self.popupNotificationMaxShowCount == nil then
    self.popupNotificationMaxShowCount = LuaEntry.DataConfig:TryGetNum("login_popup_notification", "k1")
  end
  return self.popupNotificationMaxShowCount
end

function LWPopupManager:GetPopupNotificationCfgByType(popupNotificationType)
  if self.popupNotificationCfgDict == nil then
    self.popupNotificationCfgDict = {}
    local cfgTbl = LocalController:instance():getTable(TableName.LW_LOGIN_POPUP_NOTIFICATION)
    for id, _ in pairs(cfgTbl.data) do
      local cfg = LocalController:instance():getLine(TableName.LW_LOGIN_POPUP_NOTIFICATION, id)
      self.popupNotificationCfgDict[cfg.para] = cfg
    end
  end
  local cfg = self.popupNotificationCfgDict[popupNotificationType]
  return cfg
end

function LWPopupManager:TryAddPopupNotification(popupNotificationType, popupParam)
  local cfg = self:GetPopupNotificationCfgByType(popupNotificationType)
  if cfg == nil then
    return false, cfg
  end
  local isValid = self:CheckIsValidTime(cfg.start_time, cfg.end_time)
  if isValid then
    local isExist = self:IsExistPopupNotificationData(popupNotificationType, popupParam)
    if isExist then
      return
    end
    local popupData = LWPopupBaseData.New()
    popupData:InitData(popupNotificationType, popupParam, cfg.clear_type, cfg.priority, cfg.icon)
    table.insert(self.needShowPopupNotificationList, popupData)
    self.isDirtyPopupNotificationList = true
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshMainUIPopupNotificationView)
  end
end

function LWPopupManager:ClearPopupNotificationByClick(popupNotificationType)
  for i = #self.needShowPopupNotificationList, 1, -1 do
    local popupData = self.needShowPopupNotificationList[i]
    if popupData and popupData.popupType == popupNotificationType then
      local isClear = popupData:CheckCanClear(PopupCleanType.Click)
      if isClear then
        table.remove(self.needShowPopupNotificationList, i)
        EventManager:GetInstance():Broadcast(EventId.RefreshMainUIPopupNotificationView)
        break
      end
    end
  end
end

function LWPopupManager:ClearPopupNotificationByPassDay()
  for i = #self.needShowPopupNotificationList, 1, -1 do
    local popupData = self.needShowPopupNotificationList[i]
    if popupData then
      local isClear = popupData:CheckCanClear(PopupCleanType.PassDay)
      if isClear then
        popupData:MarkSuccessSeeData()
        table.remove(self.needShowPopupNotificationList, i)
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshMainUIPopupNotificationView)
end

function LWPopupManager:GetPopupNotificationList()
  if self.isDirtyPopupNotificationList then
    self.isDirtyPopupNotificationList = false
    table.sort(self.needShowPopupNotificationList, function(a, b)
      return a.priority > b.priority
    end)
  end
  return self.needShowPopupNotificationList
end

function LWPopupManager:IsExistPopupNotificationData(popupNotificationType, popupParam)
  if self.needShowPopupNotificationList then
    for i = 1, #self.needShowPopupNotificationList do
      local popupActivityData = self.needShowPopupNotificationList[i]
      if popupActivityData.popupType == popupNotificationType then
        return true
      end
    end
  end
  return false
end

function LWPopupManager:GetPopupActivityCfgByType(popupActivityType)
  if self.popupActivityCfgDict == nil then
    self.popupActivityCfgDict = {}
    local cfgTbl = LocalController:instance():getTable(TableName.LW_LOGIN_POPUP_ACTIVITY)
    for id, _ in pairs(cfgTbl.data) do
      local cfg = LocalController:instance():getLine(TableName.LW_LOGIN_POPUP_ACTIVITY, id)
      self.popupActivityCfgDict[cfg.activity_type] = cfg
    end
  end
  local cfg = self.popupActivityCfgDict[popupActivityType]
  return cfg
end

function LWPopupManager:TryAddPopupActivity(popupActivityType, popupParam)
  local cfg = self:GetPopupActivityCfgByType(popupActivityType)
  if cfg == nil then
    return
  end
  local isValid = self:CheckIsValidTime(cfg.start_time, cfg.end_time)
  if isValid then
    local isExist = self:IsExistPopupActivityData(popupActivityType, popupParam)
    if isExist then
      return
    end
    local popupData = LWPopupActivityData.New()
    popupData:InitData(popupActivityType, popupParam, cfg.clear_type, cfg.priority, cfg.icon, cfg)
    table.insert(self.needShowPopupActivityList, popupData)
    self.isDirtyPopupActivityList = true
    EventManager:GetInstance():BroadcastDeferred(EventId.RefreshPopupActivityView)
  end
end

function LWPopupManager:ClearPopupActivityByClick(popupActivityType)
  for i = #self.needShowPopupActivityList, 1, -1 do
    local popupData = self.needShowPopupActivityList[i]
    if popupData and popupData.popupType == popupActivityType then
      local isClear = popupData:CheckCanClear(PopupCleanType.Click)
      if isClear then
        popupData:MarkSuccessSeeData()
        table.remove(self.needShowPopupActivityList, i)
        EventManager:GetInstance():Broadcast(EventId.RefreshPopupActivityView)
        break
      end
    end
  end
end

function LWPopupManager:ClearPopupActivityByPassDay()
  for i = #self.needShowPopupActivityList, 1, -1 do
    local popupData = self.needShowPopupActivityList[i]
    if popupData then
      local isClear = popupData:CheckCanClear(PopupCleanType.PassDay)
      if isClear then
        popupData:MarkSuccessSeeData()
        table.remove(self.needShowPopupActivityList, i)
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshPopupActivityView)
end

function LWPopupManager:GetPopupActivityList()
  if self.isDirtyPopupActivityList then
    self.isDirtyPopupActivityList = false
    table.sort(self.needShowPopupActivityList, function(a, b)
      return a.priority > b.priority
    end)
  end
  return self.needShowPopupActivityList
end

function LWPopupManager:IsExistPopupActivityData(popupActivityType, popupParam)
  if self.needShowPopupActivityList then
    for i = 1, #self.needShowPopupActivityList do
      local popupActivityData = self.needShowPopupActivityList[i]
      if popupActivityData.popupType == popupActivityType then
        return true
      end
    end
  end
  return false
end

return LWPopupManager
