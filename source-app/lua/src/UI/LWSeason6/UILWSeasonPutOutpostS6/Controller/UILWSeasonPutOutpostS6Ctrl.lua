local UILWSeasonPutOutpostS6Ctrl = BaseClass("UILWSeasonPutOutpostS6Ctrl", UIBaseCtrl)

function UILWSeasonPutOutpostS6Ctrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonPutOutpostS6)
end

return UILWSeasonPutOutpostS6Ctrl
