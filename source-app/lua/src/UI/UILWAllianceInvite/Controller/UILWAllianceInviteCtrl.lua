local UILWAllianceInviteCtrl = BaseClass("UILWAllianceInviteCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UILWAllianceInvite)
end

UILWAllianceInviteCtrl.CloseSelf = CloseSelf
return UILWAllianceInviteCtrl
