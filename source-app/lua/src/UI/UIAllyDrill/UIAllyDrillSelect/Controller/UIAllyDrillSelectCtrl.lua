local UIAllyDrillSelectCtrl = BaseClass("UIAllyDrillSelectCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllyDrillSelect)
end

UIAllyDrillSelectCtrl.CloseSelf = CloseSelf
return UIAllyDrillSelectCtrl
