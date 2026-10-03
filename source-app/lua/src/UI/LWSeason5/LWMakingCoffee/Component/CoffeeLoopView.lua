local base = require("UI.UIChatNew.Component.UniversalComponent.BaseLoopView")
local CoffeeLoopView = BaseClass("CoffeeLoopView", base)
local CoffeeLayOutItem = require("UI/LWSeason5/LWMakingCoffee/Component/CoffeeLayOutItem")

function CoffeeLoopView:GetChatItemScriptName(index)
  return CoffeeLayOutItem
end

function CoffeeLoopView:GetItemPrefabName(index)
  return "CoffeeLayoutItem"
end

function CoffeeLoopView:MoveToIndex(index)
  self._scrollView:MovePanelToItemIndex(index, 0)
end

function CoffeeLoopView:SetChatItemSizeDelta(item)
  if item.CachedRectTransform.sizeDelta.x == self._scrollView:GetViewPortWidth() then
    return
  end
  self.chatItemSizeDelta = self.chatItemSizeDelta or Vector2.zero
  self.chatItemSizeDelta.x = self._scrollView:GetViewPortWidth()
  self.chatItemSizeDelta.y = item.CachedRectTransform.sizeDelta.y
  item.CachedRectTransform.sizeDelta = self.chatItemSizeDelta
end

function CoffeeLoopView:OnDestroy()
  base.OnDestroy(self)
end

function CoffeeLoopView:RefreshViewList()
end

function CoffeeLoopView:RefreshList(dataList)
  self._chatDatas = dataList
  self:RefreshScrollView()
end

function CoffeeLoopView:ChangeCoffee(coffeeId)
  for i, item in pairs(self._chatItemObjList) do
    item:SelectItem(coffeeId)
  end
end

function CoffeeLoopView:UnlockCoffee(coffeeId)
  for i, item in pairs(self._chatItemObjList) do
    item:UnlockCoffee(coffeeId)
  end
end

function CoffeeLoopView:RefreshScrollView()
  self._scrollView:SetListItemCount(#self._chatDatas, false, false)
  self._scrollView:RefreshAllShownItem()
end

function CoffeeLoopView:OnNewsUpdate()
end

function CoffeeLoopView:OnTopPull()
end

function CoffeeLoopView:OnBottomPull()
end

return CoffeeLoopView
