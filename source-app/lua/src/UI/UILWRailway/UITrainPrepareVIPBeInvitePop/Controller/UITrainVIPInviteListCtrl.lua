local UITrainVIPBeInvitedPopCtrl = BaseClass("UITrainVIPBeInvitedPopCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITrainVIPBeInvitedPop)
end

UITrainVIPBeInvitedPopCtrl.CloseSelf = CloseSelf
return UITrainVIPBeInvitedPopCtrl
