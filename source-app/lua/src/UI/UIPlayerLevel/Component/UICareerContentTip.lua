local UICareerContentTip = BaseClass("UICareerContentTip", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Screen = CS.UnityEngine.Screen
local this_path = ""
local bg_path = "Bg"
local name_path = "Bg/Name"
local desc_path = "Bg/Desc"
local require_title_path = "Bg/RequireTitle"
local require_path = "Bg/Require"
local arrow_path = "Arrow"
local close_path = "Close"
local trigger_path = "Trigger"
local EFFECT_COUNT = 3
local OFFSET_Y = 50
local SCREEN_PADDING = 20

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
  self.name_texts = {}
  self.desc_texts = {}
  for i = 1, EFFECT_COUNT do
    self.name_texts[i] = self:AddComponent(UIText, name_path .. i)
    self.desc_texts[i] = self:AddComponent(UIText, desc_path .. i)
  end
  self.require_title_text = self:AddComponent(UIText, require_title_path)
  self.require_title_text:SetLocalText(395013)
  self.require_text = self:AddComponent(UIText, require_path)
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
  self.name_texts = nil
  self.desc_texts = nil
  self.require_title_text = nil
  self.require_text = nil
  self.arrow_go = nil
  self.close_btn = nil
  self.event_trigger = nil
end

local function DataDefine(self)
  self.careerType = nil
  self.careerLv = nil
  self.bindGo = nil
  self.onDrag = nil
  self.onBeginDrag = nil
  self.onEndDrag = nil
  self.onPointerUp = nil
  self.active = false
  self.useTrigger = false
end

local function DataDestroy(self)
  self.careerType = nil
  self.careerLv = nil
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

local function SetData(self, careerType, careerLv, bindGo)
  self.careerType = careerType
  self.careerLv = careerLv
  self.bindGo = bindGo
  local careerTemplate = DataCenter.PlayerCareerManager:GetCareerTemplate(careerType, careerLv)
  local effectCount = 0
  if careerLv == 1 then
    effectCount = #careerTemplate.initEffectList
    for i, id in ipairs(careerTemplate.initEffectList) do
      local name, desc = DataCenter.PlayerCareerManager:GetEffectTip(id)
      self.name_texts[i]:SetText(name)
      self.desc_texts[i]:SetText(desc)
    end
  else
    effectCount = 1
    local id = careerTemplate.levelEffect
    local name, desc = DataCenter.PlayerCareerManager:GetEffectTip(id)
    self.name_texts[1]:SetText(name)
    self.desc_texts[1]:SetText(desc)
  end
  for i = 1, EFFECT_COUNT do
    self.name_texts[i]:SetActive(effectCount >= i)
    self.desc_texts[i]:SetActive(effectCount >= i)
  end
  local requireStrs = {}
  if 0 < careerTemplate.requirePlayerLv then
    table.insert(requireStrs, Localization:GetString("120986", careerTemplate.requirePlayerLv))
  end
  if not table.IsNullOrEmpty(careerTemplate.requireItemDict) then
    local str = DataCenter.PlayerCareerManager:GetRequireItemInfo(careerTemplate.requireItemDict)
    table.insert(requireStrs, str)
  end
  self.require_text:SetText(string.join(requireStrs, "\n"))
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

local function Show(self)
  self.anim:Enable(true)
  self.anim:Play("CommonPopup_movein", 0, 0)
  self.active = true
  if not self.useTrigger then
    self.close_btn:SetActive(true)
  end
  for i = 1, EFFECT_COUNT do
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.name_texts[i].transform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.desc_texts[i].transform)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.require_text.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bg_go.transform)
  if self.bindGo then
    self.anim.transform.position = self.bindGo.transform.position + Vector3.New(0, OFFSET_Y, 0)
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

UICareerContentTip.OnCreate = OnCreate
UICareerContentTip.OnDestroy = OnDestroy
UICareerContentTip.ComponentDefine = ComponentDefine
UICareerContentTip.ComponentDestroy = ComponentDestroy
UICareerContentTip.DataDefine = DataDefine
UICareerContentTip.DataDestroy = DataDestroy
UICareerContentTip.OnAddListener = OnAddListener
UICareerContentTip.OnRemoveListener = OnRemoveListener
UICareerContentTip.OnEnable = OnEnable
UICareerContentTip.OnDisable = OnDisable
UICareerContentTip.OnDrag = OnDrag
UICareerContentTip.OnBeginDrag = OnBeginDrag
UICareerContentTip.OnEndDrag = OnEndDrag
UICareerContentTip.OnPointerUp = OnPointerUp
UICareerContentTip.State = State
UICareerContentTip.SetData = SetData
UICareerContentTip.SetOnDrag = SetOnDrag
UICareerContentTip.Show = Show
UICareerContentTip.Hide = Hide
UICareerContentTip.AdjustScreen = AdjustScreen
return UICareerContentTip
