local UIPVEJoyStick = BaseClass("UIPVEJoyStick", UIBaseContainer)
local base = UIBaseContainer
local Touch = CS.BitBenderGames.TouchWrapper
local touch_path = "Touch"
local select_path = "Touch/TouchSelect"
local collect_path = "btnCollect"
local SelectRangeMax = 76
local Sensitivity = 6
local Epsilon = 0.001

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.touch_go = self:AddComponent(UIBaseContainer, touch_path)
  self.select_go = self:AddComponent(UIBaseContainer, select_path)
  self.collect_btn = self:AddComponent(UIButton, collect_path)
  self.collect_btn:SetOnClick(function()
    self:OnCollectClick()
  end)
end

local function ComponentDestroy(self)
  self.touch_go = nil
  self.select_go = nil
  self.collect_btn = nil
end

local function DataDefine(self)
  self.fingers = {}
  self.curFinger = nil
  self.originX = 0
  self.originY = 0
  self.enabled = false
end

local function DataDestroy(self)
  self.fingers = nil
  self.curFinger = nil
  self.originX = nil
  self.originY = nil
  self.enabled = nil
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
  self.collect_btn:SetActive(false)
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

local function ShowCollect(self, show)
  self.collect_btn:SetActive(show)
end

local function TouchPos(self, pos)
  local x = pos.x - self.originX
  local y = pos.y - self.originY
  local d = math.sqrt(x * x + y * y)
  if d < Epsilon then
    return 0, 0
  end
  local cos = x / d
  local sin = y / d
  local selectRange = math.min(d, SelectRangeMax)
  self.select_go.transform:Set_localPosition(selectRange * cos, selectRange * sin, 0)
  return Sensitivity * cos, Sensitivity * sin
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
    self.originX = self.curFinger.startPos.x
    self.originY = self.curFinger.startPos.y
    self.touch_go:SetActive(true)
    self.touch_go.transform:Set_position(self.originX, self.originY, 0)
    self.select_go.transform:Set_localPosition(0, 0, 0)
  end
  if self.curFinger ~= nil then
    local vx, vz = self:TouchPos(self.curFinger.position)
    return vx, vz
  else
    self.touch_go:SetActive(false)
    return 0, 0
  end
end

local function OnFingerDown(self)
  if not self.enabled then
    return
  end
  self:UpdateFingers()
  if self.curFinger ~= nil then
    self.originX = self.curFinger.startPos.x
    self.originY = self.curFinger.startPos.y
    self.touch_go:SetActive(true)
    self.touch_go.transform:Set_position(self.originX, self.originY, 0)
    self.select_go.transform:Set_localPosition(0, 0, 0)
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

local function OnCollectClick(self)
  DataCenter.BattleLevel:OnClickBtnCollect()
end

UIPVEJoyStick.OnCreate = OnCreate
UIPVEJoyStick.OnDestroy = OnDestroy
UIPVEJoyStick.ComponentDefine = ComponentDefine
UIPVEJoyStick.ComponentDestroy = ComponentDestroy
UIPVEJoyStick.DataDefine = DataDefine
UIPVEJoyStick.DataDestroy = DataDestroy
UIPVEJoyStick.OnEnable = OnEnable
UIPVEJoyStick.OnDisable = OnDisable
UIPVEJoyStick.OnAddListener = OnAddListener
UIPVEJoyStick.OnRemoveListener = OnRemoveListener
UIPVEJoyStick.ReInit = ReInit
UIPVEJoyStick.Clear = Clear
UIPVEJoyStick.SetEnabled = SetEnabled
UIPVEJoyStick.GetEnabled = GetEnabled
UIPVEJoyStick.ShowCollect = ShowCollect
UIPVEJoyStick.TouchPos = TouchPos
UIPVEJoyStick.UpdateFingers = UpdateFingers
UIPVEJoyStick.OnUpdate = OnUpdate
UIPVEJoyStick.OnFingerDown = OnFingerDown
UIPVEJoyStick.OnFingerUp = OnFingerUp
UIPVEJoyStick.OnHighView = OnHighView
UIPVEJoyStick.OnCollectClick = OnCollectClick
return UIPVEJoyStick
