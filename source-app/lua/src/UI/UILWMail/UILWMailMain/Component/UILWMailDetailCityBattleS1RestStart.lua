local UILWMailDetailCityBattleS1RestStart = BaseClass("UILWMailDetailCityBattleS1RestStart", UIBaseContainer)
local base = UIBaseContainer
local title_txt_path = "System/DetailTitle"
local message_richtxt_path = "System/DScroll/DViewport/DContent/DMessageRichText"
local time_txt_path = "System/DetailTimeBg/DetailTime"
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")

function UILWMailDetailCityBattleS1RestStart:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailCityBattleS1RestStart:OnDestroy()
  DataCenter.MailRankDataManager:CancelGetMailRankData()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailCityBattleS1RestStart:ComponentDefine()
  self.titleTxt = self:AddComponent(UIText, title_txt_path)
  self.messageRichTxt = self:AddComponent(UITextMeshProUGUIEx, message_richtxt_path)
  ChatInterface.SetEmojiTextProperty(self.messageRichTxt, true)
  self.messageRichTxt:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
  self.timeTxt = self:AddComponent(UIText, time_txt_path)
end

function UILWMailDetailCityBattleS1RestStart:ComponentDestroy()
  self.titleTxt = nil
  self.messageRichTxt = nil
  self.timeTxt = nil
end

function UILWMailDetailCityBattleS1RestStart:DataDefine()
  self.mailUid = {}
  self.mailData = {}
end

function UILWMailDetailCityBattleS1RestStart:DataDestroy()
  self.mailUid = nil
  self.mailData = nil
end

function UILWMailDetailCityBattleS1RestStart:OnEnable()
  base.OnEnable(self)
end

function UILWMailDetailCityBattleS1RestStart:OnDisable()
  base.OnDisable(self)
end

function UILWMailDetailCityBattleS1RestStart:OnAddListener()
  base.OnAddListener(self)
end

function UILWMailDetailCityBattleS1RestStart:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWMailDetailCityBattleS1RestStart:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local _strTitle = MailShowHelper.GetMainTitle(self.mailData)
  _strTitle = string.gsub(_strTitle, "\n", "")
  _strTitle = ChatInterface.CheckMessage(_strTitle)
  self.titleTxt:SetText(_strTitle)
  local _strContents = self.mailData:GetMailMessage()
  self:setMailText(_strContents)
  local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.timeTxt:SetText(_strTime)
end

function UILWMailDetailCityBattleS1RestStart:setMailText(txt)
  local hasLinkData = txt:find("<link") ~= nil and txt:find("</link>") ~= nil
  if not hasLinkData and txt:find("X:") ~= nil and txt:find("Y:") ~= nil then
    txt = FindAndAppendLinkInfo(txt)
  end
  txt = ChatInterface.CheckMessage(txt)
  self.messageRichTxt:SetAlignment(CS.TMPro.TextAlignmentOptions.TopLeft)
  self.messageRichTxt:SetText_NotNative(txt)
end

function UILWMailDetailCityBattleS1RestStart:OnPointerClick(clickPos)
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

return UILWMailDetailCityBattleS1RestStart
