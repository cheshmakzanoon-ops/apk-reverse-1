local base = UIBaseContainer
local UIArenaNewbieAreaRank = BaseClass("UIArenaNewbieAreaRank", base)
local Localization = CS.GameEntry.Localization
local Notifier = require("Common.Notifier")
local compBook = {
  {
    path = "txtTitle",
    name = "txtTitle",
    type = UIText,
    text = ""
  },
  {
    path = "txtTime",
    name = "txtTime",
    type = UIText,
    text = ""
  },
  {
    path = "btnRewards",
    name = "btnRules",
    type = UIButton,
    onClick = function(self)
      Notifier.Dispatch("UIArenaNewbieArea.ShowRewards")
    end
  },
  {
    path = "btnShop",
    name = "btnRewards",
    type = UIButton,
    onClick = function(self)
      Notifier.Dispatch("UIArenaNewbieArea.GotoShop")
    end
  },
  {
    path = "btnRecords",
    name = "btnRewards",
    type = UIButton,
    onClick = function(self)
      Notifier.Dispatch("UIArenaNewbieArea.ShowRecords")
    end
  },
  {
    path = "btnRewards/txtRewards",
    name = "txtRewards",
    type = UIText,
    textKey = "130065"
  },
  {
    path = "btnRewards/dotRewards",
    name = "dotRewards",
    type = nil,
    active = false
  },
  {
    path = "btnRewards/dotRewards/txtDotRewards",
    name = "txtDotRewards",
    type = UIText,
    text = ""
  },
  {
    path = "btnShop/txtShop",
    name = "txtShop",
    type = UIText,
    textKey = "104241"
  },
  {
    path = "btnRecords/txtRecords",
    name = "txtRecords",
    type = UIText,
    textKey = "390061"
  },
  {
    path = "btnRecords/dotRecords",
    name = "dotRecords",
    type = nil,
    active = false
  },
  {
    path = "btnRecords/dotRecords/txtDotRecords",
    name = "txtDotRecords",
    type = UIText,
    text = ""
  },
  {
    path = "btnDefence",
    name = "btnDefence",
    type = UIButton,
    onClick = function(self)
      Notifier.Dispatch("UIArenaNewbieArea.EditDefenceTeam")
    end
  },
  {
    path = "btnDefence/txtDefence",
    name = "txtDefence",
    type = UIText,
    textKey = "372281"
  },
  {
    path = "layoutBottom",
    name = "layoutBottom",
    type = nil
  },
  {
    path = "layoutBottom/txtRemainTimes",
    name = "txtRemainTimes",
    type = UIText,
    text = ""
  },
  {
    path = "layoutBottom/btnAddTimes",
    name = "btnAddTimes",
    type = UIButton,
    onClick = function(self)
      Notifier.Dispatch("UIArenaNewbieArea.AddChallengeTimes")
    end,
    active = false
  },
  {
    path = "scrollRank",
    name = "scrollRank",
    type = UIDynamicVerticleScrollRectEx
  }
}
local UIRankItemComps = {
  [1] = require("UI.UIActivityCenterTable.Component.ArenaNewbie.UIArenaNewbieRankItemSegment"),
  [2] = require("UI.UIActivityCenterTable.Component.ArenaNewbie.UIArenaNewbieRankItemPerson")
}

function UIArenaNewbieAreaRank:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIArenaNewbieAreaRank:OnDestroy()
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
  if self.__blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
    self.__blockerHandleID = nil
  end
end

function UIArenaNewbieAreaRank:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.itemIncNo = 1
  self.rankItemMap = {}
  self.scrollRank:AddInstantiateItemListener(function(itemObj, prefabIdx)
    itemObj.name = "rankItem_" .. self.itemIncNo
    self.itemIncNo = self.itemIncNo + 1
    local rankItem = self:AddComponent(UIRankItemComps[prefabIdx + 1], itemObj)
    self.rankItemMap[itemObj] = rankItem
  end)
  self.scrollRank:AddDisplayItemListener(function(itemObj, dataIdx)
    local rankItem = self.rankItemMap[itemObj]
    assert(rankItem, "rankItem is nil. dataIdx:" .. dataIdx)
    local rankData = self.rankDatas[dataIdx + 1]
    assert(rankData, "rankData is nil. dataIdx:" .. dataIdx)
    rankItem:Refresh(rankData)
  end)
end

function UIArenaNewbieAreaRank:ComponentDestroy()
  self.rankDatas = nil
  self.rankItemMap = nil
  self:ClearCompsByBook(compBook)
end

function UIArenaNewbieAreaRank:OnAddListener()
  base.OnAddListener(self)
end

function UIArenaNewbieAreaRank:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIArenaNewbieAreaRank:RefreshTimer(remainTime, state)
  self.txtTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  if state == ActivityArenaState.Over and remainTime == 0 then
    self.txtTime:SetText(Localization:GetString("2000409"))
  end
end

function UIArenaNewbieAreaRank:Refresh(info)
  if not info or not info.rankInfo then
    return
  end
  self.txtTitle:SetLocalText(LocalController:instance():getValue(TableName.Activity, info.id, "name"))
  self.rankDatas = {}
  self.prefabIdxs = {}
  local dataList = info.rankInfo.dataList or {}
  local firstCanChallengeRank
  for rank = 1, #dataList do
    local segCfg = self:IsInRankSeg(rank)
    if not segCfg then
      break
    end
    if segCfg.rank_low == rank and 1 < segCfg.rank_low then
      table.insert(self.rankDatas, segCfg)
      table.insert(self.prefabIdxs, 0)
    end
    local rankData = dataList[rank]
    rankData.isSelf = rank == info.rankInfo.myRank
    rankData.canView = info.state == ActivityArenaState.Over
    rankData.canChallenge = rankData.isBattle == 1 and info.state == ActivityArenaState.Fight and tostring(rankData.playerId) ~= tostring(LuaEntry.Player.uid)
    if rankData.canChallenge and not firstCanChallengeRank then
      firstCanChallengeRank = rank
    end
    local highRankCfg = DataCenter.LWNewbieArenaManager.cfgMap_rankhigh[rank]
    rankData.chestAchieveId = not (not (highRankCfg and info.receives) or table.indexof(info.receives, highRankCfg.id)) and highRankCfg.id or nil
    table.insert(self.rankDatas, rankData)
    table.insert(self.prefabIdxs, 1)
    if rankData.isSelf and info.rankInfo.needPlayRankAnim then
      info.rankInfo.needPlayRankAnim = false
      self:PlaySelfRankAnim(rankData, info.rankInfo.myPreRank)
    end
  end
  firstCanChallengeRank = firstCanChallengeRank or 1
  self.scrollRank:SetDatas(self.prefabIdxs)
  local locateRank = 0 < info.rankInfo.myRank and info.rankInfo.myRank or firstCanChallengeRank
  local selfDataIdx = math.max(1, self:GetDataIdxByRank(locateRank) - 3) or 1
  local scrollOffset = self.scrollRank:GetScrollOffsetOfDataIdx(selfDataIdx - 1)
  self.scrollRank:SetScrollOffset(scrollOffset)
  self.scrollRank:SetActive(info.rankInfo)
  self.btnDefence:SetActive(info.state == ActivityArenaState.Fight)
  self:RefreshChallengeTimes(info)
  self:RefreshRecordsRedDot(info.defLoseTimes)
  self:RefreshRewardsRedDot(info.hasAchieveReward)
end

function UIArenaNewbieAreaRank:RefreshChallengeTimes(info)
  if not info then
    return
  end
  self.txtRemainTimes:SetActive(info.state == ActivityArenaState.Fight)
  self.txtRemainTimes:SetText(Localization:GetString("801109", info.remainFree))
  self.btnAddTimes:SetActive(info.state == ActivityArenaState.Fight and info.remainFree == 0 and 0 < info.remainBuy)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layoutBottom.transform)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function UIArenaNewbieAreaRank:RefreshRecordsRedDot(num)
  num = num or 0
  self.dotRecords:SetActive(0 < num)
  self.txtDotRecords:SetText(num)
end

function UIArenaNewbieAreaRank:RefreshRewardsRedDot(num)
  num = num or 0
  self.dotRewards:SetActive(0 < num)
  self.txtDotRewards:SetText(num)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function UIArenaNewbieAreaRank:IsInRankSeg(rank)
  if not self.rankSegCfgs then
    self.rankSegCfgs = {}
    local tbl = LocalController:instance():getTable(TableName.LW_Newbie_Arena)
    for id = 4, #tbl.data do
      local segCfg = LocalController:instance():getLine(TableName.LW_Newbie_Arena, id)
      table.insert(self.rankSegCfgs, segCfg)
    end
    table.insert(self.rankSegCfgs, 1, {rank_low = 1, rank_high = 3})
  end
  for i, segCfg in ipairs(self.rankSegCfgs) do
    if rank >= segCfg.rank_low and rank <= segCfg.rank_high then
      return segCfg, i
    end
  end
  return nil
end

function UIArenaNewbieAreaRank:GetDataIdxByRank(rank)
  local segCfg, idx = self:IsInRankSeg(rank)
  if not segCfg then
    return 0
  end
  return rank + idx - 1
end

function UIArenaNewbieAreaRank:PlaySelfRankAnim(rankData, preRank)
  if not preRank or preRank <= 0 then
    return
  end
  if self.__blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
  end
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, 3)
  rankData.lastRank = preRank
  rankData.lastRankScale = 1
  rankData.lastRankAlpha = 1
  rankData.rankAlpha = 0
  rankData.rankScale = 4
  rankData.animW = 0
  rankData.playVfxGlow = false
  self.tweenSeq = DOTween.Sequence()
  self.tweenSeq:Append(DOTween.To(function()
    return rankData.lastRankScale
  end, function(value)
    rankData.lastRankScale = value
    self.scrollRank:UpdateItems()
  end, 1.5, 0.25):SetDelay(0.5):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo))
  self.tweenSeq:Append(DOTween.To(function()
    return rankData.lastRankAlpha
  end, function(value)
    rankData.lastRankAlpha = value
    self.scrollRank:UpdateItems()
  end, 0, 0.5))
  self.tweenSeq:Append(DOTween.To(function()
    return rankData.animW
  end, function(value)
    rankData.animW = value
    rankData.rankAlpha = value * 10
    rankData.rankScale = 4 - value * 3
    self.scrollRank:UpdateItems()
  end, 1, 0.25))
  self.tweenSeq:AppendCallback(function()
    if self.__blockerHandleID then
      UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
      self.__blockerHandleID = nil
    end
    rankData.lastRank = nil
    rankData.lastRankAlpha = nil
    rankData.rankAlpha = nil
    rankData.rankScale = nil
    rankData.animW = nil
    rankData.playVfxGlow = true
    self.scrollRank:UpdateItems()
  end)
end

return UIArenaNewbieAreaRank
