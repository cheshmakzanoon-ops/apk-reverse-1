local UILWActDetectEventTreasureClaimInfoNewCtrl = BaseClass("UILWActDetectEventTreasureClaimInfoNewCtrl", UIBaseCtrl)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UILWActDetectEventTreasureClaimInfoNewCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWActDetectEventTreasureClaimInfoNew)
end

return UILWActDetectEventTreasureClaimInfoNewCtrl
