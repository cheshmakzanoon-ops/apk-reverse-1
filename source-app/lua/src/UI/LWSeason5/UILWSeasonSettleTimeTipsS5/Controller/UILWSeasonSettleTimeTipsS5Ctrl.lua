local UILWSeasonSettleTimeTipsS5Ctrl = BaseClass("UILWSeasonSettleTimeTipsS5Ctrl", UIBaseCtrl)

function UILWSeasonSettleTimeTipsS5Ctrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonSettleTimeTipsS5)
end

return UILWSeasonSettleTimeTipsS5Ctrl
