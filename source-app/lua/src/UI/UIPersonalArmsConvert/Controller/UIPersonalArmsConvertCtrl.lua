local UIPersonalArmsConvertCtrl = BaseClass("UIPersonalArmsConvertCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPersonalArmsConvert)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIPersonalArmsConvertCtrl.CloseSelf = CloseSelf
UIPersonalArmsConvertCtrl.Close = Close
return UIPersonalArmsConvertCtrl
