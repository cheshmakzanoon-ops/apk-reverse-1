local base = UIBaseContainer
local LLBattleSkillCur = BaseClass("LLBattleSkillCur", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function LLBattleSkillCur:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLBattleSkillCur:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLBattleSkillCur:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgItemIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textDuration = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textType = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
end

function LLBattleSkillCur:ComponentDestroy()
  self.viewSkin = nil
  self.imgItemIcon = nil
  self.textName = nil
  self.textDuration = nil
  self.textType = nil
  self.textDesc = nil
end

function LLBattleSkillCur:DataDefine()
end

function LLBattleSkillCur:DataDestroy()
end

function LLBattleSkillCur:OnAddListener()
  base.OnAddListener(self)
end

function LLBattleSkillCur:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLBattleSkillCur:ReInit(skillId)
  self.curSkillId = skillId
  local template = DataCenter.StatusManager:GetTemplate(self.curSkillId)
  if template then
    if not string.IsNullOrEmpty(template.icon) then
      self.imgItemIcon:LoadSpriteAuto(template.icon)
    end
    self.textName:SetLocalText(template.name)
    self.textDuration:SetText(UITimeManager:GetInstance():SecondToFmtString(tonumber(template.time)))
    self.textDesc:SetLocalText(template.description, template.effect_num, template.time)
  end
end

return LLBattleSkillCur
