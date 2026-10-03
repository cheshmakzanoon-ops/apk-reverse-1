local base = require("UI.UIChatNew.Component.UniversalComponent.BaseLoopView")
local FollowItem = require("UI.UILWFriendsCircleFollowee.Component.LWFollowItem")
local LWMomentPlayerList = BaseClass("LWMomentPlayerList", base)

function LWMomentPlayerList:GetChatItemScriptName(index)
  return FollowItem
end

function LWMomentPlayerList:GetItemPrefabName(index)
  return "Roles"
end

function LWMomentPlayerList:SetChatItemSizeDelta(item)
end

function LWMomentPlayerList:OnDestroy()
  base.OnDestroy(self)
  if self.unFollowDic then
    local uidList = {}
    for uid, v in pairs(self.unFollowDic) do
      table.insert(uidList, uid)
    end
    if 0 < #uidList then
      ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.MomentUnFollow, uidList)
    end
    self.unFollowDic = nil
  end
end

function LWMomentPlayerList:SetUnFollow(uid, state)
  if not self.unFollowDic then
    self.unFollowDic = {}
  end
  if state then
    self.unFollowDic[uid] = state
  elseif self.unFollowDic[uid] then
    self.unFollowDic[uid] = nil
  end
end

function LWMomentPlayerList:RefreshRoomData()
  local momentList = ChatInterface.getMoment():GetMomentFollowList()
  if momentList then
    self._chatDatas = momentList
    table.sort(self._chatDatas, function(a, b)
      return a.id > b.id
    end)
    self._scrollView:SetListItemCount(#self._chatDatas, false, false)
    self._scrollView.unity_looplistview2:RefreshAllShownItem()
  end
end

function LWMomentPlayerList:OnTopPull()
end

function LWMomentPlayerList:OnBottomPull()
  if self._chatDatas then
    local count = #self._chatDatas
    local des = 0 < count and self._chatDatas[count].id or 0
    ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.MomentFollowList, des)
  end
end

return LWMomentPlayerList
