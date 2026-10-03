local UISeasonOfficialMainCtrl = BaseClass("UISeasonOfficialMainCtrl", UIBaseCtrl)

function UISeasonOfficialMainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISeasonOfficialMain)
end

return UISeasonOfficialMainCtrl
