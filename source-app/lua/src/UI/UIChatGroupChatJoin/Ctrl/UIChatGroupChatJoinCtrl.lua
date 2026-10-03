local UIChatGroupChatJoinCtrl = BaseClass("UIChatGroupChatJoinCtrl", UIBaseCtrl)

function UIChatGroupChatJoinCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChatGroupChatJoin)
end

return UIChatGroupChatJoinCtrl
