local EmailCtrl = BaseClass("EmailCtrl", UIBaseCtrl)

function EmailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentEmail_v2)
end

return EmailCtrl
