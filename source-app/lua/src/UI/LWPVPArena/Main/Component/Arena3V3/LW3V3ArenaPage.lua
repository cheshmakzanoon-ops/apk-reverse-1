local LW3V3ArenaPage = BaseClass("LW3V3ArenaPage", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local UIWinner = require("UI.LWPVPArena.Main.Component.Arena3V3.LW3v3ArenaWinner")
local UIBorderItem = require("UI.LWPVPArena.Main.Component.Peak.LWPVPArenaPeakBorderItem")
local UIRankItemPerson = require("UI.LWPVPArena.Main.Component.Arena3V3.LW3v3ArenaRankItemPerson")
local UIRankItemSeg = require("UI.LWPVPArena.Main.Component.Peak.LWPVPArenaPeakRankItemSegment")
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "txtSub",
    name = "txtSub",
    type = UIText
  },
  {
    path = "imgTime/txtTime",
    name = "txtTime",
    type = UIText
  },
  {
    path = "imgTime",
    name = "time",
    type = UIBaseContainer
  },
  {
    path = "txtRemainTimes",
    name = "txtRemainTimes",
    type = UIText
  },
  {
    path = "txtTip",
    name = "txtTip",
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
    path = "btnSkin",
    name = "btnSkin",
    type = UIButton
  },
  {
    path = "winners/gold",
    name = "goldWinner",
    type = UIWinner
  },
  {
    path = "winners/gold/like/LikeRedDot",
    name = "likeRedDot",
    type = UIImage
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
    path = "scrollRanks",
    name = "scrollRanks",
    type = UIDynamicVerticleScrollRectEx
  },
  {
    path = "btns/ChallangeBtn",
    name = "challangeBtn",
    type = UIButton
  },
  {
    path = "btns/RevengeBtn",
    name = "revengeBtn",
    type = UIButton
  },
  {
    path = "btns/RevengeBtn/RevengeBtnText",
    name = "revengeBtnText",
    type = UITextMeshProUGUIEx
  },
  {
    path = "btns/RevengeBtn/dot",
    name = "revengeDot",
    type = UIBaseContainer
  },
  {
    path = "btns/RevengeBtn/dot/txtRevengeDot",
    name = "revengeDotText",
    type = UITextMeshProUGUIEx
  },
  {
    path = "serverInfo",
    name = "serverInfo",
    type = UITextMeshProUGUIEx
  }
}

function LW3V3ArenaPage:OnCreate()
  DataCenter.LW3V3Manager:SetType(Type3v3.Arena)
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

function LW3V3ArenaPage:OnDestroy()
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.pagePara1 = nil
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

function LW3V3ArenaPage:RequestDefenceTeam(uid)
  if self.__waitingForMsg then
    return
  end
  self:SetWaitingForMsg()
  DataCenter.LW3V3ArenaManager:RequestPlayerDefenceTeam(uid)
end

function LW3V3ArenaPage:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.txtSub:SetText(Localization:GetString("500201"))
  self.txtRewards:SetText(Localization:GetString("130065"))
  self.txtRecords:SetText(Localization:GetString("390061"))
  self.txtReward:SetText(Localization:GetString("801103"))
  self.txtIntroH:SetText(Localization:GetString("801104"))
  self.txtIntro:SetText(Localization:GetString("801105"))
  self.txtDefence:SetText(Localization:GetString("372281"))
  self.btnRewards:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWPVPArenaReward)
  end)
  self.btnRecords:SetOnClick(function()
    if self.__waitingForMsg then
      return
    end
    self:SetWaitingForMsg()
    SFSNetwork.SendMessage(MsgDefines.Get3V3ArenaRecords)
  end)
  self.btnDefence:SetOnClick(function()
    self:RequestDefenceTeam()
  end)
  self.btnInfo:SetOnClick(function()
    self.view:ShowInfo(500254, 500255)
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
  self.challangeBtn:SetOnClick(function()
    if DataCenter.LW3V3ArenaManager.battleTimes and DataCenter.LW3V3ArenaManager.battleTimes <= 0 then
      return
    end
    if self.__waitingForMsg then
      return
    end
    self:SetWaitingForMsg()
    SFSNetwork.SendMessage(MsgDefines.Get3V3ArenaMatchInfo)
    UIGray.SetGray(self.challangeBtn.transform, true, false)
  end)
  self.likeRedDot:SetActive(false)
  self.btnSkin:SetOnClick(function()
    EventManager:GetInstance():Broadcast(EventId.UIDecorationMainViewOpen)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorationMain, {anim = true}, DecorationType_Main_City, 10009)
  end)
  self.revengeBtnText:SetText(Localization:GetString("arena_score_001"))
  self.revengeBtn:SetOnClick(function()
    self:OnRevengeBtnClick()
  end)
  self.revengeBtn:SetActive(false)
  self.revengeDot:SetActive(true)
  self.challangeBtn:SetActive(false)
  self.btnDefence:SetActive(false)
end

function LW3V3ArenaPage:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function LW3V3ArenaPage:RefreshTimer()
  local state = DataCenter.LW3V3ArenaManager.state
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local targetTime
  if state == PVPArenaState.NotActive then
    targetTime = DataCenter.LW3V3ArenaManager.showTime
  elseif state == PVPArenaState.NotOpen then
    targetTime = DataCenter.LW3V3ArenaManager.startTime
  elseif state == PVPArenaState.Open then
    targetTime = DataCenter.LW3V3ArenaManager.endTime
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
        SFSNetwork.SendMessage(MsgDefines.Get3V3ArenaRankList)
        self.time:SetActive(false)
      end
      self.txtTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(0))
    end
  end
end

function LW3V3ArenaPage:Refresh()
  local state = DataCenter.LW3V3ArenaManager.state
  self:RefreshState(state == PVPArenaState.Open)
  self:RefreshTimer()
end

function LW3V3ArenaPage:RefreshState(isOpen)
  self.goldWinner:SetActive(false)
  self.silverWinner:SetActive(false)
  self.bronzeWinner:SetActive(false)
  if not table.IsNullOrEmpty(DataCenter.LW3V3ArenaManager.rankings) then
    for i = 1, 3 do
      local player = DataCenter.LW3V3ArenaManager.rankings[i]
      if player then
        local winnerComp = self.winnerComps[i]
        winnerComp:SetActive(true)
        winnerComp:Refresh(player)
        if player.uid == LuaEntry.Player.uid and DataCenter.LW3V3ArenaManager:IsNeedPlayRankAnim() then
          self:PlaySelfRankAnimTop(winnerComp)
          DataCenter.LW3V3ArenaManager:ResetLastSelfRank()
        end
      end
    end
    self.rankDatas = {}
    local prefabIdxs = {}
    local dataCount = #DataCenter.LW3V3ArenaManager.rankings
    if not isOpen then
      dataCount = 10
      dataCount = math.min(dataCount, #DataCenter.LW3V3ArenaManager.rankings)
    end
    for i = 4, dataCount do
      local seg = __IsInRankSeg(self, i)
      if not seg then
        break
      end
      if seg.rank_low == i then
        table.insert(self.rankDatas, seg)
        table.insert(prefabIdxs, 0)
      end
      table.insert(self.rankDatas, DataCenter.LW3V3ArenaManager.rankings[i])
      table.insert(prefabIdxs, DataCenter.LW3V3ArenaManager.rankings[i].uid == LuaEntry.Player.uid and 2 or 1)
      if prefabIdxs[#prefabIdxs] == 2 and DataCenter.LW3V3ArenaManager:IsNeedPlayRankAnim() then
        self:PlaySelfRankAnim(self.rankDatas[#self.rankDatas])
      end
    end
    self.scrollRanks:SetDatas(prefabIdxs)
    local selfDataIdx = DataCenter.LW3V3ArenaManager.selfRank and __GetDataIdxByRank(self, DataCenter.LW3V3ArenaManager.selfRank) or 1
    local scrollOffset = self.scrollRanks:GetScrollOffsetOfDataIdx(selfDataIdx - 1)
    self.scrollRanks:SetScrollOffset(scrollOffset)
    self.scrollRanks:SetActive(true)
  else
    self.scrollRanks:SetActive(false)
  end
  self.imgReward:SetActive(false)
  self.scrollBorders:SetActive(false)
  local canChallange = DataCenter.LW3V3ArenaManager.selfRank ~= nil and 0 < DataCenter.LW3V3ArenaManager.selfRank
  self.btnRecords:SetActive(canChallange)
  if isOpen then
    local canChallange = DataCenter.LW3V3ArenaManager.selfRank ~= nil and 0 < DataCenter.LW3V3ArenaManager.selfRank
    self.challangeBtn:SetActive(canChallange)
    self:RefreshChallengeBtn()
    self.btnDefence:SetActive(canChallange)
    if DataCenter.LW3V3ArenaManager.selfRank and 0 < DataCenter.LW3V3ArenaManager.selfRank then
      self.txtRemainTimes:SetActive(true)
      self.txtTip:SetActive(false)
      self.txtRemainTimes:SetText(Localization:GetString("801109", DataCenter.LW3V3ArenaManager.battleTimes))
    else
      self.txtRemainTimes:SetActive(false)
      self.txtTip:SetActive(true)
      self.txtTip:SetText(Localization:GetString("801112", 200))
    end
    self:RefreshRecordsRedDot(DataCenter.LW3V3ArenaManager.defLoseTimes)
    self.time:SetActive(true)
    self.likeRedDot:SetActive(0 < DataCenter.LW3V3ArenaManager.remainPraise)
    self:RefreshRevengeBtn()
  else
    self.challangeBtn:SetActive(false)
    self.btnDefence:SetActive(false)
    self.txtRemainTimes:SetActive(false)
    if self.hideTimer then
      self.hideTimer:Stop()
    end
    self.hideTimer = TimerManager:GetInstance():GetTimer(5, function()
      if not self.itemIntro then
        return
      end
      self.itemIntro:SetActive(false)
      self.itemIntro:SetActive(true)
    end, self, true, true):Start()
    self.dotRecords:SetActive(false)
    self.time:SetActive(false)
    self.likeRedDot:SetActive(false)
    self.revengeBtn:SetActive(false)
    self.txtTip:SetActive(true)
    local inRank = DataCenter.LW3V3ArenaManager.selfRank ~= nil and 0 < DataCenter.LW3V3ArenaManager.selfRank and 10 >= DataCenter.LW3V3ArenaManager.selfRank
    if inRank then
      self.txtTip:SetText(Localization:GetString("arena_score_009"))
    else
      self.txtTip:SetText(Localization:GetString("arena_score_010"))
    end
  end
  self.btnRewards:SetActive(true)
  local historyServers = DataCenter.LW3V3ArenaManager.historyServers
  local info = ""
  if historyServers and 0 < #historyServers then
    local ret = table.concat(historyServers, " #")
    info = "#" .. ret
  end
  self.serverInfo:SetText(info)
end

function LW3V3ArenaPage:RefreshRevengeBtn()
  local revengeNum = DataCenter.LW3V3ArenaManager.revengeNum
  local canRevenge = 0 < revengeNum
  self.revengeBtn:SetActive(canRevenge)
  if canRevenge then
    self.revengeDotText:SetText(revengeNum)
  end
end

function LW3V3ArenaPage:OnRevengeNumChanged()
  if DataCenter.LW3V3ArenaManager.state == PVPArenaState.Open then
    self:RefreshRevengeBtn()
  end
end

function LW3V3ArenaPage:PlaySelfRankAnim(playerData)
  if self.__blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
  end
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, 3)
  playerData.lastRank = DataCenter.LW3V3ArenaManager.lastSelfRank
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

function LW3V3ArenaPage:PlaySelfRankAnimTop(winnerComp)
  if self.__blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
  end
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, 3)
  winnerComp.txtLastRank:SetActive(true)
  winnerComp.txtLastRank:SetText(DataCenter.LW3V3ArenaManager.lastSelfRank)
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

function LW3V3ArenaPage:RefreshRecordsRedDot(num)
  num = num or 0
  self.dotRecords:SetActive(0 < num)
  self.txtDotRecords:SetText(num)
end

function LW3V3ArenaPage:RefreshChallengeBtn()
  if not self.challangeBtn then
    return
  end
  local battleTimes = 0
  if DataCenter.LW3V3ArenaManager.battleTimes then
    battleTimes = DataCenter.LW3V3ArenaManager.battleTimes
  end
  UIGray.SetGray(self.challangeBtn.transform, battleTimes <= 0, 0 < battleTimes)
end

function LW3V3ArenaPage:OnOpponentMatch()
  if not DataCenter.LW3V3Manager.opponentData then
    return
  end
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILW3V3Opponent) then
    local selfPlayerInfo = DataCenter.LW3V3Manager:PackSelfPlayerInfo()
    local selfScore = DataCenter.LW3V3ArenaManager:GetPlayerScore(selfPlayerInfo.uid)
    selfPlayerInfo.score = selfScore
    local rightPlayers = {}
    local players = DataCenter.LW3V3ArenaManager.rankings
    local curRank = DataCenter.LW3V3ArenaManager.selfRank
    local opponentPlayerInfo = DeepCopy(DataCenter.LW3V3Manager.opponentData.playerInfo)
    opponentPlayerInfo.score = DataCenter.LW3V3Manager.opponentData.score or 0
    local allAtkTeamPower = 0
    local allDefTeamPower = 0
    for i = 1, 3 do
      local atkTeam = DataCenter.LW3V3Manager:GetAtkTeamByIndex(i)
      local defTeam = DataCenter.LW3V3Manager:GetOpponentDefenceTeam(i)
      allAtkTeamPower = allAtkTeamPower + atkTeam:GetTotalCapacity()
      allDefTeamPower = allDefTeamPower + defTeam.power
    end
    selfPlayerInfo.formationPower = math.floor(allAtkTeamPower)
    opponentPlayerInfo.formationPower = math.floor(allDefTeamPower)
    if players and curRank then
      local minRankRange = curRank - 10
      if minRankRange < 1 then
        minRankRange = 1
      end
      local maxRankRange = curRank + 10
      if maxRankRange > #players then
        maxRankRange = #players
      end
      for i = minRankRange, maxRankRange do
        local player = players[i]
        if player and player.uid ~= LuaEntry.Player.uid then
          local playerInfo = DeepCopy(player.playerInfo)
          playerInfo.score = player.score
          table.insert(rightPlayers, playerInfo)
        end
      end
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILW3V3Opponent, {anim = false}, selfPlayerInfo, opponentPlayerInfo, rightPlayers)
  end
  self:RefreshChallengeBtn()
  self:UnsetWaitingForMsg()
end

function LW3V3ArenaPage:OnGetRankListData()
  self:Refresh()
  self:UnsetWaitingForMsg()
  if self.toOpenRevenge then
    self.toOpenRevenge = false
    if DataCenter.LW3V3ArenaManager.state == PVPArenaState.Open and DataCenter.LW3V3ArenaManager.revengeNum > 0 then
      self:OnRevengeBtnClick()
    end
  end
end

function LW3V3ArenaPage:OnGetBattlePreview(uuid)
  if uuid == LuaEntry.Player.uid then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVPFormation, {anim = true}, EnterHeroSquadPanelWay.Arena3V3Defence, 1)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWArena3V3PlayerInfo, {anim = true}, uuid)
  end
  self:UnsetWaitingForMsg()
end

function LW3V3ArenaPage:OnGetRecords(data)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWArena3V3Records, {anim = true}, data, self.pagePara1)
  self:RefreshRecordsRedDot(0)
  self:UnsetWaitingForMsg()
  self.pagePara1 = nil
end

function LW3V3ArenaPage:OnSentLike(uid)
  for i = 1, 3 do
    local winnerComp = self.winnerComps[i]
    if winnerComp.data.uid == uid then
      local player = DataCenter.LW3V3ArenaManager.rankings[i]
      if player then
        winnerComp:Refresh(player)
        winnerComp:ShowDianZanEffect()
      end
      break
    end
  end
  self.likeRedDot:SetActive(DataCenter.LW3V3ArenaManager.remainPraise > 0)
end

function LW3V3ArenaPage:OnGetArenaError()
  self:UnsetWaitingForMsg()
end

function LW3V3ArenaPage:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.Arena3V3OpponentMatch, self.OnOpponentMatch)
  self:AddUIListener(EventId.Arena3V3GetRankList, self.OnGetRankListData)
  self:AddUIListener(EventId.Arena3V3GetDenfenseTeam, self.OnGetBattlePreview)
  self:AddUIListener(EventId.Arena3V3GetRecords, self.OnGetRecords)
  self:AddUIListener(EventId.Arena3V3SendLike, self.OnSentLike)
  self:AddUIListener(EventId.Arena3V3GetMessageError, self.OnGetArenaError)
  self:AddUIListener(EventId.Arena3V3RevengeNumChanged, self.OnRevengeNumChanged)
end

function LW3V3ArenaPage:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.Arena3V3OpponentMatch, self.OnOpponentMatch)
  self:RemoveUIListener(EventId.Arena3V3GetRankList, self.OnGetRankListData)
  self:RemoveUIListener(EventId.Arena3V3GetDenfenseTeam, self.OnGetBattlePreview)
  self:RemoveUIListener(EventId.Arena3V3GetRecords, self.OnGetRecords)
  self:RemoveUIListener(EventId.Arena3V3SendLike, self.OnSentLike)
  self:RemoveUIListener(EventId.Arena3V3GetMessageError, self.OnGetArenaError)
  self:RemoveUIListener(EventId.Arena3V3RevengeNumChanged, self.OnRevengeNumChanged)
end

function LW3V3ArenaPage:OnEnable()
  base.OnEnable(self)
  self:RefreshChallengeBtn()
end

function LW3V3ArenaPage:OnDisable()
  base.OnDisable(self)
  if self.hideTimer then
    self.hideTimer:Stop()
    self.hideTimer = nil
  end
  self:UnsetWaitingForMsg()
  DataCenter.LW3V3ArenaManager:SetRedDotIgnore()
end

function LW3V3ArenaPage:Init(pagePara1)
  SFSNetwork.SendMessage(MsgDefines.Get3V3ArenaRankList)
  self:SetWaitingForMsg()
  self.toOpenRevenge = false
  if not table.IsNullOrEmpty(DataCenter.LW3V3ArenaManager.rankings) then
    self:Refresh()
  end
  self.pagePara1 = nil
  if pagePara1 then
    self.pagePara1 = pagePara1
    SFSNetwork.SendMessage(MsgDefines.Get3V3ArenaRecords)
  elseif DataCenter.LW3V3Manager:CheckIsRevenge() then
    self.toOpenRevenge = true
    DataCenter.LW3V3Manager:ClearRevenge()
  end
end

function LW3V3ArenaPage:OnRevengeBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILW3V3Revenge, {anim = false})
end

function LW3V3ArenaPage:SetWaitingForMsg()
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

function LW3V3ArenaPage:UnsetWaitingForMsg()
  self.__waitingForMsg = false
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

return LW3V3ArenaPage
