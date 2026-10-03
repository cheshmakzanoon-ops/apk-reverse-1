local UIZombieBattleWinView = BaseClass("UIZombieBattleWinView", UIBaseView)
local base = UIBaseView
local Time = _ENV.Time
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local LayoutLayer = "Layout/"
local monopolySbattleDelayTime = 5
local sBattleText = "(%s)"
local UIStatisticList = require("UI.UIZombieBattleLose.Component.UIZombieBattleStatisticHeroList")

function UIZombieBattleWinView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Show()
end

function UIZombieBattleWinView:OnDestroy()
  if not IsNull(self.tabTween) then
    self.tabTween:Kill()
    self.tabTween = nil
  end
  if self.showRewardAnimCo then
    self.showRewardAnimCo = nil
  end
  if self.reqs ~= nil then
    for _, v in pairs(self.reqs) do
      v:Destroy()
    end
    self.reqs = nil
  end
  if self.timerTask then
    self.timerTask:Stop()
    self.timerTask = nil
  end
  base.OnDestroy(self)
end

function UIZombieBattleWinView:ComponentDefine()
  self.backBtn = self:AddComponent(UIButton, LayoutLayer .. "BackBtn")
  self.backBtn:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.timerTask = TimerManager:GetInstance():GetTimer(1, function()
    self:SBattleTimeFunc()
  end, self, false, false, false)
  self.layout = self:AddComponent(UIBaseContainer, LayoutLayer)
  self.canvasGroup = self.transform:Find(LayoutLayer).gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.canvasGroup.alpha = 0
  self.victoryText = self:AddComponent(UIText, LayoutLayer .. "Title/VictoryGo/VictoryText")
  self.victoryText:SetText(Localization:GetString("311105"))
  self.levelText = self:AddComponent(UIText, LayoutLayer .. "LevelText")
  self.timeText = self:AddComponent(UIText, LayoutLayer .. "TimeText")
  self.killNumText = self:AddComponent(UIText, LayoutLayer .. "KillNumText")
  self.isSbattle = DataCenter.MonopolyManager:GetSpontaneousBattle()
  self.sBattleToogle = self:AddComponent(UIToggle, "Layout/backToggle")
  self.sBattleToogle:SetIsOn(self.isSbattle)
  self.sBattleToogle:SetOnValueChanged(function(value)
    self:OnToggerChangeFunc(value)
  end)
  self.backBtnTimerRoot = self:AddComponent(UIBaseContainer, "Layout/BackBtn/timerRoot")
  self.backBtnTimerText = self:AddComponent(UIText, "Layout/BackBtn/timerRoot/timer")
  self.backBtnTimerTitle = self:AddComponent(UIText, "Layout/BackBtn/timerRoot/title")
  self.backBtnText = self:AddComponent(UIText, LayoutLayer .. "BackBtn/BackBtnText")
  local param, battleManagerParam = self:GetUserData()
  local stageId = param.stageId
  self.stageTemp = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), stageId)
  self.battleManagerParam = battleManagerParam
  self.backBtnText:SetActive(true)
  self.sBattleToogle:SetActive(false)
  if self.battleManagerParam.enterType == PVEEnterType.Radar then
    self.backBtnText:SetText(Localization:GetString("300520"))
  elseif self.battleManagerParam.enterType == PVEEnterType.TowerupJeepAdventure then
    self.backBtnText:SetText(Localization:GetString("800306"))
  elseif self.battleManagerParam.enterType == PVEEnterType.Monopoly then
    self.backBtnText:SetText(Localization:GetString("800306"))
    local isOpen = DataCenter.MonopolyManager:GetSBattleIsOpen()
    self.backBtnTimerTitle:SetText(Localization:GetString(801327))
    if isOpen then
      self.sBattleToogle:SetActive(true)
    else
      self.sBattleToogle:SetActive(false)
    end
    self.sBattleToogle:SetIsOn(self.isSbattle)
    if self.isSbattle then
      self.backBtnText:SetActive(false)
      self.backBtnTimerRoot:SetActive(true)
      self.time = monopolySbattleDelayTime
      self.backBtnTimerText:SetText(string.format(sBattleText, self.time))
      self.timerTask:Start()
    else
      self.backBtnText:SetActive(true)
      self.backBtnTimerRoot:SetActive(false)
    end
  else
    self.backBtnText:SetText(Localization:GetString("800306"))
  end
  self.levelText:SetText(Localization:GetString("800313", GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), stageId, "order")))
  self.tabBtns = {
    self:AddComponent(UIButton, "Layout/Tabs/MakeBtn"),
    self:AddComponent(UIButton, "Layout/Tabs/TakeBtn")
  }
  for i, tabBtn in ipairs(self.tabBtns) do
    local idx = i
    tabBtn:SetOnClick(function()
      self:OnTabBtnClick(idx)
    end)
  end
  self.tabComps = {
    self:AddComponent(UIStatisticList, "Layout/MakeDmgScroll", "makeDmg"),
    self:AddComponent(UIStatisticList, "Layout/TakeDmgScroll", "takeDmg")
  }
  self.tabIdx = 1
  self.highlightMask = self:AddComponent(UIBaseContainer, "Layout/Tabs/Highlight/Mask")
  self.highlightInner = self:AddComponent(UIBaseContainer, "Layout/Tabs/Highlight/Mask/Inner")
  self.highlightMask:SetAnchoredPositionXY(0, -1)
  self.highlightInner:SetAnchoredPositionXY(0, 0)
  self.transform:Find("Layout/Tabs/MakeBtn/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800800)
  self.transform:Find("Layout/Tabs/Highlight/Mask/Inner/MakeBtnHigh/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800800)
  self.transform:Find("Layout/Tabs/TakeBtn/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800801)
  self.transform:Find("Layout/Tabs/Highlight/Mask/Inner/TakeBtnHigh/BtnText"):GetComponent(typeof(CS.TextMeshProUGUIEx)).text = CS.GameEntry.Localization:GetString(800801)
end

function UIZombieBattleWinView:SBattleTimeFunc()
  if not self.time then
    self.timerTask:Pause()
  end
  self.time = self.time - 1
  if not IsNull(self.backBtnTimerText) then
    self.backBtnTimerText:SetText(string.format(sBattleText, self.time))
  end
  if self.time == 0 then
    self:OnBackBtnClick()
    if self.timerTask then
      self.timerTask:Pause()
    end
  end
end

function UIZombieBattleWinView:Show()
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_stage_win_bgm)
  TimerManager:GetInstance():DelayInvoke(function()
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIZombieBattleWin) then
      self.canvasGroup:DOFade(1, 0.2)
      self:RefreshView()
    end
  end, 1.5)
end

function UIZombieBattleWinView:OnToggerChangeFunc(value)
  if self.isSbattle ~= value then
    self.isSbattle = value
    DataCenter.MonopolyManager:SetSpontaneousBattle(value)
  end
  if self.isSbattle then
    self.time = monopolySbattleDelayTime
    self.backBtnTimerText:SetText(string.format(sBattleText, self.time))
    self.backBtnText:SetActive(false)
    self.backBtnTimerRoot:SetActive(true)
    self.timerTask:Start()
  else
    self.backBtnText:SetActive(true)
    self.backBtnTimerRoot:SetActive(false)
    if self.timerTask then
      self.timerTask:Pause()
    end
  end
end

function UIZombieBattleWinView:OnTabBtnClick(idx)
  if self.tabIdx == idx then
    return
  end
  self.tabIdx = idx
  self:RefreshView()
  if not IsNull(self.tabTween) then
    self.tabTween:Kill()
    self.tabTween = nil
  end
  self.tabTween = CS.DG.Tweening.DOTween.To(function()
    return self.highlightMask:GetAnchoredPositionX()
  end, function(value)
    self.highlightMask:SetAnchoredPositionXY(value, -1)
    self.highlightInner:SetAnchoredPositionXY(-value, 0)
  end, (self.tabIdx - 1) * 334 * (CommonUtil.IsArabicAutoMirrorOpen() and -1 or 1), 0.5):SetEase(CS.DG.Tweening.Ease.OutQuint)
end

function UIZombieBattleWinView:DataDefine()
  self.flyRewardList = {}
  self.heroId = nil
end

function UIZombieBattleWinView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

function UIZombieBattleWinView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
  base.OnRemoveListener(self)
end

function UIZombieBattleWinView:OnKeyCodeEscape()
  TimerManager:GetInstance():DelayFrameInvoke(function()
    self:OnBackBtnClick()
  end, 1)
end

function UIZombieBattleWinView:ComponentDestroy()
  self.back_btn = nil
end

function UIZombieBattleWinView:RefreshView()
  for i, tabComp in ipairs(self.tabComps) do
    if i == self.tabIdx then
      tabComp:SetActive(true)
      tabComp:RefreshView()
      tabComp:FadeIn()
    else
      tabComp:SetActive(false)
    end
  end
end

function UIZombieBattleWinView:OnBackBtnClick()
  local cfg = {}
  for i, v in ipairs(self.flyRewardList) do
    cfg[i] = {
      v[1].position,
      v[2]
    }
  end
  EventManager:GetInstance():Broadcast(EventId.UIMainFlyReward, cfg)
  self.ctrl:CloseSelf()
  if self.battleManagerParam.enterType == PVEEnterType.Radar then
    DataCenter.ZombieBattleManager:Exit(nil, PveExitType.DetectEventExitBtn)
  elseif self.battleManagerParam.enterType == PVEEnterType.TowerupJeepAdventure then
    DataCenter.ZombieBattleManager:Exit(nil, PveExitType.TowerupExitBtn)
  else
    DataCenter.ZombieBattleManager:Exit(nil, PveExitType.ExitBtn)
  end
end

return UIZombieBattleWinView
