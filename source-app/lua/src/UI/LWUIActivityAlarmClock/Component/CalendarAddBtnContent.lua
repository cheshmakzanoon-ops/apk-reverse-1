local base = UIBaseContainer
local CalendarAddBtnContent = BaseClass("CalendarAddBtnContent", base)
local Localization = CS.GameEntry.Localization
local StringUtils = CS.StringUtils
local add_btn_path = "AddBtn"
local targetVersion = "1.0.310"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.add_btn = self:AddComponent(UIButton, add_btn_path)
  self.add_btn:SetOnClick(function()
    self:OnAddBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.add_btn = nil
end

local function DataDefine(self)
  self.isShow = false
  self.title = ""
  self.location = ""
  self.startTime = 0
  self.endTime = 0
  self.haveAlarm = 0
  self.alarmTime = 0
  self.cfgId = 0
  self.sourcePath = ""
end

local function DataDestroy(self)
  self.isShow = nil
  self.title = nil
  self.location = nil
  self.startTime = nil
  self.endTime = nil
  self.haveAlarm = nil
  self.alarmTime = nil
  self.cfgId = nil
  self.sourcePath = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, title, location, startTime, endTime, haveAlarm, alarmTime, calendarItemExternalIdentifier, cfgId, sourcePath)
  self.title = title
  self.location = location
  self.startTime = startTime
  self.endTime = endTime
  self.haveAlarm = haveAlarm
  self.alarmTime = alarmTime
  self.calendarItemExternalIdentifier = calendarItemExternalIdentifier
  if cfgId and 0 < cfgId then
    self.cfgId = cfgId
  else
    self.cfgId = 0
  end
  if sourcePath then
    self.sourcePath = sourcePath
  else
    self.sourcePath = ""
  end
  self.isShow = self:IsCanShow()
  self.add_btn:SetActive(self.isShow)
end

local function SetTitleData(self, title)
  self.title = title
end

local function SetDataWithDefautValue(self, cfgId, startTime, endTime, sourcePath)
  local title = ""
  local location = ""
  local alarmTime = -600
  local haveAlarm = 1
  local calendarItemExternalIdentifier = Localization:GetString("lastwar_name")
  if cfgId and 0 < cfgId then
    local line = LocalController:instance():getLine(TableName.Calendar, cfgId)
    if line then
      title = Localization:GetString(line.content)
    end
  end
  self:SetData(title, location, startTime, endTime, haveAlarm, alarmTime, calendarItemExternalIdentifier, cfgId, sourcePath)
end

local function IsCanShow(self)
  local isCanShow = true
  if not self.ConfigServerIsOpen() then
    isCanShow = false
    return isCanShow
  end
  if self.startTime <= 0 or 0 >= self.endTime then
    isCanShow = false
    return isCanShow
  end
  if 0 > StringUtils.VersionCompare(CS.GameEntry.Sdk.Version, targetVersion) then
    isCanShow = false
    return isCanShow
  end
  if not self.IsOnAndroidOrIOS() then
    isCanShow = false
    return isCanShow
  end
  return isCanShow
end

function CalendarAddBtnContent.ConfigServerIsOpen()
  local k1 = LuaEntry.DataConfig:TryGetNum("calendar_test_set", "k1")
  local selfServerId = LuaEntry.Player:GetSourceServerId()
  if CS.NetworkURLConfig.IsPressureTest then
    if k1 == 1 then
      if selfServerId <= 46 then
        return true
      end
    elseif k1 == 2 then
      return true
    end
  elseif k1 == 1 then
    if selfServerId <= 68 then
      return true
    end
  elseif k1 == 2 then
    return true
  end
  return false
end

local function OnAddBtnClick(self)
  if not self.isShow then
    return
  end
  UIUtil.ShowMessage(Localization:GetString("calendar_tips1"), 2, nil, nil, function()
    CS.GameEntry.Sdk:AddCalendarEvent(self.title, self.location, self.startTime, self.endTime, self.haveAlarm, self.alarmTime, self.calendarItemExternalIdentifier, self.cfgId, self.sourcePath)
  end, nil, nil)
end

local function IsOnAndroidOrIOS()
  return (CS.SDKManager.IS_UNITY_ANDROID() or CS.SDKManager.IS_UNITY_IOS()) and not CS.SDKManager.IS_UNITY_EDITOR()
end

CalendarAddBtnContent.OnCreate = OnCreate
CalendarAddBtnContent.OnDestroy = OnDestroy
CalendarAddBtnContent.OnEnable = OnEnable
CalendarAddBtnContent.OnDisable = OnDisable
CalendarAddBtnContent.ComponentDefine = ComponentDefine
CalendarAddBtnContent.ComponentDestroy = ComponentDestroy
CalendarAddBtnContent.DataDefine = DataDefine
CalendarAddBtnContent.DataDestroy = DataDestroy
CalendarAddBtnContent.OnAddListener = OnAddListener
CalendarAddBtnContent.OnRemoveListener = OnRemoveListener
CalendarAddBtnContent.SetData = SetData
CalendarAddBtnContent.SetDataWithDefautValue = SetDataWithDefautValue
CalendarAddBtnContent.SetTitleData = SetTitleData
CalendarAddBtnContent.IsCanShow = IsCanShow
CalendarAddBtnContent.OnAddBtnClick = OnAddBtnClick
CalendarAddBtnContent.IsOnAndroidOrIOS = IsOnAndroidOrIOS
return CalendarAddBtnContent
