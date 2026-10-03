local base = require("UI.UIGiftPackageRewardGet.Controller.UIGiftPackageRewardGetCtrl")
local UIGiftPackageOnlyRewardGetCtrl = BaseClass("UIGiftPackageRewardGetCtrl", base)

local function CloseSelf(self)
  self:ClearParam()
  UIManager.Instance:DestroyWindow(UIWindowNames.UIGiftPackageOnlyRewardGet)
  EventManager:GetInstance():Broadcast(EventId.ActGolloesCardFlipAll, 1)
end

UIGiftPackageOnlyRewardGetCtrl.CloseSelf = CloseSelf
return UIGiftPackageOnlyRewardGetCtrl
