local UIGuideHeadTalkCtrl = BaseClass("UIGuideHeadTalkCtrl", UIBaseCtrl)

function UIGuideHeadTalkCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideHeadTalk, {anim = true, playEffect = false})
end

return UIGuideHeadTalkCtrl
