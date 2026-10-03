local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local ChatItemPost_MailReportShare = BaseClass("ChatItemPost_MailReportShare", IChatItemPost)
local base = IChatItemPost
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local _cp_shareMsg = "ShareIconNode/ShareMsg"
local _cp_shareNode = ""
local win_img_path = "ShareIconNode/Win"
local lose_img_path = "ShareIconNode/Lose"
local assist_img_path = "ShareIconNode/Assist"
local truck_quality_img_path = "ShareIconNode/TruckQuality"
local truck_msg_img_path = "ShareIconNode/TruckMsg"
local MailBattleParseHelper = require("DataCenter.MailData.MailBattleParseHelper")

function ChatItemPost_MailReportShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChatItemPost_MailReportShare:ComponentDefine()
  self._shareMsg = self:AddComponent(UIText, _cp_shareMsg)
  self._shareNode = self:AddComponent(UIButton, _cp_shareNode)
  self._shareNode:SetOnClick(BindCallback(self, self.OnClickBg))
  self.win = self:AddComponent(UIImage, win_img_path)
  self.lose = self:AddComponent(UIImage, lose_img_path)
  self.assist = self:AddComponent(UIImage, assist_img_path)
  self.truck_quality = self:AddComponent(UIImage, truck_quality_img_path)
  self.truck_msg = self:AddComponent(UIBaseContainer, truck_msg_img_path)
  self.iconSword = self:AddComponent(UIImage, "ShareIconNode/IconSword")
  self.iconAssist = self:AddComponent(UIImage, "ShareIconNode/IconAssist")
end

function ChatItemPost_MailReportShare:OnClickBg()
  if self.postType == PostType.NewBattleReportShare then
    local isAddressMode = BattleReportUtil.IsAddressMode(self.ossAddress)
    local reportId = tonumber(self.mailId)
    BattleReportUtil.Create(reportId, PVEEnterType.Default, true, isAddressMode, self.ossAddress, BattleReportPreviewEnterType.NewBattleReportChatShare)
    return
  end
  if not string.IsNullOrEmpty(self.mailId) then
    DataCenter.MailDataManager:OpenShareMail(self.mailId, self.toUser)
  end
end

function ChatItemPost_MailReportShare:OnLoaded()
  local chatdata = self:ChatData()
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
  self.resultState = tabAttachment.resultState
  self.resultName = tabAttachment.targetName
  self.postType = chatdata.extra.post
  self.ossAddress = tabAttachment.ossAddress or ""
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
      if tabAttachment.wolfEndTime and UITimeManager:GetInstance():GetServerTime() < tabAttachment.wolfEndTime then
        targetName = Localization:GetString(GameDialogDefine.WEREWOLF)
      end
      local text
      if isWin then
        text = Localization:GetString("battle_report_victory", targetName)
      else
        text = Localization:GetString("battle_report_lose", targetName)
      end
      if self.resultName and self.resultState then
        if tabAttachment.wolfEndTime and UITimeManager:GetInstance():GetServerTime() < tabAttachment.wolfEndTime then
          self.resultName = Localization:GetString(GameDialogDefine.WEREWOLF)
        end
        if self.resultState == FightResult.SELF_WIN then
          text = Localization:GetString("battle_report_victory", self.resultName or "")
        elseif self.resultState == FightResult.OTHER_WIN then
          text = Localization:GetString("battle_report_lose", self.resultName or "")
        end
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

function ChatItemPost_MailReportShare:GetPlayerName(player)
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

function ChatItemPost_MailReportShare:OnRecycle()
end

return ChatItemPost_MailReportShare
