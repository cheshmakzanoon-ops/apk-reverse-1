local UIMainResourceProgress = BaseClass("UIMainResourceProgress", UIBaseContainer)
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

function UIMainResourceProgress:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMainResourceProgress:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIMainResourceProgress:ComponentDefine()
  self.btn = self:AddComponent(UIButton, this_path)
  self.resource_icon = self:AddComponent(UIImage, resource_icon_path)
  self.anim = self:AddComponent(UIAnimator, anim_path)
  self.resource_num = self:AddComponent(UIText, resource_num_path)
  self.btn:SetOnClick(function()
    local resourceType = self.param.resourceType
    if self.param and type(self.param.OnClickResourceBtn) == "function" then
      CommonUtil.ProtectCall(function()
        self.param.OnClickResourceBtn(resourceType)
      end)
    elseif resourceType == ResourceType.BatteryPower then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPowerSource)
    elseif self.view ~= nil and self.view.ctrl ~= nil and self.view.ctrl.OnClickResourceBtn ~= nil then
      self.view.ctrl:OnClickResourceBtn(resourceType)
    end
    if self.power_slider ~= nil then
      self.power_slider:UpdateData()
    end
  end)
end

function UIMainResourceProgress:ComponentDestroy()
  self.btn = nil
  self.resource_icon = nil
  self.anim = nil
  self.resource_num = nil
  if self.DelayRefreshTimer then
    self.DelayRefreshTimer:Stop()
    self.DelayRefreshTimer = nil
  end
end

function UIMainResourceProgress:DataDefine()
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

function UIMainResourceProgress:DataDestroy()
  if self.param and self.param.resourceType == ResourceType.FLINT then
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
end

function UIMainResourceProgress:GetCntByResType()
  if self.param.showCount then
    return self.param.showCount
  elseif self.view ~= nil and self.view.ctrl ~= nil and self.view.ctrl.GetCntByResType ~= nil then
    return self.view.ctrl:GetCntByResType(self.param.resourceType)
  end
  return LuaEntry.Resource:GetCntByResType(self.param.resourceType)
end

function UIMainResourceProgress:ReInit(param)
  local resourceType = param.resourceType
  self:DeleteTimer()
  self:RemoveAllPickUpEffect()
  self:DeleteDelayRefreshTimer()
  self.param = param
  self.resourceType = resourceType
  self._resNumShow = self:GetCntByResType(resourceType)
  self._resNumTarget = self._resNumShow
  local numStr = self:FormatNum(self._resNumTarget, resourceType)
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
  self:CheckBatteryPower()
  EventManager:GetInstance():Broadcast(EventId.RefreshTopResSuc)
  if resourceType == ResourceType.FLINT then
    self:AddUIListener(EventId.RESOURCE_REDUCE_TICK, self.Refresh)
  end
end

function UIMainResourceProgress:CheckBatteryPower()
  if self.resourceType ~= ResourceType.BatteryPower and not string.IsNullOrEmpty(self.param.iconName) then
    self.resource_icon:SetActive(true)
    self.resource_icon:LoadSprite(self.param.iconName)
  end
  if self.resourceType == ResourceType.BatteryPower and SeasonUtil.GetSeasonType() == SeasonMapType.Darkness then
    if self.power_slider == nil then
      local luaPath = "UI.LWSeason4.Component.BatteryPowerSlider"
      local prefabPath = "Assets/Main/SeasonRes/S4/Prefabs/UI/Component/PowerSlider.prefab"
      self.power_slider = UIBaseComponent.LoadComponentAsync(self, luaPath, prefabPath, self.anim, function(view, go, lua, callback_param)
        if go and ComponentIsValid(self.resource_icon) then
          self.resource_icon:SetActive(false)
        end
      end)
      self.power_slider:SetTextComponent(self.resource_num)
      self.power_slider:SetLocalPositionXYZ(-66.5, -2.2, 0)
    end
    self.power_slider:UpdateData()
  end
end

function UIMainResourceProgress:Refresh(delay)
  self:DoResNumChange()
end

function UIMainResourceProgress:DoResNumChange()
  self._resNumTarget = self:GetCntByResType(self.param.resourceType)
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
  self:CheckBatteryPower()
end

function UIMainResourceProgress:Update()
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

function UIMainResourceProgress:AddDelayRefreshTimer()
  self:DeleteDelayRefreshTimer()
  self.delayTimer = TimerManager:GetInstance():GetTimer(DelayTime, self.delay_timer_action, self, true, false, false)
  self.delayTimer:Start()
end

function UIMainResourceProgress:DelayRefreshTimerBallBack()
  self:DeleteDelayRefreshTimer()
  local num = self:GetCntByResType(self.param.resourceType)
  local numStr = self:FormatNum(num, self.param.resourceType)
  self.resource_num:SetText(numStr)
end

function UIMainResourceProgress:DeleteDelayRefreshTimer()
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

function UIMainResourceProgress:GetResourcePos()
  return self.resource_icon.transform.position
end

function UIMainResourceProgress:ChangeParam(param)
  local resourceType = param.resourceType
  self.param = param
  self.resourceType = resourceType
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

function UIMainResourceProgress:AddOnePickEffect(param)
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

function UIMainResourceProgress:RemoveOnePickEffect(id)
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

function UIMainResourceProgress:RemoveAllPickUpEffect()
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

function UIMainResourceProgress:AddDeleteTimer()
  self:DeleteTimer()
  self.deleteTimer = TimerManager:GetInstance():GetTimer(DeleteTime, self.delete_timer_action, self, true, false, false)
  self.deleteTimer:Start()
end

function UIMainResourceProgress:DeleteTimerBallBack()
  self:DeleteTimer()
  if self.param.parent ~= nil then
    self.param.parent:RemoveOneResourceCell(self.param.resourceType)
  end
end

function UIMainResourceProgress:DeleteTimer()
  if self.deleteTimer ~= nil then
    self.deleteTimer:Stop()
    self.deleteTimer = nil
  end
end

function UIMainResourceProgress:SetTextColor(color)
  if self.resource_num ~= nil then
    self.resource_num:SetColor(color)
  end
end

function UIMainResourceProgress:FormatNum(num, type)
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

function UIMainResourceProgress:SetZero(param)
  self.param = param
  self:DeleteTimer()
  self:RemoveAllPickUpEffect()
  self:DeleteDelayRefreshTimer()
  self.iconAnim = self:AddComponent(UIAnimator, "root/resourceIcon")
  self.resource_icon:LoadSprite(param.iconName)
  self._resNumShow = 0
  self._resNumTarget = 0
  self.resource_num:SetText("0")
  self.anim:Play(AnimName.Idle, 0, 0)
  self.anim:Enable(false)
  self:Refresh()
end

function UIMainResourceProgress:SetData(param)
  self.param = param
  self:DeleteTimer()
  self:Refresh()
  self.iconAnim:Play("Eff_ui_beizengmen_jinbi_chupeng", 0, 0)
end

return UIMainResourceProgress
