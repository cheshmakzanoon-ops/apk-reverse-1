local UIVIPUpgradePopUpCtrl = BaseClass("UIVIPUpgradePopUpCtrl", UIBaseCtrl)

function UIVIPUpgradePopUpCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIVIPUpgradePopUp)
end

function UIVIPUpgradePopUpCtrl:Close()
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

function UIVIPUpgradePopUpCtrl:CloseSelfOpenVip()
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIVipPurchase) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIVipPurchase)
  end
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UICapacityTable) then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UICapacityTable)
  end
  if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIVip) then
    local window = UIManager:GetInstance():GetWindow(UIWindowNames.UIVip)
    if window ~= nil and window.View ~= nil then
      window.View:RefreshVipContentIndex()
    end
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIVip, {anim = true})
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIVIPUpgradePopUp)
end

return UIVIPUpgradePopUpCtrl
