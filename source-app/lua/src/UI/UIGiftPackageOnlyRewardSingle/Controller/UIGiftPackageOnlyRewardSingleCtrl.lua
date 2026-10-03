local base = require("UI.UIGiftPackageRewardGet.Controller.UIGiftPackageRewardGetCtrl")
local UIGiftPackageOnlyRewardSingleCtrl = BaseClass("UIGiftPackageOnlyRewardSingleCtrl", base)

local function CloseSelf(self)
  self:ClearParam()
  UIManager.Instance:DestroyWindow(UIWindowNames.UIGiftPackageOnlyRewardSingle)
  EventManager:GetInstance():Broadcast(EventId.ActGolloesCardFlipAll, 1)
end

UIGiftPackageOnlyRewardSingleCtrl.CloseSelf = CloseSelf
return UIGiftPackageOnlyRewardSingleCtrl
