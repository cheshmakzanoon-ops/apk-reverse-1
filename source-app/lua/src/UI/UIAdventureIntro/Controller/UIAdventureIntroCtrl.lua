local UIAdventureIntroCtrl = BaseClass("UIAdventureIntroCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAdventureIntro)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Background)
end

UIAdventureIntroCtrl.CloseSelf = CloseSelf
UIAdventureIntroCtrl.Close = Close
return UIAdventureIntroCtrl
