local IChatItem = require("UI.UIChatNew.Component.ChatItem.IChatItem")
local ChampionBattleReportShare = BaseClass("ChampionBattleReportShare", IChatItem)
local base = IChatItem
local ChatHead = require("UI.UIChatNew.Component.ChatHead")
local ChatUserName = require("UI.UIChatNew.Component.ChatItem.ChatUserName")
local rapidjson = require("rapidjson")
local Localization = CS.GameEntry.Localization
local _cp_chatHead = "ChatHead"
local _cp_ShareTitle = "ChatShareNode/Image/ShareTitle"
local _cp_shareMsg = "ChatShareNode/ShareIconNode/ShareMsg/ShareMsg"
local _cp_shareNode = "ChatShareNode"
local _cp_chatNameLayout = "ChatNameLayout"
local Const_Min_ShareNodeHeight = 120
local Const_OneLineHeight = 26
local UnityOutLine = typeof(CS.UnityEngine.UI.Outline)

function ChampionBattleReportShare:ComponentDefine()
  self._chatHead = self:AddComponent(ChatHead, _cp_chatHead)
  self._shareTitle = self:AddComponent(UIText, _cp_ShareTitle)
  self._shareTitleOutline = self._shareTitle.gameObject:GetComponent(UnityOutLine)
  self._shareMsg = self:AddComponent(UIText, _cp_shareMsg)
  self._shareNode = self:AddComponent(UIButton, _cp_shareNode)
  self._shareNode:SetOnClick(BindCallback(self, self.OnClickBg))
  self._chatNameLayout = self:AddComponent(ChatUserName, _cp_chatNameLayout)
end

function ChampionBattleReportShare:OnClickBg()
  if CS.SceneManager:IsInCity() then
    return UIUtil.ShowTipsId(120018)
  end
  DataCenter.ActChampionBattleManager:SendActChampionBattleReportDescCmd(self.type, self.reportId)
end

function ChampionBattleReportShare:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function ChampionBattleReportShare:GetBattleResult()
  return self.win
end

function ChampionBattleReportShare:UpdateItem(chatdata, index)
  base.UpdateItem(self, chatdata, index)
  if chatdata == nil then
    return
  end
  local attachmentId = chatdata.attachmentId or ""
  local tabAttachment = rapidjson.decode(attachmentId) or {}
  local tabParam = tabAttachment.para or {}
  self.reportId = tabParam.reportId
  self.type = tabParam.type
  self.win = tabParam.isWin
  local title = tabParam.title
  local titleDialog1 = tabParam.titleDialogId1
  local titleDialog2 = tabParam.titleDialogId2
  if titleDialog1 ~= nil and titleDialog2 ~= nil then
    local score1 = tabParam.score1
    local score2 = tabParam.score2
    local str = Localization:GetString(titleDialog1) .. Localization:GetString(titleDialog2) .. tostring(score1) .. ": " .. tostring(score2)
    self._shareTitle:SetText(str)
  elseif title then
    self._shareTitle:SetText(title)
  end
  local str = chatdata:getMessageWithExtra(false)
  self._shareMsg:SetText(str)
  local senderUid = chatdata.senderUid
  local _userInfo = ChatManager2:GetInstance().User:getChatUserInfo(senderUid, true)
  if self._chatNameLayout then
    self._chatNameLayout:UpdateName(_userInfo, chatdata)
  end
  local height = self._shareMsg:GetHeight()
  local curHeight = Const_Min_ShareNodeHeight + height - Const_OneLineHeight
  height = Mathf.Max(Const_Min_ShareNodeHeight, curHeight)
  local size_x, size_y = self._shareNode.rectTransform:Get_sizeDelta()
  self._shareNode.rectTransform:Set_sizeDelta(size_x, height)
  local r_x, _ = self.rectTransform:Get_sizeDelta()
  self.rectTransform:Set_sizeDelta(r_x, height + 40)
  local battleWin = self:GetBattleResult()
  if battleWin then
    self._shareTitle:SetColor(Const_Color_Green)
    self._shareTitleOutline.effectColor = Const_Green_Outline
  else
    self._shareTitle:SetColor(Const_Color_Red)
    self._shareTitleOutline.effectColor = Const_Red_Outline
  end
  self:UpdateTopOffset()
end

function ChampionBattleReportShare:GetTopOffset()
  if self._chatNameLayout then
    return self._chatNameLayout:GetTopOffset()
  else
    return 0
  end
end

function ChampionBattleReportShare:UpdateTopOffset()
  local initOffset = 40
  local initSizeY = 190
  local topOffset = self:GetTopOffset()
  local sizeX, _ = self.rectTransform:Get_sizeDelta()
  self.rectTransform:Set_sizeDelta(sizeX, initSizeY + topOffset)
  self:SetTransPosY(self._shareNode.rectTransform, -(initOffset + topOffset))
end

return ChampionBattleReportShare
