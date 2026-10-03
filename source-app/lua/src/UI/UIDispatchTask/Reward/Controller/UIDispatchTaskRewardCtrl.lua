local UIDispatchTaskRewardCtrl = BaseClass("UIDispatchTaskRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDispatchTaskReward, {anim = false})
end

UIDispatchTaskRewardCtrl.CloseSelf = CloseSelf
return UIDispatchTaskRewardCtrl
