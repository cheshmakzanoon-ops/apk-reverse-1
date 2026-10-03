local UIHeroMonthCardCtrl = BaseClass("UIHeroMonthCardCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroMonthCard)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIHeroMonthCardCtrl.CloseSelf = CloseSelf
UIHeroMonthCardCtrl.Close = Close
return UIHeroMonthCardCtrl
