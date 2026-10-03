local EmailCtrl = BaseClass("EmailCtrl", UIBaseCtrl)

function EmailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentEmail)
end

return EmailCtrl
