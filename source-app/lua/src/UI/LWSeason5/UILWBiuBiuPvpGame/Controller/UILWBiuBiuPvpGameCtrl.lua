local UILWBiuBiuPvpGameCtrl = BaseClass("UILWBiuBiuPvpGameCtrl", UIBaseCtrl)

function UILWBiuBiuPvpGameCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWBiuBiuPvpGame)
end

function UILWBiuBiuPvpGameCtrl:OnCustomKeyCodeEscape()
end

return UILWBiuBiuPvpGameCtrl
