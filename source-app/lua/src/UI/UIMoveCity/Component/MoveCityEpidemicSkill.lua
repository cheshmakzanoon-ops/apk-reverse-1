local MoveCityEpidemicSkill = BaseClass("MoveCityEpidemicSkill", UIAsyncContainer)
local base = UIAsyncContainer
local skill_icon_path = "SkillIcon"
local skill_name_path = "SkillName"
local skill_desc_path = "SkillDesc"
local back_btn_path = "BackBtn"
local tip_text_path = "Tip/TipText"

function MoveCityEpidemicSkill:OnCreate()
  base.OnCreate(self)
  self.skill_icon = self:AddComponent(UIButton, skill_icon_path)
  self.skill_icon:SetOnClick(function()
    local actMgr = DataCenter.ActEpidemicZoneManager
    actMgr:PreviewSkill(actMgr:GetCurSkillId())
  end)
  self.skill_name = self:AddComponent(UITextMeshProUGUIEx, skill_name_path)
  self.skill_desc = self:AddComponent(UITextMeshProUGUIEx, skill_desc_path)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.back_btn:SetOnClick(function()
    if self.curView ~= nil and self.curView.OnBackClick then
      self.curView:OnBackClick()
    end
  end)
  self.tip_text = self:AddComponent(UITextMeshProUGUIEx, tip_text_path)
end

function MoveCityEpidemicSkill:OnDestroy()
  self.skill_icon = nil
  self.skill_name = nil
  self.skill_desc = nil
  self.back_btn = nil
  self.tip_text = nil
  self.curView = nil
  base.OnDestroy(self)
end

function MoveCityEpidemicSkill:UpdateData(view)
  self.curView = view
  if self.curView ~= nil and self.curView.OnBackClick then
    self.back_btn:SetActive(true)
  else
    self.back_btn:SetActive(false)
  end
  local actMgr = DataCenter.ActEpidemicZoneManager
  local skillId = actMgr:GetCurSkillId()
  local template = actMgr:GetTemplateSkillById(skillId)
  if template then
    if not string.IsNullOrEmpty(template.icon) then
      self.skill_icon:LoadSprite(template.icon)
    end
    self.skill_name:SetLocalText(template.name)
    if template.getDesc then
      self.skill_desc:SetText(template:getDesc())
    else
      self.skill_desc:SetLocalText(template.desc)
    end
  end
end

function MoveCityEpidemicSkill:SetTipText(haveTarget)
  if self.haveTarget == haveTarget then
    return
  end
  self.haveTarget = haveTarget
  self.tip_text:SetLocalText(haveTarget and "YiBianJinQu_trivial_tips_27" or "YiBianJinQu_trivial_tips_43")
  self.tip_text:SetColor(haveTarget and Color.white or Color.red)
end

return MoveCityEpidemicSkill
