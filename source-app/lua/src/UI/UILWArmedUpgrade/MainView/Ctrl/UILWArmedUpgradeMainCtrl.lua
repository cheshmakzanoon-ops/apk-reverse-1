local UILWArmedUpgradeMainCtrl = BaseClass("UILWArmedUpgradeMainCtrl", UIBaseCtrl)

function UILWArmedUpgradeMainCtrl:CloseSelf()
  self.view = nil
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWArmedUpgradeMain)
end

function UILWArmedUpgradeMainCtrl:OnCustomKeyCodeEscape()
  if self.view then
    self.view:OnBtnBackClick()
  end
end

function UILWArmedUpgradeMainCtrl:SetView(view)
  self.view = view
end

function UILWArmedUpgradeMainCtrl:ResetIsUpdateFlag()
  self.isUpgraded = false
end

function UILWArmedUpgradeMainCtrl:SetIsUpdateFlag()
  self.isUpgraded = true
end

return UILWArmedUpgradeMainCtrl
