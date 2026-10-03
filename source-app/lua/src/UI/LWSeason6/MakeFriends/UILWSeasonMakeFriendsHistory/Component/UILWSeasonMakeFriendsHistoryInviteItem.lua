local UILWSeasonMakeFriendsHistoryInviteItem = BaseClass("UILWSeasonMakeFriendsHistoryInviteItem", UIBaseContainer)
local base = UIBaseContainer
local txt_time_path = "Txt_Time"
local alli_path = "Alli"
local alli_name_path = "Alli/AlliName"
local txt_msg_path = "Txt_Msg"
local mail_path = "Alli/mail"
local bg_info_path = "bgInfo"
local txt_info_path = "bgInfo/TxtInfo"

function UILWSeasonMakeFriendsHistoryInviteItem:OnCreate()
  base.OnCreate(self)
  self.txt_time = self:AddComponent(UITextMeshProUGUIEx, txt_time_path)
  self.alli_icon = self:AddComponent(UIButton, alli_path)
  self.alli_name = self:AddComponent(UITextMeshProUGUIEx, alli_name_path)
  self.txt_msg = self:AddComponent(UITextMeshProUGUIEx, txt_msg_path)
  self.mail = self:AddComponent(UIButton, mail_path)
  self.bg_info = self:AddComponent(UIImage, bg_info_path)
  self.txt_info = self:AddComponent(UITextMeshProUGUIEx, txt_info_path)
  self.alli_icon:SetOnClick(function()
    if self.logData then
      local data = self.logData.otherAllianceInfo
      if data then
        UIUtil.TryShowAllianceInfo(data.serverId, data.allianceId, data.name)
      end
    end
  end)
  self.mail:SetOnClick(function()
    if self.logData and self.logData.subType == 100 then
      local detail = DataCenter.SeasonAllyFriendManager:GetOpLogDetail(self.logData.uuid)
      if detail ~= nil then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonInviteDetail, {anim = false}, detail)
      end
    end
  end)
end

function UILWSeasonMakeFriendsHistoryInviteItem:OnDestroy()
  self.txt_time = nil
  self.alli_icon = nil
  self.alli_name = nil
  self.txt_msg = nil
  self.mail = nil
  self.bg_info = nil
  self.txt_info = nil
  base.OnDestroy(self)
end

function UILWSeasonMakeFriendsHistoryInviteItem:ReInit(typeIndex, index, logData)
  self.typeIndex = typeIndex
  self.index = index
  self.logData = logData
  if typeIndex == 2 then
    self:OnInviteInfo(logData)
  elseif typeIndex == 3 then
    self:OnBeInvitedInfo(logData)
  end
  local strTime = UITimeManager:GetInstance():GetServerTimeByUTC(logData.eventTime or 0, false)
  if index == 1 and typeIndex ~= nil then
    Setting:SetPrivateString("AllyFriend_T" .. typeIndex, tostring(logData.eventTime or 0))
  end
  self.txt_time:SetText(strTime)
  self.mail:SetActive(false)
  if logData.subType == 100 or logData.subType == 202 or logData.subType == 303 then
    local detail = DataCenter.SeasonAllyFriendManager:GetOpLogDetail(logData.uuid)
    if detail == nil then
      SFSNetwork.SendMessage(MsgDefines.FetchAllianceAllyLogDetail, logData.uuid)
    end
  end
  if logData.subType == 200 or logData.subType == 301 then
    self.bg_info:SetActive(true)
    self.bg_info:SetColorHex("#4bc382")
    self.txt_info:SetLocalText("migration_activity_interface_10074")
    self.txt_info:SetColorHex("#4bc382")
  elseif logData.subType == 201 or logData.subType == 302 then
    self.bg_info:SetActive(true)
    self.bg_info:SetColorHex("#f0b969")
    self.txt_info:SetLocalText("btn_recall")
    self.txt_info:SetColorHex("#f0b969")
  elseif logData.subType == 202 or logData.subType == 303 then
    self.bg_info:SetActive(true)
    self.bg_info:SetColorHex("#ef5e5e")
    self.txt_info:SetLocalText("migration_activity_interface_10075")
    self.txt_info:SetColorHex("#ef5e5e")
  elseif logData.subType == 203 or logData.subType == 304 then
    self.bg_info:SetActive(true)
    self.bg_info:SetColorHex("#adadad")
    self.txt_info:SetLocalText("390843")
    self.txt_info:SetColorHex("#adadad")
  else
    self.bg_info:SetActive(false)
  end
end

function UILWSeasonMakeFriendsHistoryInviteItem:OnInviteInfo(logData)
  self.alli_icon:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, logData.targetAlliance.icon))
  self.alli_name:SetText(UIUtil.FormatServerAllianceName(logData.targetAlliance.serverId, logData.targetAlliance.abbr))
  self.txt_msg:SetLocalText("s6_alliance_ally_desc45", logData.applyUser.name, "[" .. logData.targetAlliance.abbr .. "]")
end

function UILWSeasonMakeFriendsHistoryInviteItem:OnBeInvitedInfo(logData)
  self.alli_icon:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, logData.applyAlliance.icon))
  self.alli_name:SetText(UIUtil.FormatServerAllianceName(logData.applyAlliance.serverId, logData.applyAlliance.abbr))
  self.txt_msg:SetLocalText("s6_alliance_ally_desc44", logData.applyUser.name, "[" .. logData.applyAlliance.abbr .. "]")
end

return UILWSeasonMakeFriendsHistoryInviteItem
