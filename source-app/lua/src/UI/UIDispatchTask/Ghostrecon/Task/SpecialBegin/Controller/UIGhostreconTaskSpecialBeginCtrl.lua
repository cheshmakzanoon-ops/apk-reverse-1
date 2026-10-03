local UIGhostreconTaskSpecialBeginCtrl = BaseClass("UIGhostreconTaskSpecialBeginCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostreconTaskSpecialBegin)
end

UIGhostreconTaskSpecialBeginCtrl.CloseSelf = CloseSelf
return UIGhostreconTaskSpecialBeginCtrl
