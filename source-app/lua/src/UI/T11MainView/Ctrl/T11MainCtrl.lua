local T11MainCtrl = BaseClass("T11MainCtrl", UIBaseCtrl)

function T11MainCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.T11MainView)
end

return T11MainCtrl
