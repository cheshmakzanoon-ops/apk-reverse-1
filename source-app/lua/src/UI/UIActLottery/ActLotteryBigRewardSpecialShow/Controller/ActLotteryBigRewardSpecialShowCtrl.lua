local ActLotteryBigRewardSpecialShowCtrl = BaseClass("ActLotteryBigRewardSpecialShowCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.ActLotteryBigRewardSpecialShow)
end

local function OnCustomKeyCodeEscape(self)
end

ActLotteryBigRewardSpecialShowCtrl.CloseSelf = CloseSelf
ActLotteryBigRewardSpecialShowCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
return ActLotteryBigRewardSpecialShowCtrl
