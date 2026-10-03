local SingleActivityContainerType2Ctrl = BaseClass("SingleActivityContainerType2Ctrl", UIBaseCtrl)

function SingleActivityContainerType2Ctrl:InitPanelStack()
  self.panelStack = {}
end

function SingleActivityContainerType2Ctrl:DestroyPanelStack()
  self.panelStack = nil
end

function SingleActivityContainerType2Ctrl:PushPanelInfo(activityId, activityClass, activityData)
  local info = {}
  info.activityId = activityId
  info.activityClass = activityClass
  info.activityData = activityData
  table.insert(self.panelStack, info)
end

function SingleActivityContainerType2Ctrl:GetCurPanelInfo()
  if self.panelStack and #self.panelStack > 0 then
    return self.panelStack[#self.panelStack]
  end
  return nil
end

function SingleActivityContainerType2Ctrl:GetPanelInfoByActivityId(activityId)
  for key, value in pairs(self.panelStack) do
    if value.activityId == activityId then
      return value
    end
  end
  return nil
end

function SingleActivityContainerType2Ctrl:CloseSelf()
  EventManager:GetInstance():Broadcast(EventId.SingleActivityContainerType2Close)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.SingleActivityContainerType2)
end

function SingleActivityContainerType2Ctrl:OnCustomKeyCodeEscape()
  if self.panelStack and #self.panelStack > 1 then
    table.remove(self.panelStack)
    EventManager:GetInstance():Broadcast(EventId.SingleActivityContainerType2ClosePanel)
  else
    self:CloseSelf()
  end
end

return SingleActivityContainerType2Ctrl
