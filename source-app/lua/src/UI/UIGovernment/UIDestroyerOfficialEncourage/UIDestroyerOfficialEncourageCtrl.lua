local UIDestroyerOfficialEncourageCtrl = BaseClass("UIDestroyerOfficialEncourageCtrl", UIBaseCtrl)

function UIDestroyerOfficialEncourageCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDestroyerOfficialEncourage)
end

return UIDestroyerOfficialEncourageCtrl
