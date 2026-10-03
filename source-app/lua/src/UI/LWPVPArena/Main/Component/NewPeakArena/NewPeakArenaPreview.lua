local NewPeakArenaPreview = BaseClass("NewPeakArenaPreview", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local NewPeakArenaPreWinerItem = require("UI.LWPVPArena.Main.Component.NewPeakArena.NewPeakArenaPreWinerItem")
local NewPeakArenaPreRankLevelItem = require("UI.LWPVPArena.Main.Component.NewPeakArena.NewPeakArenaPreRankLevelItem")

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
  self.compFirst = self:AddComponent(NewPeakArenaPreWinerItem, "Winner/First")
  self.compSecond = self:AddComponent(NewPeakArenaPreWinerItem, "Winner/Second")
  self.compThird = self:AddComponent(NewPeakArenaPreWinerItem, "Winner/Third")
  self.textTip = self:AddComponent(UIText, "DownInfo/TipText")
  self.textPowerRank = self:AddComponent(UIText, "DownInfo/PowerRankText")
  self.btnPromte = self:AddComponent(UIButton, "DownInfo/PromteBtn")
  self.btnPromte:SetOnClick(function()
    self:OnBtnPromteClick()
  end)
  self.textPromteBtn = self:AddComponent(UIText, "DownInfo/PromteBtn/PromteBtnText")
  self.compAdvancedItem = self:AddComponent(NewPeakArenaPreRankLevelItem, "DownInfo/AdvancedItem")
  self.compIntermediateItem = self:AddComponent(NewPeakArenaPreRankLevelItem, "DownInfo/IntermediateItem")
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
  self.winnerComps = nil
  self.btnRecord = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.NewArenaPraise, self.OnNewArenaPraise)
  self:AddUIListener(EventId.NewArenaLogRecord, self.OnNewArenaLogRecord)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.NewArenaPraise, self.OnNewArenaPraise)
  self:RemoveUIListener(EventId.NewArenaLogRecord, self.OnNewArenaLogRecord)
  base.OnRemoveListener(self)
end

local function OnBtnInfoClick(self)
  self.view:ShowInfo(801104, "new_arena_tips_8")
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
  local historyServers = DataCenter.NewPeakArenaManager.info.historyServers
  if historyServers and 0 < #historyServers then
    local info = ""
    local ret = table.concat(historyServers, " #")
    info = "#" .. ret
    self.textTitle:SetText(info)
  else
    self.textTitle:SetLocalText("new_arena_tips_35")
  end
  if DataCenter.NewPeakArenaManager.state == NewPeakArenaState.Open then
    self.textOpenTip:SetActive(true)
  else
    self.textOpenTip:SetActive(false)
  end
  if DataCenter.NewPeakArenaManager.info.heroPowerRank == 0 then
    self.textPowerRank:SetLocalText("new_arena_no_rank")
  else
    self.textPowerRank:SetText(Localization:GetString("new_arena_tips_6") .. " <color=#fdc389>" .. DataCenter.NewPeakArenaManager.info.heroPowerRank .. "</color>")
  end
  self.compAdvancedItem:Refresh(NewPeakArenaLevel.Advanced)
  self.compIntermediateItem:Refresh(NewPeakArenaLevel.Intermediate)
  local state = DataCenter.NewPeakArenaManager.state
  self.btnRecord:SetActive(state ~= NewPeakArenaState.FirstPreview)
  self:RefreshRank()
  self:OnNewArenaPraise()
  self:Update1000MS()
end

local function RefreshRank(self)
  if DataCenter.NewPeakArenaManager.rankData and DataCenter.NewPeakArenaManager.rankData.players then
    for index, value in ipairs(self.winnerComps) do
      local player = DataCenter.NewPeakArenaManager.rankData.players[index]
      if player then
        value:SetActive(true)
        value:Refresh(player)
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
      if DataCenter.NewPeakArenaManager.state == NewPeakArenaState.Open then
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
      if DataCenter.NewPeakArenaManager.state == NewPeakArenaState.Open then
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

local function OnNewArenaPraise(self, uid)
  if DataCenter.NewPeakArenaManager.rankData then
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
end

local function OnBtnRecordClick(self)
  SFSNetwork.SendMessage(MsgDefines.NewArenaLogRecord)
end

local function OnNewArenaLogRecord(self, msg)
  UIManager:GetInstance():OpenWindow(UIWindowNames.NewPeakArenaRecord, {anim = true}, msg, self.pagePara1, PVPArenaType.NewPeakArena)
end

NewPeakArenaPreview.OnCreate = OnCreate
NewPeakArenaPreview.OnDestroy = OnDestroy
NewPeakArenaPreview.OnEnable = OnEnable
NewPeakArenaPreview.OnDisable = OnDisable
NewPeakArenaPreview.ComponentDefine = ComponentDefine
NewPeakArenaPreview.ComponentDestroy = ComponentDestroy
NewPeakArenaPreview.DataDefine = DataDefine
NewPeakArenaPreview.DataDestroy = DataDestroy
NewPeakArenaPreview.OnAddListener = OnAddListener
NewPeakArenaPreview.OnRemoveListener = OnRemoveListener
NewPeakArenaPreview.OnBtnInfoClick = OnBtnInfoClick
NewPeakArenaPreview.OnBtnPromteClick = OnBtnPromteClick
NewPeakArenaPreview.Init = Init
NewPeakArenaPreview.Refresh = Refresh
NewPeakArenaPreview.RefreshRank = RefreshRank
NewPeakArenaPreview.Update1000MS = Update1000MS
NewPeakArenaPreview.OnNewArenaPraise = OnNewArenaPraise
NewPeakArenaPreview.OnBtnRecordClick = OnBtnRecordClick
NewPeakArenaPreview.OnNewArenaLogRecord = OnNewArenaLogRecord
return NewPeakArenaPreview
