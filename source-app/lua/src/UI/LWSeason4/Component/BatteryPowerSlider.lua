local BatteryPowerSlider = BaseClass("BatteryPowerSlider", UIAsyncContainer)
local base = UIAsyncContainer

function BatteryPowerSlider:OnCreate()
  base.OnCreate(self)
  self.power_slider = self:AddComponent(UISlider, "")
  self.background = self:AddComponent(UIImage, "Background")
  self.power_icon = self:AddComponent(UIImage, "power_icon")
  self.lastTipMsg = nil
end

function BatteryPowerSlider:OnDestroy()
  self.power_slider = nil
  self.power_icon = nil
  self.background = nil
  self.resNumTxt = nil
  base.OnDestroy(self)
end

function BatteryPowerSlider:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BatteryPowerResourceUpdated, self.UpdateData)
end

function BatteryPowerSlider:OnRemoveListener()
  self:RemoveUIListener(EventId.BatteryPowerResourceUpdated, self.UpdateData)
  base.OnRemoveListener(self)
end

function BatteryPowerSlider:UpdateData()
  if IsNull(self.gameObject) then
    return
  end
  local powerNow, powerMax, powerSpeed = DataCenter.SeasonPowerWorkerManager:GetBatteryPowerResourceInfo()
  self.power_icon:SetActive(powerSpeed ~= 0)
  if powerNow == 0 then
    self.powerValue = 0
    self.power_slider:SetValue(0)
    self.background:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_diandeng_dianchi_04.png")
    if ComponentIsValid(self.resNumTxt) then
      self.resNumTxt:SetText("<color=#f97077>0</color>")
    end
  elseif powerMax ~= nil and powerMax ~= 0 then
    local rate = powerNow / powerMax
    if powerNow == powerMax then
      self.power_slider:SetValue(1)
      self.background:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_diandeng_dianchi_04.png")
      if ComponentIsValid(self.resNumTxt) then
        self.resNumTxt:SetText("<color=#5fef87>" .. string.GetFormattedStr(powerNow) .. "</color>")
      end
    elseif rate < 0.1 then
      self.power_slider:SetValue(0)
      self.background:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_diandeng_dianchi_03.png")
      if ComponentIsValid(self.resNumTxt) then
        self.resNumTxt:SetText("<color=#f97077>" .. string.GetFormattedStr(powerNow) .. "</color>")
      end
    else
      self.power_slider:SetValue(rate)
      self.background:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_diandeng_dianchi_04.png")
      if ComponentIsValid(self.resNumTxt) then
        self.resNumTxt:SetText("<color=#FFFFFF>" .. string.GetFormattedStr(powerNow) .. "</color>")
      end
    end
    self.powerValue = rate
  else
    self.powerValue = 0
    self.power_slider:SetValue(0)
    self.background:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_diandeng_dianchi_04.png")
    if ComponentIsValid(self.resNumTxt) then
      self.resNumTxt:SetText("<color=#f97077>0</color>")
    end
  end
  if powerMax ~= 0 then
    if powerMax == powerNow and 0 <= powerSpeed then
      if self.lastTipMsg ~= "season_s4_building_ui_info54" then
        UIUtil.ShowTipsId("season_s4_building_ui_info54")
        self.lastTipMsg = "season_s4_building_ui_info54"
      end
    elseif powerNow == 0 and powerSpeed <= 0 and self.lastTipMsg ~= "season_s4_building_ui_info55" then
      UIUtil.ShowTipsId("season_s4_building_ui_info55")
      self.lastTipMsg = "season_s4_building_ui_info55"
    end
  end
end

function BatteryPowerSlider:GetValue()
  return toInt(self.powerValue)
end

function BatteryPowerSlider:SetTextComponent(text_node)
  self.resNumTxt = text_node
end

function BatteryPowerSlider:Update1000MS()
  self:UpdateData()
end

return BatteryPowerSlider
