local base = UIBaseContainer
local LWNewbieArenaV2Rank = BaseClass("LWNewbieArenaV2Rank", base)
local Localization = CS.GameEntry.Localization
local Notifier = require("Common.Notifier")
local UIWinner = require("UI.LWPVPArena.Main.Component.NewbieArenaV2.LWNewbieArenaV2Winner")
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
      Notifier.Dispatch("LWNewbieArenaV2PageArea.ShowRewards")
    end
  },
  {
    path = "btnShop",
    name = "btnRewards",
    type = UIButton,
    onClick = function(self)
      Notifier.Dispatch("LWNewbieArenaV2PageArea.GotoShop")
    end
  },
  {
    path = "btnRecords",
    name = "btnRewards",
    type = UIButton,
    onClick = function(self)
      Notifier.Dispatch("LWNewbieArenaV2PageArea.ShowRecords")
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
      Notifier.Dispatch("LWNewbieArenaV2PageArea.EditDefenceTeam")
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
      Notifier.Dispatch("LWNewbieArenaV2PageArea.AddChallengeTimes")
    end,
    active = false
  },
  {
    path = "scrollRank",
    name = "scrollRank",
    type = UIDynamicVerticleScrollRectEx
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
    path = "ChallengeBtn",
    name = "btnChallenge",
    type = UIButton
  },
  {
    path = "ChallengeBtn/ChallengeBtnText",
    name = "txtChallenge",
    type = UIText,
    textKey = "372258"
  },
  {
    path = "txtFinishTip",
    name = "txtFinishTip",
    type = UIText,
    textKey = "170009"
  },
  {
    path = "selfRank",
    name = "selfRank",
    type = UIBaseContainer
  },
  {
    path = "selfRank/txtRank",
    name = "txtSelfRank",
    type = UIText
  },
  {
    path = "selfRank/txtName",
    name = "txtSelfName",
    type = UIText
  },
  {
    path = "selfRank/txtPower",
    name = "txtSelfPower",
    type = UIText
  },
  {
    path = "selfRank/head",
    name = "selfRankHead",
    type = UICommonHead
  },
  {
    path = "selfRank/txtLastRank",
    name = "txtSelfLastRank",
    type = UIText
  },
  {
    path = "selfRank/vfxGlow",
    name = "selfRankVfxGlow",
    type = nil,
    active = false
  },
  {
    path = "selfRank/txtRank",
    name = "selfCgRank",
    rawType = CS.UnityEngine.CanvasGroup
  },
  {
    path = "selfRank/txtLastRank",
    name = "selfCgLastRank",
    rawType = CS.UnityEngine.CanvasGroup
  },
  {
    path = "selfRank/soldier",
    name = "objSoldier",
    type = nil
  },
  {
    path = "selfRank/soldier/imgSoldierBase",
    name = "imgSoldierBase",
    type = UIImage
  },
  {
    path = "selfRank/soldier/imgSoldierBase/imgSoldier",
    name = "imgSoldier",
    type = UIImage
  },
  {
    path = "selfRank/soldier/txtSoldier",
    name = "textSoldier",
    type = UITextMeshProUGUIEx
  }
}
local UIRankItemComps = {
  [1] = require("UI.LWPVPArena.Main.Component.NewbieArenaV2.LWNewbieArenaV2RankItemPerson")
}

function LWNewbieArenaV2Rank:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWNewbieArenaV2Rank:OnDestroy()
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

function LWNewbieArenaV2Rank:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.selfRankVfxGlow:SetActive(false)
  self.txtSelfLastRank:SetActive(false)
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
  self.winnerComps = {
    self.goldWinner,
    self.silverWinner,
    self.bronzeWinner
  }
  self.btnChallenge:SetOnClick(function()
    self:OnChallengeBtnClick()
  end)
end

function LWNewbieArenaV2Rank:ComponentDestroy()
  self.rankDatas = nil
  self.rankItemMap = nil
  self:ClearCompsByBook(compBook)
end

function LWNewbieArenaV2Rank:OnAddListener()
  base.OnAddListener(self)
end

function LWNewbieArenaV2Rank:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LWNewbieArenaV2Rank:RefreshTimer(remainTime, state)
  self.txtTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  if state == ActivityArenaState.Over and remainTime == 0 then
    self.txtTime:SetText(Localization:GetString("2000409"))
  end
end

function LWNewbieArenaV2Rank:Refresh(info)
  if not info or not info.rankInfo then
    return
  end
  self.txtTitle:SetLocalText(LocalController:instance():getValue(TableName.Activity, info.id, "name"))
  self.goldWinner:SetActive(false)
  self.silverWinner:SetActive(false)
  self.bronzeWinner:SetActive(false)
  self.rankDatas = {}
  self.prefabIdxs = {}
  local dataList = info.rankInfo.dataList or {}
  for i = 1, 3 do
    local rankData = dataList[i]
    if rankData then
      local winner = self.winnerComps[i]
      winner:SetActive(true)
      winner:Refresh(rankData)
    end
  end
  local firstCanChallengeRank, myPower
  for rank = 4, #dataList do
    local rankData = dataList[rank]
    local isSelf = rank == info.rankInfo.myRank
    rankData.isSelf = isSelf
    rankData.canView = info.state == ActivityArenaState.Over
    rankData.canChallenge = false
    if rankData.canChallenge and not firstCanChallengeRank then
      firstCanChallengeRank = rank
    end
    if isSelf then
      myPower = rankData.formationPower
    end
    table.insert(self.rankDatas, rankData)
    table.insert(self.prefabIdxs, 0)
  end
  self.scrollRank:SetDatas(self.prefabIdxs)
  local myRank = info.rankInfo.myRank
  myPower = myPower or info.rankInfo.myFormationPower
  if myRank and 0 < tonumber(myRank) then
    local locateRank = tonumber(myRank)
    if locateRank <= #dataList and 3 < locateRank then
      locateRank = math.max(1, locateRank - 5)
      local scrollOffset = self.scrollRank:GetScrollOffsetOfDataIdx(locateRank - 1)
      self.scrollRank:SetScrollOffset(scrollOffset)
    end
  end
  self.scrollRank:SetActive(info.rankInfo)
  local fighting = info.state == ActivityArenaState.Fight
  self.btnDefence:SetActive(fighting)
  self.btnChallenge:SetActive(fighting)
  self.txtFinishTip:SetActive(not fighting)
  self:RefreshChallengeTimes(info)
  self:RefreshRecordsRedDot(info.defLoseTimes)
  self:RefreshRewardsRedDot(info.hasAchieveReward)
  local uid = LuaEntry.Player:GetUid()
  local pic = LuaEntry.Player:GetPic()
  local picVer = LuaEntry.Player.picVer
  local headSkinPath = LuaEntry.Player:GetHeadBgImg()
  self.selfRankHead:SetData(uid, pic, picVer, nil, headSkinPath)
  if myPower and 0 < myPower then
    self.txtSelfPower:SetText(string.GetFormattedStr(math.floor(myPower)))
  else
    local playerPower = LuaEntry.Player.power
    self.txtSelfPower:SetText(string.GetFormattedStr(math.floor(playerPower)))
  end
  local nameStr = ""
  local name = LuaEntry.Player:GetName()
  local alAbbr = ""
  local allianceBaseInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if allianceBaseInfo ~= nil and allianceBaseInfo.abbr then
    alAbbr = allianceBaseInfo.abbr
  end
  if not string.IsNullOrEmpty(alAbbr) then
    nameStr = nameStr .. " [" .. alAbbr .. "]"
  end
  nameStr = nameStr .. " " .. name
  self.txtSelfName:SetText(nameStr)
  if myRank and 0 < tonumber(myRank) then
    self.txtSelfRank:SetText(myRank)
  else
    self.txtSelfRank:SetText(Localization:GetString("new_arena_no_rank"))
  end
  if info.rankInfo.needPlayRankAnim then
    info.rankInfo.needPlayRankAnim = false
    self:PlaySelfRankAnimV2(info.rankInfo.myPreRank)
  end
  local soldierId = checknumber(info.rankInfo.myFormationSoldier)
  local showSoldier = 0 < soldierId
  if self.objSoldier then
    self.objSoldier:SetActive(showSoldier)
    if showSoldier then
      local soldierTemplate = DataCenter.SoldierDataManager:GetTemplate(soldierId)
      if soldierTemplate ~= nil then
        self.imgSoldierBase:LoadSprite(UIUtil.GetItemQualityBg(soldierTemplate.quality))
        local soldierIcon = string.format(LoadPath.ItemPath, soldierTemplate.icon)
        self.imgSoldier:LoadSprite(soldierIcon)
        self.textSoldier:SetText("Lv." .. soldierTemplate.lv)
      end
    end
  end
end

function LWNewbieArenaV2Rank:RefreshChallengeTimes(info)
  if not info then
    return
  end
  self.txtRemainTimes:SetActive(info.state == ActivityArenaState.Fight)
  self.txtRemainTimes:SetText(Localization:GetString("801109", info.remainFree))
  self.btnAddTimes:SetActive(info.state == ActivityArenaState.Fight and info.remainFree == 0 and 0 < info.remainBuy)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layoutBottom.transform)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function LWNewbieArenaV2Rank:RefreshRecordsRedDot(num)
  num = num or 0
  self.dotRecords:SetActive(0 < num)
  self.txtDotRecords:SetText(num)
end

function LWNewbieArenaV2Rank:RefreshRewardsRedDot(num)
  num = num or 0
  self.dotRewards:SetActive(0 < num)
  self.txtDotRewards:SetText(num)
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
end

function LWNewbieArenaV2Rank:IsInRankSeg(rank)
  if not self.rankSegCfgs then
    self.rankSegCfgs = {}
    local tbl = LocalController:instance():getTable(TableName.LW_Newbie_Arena_V2)
    for id = 4, #tbl.data do
      local segCfg = LocalController:instance():getLine(TableName.LW_Newbie_Arena_V2, id)
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

function LWNewbieArenaV2Rank:GetDataIdxByRank(rank)
  local segCfg, idx = self:IsInRankSeg(rank)
  if not segCfg then
    return 0
  end
  return rank + idx - 1
end

function LWNewbieArenaV2Rank:PlaySelfRankAnimTop(winnerComp, preRank)
  if self.__blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
  end
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, 3)
  winnerComp.txtLastRank:SetActive(true)
  winnerComp.txtLastRank:SetText(preRank)
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

function LWNewbieArenaV2Rank:PlaySelfRankAnim(rankData, preRank)
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

function LWNewbieArenaV2Rank:PlaySelfRankAnimV2(preRank)
  if not preRank then
    return
  end
  if self.__blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
  end
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, 3)
  self.lastRankScale = 1
  self.lastRankAlpha = 1
  self.rankAlpha = 0
  self.rankScale = 4
  self.animW = 0
  self.playVfxGlow = false
  self.selfRankVfxGlow:SetActive(false)
  self.txtSelfLastRank:SetActive(true)
  if preRank <= 0 then
    self.txtSelfLastRank:SetText(Localization:GetString("new_arena_no_rank"))
  else
    self.txtSelfLastRank:SetText(preRank)
  end
  self.selfCgLastRank.alpha = 1
  self.selfCgRank.alpha = 0
  self.txtSelfRank:SetLocalScaleXYZ(self.rankScale, self.rankScale, self.rankScale)
  self.tweenSeq = DOTween.Sequence()
  self.tweenSeq:Append(DOTween.To(function()
    return self.lastRankScale
  end, function(value)
    self.lastRankScale = value
    self.txtSelfLastRank:SetLocalScaleXYZ(value, value, value)
  end, 1.5, 0.25):SetDelay(0.5):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo))
  self.tweenSeq:Append(DOTween.To(function()
    return self.lastRankAlpha
  end, function(value)
    self.lastRankAlpha = value
    self.selfCgLastRank.alpha = value
  end, 0, 0.5))
  self.tweenSeq:Append(DOTween.To(function()
    return self.animW
  end, function(value)
    self.animW = value
    self.rankAlpha = value * 10
    self.rankScale = 4 - value * 3
    self.txtSelfRank:SetLocalScaleXYZ(self.rankScale, self.rankScale, self.rankScale)
    self.selfCgRank.alpha = self.rankAlpha
  end, 1, 0.25))
  self.tweenSeq:AppendCallback(function()
    if self.__blockerHandleID then
      UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
      self.__blockerHandleID = nil
    end
    self.selfRankVfxGlow:SetActive(true)
    self.txtSelfLastRank:SetActive(false)
    self.selfCgRank.alpha = 1
    self.txtSelfRank:SetLocalScaleXYZ(1, 1, 1)
  end)
end

function LWNewbieArenaV2Rank:OnChallengeBtnClick()
  Notifier.Dispatch("LWNewbieArenaV2PageArea.BattleList")
end

return LWNewbieArenaV2Rank
