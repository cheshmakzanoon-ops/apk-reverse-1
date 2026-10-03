local UICareerEffectTip = BaseClass("UICareerEffectTip", UIBaseContainer)
local base = UIBaseContainer
local Screen = CS.UnityEngine.Screen
local this_path = ""
local bg_path = "Bg"
local name_path = "Bg/Name"
local desc_path = "Bg/Desc"
local arrow_path = "Arrow"
local close_path = "Close"
local trigger_path = "Trigger"
local SCREEN_PADDING = 20
local Direction = {Up = 1, Down = 2}

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.anim = self:AddComponent(UIAnimator, this_path)
  self.canvas_group = self:AddComponent(UICanvasGroup, this_path)
  self.bg_go = self:AddComponent(UIBaseContainer, bg_path)
  self.name_text = self:AddComponent(UIText, name_path)
  self.desc_text = self:AddComponent(UIText, desc_path)
  self.arrow_go = self:AddComponent(UIBaseContainer, arrow_path)
  self.close_btn = self:AddComponent(UIButton, close_path)
  self.close_btn:SetOnClick(function()
    self:Hide()
  end)
  self.event_trigger = self:AddComponent(UIEventTrigger, trigger_path)
  self.event_trigger:OnDrag(function(eventData)
    self:OnDrag(eventData)
  end)
  self.event_trigger:OnBeginDrag(function(eventData)
    self:OnBeginDrag(eventData)
  end)
  self.event_trigger:OnEndDrag(function(eventData)
    self:OnEndDrag(eventData)
  end)
  self.event_trigger:OnPointerUp(function(eventData)
    self:OnPointerUp(eventData)
  end)
  self.event_trigger:SetActive(false)
end

local function ComponentDestroy(self)
  self.anim = nil
  self.canvas_group = nil
  self.bg_go = nil
  self.name_text = nil
  self.desc_text = nil
  self.arrow_go = nil
  self.close_btn = nil
  self.event_trigger = nil
end

local function DataDefine(self)
  self.bindGo = nil
  self.onDrag = nil
  self.onBeginDrag = nil
  self.onEndDrag = nil
  self.onPointerUp = nil
  self.active = false
  self.useTrigger = false
end

local function DataDestroy(self)
  self.bindGo = nil
  self.onDrag = nil
  self.onBeginDrag = nil
  self.onEndDrag = nil
  self.onPointerUp = nil
  self.active = nil
  self.useTrigger = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnDrag(self, eventData)
  if self.onDrag then
    self.onDrag(eventData)
  end
end

local function OnBeginDrag(self, eventData)
  if self.onBeginDrag then
    self.onBeginDrag(eventData)
  end
  self:Hide()
end

local function OnEndDrag(self, eventData)
  if self.onEndDrag then
    self.onEndDrag(eventData)
  end
end

local function OnPointerUp(self, eventData)
  if self.onPointerUp then
    self.onPointerUp(eventData)
  end
end

local function SetData(self, name, desc, bindGo)
  self.bindGo = bindGo
  if not string.IsNullOrEmpty(name) then
    self.name_text:SetText(name)
    self.name_text:SetActive(true)
  else
    self.name_text:SetActive(false)
  end
  if not string.IsNullOrEmpty(desc) then
    self.desc_text:SetText(desc)
    self.desc_text:SetActive(true)
  else
    self.desc_text:SetActive(false)
  end
end

local function SetOnDrag(self, onDrag, onBeginDrag, onEndDrag, onPointerUp)
  self.close_btn:SetActive(false)
  self.event_trigger:SetActive(true)
  self.useTrigger = true
  self.onDrag = onDrag
  self.onBeginDrag = onBeginDrag
  self.onEndDrag = onEndDrag
  self.onPointerUp = onPointerUp
end

local function Show(self, dir, offset)
  dir = dir or Direction.Up
  offset = offset or Vector2.New(0, 0)
  self.anim:Enable(true)
  self.anim:Play("CommonPopup_movein", 0, 0)
  self.active = true
  if not self.useTrigger then
    self.close_btn:SetActive(true)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.name_text.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.desc_text.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bg_go.transform)
  if self.bindGo then
    if dir == Direction.Down then
      self.arrow_go.transform.localScale = Vector3.New(1, -1, 1)
      self.bg_go.rectTransform.pivot = Vector2.New(0.5, 1)
      self.bg_go.rectTransform.anchoredPosition = Vector2.New(0, -2.5)
    else
      self.arrow_go.transform.localScale = Vector3.New(1, 1, 1)
      self.bg_go.rectTransform.pivot = Vector2.New(0.5, 0)
      self.bg_go.rectTransform.anchoredPosition = Vector2.New(0, 2.5)
    end
    self.anim.transform.position = self.bindGo.transform.position + offset
  end
  self:AdjustScreen()
end

local function Hide(self, immediate)
  if immediate then
    self.anim:Enable(false)
    self.canvas_group:SetAlpha(0)
  elseif self.active then
    self.anim:Enable(true)
    self.anim:Play("CommonPopup_moveout", 0, 0)
  end
  self.active = false
  if not self.useTrigger then
    self.close_btn:SetActive(false)
  end
end

local function AdjustScreen(self)
  local width = self.bg_go.rectTransform.sizeDelta.x * GetStandardScale()
  local left = width / 2 + SCREEN_PADDING
  local right = Screen.width - width / 2 - SCREEN_PADDING
  if left > self.bg_go.transform.position.x then
    self.bg_go.transform.position = Vector3.New(left, self.bg_go.transform.position.y)
  elseif right < self.bg_go.transform.position.x then
    self.bg_go.transform.position = Vector3.New(right, self.bg_go.transform.position.y)
  end
end

UICareerEffectTip.OnCreate = OnCreate
UICareerEffectTip.OnDestroy = OnDestroy
UICareerEffectTip.ComponentDefine = ComponentDefine
UICareerEffectTip.ComponentDestroy = ComponentDestroy
UICareerEffectTip.DataDefine = DataDefine
UICareerEffectTip.DataDestroy = DataDestroy
UICareerEffectTip.OnAddListener = OnAddListener
UICareerEffectTip.OnRemoveListener = OnRemoveListener
UICareerEffectTip.OnEnable = OnEnable
UICareerEffectTip.OnDisable = OnDisable
UICareerEffectTip.OnDrag = OnDrag
UICareerEffectTip.OnBeginDrag = OnBeginDrag
UICareerEffectTip.OnEndDrag = OnEndDrag
UICareerEffectTip.OnPointerUp = OnPointerUp
UICareerEffectTip.Direction = Direction
UICareerEffectTip.State = State
UICareerEffectTip.SetData = SetData
UICareerEffectTip.SetOnDrag = SetOnDrag
UICareerEffectTip.Show = Show
UICareerEffectTip.Hide = Hide
UICareerEffectTip.AdjustScreen = AdjustScreen
return UICareerEffectTip
