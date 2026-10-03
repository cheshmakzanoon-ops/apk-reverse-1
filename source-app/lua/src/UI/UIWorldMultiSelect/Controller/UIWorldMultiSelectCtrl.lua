local UIWorldMultiSelectCtrl = BaseClass("UIWorldMultiSelectCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorldMultiSelect)
end

UIWorldMultiSelectCtrl.CloseSelf = CloseSelf
return UIWorldMultiSelectCtrl
