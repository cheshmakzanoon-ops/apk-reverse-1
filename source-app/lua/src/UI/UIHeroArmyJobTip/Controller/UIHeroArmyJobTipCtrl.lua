local UIHeroArmyJobTipCtrl = BaseClass("UIHeroArmyJobTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroTips)
end

UIHeroArmyJobTipCtrl.CloseSelf = CloseSelf
return UIHeroArmyJobTipCtrl
