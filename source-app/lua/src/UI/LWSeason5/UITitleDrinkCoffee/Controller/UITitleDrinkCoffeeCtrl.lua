local UITitleDrinkCoffeeCtrl = BaseClass("UITitleDrinkCoffeeCtrl", UIBaseCtrl)

function UITitleDrinkCoffeeCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITitleDrinkCoffeeView)
end

return UITitleDrinkCoffeeCtrl
