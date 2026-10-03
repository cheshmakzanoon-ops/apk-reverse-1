local UIAllianceInviteTipCtrl = BaseClass("UIAllianceInviteTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceInviteTip)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIAllianceInviteTipCtrl.CloseSelf = CloseSelf
UIAllianceInviteTipCtrl.Close = Close
return UIAllianceInviteTipCtrl
