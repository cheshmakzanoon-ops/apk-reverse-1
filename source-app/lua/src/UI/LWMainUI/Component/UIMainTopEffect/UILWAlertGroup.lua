local UILWAlertGroup = BaseClass("UILWAlertGroup", UIBaseContainer)
local base = UIBaseContainer
local Camera = CS.UnityEngine.Camera
local resPath = {
  effectFrozen = "Assets/Main/Prefabs/Effect/Eff_Common_bingdong_01.prefab",
  effectFire = "Assets/Main/Prefabs/Effect/Eff_Common_huoyan_01.prefab",
  effectBloodyNight = "Assets/Main/Prefabs/Effect/Eff_Common_s4bloody_01.prefab",
  effectSwallow = "Assets/Main/SeasonRes/S6/Prefabs/Effect/Eff_ui_S6_ScreenEffect.prefab"
}
local flashingPveRedPath = "flashingPveRed"
local flashingPvpRedPath = "flashingPvpRed"
local flashingGreenPath = "flashingGreen"

function UILWAlertGroup:OnCreate()
  base.OnCreate(self)
  self.activeAlarmType = nil
  self.curEffectType = nil
  self:ComponentDefine()
end

function UILWAlertGroup:OnDestroy()
  self.hide = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlertGroup:ComponentDefine()
  self.flashingPveRed = self:AddComponent(UIBaseContainer, flashingPveRedPath)
  self.flashingPvpRed = self:AddComponent(UICanvas, flashingPvpRedPath)
  self.flashingGreen = self:AddComponent(UIBaseContainer, flashingGreenPath)
  self.canPlayPvpAlertSound = true
  self.playPvpAlertSoundTime = 0
  self.pvpAlertSoundId = LuaEntry.DataConfig:TryGetNum("pvp_alert_sfx_config", "k3", 0)
  self.pvpAlertSoundCD = LuaEntry.DataConfig:TryGetNum("pvp_alert_sfx_config", "k2", 10)
  self.lastPhase = nil
  self.isInBloodyNight = false
end

function UILWAlertGroup:ComponentDestroy()
  self.canPlayPvpAlertSound = nil
  self.playPvpAlertSoundTime = nil
  self.pvpAlertSoundId = nil
  self.pvpAlertSoundCD = nil
  self:DestroyTempEffect()
end

function UILWAlertGroup:OnEnable()
  base.OnEnable(self)
  local rectSize = self.rectTransform.rect
  self.scaleWidth = rectSize.width / DefaultScreenWidth
  self.scaleHeight = rectSize.height / DefaultScreenHeight
  self.flashingPveRed:SetLocalScaleXYZ(self.scaleWidth, self.scaleHeight, 1)
  self.flashingPvpRed:SetLocalScaleXYZ(self.scaleWidth, self.scaleHeight, 1)
  self.flashingGreen:SetLocalScaleXYZ(self.scaleWidth, self.scaleHeight, 1)
  self:MyBasePhaseChange()
  self:CheckAlOfficialSkillAlertEffect()
  self:TryAndBloodyNightEffect()
  self:CheckJungleTrialSwallowEffect()
end

function UILWAlertGroup:OnDisable()
  base.OnDisable(self)
  self:DestroyTempEffect()
end

function UILWAlertGroup:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.MyBasePhaseChange, self.MyBasePhaseChange)
  self:AddUIListener(EventId.AlOfficialSkillAlertEffect, self.CheckAlOfficialSkillAlertEffect)
  self:AddUIListener(EventId.BloodyNightActivityRefresh, self.OnBloodyNightChange)
  self:AddUIListener(EventId.OnEnterCrossServer, self.TryAndBloodyNightEffect)
  self:AddUIListener(EventId.JungleTrialWrapRefresh, self.CheckJungleTrialSwallowEffect)
  self:AddUIListener(EventId.SmallGameUIOpenClose, self.OnSmallGameUIOpenClose)
end

function UILWAlertGroup:OnRemoveListener()
  self:RemoveUIListener(EventId.MyBasePhaseChange, self.MyBasePhaseChange)
  self:RemoveUIListener(EventId.AlOfficialSkillAlertEffect, self.CheckAlOfficialSkillAlertEffect)
  self:RemoveUIListener(EventId.BloodyNightActivityRefresh, self.OnBloodyNightChange)
  self:RemoveUIListener(EventId.OnEnterCrossServer, self.TryAndBloodyNightEffect)
  self:RemoveUIListener(EventId.JungleTrialWrapRefresh, self.CheckJungleTrialSwallowEffect)
  self:RemoveUIListener(EventId.SmallGameUIOpenClose, self.OnSmallGameUIOpenClose)
  base.OnRemoveListener(self)
end

function UILWAlertGroup:CheckAlOfficialSkillAlertEffect()
  if self.activeAlarmType == nil then
    local storageCurExtra = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_ALARM_OPEN) == 1
    if not storageCurExtra then
      return
    end
    self.alertEffect = DataCenter.AllianceSkillManager:GetActiveEffectAlert(false, nil)
    if self.alertEffect ~= nil then
      self:ShowAlarmEffect(MarchTargetType.AOS_ALERT)
    end
  end
end

function UILWAlertGroup:HideAlarmEffect()
  self.activeAlarmType = nil
  self.curEffectType = nil
  self.flashingGreen:SetActive(false)
  self.flashingPveRed:SetActive(false)
  self.flashingPvpRed:SetActive(false)
  EventManager:GetInstance():Broadcast(EventId.AlOfficialSkillAlertEffect)
end

function UILWAlertGroup:ShowAlarmEffect(alarmType)
  local storageCurExtra = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_ALARM_OPEN) == 1
  if not storageCurExtra then
    return
  end
  if alarmType == nil then
    self:HideAlarmEffect()
    return
  end
  local isOn = CommonUtil.PlayerPrefsGetBool("ScreenEffects", true)
  if isOn then
    local effectType = AlarmType[alarmType]
    if effectType then
      if self.curEffectType ~= effectType then
        self.flashingGreen:SetActive(false)
        self.flashingPveRed:SetActive(false)
        self.flashingPvpRed:SetActive(false)
      end
      self.curEffectType = effectType
      if effectType == AlarmEffect.Pve then
        self.activeAlarmType = alarmType
        self.flashingPveRed:SetActive(true)
      elseif effectType == AlarmEffect.Pvp then
        self.activeAlarmType = alarmType
        self.flashingPvpRed:SetActive(true)
        self.flashingPvpRed:SetOverrideSorting(true)
        self.flashingPvpRed:SetSortingOrder(CanvasOrder.PvpAlarm)
        if Setting:GetBool(SettingKeys.PVPALERT, true) then
          self:PlayPvpAlertSound()
        end
      elseif effectType == AlarmEffect.Help then
      end
    end
  end
end

function UILWAlertGroup:PlayPvpAlertSound()
  if self.canPlayPvpAlertSound then
    DataCenter.LWSoundManager:PlaySound(self.pvpAlertSoundId, false)
    self.canPlayPvpAlertSound = false
    self.playPvpAlertSoundTime = 0
  end
end

function UILWAlertGroup:Update1000MS()
  if not self.canPlayPvpAlertSound then
    self.playPvpAlertSoundTime = self.playPvpAlertSoundTime + 1
    if self.playPvpAlertSoundTime > self.pvpAlertSoundCD then
      self.canPlayPvpAlertSound = true
    end
  end
  if self.alertEffect ~= nil then
    local effect = self.alertEffect
    if (effect == nil or effect.mask_finish or effect.activeTime <= UITimeManager:GetInstance():GetServerTime()) and self.activeAlarmType == MarchTargetType.AOS_ALERT then
      self:HideAlarmEffect()
    end
  end
end

function UILWAlertGroup:MyBasePhaseChange()
  if SeasonUtil.IsInSeasonSnowMode() then
    local conductor = DataCenter.TemperatureManager:GetMyBaseConductor()
    local phase = conductor and conductor.phase
    if phase == self.lastPhase then
      return
    end
    self.lastPhase = phase
    if phase then
      if phase == ThermalPhase.Frozen then
        self:LoadEffectOnMainCamera(resPath.effectFrozen)
        return
      end
      if phase == ThermalPhase.Fire then
        self:LoadEffectOnMainCamera(resPath.effectFire)
        return
      end
    end
  end
  self:DestroyTempEffect()
end

function UILWAlertGroup:TryAndBloodyNightEffect()
  if SeasonUtil.IsInSeasonDarknessMode(true) then
    local currentServerId = -1
    local crossServerId = LuaEntry.Player:GetCrossServerId()
    if crossServerId == -1 then
      currentServerId = LuaEntry.Player:GetSelfServerId()
    else
      currentServerId = crossServerId
    end
    local isBloodyNight = DataCenter.BloodyNightDataManager:IsBloodyNight(currentServerId)
    if self.isInBloodyNight ~= nil and self.isInBloodyNight ~= isBloodyNight then
      if isBloodyNight then
        self:LoadEffectOnMainCamera(resPath.effectBloodyNight)
      else
        self:DestroyTempEffect()
      end
      self.isInBloodyNight = isBloodyNight
    end
  end
end

function UILWAlertGroup:OnBloodyNightChange(serverId)
  if SeasonUtil.IsInSeasonDarknessMode(true) then
    local currentServerId = -1
    local crossServerId = LuaEntry.Player:GetCrossServerId()
    if crossServerId == -1 then
      currentServerId = LuaEntry.Player:GetSelfServerId()
    else
      currentServerId = crossServerId
    end
    if currentServerId == serverId then
      local isBloodyNight = DataCenter.BloodyNightDataManager:IsBloodyNight(currentServerId)
      if self.isInBloodyNight ~= isBloodyNight then
        if isBloodyNight then
          self:LoadEffectOnMainCamera(resPath.effectBloodyNight)
        else
          self:DestroyTempEffect()
        end
        self.isInBloodyNight = isBloodyNight
      end
    end
  end
end

function UILWAlertGroup:OnSmallGameUIOpenClose(bool)
  self:CheckJungleTrialSwallowEffect(bool)
end

function UILWAlertGroup:CheckJungleTrialSwallowEffect(isSmallGame)
  if SeasonUtil.IsInSeasonNineNationRainforestMode() then
    if isSmallGame == nil then
      isSmallGame = UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWGGGoGame) or UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWGGGoPvpGame)
    end
    local isSwallow = DataCenter.JungleTrialDataManager:IsMyBaseSwallow()
    if isSwallow and not isSmallGame then
      if self.curTempEffectPath ~= resPath.effectSwallow then
        self:LoadEffectOnMainUIBackGround(resPath.effectSwallow)
        self.curTempEffectPath = resPath.effectSwallow
      end
    elseif self.curTempEffectPath == resPath.effectSwallow then
      self:DestroyTempEffect()
      self.curTempEffectPath = nil
      self:CheckAlOfficialSkillAlertEffect()
    end
  end
end

function UILWAlertGroup:LoadEffectOnMainCamera(path)
  self:DestroyTempEffect()
  self.curTempEffectPath = path
  self.tempEffectHandle = CS.GameEntry.Resource:InstantiateAsync(path)
  self.tempEffectHandle:completed("+", function(req)
    if req.isError then
      return
    end
    if not Camera.main then
      req:Destroy()
      return
    end
    local go = req.gameObject
    local trans = go.transform
    trans:SetParent(Camera.main.transform)
    trans.transform:Reset()
    trans:Set_localScale(self.scaleWidth, self.scaleHeight, 1)
  end)
end

function UILWAlertGroup:LoadEffectOnMainUIBackGround(path)
  self:DestroyTempEffect()
  self.curTempEffectPath = path
  self.tempEffectHandle = CS.GameEntry.Resource:InstantiateAsync(path)
  self.tempEffectHandle:completed("+", function(req)
    if req.isError then
      return
    end
    if not Camera.main then
      req:Destroy()
      return
    end
    local go = req.gameObject
    local trans = go.transform
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIMain) then
      local mainUIView = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain).View
      if mainUIView then
        trans:SetParent(mainUIView.transform)
        trans:SetSiblingIndex(0)
        trans:Set_localScale(1, 1, 1)
        trans:Set_anchoredPosition(0, 0)
        trans:Set_offsetMin(0, 0)
        trans:Set_offsetMax(0, 0)
      else
        req:Destroy()
      end
    else
      req:Destroy()
    end
  end)
end

function UILWAlertGroup:DestroyTempEffect()
  if self.tempEffectHandle then
    self.tempEffectHandle:Destroy()
    self.tempEffectHandle = nil
    self.lastPhase = nil
    self.curTempEffectPath = nil
  end
end

return UILWAlertGroup
