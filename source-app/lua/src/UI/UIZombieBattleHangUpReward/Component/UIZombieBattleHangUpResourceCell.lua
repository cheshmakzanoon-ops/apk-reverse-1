local UIZombieBattleHangUpResourceCell = BaseClass("UIZombieBattleHangUpResourceCell", UIBaseContainer)
local base = UIBaseContainer
local this_path = ""
local anim_path = "root"
local resource_icon_path = "root/resourceIcon"
local resource_num_path = "root/resourceNum"
local background_path = "root/Background"
local CountNumJumpTimes = 10
local ChangePerTime = 100
local DelayTime = 0.5
local PickUpEffectDestroyTime = 1.5
local DeleteTime = 2
local AnimName = {
  Play = "Play",
  PickUp = "Play1",
  Idle = "Idle"
}

function UIZombieBattleHangUpResourceCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIZombieBattleHangUpResourceCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIZombieBattleHangUpResourceCell:ComponentDefine()
  self.resource_icon = self:AddComponent(UIImage, resource_icon_path)
  self.anim = self:AddComponent(UIAnimator, anim_path)
  self.resource_num = self:AddComponent(UIText, resource_num_path)
  self.background = self:AddComponent(UIBaseContainer, background_path)
  self.resource_num_cachePos = self.resource_num:GetAnchoredPosition()
end

function UIZombieBattleHangUpResourceCell:ComponentDestroy()
  if self.resource_num_cachePos then
    self.resource_num:SetAnchoredPosition(self.resource_num_cachePos)
  end
  self.background:SetActive(true)
  self.resource_icon = nil
  self.anim = nil
  self.resource_num = nil
  self.background = nil
end

function UIZombieBattleHangUpResourceCell:DataDefine()
  self.param = {}
  self._resNumShow = 0
  self._resNumTarget = 0
  self._resNumDelta = 0
  self._lastSetTime = 0
  
  function self.delay_timer_action()
    self:DelayRefreshTimerBallBack()
  end
  
  function self.delete_timer_action()
    self:DeleteTimerBallBack()
  end
  
  self.deleteTimer = nil
  self.delayTimer = nil
  self.pickUpEffect = {}
end

function UIZombieBattleHangUpResourceCell:DataDestroy()
  self.param = {}
  self._resNumShow = 0
  self._resNumTarget = 0
  self._resNumDelta = 0
  self._lastSetTime = 0
  self.delay_timer_action = nil
  self.delayTimer = nil
  self.delete_timer_action = nil
  self.deleteTimer = nil
  self.pickUpEffect = {}
  self.resource_num_cachePos = nil
end

function UIZombieBattleHangUpResourceCell:ReInit(param)
  self.param = param
  self.resource_icon:LoadSprite(param.iconName)
  self._resNumTarget = param.resNum
  local numStr = self:FormatNum(self._resNumTarget, param.resType)
  self.resource_num:SetText(numStr .. "/h")
  self.resource_num:SetAnchoredPositionXY(90, -1)
  self.resource_num:SetSizeDelta({x = 130, y = 52})
end

function UIZombieBattleHangUpResourceCell:Refresh()
  self:DoResNumChange()
end

function UIZombieBattleHangUpResourceCell:OnEnable()
  base.OnEnable(self)
end

function UIZombieBattleHangUpResourceCell:OnDisable()
  base.OnDisable(self)
end

function UIZombieBattleHangUpResourceCell:DoResNumChange(delta)
  self._resNumTarget = self.param.resNum + delta
  if self._resNumShow ~= self._resNumTarget then
    self._resNumDelta = (self._resNumTarget - self._resNumShow) / CountNumJumpTimes
    if math.modf(self._resNumDelta) == 0 then
      self._resNumDelta = self._resNumDelta > 0 and 1 or -1
    else
      self._resNumDelta = math.modf(self._resNumDelta)
    end
    self._lastSetTime = UITimeManager:GetInstance():GetServerTime()
  else
    local numStr = self:FormatNum(self._resNumTarget, self.param.resType)
    self.resource_num:SetText(numStr)
  end
end

function UIZombieBattleHangUpResourceCell:SetTextColor(color)
  if self.resource_num ~= nil then
    self.resource_num:SetColor(color)
  end
end

function UIZombieBattleHangUpResourceCell:FormatNum(num, type)
  if type == ResourceType.People then
    if 10000 <= num then
      return string.GetFormattedStr(num)
    else
      return string.GetFormattedSeperatorNum(num)
    end
  else
    return string.GetFormattedStr(num)
  end
end

return UIZombieBattleHangUpResourceCell
