local LWBaseCheckActivityTip = require("UI.LWMainUI.Controller.ActivityTip.LWBaseCheckActivityTip")
local LWDesertBattleCheckActivityTip = BaseClass("LWDesertBattleCheckActivityTip", LWBaseCheckActivityTip)

function LWDesertBattleCheckActivityTip:CheckIsShowTip()
  local isDataInit = true
  local tipTxt, jumpAction
  if LuaEntry.Player:IsInAlliance() then
    tipTxt = DataCenter.ActDragonManager:CheckGotoTipStatus()
    if tipTxt == "" then
      isDataInit = false
    end
    if tipTxt ~= nil and tipTxt ~= "" then
      function jumpAction()
        RaceEntranceUtil.GotoOpenView(EnumActivity.ActDragon.Type)
      end
    end
  end
  return isDataInit, tipTxt, jumpAction
end

return LWDesertBattleCheckActivityTip
