local UISettingSetCtrl = BaseClass("UISettingSetCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UISettingSet)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UISettingSetCtrl.CloseSelf = CloseSelf
UISettingSetCtrl.Close = Close
return UISettingSetCtrl
