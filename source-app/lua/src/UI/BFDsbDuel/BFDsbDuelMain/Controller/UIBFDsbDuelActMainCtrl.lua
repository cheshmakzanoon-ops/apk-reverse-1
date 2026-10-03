local UIBFDsbDuelActMainCtrl = BaseClass("UIBFDsbDuelActMainCtrl", UIBaseCtrl)

function UIBFDsbDuelActMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBFDsbDuelActMain, {anim = false})
end

function UIBFDsbDuelActMainCtrl:OnCustomKeyCodeEscape()
  self:CloseSelf()
end

return UIBFDsbDuelActMainCtrl
