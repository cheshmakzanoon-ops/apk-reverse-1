local UIPostAllianceNoticeCtrl = BaseClass("UIPostAllianceNoticeCtrl", UIBaseCtrl)

function UIPostAllianceNoticeCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPostAllianceNotice, {anim = true, playEffect = false})
end

return UIPostAllianceNoticeCtrl
