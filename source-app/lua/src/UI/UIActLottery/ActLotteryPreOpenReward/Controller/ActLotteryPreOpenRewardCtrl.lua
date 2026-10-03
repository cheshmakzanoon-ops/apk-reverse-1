local ActLotteryPreOpenRewardCtrl = BaseClass("ActLotteryPreOpenRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.ActLotteryPreOpenReward)
end

local function OnCustomKeyCodeEscape(self)
end

ActLotteryPreOpenRewardCtrl.CloseSelf = CloseSelf
ActLotteryPreOpenRewardCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
return ActLotteryPreOpenRewardCtrl
