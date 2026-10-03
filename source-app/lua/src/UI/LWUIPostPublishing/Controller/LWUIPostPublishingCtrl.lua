local LWUIPostPublishingCtrl = BaseClass("LWUIPostPublishingCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIPostPublishing, {anim = true})
end

LWUIPostPublishingCtrl.CloseSelf = CloseSelf
return LWUIPostPublishingCtrl
