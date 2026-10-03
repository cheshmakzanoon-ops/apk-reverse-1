local UIDelAllAcctResultConfirmCtrl = BaseClass("UIDelAllAcctResultConfirmCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDelAllAcctResultConfirm)
  CS.ApplicationLaunch.Instance:ReloadGame()
end

local function OnCustomKeyCodeEscape(self)
  self:CloseSelf()
end

UIDelAllAcctResultConfirmCtrl.CloseSelf = CloseSelf
UIDelAllAcctResultConfirmCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
return UIDelAllAcctResultConfirmCtrl
