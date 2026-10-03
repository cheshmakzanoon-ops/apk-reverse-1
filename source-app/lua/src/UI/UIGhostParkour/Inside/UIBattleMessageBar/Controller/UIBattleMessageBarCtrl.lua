local UIBattleMessageBarCtrl = BaseClass("UIBattleMessageBarCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBattleMessageBar, {anim = true, playEffect = false})
end

UIBattleMessageBarCtrl.CloseSelf = CloseSelf
return UIBattleMessageBarCtrl
