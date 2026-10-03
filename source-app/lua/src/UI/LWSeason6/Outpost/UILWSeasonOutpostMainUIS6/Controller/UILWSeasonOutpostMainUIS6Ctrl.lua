local UILWSeasonOutpostMainUIS6Ctrl = BaseClass("UILWSeasonOutpostMainUIS6Ctrl", UIBaseCtrl)

function UILWSeasonOutpostMainUIS6Ctrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSeasonOutpostMainUIS6)
end

return UILWSeasonOutpostMainUIS6Ctrl
