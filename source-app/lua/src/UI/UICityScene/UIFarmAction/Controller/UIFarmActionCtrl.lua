local UIFarmActionCtrl = BaseClass("UIFarmActionCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIFarmAction)
end

UIFarmActionCtrl.CloseSelf = CloseSelf
return UIFarmActionCtrl
