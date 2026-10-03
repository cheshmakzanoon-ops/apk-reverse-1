local UIRecruitLotteryTipCtrl = BaseClass("UIRecruitLotteryTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIRecruitLotteryTip, {anim = false, playEffect = false})
end

UIRecruitLotteryTipCtrl.CloseSelf = CloseSelf
return UIRecruitLotteryTipCtrl
