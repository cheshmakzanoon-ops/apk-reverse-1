local LWUIMasteryCtrl = BaseClass("LWUIMasteryCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIMastery)
end

LWUIMasteryCtrl.CloseSelf = CloseSelf
return LWUIMasteryCtrl
