local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChatItemMailScoutShare = BaseClass("ChatItemMailScoutShare", IChatItem)
local base = IChatItem
local Localization = CS.GameEntry.Localization
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local ChatUserName = require("UI.UIChatNew.Component.ChatItem.ChatUserName")
local rapidjson = require("rapidjson")
local MailParseHelper = require("DataCenter.MailData.MailParseHelper")
local _cp_chatHead = "ChatHead"
local _cp_shareMsg = "ChatShareNode/ShareIconNode/ShareMsg"
local _cp_shareNode = "ChatShareNode"
local _cp_chatNameLayout = "ChatNameLayout"
local win_img_path = "ChatShareNode/ShareIconNode/Win"
local lose_img_path = "ChatShareNode/ShareIconNode/Lose"
local MailBattleParseHelper = require("DataCenter.MailData.MailBattleParseHelper")
local Const_Min_ShareNodeHeight = 120
local Const_OneLineHeight = 26

function ChatItemMailScoutShare:ComponentDefine()
  self._chatHead = self:AddComponent(ChatHead, _cp_chatHead)
  self._shareMsg = self:AddComponent(UIText, _cp_shareMsg)
  self._shareNode = self:AddComponent(UIButton, _cp_shareNode)
  self._shareNode:SetOnClick(BindCallback(self, self.OnClickBg))
  self._chatNameLayout = self:AddComponent(ChatUserName, _cp_chatNameLayout)
end

function ChatItemMailScoutShare:OnClickBg()
  if self.mailId ~= nil then
    SFSNetwork.SendMessage(MsgDefines.MailGet, self.mailId, "", self.toUser)
  end
end

function ChatItemMailScoutShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemMailScoutShare:UpdateItem(chatdata, index)
  base.UpdateItem(self, chatdata, index)
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
  if mailInfo.title then
    local mailTitle = rapidjson.decode(mailInfo.title) or {}
    local target = mailTitle.h.subTitle.dialog.params[1]
    local targetStr = MailParseHelper:DecodeMessage(target) or ""
    local text = Localization:GetString(GameDialogDefine.SCOUT_WITH_SB, targetStr)
    self._shareMsg:SetText(text)
  end
end

function ChatItemMailScoutShare:GetPlayerName(player)
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

return ChatItemMailScoutShare
