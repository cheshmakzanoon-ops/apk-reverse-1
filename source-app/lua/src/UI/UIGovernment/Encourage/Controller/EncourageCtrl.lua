local EncourageCtrl = BaseClass("EncourageCtrl", UIBaseCtrl)

function EncourageCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentEncourage)
end

return EncourageCtrl
