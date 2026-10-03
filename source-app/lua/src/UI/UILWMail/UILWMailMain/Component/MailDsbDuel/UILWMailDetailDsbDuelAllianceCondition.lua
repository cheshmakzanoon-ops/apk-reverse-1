local UILWMailDetailDsbDuelAllianceCondition = BaseClass("UILWMailDetailDsbDuelAllianceCondition", UIBaseContainer)
local base = UIBaseContainer
local UIBFDsbDuelActSignUpSuccessItem = require("UI.BFDsbDuel.BFDsbDuelSignUpSuccess.Component.UIBFDsbDuelActSignUpSuccessItem")
local Localization = CS.GameEntry.Localization
local title_txt_path = "System/DetailTitle"
local sub_title_txt_path = "System/DScroll/DViewport/DContent/DSubTitle"
local message_txt_path = "System/DScroll/DViewport/DContent/DMessage"
local message_richtxt_path = "System/DScroll/DViewport/DContent/DMessageRichText"
local time_txt_path = "System/DetailTimeBg/DetailTime"
local detail_time_bg_path = "System/DetailTimeBg"
local scroll_view_path = "System/DScroll/DViewport/DContent/AllianceConditionScrollView"
local rapidjson = require("rapidjson")
local base64 = require("Framework.Common.base64")

function UILWMailDetailDsbDuelAllianceCondition:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailDsbDuelAllianceCondition:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailDsbDuelAllianceCondition:ComponentDefine()
  self.titleTxt = self:AddComponent(UIText, title_txt_path)
  self.subTitleTxt = self:AddComponent(UIText, sub_title_txt_path)
  self.messageTxt = self:AddComponent(UITextMeshProUGUIEx, message_txt_path)
  ChatInterface.SetEmojiTextProperty(self.messageTxt, true)
  self.messageRichTxt = self:AddComponent(UITextMeshProUGUIEx, message_richtxt_path)
  ChatInterface.SetEmojiTextProperty(self.messageRichTxt, true)
  self.messageRichTxt:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData.position)
  end)
  self.detail_time_bg = self:AddComponent(UIBaseContainer, detail_time_bg_path)
  self.timeTxt = self:AddComponent(UIText, time_txt_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
end

function UILWMailDetailDsbDuelAllianceCondition:ComponentDestroy()
  self:ClearScroll()
  self.titleTxt = nil
  self.subTitleTxt = nil
  self.messageTxt = nil
  self.messageSignatureTxt = nil
  self.messageRichTxt = nil
  self.detail_time_bg = nil
  self.timeTxt = nil
  self.scroll_view = nil
end

function UILWMailDetailDsbDuelAllianceCondition:DataDefine()
  self.mailUid = {}
  self.mailData = {}
end

function UILWMailDetailDsbDuelAllianceCondition:DataDestroy()
  self.mailUid = nil
  self.mailData = nil
end

function UILWMailDetailDsbDuelAllianceCondition:OnEnable()
  base.OnEnable(self)
end

function UILWMailDetailDsbDuelAllianceCondition:OnDisable()
  base.OnDisable(self)
end

function UILWMailDetailDsbDuelAllianceCondition:OnAddListener()
  base.OnAddListener(self)
end

function UILWMailDetailDsbDuelAllianceCondition:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWMailDetailDsbDuelAllianceCondition:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local _strTitle = MailShowHelper.GetMainTitle(self.mailData)
  _strTitle = string.gsub(_strTitle, "\n", "")
  _strTitle = ChatInterface.CheckMessage(_strTitle)
  self.titleTxt:SetText(_strTitle)
  local _strSubTitle = MailShowHelper.GetMailSubTitle(self.mailData)
  self.subTitleTxt:SetText(_strSubTitle)
  local _strContents = self.mailData:GetMailMessage()
  self:setMailText(_strContents)
  local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.detail_time_bg:SetActive(true)
  self.timeTxt:SetText(_strTime)
  self:CheckAllianceRequirements()
  self:ClearScroll()
  self.scroll_view:SetTotalCount(#self.data)
  self.scroll_view:RefillCells()
end

function UILWMailDetailDsbDuelAllianceCondition:setMailText(txt)
  local hasLinkData = txt:find("<link") ~= nil and txt:find("</link>") ~= nil
  if not hasLinkData and txt:find("X:") ~= nil and txt:find("Y:") ~= nil then
    txt = FindAndAppendLinkInfo(txt)
  end
  txt = ChatInterface.CheckMessage(txt)
  self.messageTxt:SetAlignment(CS.TMPro.TextAlignmentOptions.TopLeft)
  self.messageRichTxt:SetAlignment(CS.TMPro.TextAlignmentOptions.TopLeft)
  self.messageRichTxt:SetText_NotNative(txt)
  self.messageTxt:SetActive(false)
  self.messageRichTxt:SetActive(true)
end

function UILWMailDetailDsbDuelAllianceCondition:OnPointerClick(clickPos)
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

function UILWMailDetailDsbDuelAllianceCondition:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local item = self.scroll_view:AddComponent(UIBFDsbDuelActSignUpSuccessItem, itemObj)
  item:SetData(self.data[index])
end

function UILWMailDetailDsbDuelAllianceCondition:OnItemMoveOut(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UIBFDsbDuelActSignUpSuccessItem)
end

function UILWMailDetailDsbDuelAllianceCondition:ClearScroll()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIBFDsbDuelActSignUpSuccessItem)
end

function UILWMailDetailDsbDuelAllianceCondition:CheckAllianceRequirements()
  self.data = {}
  local thresholdStr = LuaEntry.DataConfig:TryGetStr("dsb_duel_league", "k4", "")
  local thresholdList = string.string2array_num_oneSep(thresholdStr, ",")
  local curState = -1
  local mailType = self.mailData.type
  if mailType == MailType.DSB_DUEL_ALLIANCE_CONDITION_SUCCESS then
    curState = 1
  end
  for i = 1, 3 do
    if mailType == MailType.DSB_DUEL_ALLIANCE_CONDITION_FAIL then
      curState = -1
      local tInfo = self.mailData:GetMailParamTable(i)
      if tInfo and tInfo.text then
        curState = toInt(tInfo.text)
      end
    end
    table.insert(self.data, {
      state = curState,
      index = i,
      param = thresholdList[i]
    })
  end
end

return UILWMailDetailDsbDuelAllianceCondition
