local UIActMonopolyMonsterHuntedCtrl = BaseClass("UIActMonopolyMonsterHuntedCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActMonopolyMonsterHunted)
end

UIActMonopolyMonsterHuntedCtrl.CloseSelf = CloseSelf
return UIActMonopolyMonsterHuntedCtrl
