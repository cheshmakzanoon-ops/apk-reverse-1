local UILWBiuBiuGameCtrl = BaseClass("UILWBiuBiuGameCtrl", UIBaseCtrl)

function UILWBiuBiuGameCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWBiuBiuGame)
end

function UILWBiuBiuGameCtrl:OnCustomKeyCodeEscape()
end

return UILWBiuBiuGameCtrl
