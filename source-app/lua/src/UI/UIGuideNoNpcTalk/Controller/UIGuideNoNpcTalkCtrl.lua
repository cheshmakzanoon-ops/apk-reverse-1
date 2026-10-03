local UIGuideNoNpcTalkCtrl = BaseClass("UIGuideNoNpcTalkCtrl", UIBaseCtrl)

function UIGuideNoNpcTalkCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.UIGuideNoNpcTalk)
end

return UIGuideNoNpcTalkCtrl
