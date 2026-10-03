local UITacticalChipManageEmptyCtrl = BaseClass("UITacticalChipManageEmptyCtrl", UIBaseCtrl)

function UITacticalChipManageEmptyCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITacticalChipManageEmpty)
end

return UITacticalChipManageEmptyCtrl
