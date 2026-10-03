local UILWCityBuffCtrl = BaseClass("UILWCityBuffCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWCityBuff, {anim = true})
end

UILWCityBuffCtrl.CloseSelf = CloseSelf
return UILWCityBuffCtrl
