local UIJoystick = BaseClass("UIJoystick", UIBaseView)
local base = UIBaseView
local Touch = CS.BitBenderGames.TouchWrapper
local AutoMoveDelta = 6
local TouchSelectRange = 76
local touch_direction_path = "TouchDirection"
local touch_select_path = "TouchDirection/TouchSelect"
local touch_arrow_go_path = "TouchDirection/TouchArrowGo"
local Input = CS.UnityEngine.Input

function UIJoystick:OnCreate()
  base.OnCreate(self)
  local x, y = self:GetUserData()
  self.originalTouchX = x
  self.originalTouchY = y
  self.perX = 0
  self.perY = 0
  self.touch_direction = self:AddComponent(UIEventTrigger, touch_direction_path)
  self.touch_direction.transform:Set_position(x, y, 0)
  self.touch_select = self:AddComponent(UIBaseContainer, touch_select_path)
  self.touch_select.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  self.touch_arrow_go = self:AddComponent(UIBaseContainer, touch_arrow_go_path)
  self.touch_arrow_go:SetActive(false)
  self.show_trigger_point = false
  self.fingers = {}
  self.currFinger = nil
  self:ProcessTouch()
  if self.currFinger ~= nil then
    self.originalTouchX = self.currFinger.startPos.x
    self.originalTouchY = self.currFinger.startPos.y
    if self.touch_select then
      self.touch_select.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    end
    if self.touch_direction ~= nil then
      self.touch_direction:SetActive(true)
      self.touch_direction.transform:Set_position(self.originalTouchX, self.originalTouchY, 0)
    end
    self:SetMovePosition(self.currFinger.position)
  end
end

function UIJoystick:OnDrag()
  self:SetMovePosition(eventData.position)
end

function UIJoystick:OnPointerDown(eventData)
  self.touch_arrow_go:SetActive(true)
  self:SetMovePosition(eventData.position)
end

function UIJoystick:OnPointerUp(eventData)
  self.touch_select.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  self.touch_arrow_go:SetActive(false)
end

function UIJoystick:ProcessTouch()
  local fingers = self.fingers
  local tmp = {}
  if Touch.TouchCount > 0 then
    local touchCount = Touch.TouchCount
    local touches = Touch.Touches
    local i = 0
    while touchCount > i do
      local touch = touches[i]
      local fingerId = touch.FingerId
      tmp[fingerId] = true
      if fingers[fingerId] == nil then
        fingers[fingerId] = {
          startPos = touch.Position,
          position = touch.Position,
          isDrag = false,
          valid = true,
          fingerId = fingerId
        }
        local ff = fingers[fingerId]
        if self.currFinger == nil then
          self.currFinger = fingers[fingerId]
          self.currFinger.isDrag = true
        end
      else
        local finger = fingers[fingerId]
        finger.position = touch.Position
        if not finger.isDrag and finger.valid and Vector3.Distance(finger.position, finger.startPos) > 15 then
          if self.currFinger ~= nil then
            self.currFinger.valid = false
          end
          finger.isDrag = true
          self.currFinger = finger
        end
      end
      i = i + 1
    end
  end
  for k, f in pairs(self.fingers) do
    if tmp[k] == nil then
      self.fingers[k] = nil
      if self.currFinger ~= nil and self.currFinger.fingerId == k then
        self.currFinger = nil
      end
    end
  end
end

function UIJoystick:SetMovePosition(pos)
  local x = pos.x - self.originalTouchX
  local y = pos.y - self.originalTouchY
  local per = math.sqrt(x * x + y * y)
  if per <= 1.0E-4 then
    return
  end
  self.perX = x / per
  self.perY = y / per
  local useRange = TouchSelectRange
  if per < TouchSelectRange then
    useRange = per
  end
  self.touch_select.transform:Set_localPosition(self.perX * useRange, self.perY * useRange, ResetPosition.z)
  local angle = math.atan(y, x) * 180 / math.pi
  if self.touch_arrow_go:GetActive() == false then
    self.touch_arrow_go:SetActive(true)
  end
  self.touch_arrow_go:SetEulerAnglesXYZ(0, 0, angle)
  CitySpaceMan:GetInstance():Walk(self.perX * AutoMoveDelta, self.perY * AutoMoveDelta)
end

function UIJoystick:OnDestroy()
  CitySpaceMan:GetInstance():StopWalk()
  base.OnDestroy(self)
end

function UIJoystick:Update()
  local oldFingerId
  if self.currFinger ~= nil then
    oldFingerId = self.currFinger.fingerId
  end
  self:ProcessTouch()
  if self.currFinger ~= nil and oldFingerId ~= self.currFinger.fingerId then
    self.originalTouchX = self.currFinger.startPos.x
    self.originalTouchY = self.currFinger.startPos.y
    if self.touch_select then
      self.touch_select.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    end
    if self.touch_direction ~= nil then
      self.touch_direction:SetActive(true)
      self.touch_direction.transform:Set_position(self.originalTouchX, self.originalTouchY, 0)
    end
  end
  if self.currFinger ~= nil then
    self:SetMovePosition(self.currFinger.position)
  end
end

return UIJoystick
