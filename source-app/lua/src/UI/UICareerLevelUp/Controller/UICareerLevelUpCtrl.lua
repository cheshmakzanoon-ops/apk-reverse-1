local UICareerLevelUp = BaseClass("UICareerLevelUp", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICareerLevelUp)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UICareerLevelUp.CloseSelf = CloseSelf
UICareerLevelUp.Close = Close
return UICareerLevelUp
