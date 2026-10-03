local TouchInputController2 = BaseClass("TouchInputController2", UIBaseContainer)
local base = UIBaseContainer
local CSTouchInputController2 = typeof(CS.BitBenderGames.TouchInputController2)

local function OnCreate(self, ...)
  base.OnCreate(self)
  self.unity_touch_input_controller2 = self.gameObject:GetComponent(CSTouchInputController2)
  self.unity_touch_input_controller2:ClearAllEvent()
end

local function OnDestroy(self)
  self.unity_touch_input_controller2:ClearAllEvent()
  self.unity_touch_input_controller2 = nil
  base.OnDestroy(self)
end

local function OnDragStart(self, OnDragStart)
  self.unity_touch_input_controller2:SetOnDragStart(OnDragStart)
end

local function OnDragUpdate(self, OnDragUpdate)
  self.unity_touch_input_controller2:SetOnDragUpdate(OnDragUpdate)
end

local function OnDragStop(self, OnDragStop)
  self.unity_touch_input_controller2:SetOnDragStop(OnDragStop)
end

local function OnPinchStart(self, OnPinchStart)
  self.unity_touch_input_controller2:SetOnPinchStart(OnPinchStart)
end

local function OnPinchUpdate(self, OnPinchUpdate)
  self.unity_touch_input_controller2:SetOnPinchUpdate(OnPinchUpdate)
end

local function OnPinchStop(self, OnPinchStop)
  self.unity_touch_input_controller2:SetOnPinchStop(OnPinchStop)
end

local function OnInputClick(self, OnInputClick)
  self.unity_touch_input_controller2:SetOnInputClick(OnInputClick)
end

local function RestartDrag(self)
  self.unity_touch_input_controller2:RestartDrag()
end

local function GetIsDragging(self)
  return self.unity_touch_input_controller2.isDragging
end

local function GetIsPinching(self)
  return self.unity_touch_input_controller2.isPinching
end

TouchInputController2.OnCreate = OnCreate
TouchInputController2.OnDestroy = OnDestroy
TouchInputController2.OnDragUpdate = OnDragUpdate
TouchInputController2.OnDragStart = OnDragStart
TouchInputController2.OnDragStop = OnDragStop
TouchInputController2.OnPinchStart = OnPinchStart
TouchInputController2.OnPinchUpdate = OnPinchUpdate
TouchInputController2.OnPinchStop = OnPinchStop
TouchInputController2.OnInputClick = OnInputClick
TouchInputController2.RestartDrag = RestartDrag
TouchInputController2.GetIsDragging = GetIsDragging
TouchInputController2.GetIsPinching = GetIsPinching
return TouchInputController2
