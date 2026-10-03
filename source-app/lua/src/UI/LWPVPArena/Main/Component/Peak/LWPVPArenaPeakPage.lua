local LWPVPArenaPeakPage = BaseClass("LWPVPArenaPeakPage", UIBaseContainer)
local base = UIBaseContainer
local UIWinner = require("UI.LWPVPArena.Main.Component.Peak.LWPVPArenaPeakWinner")
local UIBorderItem = require("UI.LWPVPArena.Main.Component.Peak.LWPVPArenaPeakBorderItem")
local UIRankItemPerson = require("UI.LWPVPArena.Main.Component.Peak.LWPVPArenaPeakRankItemPerson")
local UIRankItemSeg = require("UI.LWPVPArena.Main.Component.Peak.LWPVPArenaPeakRankItemSegment")
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "txtSub",
    name = "txtSub",
    type = UIText
  },
  {
    path = "txtTime",
    name = "txtTime",
    type = UIText
  },
  {
    path = "txtRemainTimes",
    name = "txtRemainTimes",
    type = UIText
  },
  {
    path = "btnInfo",
    name = "btnInfo",
    type = UIButton
  },
  {
    path = "btnRewards",
    name = "btnRewards",
    type = UIButton
  },
  {
    path = "btnRewards/txtRewards",
    name = "txtRewards",
    type = UIText
  },
  {
    path = "btnDefence",
    name = "btnDefence",
    type = UIButton
  },
  {
    path = "btnDefence/txtDefence",
    name = "txtDefence",
    type = UIText
  },
  {
    path = "btnRecords",
    name = "btnRecords",
    type = UIButton
  },
  {
    path = "btnRecords/txtRecords",
    name = "txtRecords",
    type = UIText
  },
  {
    path = "btnRecords/dotRecords",
    name = "dotRecords",
    type = UIBaseContainer
  },
  {
    path = "btnRecords/dotRecords/txtDotRecords",
    name = "txtDotRecords",
    type = UIText
  },
  {
    path = "winners/gold",
    name = "goldWinner",
    type = UIWinner
  },
  {
    path = "winners/silver",
    name = "silverWinner",
    type = UIWinner
  },
  {
    path = "winners/bronze",
    name = "bronzeWinner",
    type = UIWinner
  },
  {
    path = "imgReward",
    name = "imgReward",
    type = UIImage
  },
  {
    path = "imgReward/txtReward",
    name = "txtReward",
    type = UIText
  },
  {
    path = "scrollBorders",
    name = "scrollBorders",
    type = UIBaseContainer
  },
  {
    path = "scrollBorders/Viewport/Content/itemGold",
    name = "borderItemGold",
    type = UIBorderItem
  },
  {
    path = "scrollBorders/Viewport/Content/itemSilver",
    name = "borderItemSilver",
    type = UIBorderItem
  },
  {
    path = "scrollBorders/Viewport/Content/itemBronze",
    name = "borderItemBronze",
    type = UIBorderItem
  },
  {
    path = "scrollBorders/Viewport/Content/itemGray1",
    name = "borderItemGray1",
    type = UIBorderItem
  },
  {
    path = "scrollBorders/Viewport/Content/itemGray2",
    name = "borderItemGray2",
    type = UIBorderItem
  },
  {
    path = "scrollBorders/Viewport/Content/itemIntro",
    name = "itemIntro",
    type = UIBaseContainer
  },
  {
    path = "scrollBorders/Viewport/Content/itemIntro/txtIntroH",
    name = "txtIntroH",
    type = UIText
  },
  {
    path = "scrollBorders/Viewport/Content/itemIntro/txtIntro",
    name = "txtIntro",
    type = UIText
  },
  {
    path = "scrollBorders/Viewport/Content",
    name = "scrollContent",
    type = UIBaseContainer
  },
  {
    path = "scrollRanks",
    name = "scrollRanks",
    type = UIDynamicVerticleScrollRectEx
  }
}

function LWPVPArenaPeakPage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.timer = TimerManager:GetInstance():GetTimer(1, self.RefreshTimer, self, false, false, false)
  self.timer:Start()
  self.rankSegs = {}
  local tbl = LocalController:instance():getTable("lw_arena_rank_reward")
  for id = 4, #tbl.data do
    local data = LocalController:instance():getLine("lw_arena_rank_reward", id)
    table.insert(self.rankSegs, data)
  end
end

local function __IsInRankSeg(self, rank)
  for i, seg in ipairs(self.rankSegs) do
    if rank >= seg.rank_low and rank <= seg.rank_high then
      return seg, i
    end
  end
  return nil
end

local function __GetDataIdxByRank(self, rank)
  if rank <= 3 then
    return -1
  end
  local seg, idx = __IsInRankSeg(self, rank)
  if not seg then
    return -1
  end
  return rank - 3 + idx - 1
end

function LWPVPArenaPeakPage:OnDestroy()
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.rankDatas = nil
  self.rankItemMap = nil
  self.__waitingForMsg = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
  if self.__blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
    self.__blockerHandleID = nil
  end
end

function LWPVPArenaPeakPage:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.txtSub:SetText(Localization:GetString("801157"))
  self.txtRewards:SetText(Localization:GetString("130065"))
  self.txtRecords:SetText(Localization:GetString("390061"))
  self.txtReward:SetText(Localization:GetString("801103"))
  self.txtIntroH:SetText(Localization:GetString("801104"))
  self.txtIntro:SetText(Localization:GetString("801105"))
  self.txtDefence:SetText(Localization:GetString("372281"))
  self.btnRewards:SetOnClick(function()
    if self.__waitingForMsg then
      return
    end
    self:SetWaitingForMsg()
    SFSNetwork.SendMessage(MsgDefines.GetPVPArenaRewardPreview)
  end)
  self.btnRecords:SetOnClick(function()
    if self.__waitingForMsg then
      return
    end
    self:SetWaitingForMsg()
    SFSNetwork.SendMessage(MsgDefines.GetPVPArenaRecords)
  end)
  self.btnDefence:SetOnClick(function()
    if self.__waitingForMsg then
      return
    end
    self:SetWaitingForMsg()
    SFSNetwork.SendMessage(MsgDefines.GetPVPArenaBattlePreivew)
  end)
  self.btnInfo:SetOnClick(function()
    self.view:ShowInfo(801104, 801105)
  end)
  self.winnerComps = {
    self.goldWinner,
    self.silverWinner,
    self.bronzeWinner
  }
  self.itemIncNo = 1
  self.rankItemMap = {}
  self.scrollRanks:AddInstantiateItemListener(function(itemObj, prefabIdx)
    itemObj.name = "rankItem_" .. self.itemIncNo
    self.itemIncNo = self.itemIncNo + 1
    local rankItem
    if prefabIdx == 0 then
      rankItem = self:AddComponent(UIRankItemSeg, itemObj)
    else
      rankItem = self:AddComponent(UIRankItemPerson, itemObj)
    end
    if rankItem then
      rankItem.__prefabIdx = prefabIdx
      self.rankItemMap[itemObj] = rankItem
    end
  end)
  self.scrollRanks:AddDisplayItemListener(function(itemObj, dataIdx)
    local rankItem = self.rankItemMap[itemObj]
    if rankItem then
      if rankItem.__prefabIdx == 0 then
        local seg = self.rankDatas[dataIdx + 1]
        rankItem:Refresh(seg.rank_low, seg.rank_high)
      else
        local player = self.rankDatas[dataIdx + 1]
        rankItem:Refresh(player, 0 < player.isBattle and player.uid ~= LuaEntry.Player.uid)
      end
    end
  end)
end

function LWPVPArenaPeakPage:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function LWPVPArenaPeakPage:RefreshTimer()
  local info = DataCenter.LWPVPArenaManager.info
  local state = DataCenter.LWPVPArenaManager.state
  if not info or not state then
    return
  end
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local targetTime
  if state == PVPArenaState.NotActive then
    targetTime = info.showTime
  elseif state == PVPArenaState.NotOpen then
    targetTime = info.startTime
  elseif state == PVPArenaState.Open then
    targetTime = info.endTime
  end
  if targetTime then
    local remainTime = targetTime - serverTime
    if 0 < remainTime then
      self.hasRemainTime = true
      self.txtTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      if self.hasRemainTime then
        self.hasRemainTime = false
        self.view:CloseAllPopups()
        SFSNetwork.SendMessage(MsgDefines.GetPVPArenaInfo)
        SFSNetwork.SendMessage(MsgDefines.GetPVPArenaRankList)
      end
      self.txtTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(0))
    end
  end
end

function LWPVPArenaPeakPage:Refresh(arenaData)
  self.arenaData = arenaData
  local state = DataCenter.LWPVPArenaManager.state
  if state == PVPArenaState.NotActive then
    self:RefreshNotOpen(arenaData)
  elseif state == PVPArenaState.NotOpen then
    self:RefreshNotOpen(arenaData)
  elseif state == PVPArenaState.Open then
    self:RefreshOpen(arenaData)
  end
  self:RefreshTimer()
end

function LWPVPArenaPeakPage:RefreshNotOpen(arenaData)
  self.goldWinner:SetActive(false)
  self.silverWinner:SetActive(false)
  self.bronzeWinner:SetActive(false)
  if arenaData.players then
    for i = 1, 3 do
      local player = arenaData.players[i]
      if player then
        local winnerComp = self.winnerComps[i]
        winnerComp:SetActive(true)
        winnerComp:Refresh(player, false)
      end
    end
  end
  self.imgReward:SetActive(true)
  self.scrollBorders:SetActive(true)
  self.scrollRanks:SetActive(false)
  self.borderItemGold:Refresh(20003, 801133, 1)
  self.borderItemSilver:Refresh(20004, 801134, 2)
  self.borderItemBronze:Refresh(20005, 801135, 3)
  self.borderItemGray1:Refresh(20006, 801136, 4)
  self.borderItemGray2:Refresh(20007, 801137, 5)
  self.btnRecords:SetActive(arenaData.curRank ~= nil)
  self.btnRewards:SetActive(true)
  self.btnDefence:SetActive(false)
  self.txtRemainTimes:SetActive(false)
  self.dotRecords:SetActive(DataCenter.LWPVPArenaManager.defLoseTimes and DataCenter.LWPVPArenaManager.defLoseTimes > 0)
  self.txtDotRecords:SetText(DataCenter.LWPVPArenaManager.defLoseTimes or 0)
  TimerManager:GetInstance():GetTimer(5, function()
    if not self then
      return
    end
    if self.itemIntro then
      self.itemIntro:SetActive(false)
      self.itemIntro:SetActive(true)
    end
    if self.scrollContent and not IsNull(self.scrollContent.rectTransform) then
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.scrollContent.rectTransform)
    end
  end, self, true, true):Start()
end

function LWPVPArenaPeakPage:RefreshOpen(arenaData)
  self.goldWinner:SetActive(false)
  self.silverWinner:SetActive(false)
  self.bronzeWinner:SetActive(false)
  if arenaData.players then
    for i = 1, 3 do
      local player = arenaData.players[i]
      if player then
        local winnerComp = self.winnerComps[i]
        winnerComp:SetActive(true)
        winnerComp:Refresh(player, player.isBattle > 0 and player.uid ~= LuaEntry.Player.uid)
        if player.uid == LuaEntry.Player.uid and arenaData:IsNeedPlayRankAnim() then
          self:PlaySelfRankAnimTop(winnerComp, arenaData)
        end
      end
    end
    self.rankDatas = {}
    local prefabIdxs = {}
    for i = 4, #arenaData.players do
      local seg = __IsInRankSeg(self, i)
      if not seg then
        break
      end
      if seg.rank_low == i then
        table.insert(self.rankDatas, seg)
        table.insert(prefabIdxs, 0)
      end
      table.insert(self.rankDatas, arenaData.players[i])
      table.insert(prefabIdxs, arenaData.players[i].uid == LuaEntry.Player.uid and 2 or 1)
      if prefabIdxs[#prefabIdxs] == 2 and arenaData:IsNeedPlayRankAnim() then
        self:PlaySelfRankAnim(self.rankDatas[#self.rankDatas], arenaData)
      end
    end
    for _, rankItem in pairs(self.rankItemMap) do
      if rankItem then
        rankItem.data = nil
      end
    end
    self.scrollRanks:SetDatas(prefabIdxs)
  end
  local selfDataIdx = arenaData.selfRank and __GetDataIdxByRank(self, arenaData.selfRank) or 1
  local scrollOffset = self.scrollRanks:GetScrollOffsetOfDataIdx(selfDataIdx - 1)
  self.scrollRanks:SetScrollOffset(scrollOffset)
  self.imgReward:SetActive(false)
  self.scrollBorders:SetActive(false)
  self.scrollRanks:SetActive(true)
  self.btnRecords:SetActive(arenaData.selfRank ~= nil)
  self.btnRewards:SetActive(true)
  self.btnDefence:SetActive(arenaData.selfRank ~= nil)
  self.txtRemainTimes:SetActive(true)
  if arenaData.selfRank then
    self.txtRemainTimes:SetText(Localization:GetString("801109", DataCenter.LWPVPArenaManager.battleTimes))
  else
    self.txtRemainTimes:SetText(Localization:GetString("801112", 200))
  end
  self:RefreshRecordsRedDot(DataCenter.LWPVPArenaManager.defLoseTimes)
  local server_str = ""
  for i, serverId in ipairs(arenaData.server_arr) do
    server_str = server_str .. "#" .. serverId
    if i < #arenaData.server_arr then
      server_str = server_str .. " "
    end
  end
  self.txtSub:SetText(Localization:GetString("801152", server_str))
end

function LWPVPArenaPeakPage:PlaySelfRankAnim(playerData, arenaData)
  if self.__blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
  end
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, 3)
  playerData.lastRank = arenaData.lastSelfRank
  playerData.lastRankScale = 1
  playerData.lastRankAlpha = 1
  playerData.rankAlpha = 0
  playerData.rankScale = 4
  playerData.animW = 0
  playerData.playVfxGlow = false
  self.tweenSeq = DOTween.Sequence()
  self.tweenSeq:Append(DOTween.To(function()
    return playerData.lastRankScale
  end, function(value)
    playerData.lastRankScale = value
    self.scrollRanks:UpdateItems()
  end, 1.5, 0.25):SetDelay(0.5):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo))
  self.tweenSeq:Append(DOTween.To(function()
    return playerData.lastRankAlpha
  end, function(value)
    playerData.lastRankAlpha = value
    self.scrollRanks:UpdateItems()
  end, 0, 0.5))
  self.tweenSeq:Append(DOTween.To(function()
    return playerData.animW
  end, function(value)
    playerData.animW = value
    playerData.rankAlpha = value * 10
    playerData.rankScale = 4 - value * 3
    self.scrollRanks:UpdateItems()
  end, 1, 0.25))
  self.tweenSeq:AppendCallback(function()
    if self.__blockerHandleID then
      UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
      self.__blockerHandleID = nil
    end
    playerData.lastRank = nil
    playerData.lastRankAlpha = nil
    playerData.rankAlpha = nil
    playerData.rankScale = nil
    playerData.animW = nil
    playerData.playVfxGlow = true
    self.scrollRanks:UpdateItems()
  end)
end

function LWPVPArenaPeakPage:PlaySelfRankAnimTop(winnerComp, arenaData)
  if self.__blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
  end
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, 3)
  winnerComp.txtLastRank:SetActive(true)
  winnerComp.txtLastRank:SetText(arenaData.lastSelfRank)
  winnerComp.txtLastRank:SetLocalScaleXYZ(1, 1, 1)
  winnerComp.lastRankCanvasGroup.alpha = 1
  winnerComp.rankCanvasGroup.alpha = 0
  winnerComp.txtRank:SetLocalScaleXYZ(4, 4, 4)
  winnerComp.animW = 0
  self.tweenSeq = DOTween.Sequence()
  self.tweenSeq:Append(winnerComp.txtLastRank.transform:DOScale(Vector3.New(1.5, 1.5, 1.5), 0.25):SetDelay(0.5):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo))
  self.tweenSeq:Append(DOTween.To(function()
    return winnerComp.lastRankCanvasGroup.alpha
  end, function(value)
    winnerComp.lastRankCanvasGroup.alpha = value
    self.scrollRanks:UpdateItems()
  end, 0, 0.5))
  self.tweenSeq:Append(DOTween.To(function()
    return winnerComp.animW
  end, function(value)
    winnerComp.animW = value
    winnerComp.rankCanvasGroup.alpha = value * 10
    local scale = 4 - value * 3
    winnerComp.txtRank:SetLocalScaleXYZ(scale, scale, scale)
  end, 1, 0.25))
  self.tweenSeq:AppendCallback(function()
    if self.__blockerHandleID then
      UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
      self.__blockerHandleID = nil
    end
    winnerComp.vfxGlow:SetActive(false)
    winnerComp.vfxGlow:SetActive(true)
  end)
end

function LWPVPArenaPeakPage:RefreshRecordsRedDot(num)
  num = num or 0
  self.dotRecords:SetActive(0 < num)
  self.txtDotRecords:SetText(num)
end

function LWPVPArenaPeakPage:OnGetRankList(data)
  self:Refresh(DataCenter.LWPVPArenaManager.rankData)
  if self.view.peakArenaRecordsPanel then
    self.view.peakArenaRecordsPanel:RefreshChallengeTimes(DataCenter.LWPVPArenaManager.battleTimes, DataCenter.LWPVPArenaManager.max_limit)
  end
  self:UnsetWaitingForMsg()
end

function LWPVPArenaPeakPage:OnGetBattlePreview(data)
  self:UnsetWaitingForMsg()
  if not data.otherInfo then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVPFormation, {anim = true}, EnterHeroSquadPanelWay.PVPArenaDefence, data.ownerInfo)
  else
    local param = {}
    param.type = PVEType.FakePVP
    param.enterType = PVEEnterType.PVPArena
    param.levelId = -1
    param.sceneId = 51
    param.extraData = {}
    param.extraData.ownerInfo = data.ownerInfo
    param.extraData.otherInfo = data.otherInfo
    DataCenter.LWBattleManager:Enter(param)
  end
end

function LWPVPArenaPeakPage:OnGetRecords(data)
  self:UnsetWaitingForMsg()
  DataCenter.LWPVPArenaManager:SetDefLoseTimes(0)
  self.view:OnGetArenaRecords(data)
  self:RefreshRecordsRedDot(DataCenter.LWPVPArenaManager.defLoseTimes)
end

function LWPVPArenaPeakPage:OnGetRewardPreview(data)
  self:UnsetWaitingForMsg()
  self.view:OnGetArenaRewardPreview(data)
end

function LWPVPArenaPeakPage:OnGetMessageError()
  self:UnsetWaitingForMsg()
end

function LWPVPArenaPeakPage:OnArenaRankChange()
  SFSNetwork.SendMessage(MsgDefines.GetPVPArenaRankList)
end

function LWPVPArenaPeakPage:OnArenaInfoUpdate()
  local state = DataCenter.LWPVPArenaManager.state
  if state == PVPArenaState.Open then
    if DataCenter.LWPVPArenaManager.selfRank then
      self.txtRemainTimes:SetText(Localization:GetString("801109", DataCenter.LWPVPArenaManager.battleTimes))
    else
      self.txtRemainTimes:SetText(Localization:GetString("801112", 100))
    end
  end
  if self.view.peakArenaRecordsPanel then
    self.view.peakArenaRecordsPanel:RefreshChallengeTimes(DataCenter.LWPVPArenaManager.battleTimes, DataCenter.LWPVPArenaManager.max_limit)
  end
end

function LWPVPArenaPeakPage:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PeakArenaGetRankList, self.OnGetRankList)
  self:AddUIListener(EventId.PeakArenaGetBattlePreview, self.OnGetBattlePreview)
  self:AddUIListener(EventId.PeakArenaGetRecords, self.OnGetRecords)
  self:AddUIListener(EventId.PeakArenaGetRewardPreview, self.OnGetRewardPreview)
  self:AddUIListener(EventId.PeakArenaGetMessageError, self.OnGetMessageError)
  self:AddUIListener(EventId.PVPArenaInfoUpdate, self.OnArenaInfoUpdate)
  self:AddUIListener(EventId.PeakArenaRankChange, self.OnArenaRankChange)
end

function LWPVPArenaPeakPage:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.PeakArenaGetRankList, self.OnGetRankList)
  self:RemoveUIListener(EventId.PeakArenaGetBattlePreview, self.OnGetBattlePreview)
  self:RemoveUIListener(EventId.PeakArenaGetRecords, self.OnGetRecords)
  self:RemoveUIListener(EventId.PeakArenaGetRewardPreview, self.OnGetRewardPreview)
  self:RemoveUIListener(EventId.PeakArenaGetMessageError, self.OnGetMessageError)
  self:RemoveUIListener(EventId.PVPArenaInfoUpdate, self.OnArenaInfoUpdate)
  self:RemoveUIListener(EventId.PeakArenaRankChange, self.OnArenaRankChange)
end

function LWPVPArenaPeakPage:Init(pagePara1)
  SFSNetwork.SendMessage(MsgDefines.GetPVPArenaRankList)
  self:SetWaitingForMsg()
  if DataCenter.LWPVPArenaManager.rankData then
    self:Refresh(DataCenter.LWPVPArenaManager.rankData)
  end
  local requestRecords = pagePara1
  if requestRecords then
    SFSNetwork.SendMessage(MsgDefines.GetPVPArenaRecords)
  end
end

function LWPVPArenaPeakPage:OnDisable()
  base.OnDisable(self)
  self:UnsetWaitingForMsg()
end

function LWPVPArenaPeakPage:SetWaitingForMsg()
  if not self.__waitingForMsg then
    self.__waitingForMsg = true
    if self.delayTimer then
      self.delayTimer:Stop()
      self.delayTimer = nil
    end
    self.delayTimer = TimerManager:GetInstance():GetTimer(6, function()
      self.__waitingForMsg = false
    end, self, true, true)
  end
end

function LWPVPArenaPeakPage:UnsetWaitingForMsg()
  self.__waitingForMsg = false
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

return LWPVPArenaPeakPage
