local UILWArmedUpgradeBannerWarningCtrl = BaseClass("UILWArmedUpgradeBannerWarningCtrl", UIBaseCtrl)

function UILWArmedUpgradeBannerWarningCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWArmedUpgradeBannerWarning, {anim = true})
end

function UILWArmedUpgradeBannerWarningCtrl:SetUseESC(canUse)
  self.canUseESC = canUse
end

function UILWArmedUpgradeBannerWarningCtrl:OnCustomKeyCodeEscape()
  if self.canUseESC then
    self:CloseSelf()
  end
end

return UILWArmedUpgradeBannerWarningCtrl
