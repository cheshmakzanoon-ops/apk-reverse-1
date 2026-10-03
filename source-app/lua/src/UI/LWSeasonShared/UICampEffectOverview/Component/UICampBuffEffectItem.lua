local base = UIBaseContainer
local UICampBuffEffectItem = BaseClass("UICampBuffEffectItem", base)
local img_Icon_path = "Icon"
local btn_info_path = "btn_info"
local txt_value_path = "txt_value"
local txt_lv_path = "txt_lv"
local txt_des_path = "txt_des"

function UICampBuffEffectItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UICampBuffEffectItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICampBuffEffectItem:ComponentDefine()
  self.img_Icon = self:AddComponent(UIImage, img_Icon_path)
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.txt_value = self:AddComponent(UIText, txt_value_path)
  self.txt_lv = self:AddComponent(UIText, txt_lv_path)
  self.txt_des = self:AddComponent(UIText, txt_des_path)
  self.btn_info:SetOnClick(BindCallback(self, self.ClickBtnInfo))
end

function UICampBuffEffectItem:ComponentDestroy()
  self.img_Icon = nil
  self.btn_info = nil
  self.txt_value = nil
  self.txt_lv = nil
  self.txt_des = nil
end

function UICampBuffEffectItem:ClickBtnInfo()
  if self.buffInfo ~= nil then
    local campId = self.buffInfo.campId or DataCenter.SeasonFactionWarDataManager.myCampId
    local buffList = DataCenter.CampScienceDataManager:GetSeasonCampBuffsByCampAndType(campId, self.buffInfo.type)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICampEffectOverviewPreview, {anim = true}, buffList, self.buffInfo)
  end
end

function UICampBuffEffectItem:ReInit(buffInfo)
  self.buffInfo = buffInfo
  local config = buffInfo.config
  self.img_Icon:LoadSprite(config.icon)
  self.txt_lv:SetLocalText(config.name, config.name_cfg)
  local strArray = string.split_ss_array(config.description_cfg, "|")
  self.txt_des:SetLocalText(config.description, table.unpack(strArray))
  if buffInfo.type == 1 then
    self.txt_value:SetLocalText("season_camp_science_ui_10", string.GetFormattedSeparatorNum(buffInfo.value))
  else
    self.txt_value:SetLocalText("season_camp_science_ui_11", string.GetFormattedSeparatorNum(buffInfo.value))
  end
end

return UICampBuffEffectItem
