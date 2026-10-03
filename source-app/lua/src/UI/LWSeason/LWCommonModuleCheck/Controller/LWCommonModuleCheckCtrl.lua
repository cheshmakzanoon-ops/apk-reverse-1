local LWCommonModuleCheckCtrl = BaseClass("LWCommonModuleCheckCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWCommonModuleCheck)
end

LWCommonModuleCheckCtrl.CloseSelf = CloseSelf
return LWCommonModuleCheckCtrl
