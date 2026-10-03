local base = require("UI.UIChatNew.Component.UniversalComponent.BaseLoopView")
local LWUIChatOperationLoopView = BaseClass("LWUIChatOperationLoopView", base)
local LWUIChatOperationItem = require("UI.LWUIChatOperation.Component.LWUIChatOperationItem")
local LWUIChatEmojiUpPlayerItem = require("UI.LWUIChatOperation.Component.LWUIChatEmojiUpPlayerItem")

function LWUIChatOperationLoopView:GetChatItemScriptName(index)
  if self._chatDatas[index].uid then
    return LWUIChatEmojiUpPlayerItem
  end
  return LWUIChatOperationItem
end

function LWUIChatOperationLoopView:GetItemPrefabName(index)
  if self._chatDatas[index].uid then
    return "LWUIUserItem"
  end
  return "LWUIChatOperationItem"
end

function LWUIChatOperationLoopView:MoveToIndex(index)
  self._scrollView:MovePanelToItemIndex(index, 0)
end

function LWUIChatOperationLoopView:SetChatItemSizeDelta(item)
  if item.CachedRectTransform.sizeDelta.x == self._scrollView:GetViewPortWidth() then
    return
  end
  self.chatItemSizeDelta = self.chatItemSizeDelta or Vector2.zero
  self.chatItemSizeDelta.x = self._scrollView:GetViewPortWidth()
  self.chatItemSizeDelta.y = item.CachedRectTransform.sizeDelta.y
  item.CachedRectTransform.sizeDelta = self.chatItemSizeDelta
end

function LWUIChatOperationLoopView:OnDestroy()
  base.OnDestroy(self)
end

function LWUIChatOperationLoopView:RefreshViewList()
end

function LWUIChatOperationLoopView:RefreshEmojiList(dataList, index)
  self.emojiIndex = index
  self:RefreshList(dataList)
end

function LWUIChatOperationLoopView:RefreshList(dataList)
  self._chatDatas = dataList
  self:RefreshScrollView()
end

function LWUIChatOperationLoopView:RefreshScrollView()
  local count = self._chatDatas and #self._chatDatas or 0
  self._scrollView:SetListItemCount(count, false, false)
  self._scrollView:RefreshAllShownItem()
end

function LWUIChatOperationLoopView:OnNewsUpdate()
end

function LWUIChatOperationLoopView:OnTopPull()
end

function LWUIChatOperationLoopView:OnBottomPull()
end

return LWUIChatOperationLoopView
