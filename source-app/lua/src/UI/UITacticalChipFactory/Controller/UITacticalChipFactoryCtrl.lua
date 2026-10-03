local UITacticalChipFactoryCtrl = BaseClass("UITacticalChipFactoryCtrl", UIBaseCtrl)

function UITacticalChipFactoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITacticalChipFactory)
end

return UITacticalChipFactoryCtrl
