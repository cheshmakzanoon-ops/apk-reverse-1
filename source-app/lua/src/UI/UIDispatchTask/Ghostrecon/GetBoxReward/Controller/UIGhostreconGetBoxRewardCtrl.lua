local _TEMPLATE_NAME_Ctrl = BaseClass("_TEMPLATE_NAME_Ctrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGhostreconGetBoxReward)
end

_TEMPLATE_NAME_Ctrl.CloseSelf = CloseSelf
return _TEMPLATE_NAME_Ctrl
