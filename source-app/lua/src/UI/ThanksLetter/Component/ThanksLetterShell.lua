local ThanksLetterShell = BaseClass("ThanksLetterShell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Letter = require("UI.ThanksLetter.Component.ThanksLetterItem")
local BirthdayLetterItem = require("UI.ThanksLetter.Component.BirthdayLetterItem")
local mask_area_path = "UnOpenConent/Root/MaskArea"
local open_letter_btn_path = "UnOpenConent/Root/OpenLetterBtn"
local letter_item_point_path = "UnOpenConent/Root/MaskArea/LetterItemPoint"

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
  if self.canvasGroup then
    self.canvasGroup:SetAlpha(0)
  end
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.maskRootObj = self:AddComponent(UIBaseContainer, mask_area_path)
  self.openLetterBtn = self:AddComponent(UIButton, open_letter_btn_path)
  self.openLetterBtn:SetOnClick(function()
    self:OpenLetter()
  end)
  self.letterAni = self:AddComponent(UISimpleAnimation, "")
  self.letterItemPoint = self:AddComponent(UIBaseContainer, letter_item_point_path)
  self.canvasGroup = self:AddComponent(UICanvasGroup, "")
end

local function ComponentDestroy(self)
  if self.letterPrefabReq then
    self.letterPrefabReq:Destroy()
    self.letterPrefabReq = nil
  end
  self:StopAllTimer()
end

local function DataDefine(self)
  self.isCompleteExpand = false
end

local function DataDestroy(self)
  self.isCompleteExpand = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function ThanksLetterShell:SetData(uuid, itemId, templateData, serverData, closeFunc)
  self:StopAllTimer()
  if not templateData then
    return
  end
  local letterContentPrefab = templateData.letter_content_prefab
  if string.IsNullOrEmpty(letterContentPrefab) then
    return
  end
  self.letterPrefabReq = self:GameObjectInstantiateAsync(letterContentPrefab, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    go.transform:SetParent(self.letterItemPoint.transform)
    go.transform:Set_localPosition(0, 0, 0)
    go.transform:Set_localScale(1, 1, 1)
    local prefabName = "LetterItem"
    go.transform.name = prefabName
    local targetComponent = Letter
    if templateData.letter_content_type == LetterContentType.Birthday then
      targetComponent = BirthdayLetterItem
    end
    self.letterItem = self:AddComponent(targetComponent, string.format("%s/%s", letter_item_point_path, prefabName))
    self.letterItem:SetData(uuid, itemId, templateData, serverData, closeFunc)
    local ret, time = self.letterAni:PlayAnimationReturnTime("FadeIn")
    if ret then
      self.shellIdleTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.shellIdleTimer = nil
        self.letterAni:Play("Idle")
      end, time)
    end
  end)
  self.openLetterBtn:SetActive(true)
end

function ThanksLetterShell:OpenLetter()
  if self.shellIdleTimer then
    self.shellIdleTimer:Stop()
    self.shellIdleTimer = nil
  end
  self.isCompleteExpand = false
  if not self.letterItem or not self.letterItem:isBannerLoadFinish() then
    return
  end
  local ret, time = self.letterAni:PlayAnimationReturnTime("Open")
  if ret then
    self.expandTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.isCompleteExpand = true
      self.expandTimer = nil
    end, time)
  else
    self.isCompleteExpand = true
  end
  if self.letterItem then
    self.letterItem:OnPlay()
  end
  self.openLetterBtn:SetActive(false)
end

function ThanksLetterShell:PlayCloseAniAndGetAniTime()
  if not self.letterItem then
    return
  end
  return self.letterItem:PlayCloseAniAndGetAniTime()
end

function ThanksLetterShell:StopAllTimer()
  if self.expandTimer then
    self.expandTimer:Stop()
    self.expandTimer = nil
  end
  if self.shellIdleTimer then
    self.shellIdleTimer:Stop()
    self.shellIdleTimer = nil
  end
end

ThanksLetterShell.OnCreate = OnCreate
ThanksLetterShell.OnDestroy = OnDestroy
ThanksLetterShell.OnEnable = OnEnable
ThanksLetterShell.OnDisable = OnDisable
ThanksLetterShell.ComponentDefine = ComponentDefine
ThanksLetterShell.ComponentDestroy = ComponentDestroy
ThanksLetterShell.DataDefine = DataDefine
ThanksLetterShell.DataDestroy = DataDestroy
ThanksLetterShell.OnAddListener = OnAddListener
ThanksLetterShell.OnRemoveListener = OnRemoveListener
return ThanksLetterShell
