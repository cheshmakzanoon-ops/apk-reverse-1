local img_bg_state_clock_path = "img_bg_state_clock"
local p_go_state_time_select_path = "p_go_state_time_select"
local p_text_state_time_select_path = "p_go_state_time_select/p_text_state_time_select"
local p_go_state_time_unselect_path = "p_go_state_time_unselect"
local p_text_state_time_unselect_path = "p_go_state_time_unselect/p_text_state_time_unselect"
local base = UIBaseContainer
local SeasonCampDestroyWarTimeStateTimeCell = BaseClass("SeasonCampDestroyWarTimeStateTimeCell", UIBaseContainer)

function SeasonCampDestroyWarTimeStateTimeCell:ComponentDefine()
  self.img_bg_state_clock = self:AddComponent(UIButton, img_bg_state_clock_path)
  self.img_bg_state_clock:SetOnClick(BindCallback(self, self.OnClockClicked))
  self.p_go_state_time_select = self:AddComponent(UIBaseContainer, p_go_state_time_select_path)
  self.p_text_state_time_select = self:AddComponent(UITextMeshProUGUIEx, p_text_state_time_select_path)
  self.p_go_state_time_unselect = self:AddComponent(UIBaseContainer, p_go_state_time_unselect_path)
  self.p_text_state_time_unselect = self:AddComponent(UITextMeshProUGUIEx, p_text_state_time_unselect_path)
end

function SeasonCampDestroyWarTimeStateTimeCell:ComponentDestroy()
  self.img_bg_state_clock = nil
  self.p_go_state_time_select = nil
  self.p_text_state_time_select = nil
  self.p_go_state_time_unselect = nil
  self.p_text_state_time_unselect = nil
end

function SeasonCampDestroyWarTimeStateTimeCell:DataDefine()
end

function SeasonCampDestroyWarTimeStateTimeCell:DataDestroy()
  self.Data = nil
  self.WarTimeData = nil
end

function SeasonCampDestroyWarTimeStateTimeCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonCampDestroyWarTimeStateTimeCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCampDestroyWarTimeStateTimeCell:OnAddListener()
  base.OnAddListener(self)
end

function SeasonCampDestroyWarTimeStateTimeCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonCampDestroyWarTimeStateTimeCell:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function SeasonCampDestroyWarTimeStateTimeCell:InitData(data)
  if data ~= nil then
    self.Data = data
    self.WarTimeData = DataCenter.SeasonCampDestroyManager:GetWarTimeConfigData(self.Data.TimeIndex)
    return self.Data ~= nil
  end
  return false
end

function SeasonCampDestroyWarTimeStateTimeCell:InitUi()
  if self.WarTimeData ~= nil then
    if self.Data.IsLocalTime then
      self.p_text_state_time_select:SetText(self.WarTimeData:GetLocalTimeRangeStr())
      self.p_text_state_time_unselect:SetText(self.WarTimeData:GetLocalTimeRangeStr())
    else
      self.p_text_state_time_select:SetText(self.WarTimeData:GetServerTimeRangeStr())
      self.p_text_state_time_unselect:SetText(self.WarTimeData:GetServerTimeRangeStr())
    end
  end
  self.p_go_state_time_select:SetActive(self.Data.IsSelect)
  self.p_go_state_time_unselect:SetActive(not self.Data.IsSelect)
end

function SeasonCampDestroyWarTimeStateTimeCell:OnClockClicked()
  if self.Data ~= nil and self.Data.ClockClickEnable then
    local key = ""
    local index = checknumber(self.Data.TimeIndex)
    if index == 0 then
      key = "s5_alliance_battle_time_ui10"
    elseif index == 1 then
      key = "s5_alliance_battle_time_ui11"
    elseif index == 2 then
      key = "s5_alliance_battle_time_ui12"
    end
    if key ~= "" then
      UIUtil.ShowBubbleTips(CS.GameEntry.Localization:GetString(key), self.img_bg_state_clock.transform.position, 0, -30, 0)
    end
  end
end

return SeasonCampDestroyWarTimeStateTimeCell
