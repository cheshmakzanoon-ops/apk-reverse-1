local UICommonSimpleTipCtrl = BaseClass("UICommonSimpleTipCtrl", UIBaseCtrl)

function UICommonSimpleTipCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICommonSimpleTipView)
end

return UICommonSimpleTipCtrl
