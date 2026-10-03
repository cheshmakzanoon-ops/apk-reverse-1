local UILWGGGoGameCtrl = BaseClass("UILWGGGoGameCtrl", UIBaseCtrl)

function UILWGGGoGameCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWGGGoGame)
end

function UILWGGGoGameCtrl:OnCustomKeyCodeEscape()
end

return UILWGGGoGameCtrl
