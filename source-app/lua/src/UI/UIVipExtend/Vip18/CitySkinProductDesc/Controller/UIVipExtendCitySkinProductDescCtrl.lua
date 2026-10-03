local UIVipExtendCitySkinProductDescCtrl = BaseClass("UIVipExtendCitySkinProductDescCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIVipExtendCitySkinProductDesc)
end

UIVipExtendCitySkinProductDescCtrl.CloseSelf = CloseSelf
return UIVipExtendCitySkinProductDescCtrl
