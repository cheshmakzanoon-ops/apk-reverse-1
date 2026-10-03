local UISeasonOfficialListCtrl = BaseClass("UISeasonOfficialListCtrl", UIBaseCtrl)

function UISeasonOfficialListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISeasonOfficialList)
end

return UISeasonOfficialListCtrl
