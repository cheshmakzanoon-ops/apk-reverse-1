local TempBanner3 = BaseClass("TempBanner3", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local base_path = "base"
local base_temp_text_path = "base/baseTempText"
local base_btn_path = "base/baseBtn"
local env_path = "env"
local env_temp_text_path = "env/envTempText"
local env_btn_path = "env/envBtn"
local history_btn_path = "historyBtn"
local FACE_DISTANCE = 138
local DIS_PER_TEMP = FACE_DISTANCE / 20

function TempBanner3:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function TempBanner3:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TempBanner3:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MyBaseThermalRefresh, self.Refresh)
end

function TempBanner3:OnRemoveListener()
  self:RemoveUIListener(EventId.MyBaseThermalRefresh, self.Refresh)
  base.OnRemoveListener(self)
end

function TempBanner3:ComponentDefine()
  self.base = self:AddComponent(UIBaseComponent, base_path)
  self.base_temp_text = self:AddComponent(UITextMeshProUGUIEx, base_temp_text_path)
  self.base_btn = self:AddComponent(UIButton, base_btn_path)
  self.base_btn:SetOnClick(function()
    local content = Localization:GetString("season_s2_temperature_ui_info01")
    UIUtil.ShowBubbleTips(content, self.base_btn.transform.position, 0, -30, -20)
  end)
  self.env = self:AddComponent(UIBaseComponent, env_path)
  self.env_temp_text = self:AddComponent(UITextMeshProUGUIEx, env_temp_text_path)
  self.env_btn = self:AddComponent(UIButton, env_btn_path)
  self.env_btn:SetOnClick(function()
    local content = Localization:GetString("season_s2_temperature_ui_info02")
    UIUtil.ShowBubbleTips(content, self.env_btn.transform.position, 0, -30, -20)
  end)
  self.history_btn = self:AddComponent(UIButton, history_btn_path)
  self.history_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITemperatureHistory)
  end)
end

function TempBanner3:ComponentDestroy()
end

function TempBanner3:Refresh()
  local myTileTemp = DataCenter.TemperatureManager:GetMyEnvTemperature()
  self.env_temp_text:SetLocalText("season_s2_common_temperature", string.format("%.1f", myTileTemp))
  self.env_temp_text:SetColor(UIUtil.HexToColor(DataCenter.TemperatureTemplateManager:GetTextColor(myTileTemp)))
  local envX = self:GetPositionXByTemperature(myTileTemp)
  local pos = self.env:GetAnchoredPosition()
  pos.x = envX
  self.env:SetAnchoredPosition(pos)
  self:Update100MS()
end

function TempBanner3:Update100MS()
  local baseTemp = DataCenter.TemperatureManager:GetMyBaseTemperature()
  local baseTempStr = string.format("%.1f", baseTemp)
  self.base_temp_text:SetColor(UIUtil.HexToColor(DataCenter.TemperatureTemplateManager:GetTextColor(baseTemp)))
  self.base_temp_text:SetLocalText("season_s2_common_temperature", baseTempStr)
  local baseX = self:GetPositionXByTemperature(baseTemp)
  local pos = self.base:GetAnchoredPosition()
  pos.x = baseX
  self.base:SetAnchoredPosition(pos)
end

function TempBanner3:GetPositionXByTemperature(t)
  local x = 0
  if 0 <= t and t <= 40 then
    x = DIS_PER_TEMP * t
  elseif -20 <= t and t < 0 then
    x = 2 * DIS_PER_TEMP * t
  elseif 40 < t then
    x = 2 * FACE_DISTANCE + DIS_PER_TEMP * Mathf.Log(t - 39)
  else
    x = -2 * FACE_DISTANCE - 2 * DIS_PER_TEMP * Mathf.Log(-t - 19)
  end
  return x
end

return TempBanner3
