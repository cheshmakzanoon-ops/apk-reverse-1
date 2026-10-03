local UIWestwardExpansionInstructionCtrl = BaseClass("UIWestwardExpansionInstructionCtrl", UIBaseCtrl)

function UIWestwardExpansionInstructionCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWestwardExpansionInstruction)
end

return UIWestwardExpansionInstructionCtrl
