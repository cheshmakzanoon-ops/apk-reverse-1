local UILWArmedUpgradeBannerWarning_JPCtrl = BaseClass("UILWArmedUpgradeBannerWarning_JPCtrl", UIBaseCtrl)

function UILWArmedUpgradeBannerWarning_JPCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWArmedUpgradeBannerWarningView_JP, {anim = false})
end

function UILWArmedUpgradeBannerWarning_JPCtrl:SetUseESC(canUse)
  self.canUseESC = canUse
end

function UILWArmedUpgradeBannerWarning_JPCtrl:OnCustomKeyCodeEscape()
  if self.canUseESC then
    self:CloseSelf()
  end
end

return UILWArmedUpgradeBannerWarning_JPCtrl
