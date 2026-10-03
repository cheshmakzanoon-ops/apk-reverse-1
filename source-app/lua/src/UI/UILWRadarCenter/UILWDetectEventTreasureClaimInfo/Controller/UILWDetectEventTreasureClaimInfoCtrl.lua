local UILWDetectEventTreasureClaimInfoCtrl = BaseClass("UILWDetectEventTreasureClaimInfoCtrl", UIBaseCtrl)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UILWDetectEventTreasureClaimInfoCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWDetectEventTreasureClaimInfo)
end

return UILWDetectEventTreasureClaimInfoCtrl
