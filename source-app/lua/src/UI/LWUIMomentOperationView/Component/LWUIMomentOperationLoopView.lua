local base = require("UI.UIChatNew.Component.UniversalComponent.BaseLoopView")
local LWUIMomentOperationLoopView = BaseClass("LWUIMomentOperationLoopView", base)
local LWUIMomentOperationItem = require("UI.LWUIMomentOperationView.Component.LWUIMomentOperationItem")

function LWUIMomentOperationLoopView:GetChatItemScriptName(index)
  return LWUIMomentOperationItem
end

function LWUIMomentOperationLoopView:GetItemPrefabName(index)
  return "LWUIMomentOperationItem"
end

function LWUIMomentOperationLoopView:MoveToIndex(index)
  self._scrollView:MovePanelToItemIndex(index, 0)
end

function LWUIMomentOperationLoopView:SetChatItemSizeDelta(item)
  if item.CachedRectTransform.sizeDelta.x == self._scrollView:GetViewPortWidth() then
    return
  end
  self.chatItemSizeDelta = self.chatItemSizeDelta or Vector2.zero
  self.chatItemSizeDelta.x = self._scrollView:GetViewPortWidth()
  self.chatItemSizeDelta.y = item.CachedRectTransform.sizeDelta.y
  item.CachedRectTransform.sizeDelta = self.chatItemSizeDelta
end

function LWUIMomentOperationLoopView:OnDestroy()
  base.OnDestroy(self)
end

function LWUIMomentOperationLoopView:RefreshViewList()
end

function LWUIMomentOperationLoopView:RefreshList(dataList)
  self._chatDatas = dataList
  self:RefreshScrollView()
end

function LWUIMomentOperationLoopView:RefreshScrollView()
  local count = self._chatDatas and #self._chatDatas or 0
  self._scrollView:SetListItemCount(count, false, false)
  self._scrollView:RefreshAllShownItem()
end

function LWUIMomentOperationLoopView:OnNewsUpdate()
end

function LWUIMomentOperationLoopView:OnTopPull()
end

function LWUIMomentOperationLoopView:OnBottomPull()
end

return LWUIMomentOperationLoopView
