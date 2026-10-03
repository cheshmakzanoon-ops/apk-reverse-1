local LWBaseCheckActivityTip = require("UI.LWMainUI.Controller.ActivityTip.LWBaseCheckActivityTip")
local LWAllyDrillCheckActivityTip = BaseClass("LWAllyDrillCheckActivityTip", LWBaseCheckActivityTip)
local Localization = CS.GameEntry.Localization

function LWAllyDrillCheckActivityTip:CheckIsShowTip()
  local isDataInit = true
  local tipTxt, jumpAction
  local need = DataCenter.AllyDrillDataManager:IsNeedMainUIShowTip()
  if need then
    tipTxt = Localization:GetString(2010388)
    
    function jumpAction()
      DataCenter.AllyDrillDataManager:JumpToDrill()
    end
    
    DataCenter.AllyDrillDataManager:SetNeedMainUIShowTip(false)
  end
  return isDataInit, tipTxt, jumpAction
end

return LWAllyDrillCheckActivityTip
