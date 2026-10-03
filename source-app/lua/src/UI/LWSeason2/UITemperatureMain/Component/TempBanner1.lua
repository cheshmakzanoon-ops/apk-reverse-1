local TempBanner1 = BaseClass("TempBanner1", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local world_temp_text_path = "worldTempText"
local world_tip_btn_path = "worldTipBtn"
local world_text_path = "worldText"
local weather_path = "weather"
local weather_text_path = "weather/weatherText"
local base_temp_text_path = "baseTempText"
local base_tip_btn_path = "baseTipBtn"
local base_text_path = "baseText"
local stove_text_path = "stove/stoveText"
local phase_path = "phase"
local phase_text_path = "phase/phaseText"
local phase_icon_path = "phase/phaseIcon"
local up_path = "up"
local down_path = "down"

function TempBanner1:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function TempBanner1:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TempBanner1:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MyBaseThermalRefresh, self.Refresh)
end

function TempBanner1:OnRemoveListener()
  self:RemoveUIListener(EventId.MyBaseThermalRefresh, self.Refresh)
  base.OnRemoveListener(self)
end

function TempBanner1:ComponentDefine()
  self.world_temp_text = self:AddComponent(UITextMeshProUGUIEx, world_temp_text_path)
  self.world_tip_btn = self:AddComponent(UIButton, world_tip_btn_path)
  self.world_tip_btn:SetOnClick(function()
    local content = Localization:GetString("season_s2_temperature_ui_info01")
    UIUtil.ShowBubbleTips(content, self.world_tip_btn.transform.position, 0, -30, -20)
  end)
  local world_text = self:AddComponent(UITextMeshProUGUIEx, world_text_path)
  world_text:SetLocalText("season_s2_temperature_ui_tab1")
  self.weather = self:AddComponent(UIImage, weather_path)
  self.weather_text = self:AddComponent(UITextMeshProUGUIEx, weather_text_path)
  self.base_temp_text = self:AddComponent(UITextMeshProUGUIEx, base_temp_text_path)
  self.base_tip_btn = self:AddComponent(UIButton, base_tip_btn_path)
  self.base_tip_btn:SetOnClick(function()
    local content = Localization:GetString("season_s2_temperature_ui_info02")
    UIUtil.ShowBubbleTips(content, self.base_tip_btn.transform.position, 0, -30, -20)
  end)
  local base_text = self:AddComponent(UITextMeshProUGUIEx, base_text_path)
  base_text:SetLocalText("season_s2_temperature_ui_tab5")
  self.stove_text = self:AddComponent(UITextMeshProUGUIEx, stove_text_path)
  self.phase = self:AddComponent(UIImage, phase_path)
  self.phase_text = self:AddComponent(UITextMeshProUGUIEx, phase_text_path)
  self.phase_icon = self:AddComponent(UIImage, phase_icon_path)
  self.up = self:AddComponent(UIBaseComponent, up_path)
  self.down = self:AddComponent(UIBaseComponent, down_path)
end

function TempBanner1:ComponentDestroy()
end

function TempBanner1:Refresh()
  local myTileTemp = DataCenter.TemperatureManager:GetMyEnvTemperature()
  self.world_temp_text:SetLocalText("season_s2_common_temperature", string.format("%.1f", myTileTemp))
  self.showBlizzard, self.blizzardTs = DataCenter.SeasonSnowStormDataManager:NeedShowBlizzardInMainUI()
  self.weather:SetActive(self.showBlizzard)
  local state = DataCenter.BuildManager:GetFurnaceStateAndTemp()
  if state == HeatSourceState.None then
    self.stove_text:SetLocalText("season_s2_temperature_ui_status04")
  elseif state == HeatSourceState.Close then
    self.stove_text:SetLocalText("season_s2_temperature_ui_status01")
  elseif state == HeatSourceState.Active then
    self.stove_text:SetLocalText("season_s2_temperature_ui_status02")
  elseif state == HeatSourceState.Overload then
    self.stove_text:SetLocalText("season_s2_temperature_ui_status03")
  end
  local conductor = DataCenter.TemperatureManager:GetMyBaseConductor()
  if conductor.phase == ThermalPhase.Normal and conductor.nextPhase == ThermalPhase.None then
    self.showPhase = false
  else
    self.showPhase = true
  end
  self.phase:SetActive(self.showPhase)
  self:Update1000MS()
end

function TempBanner1:Update1000MS()
  local myBaseTemp = DataCenter.TemperatureManager:GetMyBaseTemperature()
  local myBaseTempStr = string.format("%.1f", myBaseTemp)
  self.base_temp_text:SetLocalText("season_s2_common_temperature", myBaseTempStr)
  local myTileTemp = DataCenter.TemperatureManager:GetMyEnvTemperature()
  local myTileTempStr = string.format("%.1f", myTileTemp)
  if myBaseTempStr == myTileTempStr then
    self.up:SetActive(false)
    self.down:SetActive(false)
  elseif myBaseTemp > myTileTemp then
    self.up:SetActive(false)
    self.down:SetActive(true)
  else
    self.up:SetActive(true)
    self.down:SetActive(false)
  end
  if self.showPhase then
    local conductor = DataCenter.TemperatureManager:GetMyBaseConductor()
    local now = UITimeManager:GetInstance():GetServerTime()
    local remain = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutHour(conductor.nextPhaseEndTime - now)
    local phaseChangeType = conductor:GetPhaseChangeType()
    if phaseChangeType == PhaseChangeType.ToFrozen then
      self.phase_text:SetLocalText("season_s2_status_name_001", remain)
      self.phase_icon:LoadSprite("Assets/Main/Sprites/UI/UITemperature/FX_S2saiji_icon_bing.png")
    elseif phaseChangeType == PhaseChangeType.ToFire then
      self.phase_text:SetLocalText("season_s2_status_name_002", remain)
      self.phase_icon:LoadSprite("Assets/Main/Sprites/UI/UITemperature/FX_S2saiji_icon_re.png")
    elseif phaseChangeType == PhaseChangeType.FrozenToNormal then
      self.phase_text:SetLocalText("season_s2_status_name_003", remain)
      self.phase_icon:LoadSprite("Assets/Main/Sprites/UI/UITemperature/FX_S2saiji_icon_bing.png")
    elseif phaseChangeType == PhaseChangeType.FireToNormal then
      self.phase_text:SetLocalText("season_s2_status_name_004", remain)
      self.phase_icon:LoadSprite("Assets/Main/Sprites/UI/UITemperature/FX_S2saiji_icon_re.png")
    elseif conductor.phase == ThermalPhase.Frozen then
      self.phase_text:SetLocalText("season_s2_status_name_freeze")
      self.phase_icon:LoadSprite("Assets/Main/Sprites/UI/UITemperature/FX_S2saiji_icon_bing.png")
    elseif conductor.phase == ThermalPhase.Fire then
      self.phase_text:SetLocalText("season_s2_status_name_fire")
      self.phase_icon:LoadSprite("Assets/Main/Sprites/UI/UITemperature/FX_S2saiji_icon_re.png")
    end
  end
  if self.showBlizzard then
    local level = DataCenter.SeasonSnowStormDataManager:GetCurBlizzardLevel()
    local blizzardStr = CS.GameEntry.Localization:GetString("season_s2_storm_event_05", level)
    local now = UITimeManager:GetInstance():GetServerTime()
    local timeStr = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutDay(self.blizzardTs - now)
    self.weather_text:SetText(blizzardStr .. " " .. timeStr)
  end
end

return TempBanner1
