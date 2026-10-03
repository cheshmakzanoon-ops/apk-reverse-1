local UILWActDetectEventTreasureClaimInfoCtrl = BaseClass("UILWActDetectEventTreasureClaimInfoCtrl", UIBaseCtrl)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UILWActDetectEventTreasureClaimInfoCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWActDetectEventTreasureClaimInfo)
end

return UILWActDetectEventTreasureClaimInfoCtrl
