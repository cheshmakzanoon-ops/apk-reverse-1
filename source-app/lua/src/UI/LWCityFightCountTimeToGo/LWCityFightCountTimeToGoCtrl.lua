local LWCityFightCountTimeToGoCtrl = BaseClass("LWCityFightCountTimeToGoCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWCityFightCountTimeToGo)
end

LWCityFightCountTimeToGoCtrl.CloseSelf = CloseSelf
return LWCityFightCountTimeToGoCtrl
