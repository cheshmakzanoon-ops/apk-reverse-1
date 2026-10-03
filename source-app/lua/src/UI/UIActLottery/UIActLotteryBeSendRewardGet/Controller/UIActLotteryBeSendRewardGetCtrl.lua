local UIActLotteryBeSendRewardGetCtrl = BaseClass("UIActLotteryBeSendRewardGetCtrl", UIBaseCtrl)

local function CloseSelf(self, useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActLotteryBeSendRewardGet, {anim = true})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIActLotteryBeSendRewardGetCtrl.CloseSelf = CloseSelf
UIActLotteryBeSendRewardGetCtrl.Close = Close
return UIActLotteryBeSendRewardGetCtrl
