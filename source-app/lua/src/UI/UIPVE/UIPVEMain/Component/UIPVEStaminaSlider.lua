local UIPVEStaminaSlider = BaseClass("UIPVEStaminaSlider", UIBaseContainer)
local base = UIBaseContainer
local slider_path = "StaminaSlider"
local slider_text_path = "StaminaSliderText"
local no_stamina_effect_path = "VFX_ui_stamina_tiao"
local add_stamina_btn_path = "AddStaminaButton"
local max_add_per_frame = 1
local max_add_per_frame1 = 10
local this_path = ""

function UIPVEStaminaSlider:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

function UIPVEStaminaSlider:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIPVEStaminaSlider:ComponentDefine()
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider_text = self:AddComponent(UIText, slider_text_path)
  self.no_stamina_effect = self:AddComponent(UIBaseContainer, no_stamina_effect_path)
  self.self_btn = self:AddComponent(UIButton, this_path)
  self.self_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnStaminaClick()
  end)
  self.add_stamina_btn = self:AddComponent(UIButton, add_stamina_btn_path)
  self.add_stamina_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnStaminaClick()
  end)
end

function UIPVEStaminaSlider:OnStaminaClick(fromSlider)
  if not self.noClick then
    fromSlider = true
    local lackTab = {}
    local param = {}
    param.type = ResLackType.Res
    param.resType = ResourceType.PVE_STAMINA
    local maxNum = LuaEntry.Player:GetMaxPveStamina()
    if 0 < maxNum then
      maxNum = Mathf.Floor(maxNum)
    end
    param.targetNum = maxNum
    table.insert(lackTab, param)
    if fromSlider then
      GoToResLack.GoToItemResLackList(lackTab, nil, self.transform.position, nil, true)
    else
      GoToResLack.GoToItemResLackList(lackTab)
    end
  end
end

function UIPVEStaminaSlider:ComponentDestroy()
  self.slider = nil
  self.slider_text = nil
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  if self.delayTimer1 then
    self.delayTimer1:Stop()
    self.delayTimer1 = nil
  end
end

function UIPVEStaminaSlider:DataDefine()
  self.curShowNum = nil
  self.delayRefresh = nil
  self.noClick = false
  self.addSpeed = nil
end

function UIPVEStaminaSlider:DataDestroy()
  self.curShowNum = nil
  self.delayRefresh = nil
  self.noClick = false
end

function UIPVEStaminaSlider:OnEnable()
  base.OnEnable(self)
end

function UIPVEStaminaSlider:OnDisable()
  base.OnDisable(self)
end

function UIPVEStaminaSlider:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DelayRefreshPVEStamina, self.DelayRefreshPVEStamina)
end

function UIPVEStaminaSlider:OnRemoveListener()
  self:RemoveUIListener(EventId.DelayRefreshPVEStamina, self.DelayRefreshPVEStamina)
  base.OnRemoveListener(self)
end

function UIPVEStaminaSlider:DelayRefreshPVEStamina(param)
  local delayTime = 2.5
  local totalTime = 1
  if param ~= nil then
    delayTime = param.delayTime or delayTime
    totalTime = param.totalTime or totalTime
  end
  if self.addSpeed ~= nil then
    totalTime = delayTime + totalTime
    delayTime = 0
  end
  local nowStamina = LuaEntry.Player:GetCurPveStamina()
  local preStamina = self.curShowNum or LuaEntry.Player:GetCurPveStamina()
  self.addSpeed = (nowStamina - preStamina) / totalTime
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  if self.delayTimer == nil then
    self.delayRefresh = true
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.delayRefresh = false
      self.delayTimer:Stop()
      self.delayTimer = nil
    end, delayTime)
  end
end

function UIPVEStaminaSlider:ReInit()
  self:Refresh()
end

function UIPVEStaminaSlider:RefreshStaminaLater()
  local curNum = LuaEntry.Player:GetCurPveStamina()
  if self.curShowNum ~= nil and curNum > self.curShowNum then
    if self.delayTimer ~= nil then
      self.delayTimer:Stop()
      self.delayTimer = nil
    end
    if self.delayTimer == nil then
      self.delayRefresh = true
      self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.delayRefresh = false
        self.delayTimer:Stop()
        self.delayTimer = nil
      end, 0.2)
    end
  end
end

function UIPVEStaminaSlider:Refresh()
  if self.delayRefresh == true then
    return
  end
  local curNum = LuaEntry.Player:GetCurPveStamina()
  if self.curShowNum ~= curNum then
    local realShow = 0
    if self.curShowNum == nil then
      self.curShowNum = LuaEntry.Player:GetCurPveStamina()
      realShow = math.ceil(self.curShowNum)
    else
      local addPerFrame = max_add_per_frame
      if math.abs(curNum - self.curShowNum) > 50 then
        addPerFrame = max_add_per_frame1
      end
      if self.addSpeed ~= nil then
        local time = Time.deltaTime
        addPerFrame = self.addSpeed * time
      end
      addPerFrame = math.abs(addPerFrame)
      if curNum < self.curShowNum then
        self.curShowNum = self.curShowNum - addPerFrame
        self.curShowNum = math.max(self.curShowNum, curNum)
        realShow = math.ceil(self.curShowNum)
      else
        self.curShowNum = self.curShowNum + addPerFrame
        self.curShowNum = math.min(self.curShowNum, curNum)
        realShow = math.ceil(self.curShowNum)
      end
    end
    local maxNum = LuaEntry.Player:GetMaxPveStamina()
    if 0 < maxNum then
      local dur = realShow / maxNum
      self.slider:SetValue(dur)
      self.slider_text:SetLocalText(GameDialogDefine.SPLIT, realShow, maxNum)
    end
    if self.curShowNum <= 0 then
      self.no_stamina_effect:SetActive(true)
      DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.PveStaminaZero, SaveGuideDoneValue)
    else
      self.no_stamina_effect:SetActive(false)
    end
    if self.curShowNum <= 0 and DataCenter.BattleLevel ~= nil and DataCenter.BattleLevel:AutoShowEnergyPanel() then
      self.delayTimer1 = TimerManager:GetInstance():DelayInvoke(function()
        if self.delayTimer1 then
          self.delayTimer1:Stop()
          self.delayTimer1 = nil
        end
        self:OnStaminaClick(true)
        if DataCenter.BuildManager.MainLv <= 6 then
          local param = LuaEntry.Player.uid .. "_" .. math.ceil(UITimeManager:GetInstance():GetServerTime()) .. "_" .. DataCenter.BattleLevel.levelId
          DataCenter.GuideManager:SendLogMessage(DataCenter.BattleLevel.levelId, StatTTType.EngeryNotEnough, param)
        end
      end, 0.5)
    end
  else
    self.addSpeed = nil
  end
end

function UIPVEStaminaSlider:Update()
  self:Refresh()
end

function UIPVEStaminaSlider:SetStopRefresh(isStop)
  self.delayRefresh = isStop
  if not isStop then
    self:Refresh()
  end
end

function UIPVEStaminaSlider:SetNoClick(noClick)
  self.noClick = noClick
end

return UIPVEStaminaSlider
