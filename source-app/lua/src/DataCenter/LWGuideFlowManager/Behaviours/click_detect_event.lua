local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
behaviour.params = {
  {
    "number",
    "detectEventId"
  }
}

function behaviour:Begin()
  self.duration = 2
  self.__blockerHandleID = UIManager:GetInstance():EnableInteractionBlocker(2, 2)
  self.vfxHandle = DataCenter.LWGuideVFXManager:InstantiateAsync("Assets/Main/Prefabs/Guide/UIArrowFinger.prefab", self.OnVfxLoaded, self, self.duration, GuideVFXPriority.High)
end

function behaviour:Update(dt)
  if self.timer ~= nil and self.timer > 0 then
    self.timer = self.timer - dt
    if self.timer <= 0 then
      self.done = true
    end
  end
end

function behaviour:End()
  UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
  self.__blockerHandleID = nil
  self.vfxHandle = nil
end

function behaviour:OnVfxLoaded(handle)
  if handle.isError then
    self:LogError("load res failed:" .. self.resPath)
    self.done = true
    return
  end
  handle.gameObject.transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.Normal.Name).transform, false)
  local targetObj
  if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIDetectEvent) then
    local luaWindow = UIManager:GetInstance():GetWindow(UIWindowNames.UIDetectEvent)
    if luaWindow ~= nil and luaWindow.View ~= nil then
      targetObj = luaWindow.View:GetGuideBubbleByEventId(tonumber(self.detectEventId))
    end
  end
  if IsNull(targetObj) then
    if not IsNull(handle) then
      handle:Destroy()
    end
    return
  end
  handle.gameObject.transform.position = targetObj.position + self.offset
  handle.gameObject.transform.localScale = self.scale
  self.timer = self.duration
end

return behaviour
