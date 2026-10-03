local UIWorldOccupyHistoryItem = BaseClass("UIWorldOccupyHistoryItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ui_player_head_path = "UIPlayerHead"
local txt_des_path = "Txt_Des"
local txt_time_path = "Txt_Time"
local txt_title_path = "Txt_Title"
local root_blue_path = "blue"
local root_red_path = "red"

function UIWorldOccupyHistoryItem:OnCreate()
  base.OnCreate(self)
  self.player_head = self:AddComponent(UICommonHead, ui_player_head_path)
  self.txt_des = self:AddComponent(UITextMeshProUGUIEx, txt_des_path)
  self.txt_time = self:AddComponent(UITextMeshProUGUIEx, txt_time_path)
  self.root_blue = self:AddComponent(UIBaseContainer, root_blue_path)
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
  self.root_red = self:AddComponent(UIBaseContainer, root_red_path)
  self.player_head:SetEnableClickShowInfo(true, true)
end

function UIWorldOccupyHistoryItem:OnDestroy()
  base.OnDestroy(self)
  self.player_head = nil
  self.txt_des = nil
  self.txt_time = nil
  self.txt_title = nil
end

function UIWorldOccupyHistoryItem:ReInit(index, data)
  self.player_head:ParseHeadInfo(data)
  self.txt_time:SetText(UITimeManager:GetInstance():GetServerTimeByUTC(data.time or 0, false))
  local playerName = UIUtil.FormatAllianceAndName(data.alAbbr, data.name)
  self.txt_des:SetText(Localization:GetString("zone_war_ui_desc10", playerName))
  self.txt_title:SetText(playerName)
  local mySeverId = LuaEntry.Player:GetSourceServerId()
  if SeasonUtil.IsAlly(data.serverId, mySeverId, data.allianceId) then
    self.root_blue:SetActive(true)
    self.root_red:SetActive(false)
    self.txt_title:SetColor(BlueColor)
  else
    self.root_blue:SetActive(false)
    self.root_red:SetActive(true)
    if SeasonUtil.IsBattleMember() then
      self.txt_title:SetColor(RedColor)
    else
      self.txt_title:SetColor(BlackColor)
    end
  end
end

return UIWorldOccupyHistoryItem
