local UIActBountyHunterSpecialEventCtrl = BaseClass("UIActBountyHunterSpecialEventCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.BountyHunterSpecialEvent)
end

UIActBountyHunterSpecialEventCtrl.CloseSelf = CloseSelf
return UIActBountyHunterSpecialEventCtrl
