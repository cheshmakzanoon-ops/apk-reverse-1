local IChatItemPost = require("UI.UIChatNewV2.Component.ChatItem.IChatItemPost")
local base = IChatItemPost
local ChatItemPost_AllianceInvite = BaseClass("ChatItemPost_AllianceInvite", base)
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local AllianceRecommendInfo = require("DataCenter.AllianceData.AllianceRecommendInfo")
local UIAllianceInfoPanel = require("UI.UIAlliance.UIAllianceInfo.Component.UIAllianceInfoPanel")

function ChatItemPost_AllianceInvite:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ChatItemPost_AllianceInvite:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ChatItemPost_AllianceInvite:ComponentDefine()
  self.bg = self:AddComponent(UIImage, "Root/Bg")
  self.line = self:AddComponent(UIImage, "Root/DownPanel/LineImg")
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.compBtnPanel = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.btnRejected = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnRejected:SetOnClick(function()
    self:OnBtnRejectedClick()
  end)
  self.textBtnRejected = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnJoin = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnJoin:SetOnClick(function()
    self:OnBtnJoinClick()
  end)
  self.textBtnJoin = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.compRecordPanel = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.textRecord = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.imgSure = self.viewSkin:AddComponent(self, UIImage, 9)
  self.imgRefuse = self.viewSkin:AddComponent(self, UIImage, 10)
  self.compWaitPanel = self.viewSkin:AddComponent(self, UIBaseComponent, 11)
  self.textWaitTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.textWaitTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.textBtnRejectedTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.compAllianceInfoPanel = self.viewSkin:AddComponent(self, UIAllianceInfoPanel, 15)
  self.textTitle:SetLocalText("alliance_invite_title_joinus")
  self.textBtnJoin:SetLocalText("393106")
  self.textBtnRejected:SetLocalText("393107")
  self.textWaitTip:SetLocalText("alliance_invite_status_waiting")
end

function ChatItemPost_AllianceInvite:ComponentDestroy()
  self.bg = nil
  self.line = nil
  self.viewSkin = nil
  self.textTitle = nil
  self.compBtnPanel = nil
  self.btnRejected = nil
  self.textBtnRejected = nil
  self.btnJoin = nil
  self.textBtnJoin = nil
  self.compRecordPanel = nil
  self.textRecord = nil
  self.imgSure = nil
  self.imgRefuse = nil
  self.compWaitPanel = nil
  self.textWaitTip = nil
  self.textWaitTime = nil
  self.textBtnRejectedTime = nil
  self.compAllianceInfoPanel = nil
end

function ChatItemPost_AllianceInvite:DataDefine()
end

function ChatItemPost_AllianceInvite:DataDestroy()
end

function ChatItemPost_AllianceInvite:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
end

function ChatItemPost_AllianceInvite:OnRemoveListener()
  self:RemoveUIListener(EventId.CHAT_ROOM_ONEMSG_UPDATA, self.OnUpdateMsg)
  base.OnRemoveListener(self)
end

function ChatItemPost_AllianceInvite:OnBtnRejectedClick()
  if self.inviteUid and self.inviteAllianceId and self.seqId and self.roomId then
    SFSNetwork.SendMessage(MsgDefines.AllianceManagerRecommendationReceivedInvite, self.inviteUid, self.inviteAllianceId, self.seqId, self.roomId, false)
  end
end

function ChatItemPost_AllianceInvite:OnBtnJoinClick()
  if not string.IsNullOrEmpty(LuaEntry.Player.allianceId) and not string.IsNullOrEmpty(self.inviteAllianceId) and LuaEntry.Player.allianceId == self.inviteAllianceId then
    UIUtil.ShowTipsId("alliance_invite_tips_alreadyIn")
    self:RefreshDownPanel("1")
    return
  end
  if self.seqId and self.roomId then
    DataCenter.AllianceFeatureManager:ReceivedInvite(self.inviteUid, self.inviteAllianceId, self.seqId, self.roomId)
  end
end

function ChatItemPost_AllianceInvite:UpdateUserInfo()
end

function ChatItemPost_AllianceInvite:OnLoaded()
  local _chatData = self:ChatData()
  if _chatData == nil then
    return
  end
  self.seqId = _chatData:getSeqId()
  self.roomId = _chatData.roomId
  self:Refresh(_chatData)
end

function ChatItemPost_AllianceInvite:OnUpdateMsg(chatData)
  if chatData and chatData.seqId == self.seqId and chatData.roomId == self.roomId then
    self:Refresh(chatData)
    self:UpdateSize()
  end
end

function ChatItemPost_AllianceInvite:Refresh(_chatData)
  local titleColor, recordColor
  local isMyChat = _chatData:isMyChat()
  self.isMyChat = isMyChat
  if isMyChat then
    self.bg:LoadSprite(ChatInterface.GetChatUIPath(UIAssets.ChatItemBg_right))
    titleColor = ChatUIThemeConfig.AllianceInvite_TitleColor[2]
    recordColor = ChatUIThemeConfig.AllianceInvite_RecordColor[2]
  else
    self.bg:LoadSprite(ChatInterface.GetChatUIPath(UIAssets.ChatItemBg_left))
    titleColor = ChatUIThemeConfig.AllianceInvite_TitleColor[1]
    recordColor = ChatUIThemeConfig.AllianceInvite_RecordColor[1]
  end
  local chatIndex = ChatInterface.GetChatTheme()
  self.chatThemeIndex = chatIndex
  self.textTitle:SetColor(titleColor[chatIndex])
  self.textRecord:SetColor(recordColor[chatIndex])
  self.imgSure:SetAlpha(ChatUIThemeConfig.AllianceInvite_IconAlpha[chatIndex])
  self.imgRefuse:SetAlpha(ChatUIThemeConfig.AllianceInvite_IconAlpha[chatIndex])
  if _chatData.extra == nil or _chatData.extra.customJsonParam == nil then
    Logger.LogError("UpdateItem error ----------- > roomId : " .. _chatData.roomId .. "seqId : " .. _chatData.seqId)
    return
  end
  local customData = _chatData.extra.customJsonParam
  if customData and customData.allianceInfo then
    self.recommendInfo = AllianceRecommendInfo.New()
    self.recommendInfo:ParseMsg(customData)
    self.compAllianceInfoPanel:Refresh(self.recommendInfo, isMyChat, chatIndex)
    self.inviteUid = customData.inviteUid
    self.inviteAllianceId = self.recommendInfo.allianceId
    self.expireTime = customData.expireTime
    local agree = _chatData.clientUpdateExtra
    self:RefreshDownPanel(agree)
  end
  self:Update1000MS()
end

function ChatItemPost_AllianceInvite:OnRecycle()
end

function ChatItemPost_AllianceInvite:Update1000MS()
  if self.expireTime then
    if self.compBtnPanel:GetActive() then
      local now = UITimeManager:GetInstance():GetServerTime()
      local diff = self.expireTime - now
      self.textBtnRejectedTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(diff))
      if diff < 0 then
        self:RefreshDownPanel("0")
      end
    elseif self.compWaitPanel:GetActive() then
      local now = UITimeManager:GetInstance():GetServerTime()
      local diff = self.expireTime - now
      self.textWaitTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(diff))
      if diff < 0 then
        self:RefreshDownPanel("0")
      end
    end
  end
end

function ChatItemPost_AllianceInvite:RefreshDownPanel(agree)
  local isMyChat = self.isMyChat
  if string.IsNullOrEmpty(agree) or agree == "0" then
    if not isMyChat and not string.IsNullOrEmpty(LuaEntry.Player.allianceId) and not string.IsNullOrEmpty(self.inviteAllianceId) and LuaEntry.Player.allianceId == self.inviteAllianceId then
      agree = "1"
    else
      local now = UITimeManager:GetInstance():GetServerTime()
      if now > self.expireTime then
        agree = "-1"
      end
    end
  end
  if string.IsNullOrEmpty(agree) or agree == "0" then
    if isMyChat then
      self.compBtnPanel:SetActive(false)
      self.compRecordPanel:SetActive(false)
      self.compWaitPanel:SetActive(true)
    else
      self.compBtnPanel:SetActive(true)
      self.compRecordPanel:SetActive(false)
      self.compWaitPanel:SetActive(false)
    end
  elseif agree == "1" then
    self.compBtnPanel:SetActive(false)
    self.compRecordPanel:SetActive(true)
    self.compWaitPanel:SetActive(false)
    self.textRecord:SetLocalText("alliance_invite_status_joined")
    self.imgSure:SetActive(true)
    self.imgRefuse:SetActive(false)
  elseif agree == "-1" then
    self.compBtnPanel:SetActive(false)
    self.compRecordPanel:SetActive(true)
    self.compWaitPanel:SetActive(false)
    self.textRecord:SetLocalText("alliance_invite_status_rejected")
    self.imgSure:SetActive(false)
    self.imgRefuse:SetActive(true)
  end
end

return ChatItemPost_AllianceInvite
