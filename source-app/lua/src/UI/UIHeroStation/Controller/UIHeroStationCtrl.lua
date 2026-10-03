local UIHeroStation = BaseClass("UIHeroStation", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroStation)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Background, false)
end

UIHeroStation.CloseSelf = CloseSelf
UIHeroStation.Close = Close
return UIHeroStation
