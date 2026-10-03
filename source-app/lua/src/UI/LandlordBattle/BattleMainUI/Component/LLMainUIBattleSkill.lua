local base = UIBaseContainer
local LLMainUIBattleSkill = BaseClass("LLMainUIBattleSkill", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local LLMainUIBattleSkillEffect = require("UI.LandlordBattle.BattleMainUI.Component.LLMainUIBattleSkillEffect")

function LLMainUIBattleSkill:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLMainUIBattleSkill:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLMainUIBattleSkill:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textSkillName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.imgSkillCDFill = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textSkillCD = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgSkillIcon = self.viewSkin:AddComponent(self, UIImage, 4)
  self.compEffect = self.viewSkin:AddComponent(self, LLMainUIBattleSkillEffect, 5)
  self.btnLWLandlordBattleMainSkill = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnLWLandlordBattleMainSkill:SetOnClick(function()
    self:OnBtnLWLandlordBattleMainSkillClick()
  end)
end

function LLMainUIBattleSkill:ComponentDestroy()
  self.viewSkin = nil
  self.textSkillName = nil
  self.imgSkillCDFill = nil
  self.textSkillCD = nil
  self.imgSkillIcon = nil
  self.compEffect = nil
  self.btnLWLandlordBattleMainSkill = nil
end

function LLMainUIBattleSkill:DataDefine()
end

function LLMainUIBattleSkill:DataDestroy()
end

function LLMainUIBattleSkill:OnAddListener()
  base.OnAddListener(self)
end

function LLMainUIBattleSkill:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLMainUIBattleSkill:ReInit(skillId)
  self:RefreshSkillShow(skillId)
end

function LLMainUIBattleSkill:OnBtnLWLandlordBattleMainSkillClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILLBattleSkillDetail, {
    anim = false,
    UIMainAnim = UIMainAnimType.AllHide
  }, self.curSkillId)
end

function LLMainUIBattleSkill:RefreshSkillShow(skillId)
  self.curSkillId = skillId
  local template = DataCenter.StatusManager:GetTemplate(self.curSkillId)
  if template == nil then
    self.curSkillId = 0
    return
  end
  local eTime = DataCenter.LandlordMgr:GetCurIronCurtainStatusEndTime()
  local skillPlaying = 0 < eTime
  self.compEffect:SetActive(skillPlaying)
  self:SetActive(skillPlaying)
  if not string.IsNullOrEmpty(template.icon) then
    self.imgSkillIcon:LoadSpriteAuto(template.icon)
  end
  self.textSkillName:SetLocalText(template.name)
  if skillPlaying then
    self:RefreshSkillEffect()
    self.textSkillCD:SetActive(true)
  end
  self:Update1000MS()
end

function LLMainUIBattleSkill:RefreshSkillEffect()
  local skillId = self.curSkillId
  if self.compEffect then
    self.compEffect:SetShow(skillId)
  end
end

function LLMainUIBattleSkill:Update1000MS()
  if self.curSkillId == 0 then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local eTime = DataCenter.LandlordMgr:GetCurIronCurtainStatusEndTime()
  local skillPlaying = 0 < eTime and curTime < eTime
  if skillPlaying then
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutHour(eTime - curTime)
    self.textSkillCD:SetText(timeStr)
    return
  end
end

return LLMainUIBattleSkill
