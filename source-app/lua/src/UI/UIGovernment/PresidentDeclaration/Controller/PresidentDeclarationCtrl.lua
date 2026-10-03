local PresidentDeclarationCtrl = BaseClass("PresidentDeclarationCtrl", UIBaseCtrl)

function PresidentDeclarationCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentPresidentDeclaration)
end

return PresidentDeclarationCtrl
