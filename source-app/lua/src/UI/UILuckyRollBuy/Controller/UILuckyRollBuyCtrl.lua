local UILuckyRollBuyCtrl = BaseClass("UILuckyRollBuyCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UILuckyRollBuy, {anim = true})
end

UILuckyRollBuyCtrl.CloseSelf = CloseSelf
return UILuckyRollBuyCtrl
