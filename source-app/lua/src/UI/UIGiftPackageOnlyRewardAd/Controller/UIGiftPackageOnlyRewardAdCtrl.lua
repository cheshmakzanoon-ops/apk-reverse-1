local base = require("UI.UIGiftPackageRewardGet.Controller.UIGiftPackageRewardGetCtrl")
local UIGiftPackageOnlyRewardAdCtrl = BaseClass("UIGiftPackageOnlyRewardAdCtrl", base)

local function CloseSelf(self)
  self:ClearParam()
  UIManager.Instance:DestroyWindow(UIWindowNames.UIGiftPackageOnlyRewardAd)
  EventManager:GetInstance():Broadcast(EventId.ActGolloesCardFlipAll, 1)
end

local function OnCustomKeyCodeEscape(self)
  EventManager:GetInstance():Broadcast(EventId.OnRewardGetPanelClose)
  self:CloseSelf()
end

UIGiftPackageOnlyRewardAdCtrl.CloseSelf = CloseSelf
UIGiftPackageOnlyRewardAdCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
return UIGiftPackageOnlyRewardAdCtrl
