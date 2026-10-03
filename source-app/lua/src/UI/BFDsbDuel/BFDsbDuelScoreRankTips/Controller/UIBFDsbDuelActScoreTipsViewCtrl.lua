local UIBFDsbDuelActScoreTipsViewCtrl = BaseClass("UIBFDsbDuelActScoreTipsViewCtrl", UIBaseCtrl)

function UIBFDsbDuelActScoreTipsViewCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBFDsbDuelActScoreTipsView, {anim = true})
end

function UIBFDsbDuelActScoreTipsViewCtrl:OnCustomKeyCodeEscape()
  self:CloseSelf()
end

return UIBFDsbDuelActScoreTipsViewCtrl
