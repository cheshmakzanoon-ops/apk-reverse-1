local UISettingFlagCtrl = BaseClass("UISettingFlagCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISettingFlag)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UISettingFlagCtrl.CloseSelf = CloseSelf
UISettingFlagCtrl.Close = Close
return UISettingFlagCtrl
