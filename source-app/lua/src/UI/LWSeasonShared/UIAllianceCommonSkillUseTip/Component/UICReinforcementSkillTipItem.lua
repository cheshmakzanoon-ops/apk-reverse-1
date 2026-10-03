local base = UIBaseContainer
local UICReinforcementSkillTipItem = BaseClass("UICReinforcementSkillTipItem", base)
local txt_title_path = "title/txt_title"
local txt_name_path = "go_city/Pos/txt_name"
local img_icon_path = "go_city/img_icon"
local txt_value_stage1_path = "go_effect1/txt_value_stage1"
local sli_Slider_path = "LW_Simple_Slider/Slider"
local txt_value_stage2_path = "go_effect2/txt_value_stage2"

function UICReinforcementSkillTipItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UICReinforcementSkillTipItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICReinforcementSkillTipItem:ComponentDefine()
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.txt_name = self:AddComponent(UIText, txt_name_path)
  self.img_icon = self:AddComponent(UIImage, img_icon_path)
  self.txt_value_stage1 = self:AddComponent(UIText, txt_value_stage1_path)
  self.sli_Slider = self:AddComponent(UISlider, sli_Slider_path)
  self.txt_value_stage2 = self:AddComponent(UIText, txt_value_stage2_path)
end

function UICReinforcementSkillTipItem:ComponentDestroy()
  self.txt_title = nil
  self.txt_name = nil
  self.img_icon = nil
  self.txt_value_stage1 = nil
  self.sli_Slider = nil
  self.txt_value_stage2 = nil
end

function UICReinforcementSkillTipItem:ReInit(data, txtDesc)
  self.data = data
  local skillName = CS.GameEntry.Localization:GetString(self.data.scoreConfig.skill_name)
  txtDesc:SetLocalText("season_s6_government_skill_desc19", skillName)
  self.txt_title:SetLocalText("season_s6_government_skill_desc20")
  local pointId = self.data.logic.pointId
  local isCityOrPlayerBuild = false
  local pointInfo = CS.SceneManager.World:GetPointInfo(pointId)
  if not IsNull(pointInfo) and pointInfo.PointType == WorldPointType.WORLD_ALLIANCE_CITY then
    isCityOrPlayerBuild = true
    local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(pointInfo.CityId, LuaEntry.Player:GetSelfServerId())
    self.txt_name:SetText(meta:GetName())
    self.img_icon:LoadSpriteAuto(meta:GetIconPath())
    self.txt_value_stage2:SetText(meta.wall)
    local extraData = PBController.ParsePbFromBytes(pointInfo.extraInfo, "protobuf.AllianceCityPointInfo")
    self.sli_Slider:SetValue(extraData.durability / meta.wall)
  end
  self.txt_value_stage1:SetText(data.config.skill_para1)
end

return UICReinforcementSkillTipItem
