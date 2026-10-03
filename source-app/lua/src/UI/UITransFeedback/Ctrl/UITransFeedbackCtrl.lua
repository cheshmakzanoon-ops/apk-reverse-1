local UITransFeedbackCtrl = BaseClass("UITransFeedbackCtrl", UIBaseCtrl)

function UITransFeedbackCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITransFeedbackView)
end

return UITransFeedbackCtrl
