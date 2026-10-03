local UICoppaAppealCtrl = BaseClass("UICoppaAppealCtrl", UIBaseCtrl)

function UICoppaAppealCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICoppaAppeal)
end

return UICoppaAppealCtrl
