local UIWorldOutpostCityEmpty = BaseClass("UIWorldOutpostCityEmpty", UILayoutElement)
local base = UILayoutElement
local Localization = CS.GameEntry.Localization
local k1_path = "Status1/k1"
local v1_path = "Status1/v1"
local k2_path = "Status2/k2"
local v2_path = "Status2/v2"
local mgr_path = "Manager"
local mgr_btn_path = "Manager/MgrBtn"
local mgr_tips_path = "Manager/MgrTips"
local mgr_icon_path = "Manager/MgrIcon"
local desc_path = "Desc"
local line_content1_path = "LineContent1"
local line_content2_path = "LineContent2"
local city_force_path = "cityForce"
local city_force_btn_path = "cityForce/bg/cityForceBtn"
local city_force_icon_path = "cityForce/cityForceIcon"
local city_force_value_path = "cityForce/cityForceValue"
local line_content3_path = "LineContent3"

function UIWorldOutpostCityEmpty:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.k1:SetLocalText("war_zone_outpost_10")
  self.k2:SetLocalText("war_zone_outpost_12")
  self.v1:SetText("")
  self.v2:SetText("")
  self.desc:SetLocalText("war_zone_outpost_14")
  self.mgr_tips:SetLocalText("457006")
  self.mgr_btn:SetOnClick(function()
    self:OnMgrClick()
  end)
  local seasonSubType = SeasonUtil.GetSeasonSubdivisionType(false, ServerEnum.View)
  local templates = DataCenter.GovernmentTemplateManager:GetTemplatesByType(GovOfficialType.Outpost, seasonSubType)
  self.official:SetActive(0 < #templates)
  self.city_force_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonS5CrossOccupyDetail)
  end)
end

function UIWorldOutpostCityEmpty:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWorldOutpostCityEmpty:ComponentDefine()
  self.k1 = self:AddComponent(UITextMeshProUGUIEx, k1_path)
  self.v1 = self:AddComponent(UITextMeshProUGUIEx, v1_path)
  self.k2 = self:AddComponent(UITextMeshProUGUIEx, k2_path)
  self.v2 = self:AddComponent(UITextMeshProUGUIEx, v2_path)
  self.official = self:AddComponent(UIBaseComponent, mgr_path)
  self.mgr_btn = self:AddComponent(UIButton, mgr_btn_path)
  self.mgr_tips = self:AddComponent(UITextMeshProUGUIEx, mgr_tips_path)
  self.mgr_icon = self:AddComponent(UIImage, mgr_icon_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.line_content1 = self:AddComponent(UIBaseContainer, line_content1_path)
  self.line_content2 = self:AddComponent(UIBaseContainer, line_content2_path)
  self.city_force = self:AddComponent(UIBaseContainer, city_force_path)
  self.city_force_btn = self:AddComponent(UIButton, city_force_btn_path)
  self.city_force_icon = self:AddComponent(UIImage, city_force_icon_path)
  self.city_force_value = self:AddComponent(UITextMeshProUGUIEx, city_force_value_path)
  self.line_content3 = self:AddComponent(UIBaseContainer, line_content3_path)
end

function UIWorldOutpostCityEmpty:ComponentDestroy()
  self.city_force = nil
  self.city_force_btn = nil
  self.city_force_icon = nil
  self.city_force_value = nil
  self.line_content3 = nil
  self.k1 = nil
  self.v1 = nil
  self.k2 = nil
  self.v2 = nil
  self.mgr_btn = nil
  self.mgr_tips = nil
  self.mgr_icon = nil
  self.desc = nil
  self.line_content1 = nil
  self.line_content2 = nil
end

function UIWorldOutpostCityEmpty:OnMgrClick()
  UIUtil.ShowTipsId("outpost_commander_ui_18")
end

function UIWorldOutpostCityEmpty:InitData(param)
  self.param = param
  self.cityMeta = param.meta
  self.attackActData = param.attackActData
  self.extraInfo = param.extraInfo
  self.ownerServerId = 0
  self.ok = param.state == 1 and self.extraInfo ~= nil
  if self.ok then
    self.ownerServerId = toInt(self.extraInfo.ownerServerId)
    self.ok = self.ownerServerId <= 0
  end
  self:SetActive(self.ok)
  self:RefreshUI()
end

function UIWorldOutpostCityEmpty:RefreshData(serverData)
  self.serverData = serverData
  self.outpostDetailInfo = serverData.outpostDetailInfo
  self:RefreshUI()
end

function UIWorldOutpostCityEmpty:RefreshUI()
  if self.ok then
    self.v1:SetLocalText("new_city_activity_tips1013")
    self.v2:SetText(self:GetDeadRate())
    local force_num = 0
    if self.cityMeta then
      force_num = toInt(self.cityMeta.force)
    end
    if 0 < force_num then
      local value = string.GetFormattedSeparatorNum(force_num)
      self.line_content3:SetActive(true)
      self.city_force:SetActive(true)
      self.city_force_value:SetLocalText("season_s1_add_city_desc01", value)
    else
      self.line_content3:SetActive(false)
      self.city_force:SetActive(false)
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rectTransform)
end

function UIWorldOutpostCityEmpty:GetDeadRate()
  if self.cityMeta == nil then
    return ""
  end
  local wounded_rate = self.cityMeta.wounded_rate
  local injury_rate = self.cityMeta.injury_rate
  if wounded_rate and injury_rate then
    local rate = 100 - wounded_rate - injury_rate
    return rate .. "%"
  end
  return ""
end

return UIWorldOutpostCityEmpty
