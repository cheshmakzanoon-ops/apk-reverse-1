local base = require("DataCenter.LWGuideFlowManager.Behaviours.BehaviourBase")
local metatbl = {__index = base}
local behaviour = setmetatable({}, metatbl)
local wait_for_event = require("DataCenter.LWGuideFlowManager.Behaviours.wait_for_event")
behaviour.params = {
  {
    "number",
    "interactOffset"
  },
  {
    "number",
    "visualOffset"
  },
  {
    "number",
    "pointerStyle"
  },
  {
    "string",
    "nextEventName"
  }
}
behaviour.optionalParams = {
  {
    "string",
    "cancelEventName",
    "none"
  },
  {
    "number",
    "animDuration",
    0.25
  },
  {
    "number",
    "roundCorner",
    4
  },
  {
    "number",
    "fadeDist",
    10
  },
  {
    "number",
    "blockerExpireTime",
    999
  },
  {
    "number",
    "pointerOffsetX",
    0
  },
  {
    "number",
    "pointerOffsetY",
    0
  }
}

function behaviour:__Awake()
  wait_for_event.ParseNextEventParams(self)
  wait_for_event.ParseCancelEventParams(self)
  wait_for_event.InitNextEventListener(self)
  wait_for_event.InitCancelEventListener(self)
  
  function self.OnMaskOpened()
    UIManager:GetInstance():DisableInteractionBlocker(self.__blockerHandleID)
    self.__blockerHandleID = nil
  end
  
  self.maskParams = {}
end

function behaviour:Begin()
  local maskParams = {}
  maskParams.matParams = {}
  maskParams.matParams.color = Color(0, 0, 0, 0.8)
  maskParams.matParams.rcr = self.roundCorner
  maskParams.matParams.fade = self.fadeDist
  maskParams.matParams.inverse = true
  maskParams.target = nil
  maskParams.rect = nil
  maskParams.interactOffset = self.interactOffset
  maskParams.visualOffset = self.visualOffset
  maskParams.pointerStyle = self.pointerStyle
  maskParams.animDuration = self.animDuration
  maskParams.pointerOffsetX = self.pointerOffsetX
  maskParams.pointerOffsetY = self.pointerOffsetY
  if self.__SetupMaskParams ~= nil then
    local error = self:__SetupMaskParams(maskParams)
    if error then
      printError(self.name .. " __SetupMaskParams error: " .. error)
      self.canceled = true
      return
    end
  else
    printError(self.name .. " __SetupMaskParams not exists!")
    self.canceled = true
    return
  end
  EventManager:GetInstance():AddListener(EventId.GF_guide_mask_ready, self.OnMaskOpened)
  wait_for_event.Begin(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWGuideMask, {anim = false}, maskParams)
end

function behaviour:End()
  if self.__BeforeEnd then
    self:__BeforeEnd()
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWGuideMask)
  EventManager:GetInstance():RemoveListener(EventId.GF_guide_mask_ready, self.OnMaskOpened)
  wait_for_event.End(self)
end

return behaviour
