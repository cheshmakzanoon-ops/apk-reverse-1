local UIFireworkGiftRecordCtrl = BaseClass("UIFireworkGiftRecordCtrl", UIBaseCtrl)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIFireworkGiftRecordCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFireworkGiftRecord)
end

return UIFireworkGiftRecordCtrl
