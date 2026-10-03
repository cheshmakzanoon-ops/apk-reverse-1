local UILLGroupChooseCtrl = BaseClass("UILLGroupChooseCtrl", UIBaseCtrl)

function UILLGroupChooseCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILLGroupChoose)
end

return UILLGroupChooseCtrl
