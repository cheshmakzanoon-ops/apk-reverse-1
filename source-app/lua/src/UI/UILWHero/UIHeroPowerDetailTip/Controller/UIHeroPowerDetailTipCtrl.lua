local UIHeroPowerDetailTipCtrl = BaseClass("UIHeroPowerDetailTipCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroPowerDetailTip)
end

UIHeroPowerDetailTipCtrl.CloseSelf = CloseSelf
return UIHeroPowerDetailTipCtrl
