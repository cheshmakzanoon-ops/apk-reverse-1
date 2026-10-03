local base = UIBaseContainer
local BattleSkillCell = BaseClass("BattleSkillCell", base)
local ActMgr = DataCenter.ActEpidemicZoneManager
local Localization = CS.GameEntry.Localization
local item_icon_path = "ItemIcon"
local name_text_path = "NameText"
local duration_text_path = "DurationText"
local cd_text_path = "CDText"
local play_btn_path = "PlayBtn"
local skill_type_path = "SkillType"
local type_text_path = "SkillType/TypeText"
local slider_path = "Slider"
local left_time_path = "Slider/LeftTime"
local info_btn_path = "Slider/InfoBtn"
local desc_text_path = "DescText"
local line_path = "Line"

function BattleSkillCell:OnCreate()
  base.OnCreate(self)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
  self.duration_text = self:AddComponent(UITextMeshProUGUIEx, duration_text_path)
  self.cd_text = self:AddComponent(UITextMeshProUGUIEx, cd_text_path)
  self.play_btn = self:AddComponent(UIButton, play_btn_path)
  self.play_btn:SetOnClick(BindCallback(self, self.OnClickBtnPreview))
  self.skill_type = self:AddComponent(UIImage, skill_type_path)
  self.type_text = self:AddComponent(UITextMeshProUGUIEx, type_text_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.left_time = self:AddComponent(UITextMeshProUGUIEx, left_time_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(BindCallback(self, self.OnClickBtnInfo))
  self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_text_path)
  self.line = self:AddComponent(UIImage, line_path)
end

function BattleSkillCell:OnDestroy()
  self.item_icon = nil
  self.name_text = nil
  self.play_btn = nil
  self.skill_type = nil
  self.type_text = nil
  self.slider = nil
  self.left_time = nil
  self.info_btn = nil
  self.desc_text = nil
  self.line = nil
  base.OnDestroy(self)
end

function BattleSkillCell:UpdateData(skillId, bList, bLast)
  self.skillId = skillId
  local template = ActMgr:GetTemplateSkillById(skillId)
  self.template = template
  if not string.IsNullOrEmpty(template.icon) then
    self.item_icon:LoadSpriteAuto(template.icon)
  end
  self.name_text:SetLocalText(template.name)
  local secStr = Localization:GetString("372115")
  local str = Localization:GetString("YiBianJinQu_skill_labels_1")
  self.duration_text:SetText(string.format("%s: %s%s", str, template.active_time, secStr))
  str = Localization:GetString("YiBianJinQu_skill_labels_3")
  self.cd_text:SetText(string.format("%s: %s%s", str, template.skill_CD, secStr))
  local maxNum = DataCenter.ActEpidemicZoneManager:FixSkillCost(template)
  local curNum = maxNum
  if not bList then
    curNum = ActMgr:GetBattleInfo().skillPoint
  end
  self.left_time:SetText(curNum .. "/" .. maxNum)
  local percent = math.min(curNum / maxNum, 1)
  self.slider:SetValue(percent)
  if template.getDesc then
    self.desc_text:SetText(template:getDesc())
  else
    self.desc_text:SetLocalText(template.desc)
  end
  self.play_btn:SetActive(bList)
  self.line:SetActive(bList and not bLast)
end

function BattleSkillCell:OnClickBtnPreview()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  ActMgr:PreviewSkill(self.skillId)
end

function BattleSkillCell:OnClickBtnInfo()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIEpidemicBattleSkillPoint)
end

return BattleSkillCell
