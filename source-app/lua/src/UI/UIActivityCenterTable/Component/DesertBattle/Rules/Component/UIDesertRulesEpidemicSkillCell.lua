local UIDesertRulesEpidemicSkillCell = BaseClass("UIDesertRulesEpidemicSkillCell", UIBaseContainer)
local base = UIBaseContainer
local icon_skill_path = "ignoreLayout/iconSkill"
local icon_play_path = "ignoreLayout/iconPlay"
local btn_play_path = "ignoreLayout/btnPlay"
local skill_name_path = "ignoreLayout/skillName"
local bg2_path = "ignoreLayout/bg2"
local type_name_path = "ignoreLayout/typeName"
local desc_path = "desc"
local detail_path = "detailRect"
local duration_name_path = "detailRect/durationName"
local duration_val_path = "detailRect/durationVal"
local consumption_name_path = "detailRect/consumptionName"
local consumption_val_path = "detailRect/consumptionVal"
local cd_name_path = "detailRect/cdName"
local cd_val_path = "detailRect/cdVal"

function UIDesertRulesEpidemicSkillCell:OnCreate()
  base.OnCreate(self)
  self.imgSkillIcon = self:AddComponent(UIImage, icon_skill_path)
  self.imgPlay = self:AddComponent(UIImage, icon_play_path)
  self.btnPlay = self:AddComponent(UIButton, btn_play_path)
  self.btnPlay:SetOnClick(function()
    self:ClickedSkill()
  end)
  self.tmpSkillName = self:AddComponent(UITextMeshProUGUIEx, skill_name_path)
  self.tmpTypeName = self:AddComponent(UITextMeshProUGUIEx, type_name_path)
  self.tmpDesc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.imgTypeBg = self:AddComponent(UIImage, bg2_path)
  self.detail = self:AddComponent(UIBaseComponent, detail_path)
  self.duration_name = self:AddComponent(UITextMeshProUGUIEx, duration_name_path)
  self.duration_val = self:AddComponent(UITextMeshProUGUIEx, duration_val_path)
  self.consumption_name = self:AddComponent(UITextMeshProUGUIEx, consumption_name_path)
  self.consumption_val = self:AddComponent(UITextMeshProUGUIEx, consumption_val_path)
  self.cd_name = self:AddComponent(UITextMeshProUGUIEx, cd_name_path)
  self.cd_val = self:AddComponent(UITextMeshProUGUIEx, cd_val_path)
end

function UIDesertRulesEpidemicSkillCell:OnDestroy()
  base.OnDestroy(self)
end

function UIDesertRulesEpidemicSkillCell:ReInit(template, battleType, onlyBaseInfo)
  self.battleType = battleType
  self.tmpSkillName:SetLocalText(template.name)
  if not string.IsNullOrEmpty(template.icon) then
    self.imgSkillIcon:LoadSpriteAuto(template.icon)
  end
  self.skillId = template.id
  if template.getDesc then
    self.tmpDesc:SetText(template:getDesc())
  else
    self.tmpDesc:SetLocalText(template.desc)
  end
  self.imgTypeBg:SetActive(not onlyBaseInfo)
  self.tmpTypeName:SetActive(not onlyBaseInfo)
  self.detail:SetActive(not onlyBaseInfo)
  self.imgPlay:SetActive(not onlyBaseInfo)
  self.btnPlay:SetActive(not onlyBaseInfo)
  if onlyBaseInfo then
    return
  end
  local color, key = DataCenter.ActEpidemicZoneManager:GetSkillTagInfo(template.tag)
  self.imgTypeBg:SetColor(color)
  self.tmpTypeName:SetLocalText(key)
  self.duration_name:SetLocalText("YiBianJinQu_skill_labels_1")
  self.consumption_name:SetLocalText("YiBianJinQu_skill_labels_2")
  self.cd_name:SetLocalText("YiBianJinQu_skill_labels_3")
  self.duration_val:SetLocalText("time_count_s", template.active_time)
  self.consumption_val:SetText(template.points_required)
  self.cd_val:SetLocalText("time_count_s", template.skill_CD)
end

function UIDesertRulesEpidemicSkillCell:ClickedSkill()
  if self.battleType == BattleFieldType.EpidemicZone then
    DataCenter.ActEpidemicZoneManager:PreviewSkill(self.skillId)
  end
end

return UIDesertRulesEpidemicSkillCell
