local LWUIMasteryCenterTabCtrl = BaseClass("LWUIMasteryCenterTabCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMasteryCenterTab)
end

LWUIMasteryCenterTabCtrl.CloseSelf = CloseSelf
return LWUIMasteryCenterTabCtrl
