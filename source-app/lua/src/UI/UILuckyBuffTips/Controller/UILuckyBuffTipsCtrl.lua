local UILuckyBuffTipsCtrl = BaseClass("UILuckyBuffTipsCtrl", UIBaseCtrl)

function UILuckyBuffTipsCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILuckyBuffTips)
end

return UILuckyBuffTipsCtrl
