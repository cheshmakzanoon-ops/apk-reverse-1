local LWCityFightWarningCtrl = BaseClass("LWCityFightWarningCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICityFightWarning)
end

LWCityFightWarningCtrl.CloseSelf = CloseSelf
return LWCityFightWarningCtrl
