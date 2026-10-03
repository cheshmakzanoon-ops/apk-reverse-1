local UILWVIPRadarClaimPanelCtrl = BaseClass("UILWVIPRadarClaimPanelCtrl", UIBaseCtrl)

function UILWVIPRadarClaimPanelCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWVIPRadarClaimPanel)
end

return UILWVIPRadarClaimPanelCtrl
