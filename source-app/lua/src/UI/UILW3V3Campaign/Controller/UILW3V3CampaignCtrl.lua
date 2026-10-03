local UILW3V3CampaignCtrl = BaseClass("UILW3V3CampaignCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILW3V3Campaign)
end

function UILW3V3CampaignCtrl:OnCustomKeyCodeEscape()
  if not CS.SceneManager.IsInPVE() then
    local showMessage = "400097"
    UIUtil.ShowMessage(Localization:GetString(showMessage), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UIArena3V3BattleResult, {anim = false})
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UILW3V3Campaign)
      DataCenter.LWPVPArenaManager.ShowPVPArenaMain(PVPArenaType.Arena3V3, nil)
    end, nil, nil)
  end
end

UILW3V3CampaignCtrl.CloseSelf = CloseSelf
return UILW3V3CampaignCtrl
