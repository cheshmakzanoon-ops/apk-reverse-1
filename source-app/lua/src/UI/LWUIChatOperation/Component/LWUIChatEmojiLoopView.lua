local base = require("UI.UIChatNew.Component.UniversalComponent.BaseLoopView")
local LWUIChatEmojiLoopView = BaseClass("LWUIChatEmojiLoopView", base)
local LWUIChatOperationItem = require("UI.LWUIChatOperation.Component.LWUIChatOperationItem")
local LWUIChatEmojiItem = require("UI.LWUIChatOperation.Component.LWUIChatEmojiItem")

function LWUIChatEmojiLoopView:GetChatItemScriptName(index)
  if self._chatDatas[index].count then
    return LWUIChatEmojiItem
  end
  return LWUIChatOperationItem
end

function LWUIChatEmojiLoopView:GetItemPrefabName(index)
  if self._chatDatas[index].count then
    return "LikeCountItem"
  end
  return "LWUIChatEmojiOperationItem"
end

function LWUIChatEmojiLoopView:MoveToIndex(index)
  self._scrollView:MovePanelToItemIndex(index, 0)
end

function LWUIChatEmojiLoopView:SetChatItemSizeDelta(item)
end

function LWUIChatEmojiLoopView:OnDestroy()
  base.OnDestroy(self)
end

function LWUIChatEmojiLoopView:RefreshViewList()
end

function LWUIChatEmojiLoopView:RefreshEmojiList(dataList, index)
  self:RefreshList(dataList)
end

function LWUIChatEmojiLoopView:UpdateClickBg(index)
  self.emojiIndex = index
  for i, item in pairs(self._chatItemObjList) do
    if item.SetClickBg then
      item:SetClickBg(self.emojiIndex)
    end
  end
end

function LWUIChatEmojiLoopView:RefreshList(dataList)
  self._chatDatas = dataList
  self:RefreshScrollView()
end

function LWUIChatEmojiLoopView:RefreshScrollView()
  local count = self._chatDatas and #self._chatDatas or 0
  self._scrollView:SetListItemCount(count, false, false)
  self._scrollView:RefreshAllShownItem()
end

function LWUIChatEmojiLoopView:OnNewsUpdate()
end

function LWUIChatEmojiLoopView:OnTopPull()
end

function LWUIChatEmojiLoopView:OnBottomPull()
end

return LWUIChatEmojiLoopView
