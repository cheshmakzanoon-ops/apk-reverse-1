local UITacticalChipStarDetailCtrl = BaseClass("UITacticalChipStarDetailCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UITacticalChipStarDetail)
end

UITacticalChipStarDetailCtrl.CloseSelf = CloseSelf
return UITacticalChipStarDetailCtrl
