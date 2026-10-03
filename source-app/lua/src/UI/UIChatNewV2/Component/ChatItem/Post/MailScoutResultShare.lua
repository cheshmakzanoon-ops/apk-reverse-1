local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_MailScoutResultShare = BaseClass("ChatItemPost_MailScoutResultShare", IChatItemPost)
local base = IChatItemPost
local MailParseHelper = require("DataCenter.MailData.MailParseHelper")
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local _cp_shareMsg = "ShareIconNode/ShareMsg"
local _cp_shareNode = ""
local troop_icon_path = "ShareIconNode/troopIcon"
local troop_text_path = "ShareIconNode/troopIcon/troopText"
local power_icon_path = "ShareIconNode/powerIcon"
local power_text_path = "ShareIconNode/powerIcon/powerText"

function ChatItemPost_MailScoutResultShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_MailScoutResultShare:ComponentDefine()
  self._shareMsg = self:AddComponent(UIText, _cp_shareMsg)
  self._shareNode = self:AddComponent(UIButton, _cp_shareNode)
  self._shareNode:SetOnClick(BindCallback(self, self.OnClickBg))
  self.troop_text = self:AddComponent(UITextMeshProUGUIEx, troop_text_path)
  self.troop_icon = self:AddComponent(UIBaseContainer, troop_icon_path)
  self.power_icon = self:AddComponent(UIBaseContainer, power_icon_path)
  self.power_text = self:AddComponent(UITextMeshProUGUIEx, power_text_path)
end

function ChatItemPost_MailScoutResultShare:OnClickBg()
  if self.mailId ~= nil then
    DataCenter.MailDataManager:OpenShareMail(self.mailId, self.toUser)
  end
end

function ChatItemPost_MailScoutResultShare:OnLoaded()
  local chatdata = self:ChatData()
  if chatdata == nil then
    return
  end
  if not chatdata.extra or not chatdata.extra.customJsonParam then
    return
  end
  local senderUid = chatdata.senderUid
  local _userInfo = ChatManager2:GetInstance().User:getChatUserInfo(senderUid, true)
  if self._chatNameLayout then
    self._chatNameLayout:UpdateName(_userInfo, chatdata)
  end
  local mailInfo = rapidjson.decode(chatdata.extra.customJsonParam) or {}
  self.mailId = mailInfo.reportUid
  self.toUser = mailInfo.toUser or ""
  local tabAttachment = rapidjson.decode(chatdata.attachmentId) or {}
  if self.mailId == nil then
    self.mailId = tabAttachment.reportUid
  end
  if string.IsNullOrEmpty(self.toUser) then
    self.toUser = tabAttachment.toUser or ""
  end
  if string.IsNullOrEmpty(self.toUser) then
    self.toUser = senderUid
  end
  if mailInfo.title then
    local mailTitle = rapidjson.decode(mailInfo.title) or {}
    local target = mailTitle.h.subTitle.dialog.params[1]
    local targetStr
    if tabAttachment.wolfEndTime and UITimeManager:GetInstance():GetServerTime() < tabAttachment.wolfEndTime then
      targetStr = Localization:GetString(GameDialogDefine.WEREWOLF)
    else
      targetStr = MailParseHelper:DecodeMessage(target) or ""
    end
    local text = Localization:GetString(GameDialogDefine.SCOUT_WITH_SB, targetStr)
    self._shareMsg:SetText(text)
  end
  if LuaEntry.DataConfig:CheckSwitch("scout_beta") then
    self.troop_icon:SetActive(mailInfo.defendSize)
    if mailInfo.defendSize then
      self.troop_text:SetText(mailInfo.defendSize)
    end
    self.power_icon:SetActive(mailInfo.defendTotalPower)
    if mailInfo.defendTotalPower then
      self.power_text:SetText(string.GetFormattedStr2(mailInfo.defendTotalPower))
    end
  end
end

function ChatItemPost_MailScoutResultShare:GetPlayerName(player)
  if player.armyType == MailTargetType.DragonBuild then
    player.meta = DataCenter.DragonBuildTemplateManager:GetTemplate(player.contentId)
    if player.meta then
      player.pic = player.meta:GetDetailPath()
      player.name = Localization:GetString(player.meta.name)
      player.level = player.meta.level
    end
  elseif player.armyType == MailTargetType.WinterStormBuilding then
    player.meta = DataCenter.WinterStormTemplateManager:GetTemplate(player.contentId)
    if player.meta then
      player.pic = player.meta:GetDetailPath()
      player.name = Localization:GetString(player.meta.name)
      player.level = player.meta.level
    end
  elseif player.armyType == MailTargetType.EpidemicBuild then
    player.meta = DataCenter.EpidemicBuildTemplateMgr:GetTemplate(player.contentId)
    if player.meta then
      player.pic = player.meta:GetDetailPath()
      player.name = Localization:GetString(player.meta.name)
      player.level = player.meta.level
    end
  elseif player.armyType == MailTargetType.AllianceCity or player.armyType == MailTargetType.CityStronghold or player.armyType == MailTargetType.TradeStation then
    player.meta = DataCenter.AllianceCityTemplateManager:GetTemplate(player.contentId)
    if player.meta then
      player.name = Localization:GetString(player.meta.name)
      player.level = player.meta.level
    end
  elseif player.armyType == MailTargetType.SeasonDesert then
    player.meta = DataCenter.DesertTemplateManager:GetTemplate(player.contentId)
    if player.meta then
      player.name = Localization:GetString(player.meta.name)
      player.level = player.meta.level
    end
  elseif player.armyType == MailTargetType.SeasonBuilding then
    local level = player.contentId % BuildLevelCap
    local buildId = player.contentId - level
    player.meta = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, level)
    if player.meta == nil then
      player.meta = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
    end
    if player.meta then
      player.pic = player.meta:GetBuildIconOutCity()
      player.name = Localization:GetString(player.meta.name)
      player.level = level
    end
  elseif player.armyType == MailTargetType.SeasonCenter then
    player.meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(player.contentId)
    if player.meta then
      player.pic = player.meta:GetIconPath()
      player.name = Localization:GetString(player.meta.name)
      player.level = 1
    end
  end
end

function ChatItemPost_MailScoutResultShare:OnRecycle()
end

return ChatItemPost_MailScoutResultShare
