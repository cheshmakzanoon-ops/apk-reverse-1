local UIAllianceCommonSkillRecordCtrl = BaseClass("UIAllianceCommonSkillRecordCtrl", UIBaseCtrl)

function UIAllianceCommonSkillRecordCtrl:CloseSelf(useAnimation)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceCommonSkillRecord, {anim = useAnimation})
end

return UIAllianceCommonSkillRecordCtrl
