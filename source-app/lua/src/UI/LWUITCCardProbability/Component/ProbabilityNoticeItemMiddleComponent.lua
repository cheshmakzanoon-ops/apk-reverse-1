local ProbabilityNoticeItemMiddleComponent = BaseClass("ProbabilityNoticeItemMiddleComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local TCCardProbItemComponent = require("UI.LWUITC.Component.TCCardProbItemComponent")
local content_path = "Content"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ClearCardItems()
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
  self.content = self:AddComponent(UIBaseContainer, content_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.items = {}
end

local function DataDestroy(self)
  self.items = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function ProbabilityNoticeItemMiddleComponent:ReInit(data, probItemTemplate)
  if not data then
    return
  end
  self.showCardDataList = data.data
  if not self.cardItems then
    self.cardItems = {}
  end
  for i = 1, #self.showCardDataList do
    local cardItem = self.cardItems[i]
    if not cardItem then
      cardItem = self:LoadComponentAsync(TCCardProbItemComponent, TCCardProbItemComponent.PrefabPath, self.content)
      self.cardItems[i] = cardItem
    end
    cardItem:SetData(self.showCardDataList[i].prob, self.showCardDataList[i].cardTmp)
    cardItem:SetActive(true)
  end
  if #self.showCardDataList < #self.cardItems then
    for i = #self.showCardDataList + 1, #self.cardItems do
      self.cardItems[i]:SetActive(false)
    end
  end
end

function ProbabilityNoticeItemMiddleComponent:ClearCardItems()
  for i = 1, #self.cardItems do
    self:RemoveAsyncComponent(self.cardItems[i])
  end
  self.cardItems = nil
end

ProbabilityNoticeItemMiddleComponent.OnCreate = OnCreate
ProbabilityNoticeItemMiddleComponent.OnDestroy = OnDestroy
ProbabilityNoticeItemMiddleComponent.OnEnable = OnEnable
ProbabilityNoticeItemMiddleComponent.OnDisable = OnDisable
ProbabilityNoticeItemMiddleComponent.ComponentDefine = ComponentDefine
ProbabilityNoticeItemMiddleComponent.ComponentDestroy = ComponentDestroy
ProbabilityNoticeItemMiddleComponent.DataDefine = DataDefine
ProbabilityNoticeItemMiddleComponent.DataDestroy = DataDestroy
ProbabilityNoticeItemMiddleComponent.OnAddListener = OnAddListener
ProbabilityNoticeItemMiddleComponent.OnRemoveListener = OnRemoveListener
return ProbabilityNoticeItemMiddleComponent
