local CommonShowBubbleTipCtrl = BaseClass("CommonShowBubbleTipCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWCommonShowBubbleTip, {anim = true})
end

CommonShowBubbleTipCtrl.CloseSelf = CloseSelf
return CommonShowBubbleTipCtrl
