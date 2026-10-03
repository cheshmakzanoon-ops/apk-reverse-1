local UILWMummyHistoryCtrl = BaseClass("UILWMummyHistoryCtrl", UIBaseCtrl)

function UILWMummyHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWMummyHistory)
end

return UILWMummyHistoryCtrl
