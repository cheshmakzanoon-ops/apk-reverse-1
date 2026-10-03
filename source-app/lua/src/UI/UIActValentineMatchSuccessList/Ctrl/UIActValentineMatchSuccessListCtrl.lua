local UIActValentineMatchSuccessListCtrl = BaseClass("UIActValentineMatchSuccessListCtrl", UIBaseCtrl)

function UIActValentineMatchSuccessListCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActValentineMatchSuccessList)
end

return UIActValentineMatchSuccessListCtrl
