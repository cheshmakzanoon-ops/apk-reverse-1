local UITrainVIPInviteConfirmPopCtrl = BaseClass("UITrainVIPInviteConfirmPopCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITrainVIPInviteConfirmPop)
end

UITrainVIPInviteConfirmPopCtrl.CloseSelf = CloseSelf
return UITrainVIPInviteConfirmPopCtrl
