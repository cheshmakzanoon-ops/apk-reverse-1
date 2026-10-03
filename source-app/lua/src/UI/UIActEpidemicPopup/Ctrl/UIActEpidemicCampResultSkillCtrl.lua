local UIActEpidemicCampResultSkillCtrl = BaseClass("UIActEpidemicCampResultSkillCtrl", UIBaseCtrl)

function UIActEpidemicCampResultSkillCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActEpidemicCampResultSkillView, {anim = false})
end

return UIActEpidemicCampResultSkillCtrl
