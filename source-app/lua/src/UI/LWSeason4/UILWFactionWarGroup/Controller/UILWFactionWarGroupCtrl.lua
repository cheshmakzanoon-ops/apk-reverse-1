local UILWFactionWarGroupCtrl = BaseClass("UILWFactionWarGroupCtrl", UIBaseCtrl)

function UILWFactionWarGroupCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWFactionWarGroup)
end

return UILWFactionWarGroupCtrl
