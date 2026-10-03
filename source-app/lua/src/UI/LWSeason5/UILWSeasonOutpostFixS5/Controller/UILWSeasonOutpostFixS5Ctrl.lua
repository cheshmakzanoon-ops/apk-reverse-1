local UILWSeasonOutpostFixS5Ctrl = BaseClass("UILWSeasonOutpostFixS5Ctrl", UIBaseCtrl)

function UILWSeasonOutpostFixS5Ctrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonOutpostFixS5)
end

return UILWSeasonOutpostFixS5Ctrl
