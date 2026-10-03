local UISeasonOfficialEncourageCtrl = BaseClass("UISeasonOfficialEncourageCtrl", UIBaseCtrl)

function UISeasonOfficialEncourageCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISeasonOfficialEncourage)
end

return UISeasonOfficialEncourageCtrl
