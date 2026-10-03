local base = UIAsyncContainer
local UIMoveCityAllianceSkill = BaseClass("UIMoveCityAllianceSkill", base)
local btn_SkillIcon_path = "SkillIcon"
local txt_SkillName_path = "SkillName"
local txt_SkillDesc_path = "SkillDesc"
local btn_BackBtn_path = "BackBtn"
local txt_TipText_path = "Tip/TipText"

function UIMoveCityAllianceSkill:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIMoveCityAllianceSkill:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMoveCityAllianceSkill:ComponentDefine()
  self.btn_SkillIcon = self:AddComponent(UIButton, btn_SkillIcon_path)
  self.txt_SkillName = self:AddComponent(UIText, txt_SkillName_path)
  self.txt_SkillDesc = self:AddComponent(UIText, txt_SkillDesc_path)
  self.btn_BackBtn = self:AddComponent(UIButton, btn_BackBtn_path)
  self.txt_TipText = self:AddComponent(UIText, txt_TipText_path)
  self.txt_TipText:SetActive(true)
  self.btn_SkillIcon:SetOnClick(function()
  end)
  self.btn_BackBtn:SetOnClick(function()
    if self.view ~= nil and self.view.OnBackClick then
      self.view:OnBackClick()
    end
  end)
end

function UIMoveCityAllianceSkill:ComponentDestroy()
  self.btn_SkillIcon = nil
  self.txt_SkillName = nil
  self.txt_SkillDesc = nil
  self.btn_BackBtn = nil
  self.txt_TipText = nil
end

function UIMoveCityAllianceSkill:UpdateData()
  if self.view.OnBackClick then
    self.btn_BackBtn:SetActive(true)
  else
    self.btn_BackBtn:SetActive(false)
  end
  local allianceFakeBuildId = self.view.param.allianceFakeBuildId
  self.allianceBuildTemplate = DataCenter.AllianceMineManager:GetAllianceMineTemplate(allianceFakeBuildId)
  local buildIcon = self.allianceBuildTemplate:GetIconPath(true)
  self.btn_SkillIcon:LoadSpriteAuto(buildIcon)
  self.txt_SkillName:SetLocalText(self.allianceBuildTemplate.name)
  self.txt_SkillDesc:SetLocalText(self.allianceBuildTemplate.desc)
end

function UIMoveCityAllianceSkill:SetTipText(haveTarget)
  if self.haveTarget == haveTarget then
    return
  end
  self.haveTarget = haveTarget
  self.txt_TipText:SetLocalText(haveTarget and "YiBianJinQu_trivial_tips_27" or "YiBianJinQu_trivial_tips_43")
  self.txt_TipText:SetColor(haveTarget and Color.white or Color.red)
end

return UIMoveCityAllianceSkill
