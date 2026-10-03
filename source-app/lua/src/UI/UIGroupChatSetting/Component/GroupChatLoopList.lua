local base = require("UI.UIChatNew.Component.UniversalComponent.BaseLoopView")
local GroupChatLoopList = BaseClass("GroupChatLoopList", base)
local GroupChatFrame = require("UI.UIChatGroupSelectMember.Component.GroupChatFrame")

function GroupChatLoopList:GetChatItemScriptName(index)
  return GroupChatFrame
end

function GroupChatLoopList:GetItemPrefabName(index)
  return "GroupChatFrame"
end

function GroupChatLoopList:OnDestroy()
  base.OnDestroy(self)
end

function GroupChatLoopList:RefreshList(room, config)
  self.room = room
  self._chatDatas = config
  self._scrollView:StopMovement()
  self:RefreshScrollView()
end

function GroupChatLoopList:RefreshScrollView()
  self._scrollView:SetListItemCount(#self._chatDatas, false, false)
  self._scrollView:RefreshAllShownItem()
end

return GroupChatLoopList
