local UIDesertJumpToCtrl = BaseClass("UIDesertJumpToCtrl", UIBaseCtrl)

function UIDesertJumpToCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDesertJumpTo)
end

return UIDesertJumpToCtrl
