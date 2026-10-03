local UILWBiuBiuPvpResultCtrl = BaseClass("UILWBiuBiuPvpResultCtrl", UIBaseCtrl)

function UILWBiuBiuPvpResultCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWBiuBiuPvpResult)
end

function UILWBiuBiuPvpResultCtrl:OnCustomKeyCodeEscape()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWBiuBiuPvpGame)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWBiuBiuPvpResult)
end

return UILWBiuBiuPvpResultCtrl
