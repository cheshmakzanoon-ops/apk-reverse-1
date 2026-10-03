local UICareerSelectCtrl = BaseClass("UICareerSelectCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICareerSelect)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Background)
end

UICareerSelectCtrl.CloseSelf = CloseSelf
UICareerSelectCtrl.Close = Close
return UICareerSelectCtrl
