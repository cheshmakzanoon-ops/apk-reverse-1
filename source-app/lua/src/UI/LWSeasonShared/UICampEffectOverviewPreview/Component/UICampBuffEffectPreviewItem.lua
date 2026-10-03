local base = UIBaseContainer
local UICampBuffEffectPreviewItem = BaseClass("UICampBuffEffectPreviewItem", base)
local img_Icon_path = "UICampBuffItemBuff/Icon"
local btn_info_path = "UICampBuffItemBuff/btn_info"
local txt_value_path = "UICampBuffItemBuff/txt_value"
local txt_lv_path = "UICampBuffItemBuff/txt_lv"
local txt_des_path = "UICampBuffItemBuff/txt_des"
local go_current_path = "go_current"

function UICampBuffEffectPreviewItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UICampBuffEffectPreviewItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICampBuffEffectPreviewItem:ComponentDefine()
  self.img_Icon = self:AddComponent(UIImage, img_Icon_path)
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.txt_value = self:AddComponent(UIText, txt_value_path)
  self.txt_lv = self:AddComponent(UIText, txt_lv_path)
  self.txt_des = self:AddComponent(UIText, txt_des_path)
  self.go_current = self:AddComponent(UIBaseContainer, go_current_path)
end

function UICampBuffEffectPreviewItem:ComponentDestroy()
  self.img_Icon = nil
  self.btn_info = nil
  self.txt_value = nil
  self.txt_lv = nil
  self.txt_des = nil
  self.go_current = nil
end

function UICampBuffEffectPreviewItem:ReInit(config)
  self.go_current:SetActive(config.currentBuffId == config.id)
  self.img_Icon:LoadSprite(config.icon)
  self.txt_lv:SetLocalText(config.name, config.name_cfg)
  local strArray = string.split_ss_array(config.description_cfg, "|")
  self.txt_des:SetLocalText(config.description, table.unpack(strArray))
  if tonumber(config.type) == 1 then
    self.txt_value:SetLocalText("season_camp_science_ui_10", string.GetFormattedSeparatorNum(config.condition))
  else
    self.txt_value:SetLocalText("season_camp_science_ui_11", string.GetFormattedSeparatorNum(config.condition))
  end
end

return UICampBuffEffectPreviewItem
