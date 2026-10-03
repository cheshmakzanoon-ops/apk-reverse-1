local UILookForCareerCtrl = BaseClass("UILookForCareerCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILookForCareer)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Background, false)
end

UILookForCareerCtrl.CloseSelf = CloseSelf
UILookForCareerCtrl.Close = Close
return UILookForCareerCtrl
