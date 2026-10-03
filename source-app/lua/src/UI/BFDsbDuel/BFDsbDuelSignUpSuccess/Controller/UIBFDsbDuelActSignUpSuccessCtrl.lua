local UIBFDsbDuelActSignUpSuccessCtrl = BaseClass("UIBFDsbDuelActSignUpSuccessCtrl", UIBaseCtrl)

function UIBFDsbDuelActSignUpSuccessCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBFDsbDuelActSignUpSuccess, {anim = true})
end

function UIBFDsbDuelActSignUpSuccessCtrl:OnCustomKeyCodeEscape()
  self:CloseSelf()
end

return UIBFDsbDuelActSignUpSuccessCtrl
