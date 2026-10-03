local FarmGatherItem = BaseClass("FarmGatherItem", UIBaseContainer)
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
  if self.data.farmState == FarmStateType.Harvest or self.data.farmState == FarmStateType.HarvestSecond then
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

FarmGatherItem.OnDestroy = OnDestroy
FarmGatherItem.OnCreate = OnCreate
FarmGatherItem.OnEnable = OnEnable
FarmGatherItem.OnDisable = OnDisable
FarmGatherItem.OnDrag = OnDrag
FarmGatherItem.OnBeginDrag = OnBeginDrag
FarmGatherItem.OnEndDrag = OnEndDrag
FarmGatherItem.RefreshData = RefreshData
FarmGatherItem.SetPosition = SetPosition
FarmGatherItem.PlayMoveInAnimator = PlayMoveInAnimator
FarmGatherItem.PlayMoveOutAnimator = PlayMoveOutAnimator
return FarmGatherItem
