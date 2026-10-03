local LWUITimelinePlotBridgeView = BaseClass("LWUITimelinePlotBridgeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function LWUITimelinePlotBridgeView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUITimelinePlotBridgeView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUITimelinePlotBridgeView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
end

function LWUITimelinePlotBridgeView:ComponentDestroy()
  self.viewSkin = nil
end

function LWUITimelinePlotBridgeView:DataDefine()
  self.param = self:GetUserData()
  if self.param == nil then
    self.ctrl:CloseSelf()
    return
  end
  self.timelinePlotId = self.param.plotId
  if self.timelinePlotId == nil then
    self.ctrl:CloseSelf()
    return
  end
end

function LWUITimelinePlotBridgeView:DataDestroy()
end

function LWUITimelinePlotBridgeView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SCREEN_TOUCH_DOWN_IGNORE_UI, self.OnClickScreen)
end

function LWUITimelinePlotBridgeView:OnRemoveListener()
  self:RemoveUIListener(EventId.SCREEN_TOUCH_DOWN_IGNORE_UI, self.OnClickScreen)
  base.OnRemoveListener(self)
end

function LWUITimelinePlotBridgeView:OnClickScreen()
  EventManager:GetInstance():Broadcast(EventId.TimelineInteractionPlotNext, self.timelinePlotId)
end

return LWUITimelinePlotBridgeView
