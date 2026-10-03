local UILWSeasonMakeFriendsHistoryItem = BaseClass("UILWSeasonMakeFriendsHistoryItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local txt_time_path = "Txt_Time"
local my_alli_path = "alliances/MyAlli"
local my_alli_name_path = "alliances/MyAlli/MyAlliName"
local other_alli_path = "alliances/OtherAlli"
local other_alli_name_path = "alliances/OtherAlli/OtherAlliName"
local txt_pos_path = "alliances/icon/Txt_Pos"
local mail1_path = "alliances/MyAlli/mail1"
local mail2_path = "alliances/OtherAlli/mail2"
local icon_path = "alliances/icon"

function UILWSeasonMakeFriendsHistoryItem:OnCreate()
  base.OnCreate(self)
  self.txt_time = self:AddComponent(UITextMeshProUGUIEx, txt_time_path)
  self.my_alli_icon = self:AddComponent(UIButton, my_alli_path)
  self.my_alli_name = self:AddComponent(UITextMeshProUGUIEx, my_alli_name_path)
  self.other_alli_icon = self:AddComponent(UIButton, other_alli_path)
  self.other_alli_name = self:AddComponent(UITextMeshProUGUIEx, other_alli_name_path)
  self.txt_pos = self:AddComponent(UITextMeshProUGUIEx, txt_pos_path)
  self.mail1 = self:AddComponent(UIButton, mail1_path)
  self.mail2 = self:AddComponent(UIButton, mail2_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.txt_pos:OnPointerClick(function(eventData)
    UIUtil.UseJumpLink(self.txt_pos, eventData)
  end)
  self.my_alli_icon:SetOnClick(function()
    if self.logData then
      local data = self.logData.myAllianceInfo
      if data then
        UIUtil.TryShowAllianceInfo(data.serverId, data.allianceId, data.name)
      end
    end
  end)
  self.other_alli_icon:SetOnClick(function()
    if self.logData then
      local data = self.logData.otherAllianceInfo
      if data then
        UIUtil.TryShowAllianceInfo(data.serverId, data.allianceId, data.name)
      end
    end
  end)
  self.mail1:SetOnClick(function()
    if self.logData and self.logData.subType then
      local detail = DataCenter.SeasonAllyFriendManager:GetOpLogDetail(self.logData.uuid)
      if detail ~= nil and (detail.likeCount ~= nil or detail.mailBody ~= nil) then
        detail.logData = self.logData
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonInviteDetail, {anim = false}, detail)
      end
    end
  end)
  self.mail2:SetOnClick(function()
    if self.logData and self.logData.subType then
      local detail = DataCenter.SeasonAllyFriendManager:GetOpLogDetail(self.logData.uuid)
      if detail ~= nil and (detail.likeCount ~= nil or detail.mailBody ~= nil) then
        detail.logData = self.logData
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonInviteDetail, {anim = false}, detail)
      end
    end
  end)
end

function UILWSeasonMakeFriendsHistoryItem:OnDestroy()
  self.txt_time = nil
  self.icon = nil
  self.my_alli_icon = nil
  self.my_alli_name = nil
  self.other_alli_icon = nil
  self.other_alli_name = nil
  self.txt_pos = nil
  self.mail1 = nil
  self.mail2 = nil
  base.OnDestroy(self)
end

function UILWSeasonMakeFriendsHistoryItem:ReInit(typeIndex, index, logData)
  self.typeIndex = typeIndex
  self.index = index
  self.logData = logData
  local strTime = UITimeManager:GetInstance():GetServerTimeByUTC(logData.eventTime or 0, false)
  self.txt_time:SetText(strTime)
  if index == 1 and typeIndex ~= nil then
    Setting:SetPrivateString("AllyFriend_T" .. typeIndex, tostring(logData.eventTime or 0))
  end
  if logData.subType == 100 then
    self.icon:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/AllyFriendS6/mjc_TMJM_icon_1_jiemeng.png")
    if logData.fromAllianceId == logData.myAllianceInfo.allianceId then
      self.mail1:SetActive(true)
      self.mail2:SetActive(false)
      self.mail1:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/AllyFriendS6/mjc_TMJM_icon_faqijiemeng.png")
      self.mail1:SetColorHex("#84c0f7")
    else
      self.mail1:SetActive(false)
      self.mail2:SetActive(true)
      self.mail2:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/AllyFriendS6/mjc_TMJM_icon_faqijiemeng.png")
      self.mail2:SetColorHex("#84c0f7")
    end
    self.txt_time:SetText(strTime .. Localization:GetString("s6_alliance_ally_desc41"))
  else
    self.mail1:SetActive(false)
    self.mail2:SetActive(false)
    local triggerAllianceId = logData.triggerAllianceId
    if logData.subType == 101 then
      self.icon:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/AllyFriendS6/mjc_TMJM_icon_1_jiechulianmeng.png")
      self.txt_time:SetText(strTime .. Localization:GetString("s6_alliance_ally_desc42"))
    elseif logData.subType == 102 then
      self.icon:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/AllyFriendS6/mjc_TMJM_icon_1_zuobiao.png")
      self.txt_time:SetText(strTime .. Localization:GetString("s6_alliance_ally_desc43"))
    elseif logData.subType == 103 then
      self.icon:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/AllyFriendS6/mjc_TMJM_icon_1_zuobiao.png")
      self.txt_time:SetText(strTime .. Localization:GetString("s6_alliance_ally_desc43"))
    end
    if triggerAllianceId == logData.myAllianceInfo.allianceId then
      self.mail1:SetActive(true)
      self.mail2:SetActive(false)
      self.mail1:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/AllyFriendS6/mjc_TMJM_icon_jiechulianmeng.png")
      self.mail1:SetColorHex("#fa8c82")
    else
      self.mail1:SetActive(false)
      self.mail2:SetActive(true)
      self.mail2:LoadSpriteAuto("Assets/Main/SeasonRes/S6/Sprites/AllyFriendS6/mjc_TMJM_icon_jiechulianmeng.png")
      self.mail2:SetColorHex("#fa8c82")
    end
  end
  if logData.cityId and logData.cityServerId and logData.cityPointId then
    self.txt_pos:SetText(UIUtil.MakeJumpLink(logData.cityPointId, logData.cityServerId, 0))
  else
    self.txt_pos:SetText("")
  end
  self.my_alli_icon:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, logData.myAllianceInfo.icon))
  self.my_alli_name:SetText(UIUtil.FormatServerAllianceName(logData.myAllianceInfo.serverId, logData.myAllianceInfo.abbr))
  self.other_alli_icon:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, logData.otherAllianceInfo.icon))
  self.other_alli_name:SetText(UIUtil.FormatServerAllianceName(logData.otherAllianceInfo.serverId, logData.otherAllianceInfo.abbr))
  local detail = DataCenter.SeasonAllyFriendManager:GetOpLogDetail(logData.uuid)
  if detail == nil then
    SFSNetwork.SendMessage(MsgDefines.FetchAllianceAllyLogDetail, logData.uuid)
  end
end

return UILWSeasonMakeFriendsHistoryItem
