local UIHeroPreviewSkillWindowCtrl = BaseClass("UIHeroPreviewSkillWindowCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroPreviewSkillWindow)
end

local function ProcessSkillTemplate(self, skillTemplate, isAdditionalSkill)
  if skillTemplate == nil then
    return
  end
  skillTemplate.pre_cd = DataCenter.HeroParamDataManager.skillPreviewStartDelay
  if skillTemplate.actionType == SkillActionType.Buff then
    local function IsMemberTarget(targetType)
      local containsSelf = false
      
      local containsMember = false
      for i, v in pairs(targetType) do
        if v == 1 then
          containsSelf = true
        end
        if v == 3 then
          containsMember = true
        end
      end
      return containsMember and containsSelf
    end
    
    if IsMemberTarget(skillTemplate.target_type) then
      skillTemplate.target_type = {1}
      local target_type_bin = 0
      for _, target_type in ipairs(skillTemplate.target_type) do
        target_type_bin = target_type_bin | 1 << target_type + 1
      end
      skillTemplate.target_type_bin = target_type_bin
    end
    skillTemplate.pos_condition = LocationCondition.None
  end
  if isAdditionalSkill and skillTemplate.apType == SkillAPType.Passive then
    skillTemplate.triggerType = SkillTriggerType.AlwaysInside
  end
end

UIHeroPreviewSkillWindowCtrl.CloseSelf = CloseSelf
UIHeroPreviewSkillWindowCtrl.ProcessSkillTemplate = ProcessSkillTemplate
return UIHeroPreviewSkillWindowCtrl
