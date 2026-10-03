local UILWSingleActivityContainerCtrl = BaseClass("UILWSingleActivityContainerCtrl", UIBaseCtrl)

function UILWSingleActivityContainerCtrl:InitPanelStack()
  self.panelStack = {}
end

function UILWSingleActivityContainerCtrl:DestroyPanelStack()
  self.panelStack = nil
end

function UILWSingleActivityContainerCtrl:PushPanelInfo(activityId, activityClass, activityData, titleTxt, param)
  local info = {}
  info.activityId = activityId
  info.activityClass = activityClass
  info.activityData = activityData
  info.titleTxt = titleTxt
  info.param = param
  table.insert(self.panelStack, info)
end

function UILWSingleActivityContainerCtrl:GetCurPanelInfo()
  if self.panelStack and #self.panelStack > 0 then
    return self.panelStack[#self.panelStack]
  end
  return nil
end

function UILWSingleActivityContainerCtrl:GetPanelInfoByActivityId(activityId)
  for key, value in pairs(self.panelStack) do
    if value.activityId == activityId then
      return value
    end
  end
  return nil
end

function UILWSingleActivityContainerCtrl:CloseSelf()
  EventManager:GetInstance():Broadcast(EventId.UILWSingleActivityContainerClose)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSingleActivityContainer)
end

function UILWSingleActivityContainerCtrl:OnCustomKeyCodeEscape()
  if self.panelStack and #self.panelStack > 1 then
    table.remove(self.panelStack)
    EventManager:GetInstance():Broadcast(EventId.UILWSingleActivityContainerClosePanel)
  else
    self:CloseSelf()
  end
end

function UILWSingleActivityContainerCtrl:GetCntByResType(resourceType)
  if DataCenter.ItemTemplateManager:GetItemTemplate(resourceType) ~= nil then
    local item = DataCenter.ItemData:GetItemById(resourceType)
    if item ~= nil then
      return item.count
    end
    return 0
  end
  return LuaEntry.Resource:GetCntByResType(resourceType)
end

function UILWSingleActivityContainerCtrl:OnClickResourceBtn(resourceType)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWResourceInfo, {anim = true}, resourceType)
end

return UILWSingleActivityContainerCtrl
