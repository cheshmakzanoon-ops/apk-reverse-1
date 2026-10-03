local UIAllianceCommonSkillInfoCtrl = BaseClass("UIAllianceCommonSkillInfoCtrl", UIBaseCtrl)

function UIAllianceCommonSkillInfoCtrl:CloseSelf(useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceCommonSkillInfo, {anim = useAnimation})
end

return UIAllianceCommonSkillInfoCtrl
