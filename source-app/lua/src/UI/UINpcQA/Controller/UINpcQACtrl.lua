local UINpcQACtrl = BaseClass("UINpcQACtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UINpcQA)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UINpcQACtrl.CloseSelf = CloseSelf
UINpcQACtrl.Close = Close
return UINpcQACtrl
