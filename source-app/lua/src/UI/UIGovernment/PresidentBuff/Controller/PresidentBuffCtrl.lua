local PresidentBuffCtrl = BaseClass("PresidentBuffCtrl", UIBaseCtrl)

function PresidentBuffCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGovernmentPresidentBuff)
end

return PresidentBuffCtrl
