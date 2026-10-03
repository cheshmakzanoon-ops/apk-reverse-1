local UISeasonOfficialDeclarationCtrl = BaseClass("UISeasonOfficialDeclarationCtrl", UIBaseCtrl)

function UISeasonOfficialDeclarationCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISeasonOfficialDeclaration)
end

return UISeasonOfficialDeclarationCtrl
