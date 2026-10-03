local UILWMomentPushCtrl = BaseClass("UILWMomentPushCtrl", UIBaseCtrl)
local TabConfig = {
  {
    tabKey = "string_likes",
    type = MomentPushType.NoticeLike,
    redType = UnreadNotificationType.ShowUnreadDot
  },
  {
    tabKey = "390009",
    type = MomentPushType.NoticeComment,
    redType = UnreadNotificationType.ShowUnreadCount
  }
}

function UILWMomentPushCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWMomentPush)
end

function UILWMomentPushCtrl:GetTabConfig()
  return DeepCopy(TabConfig)
end

return UILWMomentPushCtrl
