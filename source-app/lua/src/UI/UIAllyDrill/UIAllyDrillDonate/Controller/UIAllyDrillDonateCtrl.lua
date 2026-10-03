local UIAllyDrillDonateCtrl = BaseClass("UIAllyDrillDonateCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllyDrillDonate)
end

UIAllyDrillDonateCtrl.CloseSelf = CloseSelf
return UIAllyDrillDonateCtrl
