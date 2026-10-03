local NewGaleArenaPreview = BaseClass("NewGaleArenaPreview", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local NewGaleArenaPreWinnerItem = require("UI.LWPVPArena.Main.Component.NewGaleArena.NewGaleArenaPreWinnerItem")
local NewGaleArenaPreRankLevelItem = require("UI.LWPVPArena.Main.Component.NewGaleArena.NewGaleArenaPreRankLevelItem")

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
end

local function ComponentDefine(self)
  self.timeBg = self:AddComponent(UIBaseContainer, "TopInfo/TimeBg")
  self.timeImg = self:AddComponent(UIBaseContainer, "TopInfo/TimeImg")
  self.textTime = self:AddComponent(UIText, "TopInfo/TimeBg/TimeText")
  self.btnInfo = self:AddComponent(UIButton, "TopInfo/InfoBtn")
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.compFirst = self:AddComponent(NewGaleArenaPreWinnerItem, "Winner/First")
  self.compSecond = self:AddComponent(NewGaleArenaPreWinnerItem, "Winner/Second")
  self.compThird = self:AddComponent(NewGaleArenaPreWinnerItem, "Winner/Third")
  self.textTip = self:AddComponent(UIText, "DownInfo/TipText")
  self.textPowerRank = self:AddComponent(UIText, "DownInfo/PowerRankText")
  self.btnPromte = self:AddComponent(UIButton, "DownInfo/PromteBtn")
  self.btnPromte:SetOnClick(function()
    self:OnBtnPromteClick()
  end)
  self.textPromteBtn = self:AddComponent(UIText, "DownInfo/PromteBtn/PromteBtnText")
  self.compAdvancedItem = self:AddComponent(NewGaleArenaPreRankLevelItem, "DownInfo/AdvancedItem")
  self.compIntermediateItem = self:AddComponent(NewGaleArenaPreRankLevelItem, "DownInfo/IntermediateItem")
  self.compBasicItem = self:AddComponent(NewGaleArenaPreRankLevelItem, "DownInfo/BasicItem")
  self.winnerComps = {
    self.compFirst,
    self.compSecond,
    self.compThird
  }
  self.textTitle = self:AddComponent(UIText, "TopInfo/TitleText")
  self.textOpenTip = self:AddComponent(UIText, "DownInfo/OpenTipText")
  self.textTip:SetLocalText("new_arena_tips_7")
  self.textPromteBtn:SetLocalText("new_arena_tips_9")
  self.textOpenTip:SetLocalText("new_arena_tips_39")
  self.btnRecord = self:AddComponent(UIButton, "TopInfo/RecordBtn")
  self.btnRecord:SetOnClick(function()
    self:OnBtnRecordClick()
  end)
  self.textRecordBtn = self:AddComponent(UIText, "TopInfo/RecordBtn/RecordBtnText")
  self.textRecordBtn:SetLocalText("new_arena_tips_19")
  self.stageInfo = self:AddComponent(UICanvasGroup, "StageInfo")
  self.textStage = self:AddComponent(UIText, "StageInfo/StageText")
  self.rawImageStateBg1 = self:AddComponent(UIRawImage, "StageInfo/BG1")
  self.rawImageStateBg2 = self:AddComponent(UIRawImage, "StageInfo/BG2")
end

local function ComponentDestroy(self)
  self.textTime = nil
  self.btnInfo = nil
  self.compFirst = nil
  self.compSecond = nil
  self.compThird = nil
  self.textTip = nil
  self.textPowerRank = nil
  self.btnPromte = nil
  self.textPromteBtn = nil
  self.compAdvancedItem = nil
  self.compIntermediateItem = nil
  self.compBasicItem = nil
  self.winnerComps = nil
  self.btnRecord = nil
end

local function DataDefine(self)
  self.previewLevel = NewGaleArenaLevel.Advanced
  self.previewPlayers = {}
  SFSNetwork.SendMessage(MsgDefines.GaleArenaGetTopThreeList, self.previewLevel)
end

local function DataDestroy(self)
  self.previewPlayers = nil
  self.previewLevel = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.NewGaleArenaLogRecord, self.OnNewArenaLogRecord)
  self:AddUIListener(EventId.NewGaleArenaGetTopThreeListPreview, self.OnNewGaleArenaGetTopThreeListPreview)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.NewGaleArenaLogRecord, self.OnNewArenaLogRecord)
  self:RemoveUIListener(EventId.NewGaleArenaGetTopThreeListPreview, self.OnNewGaleArenaGetTopThreeListPreview)
  base.OnRemoveListener(self)
end

local function OnBtnInfoClick(self)
  self.view:ShowInfo(801104, "gale_arena_rules")
end

local function OnBtnPromteClick(self)
  GoToUtil.GotoOpenView(UIWindowNames.UIHeroListPanel, {
    anim = false,
    UIMainAnim = UIMainAnimType.AllHide
  })
end

local function Init(self, pagePara1)
  self:Refresh()
end

local function Refresh(self)
  local historyServers = DataCenter.NewGaleArenaManager.info.historyServers
  if historyServers and 0 < #historyServers then
    local info = ""
    local ret = table.concat(historyServers, " #")
    info = "#" .. ret
    self.textTitle:SetText(info)
  else
    self.textTitle:SetLocalText("new_arena_tips_35")
  end
  if DataCenter.NewGaleArenaManager.state == NewPeakArenaState.Open then
    self.textOpenTip:SetActive(true)
  else
    self.textOpenTip:SetActive(false)
  end
  if DataCenter.NewGaleArenaManager.info.heroPowerRank == 0 then
    self.textPowerRank:SetLocalText("new_arena_no_rank")
  else
    self.textPowerRank:SetText(Localization:GetString("new_arena_tips_6") .. " <color=#fdc389>" .. DataCenter.NewGaleArenaManager.info.heroPowerRank .. "</color>")
  end
  self:RefreshBar()
  local state = DataCenter.NewGaleArenaManager.state
  self.btnRecord:SetActive(state ~= NewPeakArenaState.FirstPreview)
  self:RefreshRank()
  self:Update1000MS()
end

local function StopSequence(self)
  if self.sequence ~= nil then
    self.sequence:Kill()
    self.sequence = nil
  end
end

local function RefreshRank(self)
  if not table.IsNullOrEmpty(self.previewPlayers) then
    local bgPath
    if self.previewLevel == NewGaleArenaLevel.Advanced then
      bgPath = "Assets/Main/TextureEx/NewGaleArena/wxy_jingjijifeng_jindi.png"
      self.textStage:SetLocalText("new_arena_tips_3")
    elseif self.previewLevel == NewGaleArenaLevel.Intermediate then
      bgPath = "Assets/Main/TextureEx/NewGaleArena/wxy_jingjijifeng_yindi.png"
      self.textStage:SetLocalText("new_arena_tips_4")
    elseif self.previewLevel == NewGaleArenaLevel.Basic then
      bgPath = "Assets/Main/TextureEx/NewGaleArena/wxy_jingjijifeng_tongdi.png"
      self.textStage:SetLocalText("gale_arena_tips03")
    end
    self.stageInfo:SetAlpha(0)
    StopSequence(self)
    self.stageInfo:SetActive(true)
    self.sequence = CS.DG.Tweening.DOTween.Sequence()
    self.sequence:Join(self.stageInfo:FadeIn(1))
    self.sequence:AppendInterval(5)
    self.sequence:Join(self.stageInfo:FadeOut(1))
    self.sequence:AppendCallback(function()
      self.stageInfo:SetActive(false)
    end)
    if bgPath then
      self.rawImageStateBg1:LoadSpriteAsync(bgPath)
      self.rawImageStateBg2:LoadSpriteAsync(bgPath)
    end
    for index, value in ipairs(self.winnerComps) do
      local player = self.previewPlayers[index]
      if player then
        value:SetActive(true)
        value:Refresh(player, self.previewLevel)
      else
        value:SetActive(false)
      end
    end
  else
    for index, value in ipairs(self.winnerComps) do
      value:SetActive(false)
    end
  end
end

local function RefreshBar(self)
  local selfArenaType = DataCenter.NewGaleArenaManager.rankData and DataCenter.NewGaleArenaManager.rankData.arenaType or NewGaleArenaLevel.Basic
  self.compAdvancedItem:Refresh(NewGaleArenaLevel.Advanced, self.previewLevel, selfArenaType == NewGaleArenaLevel.Advanced)
  self.compIntermediateItem:Refresh(NewGaleArenaLevel.Intermediate, self.previewLevel, selfArenaType == NewGaleArenaLevel.Intermediate)
  self.compBasicItem:Refresh(NewGaleArenaLevel.Basic, self.previewLevel, selfArenaType == NewGaleArenaLevel.Basic)
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
      if DataCenter.NewGaleArenaManager.state == NewPeakArenaState.Open then
        self.textTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
      else
        self.textTime:SetLocalText("new_arena_tips_34", UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
      end
    else
      if self.hasRemainTime then
        self.hasRemainTime = false
        self.view:CloseAllPopups()
        SFSNetwork.SendMessage(MsgDefines.GetPVPArenaInfo)
      end
      if DataCenter.NewGaleArenaManager.state == NewPeakArenaState.Open then
        self.textTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(0))
      else
        self.textTime:SetLocalText("new_arena_tips_34", UITimeManager:GetInstance():MilliSecondToFmtString(0))
      end
    end
  else
    self.timeBg:SetActive(false)
    self.timeImg:SetActive(false)
  end
end

local function OnBtnRecordClick(self)
  SFSNetwork.SendMessage(MsgDefines.GaleArenaLogRecord)
end

local function OnNewArenaLogRecord(self, msg)
  UIManager:GetInstance():OpenWindow(UIWindowNames.NewPeakArenaRecord, {anim = true}, msg, self.pagePara1, PVPArenaType.NewGaleArena)
end

local function OnNewGaleArenaGetTopThreeListPreview(self, msg)
  self.previewLevel = msg.arenaType
  self.previewPlayers = msg.players
  self:RefreshRank()
  self:RefreshBar()
end

NewGaleArenaPreview.OnCreate = OnCreate
NewGaleArenaPreview.OnDestroy = OnDestroy
NewGaleArenaPreview.OnEnable = OnEnable
NewGaleArenaPreview.OnDisable = OnDisable
NewGaleArenaPreview.ComponentDefine = ComponentDefine
NewGaleArenaPreview.ComponentDestroy = ComponentDestroy
NewGaleArenaPreview.DataDefine = DataDefine
NewGaleArenaPreview.DataDestroy = DataDestroy
NewGaleArenaPreview.OnAddListener = OnAddListener
NewGaleArenaPreview.OnRemoveListener = OnRemoveListener
NewGaleArenaPreview.OnBtnInfoClick = OnBtnInfoClick
NewGaleArenaPreview.OnBtnPromteClick = OnBtnPromteClick
NewGaleArenaPreview.Init = Init
NewGaleArenaPreview.Refresh = Refresh
NewGaleArenaPreview.RefreshRank = RefreshRank
NewGaleArenaPreview.RefreshBar = RefreshBar
NewGaleArenaPreview.Update1000MS = Update1000MS
NewGaleArenaPreview.OnBtnRecordClick = OnBtnRecordClick
NewGaleArenaPreview.OnNewArenaLogRecord = OnNewArenaLogRecord
NewGaleArenaPreview.OnNewGaleArenaGetTopThreeListPreview = OnNewGaleArenaGetTopThreeListPreview
return NewGaleArenaPreview
