local UISeasonOfficialMailV2Ctrl = BaseClass("UISeasonOfficialMailV2Ctrl", UIBaseCtrl)

function UISeasonOfficialMailV2Ctrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISeasonOfficialMailV2)
end

return UISeasonOfficialMailV2Ctrl
