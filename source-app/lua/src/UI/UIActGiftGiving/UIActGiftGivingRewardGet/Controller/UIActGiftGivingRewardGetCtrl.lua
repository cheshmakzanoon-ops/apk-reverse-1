local UIActGiftGivingRewardGetCtrl = BaseClass("UIActGiftGivingRewardGetCtrl", UIBaseCtrl)

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActGiftGivingRewardGet, {anim = useAnimation})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIActGiftGivingRewardGetCtrl.CloseSelf = CloseSelf
UIActGiftGivingRewardGetCtrl.Close = Close
return UIActGiftGivingRewardGetCtrl
