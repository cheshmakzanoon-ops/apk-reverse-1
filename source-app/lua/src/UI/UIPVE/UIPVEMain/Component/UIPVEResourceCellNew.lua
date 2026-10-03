local UIPVEResourceCellNew = BaseClass("UIPVEResourceCellNew", UIBaseContainer)
local base = UIBaseContainer
local this_path = ""
local anim_path = "root"
local resource_icon_path = "root/resourceIcon"
local resource_num_path = "root/resourceNum"
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

function UIPVEResourceCellNew:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIPVEResourceCellNew:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIPVEResourceCellNew:ComponentDefine()
  self.btn = self:AddComponent(UIButton, this_path)
  self.resource_icon = self:AddComponent(UIImage, resource_icon_path)
  self.anim = self:AddComponent(UIAnimator, anim_path)
  self.resource_num = self:AddComponent(UIText, resource_num_path)
end

function UIPVEResourceCellNew:ComponentDestroy()
  self.btn = nil
  self.resource_icon = nil
  self.anim = nil
  self.resource_num = nil
end

function UIPVEResourceCellNew:DataDefine()
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

function UIPVEResourceCellNew:DataDestroy()
  self:DeleteTimer()
  self:RemoveAllPickUpEffect()
  self:DeleteDelayRefreshTimer()
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
end

function UIPVEResourceCellNew:ReInit(param)
  self:DeleteTimer()
  self:RemoveAllPickUpEffect()
  self:DeleteDelayRefreshTimer()
  self.param = param
  self.resource_icon:LoadSprite(param.iconName)
  self._resNumShow = DataCenter.BattleLevel:GetResourceItemCountByResType(self.param.resourceType)
  self._resNumTarget = self._resNumShow
  self:SetNumText(self._resNumTarget)
  if self.param.showExpandAnimation then
    self.anim:SetTrigger(AnimName.Play)
    self:AddDeleteTimer()
    if self.param.showExpandParam ~= nil then
      self:AddOnePickEffect(self.param.showExpandParam)
    end
  else
    self.anim:Play(AnimName.Idle, 0, 0)
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshTopResSuc)
end

function UIPVEResourceCellNew:Refresh()
  self:DoResNumChange()
end

function UIPVEResourceCellNew:OnEnable()
  base.OnEnable(self)
end

function UIPVEResourceCellNew:OnDisable()
  base.OnDisable(self)
end

function UIPVEResourceCellNew:DoResNumChange()
  self._resNumTarget = DataCenter.BattleLevel:GetResourceItemCountByResType(self.param.resourceType)
  if self._resNumShow ~= self._resNumTarget then
    self._resNumDelta = (self._resNumTarget - self._resNumShow) / CountNumJumpTimes
    if math.modf(self._resNumDelta) == 0 then
      self._resNumDelta = self._resNumDelta > 0 and 1 or -1
    else
      self._resNumDelta = math.modf(self._resNumDelta)
    end
    self._lastSetTime = UITimeManager:GetInstance():GetServerTime()
  else
    self:SetNumText(self._resNumTarget)
  end
end

function UIPVEResourceCellNew:Update()
  if self._resNumShow ~= self._resNumTarget then
    local tempT = UITimeManager:GetInstance():GetServerTime()
    if tempT - self._lastSetTime >= ChangePerTime then
      self._lastSetTime = tempT
      self._resNumShow = self._resNumShow + self._resNumDelta
      if self._resNumDelta > 0 and self._resNumShow > self._resNumTarget then
        self._resNumShow = self._resNumTarget
      elseif self._resNumDelta < 0 and self._resNumShow < self._resNumTarget then
        self._resNumShow = self._resNumTarget
      end
      self:SetNumText(self._resNumShow)
      if self._resNumShow == self._resNumTarget then
        self:AddDelayRefreshTimer()
      end
    end
  end
end

function UIPVEResourceCellNew:AddDelayRefreshTimer()
  self:DeleteDelayRefreshTimer()
  self.delayTimer = TimerManager:GetInstance():GetTimer(DelayTime, self.delay_timer_action, self, true, false, false)
  self.delayTimer:Start()
end

function UIPVEResourceCellNew:DelayRefreshTimerBallBack()
  self:DeleteDelayRefreshTimer()
  self:SetNumText(DataCenter.BattleLevel:GetResourceItemCountByResType(self.param.resourceType))
end

function UIPVEResourceCellNew:DeleteDelayRefreshTimer()
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function UIPVEResourceCellNew:GetResourcePos()
  return self.resource_icon.transform.position
end

function UIPVEResourceCellNew:ChangeParam(param)
  self.param = param
  self.resource_icon:LoadSprite(param.iconName)
  self:DeleteTimer()
  if self.param.showExpandAnimation then
    self.anim:SetTrigger(AnimName.PickUp)
    if self.param.showExpandParam ~= nil then
      self:AddOnePickEffect(self.param.showExpandParam)
    end
  else
    self.anim:Play(AnimName.Idle, 0, 0)
  end
  self:Refresh()
end

function UIPVEResourceCellNew:AddOnePickEffect(param)
  local effectPath = ResourceTypePickUpEffectName({
    self.param.resourceType
  })
  if effectPath ~= nil then
    local id = NameCount
    NameCount = NameCount + 1
    self.pickUpEffect[id] = {}
    self.pickUpEffect[id].inst = self:GameObjectInstantiateAsync(effectPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      if param ~= nil then
        UIUtil.DoFly(param.rewardTyp, param.num, param.pic, param.screenPos, param.flyPos, 66, 66, nil, param.useTextFormat)
      end
      go:SetActive(true)
      go.transform:SetParent(self.resource_icon.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      self.pickUpEffect[id].timer = TimerManager:GetInstance():DelayInvoke(function()
        self:RemoveOnePickEffect(id)
      end, PickUpEffectDestroyTime)
    end)
  end
end

function UIPVEResourceCellNew:RemoveOnePickEffect(id)
  if self.pickUpEffect[id] ~= nil then
    if self.pickUpEffect[id].timer ~= nil then
      self.pickUpEffect[id].timer:Stop()
      self.pickUpEffect[id].timer = nil
    end
    if self.pickUpEffect[id].inst ~= nil then
      self:GameObjectDestroy(self.pickUpEffect[id].inst)
    end
    self.pickUpEffect[id] = nil
  end
end

function UIPVEResourceCellNew:RemoveAllPickUpEffect()
  for k, v in pairs(self.pickUpEffect) do
    if v.timer ~= nil then
      v.timer:Stop()
      v.timer = nil
    end
    if v.inst ~= nil then
      self:GameObjectDestroy(v.inst)
    end
  end
  self.pickUpEffect = {}
end

function UIPVEResourceCellNew:AddDeleteTimer()
  self:DeleteTimer()
  self.deleteTimer = TimerManager:GetInstance():GetTimer(DeleteTime, self.delete_timer_action, self, true, false, false)
  self.deleteTimer:Start()
end

function UIPVEResourceCellNew:DeleteTimerBallBack()
  self:DeleteTimer()
end

function UIPVEResourceCellNew:DeleteTimer()
  if self.deleteTimer ~= nil then
    self.deleteTimer:Stop()
    self.deleteTimer = nil
  end
end

function UIPVEResourceCellNew:GetFlyNode()
  return self.resource_icon
end

function UIPVEResourceCellNew:SetNumText(num)
  if num < 10000 then
    self.resource_num:SetText(string.GetFormattedSeperatorNum(num))
  else
    self.resource_num:SetText(string.GetFormattedStr(num))
  end
end

return UIPVEResourceCellNew
