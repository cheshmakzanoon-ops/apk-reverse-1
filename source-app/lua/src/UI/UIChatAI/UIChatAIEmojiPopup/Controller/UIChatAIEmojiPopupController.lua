local UIChatAIEmojiPopupController = BaseClass("UIChatAIEmojiPopupController", UIBaseCtrl)

function UIChatAIEmojiPopupController:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChatAIEmojiPopup)
end

return UIChatAIEmojiPopupController
