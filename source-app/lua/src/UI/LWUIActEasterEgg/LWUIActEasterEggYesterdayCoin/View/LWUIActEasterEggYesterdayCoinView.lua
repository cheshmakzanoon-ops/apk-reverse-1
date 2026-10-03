local LWUIActEasterEggYesterdayCoinView = BaseClass("LWUIActEasterEggYesterdayCoinView", UIBaseView)
local UnityCanvasGroup = typeof(CS.UnityEngine.CanvasGroup)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local timeBeforeFadeOut = 1.5
local TweenPosY = {
  Start = -50,
  Idle = 0,
  End = 50
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ResetItem()
  self:Show()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "Panel/CanvasNode/Bg/Title")
  self.textCoinNum = self:AddComponent(UITextMeshProUGUIEx, "Panel/CanvasNode/Bg/CoinNum")
  self.canvasGroup = self:AddComponent(UICanvasGroup, "Panel/CanvasNode")
end

local function ComponentDestroy(self)
  self.textTitle = nil
  self.textCoinNum = nil
  self.canvasGroup = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function FadeIn(self)
  self.canvasGroup.rectTransform:GetComponent(typeof(CS.UnityEngine.CanvasGroup)):DOFade(1, 0.3)
  self.canvasGroup.rectTransform:DOAnchorPosY(TweenPosY.Idle, 0.3)
end

local function ResetItem(self)
  self.canvasGroup:SetAlpha(0)
  self.canvasGroup.rectTransform:Set_localPosition(0, TweenPosY.Start, 0)
end

local function FadeOut(self, completeCallback)
  self.canvasGroup.rectTransform:GetComponent(typeof(CS.UnityEngine.CanvasGroup)):DOFade(0, 0.4):OnComplete(function()
    if completeCallback then
      completeCallback()
    end
  end):SetEase(CS.DG.Tweening.Ease.OutCubic)
  self.canvasGroup.rectTransform:DOAnchorPosY(TweenPosY.End, 0.4)
end

local function Show(self)
  self.textTitle:SetLocalText("")
  local activityData = DataCenter.ActEasterEggManager:GetActivityData()
  if not (activityData and activityData.fromLastReceive) or not activityData.fromLastReceive.historyNum then
    Logger.LogError("historyNum is nil")
  end
  self.textCoinNum:SetText(activityData.fromLastReceive.historyNum)
  self:FadeIn()
  if not self.timer then
    self.timer = TimerManager:GetInstance():GetTimer(timeBeforeFadeOut, self.TimerAction, self, false, false, false)
    self.timer:Start()
  end
end

local function TimerAction(self)
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self:FadeOut(function()
    self.ctrl:CloseSelf()
  end)
end

LWUIActEasterEggYesterdayCoinView.OnCreate = OnCreate
LWUIActEasterEggYesterdayCoinView.OnDestroy = OnDestroy
LWUIActEasterEggYesterdayCoinView.OnEnable = OnEnable
LWUIActEasterEggYesterdayCoinView.OnDisable = OnDisable
LWUIActEasterEggYesterdayCoinView.ComponentDefine = ComponentDefine
LWUIActEasterEggYesterdayCoinView.ComponentDestroy = ComponentDestroy
LWUIActEasterEggYesterdayCoinView.DataDefine = DataDefine
LWUIActEasterEggYesterdayCoinView.DataDestroy = DataDestroy
LWUIActEasterEggYesterdayCoinView.OnAddListener = OnAddListener
LWUIActEasterEggYesterdayCoinView.OnRemoveListener = OnRemoveListener
LWUIActEasterEggYesterdayCoinView.FadeIn = FadeIn
LWUIActEasterEggYesterdayCoinView.FadeOut = FadeOut
LWUIActEasterEggYesterdayCoinView.ResetItem = ResetItem
LWUIActEasterEggYesterdayCoinView.Show = Show
LWUIActEasterEggYesterdayCoinView.TimerAction = TimerAction
return LWUIActEasterEggYesterdayCoinView
