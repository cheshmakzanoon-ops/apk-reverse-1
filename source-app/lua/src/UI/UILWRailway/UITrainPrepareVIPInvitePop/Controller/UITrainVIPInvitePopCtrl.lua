local UITrainVIPInvitePopCtrl = BaseClass("UITrainVIPInvitePopCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITrainVIPInvitePopView)
end

UITrainVIPInvitePopCtrl.CloseSelf = CloseSelf
return UITrainVIPInvitePopCtrl
