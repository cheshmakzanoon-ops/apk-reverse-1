local ConfiscateHistoryItem = BaseClass("ConfiscateHistoryItem", UIBaseContainer)
local base = UIBaseContainer
local ui_player_head_path = "UIPlayerHead"
local txt_des_path = "Desc"
local txt_time_path = "Time"

function ConfiscateHistoryItem:OnCreate()
  base.OnCreate(self)
  self.player_head = self:AddComponent(UICommonHead, ui_player_head_path)
  self.player_head:SetEnableClickShowInfo(true, true)
  self.txt_des = self:AddComponent(UITextMeshProUGUIEx, txt_des_path)
  self.txt_des:OnPointerClick(function(eventData)
    UIUtil.UseJumpLink(self.txt_des, eventData)
  end)
  self.txt_time = self:AddComponent(UITextMeshProUGUIEx, txt_time_path)
end

function ConfiscateHistoryItem:OnDestroy()
  base.OnDestroy(self)
  self.player_head = nil
  self.txt_des = nil
  self.txt_time = nil
end

function ConfiscateHistoryItem:SetData(data)
  local desc = CS.GameEntry.Localization:GetString("s6_fish_confiscation_record_limit", data.name, UIUtil.MakeJumpLink(data.pointId, data.serverId), data.donation)
  self.txt_des:SetText(desc)
  if data.time then
    self.txt_time:SetText(UITimeManager:GetInstance():ConvertServerTimeToLocalTime(data.time, false))
  else
    self.txt_time:SetText("")
  end
  self.player_head:ParseHeadInfo(data)
end

return ConfiscateHistoryItem
