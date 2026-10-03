local UILWMailDetailDesertBattleMatchResult = BaseClass("UILWMailDetailDesertBattleMatchResult", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local HeroRewardItem = require("UI.UICapacityBoxSelect.Component.UICapacityBoxHeroItem")
local title_txt_path = "System/DetailTitle"
local sub_title_txt_path = "System/DScroll/DViewport/DContent/DSubTitle"
local message_txt_path = "System/DScroll/DViewport/DContent/DMessage"
local message_richtxt_path = "System/DScroll/DViewport/DContent/DMessageRichText"
local time_txt_path = "System/DetailTimeBg/DetailTime"
local flag_icon_path = "System/DScroll/DViewport/DContent/AllianceItem/flagIcon"
local name_txt_path = "System/DScroll/DViewport/DContent/AllianceItem/name"
local power_txt_path = "System/DScroll/DViewport/DContent/AllianceItem/CPContent/CPTxt"
local leader_txt_path = "System/DScroll/DViewport/DContent/AllianceItem/LeaderContent/leader"
local leader_value_txt_path = "System/DScroll/DViewport/DContent/AllianceItem/LeaderContent/leaderTxt"
local gift_txt_path = "System/DScroll/DViewport/DContent/AllianceItem/GiftContent/gift"
local gift_value_txt_path = "System/DScroll/DViewport/DContent/AllianceItem/GiftContent/giftNum"
local people_txt_path = "System/DScroll/DViewport/DContent/AllianceItem/PeopleContent/people"
local people_value_txt_path = "System/DScroll/DViewport/DContent/AllianceItem/PeopleContent/peopleTxt"
local language_txt_path = "System/DScroll/DViewport/DContent/AllianceItem/LanguageContent/language"
local language_value_txt_path = "System/DScroll/DViewport/DContent/AllianceItem/LanguageContent/languageTxt"
local country_flag_icon_path = "System/DScroll/DViewport/DContent/AllianceItem/LanguageContent/languageTxt/countryFlag"
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")

function UILWMailDetailDesertBattleMatchResult:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailDesertBattleMatchResult:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailDesertBattleMatchResult:ComponentDefine()
  self.titleTxt = self:AddComponent(UIText, title_txt_path)
  self.subTitleTxt = self:AddComponent(UIText, sub_title_txt_path)
  self.messageTxt = self:AddComponent(UIText, message_txt_path)
  self.messageRichTxt = self:AddComponent(UITextMeshProUGUIEx, message_richtxt_path)
  self.messageRichTxt:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
  self.timeTxt = self:AddComponent(UIText, time_txt_path)
  self.name = self:AddComponent(UIText, name_txt_path)
  self.power_txt = self:AddComponent(UIText, power_txt_path)
  self.leader = self:AddComponent(UIText, leader_txt_path)
  self.leader_txt = self:AddComponent(UIText, leader_value_txt_path)
  self.land = self:AddComponent(UIText, language_txt_path)
  self.land_txt = self:AddComponent(UIText, language_value_txt_path)
  self.gift = self:AddComponent(UIText, gift_txt_path)
  self.gift_txt = self:AddComponent(UIText, gift_value_txt_path)
  self.people = self:AddComponent(UIText, people_txt_path)
  self.people_txt = self:AddComponent(UIText, people_value_txt_path)
  self.AllianceFlag = self:AddComponent(UIImage, flag_icon_path)
  self.countryFlagN = self:AddComponent(UIImage, country_flag_icon_path)
  self.power_txt:SetLocalText(100644)
  self.leader:SetLocalText(390006)
  self.land:SetLocalText(100101)
  self.gift:SetLocalText(390445)
  self.people:SetLocalText(390098)
end

function UILWMailDetailDesertBattleMatchResult:ComponentDestroy()
  self.titleTxt = nil
  self.subTitleTxt = nil
  self.messageTxt = nil
  self.messageRichTxt = nil
  self.timeTxt = nil
  self.rewardContent = nil
  self.rewarditem = nil
  self.rewardheroitem = nil
  self.name = nil
  self.power_txt = nil
  self.leader = nil
  self.leader_txt = nil
  self.land = nil
  self.land_txt = nil
  self.gift = nil
  self.gift_txt = nil
  self.people = nil
  self.people_txt = nil
  self.AllianceFlag = nil
  self.countryFlagN = nil
end

function UILWMailDetailDesertBattleMatchResult:DataDefine()
  self.mailUid = {}
  self.mailData = {}
end

function UILWMailDetailDesertBattleMatchResult:DataDestroy()
  self.mailUid = nil
  self.mailData = nil
end

function UILWMailDetailDesertBattleMatchResult:OnEnable()
  base.OnEnable(self)
end

function UILWMailDetailDesertBattleMatchResult:OnDisable()
  base.OnDisable(self)
end

function UILWMailDetailDesertBattleMatchResult:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
end

function UILWMailDetailDesertBattleMatchResult:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ReadOneMailRespond, self.RewardSuccess)
end

function UILWMailDetailDesertBattleMatchResult:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local _strTitle = MailShowHelper.GetMainTitle(self.mailData)
  self.titleTxt:SetText(_strTitle)
  local _strSubTitle = MailShowHelper.GetMailSubTitle(self.mailData)
  self.subTitleTxt:SetText(_strSubTitle)
  local _strContents = self.mailData:GetMailMessage()
  self:setMailText(_strContents)
  local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.timeTxt:SetText(_strTime)
  local msg = rapidjson.decode(self.mailData.contents).obj
  self.data = {}
  self.data.abbr = msg.alAbbr
  self.data.allianceName = msg.alName
  self.data.allianceIcon = msg.alIcon
  self.data.allianceId = msg.alId
  self.data.leaderName = msg.alLeaderName
  self.data.fightPower = msg.alPower
  self.data.language = msg.alLanguage
  self.data.giftLevel = msg.alGiftLv
  self.data.curMember = msg.alCurNum
  self.data.maxMember = msg.alMaxNum
  self.data.country = msg.alCountry
  self:RefreshAllianceData()
end

function UILWMailDetailDesertBattleMatchResult:RefreshAllianceData()
  if self.data then
    self.name:SetText("<" .. self.data.abbr .. "> " .. self.data.allianceName)
    self.power_txt:SetText(string.GetFormattedSeperatorNum(self.data.fightPower))
    local leaderName = self.data.leaderUid == "" and Localization:GetString("100206") or self.data.leaderName
    self.leader_txt:SetText(leaderName)
    local languageId = self.data.language == "" and 115600 or self.data.language
    self.land_txt:SetLocalText(languageId)
    self.gift_txt:SetLocalText(300665, self.data.giftLevel)
    self.people_txt:SetText(self.data.curMember .. "/" .. self.data.maxMember)
    local nationTemplate = self:GetCountryFlagTemplate()
    self.countryFlagN:LoadSprite(nationTemplate:GetNationFlagPath())
    self.AllianceFlag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(self.data.allianceIcon)))
  end
end

function UILWMailDetailDesertBattleMatchResult:GetCountryFlagTemplate()
  local country = string.IsNullOrEmpty(self.data.country) and DefaultNation or self.data.country
  return DataCenter.NationTemplateManager:GetNationTemplate(country)
end

function UILWMailDetailDesertBattleMatchResult:setMailText(txt)
  local hasLinkData = txt:find("<link") ~= nil and txt:find("</link>") ~= nil
  if not hasLinkData and txt:find("X:") ~= nil and txt:find("Y:") ~= nil then
    txt = FindAndAppendLinkInfo(txt)
  end
  if hasLinkData or txt:find("<u>") ~= nil and txt:find("</u>") ~= nil then
    self.messageRichTxt:SetText(txt)
    self.messageTxt:SetActive(false)
    self.messageRichTxt:SetActive(true)
  else
    self.messageTxt:SetText(txt)
    self.messageTxt:SetActive(true)
    self.messageRichTxt:SetActive(false)
  end
end

function UILWMailDetailDesertBattleMatchResult:OnPointerClick(clickPos)
  if self.messageRichTxt == nil then
    return
  end
  local linkId = self.messageRichTxt:TryGetPointerClickLinkID(clickPos)
  if string.IsNullOrEmpty(linkId) then
    return
  end
  if string.find(linkId, "http:") or string.find(linkId, "https:") then
    CS.SDKManager.OpenURL(linkId)
  else
    local linkMsg = base64.decode(linkId)
    linkMsg = rapidjson.decode(linkMsg)
    GoToUtil.TryJumpToWorld(linkMsg)
  end
end

return UILWMailDetailDesertBattleMatchResult
