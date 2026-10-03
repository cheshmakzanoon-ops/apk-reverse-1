local UIHeadTalkCtrl = BaseClass("UIHeadTalkCtrl", UIBaseCtrl)

function UIHeadTalkCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeadTalk, {anim = true, playEffect = false})
end

return UIHeadTalkCtrl
