local UISeasonOfficialEncourageSelectCtrl = BaseClass("UISeasonOfficialEncourageSelectCtrl", UIBaseCtrl)

function UISeasonOfficialEncourageSelectCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISeasonOfficialEncourageSelect)
end

return UISeasonOfficialEncourageSelectCtrl
