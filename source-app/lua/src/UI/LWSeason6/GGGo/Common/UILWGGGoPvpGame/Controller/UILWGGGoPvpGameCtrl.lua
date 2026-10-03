local UILWGGGoPvpGameCtrl = BaseClass("UILWGGGoPvpGameCtrl", UIBaseCtrl)

function UILWGGGoPvpGameCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWGGGoPvpGame)
end

function UILWGGGoPvpGameCtrl:OnCustomKeyCodeEscape()
end

return UILWGGGoPvpGameCtrl
