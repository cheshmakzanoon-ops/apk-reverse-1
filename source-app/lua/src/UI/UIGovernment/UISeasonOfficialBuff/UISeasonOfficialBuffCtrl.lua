local UISeasonOfficialBuffCtrl = BaseClass("UISeasonOfficialBuffCtrl", UIBaseCtrl)

function UISeasonOfficialBuffCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISeasonOfficialBuff)
end

return UISeasonOfficialBuffCtrl
