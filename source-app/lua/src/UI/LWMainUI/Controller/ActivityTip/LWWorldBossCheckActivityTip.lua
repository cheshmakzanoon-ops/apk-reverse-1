local LWBaseCheckActivityTip = require("UI.LWMainUI.Controller.ActivityTip.LWBaseCheckActivityTip")
local LWWorldBossCheckActivityTip = BaseClass("LWWorldBossCheckActivityTip", LWBaseCheckActivityTip)
local Localization = CS.GameEntry.Localization

function LWWorldBossCheckActivityTip:CheckIsShowTip()
  local isDataInit = true
  local tipTxt, jumpAction
  local need = DataCenter.ActBossDataManager:IsNeedMainUIShowTip()
  if need and DataCenter.ActBossDataManager.activityId ~= nil then
    tipTxt = Localization:GetString("456057", DataCenter.ActBossDataManager.bossName)
    
    function jumpAction()
      GoToUtil.GotoOpenView(UIWindowNames.UIActivityCenterTable, {anim = true}, DataCenter.ActBossDataManager.activityId)
    end
    
    DataCenter.ActBossDataManager.needMainUIShowTip = false
  end
  return isDataInit, tipTxt, jumpAction
end

return LWWorldBossCheckActivityTip
