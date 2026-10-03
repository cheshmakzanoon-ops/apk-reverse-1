local base = UIBaseContainer
local UISingleMomentMiddle = BaseClass("UISingleMomentMiddle", base)
local UISingleMonmentMessageArea = require("UI.LWPlayerInfo.UILWSingleMomentDetailView.Component.UISingleMonmentMessageArea")
local compBook = {
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
    path = "Scroll_View_mainView",
    name = "scrollMsgs",
    type = UISingleMonmentMessageArea
  }
}

function UISingleMomentMiddle:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UISingleMomentMiddle:OnDestroy()
  if self.__reloadChatTimer then
    self.__reloadChatTimer:Stop()
    self.__reloadChatTimer = nil
  end
  self.__firstTimeReloaded = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISingleMomentMiddle:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(ChatEventEnum.CHAT_ONE_ROOM_HISTORY_MSG, self.OnHistoryOneRoomMsg)
end

function UISingleMomentMiddle:OnRemoveListener()
  self:RemoveUIListener(ChatEventEnum.CHAT_ONE_ROOM_HISTORY_MSG, self.OnHistoryOneRoomMsg)
  base.OnRemoveListener(self)
end

function UISingleMomentMiddle:OnHistoryOneRoomMsg(tempRoomData)
  if tempRoomData.roomId == self.circleCommentRoomId then
    local tempRoom = ChatInterface.getRoomData(tempRoomData.roomId)
    if tempRoom then
      self.scrollMsgs:RefreshRoomData(tempRoomData.roomId)
    end
  end
end

function UISingleMomentMiddle:ReInit(data)
  self.data = data
  self.roomOwner = data.senderUid
  local detailData = DeepCopy(data)
  detailData.notLikeLayOut = true
  self.scrollMsgs:SetTitleData(detailData)
  self.circleCommentRoomId = ChatManager2:GetInstance().Room:GetFriendsCircleCommentRoomId(self.data.senderUid, self.data.seqId)
  self.scrollMsgs:RefreshRoomData(self.circleCommentRoomId)
end

function UISingleMomentMiddle:ComponentDefine()
  ChatManager2:GetInstance().Room:RemoveRoomData(self.circleCommentRoomId)
  self:DefineCompsByBook(compBook)
end

function UISingleMomentMiddle:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UISingleMomentMiddle:UpdateMessages(room)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
  if self.__firstTimeReloaded then
    self.scrollMsgs:RefreshRoomData(self.circleCommentRoomId)
  else
    if self.__reloadChatTimer then
      return
    end
    self.__reloadChatTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.__firstTimeReloaded = true
      self.scrollMsgs:ReLoadChat()
    end, 0.2)
  end
end

function UISingleMomentMiddle:UpdateNoticeData(data)
  data.isNotice = true
  self.scrollMsgs:SetNoticeData(data)
end

function UISingleMomentMiddle:SetClickZoneActive(active, token, callback)
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

function UISingleMomentMiddle:OnClickZone()
  if self.__clickZoneCallback then
    self.__clickZoneCallback()
  end
end

return UISingleMomentMiddle
