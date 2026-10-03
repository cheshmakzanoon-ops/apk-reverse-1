local UILWGGGoPvpResultCtrl = BaseClass("UILWGGGoPvpResultCtrl", UIBaseCtrl)

function UILWGGGoPvpResultCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWGGGoPvpResult)
end

function UILWGGGoPvpResultCtrl:OnCustomKeyCodeEscape()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWGGGoPvpGame)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWGGGoPvpResult)
end

return UILWGGGoPvpResultCtrl
