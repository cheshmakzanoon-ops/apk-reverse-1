local ModuleCheckCtrl = BaseClass("ModuleCheckCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.ModuleCheck)
end

ModuleCheckCtrl.CloseSelf = CloseSelf
return ModuleCheckCtrl
