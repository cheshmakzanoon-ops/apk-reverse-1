local UILLBattleSkillDetailCtrl = BaseClass("UILLBattleSkillDetailCtrl")

function UILLBattleSkillDetailCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILLBattleSkillDetail)
end

return UILLBattleSkillDetailCtrl
