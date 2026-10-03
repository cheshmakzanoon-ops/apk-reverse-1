local UILWSeasonMapDetailV6Ctrl = BaseClass("UILWSeasonMapDetailV6Ctrl", UIBaseCtrl)

function UILWSeasonMapDetailV6Ctrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonMapDetailV6)
end

return UILWSeasonMapDetailV6Ctrl
