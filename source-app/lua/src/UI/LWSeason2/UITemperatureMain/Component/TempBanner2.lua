local TempBanner2 = BaseClass("TempBanner2", UIBaseContainer)
local base = UIBaseContainer
local base_temp_text_path = "baseTempText"
local base_text_path = "baseText"
local stove_text_path = "stove/stoveText"
local phase_path = "phase"
local phase_text_path = "phase/phaseText"
local phase_icon_path = "phase/phaseIcon"

function TempBanner2:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function TempBanner2:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TempBanner2:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MyBaseThermalRefresh, self.Refresh)
end

function TempBanner2:OnRemoveListener()
  self:RemoveUIListener(EventId.MyBaseThermalRefresh, self.Refresh)
  base.OnRemoveListener(self)
end

function TempBanner2:ComponentDefine()
  self.base_temp_text = self:AddComponent(UITextMeshProUGUIEx, base_temp_text_path)
  local base_text = self:AddComponent(UITextMeshProUGUIEx, base_text_path)
  base_text:SetLocalText("season_s2_temperature_ui_tab5")
  self.stove_text = self:AddComponent(UITextMeshProUGUIEx, stove_text_path)
  self.phase = self:AddComponent(UIImage, phase_path)
  self.phase_text = self:AddComponent(UITextMeshProUGUIEx, phase_text_path)
  self.phase_icon = self:AddComponent(UIImage, phase_icon_path)
end

function TempBanner2:ComponentDestroy()
end

function TempBanner2:Refresh()
  local conductor = DataCenter.TemperatureManager:GetMyBaseConductor()
  if conductor.phase == ThermalPhase.Normal and conductor.nextPhase == ThermalPhase.None then
    self.showPhase = false
  else
    self.showPhase = true
  end
  self.phase:SetActive(self.showPhase)
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
  self:Update1000MS()
end

function TempBanner2:Update1000MS()
  local myBaseTemp = DataCenter.TemperatureManager:GetMyBaseTemperature()
  self.base_temp_text:SetLocalText("season_s2_common_temperature", string.format("%.1f", myBaseTemp))
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
end

return TempBanner2
