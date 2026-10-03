local UILWSeasonFactionWarInviteHistoryItem = BaseClass("UILWSeasonFactionWarInviteHistoryItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local txt_time_path = "Txt_Time"
local txt_des_path = "Txt_Des"
local ali_icon_path = "aliIcon"
local player_path = "player"
local bg_path = "bg"

function UILWSeasonFactionWarInviteHistoryItem:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.ali_icon = self:AddComponent(UIButton, ali_icon_path)
  self.player = self:AddComponent(UICommonHead, player_path)
  self.txt_time = self:AddComponent(UITextMeshProUGUIEx, txt_time_path)
  self.txt_des = self:AddComponent(UITextMeshProUGUIEx, txt_des_path)
  self.player:SetEnableClickShowInfo(true, true)
end

function UILWSeasonFactionWarInviteHistoryItem:OnDestroy()
  self.bg = nil
  self.txt_time = nil
  self.txt_des = nil
  self.ali_icon = nil
  self.player = nil
  base.OnDestroy(self)
end

function UILWSeasonFactionWarInviteHistoryItem:OnEnable()
  base.OnEnable(self)
end

function UILWSeasonFactionWarInviteHistoryItem:OnDisable()
  base.OnDisable(self)
end

function UILWSeasonFactionWarInviteHistoryItem:ReInit(index, data)
  self.txt_time:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(data.eventTime))
  local operatorPlayer = ""
  local senderPlayer = ""
  local receiveAl = ""
  if data.operatorPlayer then
    operatorPlayer = UIUtil.FormatServerAllianceName(data.operatorPlayer.serverId, data.operatorPlayer.abbr, data.operatorPlayer.name)
  end
  if data.senderPlayer then
    senderPlayer = UIUtil.FormatServerAllianceName(data.senderPlayer.serverId, data.senderPlayer.abbr, data.senderPlayer.name)
  end
  if data.receiveAl then
    receiveAl = UIUtil.FormatServerAllianceName(data.receiveAl.serverId, data.receiveAl.abbr, data.receiveAl.name)
  end
  self.ali_icon:SetActive(false)
  self.player:SetActive(true)
  local bgPtah = "Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/mjc_xituzhengdui_list_bg2.png"
  if data.eventType == 0 then
    self.txt_des:SetLocalText("season_s2_faction_war_85", senderPlayer, receiveAl)
    self.player:ParseHeadInfo(data.senderPlayer)
  elseif data.eventType == 1 then
    self.txt_des:SetLocalText("season_s2_faction_war_60", operatorPlayer, senderPlayer)
    self.player:ParseHeadInfo(data.operatorPlayer)
    bgPtah = "Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/mjc_xituzhengdui_list_bg4.png"
  elseif data.eventType == 2 then
    self.txt_des:SetLocalText("season_s2_faction_war_61", operatorPlayer, senderPlayer)
    self.player:ParseHeadInfo(data.operatorPlayer)
    bgPtah = "Assets/Main/Sprites/UI/UISeason/UISeason2/FactionDeclareWar/mjc_xituzhengdui_list_bg3.png"
  elseif data.eventType == 3 then
    self.txt_des:SetLocalText("season_s2_faction_war_59", operatorPlayer, receiveAl)
    self.player:ParseHeadInfo(data.operatorPlayer)
  elseif data.eventType == 4 then
    self.txt_des:SetLocalText("season_s2_faction_war_58", senderPlayer, receiveAl)
    self.player:ParseHeadInfo(data.senderPlayer)
  elseif senderPlayer and receiveAl then
    self.txt_des:SetLocalText("season_s2_faction_war_58", senderPlayer, receiveAl)
    self.player:ParseHeadInfo(data.senderPlayer)
  else
    self.player:ParseHeadInfo(data.operatorPlayer or data.senderPlayer)
    self.txt_des:SetText("")
  end
  self.bg:LoadSprite(bgPtah)
end

return UILWSeasonFactionWarInviteHistoryItem
