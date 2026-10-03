local UIRoleListShowCtrl = BaseClass("UIRoleListShowCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIRoleListShow)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Dialog)
end

UIRoleListShowCtrl.CloseSelf = CloseSelf
UIRoleListShowCtrl.Close = Close
return UIRoleListShowCtrl
