local UILWPostCircleFriendCtrl = BaseClass("UILWPostCircleFriendCtrl", UIBaseCtrl)

function UILWPostCircleFriendCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWPostCircleFriend, {anim = true})
end

function UILWPostCircleFriendCtrl:GetWindName()
  return UIWindowNames.UILWPostCircleFriend
end

function UILWPostCircleFriendCtrl:GetOpList()
  return ChatInterface.getMoment():GetVisibilityConfig()
end

return UILWPostCircleFriendCtrl
