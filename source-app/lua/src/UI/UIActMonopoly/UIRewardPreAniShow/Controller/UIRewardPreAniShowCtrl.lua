local UIRewardPreAniShowCtrl = BaseClass("UIRewardPreAniShowCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIRewardPreAniShow)
end

UIRewardPreAniShowCtrl.CloseSelf = CloseSelf
return UIRewardPreAniShowCtrl
