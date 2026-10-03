local UILWVIPRadarPanelCtrl = BaseClass("UILWVIPRadarPanelCtrl", UIBaseCtrl)

function UILWVIPRadarPanelCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWVIPRadarPanel, {anim = false})
end

return UILWVIPRadarPanelCtrl
