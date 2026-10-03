local UIInteractionBubbleCtrl = BaseClass("UIInteractionBubbleCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIInteractionBubble)
end

UIInteractionBubbleCtrl.CloseSelf = CloseSelf
return UIInteractionBubbleCtrl
