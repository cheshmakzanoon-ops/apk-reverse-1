local FarmIrrigateItem = BaseClass("FarmIrrigateItem", UIBaseContainer)
local base = UIBaseContainer
local img_path = "item"
local trigger_path = "Image"
local this_path = ""

local function OnCreate(self)
  base.OnCreate(self)
  self.img = self:AddComponent(UIImage, img_path)
  self.animator = self:AddComponent(UIAnimator, this_path)
  self.obj_canvas = self:AddComponent(UICanvasGroup, this_path)
  self.event_trigger = self:AddComponent(UIEventTrigger, trigger_path)
  self.event_trigger:OnBeginDrag(function(eventData)
    self:OnBeginDrag(eventData)
  end)
  self.event_trigger:OnDrag(function(eventData)
    self:OnDrag(eventData)
  end)
  self.event_trigger:OnEndDrag(function(eventData)
    self:OnEndDrag(eventData)
  end)
  self.event_trigger:OnPointerDown(function(eventData)
    self:OnPointerDown(eventData)
  end)
  self.event_trigger:OnPointerUp(function(eventData)
    self:OnPointerUp(eventData)
  end)
end

local function OnDestroy(self)
  self.animator = nil
  self.event_trigger = nil
  self.img = nil
  base.OnDestroy(self)
end

local function OnDrag(self, eventData)
  self.img.gameObject:SetActive(false)
  self.view:OnDragItem(eventData, self.data)
end

local function OnBeginDrag(self, eventData)
  if self.data.farmState == FarmStateType.Irrigate then
    self.view:OnBeginDragItem(eventData, self.data)
  end
end

local function OnEndDrag(self, eventData)
  self.view:OnEndDragItem(eventData, self.data)
  self.img.gameObject:SetActive(true)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshData(self, data)
  self:PlayMoveInAnimator()
  self.data = data
  if self.data ~= nil then
    self.img.gameObject:SetActive(true)
    self.img:LoadSprite(self.data.icon)
  end
end

local function OnPointerDown(self, eventData)
  if self.data ~= nil then
    local posX = self.img.transform.position.x
    local posY = self.img.transform.position.y
    self.view:OnHoldItem(self.data, posX, posY)
  end
end

local function OnPointerUp(self, eventData)
  self.view:OnCancelItem()
end

local function SetPosition(self, posX, posY)
  local v3 = self.transform.position
  v3.x = posX
  v3.y = posY
  self.transform.position = v3
end

local function PlayMoveInAnimator(self)
  self.animator:Play("UIFarmGather_movein", 0, 0)
end

local function PlayMoveOutAnimator(self)
  self.animator:Play("UIFarmGather_moveout", 0, 0)
end

FarmIrrigateItem.OnDestroy = OnDestroy
FarmIrrigateItem.OnCreate = OnCreate
FarmIrrigateItem.OnEnable = OnEnable
FarmIrrigateItem.OnDisable = OnDisable
FarmIrrigateItem.OnDrag = OnDrag
FarmIrrigateItem.OnBeginDrag = OnBeginDrag
FarmIrrigateItem.OnEndDrag = OnEndDrag
FarmIrrigateItem.RefreshData = RefreshData
FarmIrrigateItem.OnPointerDown = OnPointerDown
FarmIrrigateItem.OnPointerUp = OnPointerUp
FarmIrrigateItem.SetPosition = SetPosition
FarmIrrigateItem.PlayMoveInAnimator = PlayMoveInAnimator
FarmIrrigateItem.PlayMoveOutAnimator = PlayMoveOutAnimator
return FarmIrrigateItem
