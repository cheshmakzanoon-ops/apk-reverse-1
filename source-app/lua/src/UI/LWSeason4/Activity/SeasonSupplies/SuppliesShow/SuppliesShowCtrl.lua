local SuppliesShowCtrl = BaseClass("SuppliesShowCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SuppliesShow, {anim = false})
end

SuppliesShowCtrl.CloseSelf = CloseSelf
return SuppliesShowCtrl
