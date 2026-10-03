local UILWSeasonVirusHistoryItem = BaseClass("UILWSeasonVirusHistoryItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UILWSeasonVirusHistoryItem:OnCreate()
  base.OnCreate(self)
  self.player_head = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.txt_time = self:AddComponent(UITextMeshProUGUIEx, "Txt_Time")
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, "Txt_Title")
  self.player_head:SetEnableClickShowInfo(true, true)
end

function UILWSeasonVirusHistoryItem:OnDestroy()
  base.OnDestroy(self)
end

function UILWSeasonVirusHistoryItem:ReInit(data)
  self.player_head:ParseHeadInfo(data)
  self.txt_title:SetText(UIUtil.FormatServerAllianceName(data.serverId, data.abbr, data.name))
  if data and data.time then
    self.txt_time:SetText(UITimeManager:GetInstance():ConvertServerTimeToLocalTime(data.time, false))
  else
    self.txt_time:SetText("")
  end
end

return UILWSeasonVirusHistoryItem
