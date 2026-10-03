local SecondConfirmManager = BaseClass("SecondConfirmManager")

local function __init(self)
end

local function __delete(self)
end

local LOG_TODAY_TYPES = {
  [TodayNoSecondConfirmType.UpgradeUseDiamond] = true,
  [TodayNoSecondConfirmType.BuildingFinishRemindConfirm] = true
}
local LOG_TODAY_POST_TYPES = {
  [TodayNoSecondConfirmType.MoveCityInBlackTip] = true
}

local function GetTodayCanShowSecondConfirm(self, showType)
  local time = Setting:GetPrivateString(showType, "")
  if time ~= "" then
    return not UITimeManager:GetInstance():IsSameDayForServer(tonumber(time), UITimeManager:GetInstance():GetServerSeconds())
  end
  return true
end

local function SetTodayNoShowSecondConfirm(self, showType, isNoShow)
  if isNoShow then
    Setting:SetPrivateString(showType, "")
  else
    Setting:SetPrivateString(showType, tostring(UITimeManager:GetInstance():GetServerSeconds()))
  end
  if LOG_TODAY_TYPES[showType] and not isNoShow then
    Logger.LogInfo("[SetTodayNoShowSecondConfirm] showType: " .. showType .. ", remind: " .. tostring(isNoShow))
  end
  if LOG_TODAY_POST_TYPES[showType] then
    PostEventLog.Track(PostEventLog.Defines.c_black_land_alert_off, {
      flag = isNoShow and 0 or 1
    })
  end
end

SecondConfirmManager.__init = __init
SecondConfirmManager.__delete = __delete
SecondConfirmManager.GetTodayCanShowSecondConfirm = GetTodayCanShowSecondConfirm
SecondConfirmManager.SetTodayNoShowSecondConfirm = SetTodayNoShowSecondConfirm
return SecondConfirmManager
