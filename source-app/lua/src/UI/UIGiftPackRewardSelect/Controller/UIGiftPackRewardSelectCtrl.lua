local UIGiftPackRewardSelectCtrl = BaseClass("UIGiftPackRewardSelectCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function UIGiftPackRewardSelectCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGiftPackRewardSelect)
end

return UIGiftPackRewardSelectCtrl
