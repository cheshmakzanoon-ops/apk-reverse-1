local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatItemMailReportShare = BaseClass("ChatItemMailReportShare", IChatItem)
local base = IChatItem
local Localization = CS.GameEntry.Localization
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local ChatUserName = require("UI.UIChatNew.Component.ChatItem.ChatUserName")
local rapidjson = require("rapidjson")
local _cp_chatHead = "ChatHead"
local _cp_shareMsg = "ChatShareNode/ShareIconNode/ShareMsg"
local _cp_shareNode = "ChatShareNode"
local _cp_chatNameLayout = "ChatNameLayout"
local win_img_path = "ChatShareNode/ShareIconNode/Win"
local lose_img_path = "ChatShareNode/ShareIconNode/Lose"
local assist_img_path = "ChatShareNode/ShareIconNode/Assist"
local truck_quality_img_path = "ChatShareNode/ShareIconNode/TruckQuality"
local truck_msg_img_path = "ChatShareNode/ShareIconNode/TruckMsg"
local MailBattleParseHelper = require("DataCenter.MailData.MailBattleParseHelper")
local Const_Min_ShareNodeHeight = 120
local Const_OneLineHeight = 26

function ChatItemMailReportShare:ComponentDefine()
  self._chatHead = self:AddComponent(ChatHead, _cp_chatHead)
  self._shareMsg = self:AddComponent(UIText, _cp_shareMsg)
  self._shareNode = self:AddComponent(UIButton, _cp_shareNode)
  self._shareNode:SetOnClick(BindCallback(self, self.OnClickBg))
  self._chatNameLayout = self:AddComponent(ChatUserName, _cp_chatNameLayout)
  self.win = self:AddComponent(UIImage, win_img_path)
  self.lose = self:AddComponent(UIImage, lose_img_path)
  self.assist = self:AddComponent(UIImage, assist_img_path)
  self.truck_quality = self:AddComponent(UIImage, truck_quality_img_path)
  self.truck_msg = self:AddComponent(UIBaseContainer, truck_msg_img_path)
  self.iconSword = self:AddComponent(UIImage, "ChatShareNode/ShareIconNode/IconSword")
  self.iconAssist = self:AddComponent(UIImage, "ChatShareNode/ShareIconNode/IconAssist")
end

function ChatItemMailReportShare:OnClickBg()
  if self.mailId == nil then
    return
  end
  if self.mailId == "" and self.toUser == "" then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.MailGet, self.mailId, "", self.toUser)
end

function ChatItemMailReportShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemMailReportShare:UpdateItem(chatdata, index)
  base.UpdateItem(self, chatdata, index)
  if chatdata == nil then
    return
  end
  local senderUid = chatdata.senderUid
  local _userInfo = ChatManager2:GetInstance().User:getChatUserInfo(senderUid, true)
  if self._chatNameLayout then
    self._chatNameLayout:UpdateName(_userInfo, chatdata)
  end
  local tabAttachment = rapidjson.decode(chatdata.attachmentId) or {}
  self.mailId = tabAttachment.reportUid
  self.toUser = tabAttachment.toUser or ""
  self.isDefAssist = chatdata.extra.isDefAssist
  if self.isDefAssist then
    self.win:SetActive(false)
    self.lose:SetActive(false)
    self.assist:SetActive(true)
    self.iconSword:SetActive(false)
    self.iconAssist:SetActive(true)
    self._shareMsg:SetText(Localization:GetString(2900034))
  else
    local mailInfo = rapidjson.decode(chatdata.extra.customJsonParam) or {}
    local isWin = mailInfo.reportResult == 1
    self.win:SetActive(isWin)
    self.lose:SetActive(not isWin)
    self.assist:SetActive(false)
    self.iconSword:SetActive(true)
    self.iconAssist:SetActive(false)
    local target = mailInfo.def
    if mailInfo.target then
      target = mailInfo.target
    end
    if target then
      if target.armyType == MailTargetType.Player then
        target.name = target.userName
        if not string.IsNullOrEmpty(target.allianceAbbr) then
          target.name = "[" .. target.allianceAbbr .. "]" .. target.name
        end
      else
        MailBattleParseHelper.DecodeLwBattlePlayerStat(target)
      end
      local targetName = target.name
      local text
      if isWin then
        text = Localization:GetString("battle_report_victory", targetName)
      else
        text = Localization:GetString("battle_report_lose", targetName)
      end
      self._shareMsg:SetText(text)
    end
  end
  self.truck_quality:SetActive(tabAttachment.train_quality)
  self.truck_msg:SetActive(tabAttachment.train_quality)
  if tabAttachment.train_quality then
    self.truck_quality:LoadSprite(QualityImagePath[tabAttachment.train_quality])
    self.truck_quality:SetNativeSize()
  end
end

function ChatItemMailReportShare:GetPlayerName(player)
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

return ChatItemMailReportShare
