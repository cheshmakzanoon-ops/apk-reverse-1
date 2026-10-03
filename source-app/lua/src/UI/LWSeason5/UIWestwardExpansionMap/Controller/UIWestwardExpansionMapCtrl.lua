local UIWestwardExpansionMapCtrl = BaseClass("UIWestwardExpansionMapCtrl", UIBaseCtrl)

function UIWestwardExpansionMapCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWestwardExpansionMap)
end

return UIWestwardExpansionMapCtrl
