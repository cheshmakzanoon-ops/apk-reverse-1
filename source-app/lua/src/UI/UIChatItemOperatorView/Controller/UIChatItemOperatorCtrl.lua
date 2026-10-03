local UIChatItemOperatorCtrl = BaseClass("UIChatItemOperatorCtrl", UIBaseCtrl)

function UIChatItemOperatorCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChatItemOperatorView)
end

return UIChatItemOperatorCtrl
