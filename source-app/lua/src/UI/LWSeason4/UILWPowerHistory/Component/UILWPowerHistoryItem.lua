local UILWPowerHistoryItem = BaseClass("UILWPowerHistoryItem", UIBaseContainer)
local base = UIBaseContainer

function UILWPowerHistoryItem:OnCreate()
  base.OnCreate(self)
  self.title_txt = self:AddComponent(UITextMeshProUGUIEx, "SubTitleTxt")
  self.time_text = self:AddComponent(UITextMeshProUGUIEx, "TimeText")
end

function UILWPowerHistoryItem:OnDestroy()
  self.title_txt = nil
  self.time_text = nil
  base.OnDestroy(self)
end

function UILWPowerHistoryItem:ReInit(index, data)
  self.time_text:SetText(UITimeManager:GetInstance():GetServerTimeByUTC(data.eventTime or 0, false))
  if data.reasonType == 0 then
    self.title_txt:SetLocalText("season_s4_building_ui_info51", data.oldLevel, data.newLevel)
  elseif data.reasonType == 1 then
    self.title_txt:SetLocalText("season_s4_building_ui_info53", data.oldLevel, data.newLevel)
  elseif data.reasonType == 2 then
    self.title_txt:SetLocalText("season_s4_building_ui_info52", data.oldLevel, data.newLevel)
  elseif data.reasonType == 3 then
    self.title_txt:SetLocalText("season_s4_building_ui_info71")
  elseif data.reasonType == 4 then
    self.title_txt:SetLocalText("season_s4_building_ui_info70")
  end
end

return UILWPowerHistoryItem
