local UIUpgradeAllianceNoticeCtrl = BaseClass("UIUpgradeAllianceNoticeCtrl", UIBaseCtrl)

function UIUpgradeAllianceNoticeCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIUpgradeAllianceNotice, {anim = true, playEffect = false})
end

return UIUpgradeAllianceNoticeCtrl
