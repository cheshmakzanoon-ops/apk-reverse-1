local UIMysteryFeatureProgress = BaseClass("UIMysteryFeatureProgress", UIBaseContainer)
local base = UIBaseContainer
local this_path = ""
local anim_path = "root"
local resourceIcon_path = "root/resourceIcon"
local resource_icon_path = "root/resourceIcon/icon"
local resource_gray_path = "root/resourceIcon/gray"
local collect_complete_path = "root/resourceIcon/complete"
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

function UIMysteryFeatureProgress:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMysteryFeatureProgress:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMysteryFeatureProgress:ComponentDefine()
  self.btn = self:AddComponent(UIButton, this_path)
  self.resource_icon = self:AddComponent(UIImage, resource_icon_path)
  self.resource_gray = self:AddComponent(UIImage, resource_gray_path)
  CS.UIGray.SetGray(self.resource_gray.transform, true, false)
  self.collect_complete = self:AddComponent(UIImage, collect_complete_path)
  self.anim = self:AddComponent(UIAnimator, anim_path)
  self.resource_num = self:AddComponent(UIText, resource_num_path)
  self.btn:SetOnClick(function()
    self.view.ctrl:OnClickResourceBtn(self.param.resourceType)
  end)
end

function UIMysteryFeatureProgress:ComponentDestroy()
  self.btn = nil
  self.resource_icon = nil
  self.resource_gray = nil
  self.collect_complete = nil
  self.anim = nil
  self.resource_num = nil
  self.iconAnim = nil
end

function UIMysteryFeatureProgress:DataDefine()
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

function UIMysteryFeatureProgress:DataDestroy()
  if self.param.resourceType == ResourceType.FLINT then
    self:AddUIListener(EventId.RESOURCE_REDUCE_TICK, self.Refresh)
  end
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
  if self.t ~= nil then
    self.t:Stop()
    self.t = nil
  end
end

function UIMysteryFeatureProgress:GetCntByResType()
  if self.param ~= nil and self.param.showCount then
    return self.param.showCount
  elseif self.view ~= nil and self.view.ctrl ~= nil then
    return self.view.ctrl:GetCntByResType(self.param.resourceType)
  else
    return 0
  end
end

function UIMysteryFeatureProgress:ReInit(param)
  self:DeleteTimer()
  self:RemoveAllPickUpEffect()
  self:DeleteDelayRefreshTimer()
  self.param = param
  self.resource_icon:LoadSprite(param.iconName)
  self.resource_gray:LoadSprite(param.iconName)
  self._resNumShow = self:GetCntByResType(self.param.resourceType)
  self._resNumTarget = self._resNumShow
  local numStr = self:FormatNum(self._resNumTarget, self.param.resourceType)
  self.resource_num:SetText(numStr)
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
  if param.resourceType == ResourceType.FLINT then
    self:AddUIListener(EventId.RESOURCE_REDUCE_TICK, self.Refresh)
  end
end

function UIMysteryFeatureProgress:StartLoopUpdate()
  if self.t ~= nil then
    self.t:Stop()
    self.t = nil
  end
  self:LoopUpdate()
end

function UIMysteryFeatureProgress:LoopUpdate()
  local showCount = 0
  local parkour, result = pcall(function()
    return DataCenter.LWBattleManager.logic:GetRemainUnitCount()
  end)
  if parkour then
    showCount = result
  elseif DataCenter.LWBattleManager.logic.playerGroupProxy ~= nil then
    showCount = DataCenter.LWBattleManager.logic.playerGroupProxy.lastPoint
  end
  if self.param.showCount ~= showCount then
    self.param.showCount = showCount
    self:DoUnitNumChange()
  end
  self.t = TimerManager:GetInstance():DelayInvoke(function()
    self:LoopUpdate()
  end, 0.5)
end

function UIMysteryFeatureProgress:Refresh()
  self:DoResNumChange()
end

function UIMysteryFeatureProgress:OnEnable()
  base.OnEnable(self)
end

function UIMysteryFeatureProgress:OnDisable()
  base.OnDisable(self)
end

function UIMysteryFeatureProgress:DoUnitNumChange()
  if self.param == nil or self.param.maxCount == nil or self.param.showCount == nil or self.param.showCount == nil then
    return
  end
  self._resNumTarget = self.param.showCount
  if self._resNumShow ~= self._resNumTarget then
    self._resNumDelta = (self._resNumTarget - self._resNumShow) / CountNumJumpTimes
    if math.modf(self._resNumDelta) == 0 then
      self._resNumDelta = self._resNumDelta > 0 and 1 or -1
    else
      self._resNumDelta = math.modf(self._resNumDelta)
    end
    self._lastSetTime = UITimeManager:GetInstance():GetServerTime()
  else
    self.resource_num:SetText(self._resNumTarget)
  end
  local rate = self._resNumTarget / self.param.maxCount
  self.resource_icon:SetFillAmount(rate)
  if 1 <= rate then
    self.collect_complete.gameObject:SetActive(true)
  else
    self.collect_complete.gameObject:SetActive(false)
  end
end

function UIMysteryFeatureProgress:DoResNumChange()
  self._resNumTarget = self:GetCntByResType()
  if self._resNumShow ~= self._resNumTarget then
    self._resNumDelta = (self._resNumTarget - self._resNumShow) / CountNumJumpTimes
    if math.modf(self._resNumDelta) == 0 then
      self._resNumDelta = self._resNumDelta > 0 and 1 or -1
    else
      self._resNumDelta = math.modf(self._resNumDelta)
    end
    self._lastSetTime = UITimeManager:GetInstance():GetServerTime()
  else
    local numStr = self:FormatNum(self._resNumTarget, self.param.resourceType)
    self.resource_num:SetText(numStr)
  end
  local rate = self._resNumTarget / self.param.maxCount
  self.resource_icon:SetFillAmount(rate)
  if 1 <= rate then
    self.collect_complete.gameObject:SetActive(true)
  else
    self.collect_complete.gameObject:SetActive(false)
  end
end

function UIMysteryFeatureProgress:Update()
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
      self.resource_num:SetText(string.GetFormattedSeperatorNum(self._resNumShow))
      if self._resNumShow == self._resNumTarget then
        self:AddDelayRefreshTimer()
      end
    end
  end
end

function UIMysteryFeatureProgress:AddDelayRefreshTimer()
  self:DeleteDelayRefreshTimer()
  self.delayTimer = TimerManager:GetInstance():GetTimer(DelayTime, self.delay_timer_action, self, true, false, false)
  self.delayTimer:Start()
end

function UIMysteryFeatureProgress:DelayRefreshTimerBallBack()
  self:DeleteDelayRefreshTimer()
  local num = self:GetCntByResType()
  local numStr = self:FormatNum(num, self.param.resourceType)
  self.resource_num:SetText(numStr)
end

function UIMysteryFeatureProgress:DeleteDelayRefreshTimer()
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function UIMysteryFeatureProgress:GetResourcePos()
  return self.resource_icon.transform.position
end

function UIMysteryFeatureProgress:ChangeParam(param)
  self.param.showCount = param.showCount
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

function UIMysteryFeatureProgress:AddOnePickEffect(param)
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

function UIMysteryFeatureProgress:RemoveOnePickEffect(id)
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

function UIMysteryFeatureProgress:RemoveAllPickUpEffect()
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

function UIMysteryFeatureProgress:AddDeleteTimer()
  self:DeleteTimer()
  self.deleteTimer = TimerManager:GetInstance():GetTimer(DeleteTime, self.delete_timer_action, self, true, false, false)
  self.deleteTimer:Start()
end

function UIMysteryFeatureProgress:DeleteTimerBallBack()
  self:DeleteTimer()
  if self.param.parent ~= nil then
    self.param.parent:RemoveOneResourceCell(self.param.resourceType)
  end
end

function UIMysteryFeatureProgress:DeleteTimer()
  if self.deleteTimer ~= nil then
    self.deleteTimer:Stop()
    self.deleteTimer = nil
  end
end

function UIMysteryFeatureProgress:SetTextColor(color)
  if self.resource_num ~= nil then
    self.resource_num:SetColor(color)
  end
end

function UIMysteryFeatureProgress:FormatNum(num, type)
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

function UIMysteryFeatureProgress:SetZero(param)
  self.param = param
  self:DeleteTimer()
  self:RemoveAllPickUpEffect()
  self:DeleteDelayRefreshTimer()
  self.iconAnim = self:AddComponent(UIAnimator, resourceIcon_path)
  self.resource_icon:LoadSprite(param.iconName)
  self.resource_gray:LoadSprite(param.iconName)
  if param.soldier then
    self:StartLoopUpdate()
  end
  self._resNumShow = 0
  self._resNumTarget = 0
  self.resource_num:SetText("0")
  self.anim:Play(AnimName.Idle, 0, 0)
  self.anim:Enable(false)
  self:Refresh()
end

function UIMysteryFeatureProgress:SetData(param)
  self.param.showCount = param.showCount
  self:DeleteTimer()
  self:Refresh()
  self.iconAnim:Play("Eff_ui_beizengmen_jinbi_chupeng", 0, 0)
end

return UIMysteryFeatureProgress
