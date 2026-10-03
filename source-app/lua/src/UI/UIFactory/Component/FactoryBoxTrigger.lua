local FactoryBoxTrigger = BaseClass("FactoryBoxTrigger", UIBaseContainer)
local base = UIBaseContainer
local this_path = ""

local function OnCreate(self)
  base.OnCreate(self)
  self.event_trigger = self:AddComponent(UIEventTrigger, this_path)
  self.event_trigger:OnPointerEnter(function(eventData)
    self:OnPointerEnter(eventData)
  end)
  self.event_trigger:OnPointerExit(function(eventData)
    self:OnPointerExit(eventData)
  end)
  self.event_trigger:OnDrag(function(eventData)
    self:OnDrag(eventData)
  end)
  self.event_trigger:OnBeginDrag(function(eventData)
    self:OnBeginDrag(eventData)
  end)
  self.event_trigger:OnEndDrag(function(eventData)
    self:OnEndDrag(eventData)
  end)
  self.event_trigger:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData)
  end)
  self.isAdd = false
  self.isDragging = false
end

local function OnDestroy(self)
  self.event_trigger = nil
  base.OnDestroy(self)
end

local function OnDrag(self, eventData)
  if self.isDragging then
    self.view:DragBox(eventData.position.x - self.currentX)
    self.currentX = eventData.position.x
  end
end

local function OnBeginDrag(self, eventData)
  self.isDragging = true
  self.currentX = eventData.position.x
end

local function OnPointerClick(self, eventData)
  self.view:OnPointerClick(eventData)
end

local function OnEndDrag(self, eventData)
  self.isDragging = false
end

local function OnPointerEnter(self, eventData)
  if self.isAdd == false then
    self.isAdd = true
    self.view:AddItemToBox()
  end
end

local function OnPointerExit(self, eventData)
  if self.isAdd == true then
    self.view:RemoveItemFromBox()
  end
  self.isAdd = false
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

FactoryBoxTrigger.OnDestroy = OnDestroy
FactoryBoxTrigger.OnCreate = OnCreate
FactoryBoxTrigger.OnEnable = OnEnable
FactoryBoxTrigger.OnDisable = OnDisable
FactoryBoxTrigger.OnPointerEnter = OnPointerEnter
FactoryBoxTrigger.OnPointerExit = OnPointerExit
FactoryBoxTrigger.OnDrag = OnDrag
FactoryBoxTrigger.OnBeginDrag = OnBeginDrag
FactoryBoxTrigger.OnEndDrag = OnEndDrag
FactoryBoxTrigger.OnPointerClick = OnPointerClick
return FactoryBoxTrigger
