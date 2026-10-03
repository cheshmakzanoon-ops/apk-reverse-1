local UIActLotteryBigRewardOpenCtrl = BaseClass("UIActLotteryBigRewardOpenCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActLotteryBigRewardOpen)
end

local function OnCustomKeyCodeEscape(self)
end

UIActLotteryBigRewardOpenCtrl.CloseSelf = CloseSelf
UIActLotteryBigRewardOpenCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
return UIActLotteryBigRewardOpenCtrl
