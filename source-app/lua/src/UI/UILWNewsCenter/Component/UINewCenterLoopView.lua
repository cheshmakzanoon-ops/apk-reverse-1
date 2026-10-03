local base = require("UI.UIChatNew.Component.UniversalComponent.BaseLoopView")
local UILWNewCenterLoopView = BaseClass("SelectMemberList", base)
local UINewsPersonalBattle = require("UI.UILWNewsCenter.Component.UILWNewsPersonalBattle")
local UINewsAllianceBattle = require("UI.UILWNewsCenter.Component.UILWNewsAllianceBattle")
local UINewsOccupyCity = require("UI.UILWNewsCenter.Component.UILWNewsOccupyCity")
local UINewsAppointOffical = require("UI.UILWNewsCenter.Component.UILWNewsAppointOffical")
local UINewsTrainRob = require("UI.UILWNewsCenter.Component.UILWNewsTrainRob")
local UINewsArenaChampion = require("UI.UILWNewsCenter.Component.UILWNewsArenaChampion")
local UILWNewsLayout = require("UI.UILWNewsCenter.Component.UILWNewsLayout")
local config = {
  [NewsSubType.PERSONAL_BATTLE] = {
    class = UINewsPersonalBattle,
    uiName = "LWNewsPersonalBattle"
  },
  [NewsSubType.ALLIANCE_BATTLE] = {
    class = UINewsAllianceBattle,
    uiName = "LWNewsAllianceBattle"
  },
  [NewsSubType.ALLIANCE_ATK_ALLIANCE_CITY] = {
    class = UINewsOccupyCity,
    uiName = "LWNewsOccupyCity"
  },
  [NewsSubType.APPOINT_OFFICAL] = {
    class = UINewsAppointOffical,
    uiName = "LWNewsAppointOffical"
  },
  [NewsSubType.TRAIN_ROB] = {
    class = UINewsTrainRob,
    uiName = "LWNewsTrainRob"
  },
  [NewsSubType.ARENA_CHAMPION] = {
    class = UINewsArenaChampion,
    uiName = "LWNewsArenaChampion"
  },
  [NewsSubType.NEWS_DETAILS] = {
    class = UILWNewsLayout,
    uiName = "LWNewDetailLayout"
  }
}

function UILWNewCenterLoopView:GetChatItemScriptName(index)
  return config[self._chatDatas[index].smallType].class
end

function UILWNewCenterLoopView:GetItemPrefabName(index)
  return config[self._chatDatas[index].smallType].uiName
end

function UILWNewCenterLoopView:SetChatItemSizeDelta(item)
  if item.CachedRectTransform.sizeDelta.x == self._scrollView:GetViewPortWidth() - 20 then
    return
  end
  self.chatItemSizeDelta = self.chatItemSizeDelta or Vector2.zero
  self.chatItemSizeDelta.x = self._scrollView:GetViewPortWidth() - 20
  self.chatItemSizeDelta.y = item.CachedRectTransform.sizeDelta.y
  item.CachedRectTransform.sizeDelta = self.chatItemSizeDelta
end

function UILWNewCenterLoopView:OnDestroy()
  base.OnDestroy(self)
end

function UILWNewCenterLoopView:RefreshViewList()
end

function UILWNewCenterLoopView:RefreshList(dataList, tabType)
  self._chatDatas = dataList
  self.tabType = tabType
  self:RefreshScrollView()
end

function UILWNewCenterLoopView:RefreshScrollView()
  self._scrollView:SetListItemCount(#self._chatDatas, false, false)
  self._scrollView:RefreshAllShownItem()
end

function UILWNewCenterLoopView:OnNewsUpdate()
end

function UILWNewCenterLoopView:OnTopPull()
end

function UILWNewCenterLoopView:OnBottomPull()
  DataCenter.LWNewsCenterManager:GetServerNews(self.tabType)
end

return UILWNewCenterLoopView
