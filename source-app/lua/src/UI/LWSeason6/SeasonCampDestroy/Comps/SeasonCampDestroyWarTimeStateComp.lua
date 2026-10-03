local p_text_state_time_zone_path = "p_text_state_time_zone"
local p_btn_state_switch_time_zone_path = "p_btn_state_switch_time_zone"
local p_go_state_time_0_path = "p_trans_root_state_time/p_go_state_time_0"
local p_go_state_time_1_path = "p_trans_root_state_time/p_go_state_time_1"
local p_go_state_time_2_path = "p_trans_root_state_time/p_go_state_time_2"
local state_time_cell_script = require("UI.LWSeason6.SeasonCampDestroy.Comps.SeasonCampDestroyWarTimeStateTimeCell")
local base = UIBaseContainer
local SeasonCampDestroyWarTimeStateComp = BaseClass("SeasonCampDestroyWarTimeStateComp", UIBaseContainer)

function SeasonCampDestroyWarTimeStateComp:ComponentDefine()
  self.p_text_state_time_zone = self:AddComponent(UITextMeshProUGUIEx, p_text_state_time_zone_path)
  self.p_btn_state_switch_time_zone = self:AddComponent(UIButton, p_btn_state_switch_time_zone_path)
  self.p_go_state_time_0 = self:AddComponent(state_time_cell_script, p_go_state_time_0_path)
  self.p_go_state_time_1 = self:AddComponent(state_time_cell_script, p_go_state_time_1_path)
  self.p_go_state_time_2 = self:AddComponent(state_time_cell_script, p_go_state_time_2_path)
  self.p_btn_state_switch_time_zone:SetOnClick(BindCallback(self, self.OnSwitchTimeZoneClicked))
end

function SeasonCampDestroyWarTimeStateComp:ComponentDestroy()
  self.p_text_state_time_zone = nil
  self.p_btn_state_switch_time_zone = nil
  self.p_go_state_time_0 = nil
  self.p_go_state_time_1 = nil
  self.p_go_state_time_2 = nil
end

function SeasonCampDestroyWarTimeStateComp:DataDefine()
end

function SeasonCampDestroyWarTimeStateComp:DataDestroy()
end

function SeasonCampDestroyWarTimeStateComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonCampDestroyWarTimeStateComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCampDestroyWarTimeStateComp:OnAddListener()
  base.OnAddListener(self)
end

function SeasonCampDestroyWarTimeStateComp:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonCampDestroyWarTimeStateComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function SeasonCampDestroyWarTimeStateComp:InitData(data)
  if data ~= nil then
    self.Data = data
    self.IsLocalTime = self.Data.IsLocalTime
    self.RealTimeIndex = DataCenter.SeasonCampDestroyManager:GetRealTimeIndex(self.Data.TimeIndex, self.Data.SetTime)
    if self.Data.PreviewMode then
      self.RealTimeIndex = self.Data.TimeIndex
    end
    return true
  end
  return false
end

function SeasonCampDestroyWarTimeStateComp:InitUi()
end

function SeasonCampDestroyWarTimeStateComp:UpdateData()
  return true
end

function SeasonCampDestroyWarTimeStateComp:UpdateUi()
  if self.Data ~= nil then
    for i = 0, 2 do
      local go_state_time = self["p_go_state_time_" .. i]
      local data = {}
      data.IsLocalTime = self.IsLocalTime
      data.TimeIndex = i
      data.IsSelect = self.RealTimeIndex == i
      data.ClockClickEnable = self.Data.ClockClickEnable
      go_state_time:ReInit(data)
    end
  end
  self:Update1000MS()
end

function SeasonCampDestroyWarTimeStateComp:OnSwitchTimeZoneClicked()
  self.IsLocalTime = not self.IsLocalTime
  self:UpdateUi()
end

function SeasonCampDestroyWarTimeStateComp:Update1000MS()
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.IsLocalTime then
    local dateStr = UITimeManager:GetInstance():TimeStampToTimeForLocal(now)
    local title = string.format("%s: %s", CS.GameEntry.Localization:GetString("s5_alliance_battle_time_ui03"), dateStr)
    self.p_text_state_time_zone:SetText(title)
  else
    local dateStr = UITimeManager:GetInstance():TimeStampToTimeForServer(now)
    local title = string.format("%s: %s", CS.GameEntry.Localization:GetString("s5_alliance_battle_time_ui02"), dateStr)
    self.p_text_state_time_zone:SetText(title)
  end
end

return SeasonCampDestroyWarTimeStateComp
