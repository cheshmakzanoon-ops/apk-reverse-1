local base = UIBaseView
local LWUIActEasterEggChatView = BaseClass("LWUIActEasterEggChatView", base)
local M = LWUIActEasterEggChatView
local Localization = CS.GameEntry.Localization
local LWUIActEasterEggChatTop = require("UI.LWUIActEasterEgg.LWUIActEasterEggChat.Component.LWUIActEasterEggChatTop")
local LWUIActEasterEggChatMiddle = require("UI.LWUIActEasterEgg.LWUIActEasterEggChat.Component.LWUIActEasterEggChatMiddle")
local LWUIActEasterEggChatBottom = require("UI.LWUIActEasterEgg.LWUIActEasterEggChat.Component.LWUIActEasterEggChatBottom")

function M:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:RequestChatData()
  self:RefreshView()
end

function M:OnDestroy()
  EventManager:GetInstance():Broadcast(EventId.EasterEggGetActivityRefreshMainEggAni)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.top = self:AddComponent(LWUIActEasterEggChatTop, "Root/top")
  self.middle = self:AddComponent(LWUIActEasterEggChatMiddle, "Root/middle")
  self.bottom = self:AddComponent(LWUIActEasterEggChatBottom, "Root/bottom")
  self.likeBtn = self:AddComponent(UIButton, "BtnsGroup/LikeBtn")
  self.likeBtn:SetOnClick(function()
    self:OnClickLike()
  end)
  self.likeBtnText = self:AddComponent(UIText, "BtnsGroup/LikeBtn/LikeBtnText")
  self.messageBtn = self:AddComponent(UIButton, "BtnsGroup/MessageBtn")
  self.messageBtn:SetOnClick(function()
    self:OnClickMessage()
  end)
  self.messageBtnText = self:AddComponent(UIText, "BtnsGroup/MessageBtn/MessageBtnText")
  self.getBtn = self:AddComponent(UIButton, "BtnsGroup/GetBtn")
  self.getBtn:SetOnClick(function()
    self:OnClickGet()
  end)
  self.getBtnText = self:AddComponent(UIText, "BtnsGroup/GetBtn/GetBtnText")
  self.reportBtn = self:AddComponent(UIButton, "BtnsGroup/ReportBtn")
  self.reportBtn:SetOnClick(function()
    self:OnClickReport()
  end)
  self.reportBtnText = self:AddComponent(UIText, "BtnsGroup/ReportBtn/ReportBtnText")
  self.titleText = self:AddComponent(UIText, "Root/top/txtTitle")
  self.gatherImage = self:AddComponent(UIImage, "Root/top/GatheringEggImage")
  self.voteImage = self:AddComponent(UIImage, "Root/top/VoteEggImage")
  self.likeBtnText:SetLocalText("activity_99144_ui_53")
  self.messageBtnText:SetLocalText("activity_99144_ui_54")
  self.getBtnText:SetLocalText("activity_99144_ui_55")
  self.reportBtnText:SetLocalText("activity_99144_ui_56")
end

function M:ComponentDestroy()
  self.titleText = nil
  self.gatherImage = nil
  self.voteImage = nil
end

function M:DataDefine()
  local data = self:GetUserData()
  self.eggInfo = data.eggInfo
  DataCenter.ActEasterEggManager:SetChatEggInfo(self.eggInfo)
  DataCenter.ActEasterEggManager:ClearTopLikeChatData()
end

function M:DataDestroy()
  local easterEggRoomId = ChatManager2:GetInstance().Room:GetEasterEggRoomId()
  if not string.IsNullOrEmpty(easterEggRoomId) then
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.RoomLeave, easterEggRoomId, ChatGroupType.GROUP_EASTER_EGG_ROOM)
    ChatManager2:GetInstance().Room:RemoveRoomData(easterEggRoomId)
    ChatManager2:GetInstance().Room:SetEasterEggRoomId(nil)
  end
  DataCenter.ActEasterEggManager:SetReadyForFirstPart(false)
  DataCenter.ActEasterEggManager:SetReadyForLikeDescendMsg(false)
  DataCenter.ActEasterEggManager:SetIsJumpTopLikeChatData(false)
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  self.eggInfo = nil
end

function M:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ERROR_OR_DISCONNECT, self.OnChatNetErrorOrDisconnect)
  self:AddUIListener(ChatEventEnum.CHAT_LOGIN_SUCCESS, self.OnChatLoginSuccess)
  self:AddUIListener(EventId.EasterEggGetActivityVotAniOver, self.RequestCommentData)
end

function M:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ERROR_OR_DISCONNECT, self.OnChatNetErrorOrDisconnect)
  self:RemoveUIListener(ChatEventEnum.CHAT_LOGIN_SUCCESS, self.OnChatLoginSuccess)
  self:RemoveUIListener(EventId.EasterEggGetActivityVotAniOver, self.RequestCommentData)
  base.OnRemoveListener(self)
end

function M:GetEggInfo()
  return DataCenter.ActEasterEggManager:GetChatEggInfo()
end

function M:RefreshByData(eggInfo)
  self:DataDestroy()
  self.eggInfo = eggInfo
  DataCenter.ActEasterEggManager:SetChatEggInfo(self.eggInfo)
  DataCenter.ActEasterEggManager:ClearTopLikeChatData()
  self:RequestChatData()
  self:RefreshView()
end

function M:RefreshView()
  local title = ""
  if self.eggInfo then
    local type = self.eggInfo:GetEggType()
    if type == ActEasterEggType.Vote then
      title = Localization:GetString("activity_99144_ui_66")
      self.gatherImage:SetActive(false)
      self.voteImage:SetActive(true)
    elseif type == ActEasterEggType.Gathering then
      title = Localization:GetString("activity_99144_ui_65")
      self.gatherImage:SetActive(true)
      self.voteImage:SetActive(false)
    end
  end
  self.titleText:SetText(title)
  self.middle:OnChatLoginSuccess()
  self:DelayToShowNativeInputField()
end

function M:RequestChatData()
  local easterEggRoomId = ChatManager2:GetInstance().Room:SetEasterEggRoomId(self.eggInfo.eggUuid)
  ChatManager2:GetInstance().Room:CreateChatRoom(easterEggRoomId, ChatGroupType.GROUP_EASTER_EGG_ROOM)
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.RoomJoinMulti, ChatGroupType.GROUP_EASTER_EGG_ROOM, easterEggRoomId)
  self:RequestCommentData()
end

function M:OnChatNetErrorOrDisconnect()
  self.middle:OnChatNetErrorOrDisconnect()
end

function M:OnChatLoginSuccess()
  self.middle:OnChatLoginSuccess()
  self:RequestChatData()
end

function M:RequestCommentData()
  DataCenter.ActEasterEggManager:SetReadyForFirstPart(false)
  DataCenter.ActEasterEggManager:SetReadyForLikeDescendMsg(false)
  DataCenter.ActEasterEggManager:SetIsJumpTopLikeChatData(false)
  local likeSeqIdList = self.eggInfo:GetPraiseSeqArr()
  local hasLikeComment = likeSeqIdList and 0 < #likeSeqIdList
  local easterEggRoomId = ChatManager2:GetInstance().Room:SetEasterEggRoomId(self.eggInfo.eggUuid)
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomsV2, {easterEggRoomId})
  if hasLikeComment then
    local isLikeDescendOrder = DataCenter.ActEasterEggManager:GetIsOnLikeDescendOrder()
    if isLikeDescendOrder then
      ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomSeqIdList, easterEggRoomId, likeSeqIdList)
    else
      ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.HistoryRoomSeqIdList, easterEggRoomId, {
        likeSeqIdList[1]
      })
    end
  else
    DataCenter.ActEasterEggManager:SetReadyForLikeDescendMsg(true)
  end
end

function M:OnClickLike()
  DataCenter.ActEasterEggManager:SendEggChatThumbsUp_PostOrVote()
end

function M:OnClickGet()
  local activityData = DataCenter.ActEasterEggManager:GetActivityData()
  if activityData:ReachPickUpLimit() then
    UIUtil.ShowTipsId("activity_99144_13")
    return
  end
  self.ctrl:CloseSelf()
  if not activityData then
    Logger.LogError("activityData ia nil")
    return
  end
  local activityId = activityData.activityId
  SFSNetwork.SendMessage(MsgDefines.EasterEggPickUp, toInt(activityId))
end

function M:OnClickMessage()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActEasterEggMessage)
end

function M:OnClickReport()
  local posterInfo = self.eggInfo:GetPosterInfo()
  if not posterInfo then
    Logger.LogError("posterInfo is nil")
    return
  end
  local curAnonymousName = self.eggInfo:GetCurAnonymousName()
  local showName = DataCenter.ActEasterEggManager:GetTranslateName(curAnonymousName)
  local realName = posterInfo.name
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIChatReport, {anim = true}, {
    type = ReportType.ActEasterEggOwner,
    createTime = self.eggInfo.createTime,
    uid = posterInfo.uid,
    name = showName,
    realName = realName,
    msg = self.eggInfo.content,
    eggUuid = self.eggInfo.eggUuid
  })
end

function M:DelayToShowNativeInputField()
  if self:IsOnAndroidOrIOS() then
    self.bottom:SetUMIVisible(false)
    if self.delayTimer ~= nil then
      self.delayTimer:Stop()
      self.delayTimer = nil
    end
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.bottom then
        self.bottom:SetUMIVisible(true)
      end
    end, 0.4)
  end
end

function M:IsOnAndroidOrIOS()
  return (CS.SDKManager.IS_UNITY_ANDROID() or CS.SDKManager.IS_UNITY_IOS()) and not CS.SDKManager.IS_UNITY_EDITOR()
end

return M
