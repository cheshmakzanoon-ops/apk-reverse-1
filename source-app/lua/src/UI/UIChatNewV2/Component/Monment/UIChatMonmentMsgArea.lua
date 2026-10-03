local base = require("UI.UIChatNew.Component.UniversalComponent.BaseLoopView")
local FriendCircleFrame = require("UI.LWPlayerInfo.FriendCirclePost.FriendCircleFrame")
local UIChatMonmentMsgArea = BaseClass("BaseLoopView", base)

function UIChatMonmentMsgArea:OnCreate()
  base.OnCreate(self)
  self.headCanClick = true
  self.darkModeSupport = true
  self.showLine = true
end

function UIChatMonmentMsgArea:ComponentDefine()
  base.ComponentDefine(self)
end

function UIChatMonmentMsgArea:GetChatItemScriptName(index)
  return FriendCircleFrame
end

function UIChatMonmentMsgArea:GetItemPrefabName(index)
  return "FriendCircleFrame"
end

function UIChatMonmentMsgArea:SetChatItemSizeDelta(item)
  if item.CachedRectTransform.sizeDelta.x == self._scrollView:GetViewPortWidth() - 80 then
    return
  end
  self.chatItemSizeDelta = self.chatItemSizeDelta or Vector2.zero
  self.chatItemSizeDelta.x = self._scrollView:GetViewPortWidth() - 80
  self.chatItemSizeDelta.y = item.CachedRectTransform.sizeDelta.y
  item.CachedRectTransform.sizeDelta = self.chatItemSizeDelta
end

function UIChatMonmentMsgArea:SetGroupType(group)
  self.chatGroup = group
end

function UIChatMonmentMsgArea:RefreshRoomData(group)
  self._scrollView:StopMovement()
  local room = ChatInterface.getMoment():GetMomentData(group)
  if room then
    self._chatDatas = room.msgs
    if group ~= ChatGroupType.GROUP_SUGGEST_MOMENT then
      table.sort(self._chatDatas, function(a, b)
        return a.serverTime > b.serverTime
      end)
    end
    self._scrollView:SetListItemCount(#self._chatDatas, false, false)
    self._scrollView.unity_looplistview2:RefreshAllShownItem()
  end
end

function UIChatMonmentMsgArea:OnTopPull()
  ChatInterface.getMoment():ClearMomentRoom(self.chatGroup)
  ChatInterface.getMoment():GetMomentServerByGroup(self.chatGroup)
end

function UIChatMonmentMsgArea:OnBottomPull()
  if self.view then
    local msgId = self._chatDatas[#self._chatDatas] and self._chatDatas[#self._chatDatas].msgId or 0
    ChatInterface.getMoment():GetMomentServerByGroup(self.chatGroup)
  end
end

function UIChatMonmentMsgArea:OnItemCreate(item, index)
  ChatInterface.getMoment():AddExposure(self._chatDatas[index], self.chatGroup)
end

return UIChatMonmentMsgArea
