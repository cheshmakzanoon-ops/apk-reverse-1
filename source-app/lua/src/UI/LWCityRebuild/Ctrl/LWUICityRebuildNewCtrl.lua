local LWUICityRebuildNewCtrl = BaseClass("LWUICityRebuildNewCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUICityRebuildNewView)
end

LWUICityRebuildNewCtrl.CloseSelf = CloseSelf
return LWUICityRebuildNewCtrl
