local UITrainVIPInviteListCtrl = BaseClass("UITrainVIPInviteListCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITrainVIPInviteList)
end

UITrainVIPInviteListCtrl.CloseSelf = CloseSelf
return UITrainVIPInviteListCtrl
