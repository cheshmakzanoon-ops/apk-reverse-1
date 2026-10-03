local UISeasonOfficialMailCtrl = BaseClass("UISeasonOfficialMailCtrl", UIBaseCtrl)

function UISeasonOfficialMailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISeasonOfficialMail)
end

return UISeasonOfficialMailCtrl
