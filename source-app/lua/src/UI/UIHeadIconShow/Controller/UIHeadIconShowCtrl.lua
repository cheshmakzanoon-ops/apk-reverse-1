local UIHeadIconShowCtrl = BaseClass("UIHeadIconShowCtrl", UIBaseCtrl)

function UIHeadIconShowCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeadIconShow)
end

return UIHeadIconShowCtrl
