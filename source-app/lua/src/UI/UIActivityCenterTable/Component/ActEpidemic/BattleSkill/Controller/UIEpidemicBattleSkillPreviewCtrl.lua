local UIEpidemicBattleSkillPreviewCtrl = BaseClass("UIEpidemicBattleSkillPreviewCtrl", UIBaseCtrl)

function UIEpidemicBattleSkillPreviewCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIEpidemicBattleSkillPreview)
end

return UIEpidemicBattleSkillPreviewCtrl
