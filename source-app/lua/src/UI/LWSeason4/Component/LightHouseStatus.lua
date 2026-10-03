local LightHouseStatus = BaseClass("LightHouseStatus", UIBaseContainer)
local base = UIBaseContainer

function LightHouseStatus:OnCreate()
  base.OnCreate(self)
  self.power_status_icon = self:AddComponent(UIImage, "")
  self.power_status_txt = self:AddComponent(UITextMeshProUGUIEx, "PowerStatusTxt")
  self:RefreshUI()
end

function LightHouseStatus:OnDestroy()
  self.power_status_icon = nil
  self.power_status_txt = nil
  base.OnDestroy(self)
end

function LightHouseStatus:RefreshUI()
  self.power_status_txt:SetText("")
  local iconName = "Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_03.png"
  local lightHouseStatus = DataCenter.SeasonPowerWorkerManager.lightHouseStatus
  if lightHouseStatus == nil or lightHouseStatus.active ~= true then
    iconName = "Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_01.png"
  else
    local powerNow, powerMax = DataCenter.SeasonPowerWorkerManager:GetBatteryPowerResourceInfo()
    local brightnessLevel = toInt(lightHouseStatus.brightnessLevel)
    if brightnessLevel == 0 then
      if powerNow == powerMax then
        iconName = "Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_08.png"
      elseif powerNow == 0 then
        iconName = "Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_02.png"
      else
        iconName = "Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_03.png"
      end
      self.power_status_txt:SetText("")
    elseif brightnessLevel == 1 then
      self.power_status_txt:SetText("L1")
      iconName = "Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_04.png"
    elseif brightnessLevel == 2 then
      self.power_status_txt:SetText("L2")
      iconName = "Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_05.png"
    elseif brightnessLevel == 3 then
      self.power_status_txt:SetText("L3")
      iconName = "Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_06.png"
    elseif brightnessLevel == 4 then
      self.power_status_txt:SetText("L4")
      iconName = "Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_07.png"
    end
    if powerNow == powerMax and 0 < brightnessLevel then
      iconName = "Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_qipaoa_09.png"
    end
  end
  self.power_status_icon:LoadSprite(iconName)
end

return LightHouseStatus
