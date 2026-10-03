local base = UIBaseContainer
local UIChatViewMiddle_v2 = BaseClass("UIChatViewMiddle_v2", base)
local UIChatViewRoomsBar = require("UI.UIChatNewV2.Component.UIChatViewRoomsBar_v2")
local UIChatViewPinList = require("UI.UIChatNewV2.Component.UIChatViewPinList_v2")
local UIChatViewPrivateList = require("UI.UIChatNewV2.Component.UIChatViewPrivateList_v2")
local UIChatViewMessageArea_new = require("UI.UIChatNewV2.Component.UIChatViewMessageArea_v3")
local Localization = CS.GameEntry.Localization
local UIChatViewNoticeList = require("UI.UIChatNewV2.Component.UIChatViewNoticeList")
local UILWChatBubbleTipCommon = require("UI.UILWAlliance.UILWAlHelp.Component.UILWChatBubbleTipCommon")
local UILWChatUnreadJumpTip = require("UI.UIChatNewV2.Component.Bubble.UILWChatUnreadJumpTip")
local UIChatMonment = require("UI.UIChatNewV2.Component.Monment.UIChatMonment")
local UIChatRoomFilterBar = require("UI.UIChatNewV2.Component.UIChatRoomFilterBar")
local InstanceRequestState = CS.InstanceRequest.State

local function GetMigrationTargetSrcServer(userInfo)
  if userInfo == nil then
    return 0
  end
  local srcServer = tonumber(userInfo.srcServer) or 0
  if 0 < srcServer then
    return srcServer
  end
  local crossFightSrcServerId = tonumber(userInfo.crossFightSrcServerId) or 0
  if 0 < crossFightSrcServerId then
    return crossFightSrcServerId
  end
  return tonumber(userInfo.serverId) or 0
end

local compBook = {
  {
    path = "barRooms",
    name = "barRooms",
    type = UIChatViewRoomsBar
  },
  {
    path = "listPins",
    name = "listPins",
    type = UIChatViewPinList
  },
  {
    path = "Monment",
    name = "moment",
    type = UIChatMonment
  },
  {
    path = "bgMiddle/momentBg",
    name = "momentBg",
    type = UIImage
  },
  {
    path = "listPrivate",
    name = "listPrivate",
    type = UIChatViewPrivateList,
    active = false
  },
  {
    path = "btnZone",
    name = "btnZone",
    type = UIButton,
    active = false,
    onClick = function(self)
      self:OnClickZone()
    end
  },
  {
    path = "scrollView_noticeList",
    name = "noticeList",
    type = UIChatViewNoticeList
  },
  {
    path = "StickerPoolNode",
    name = "stickerPoolNode",
    type = UIBaseComponent
  },
  {
    path = "AlHelpTipsRoot",
    name = "AlHelpTipsRoot",
    type = UIBaseContainer
  },
  {
    path = "Scroll_View_mainView/UnreadJumpTipsRoot/BubbleUnreadJump",
    name = "UnreadJumpTips",
    type = UILWChatUnreadJumpTip
  },
  {
    path = "MigrationSignBtn",
    name = "btnMigrationSign",
    type = UIButton,
    active = false,
    onClick = function(self)
      self:OnClickMigrationSign()
    end
  },
  {
    path = "MigrationSignBtn/MigrationSignTips",
    name = "compMigrationSignTips",
    type = UIBaseComponent,
    active = false
  },
  {
    path = "MigrationSignBtn/MigrationSignTips/MigrationSignTipText",
    name = "textMigrationSignTip",
    type = UITextMeshProUGUIEx
  }
}

function UIChatViewMiddle_v2:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:OnRefreshCommonBubbleTip()
end

function UIChatViewMiddle_v2:OnDestroy()
  if self.__reloadChatTimer then
    self.__reloadChatTimer:Stop()
    self.__reloadChatTimer = nil
  end
  self.__firstTimeReloaded = nil
  self.migrationSignUid = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChatViewMiddle_v2:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.scrollMsgs = self:AddComponent(UIChatViewMessageArea_new, "Scroll_View_mainView")
  self.roomFilterBar = self:AddComponent(UIChatRoomFilterBar, "RoomFilterBar")
  self.goChatDynamicSticker = self.transform:Find("StickerPoolNode/ChatDynamicSticker").gameObject
  self.goChatDynamicSticker:GameObjectCreatePool()
  self.bubbleTipCommonAsset = nil
  self.bubbleTipCommonScript = nil
  self.bubbleAlTrainAsset = nil
  self.bubbleAlTrainScript = nil
  self:DeactiveUnreadJumpBubbleTips()
end

function UIChatViewMiddle_v2:ComponentDestroy()
  self.goChatDynamicSticker:GameObjectRecycleAll()
  ChatInterface.getRoomMgr():ClearAllRoomStickerNode()
  ChatInterface.getRoomMgr():ClearAllStickerDiceData()
  self.AlHelpTipsRoot:RemoveComponents(UILWChatBubbleTipCommon)
  self.bubbleAlTrainScript = nil
  if self.bubbleTipCommonAsset ~= nil then
    self:GameObjectDestroy(self.bubbleTipCommonAsset)
  end
  self.bubbleTipCommonAsset = nil
  self.bubbleTipCommonScript = nil
  self:ClearCompsByBook(compBook)
end

function UIChatViewMiddle_v2:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ChatViewTipBubbleStateChange, self.OnRefreshCommonBubbleTip)
  self:AddUIListener(EventId.CHAT_RECEIVE_AT_SEQ_ID, self.OnReceiveChatAtSeqIds)
  self:AddUIListener(EventId.ROOM_BE_KICK_OUT, self.OnBeKickOut)
  self:AddUIListener(EventId.UPDATE_MSG_USERINFO, self.OnMigrationSignUserInfoUpdate)
  self:AddUIListener(EventId.ActMigrationMarkPlayerUpdate, self.OnRefreshMigrationSign)
end

function UIChatViewMiddle_v2:OnRemoveListener()
  self:RemoveUIListener(EventId.ChatViewTipBubbleStateChange, self.OnRefreshCommonBubbleTip)
  self:RemoveUIListener(EventId.CHAT_RECEIVE_AT_SEQ_ID, self.OnReceiveChatAtSeqIds)
  self:RemoveUIListener(EventId.ROOM_BE_KICK_OUT, self.OnBeKickOut)
  self:RemoveUIListener(EventId.UPDATE_MSG_USERINFO, self.OnMigrationSignUserInfoUpdate)
  self:RemoveUIListener(EventId.ActMigrationMarkPlayerUpdate, self.OnRefreshMigrationSign)
  base.OnRemoveListener(self)
end

function UIChatViewMiddle_v2:OnMigrationSignUserInfoUpdate()
  local room = self.view and self.view:GetSelectedRoom() or nil
  self:RefreshMigrationSignBtn(room)
end

function UIChatViewMiddle_v2:UpdateBar(roomSet, scrollToActive)
  if roomSet.category == ChatRoomCategory.MOMENT then
    self.barRooms:SetActive(false)
    self.roomFilterBar:SetActive(true)
    self.roomFilterBar:ReInitRoom(roomSet)
  else
    self.barRooms:SetActive(true)
    self.roomFilterBar:SetActive(false)
    self.barRooms:UpdateTabs(roomSet, scrollToActive)
  end
end

function UIChatViewMiddle_v2:UpdatePins(room)
  local isMoment = ChatInterface.GetIsMomentGroup(room.group)
  self.listPins:SetActive(not isMoment)
  self.roomFilterBar:SetActive(isMoment)
  if not isMoment then
    self.listPins:UpdatePins(room)
  end
end

function UIChatViewMiddle_v2:UpdatePrivateList(roomSet)
  self.listPrivate:UpdateList(roomSet)
  DataCenter.ChatViewTipBubbleDataManager:SetCurRoomData(nil)
  self:OnRefreshCommonBubbleTip()
  self:RefreshMigrationSignBtn(roomSet.currRoom)
end

function UIChatViewMiddle_v2:OnBeKickOut(data)
  local room = self.view:GetSelectedRoom()
  if room.roomId == data.roomId then
    UIUtil.ShowConfirmNew({
      contentText = Localization:GetString("group_chat_remove_tips"),
      btnNum = 1,
      showToggle = false,
      confirmBtnParam = {
        action = function()
          ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.ChatClearKickInfo, room.roomId)
        end
      },
      closeAction = function()
        ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.ChatClearKickInfo, room.roomId)
      end
    })
  end
end

function UIChatViewMiddle_v2:UpdateMessages(room, seqId, jumpType)
  if room and ChatInterface.GetIsMomentGroup(room.group) then
    DataCenter.ChatViewTipBubbleDataManager:SetCurRoomData(room.group)
    self:OnRefreshCommonBubbleTip()
    self:RefreshMigrationSignBtn(nil)
    self.moment:ReInit(room.group)
    return
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
  if self.__firstTimeReloaded then
    self.scrollMsgs:RecycleAllChatItems()
    self.scrollMsgs:SetJumpSeqId(seqId, jumpType)
    self.scrollMsgs:ReLoadChat()
    self.scrollMsgs:CheckShowMoveToTailBtn()
    self.view.ctrl:ShowUnreadCountAndJump()
  else
    if self.__reloadChatTimer then
      return
    end
    self.__reloadChatTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.__firstTimeReloaded = true
      self.scrollMsgs:RecycleAllChatItems()
      self.scrollMsgs:SetJumpSeqId(seqId, jumpType)
      self.scrollMsgs:ReLoadChat()
      self.scrollMsgs:CheckShowMoveToTailBtn()
      self.view.ctrl:ShowUnreadCountAndJump()
    end, 0.2)
  end
  if room:IsKickedRoom() then
    self:OnBeKickOut(room)
  end
  DataCenter.ChatViewTipBubbleDataManager:SetCurRoomData(room.group)
  self:OnRefreshCommonBubbleTip()
  self:RefreshMigrationSignBtn(room)
end

function UIChatViewMiddle_v2:SetPrivateListActive(active)
  self.listPrivate:SetActive(active)
  self.barRooms:SetActive(not active)
  self.listPins:SetActive(not active)
  self.roomFilterBar:SetActive(false)
end

function UIChatViewMiddle_v2:SetClickZoneActive(active, token, callback)
  if active then
    self.__clickZoneCallback = callback
    self.__clickZoneToken = token
    self.btnZone:SetActive(true)
  elseif self.__clickZoneToken == token then
    self.__clickZoneCallback = nil
    self.__clickZoneToken = nil
    self.btnZone:SetActive(false)
  end
end

function UIChatViewMiddle_v2:SetScrollMsgsActive(active)
  if self.scrollMsgs and self.scrollMsgs.gameObject then
    self.scrollMsgs:SetActive(active)
    self.scrollMsgs.gameObject:SetActive(active)
  end
end

function UIChatViewMiddle_v2:SetNoticeActive(active)
  if self.noticeList.activeSelf ~= active then
    self.noticeList:SetActive(active)
  end
  if active then
    self.noticeList:ReInit()
  end
end

function UIChatViewMiddle_v2:SetMomentActive(active)
  if self.moment.activeSelf ~= active then
    self.moment:SetActive(active)
  end
  if ChatInterface.GetChatTheme() == 1 and active then
    self.momentBg:SetActive(true)
  else
    self.momentBg:SetActive(false)
  end
end

function UIChatViewMiddle_v2:OnRefreshCommonBubbleTip()
  local curShowData = DataCenter.ChatViewTipBubbleDataManager:GetCurShowTipBubbleData()
  if curShowData == nil then
    if self.bubbleTipCommonAsset ~= nil and self.bubbleTipCommonScript ~= nil then
      self.bubbleTipCommonScript:RefreshView()
    end
    return
  end
  if self.bubbleTipCommonAsset == nil then
    self.bubbleTipCommonAsset = self:GameObjectInstantiateAsync(UIAssets.ChatBubbleCommonTip, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.AlHelpTipsRoot.transform)
      go.transform:Set_localScale(1, 1, 1)
      go.transform:Set_localPosition(0, 0, 0)
      go.transform:SetAsFirstSibling()
      self.bubbleTipCommonScript = self.AlHelpTipsRoot:AddComponent(UILWChatBubbleTipCommon, go.name)
      self.bubbleTipCommonScript:RefreshView()
    end)
  elseif self.bubbleTipCommonScript then
    self.bubbleTipCommonScript:RefreshView()
  end
end

function UIChatViewMiddle_v2:RefreshMigrationSignBtn(room)
  local flag = room ~= nil and room:isPrivateChat()
  if flag then
    local userInfo = room:getPrivateOtherMember()
    local srcServer = GetMigrationTargetSrcServer(userInfo)
    self.migrationSignUid = userInfo ~= nil and userInfo.uid or nil
    flag = userInfo ~= nil and srcServer ~= 0 and srcServer ~= LuaEntry.Player:GetSourceServerId() and DataCenter.ActMigrationManager:CheckCanSetting()
  end
  if not flag then
    self.migrationSignUid = nil
  end
  self.btnMigrationSign:SetActive(flag)
  self:OnRefreshMigrationSign()
end

function UIChatViewMiddle_v2:OnRefreshMigrationSign()
  local flag = self.btnMigrationSign:GetActive()
  if not flag then
    return
  end
  flag = DataCenter.ActMigrationManager:IsPlayerMarked(self.migrationSignUid)
  self.btnMigrationSign:LoadSpriteAuto(string.format(LoadPath.LWChat2Common, flag and "ljq_s2_yimin_biaoji_02.png" or "ljq_s2_yimin_biaoji_01.png"))
  self.compMigrationSignTips:SetActive(not flag)
  if not flag then
    self.textMigrationSignTip:SetLocalText("migration_activity_desc_1008")
  end
end

function UIChatViewMiddle_v2:ClearChatDynamicStickerGo()
  if self.goChatDynamicSticker == nil then
    return
  end
  self.goChatDynamicSticker:GameObjectRecycleAll()
end

function UIChatViewMiddle_v2:OnClickZone()
  if self.__clickZoneCallback then
    self.__clickZoneCallback()
  end
end

function UIChatViewMiddle_v2:OnClickMigrationSign()
  if self.migrationSignUid == nil then
    return
  end
  local flag = DataCenter.ActMigrationManager:IsPlayerMarked(self.migrationSignUid)
  DataCenter.ActMigrationManager:ReqPlayerMark(self.migrationSignUid, not flag)
end

function UIChatViewMiddle_v2:ActiveUnreadJumpBubbleTips(roomId, seqId, count, tipType)
  local roomMgr = ChatInterface.getRoomMgr()
  local room = roomMgr:GetRoomData(roomId)
  if room and room:isPrivateChat() and not roomMgr:GetIsShowPrivateRoom(roomId) then
    return
  end
  self.UnreadJumpTips:InitView(roomId, seqId, count, tipType or ChatTipType.Unread)
  self.UnreadJumpTips:SetActive(true)
end

function UIChatViewMiddle_v2:DeactiveUnreadJumpBubbleTips()
  self.UnreadJumpTips:SetActive(false)
end

function UIChatViewMiddle_v2:OnReceiveChatAtSeqIds()
end

function UIChatViewMiddle_v2:ActiveAtJumpBubbleTips(roomId, seqId, count, tipType)
  self.UnreadJumpTips:InitView(roomId, seqId, count or 0, tipType or ChatTipType.At)
  self.UnreadJumpTips:SetActive(true)
end

function UIChatViewMiddle_v2:UpdateMomentMessage()
  self.moment:UpdateMessage()
end

return UIChatViewMiddle_v2
