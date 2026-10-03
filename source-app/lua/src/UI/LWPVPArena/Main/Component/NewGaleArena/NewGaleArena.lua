local NewGaleArena = BaseClass("NewGaleArena", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local NewGaleArenaWinnerItem = require("UI.LWPVPArena.Main.Component.NewGaleArena.NewGaleArenaWinnerItem")
local NewPeakArenaBoxTipPanel = require("UI.LWPVPArena.Main.Component.NewPeakArena.NewPeakArenaBoxTipPanel")
local NewPeakArenaRankItem = require("UI.LWPVPArena.Main.Component.NewPeakArena.NewPeakArenaRankItem")
local showAnimIndex = 4

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.soundId = DataCenter.LWSoundManager:PlaySound(62288, false)
end

local function OnDisable(self)
  base.OnDisable(self)
  self.showAnimIndex = nil
  if self.soundId then
    DataCenter.LWSoundManager:StopSound(self.soundId)
    self.soundId = nil
  end
end

local function ComponentDefine(self)
  self.compFirst = self:AddComponent(NewGaleArenaWinnerItem, "Winner/First")
  self.compSecond = self:AddComponent(NewGaleArenaWinnerItem, "Winner/Second")
  self.compThird = self:AddComponent(NewGaleArenaWinnerItem, "Winner/Third")
  self.btnInfo = self:AddComponent(UIButton, "TopInfo/InfoBtn")
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.textTitle = self:AddComponent(UIText, "TopInfo/TitleText")
  self.timeBg = self:AddComponent(UIBaseContainer, "TopInfo/TimeBg")
  self.timeImg = self:AddComponent(UIBaseContainer, "TopInfo/TimeImg")
  self.textTime = self:AddComponent(UIText, "TopInfo/TimeBg/TimeText")
  self.btnReward = self:AddComponent(UIButton, "TopInfo/RewardBtn")
  self.btnReward:SetOnClick(function()
    self:OnBtnRewardClick()
  end)
  self.textRewardBtn = self:AddComponent(UIText, "TopInfo/RewardBtn/RewardBtnText")
  self.btnRecord = self:AddComponent(UIButton, "TopInfo/RecordBtn")
  self.btnRecord:SetOnClick(function()
    self:OnBtnRecordClick()
  end)
  self.textRecordBtn = self:AddComponent(UIText, "TopInfo/RecordBtn/RecordBtnText")
  self.btnBox = self:AddComponent(UIButton, "TopInfo/BoxBtn")
  self.btnBox:SetOnClick(function()
    self:OnBtnBoxClick()
  end)
  self.compBoxBtnRedPoint = self:AddComponent(UIBaseContainer, "TopInfo/BoxBtn/BoxBtnRedPoint")
  self.scrollRanks = self:AddComponent(UIDynamicVerticleScrollRectEx, "RankScrollView")
  self.btnDefence = self:AddComponent(UIButton, "DownInfo/DefenceBtn")
  self.btnDefence:SetOnClick(function()
    self:OnBtnDefenceClick()
  end)
  self.btnUp = self:AddComponent(UIButton, "DownInfo/UpBtn")
  self.btnUp:SetOnClick(function()
    self:OnBtnUpClick()
  end)
  self.btnChallange = self:AddComponent(UIButton, "DownInfo/ChallangeBtn")
  self.btnChallange:SetOnClick(function()
    self:OnBtnChallangeClick()
  end)
  self.textChallangeBtn = self:AddComponent(UIText, "DownInfo/ChallangeBtn/ChallangeBtnText")
  self.textAtkTime = self:AddComponent(UIText, "DownInfo/AtkTimeText")
  self.compBoxTipPanel = self:AddComponent(NewPeakArenaBoxTipPanel, "BoxTipPanel")
  self.compOwnerItem = self:AddComponent(NewPeakArenaRankItem, "DownInfo/OwnerItem")
  self.dotRecords = self:AddComponent(UIBaseContainer, "TopInfo/RecordBtn/DotRecords")
  self.txtDotRecords = self:AddComponent(UIText, "TopInfo/RecordBtn/DotRecords/DotRecordsText")
  self.txtTip = self:AddComponent(UIText, "TopInfo/TipText")
  self.winnerComps = {
    self.compFirst,
    self.compSecond,
    self.compThird
  }
  self.itemIncNo = 1
  self.rankItemMap = {}
  self.scrollRanks:AddInstantiateItemListener(function(itemObj, prefabIdx)
    itemObj.name = "rankItem_" .. self.itemIncNo
    self.itemIncNo = self.itemIncNo + 1
    local rankItem = self:AddComponent(NewPeakArenaRankItem, itemObj)
    if rankItem then
      rankItem.__prefabIdx = prefabIdx
      self.rankItemMap[itemObj] = rankItem
    end
  end)
  self.scrollRanks:AddDisplayItemListener(function(itemObj, dataIdx)
    local rankItem = self.rankItemMap[itemObj]
    if rankItem then
      local player = self.rankDatas[dataIdx + 1]
      rankItem:Refresh(player)
      if self.showAnimIndex == nil then
        self.showAnimIndex = 1
      end
      if self.showAnimIndex <= showAnimIndex then
        rankItem:SetAlpha(0)
        TimerManager:GetInstance():DelayInvoke(function()
          rankItem:PlayAnim()
        end, 0.1 + self.showAnimIndex * 0.03)
        self.showAnimIndex = self.showAnimIndex + 1
      end
    end
  end)
  self.textRewardBtn:SetLocalText("new_arena_tips_18")
  self.textRecordBtn:SetLocalText("new_arena_tips_19")
  self.textChallangeBtn:SetLocalText("new_arena_tips_23")
  self.textDefenceBtn = self:AddComponent(UIText, "DownInfo/DefenceBtn/DefenceBtnText")
  self.textUpBtn = self:AddComponent(UIText, "DownInfo/UpBtn/UpBtnText")
  self.textDefenceBtn:SetLocalText("new_arena_tips_22")
  self.textUpBtn:SetLocalText("new_arena_tips_21")
  self.compBoxTipPanel:SetActive(false)
end

local function ComponentDestroy(self)
  self.compFirst = nil
  self.compSecond = nil
  self.compThird = nil
  self.btnInfo = nil
  self.textTitle = nil
  self.textTime = nil
  self.btnReward = nil
  self.textRewardBtn = nil
  self.btnRecord = nil
  self.textRecordBtn = nil
  self.btnBox = nil
  self.compBoxBtnRedPoint = nil
  self.scrollRanks = nil
  self.btnDefence = nil
  self.btnUp = nil
  self.btnChallange = nil
  self.textChallangeBtn = nil
  self.textAtkTime = nil
  self.compBoxTipPanel = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.pagePara1 = nil
  self.__waitingForMsg = nil
  self.ownRankData = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.NewGaleArenaPraise, self.OnNewArenaPraise)
  self:AddUIListener(EventId.NewGaleArenaLogRecord, self.OnNewArenaLogRecord)
  self:AddUIListener(EventId.NewGaleArenaGetMessageError, self.OnNewPeakArenaGetMessageError)
  self:AddUIListener(EventId.NewGaleArenaReward, self.RefreshDailyBox)
  self:AddUIListener(EventId.NewGaleArenaGetBattlePreview, self.OnGetBattlePreview)
  self:AddUIListener(EventId.NewGaleArenaRefreshRedPoint, self.RefreshRecordsRedDot)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.NewGaleArenaPraise, self.OnNewArenaPraise)
  self:RemoveUIListener(EventId.NewGaleArenaLogRecord, self.OnNewArenaLogRecord)
  self:RemoveUIListener(EventId.NewGaleArenaGetMessageError, self.OnNewPeakArenaGetMessageError)
  self:RemoveUIListener(EventId.NewGaleArenaReward, self.RefreshDailyBox)
  self:RemoveUIListener(EventId.NewGaleArenaGetBattlePreview, self.OnGetBattlePreview)
  self:RemoveUIListener(EventId.NewGaleArenaRefreshRedPoint, self.RefreshRecordsRedDot)
  base.OnRemoveListener(self)
end

local function OnBtnInfoClick(self)
  self.view:ShowInfo(801104, "gale_arena_rules")
end

local function OnBtnRewardClick(self)
  local level = NewGaleArenaLevel.Advanced
  if DataCenter.NewGaleArenaManager.rankData.arenaType == 2 then
    level = NewGaleArenaLevel.Intermediate
  elseif DataCenter.NewGaleArenaManager.rankData.arenaType == 1 then
    level = NewGaleArenaLevel.Basic
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.NewPeakArenaReward, {anim = true}, level, PVPArenaType.NewGaleArena)
end

local function OnBtnRecordClick(self)
  if self.__waitingForMsg then
    return
  end
  self:SetWaitingForMsg()
  SFSNetwork.SendMessage(MsgDefines.GaleArenaLogRecord)
end

local function OnBtnBoxClick(self)
  local needGetRewardList = DataCenter.NewGaleArenaManager:GetNeedGetRewardList()
  if needGetRewardList then
    SFSNetwork.SendMessage(MsgDefines.GaleArenaReward, -1)
  else
    self.compBoxTipPanel:SetActive(true)
    self.compBoxTipPanel:Refresh(DataCenter.NewGaleArenaManager.rankData.dailyReward, DataCenter.NewGaleArenaManager.showLastSelfCount, DataCenter.NewGaleArenaManager.showSelfCount, DataCenter.NewGaleArenaManager.rankData.battleCount, PVPArenaType.NewGaleArena)
  end
end

local function OnBtnDefenceClick(self)
  if self.__waitingForMsg then
    return
  end
  self:SetWaitingForMsg()
  DataCenter.NewGaleArenaManager:SendNewArenaBattlePreView()
end

local function OnBtnUpClick(self)
  if self.__waitingForMsg then
    return
  end
  self:SetWaitingForMsg()
  self:ShowPromte()
end

local function ShowPromte(self)
  local function closeFunc()
    local startTime = DataCenter.NewGaleArenaManager.info.startTime
    
    if DataCenter.NewGaleArenaManager:GetNewPeakArenaUpStartTime() ~= startTime then
      DataCenter.NewGaleArenaManager:SaveNewPeakArenaUpStartTime(startTime)
    end
  end
  
  local showTips = "gale_arena_tips44"
  if DataCenter.NewGaleArenaManager.info.lowPromoteQualification then
    showTips = "gale_arena_tips45"
  end
  UIUtil.ShowMessage(Localization:GetString(showTips), 2, "new_arena_tips_29", "new_arena_tips_30", function()
    SFSNetwork.SendMessage(MsgDefines.GaleArenaPromote)
    closeFunc()
  end, closeFunc, closeFunc, "new_arena_tips_27")
end

local function OnBtnChallangeClick(self)
  local battleTimes = DataCenter.NewGaleArenaManager.rankData.battleTimes or 0
  if battleTimes <= 0 then
    UIUtil.ShowTipsId("801110")
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.NewPeakArenaChallenge, {anim = true}, {
      type = PVPArenaType.NewGaleArena
    })
  end
end

local function Init(self, pagePara1)
  if not table.IsNullOrEmpty(DataCenter.NewGaleArenaManager.rankData) then
    self:Refresh()
  end
  self.pagePara1 = nil
  if pagePara1 then
    self.pagePara1 = pagePara1
    SFSNetwork.SendMessage(MsgDefines.GaleArenaLogRecord)
  end
end

local function Refresh(self)
  local state = DataCenter.NewGaleArenaManager.state
  local battleTimes = DataCenter.NewGaleArenaManager.rankData.battleTimes or 0
  self.textAtkTime:SetLocalText("new_arena_tips_20", battleTimes)
  self:RefreshTipsText()
  CS.UIGray.SetGray(self.btnChallange.transform, battleTimes <= 0, true)
  self:RefreshState(state == NewPeakArenaState.Open)
  self:OnNewArenaPraise()
  self:Update1000MS()
end

local function RefreshTipsText(self)
  if DataCenter.NewGaleArenaManager.rankData.arenaType == 1 then
    self.txtTip:SetLocalText("gale_arena_tips03")
  elseif DataCenter.NewGaleArenaManager.rankData.arenaType == 2 then
    self.txtTip:SetLocalText("new_arena_tips_4")
  elseif DataCenter.NewGaleArenaManager.rankData.arenaType == 3 then
    self.txtTip:SetLocalText("new_arena_tips_3")
  else
    self.txtTip:SetLocalText("gale_arena_tips03")
  end
end

local function RefreshState(self, isOpen)
  self.compFirst:SetActive(false)
  self.compSecond:SetActive(false)
  self.compThird:SetActive(false)
  self.scrollRanks:SetActive(true)
  self.ownRankData = nil
  if not table.IsNullOrEmpty(DataCenter.NewGaleArenaManager.rankData.players) then
    local selfIsWinner = false
    for i = 1, 3 do
      local player = DataCenter.NewGaleArenaManager.rankData.players[i]
      if player then
        local winnerComp = self.winnerComps[i]
        winnerComp:SetActive(true)
        winnerComp:Refresh(player)
      end
    end
    self.rankDatas = {}
    local prefabIdxs = {}
    local dataCount = #DataCenter.NewGaleArenaManager.rankData.players
    if not isOpen then
      dataCount = 10
      dataCount = math.min(dataCount, #DataCenter.NewGaleArenaManager.rankData.players)
    end
    for i = 4, dataCount do
      table.insert(self.rankDatas, DataCenter.NewGaleArenaManager.rankData.players[i])
      table.insert(prefabIdxs, 0)
    end
    self.ownRankData = DataCenter.NewGaleArenaManager.rankData.selfInfo
    if self.ownRankData then
      if 1 <= self.ownRankData.rank and 3 >= self.ownRankData.rank then
        selfIsWinner = true
        if DataCenter.NewGaleArenaManager:IsNeedPlayRankAnim() then
          if self.winnerComps[self.ownRankData.rank] then
            self:PlaySelfRankAnimTop(self.winnerComps[self.ownRankData.rank])
          end
          DataCenter.NewGaleArenaManager:ResetLastSelfRank()
        end
      elseif DataCenter.NewGaleArenaManager:IsNeedPlayRankAnim() then
        self:PlaySelfRankAnim(self.ownRankData)
        DataCenter.NewGaleArenaManager:ResetLastSelfRank()
      end
    end
    self.scrollRanks:SetDatas(prefabIdxs)
    local selfDataIdx = selfIsWinner and 3 or DataCenter.NewGaleArenaManager.rankData.curRank
    local scrollOffset = self.scrollRanks:GetScrollOffsetOfDataIdx(selfDataIdx - 4)
    self.scrollRanks:SetScrollOffset(scrollOffset)
  else
    self.scrollRanks:SetActive(false)
  end
  if self.ownRankData then
    if DataCenter.NewGaleArenaManager:IsNeedPlayRankAnim() then
      self:PlayDownSelfRankAnim(self.ownRankData)
    end
    self.compOwnerItem:Refresh(self.ownRankData)
  end
  local historyServers = DataCenter.NewGaleArenaManager.info.historyServers
  local info = ""
  if historyServers and 0 < #historyServers then
    local ret = table.concat(historyServers, " #")
    info = "#" .. ret
  end
  self.textTitle:SetText(info)
  if isOpen then
    self.btnBox:SetActive(true)
    self:RefreshDailyBox()
  else
    self.btnBox:SetActive(false)
  end
  local promoteQualification = DataCenter.NewGaleArenaManager:NeedShowUpBtn()
  self.btnUp:SetActive(promoteQualification)
  self:RefreshRecordsRedDot()
  if promoteQualification and DataCenter.NewGaleArenaManager:GetNewPeakArenaUpStartTime() ~= DataCenter.NewGaleArenaManager.info.startTime then
    self:ShowPromte()
  end
end

local function PlayDownSelfRankAnim(self, playerData)
  if self.__blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
  end
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, 3)
  local animData = {}
  animData.lastRank = DataCenter.NewGaleArenaManager.showLastSelfRank
  animData.lastRankScale = 1
  animData.lastRankAlpha = 1
  animData.rankAlpha = 0
  animData.rankScale = 4
  animData.animW = 0
  animData.playVfxGlow = false
  playerData.animData = animData
  self.tweenSeq = DOTween.Sequence()
  self.tweenSeq:Append(DOTween.To(function()
    return playerData.animData.lastRankScale
  end, function(value)
    playerData.animData.lastRankScale = value
    self.compOwnerItem:Refresh(playerData)
  end, 1.5, 0.25):SetDelay(0.5):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo))
  self.tweenSeq:Append(DOTween.To(function()
    return playerData.animData.lastRankAlpha
  end, function(value)
    playerData.animData.lastRankAlpha = value
    self.compOwnerItem:Refresh(playerData)
  end, 0, 0.5))
  self.tweenSeq:Append(DOTween.To(function()
    return playerData.animData.animW
  end, function(value)
    playerData.animData.animW = value
    playerData.animData.rankAlpha = value * 10
    playerData.animData.rankScale = 4 - value * 3
    self.compOwnerItem:Refresh(playerData)
  end, 1, 0.25))
  self.tweenSeq:AppendCallback(function()
    if self.__blockerHandleID then
      UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
      self.__blockerHandleID = nil
    end
    playerData.animData.playVfxGlow = true
    self.compOwnerItem:Refresh(playerData)
    playerData.animData = nil
  end)
end

local function PlaySelfRankAnim(self, playerData)
  if self.__blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
  end
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, 3)
  local animData = {}
  animData.lastRank = DataCenter.NewGaleArenaManager.showLastSelfRank
  animData.lastRankScale = 1
  animData.lastRankAlpha = 1
  animData.rankAlpha = 0
  animData.rankScale = 4
  animData.animW = 0
  animData.playVfxGlow = false
  playerData.animData = animData
  self.ownTweenSeq = DOTween.Sequence()
  self.ownTweenSeq:Append(DOTween.To(function()
    return playerData.animData.lastRankScale
  end, function(value)
    playerData.animData.lastRankScale = value
    self.scrollRanks:UpdateItems()
  end, 1.5, 0.25):SetDelay(0.5):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo))
  self.ownTweenSeq:Append(DOTween.To(function()
    return playerData.animData.lastRankAlpha
  end, function(value)
    playerData.animData.lastRankAlpha = value
    self.scrollRanks:UpdateItems()
  end, 0, 0.5))
  self.ownTweenSeq:Append(DOTween.To(function()
    return playerData.animData.animW
  end, function(value)
    playerData.animData.animW = value
    playerData.animData.rankAlpha = value * 10
    playerData.animData.rankScale = 4 - value * 3
    self.scrollRanks:UpdateItems()
  end, 1, 0.25))
  self.ownTweenSeq:AppendCallback(function()
    if self.__blockerHandleID then
      UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
      self.__blockerHandleID = nil
    end
    playerData.animData.playVfxGlow = true
    self.compOwnerItem:Refresh(playerData)
    playerData.animData = nil
  end)
end

local function PlaySelfRankAnimTop(self, winnerComp)
  self.scrollRanks:UpdateItems()
end

local function Update1000MS(self)
  local info = DataCenter.NewGaleArenaManager.info
  local state = DataCenter.NewGaleArenaManager.state
  if not info or not state then
    return
  end
  local serverTime = UITimeManager:GetInstance():GetServerTime()
  local targetTime
  if state == NewPeakArenaState.FirstPreview then
    targetTime = info.startTime
  elseif state == NewPeakArenaState.Preview then
    targetTime = info.startTime
  elseif state == NewPeakArenaState.Open then
    targetTime = info.endTime
  end
  if targetTime then
    self.timeBg:SetActive(true)
    self.timeImg:SetActive(true)
    local remainTime = targetTime - serverTime
    if 0 < remainTime then
      self.hasRemainTime = true
      self.textTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      if self.hasRemainTime then
        self.hasRemainTime = false
        self.view:CloseAllPopups()
        SFSNetwork.SendMessage(MsgDefines.GetPVPArenaInfo)
      end
      self.textTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(0))
    end
  else
    self.timeBg:SetActive(false)
    self.timeImg:SetActive(false)
  end
end

local function OnNewArenaPraise(self, uid)
  for i = 1, 3 do
    local winnerComp = self.winnerComps[i]
    if winnerComp.data and winnerComp.data.uid == uid then
      local player = DataCenter.NewGaleArenaManager.rankData.players[i]
      if player then
        winnerComp:Refresh(player)
        winnerComp:ShowDianZanEffect()
      end
      break
    end
  end
  self.compFirst.compLikeRedDot:SetActive(DataCenter.NewGaleArenaManager:HavePraiseNum())
end

local function SetWaitingForMsg(self)
  if not self.__waitingForMsg then
    self.__waitingForMsg = true
    if self.delayTimer then
      self.delayTimer:Stop()
      self.delayTimer = nil
    end
    self.delayTimer = TimerManager:GetInstance():GetTimer(6, function()
      self.__waitingForMsg = false
    end, self, true, true)
    self.delayTimer:Start()
  end
end

local function UnsetWaitingForMsg(self)
  self.__waitingForMsg = false
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

local function OnNewPeakArenaGetMessageError(self)
  self:UnsetWaitingForMsg()
end

local function CloseAllPopups(self)
end

local function OnNewArenaLogRecord(self, msg)
  self:UnsetWaitingForMsg()
  UIManager:GetInstance():OpenWindow(UIWindowNames.NewPeakArenaRecord, {anim = true}, msg, self.pagePara1, PVPArenaType.NewGaleArena)
  self.pagePara1 = nil
end

local function OnGetBattlePreview(self, data)
  if UIManager:GetInstance():GetWindow(UIWindowNames.NewPeakArenaChallenge) then
    return
  end
  self:UnsetWaitingForMsg()
  if not data.otherInfo then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVPFormation, {anim = true}, EnterHeroSquadPanelWay.NewGaleArenaDefence, data.ownerInfo)
  end
end

local function OnGetKOFBattlePreview(self, data)
  if UIManager:GetInstance():GetWindow(UIWindowNames.NewPeakArenaChallenge) then
    return
  end
  self:UnsetWaitingForMsg()
  if data and not data.otherInfo then
    DataCenter.LWKOFBattleManager:SetType(TypeKOF.NewGaleArena)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVPFormation, {anim = true}, EnterHeroSquadPanelWay.KOFDefence, 1)
  end
end

local function RefreshDailyBox(self)
  local dailyReward = DataCenter.NewGaleArenaManager.rankData.dailyReward
  local battleCount = DataCenter.NewGaleArenaManager.rankData.battleCount
  self.compBoxBtnRedPoint:SetActive(false)
  local maxUnRewarded
  for i = #dailyReward, 1, -1 do
    if battleCount >= dailyReward[i].needCount and dailyReward[i].rewarded == 0 then
      maxUnRewarded = i
      break
    end
  end
  if maxUnRewarded then
    self.btnBox:LoadSprite(NewPeakArenaBoxImg[maxUnRewarded].closeImg)
    self.compBoxBtnRedPoint:SetActive(true)
  else
    self.btnBox:LoadSprite(NewPeakArenaBoxImg[#NewPeakArenaBoxImg].closeImg)
  end
  if battleCount > dailyReward[#dailyReward].needCount then
    self.compBoxTipPanel:SetActive(false)
  elseif DataCenter.NewGaleArenaManager:IsNeedShowBoxTip() or self.compBoxTipPanel:GetActive() then
    self.compBoxTipPanel:SetActive(true)
    self.compBoxTipPanel:Refresh(DataCenter.NewGaleArenaManager.rankData.dailyReward, DataCenter.NewGaleArenaManager.showLastSelfCount, DataCenter.NewGaleArenaManager.showSelfCount, DataCenter.NewGaleArenaManager.rankData.battleCount, PVPArenaType.NewGaleArena)
    DataCenter.NewGaleArenaManager:ResetLastSelfCount()
  end
end

local function RefreshRecordsRedDot(self)
  local num = DataCenter.NewGaleArenaManager.defLoseTimes or 0
  self.dotRecords:SetActive(0 < num)
  self.txtDotRecords:SetText(num)
end

NewGaleArena.OnCreate = OnCreate
NewGaleArena.OnDestroy = OnDestroy
NewGaleArena.OnEnable = OnEnable
NewGaleArena.OnDisable = OnDisable
NewGaleArena.ComponentDefine = ComponentDefine
NewGaleArena.ComponentDestroy = ComponentDestroy
NewGaleArena.DataDefine = DataDefine
NewGaleArena.DataDestroy = DataDestroy
NewGaleArena.OnAddListener = OnAddListener
NewGaleArena.OnRemoveListener = OnRemoveListener
NewGaleArena.OnBtnInfoClick = OnBtnInfoClick
NewGaleArena.OnBtnRewardClick = OnBtnRewardClick
NewGaleArena.OnBtnRecordClick = OnBtnRecordClick
NewGaleArena.OnBtnBoxClick = OnBtnBoxClick
NewGaleArena.OnBtnDefenceClick = OnBtnDefenceClick
NewGaleArena.OnBtnUpClick = OnBtnUpClick
NewGaleArena.ShowPromte = ShowPromte
NewGaleArena.OnBtnChallangeClick = OnBtnChallangeClick
NewGaleArena.Init = Init
NewGaleArena.Refresh = Refresh
NewGaleArena.RefreshState = RefreshState
NewGaleArena.PlaySelfRankAnim = PlaySelfRankAnim
NewGaleArena.PlaySelfRankAnimTop = PlaySelfRankAnimTop
NewGaleArena.PlayDownSelfRankAnim = PlayDownSelfRankAnim
NewGaleArena.OnNewArenaPraise = OnNewArenaPraise
NewGaleArena.Update1000MS = Update1000MS
NewGaleArena.SetWaitingForMsg = SetWaitingForMsg
NewGaleArena.UnsetWaitingForMsg = UnsetWaitingForMsg
NewGaleArena.OnNewPeakArenaGetMessageError = OnNewPeakArenaGetMessageError
NewGaleArena.CloseAllPopups = CloseAllPopups
NewGaleArena.OnNewArenaLogRecord = OnNewArenaLogRecord
NewGaleArena.OnGetBattlePreview = OnGetBattlePreview
NewGaleArena.OnGetKOFBattlePreview = OnGetKOFBattlePreview
NewGaleArena.RefreshDailyBox = RefreshDailyBox
NewGaleArena.RefreshRecordsRedDot = RefreshRecordsRedDot
NewGaleArena.RefreshTipsText = RefreshTipsText
return NewGaleArena
