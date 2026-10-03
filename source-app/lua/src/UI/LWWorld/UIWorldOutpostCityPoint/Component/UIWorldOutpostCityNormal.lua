local UIWorldOutpostCityNormal = BaseClass("UIWorldOutpostCityNormal", UILayoutElement)
local base = UILayoutElement
local Localization = CS.GameEntry.Localization
local k1_path = "Status1/k1"
local v1_path = "Status1/v1"
local k2_path = "Status2/k2"
local v2_path = "Status2/v2"
local k3_path = "Status3/k3"
local v3_path = "Status3/v3"
local first_occupy_path = "firstOccupy"
local first_occupy_alliance_name_path = "firstOccupy/firstOccupyAllianceName"
local first_occupy_alliance_data_path = "firstOccupy/firstOccupyAllianceData"
local mgr_btn_path = "Manager/MgrBtn"
local mgr_tips_path = "Manager/MgrTips"
local mgr_icon_path = "Manager/MgrIcon"
local mgr_path = "Manager"
local status4_path = "Status4"
local k4_path = "Status4/k4"
local v4_path = "Status4/v4"
local desc_path = "Desc"
local line_content1_path = "LineContent1"
local line_content2_path = "LineContent2"
local line_content3_path = "LineContent3"
local city_force_path = "cityForce"
local city_force_btn_path = "cityForce/bg/cityForceBtn"
local city_force_value_path = "cityForce/cityForceValue"
local line_content4_path = "LineContent4"

function UIWorldOutpostCityNormal:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.k1:SetLocalText("war_zone_outpost_10")
  self.k2:SetLocalText("war_zone_outpost_12")
  self.k4:SetLocalText("war_zone_outpost_13")
  self.v1:SetText("")
  self.v2:SetText("")
  self.v3:SetText("")
  self.v4:SetText("")
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

function UIWorldOutpostCityNormal:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIWorldOutpostCityNormal:ComponentDefine()
  self.k1 = self:AddComponent(UITextMeshProUGUIEx, k1_path)
  self.v1 = self:AddComponent(UITextMeshProUGUIEx, v1_path)
  self.k2 = self:AddComponent(UITextMeshProUGUIEx, k2_path)
  self.v2 = self:AddComponent(UITextMeshProUGUIEx, v2_path)
  self.k3 = self:AddComponent(UITextMeshProUGUIEx, k3_path)
  self.v3 = self:AddComponent(UITextMeshProUGUIEx, v3_path)
  self.first_occupy = self:AddComponent(UIBaseContainer, first_occupy_path)
  self.first_occupy_alliance_name = self:AddComponent(UITextMeshProUGUIEx, first_occupy_alliance_name_path)
  self.first_occupy_alliance_data = self:AddComponent(UITextMeshProUGUIEx, first_occupy_alliance_data_path)
  self.mgr_btn = self:AddComponent(UIButton, mgr_btn_path)
  self.mgr_tips = self:AddComponent(UITextMeshProUGUIEx, mgr_tips_path)
  self.mgr_icon = self:AddComponent(UIImage, mgr_icon_path)
  self.official = self:AddComponent(UIBaseComponent, mgr_path)
  self.k4 = self:AddComponent(UITextMeshProUGUIEx, k4_path)
  self.v4 = self:AddComponent(UITextMeshProUGUIEx, v4_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.line_content1 = self:AddComponent(UIBaseContainer, line_content1_path)
  self.line_content2 = self:AddComponent(UIBaseContainer, line_content2_path)
  self.line_content3 = self:AddComponent(UIBaseContainer, line_content3_path)
  self.status4 = self:AddComponent(UIImage, status4_path)
  self.city_force = self:AddComponent(UIBaseContainer, city_force_path)
  self.city_force_btn = self:AddComponent(UIButton, city_force_btn_path)
  self.city_force_value = self:AddComponent(UITextMeshProUGUIEx, city_force_value_path)
  self.line_content4 = self:AddComponent(UIBaseContainer, line_content4_path)
end

function UIWorldOutpostCityNormal:ComponentDestroy()
  self.k1 = nil
  self.v1 = nil
  self.k2 = nil
  self.v2 = nil
  self.k3 = nil
  self.v3 = nil
  self.first_occupy = nil
  self.first_occupy_alliance_name = nil
  self.first_occupy_alliance_data = nil
  self.mgr_btn = nil
  self.mgr_tips = nil
  self.mgr_icon = nil
  self.k4 = nil
  self.v4 = nil
  self.desc = nil
  self.line_content1 = nil
  self.line_content2 = nil
  self.line_content3 = nil
  self.status4 = nil
  self.city_force = nil
  self.city_force_btn = nil
  self.city_force_value = nil
  self.line_content4 = nil
end

function UIWorldOutpostCityNormal:OnMgrClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonOfficialMain, {anim = true}, GovOfficialType.Outpost, self.view.ctrl.serverId, self.view.ctrl.cityId)
end

function UIWorldOutpostCityNormal:InitData(param)
  self.param = param
  self.cityMeta = param.meta
  self.attackActData = param.attackActData
  self.extraInfo = param.extraInfo
  self.ownerServerId = 0
  self.ok = param.state == 1 and self.extraInfo ~= nil
  if self.ok then
    self.ownerServerId = toInt(self.extraInfo.ownerServerId)
    self.ok = self.ownerServerId > 0
  end
  self:SetActive(self.ok)
  self:RefreshUI()
end

function UIWorldOutpostCityNormal:RefreshData(serverData)
  self.serverData = serverData
  self.outpostDetailInfo = serverData.outpostDetailInfo
  self:RefreshUI()
end

function UIWorldOutpostCityNormal:RefreshUI()
  if self.ok then
    local ownerServerId = tostring(self.extraInfo.ownerServerId)
    local firstOccupyTime = toInt(self.extraInfo.firstOccupyTime)
    self.v1:SetText("#" .. ownerServerId)
    self.v2:SetText(self:GetDeadRate())
    self.v4:SetText("#" .. ownerServerId)
    self.first_occupy:SetActive(true)
    local nameStr = UIUtil.FormatAllianceAndName(self.extraInfo.firstOccupyAllianceAbbr, self.extraInfo.firstOccupyAllianceName)
    local timeStr = UITimeManager:GetInstance():GetTimeToMD(math.floor(firstOccupyTime / 1000))
    self.first_occupy_alliance_name:SetText(nameStr)
    self.first_occupy_alliance_data:SetText(Localization:GetString("300728", timeStr))
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

function UIWorldOutpostCityNormal:GetDeadRate()
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

return UIWorldOutpostCityNormal
