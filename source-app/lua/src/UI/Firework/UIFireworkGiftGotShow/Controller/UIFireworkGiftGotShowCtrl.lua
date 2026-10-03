local UIFireworkGiftGotShowCtrl = BaseClass("UIFireworkGiftGotShowCtrl", UIBaseCtrl)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIFireworkGiftGotShowCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFireworkGiftGotShow)
end

return UIFireworkGiftGotShowCtrl
