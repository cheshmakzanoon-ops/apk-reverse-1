local UIScrollRectEventTrigger = BaseClass("UIScrollRectEventTrigger", UIBaseContainer)
local base = UIBaseContainer
local CSUIScrollItemEventTrigger = typeof(CS.UIScrollItemEventTrigger)

function UIScrollRectEventTrigger:OnCreate(...)
  base.OnCreate(self)
  self.unity_event_trigger = self.gameObject:GetComponent(CSUIScrollItemEventTrigger)
end

function UIScrollRectEventTrigger:OnDestroy()
  self.unity_event_trigger.onBeginDrag = nil
  self.unity_event_trigger.onDrag = nil
  self.unity_event_trigger.onDrop = nil
  self.unity_event_trigger.onEndDrag = nil
  self.unity_event_trigger.onPointerClick = nil
  self.unity_event_trigger.onPointerDown = nil
  self.unity_event_trigger.onPointerUp = nil
  self.unity_event_trigger = nil
  base.OnDestroy(self)
end

function UIScrollRectEventTrigger:OnBeginDrag(onBeginDrag)
  self.unity_event_trigger.onBeginDrag = onBeginDrag
end

function UIScrollRectEventTrigger:OnDrag(onDrag)
  self.unity_event_trigger.onDrag = onDrag
end

function UIScrollRectEventTrigger:onDrop(onDrop)
  self.unity_event_trigger.onDrop = onDrop
end

function UIScrollRectEventTrigger:OnEndDrag(onEndDrag)
  self.unity_event_trigger.onEndDrag = onEndDrag
end

function UIScrollRectEventTrigger:OnPointerDown(onPointerDown)
  self.unity_event_trigger.onPointerDown = onPointerDown
end

function UIScrollRectEventTrigger:OnPointerUp(onPointerUp)
  self.unity_event_trigger.onPointerUp = onPointerUp
end

function UIScrollRectEventTrigger:OnPointerClick(onPointerClick)
  self.unity_event_trigger.onPointerClick = onPointerClick
end

return UIScrollRectEventTrigger
