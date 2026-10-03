local UIGetDuelScoreTipView = BaseClass("UIGetDuelScoreTipView", UIBaseView)
local base = UIBaseView
local UIGetDuelScoreTipItem = require("UI.UIGetDuelScoreTip.Component.UIGetDuelScoreTipItem")
local item_path = "UIGetDuelScoreTipItem"
local content_path = "Root"
local progress_go_path = "Root/progressGo"
local red_slider_path = "Root/progressGo/mask/redSlider"
local handle_path = "Root/progressGo/mask/redSlider/Handle Slide Area/Handle"
local red_rat_txt_path = "Root/progressGo/redRatTxt"
local blue_tat_txt_path = "Root/progressGo/blueTatTxt"
local eff_score_path = "Root/progressGo/blueTatTxt/Eff_ui_GetDuelScoreTipGlow"
local CountNumJumpTimes = 10
local ChangePerTime = 100
local DelayTime = 0.5

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  DataCenter.LWSoundManager:PlaySound(62302, false)
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshView()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.itemGo = self.transform:Find(item_path).gameObject
  self.itemGo:SetActive(false)
  self.itemGo:GameObjectCreatePool()
  self.itemComps = {}
  self.progressGo = self:AddComponent(UIBaseContainer, progress_go_path)
  self.progressGo:SetActive(false)
  self.slider = self:AddComponent(UISlider, red_slider_path)
  self.handle = self:AddComponent(UIBaseContainer, handle_path)
  self.redRatTxt = self:AddComponent(UIText, red_rat_txt_path)
  self.blueTatTxt = self:AddComponent(UIText, blue_tat_txt_path)
  self.eff_score = self:AddComponent(UIBaseContainer, eff_score_path)
  self.eff_score:SetActive(false)
end

local function ComponentDestroy(self)
  self:CleanSeq()
  self.content:RemoveComponents(UIGetDuelScoreTipItem)
  self.content = nil
  self.itemGo:GameObjectRecycleAll()
  self.itemGo = nil
  self.itemComps = nil
  self.progressGo = nil
  self.slider = nil
  self.handle = nil
  self.redRatTxt = nil
  self.blueTatTxt = nil
  self.eff_score = nil
end

local function DataDefine(self)
  self._resNumShow = 0
  self._resNumTarget = 0
  self._resNumDelta = 0
  self._lastSetTime = 0
  self._resNumShow2 = 0
  self._resNumTarget2 = 0
  self._resNumDelta2 = 0
  self._lastSetTime2 = 0
  
  function self.delay_timer_action()
    self:DelayRefreshTimerBallBack()
  end
end

local function DataDestroy(self)
  self.scoreDatas = nil
  self.diff = nil
  self.progressTime = nil
  self:DeleteDelayRefreshTimer()
  self._resNumShow = 0
  self._resNumTarget = 0
  self._resNumDelta = 0
  self._lastSetTime = 0
  self._resNumShow2 = 0
  self._resNumTarget2 = 0
  self._resNumDelta2 = 0
  self._lastSetTime2 = 0
  self.delay_timer_action = nil
  self.delayTimer = nil
end

local function OnAddListener(self)
end

local function OnRemoveListener(self)
end

local function AddData(self, scoreType, oldScore, newScore, targetGroups, isDiff)
  if self.scoreDatas == nil then
    self.scoreDatas = {}
  end
  local scoreData = {}
  scoreData.scoreType = scoreType
  scoreData.oldScore = oldScore
  scoreData.newScore = newScore
  scoreData.targetGroups = targetGroups
  scoreData.isDiff = isDiff
  self.scoreDatas[scoreType] = scoreData
  if scoreType == GetDuelScoreType.Ally then
    if self.diff == nil then
      self.diff = 0
    end
    self.diff = self.diff + (newScore - oldScore)
  end
end

local function RefreshView(self)
  if self.scoreDatas and self.itemComps then
    for _, value in pairs(self.scoreDatas) do
      local comp = self.itemComps[value.scoreType]
      if comp == nil then
        local go = self.itemGo:GameObjectSpawn(self.content.transform)
        go.name = "item_" .. value.scoreType
        comp = self.content:AddComponent(UIGetDuelScoreTipItem, go.name)
        self.itemComps[value.scoreType] = comp
      end
      comp:SetActive(true)
      comp:Refresh(value.scoreType, value.oldScore, value.newScore, value.targetGroups, value.isDiff)
    end
    self.scoreDatas = nil
    self.progressGo:SetActive(false)
    self.progressTime = nil
  end
end

local function Update1000MS(self)
  self:RefreshItemComps()
end

local function Update(self)
  if self.itemComps then
    return
  elseif self.progressTime then
    local tempT = UITimeManager:GetInstance():GetServerTime()
    if tempT < self.progressTime then
      local addDelay = false
      if self._resNumShow ~= self._resNumTarget and tempT - self._lastSetTime >= ChangePerTime then
        self._lastSetTime = tempT
        self._resNumShow = self._resNumShow + self._resNumDelta
        if self._resNumDelta > 0 and self._resNumShow > self._resNumTarget then
          self._resNumShow = self._resNumTarget
        elseif self._resNumDelta < 0 and self._resNumShow < self._resNumTarget then
          self._resNumShow = self._resNumTarget
        end
        self.blueTatTxt:SetText(string.format("%.3f", self._resNumShow / 1000) .. "%")
        if self._resNumShow == self._resNumTarget then
          addDelay = true
        end
      end
      if self._resNumShow2 ~= self._resNumTarget2 and tempT - self._lastSetTime2 >= ChangePerTime then
        self._lastSetTime2 = tempT
        self._resNumShow2 = self._resNumShow2 + self._resNumDelta2
        if 0 < self._resNumDelta2 and self._resNumShow2 > self._resNumTarget2 then
          self._resNumShow2 = self._resNumTarget2
        elseif 0 > self._resNumDelta2 and self._resNumShow2 < self._resNumTarget2 then
          self._resNumShow2 = self._resNumTarget2
        end
        self.redRatTxt:SetText(string.format("%.3f", self._resNumShow2 / 1000) .. "%")
        if self._resNumShow2 == self._resNumTarget2 then
          addDelay = true
        end
      end
      if addDelay then
        self:AddDelayRefreshTimer()
      end
    end
  end
end

local function RefreshItemComps(self)
  if self.itemComps then
    local isAllHide = true
    for key, value in pairs(self.itemComps) do
      if value:CheckNeedRemove() then
        self.itemComps[key].transform:SetAsLastSibling()
        self.itemComps[key]:SetActive(false)
      end
      if self.itemComps[key]:GetActive() then
        isAllHide = false
      end
    end
    if isAllHide then
      self.itemComps = nil
      if self:CheckAllianceScoreShow() then
        self.diff = nil
      else
        self.ctrl:CloseSelf()
      end
    end
  elseif self.progressTime and UITimeManager:GetInstance():GetServerTime() >= self.progressTime then
    self.progressTime = nil
    self.ctrl:CloseSelf()
  end
end

function UIGetDuelScoreTipView:CleanSeq()
  if self.sliderSeq then
    self.sliderSeq:Kill()
    self.sliderSeq = nil
  end
  if self.signSeq then
    self.signSeq:Kill()
    self.signSeq = nil
  end
end

local function CheckAllianceScoreShow(self)
  self:CleanSeq()
  self.progressGo:SetActive(false)
  if not DataCenter.LeagueMatchManager:BNewPop() then
    return
  end
  local info = DataCenter.GetDuelScoreManager:GetDuelInfoByType(GetDuelScoreType.Ally)
  if info == nil then
    return
  end
  local myScore = info.curMyAlScore or 0
  myScore = math.max(myScore, 0)
  local otherScore = info.curEnemyAlScore or 0
  otherScore = math.max(otherScore, 0)
  local total = myScore + otherScore
  if total <= 0 or otherScore == 0 then
    return
  end
  local oldMyScore = myScore - (self.diff or 0)
  oldMyScore = math.max(oldMyScore, 0)
  local checkPercent = (myScore - oldMyScore) * 100.0 / total
  if checkPercent < 0.001 then
    return
  end
  self.progressGo:SetActive(true)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.progressTime = curTime + 2500
  local rate, redRate, blueRate = 0.5, 50, 50
  if myScore == otherScore then
  else
    rate = tonumber(myScore / total)
    self.slider:SetValue(rate)
    redRate = (1 - rate) * 100
    blueRate = rate * 100
  end
  local percent = LuaEntry.DataConfig:TryGetNum("alliance_duel_tip", "k6", 0.01)
  self.slider:SetValue(rate - percent)
  self.handle:SetLocalScaleXYZ(0, 0, 0)
  local sequence = DOTween.Sequence()
  sequence:AppendInterval(0.11666666666666667)
  sequence:Append(self.handle.transform:DOScale(1.5, 0.03333333333333333))
  sequence:Append(self.handle.transform:DOScale(1, 0.35))
  self.signSeq = sequence
  local playEff = false
  local checkNum = LuaEntry.DataConfig:TryGetNum("alliance_duel_tip", "k3", 0)
  if checkNum >= math.abs(blueRate - redRate) or 1 <= checkPercent then
    playEff = true
  end
  self._resNumTarget = blueRate * 1000
  self._resNumShow = (blueRate - checkPercent) * 1000
  self._resNumDelta = (self._resNumTarget - self._resNumShow) / CountNumJumpTimes
  if math.modf(self._resNumDelta) == 0 then
    self._resNumDelta = 0 < self._resNumDelta and 1 or -1
  else
    self._resNumDelta = math.modf(self._resNumDelta)
  end
  self._resNumTarget2 = redRate * 1000
  self._resNumShow2 = (redRate + checkPercent) * 1000
  self._resNumDelta2 = (self._resNumTarget2 - self._resNumShow2) / CountNumJumpTimes
  if math.modf(self._resNumDelta2) == 0 then
    self._resNumDelta2 = 0 < self._resNumDelta2 and 1 or -1
  else
    self._resNumDelta2 = math.modf(self._resNumDelta2)
  end
  self._lastSetTime = curTime
  self._lastSetTime2 = curTime
  self.blueTatTxt:SetText(string.format("%.3f", self._resNumShow / 1000) .. "%")
  self.redRatTxt:SetText(string.format("%.3f", self._resNumShow2 / 1000) .. "%")
  self.eff_score:SetActive(false)
  self.sliderSeq = self.slider:DOValue(rate, 0.5):OnComplete(function()
    if playEff then
      self.eff_score:SetActive(true)
    end
  end)
  return true
end

function UIGetDuelScoreTipView:AddDelayRefreshTimer()
  self:DeleteDelayRefreshTimer()
  self.delayTimer = TimerManager:GetInstance():GetTimer(DelayTime, self.delay_timer_action, self, true, false, false)
  self.delayTimer:Start()
end

function UIGetDuelScoreTipView:DelayRefreshTimerBallBack()
  self:DeleteDelayRefreshTimer()
  self.blueTatTxt:SetText(string.format("%.3f", self._resNumTarget / 1000) .. "%")
  self.redRatTxt:SetText(string.format("%.3f", self._resNumTarget2 / 1000) .. "%")
end

function UIGetDuelScoreTipView:DeleteDelayRefreshTimer()
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

UIGetDuelScoreTipView.OnCreate = OnCreate
UIGetDuelScoreTipView.OnDestroy = OnDestroy
UIGetDuelScoreTipView.OnEnable = OnEnable
UIGetDuelScoreTipView.OnDisable = OnDisable
UIGetDuelScoreTipView.ComponentDefine = ComponentDefine
UIGetDuelScoreTipView.ComponentDestroy = ComponentDestroy
UIGetDuelScoreTipView.DataDefine = DataDefine
UIGetDuelScoreTipView.DataDestroy = DataDestroy
UIGetDuelScoreTipView.OnAddListener = OnAddListener
UIGetDuelScoreTipView.OnRemoveListener = OnRemoveListener
UIGetDuelScoreTipView.AddData = AddData
UIGetDuelScoreTipView.RefreshView = RefreshView
UIGetDuelScoreTipView.Update1000MS = Update1000MS
UIGetDuelScoreTipView.Update = Update
UIGetDuelScoreTipView.RefreshItemComps = RefreshItemComps
UIGetDuelScoreTipView.CheckAllianceScoreShow = CheckAllianceScoreShow
return UIGetDuelScoreTipView
