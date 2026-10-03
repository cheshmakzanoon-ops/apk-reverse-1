local UILWUserPromptCtrl = BaseClass("UILWUserPromptCtrl", UIBaseCtrl)

function UILWUserPromptCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWUserPrompt)
end

return UILWUserPromptCtrl
