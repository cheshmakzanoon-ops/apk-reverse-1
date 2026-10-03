local UIPVEJoystickAim = BaseClass("UIPVEJoystickAim", UIBaseContainer)
local base = UIBaseContainer
local Touch = CS.BitBenderGames.TouchWrapper
local touch_path = "Touch"
local select_path = "Touch/TouchSelect"
local arrowRoot_path = "Touch/TouchArrowGo/DeltaGo"
local arrow_path = "Touch/TouchArrowGo/DeltaGo/TouchArrow"
local line_path = "Touch/TouchArrowGo/DeltaGo/Line"
local aim_path = "Touch/Aim"
local SelectRangeMax = 280
local SelectRangeMin = 70
local Sensitivity = -1.5
local Epsilon = 0.001

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self.scaleFactor = UIManager:GetInstance():GetScaleFactor()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.touch_go = self:AddComponent(UIBaseContainer, touch_path)
  self.arrow_go = self:AddComponent(UIBaseContainer, arrow_path)
  self.arrowRoot_go = self:AddComponent(UIBaseContainer, arrowRoot_path)
  self.aim_go = self:AddComponent(UIBaseContainer, aim_path)
  self.line_go = self:AddComponent(UIBaseContainer, line_path)
end

local function ComponentDestroy(self)
  self.touch_go = nil
  self.aim_go = nil
  self.arrow_go = nil
  self.arrowRoot_go = nil
  self.line_go = nil
end

local function DataDefine(self)
  self.fingers = {}
  self.curFinger = nil
  self.originX = 0
  self.originY = 0
  self.enabled = false
  self.camera = CS.UnityEngine.Camera.main
end

local function DataDestroy(self)
  self.fingers = nil
  self.curFinger = nil
  self.originX = nil
  self.originY = nil
  self.enabled = nil
  self.camera = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  self.enabled = true
  self.touch_go:SetActive(false)
end

local function Clear(self)
  self.fingers = {}
  self.curFinger = nil
  self.touch_go:SetActive(false)
end

local function SetEnabled(self, enabled)
  self.enabled = enabled
end

local function GetEnabled(self)
  return self.enabled
end

local function TouchPos(self, pos)
  local x = pos.x - self.originX
  local y = pos.y - self.originY
  x = x / self.scaleFactor
  y = y / self.scaleFactor
  local d = math.sqrt(x * x + y * y)
  if d < Epsilon then
    return 0, 0
  end
  local angle = Mathf.Atan2(y, x) * Mathf.Rad2Deg + 90
  self.arrowRoot_go.transform.localEulerAngles = Vector3.New(0, 0, angle)
  local scale = 1
  if d < SelectRangeMin then
    scale = SelectRangeMin / d
    d = SelectRangeMin
  elseif d > SelectRangeMax then
    scale = SelectRangeMax / d
    d = SelectRangeMax
  end
  self.line_go.transform.sizeDelta = Vector2.New(10, -Sensitivity * d - 90)
  self.arrow_go.transform.anchoredPosition = Vector2.New(0, -0.5 * d + 89)
  self.arrow_go.transform.sizeDelta = Vector2.New(356, d + 178)
  local aimLocalPos = Vector3.New(Sensitivity * scale * x, Sensitivity * scale * y, 0)
  self.aim_go.transform:Set_localPosition(aimLocalPos.x, aimLocalPos.y, 0)
  local screenPos = Vector3.New(aimLocalPos.x + self.originX, aimLocalPos.y + self.originY, 0)
  local mainCamera = self.camera
  local ray = mainCamera:ScreenPointToRay(screenPos + Vector3.forward)
  CS.UnityEngine.Debug.DrawRay(ray.origin, ray.origin + ray.direction * 1000)
  local t = ray.origin.y / ray.direction.y
  return ray.origin.x - t * ray.direction.x, ray.origin.z - t * ray.direction.z
end

local function UpdateFingers(self)
  local usingFingers = {}
  if Touch.TouchCount > 0 then
    for i = 0, Touch.TouchCount - 1 do
      local touch = Touch.Touches[i]
      local id = touch.FingerId
      usingFingers[id] = true
      if self.fingers[id] == nil then
        self.fingers[id] = {
          startPos = touch.Position,
          position = touch.Position,
          isDrag = false,
          valid = true,
          fingerId = id
        }
        if self.curFinger == nil then
          self.curFinger = self.fingers[id]
          self.curFinger.isDrag = true
        end
      else
        local finger = self.fingers[id]
        finger.position = touch.Position
        if not finger.isDrag and finger.valid and Vector3.Distance(finger.position, finger.startPos) > 15 then
          if self.curFinger ~= nil then
            self.curFinger.valid = false
          end
          finger.isDrag = true
          self.curFinger = finger
        end
      end
    end
  end
  for id, _ in pairs(self.fingers) do
    if usingFingers[id] == nil then
      self.fingers[id] = nil
      if self.curFinger ~= nil and self.curFinger.fingerId == id then
        self.curFinger = nil
      end
    end
  end
end

local function OnUpdate(self)
  if not self.enabled then
    return 0, 0
  end
  local oldFingerId = self.curFinger ~= nil and self.curFinger.fingerId or nil
  self:UpdateFingers()
  if self.curFinger ~= nil and oldFingerId ~= self.curFinger.fingerId then
    self:SetOriginPos()
    self.touch_go:SetActive(true)
    self.touch_go.transform:Set_position(self.originWorld.x, self.originWorld.y, 0)
  end
  if self.curFinger ~= nil then
    local vx, vz = self:TouchPos(self.curFinger.position)
    return vx, vz
  else
    self.touch_go:SetActive(false)
    return 0, 0
  end
end

local function SetOriginPos(self)
  local squadPos = DataCenter.ZombieBattleManager.squad:GetPosition()
  local mainCamera = self.camera
  local screenPos = mainCamera:WorldToScreenPoint(squadPos)
  self.originWorld = CS.CSUtils.WorldPositionToUISpacePosition(squadPos)
  self.originX = screenPos.x
  self.originY = screenPos.y
end

local function OnFingerDown(self)
  if not self.enabled then
    return
  end
  self:UpdateFingers()
  if self.curFinger ~= nil then
    self:SetOriginPos()
    self.touch_go:SetActive(true)
    self.touch_go.transform:Set_position(self.originWorld.x, self.originWorld.y, 0)
    self:TouchPos(self.curFinger.position)
  end
end

local function OnFingerUp(self)
  if not self.enabled then
    return
  end
  self:Clear()
end

local function OnHighView(self, isHighView)
  if not self.enabled then
    return
  end
  if isHighView then
    self:Clear()
  end
end

UIPVEJoystickAim.OnCreate = OnCreate
UIPVEJoystickAim.OnDestroy = OnDestroy
UIPVEJoystickAim.ComponentDefine = ComponentDefine
UIPVEJoystickAim.ComponentDestroy = ComponentDestroy
UIPVEJoystickAim.DataDefine = DataDefine
UIPVEJoystickAim.DataDestroy = DataDestroy
UIPVEJoystickAim.OnEnable = OnEnable
UIPVEJoystickAim.OnDisable = OnDisable
UIPVEJoystickAim.OnAddListener = OnAddListener
UIPVEJoystickAim.OnRemoveListener = OnRemoveListener
UIPVEJoystickAim.ReInit = ReInit
UIPVEJoystickAim.Clear = Clear
UIPVEJoystickAim.SetEnabled = SetEnabled
UIPVEJoystickAim.GetEnabled = GetEnabled
UIPVEJoystickAim.TouchPos = TouchPos
UIPVEJoystickAim.UpdateFingers = UpdateFingers
UIPVEJoystickAim.OnUpdate = OnUpdate
UIPVEJoystickAim.OnFingerDown = OnFingerDown
UIPVEJoystickAim.OnFingerUp = OnFingerUp
UIPVEJoystickAim.OnHighView = OnHighView
UIPVEJoystickAim.SetOriginPos = SetOriginPos
return UIPVEJoystickAim
