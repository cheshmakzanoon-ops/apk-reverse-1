local LWBaseCheckActivityTip = require("UI.LWMainUI.Controller.ActivityTip.LWBaseCheckActivityTip")
local LWDefaultCheckActivityTip = BaseClass("LWDefaultCheckActivityTip", LWBaseCheckActivityTip)
local Localization = CS.GameEntry.Localization

function LWDefaultCheckActivityTip:CheckIsShowTip()
  local isDataInit = true
  local tipTxt, jumpAction
  local dataInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if dataInfo then
    local isShowed = Setting:GetBool(SettingKeys.DEFAULT_ACTIVITY_TIP_PRE .. self.activityId .. dataInfo.startTime, false)
    if not isShowed then
      Setting:SetBool(SettingKeys.DEFAULT_ACTIVITY_TIP_PRE .. self.activityId .. dataInfo.startTime, true)
      tipTxt = Localization:GetString(dataInfo.activity_tips)
      
      function jumpAction()
        GoToUtil.GotoOpenView(UIWindowNames.UIActivityCenterTable, {anim = true}, self.activityId)
      end
    end
  end
  return isDataInit, tipTxt, jumpAction
end

return LWDefaultCheckActivityTip
