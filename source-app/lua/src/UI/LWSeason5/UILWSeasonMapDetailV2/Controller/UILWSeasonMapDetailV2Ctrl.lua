local UILWSeasonMapDetailV2Ctrl = BaseClass("UILWSeasonMapDetailV2Ctrl", UIBaseCtrl)

function UILWSeasonMapDetailV2Ctrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonMapDetailV2)
end

return UILWSeasonMapDetailV2Ctrl
