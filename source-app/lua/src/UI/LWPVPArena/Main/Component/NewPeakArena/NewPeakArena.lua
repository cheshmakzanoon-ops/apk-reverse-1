local NewPeakArena = BaseClass("NewPeakArena", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local NewPeakArenaWinerItem = require("UI.LWPVPArena.Main.Component.NewPeakArena.NewPeakArenaWinerItem")
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
end

local function OnDisable(self)
  base.OnDisable(self)
  self.showAnimIndex = nil
end

local function ComponentDefine(self)
  self.compFirst = self:AddComponent(NewPeakArenaWinerItem, "Winner/First")
  self.compSecond = self:AddComponent(NewPeakArenaWinerItem, "Winner/Second")
  self.compThird = self:AddComponent(NewPeakArenaWinerItem, "Winner/Third")
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
  self:AddUIListener(EventId.NewArenaPraise, self.OnNewArenaPraise)
  self:AddUIListener(EventId.NewArenaPromote, self.UnsetWaitingForMsg)
  self:AddUIListener(EventId.NewArenaLogRecord, self.OnNewArenaLogRecord)
  self:AddUIListener(EventId.NewPeakArenaGetMessageError, self.OnNewPeakArenaGetMessageError)
  self:AddUIListener(EventId.NewArenaReward, self.RefreshDailyBox)
  self:AddUIListener(EventId.NewPeakArenaGetBattlePreview, self.OnGetBattlePreview)
  self:AddUIListener(EventId.NewPeakArenaRefreshRedPoint, self.RefreshRecordsRedDot)
  self:AddUIListener(EventId.NewPeakArenaGetKOFBattlePreview, self.OnGetKOFBattlePreview)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.NewArenaPraise, self.OnNewArenaPraise)
  self:RemoveUIListener(EventId.NewArenaPromote, self.UnsetWaitingForMsg)
  self:RemoveUIListener(EventId.NewArenaLogRecord, self.OnNewArenaLogRecord)
  self:RemoveUIListener(EventId.NewPeakArenaGetMessageError, self.OnNewPeakArenaGetMessageError)
  self:RemoveUIListener(EventId.NewArenaReward, self.RefreshDailyBox)
  self:RemoveUIListener(EventId.NewPeakArenaGetBattlePreview, self.OnGetBattlePreview)
  self:RemoveUIListener(EventId.NewPeakArenaRefreshRedPoint, self.RefreshRecordsRedDot)
  self:RemoveUIListener(EventId.NewPeakArenaGetKOFBattlePreview, self.OnGetKOFBattlePreview)
  base.OnRemoveListener(self)
end

local function OnBtnInfoClick(self)
  self.view:ShowInfo(801104, "new_arena_tips_8")
end

local function OnBtnRewardClick(self)
  local level = NewPeakArenaLevel.Advanced
  if DataCenter.NewPeakArenaManager.rankData.arenaType == 1 then
    level = NewPeakArenaLevel.Intermediate
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.NewPeakArenaReward, {anim = true}, level, PVPArenaType.NewPeakArena)
end

local function OnBtnRecordClick(self)
  if self.__waitingForMsg then
    return
  end
  self:SetWaitingForMsg()
  SFSNetwork.SendMessage(MsgDefines.NewArenaLogRecord)
end

local function OnBtnBoxClick(self)
  local needGetRewardList = DataCenter.NewPeakArenaManager:GetNeedGetRewardList()
  if needGetRewardList then
    SFSNetwork.SendMessage(MsgDefines.NewArenaReward, -1)
  else
    self.compBoxTipPanel:SetActive(true)
    self.compBoxTipPanel:Refresh(DataCenter.NewPeakArenaManager.rankData.dailyReward, DataCenter.NewPeakArenaManager.showLastSelfCount, DataCenter.NewPeakArenaManager.showSelfCount, DataCenter.NewPeakArenaManager.rankData.battleCount, PVPArenaType.NewPeakArena)
  end
end

local function OnBtnDefenceClick(self)
  if self.__waitingForMsg then
    return
  end
  self:SetWaitingForMsg()
  DataCenter.NewPeakArenaManager:SendNewArenaBattlePreView()
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
    local startTime = DataCenter.NewPeakArenaManager.info.startTime
    
    if DataCenter.NewPeakArenaManager:GetNewPeakArenaUpStartTime() ~= startTime then
      DataCenter.NewPeakArenaManager:SaveNewPeakArenaUpStartTime(startTime)
    end
  end
  
  UIUtil.ShowMessage(Localization:GetString("new_arena_tips_28"), 2, "new_arena_tips_29", "new_arena_tips_30", function()
    SFSNetwork.SendMessage(MsgDefines.NewArenaPromote)
    closeFunc()
  end, closeFunc, closeFunc, "new_arena_tips_27")
end

local function OnBtnChallangeClick(self)
  local battleTimes = DataCenter.NewPeakArenaManager.rankData.battleTimes or 0
  if battleTimes <= 0 then
    UIUtil.ShowTipsId("801110")
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.NewPeakArenaChallenge, {anim = true}, {
      type = PVPArenaType.NewPeakArena
    })
  end
end

local function Init(self, pagePara1)
  if not table.IsNullOrEmpty(DataCenter.NewPeakArenaManager.rankData) then
    self:Refresh()
  end
  self.pagePara1 = nil
  if pagePara1 then
    self.pagePara1 = pagePara1
    SFSNetwork.SendMessage(MsgDefines.NewArenaLogRecord)
  end
end

local function Refresh(self)
  local state = DataCenter.NewPeakArenaManager.state
  local battleTimes = DataCenter.NewPeakArenaManager.rankData.battleTimes or 0
  self.textAtkTime:SetLocalText("new_arena_tips_20", battleTimes)
  if DataCenter.NewPeakArenaManager.rankData.arenaType == 1 then
    self.txtTip:SetLocalText("new_arena_tips_4")
  else
    self.txtTip:SetLocalText("new_arena_tips_3")
  end
  CS.UIGray.SetGray(self.btnChallange.transform, battleTimes <= 0, true)
  self:RefreshState(state == NewPeakArenaState.Open)
  self:OnNewArenaPraise()
  self:Update1000MS()
end

local function RefreshState(self, isOpen)
  self.compFirst:SetActive(false)
  self.compSecond:SetActive(false)
  self.compThird:SetActive(false)
  self.scrollRanks:SetActive(true)
  self.ownRankData = nil
  if not table.IsNullOrEmpty(DataCenter.NewPeakArenaManager.rankData.players) then
    local selfIsWinner = false
    for i = 1, 3 do
      local player = DataCenter.NewPeakArenaManager.rankData.players[i]
      if player then
        local winnerComp = self.winnerComps[i]
        winnerComp:SetActive(true)
        winnerComp:Refresh(player)
        if player.uid == LuaEntry.Player.uid then
          self.ownRankData = player
          selfIsWinner = true
          if DataCenter.NewPeakArenaManager:IsNeedPlayRankAnim() then
            self:PlaySelfRankAnimTop(winnerComp)
            DataCenter.NewPeakArenaManager:ResetLastSelfRank()
          end
        end
      end
    end
    self.rankDatas = {}
    local prefabIdxs = {}
    local dataCount = #DataCenter.NewPeakArenaManager.rankData.players
    if not isOpen then
      dataCount = 10
      dataCount = math.min(dataCount, #DataCenter.NewPeakArenaManager.rankData.players)
    end
    for i = 4, dataCount do
      table.insert(self.rankDatas, DataCenter.NewPeakArenaManager.rankData.players[i])
      table.insert(prefabIdxs, 0)
      local player = DataCenter.NewPeakArenaManager.rankData.players[i]
      if player.uid == LuaEntry.Player.uid then
        self.ownRankData = player
        if DataCenter.NewPeakArenaManager:IsNeedPlayRankAnim() then
          self:PlaySelfRankAnim(player)
          DataCenter.NewPeakArenaManager:ResetLastSelfRank()
        end
      end
    end
    self.scrollRanks:SetDatas(prefabIdxs)
    local selfDataIdx = selfIsWinner and 3 or DataCenter.NewPeakArenaManager.rankData.curRank
    local scrollOffset = self.scrollRanks:GetScrollOffsetOfDataIdx(selfDataIdx - 4)
    self.scrollRanks:SetScrollOffset(scrollOffset)
  else
    self.scrollRanks:SetActive(false)
  end
  if self.ownRankData then
    if DataCenter.NewPeakArenaManager:IsNeedPlayRankAnim() then
      self:PlayDownSelfRankAnim(self.ownRankData)
    end
    self.compOwnerItem:Refresh(self.ownRankData)
  end
  local historyServers = DataCenter.NewPeakArenaManager.info.historyServers
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
  local promoteQualification = DataCenter.NewPeakArenaManager:NeedShowUpBtn()
  self.btnUp:SetActive(promoteQualification)
  self:RefreshRecordsRedDot()
  if promoteQualification and DataCenter.NewPeakArenaManager:GetNewPeakArenaUpStartTime() ~= DataCenter.NewPeakArenaManager.info.startTime then
    self:ShowPromte()
  end
end

local function PlayDownSelfRankAnim(self, playerData)
  if self.__blockerHandleID then
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
  end
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, 3)
  local animData = {}
  animData.lastRank = DataCenter.NewPeakArenaManager.showLastSelfRank
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
    return playerData.lastRankAlpha
  end, function(value)
    playerData.animData.lastRankAlpha = value
    self.compOwnerItem:Refresh(playerData)
  end, 0, 0.5))
  self.tweenSeq:Append(DOTween.To(function()
    return playerData.animW
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
  animData.lastRank = DataCenter.NewPeakArenaManager.showLastSelfRank
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
  local info = DataCenter.NewPeakArenaManager.info
  local state = DataCenter.NewPeakArenaManager.state
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
      local player = DataCenter.NewPeakArenaManager.rankData.players[i]
      if player then
        winnerComp:Refresh(player)
        winnerComp:ShowDianZanEffect()
      end
      break
    end
  end
  self.compFirst.compLikeRedDot:SetActive(DataCenter.NewPeakArenaManager:HavePraiseNum())
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
  UIManager:GetInstance():OpenWindow(UIWindowNames.NewPeakArenaRecord, {anim = true}, msg, self.pagePara1, PVPArenaType.NewPeakArena)
  self.pagePara1 = nil
end

local function OnGetBattlePreview(self, data)
  if UIManager:GetInstance():GetWindow(UIWindowNames.NewPeakArenaChallenge) then
    return
  end
  self:UnsetWaitingForMsg()
  if not data.otherInfo then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVPFormation, {anim = true}, EnterHeroSquadPanelWay.NewPeakArenaDefence, data.ownerInfo)
  end
end

local function OnGetKOFBattlePreview(self, data)
  if UIManager:GetInstance():GetWindow(UIWindowNames.NewPeakArenaChallenge) then
    return
  end
  self:UnsetWaitingForMsg()
  if data and not data.otherInfo then
    DataCenter.LWKOFBattleManager:SetType(TypeKOF.NewPeakArena)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVPFormation, {anim = true}, EnterHeroSquadPanelWay.KOFDefence, 1)
  end
end

local function RefreshDailyBox(self)
  local dailyReward = DataCenter.NewPeakArenaManager.rankData.dailyReward
  local battleCount = DataCenter.NewPeakArenaManager.rankData.battleCount
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
  elseif DataCenter.NewPeakArenaManager:IsNeedShowBoxTip() or self.compBoxTipPanel:GetActive() then
    self.compBoxTipPanel:SetActive(true)
    self.compBoxTipPanel:Refresh(DataCenter.NewPeakArenaManager.rankData.dailyReward, DataCenter.NewPeakArenaManager.showLastSelfCount, DataCenter.NewPeakArenaManager.showSelfCount, DataCenter.NewPeakArenaManager.rankData.battleCount)
    DataCenter.NewPeakArenaManager:ResetLastSelfCount()
  end
end

local function RefreshRecordsRedDot(self)
  local num = DataCenter.NewPeakArenaManager.defLoseTimes or 0
  self.dotRecords:SetActive(0 < num)
  self.txtDotRecords:SetText(num)
end

NewPeakArena.OnCreate = OnCreate
NewPeakArena.OnDestroy = OnDestroy
NewPeakArena.OnEnable = OnEnable
NewPeakArena.OnDisable = OnDisable
NewPeakArena.ComponentDefine = ComponentDefine
NewPeakArena.ComponentDestroy = ComponentDestroy
NewPeakArena.DataDefine = DataDefine
NewPeakArena.DataDestroy = DataDestroy
NewPeakArena.OnAddListener = OnAddListener
NewPeakArena.OnRemoveListener = OnRemoveListener
NewPeakArena.OnBtnInfoClick = OnBtnInfoClick
NewPeakArena.OnBtnRewardClick = OnBtnRewardClick
NewPeakArena.OnBtnRecordClick = OnBtnRecordClick
NewPeakArena.OnBtnBoxClick = OnBtnBoxClick
NewPeakArena.OnBtnDefenceClick = OnBtnDefenceClick
NewPeakArena.OnBtnUpClick = OnBtnUpClick
NewPeakArena.ShowPromte = ShowPromte
NewPeakArena.OnBtnChallangeClick = OnBtnChallangeClick
NewPeakArena.Init = Init
NewPeakArena.Refresh = Refresh
NewPeakArena.RefreshState = RefreshState
NewPeakArena.PlaySelfRankAnim = PlaySelfRankAnim
NewPeakArena.PlaySelfRankAnimTop = PlaySelfRankAnimTop
NewPeakArena.PlayDownSelfRankAnim = PlayDownSelfRankAnim
NewPeakArena.OnNewArenaPraise = OnNewArenaPraise
NewPeakArena.Update1000MS = Update1000MS
NewPeakArena.SetWaitingForMsg = SetWaitingForMsg
NewPeakArena.UnsetWaitingForMsg = UnsetWaitingForMsg
NewPeakArena.OnNewPeakArenaGetMessageError = OnNewPeakArenaGetMessageError
NewPeakArena.CloseAllPopups = CloseAllPopups
NewPeakArena.OnNewArenaLogRecord = OnNewArenaLogRecord
NewPeakArena.OnGetBattlePreview = OnGetBattlePreview
NewPeakArena.OnGetKOFBattlePreview = OnGetKOFBattlePreview
NewPeakArena.RefreshDailyBox = RefreshDailyBox
NewPeakArena.RefreshRecordsRedDot = RefreshRecordsRedDot
return NewPeakArena
