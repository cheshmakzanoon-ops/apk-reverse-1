local SeasonFrozenStatus = BaseClass("SeasonFrozenStatus", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local btn_info_path = "btnInfo"
local phase_changing_path = "PhaseChanging"
local phase_changing_icon_path = "PhaseChanging/PhaseChangingIcon"
local phase_changing_txt_path = "PhaseChanging/PhaseChangingTxt"
local frozen_path = "Frozen"
local frozen_icon_path = "Frozen/FrozenIcon"
local frozen_txt_path = "Frozen/FrozenTxt"
local frozen_pro_path = "Frozen/FrozenPro"
local frozen_value_path = "Frozen/FrozenValue"

function SeasonFrozenStatus:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function SeasonFrozenStatus:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonFrozenStatus:ComponentDefine()
  self.btn_info = self:AddComponent(UIButton, btn_info_path)
  self.phase_changing = self:AddComponent(UIBaseContainer, phase_changing_path)
  self.phase_changing_icon = self:AddComponent(UIImage, phase_changing_icon_path)
  self.phase_changing_txt = self:AddComponent(UITextMeshProUGUIEx, phase_changing_txt_path)
  self.frozen = self:AddComponent(UIBaseContainer, frozen_path)
  self.frozen_icon = self:AddComponent(UIImage, frozen_icon_path)
  self.frozen_txt = self:AddComponent(UITextMeshProUGUIEx, frozen_txt_path)
  self.frozen_pro = self:AddComponent(UISlider, frozen_pro_path)
  self.frozen_value = self:AddComponent(UITextMeshProUGUIEx, frozen_value_path)
  self.btn_info:SetOnClick(function()
    local desc
    if self.pointType == WorldPointUIType.City then
      desc = DataCenter.ThermalConductorTemplateManager:GetDesc(ThermalConductorType.Base, self.config_tip_name)
    elseif self.pointType == WorldPointUIType.Boss then
      desc = DataCenter.ThermalConductorTemplateManager:GetDesc(ThermalConductorType.StrongholdBoss, self.config_tip_name)
    elseif self.pointType == WorldPointUIType.WorldSuppliesPoint then
      desc = DataCenter.ThermalConductorTemplateManager:GetDesc(ThermalConductorType.SeasonGoods, self.config_tip_name)
    elseif self.pointType == WorldPointUIType.Rescue then
      desc = DataCenter.ThermalConductorTemplateManager:GetDesc(ThermalConductorType.Treasure, self.config_tip_name)
    elseif self.pointType == WorldPointUIType.AllianceCity then
      if self.city_type == WorldAllianceCityType.City then
        desc = DataCenter.ThermalConductorTemplateManager:GetDesc(ThermalConductorType.City, self.config_tip_name)
      elseif self.city_type == WorldAllianceCityType.Stronghold then
        desc = DataCenter.ThermalConductorTemplateManager:GetDesc(ThermalConductorType.Stronghold, self.config_tip_name)
      elseif self.city_type == WorldAllianceCityType.King then
        desc = DataCenter.ThermalConductorTemplateManager:GetDesc(ThermalConductorType.Throne, self.config_tip_name)
      end
    elseif self.pointType == WorldPointUIType.WorldDetectSurvivor then
      desc = DataCenter.ThermalConductorTemplateManager:GetDesc(ThermalConductorType.Survivor, self.config_tip_name)
    end
    if not string.IsNullOrEmpty(desc) then
      UIUtil.ShowBubbleTips(Localization:GetString(desc), self.btn_info.transform.position, 17, -30, 0)
    end
  end)
end

function SeasonFrozenStatus:ComponentDestroy()
  self.btn_info = nil
  self.phase_changing = nil
  self.phase_changing_icon = nil
  self.phase_changing_txt = nil
  self.frozen = nil
  self.frozen_txt = nil
  self.frozen_pro = nil
  self.frozen_value = nil
end

function SeasonFrozenStatus:OnAddListener()
  base.OnAddListener(self)
end

function SeasonFrozenStatus:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonFrozenStatus:Refresh(pointType, thermalConductor, city_type, pointUuid)
  if thermalConductor == nil or BattleFieldUtil.InBattleField() then
    self:SetActive(false)
    return
  end
  self.pointUuid = pointUuid
  self.pointType = pointType
  self.city_type = city_type
  self.config_tip_name = nil
  self.frozen_timer_tip_name = nil
  local fireEffectData = BuildFireEffectManager:GetInstance().fireEffectDataList[pointUuid]
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local conductor = thermalConductor
  local curHp = toInt(conductor.hp)
  local maxHp = toInt(conductor.maxHp)
  if fireEffectData ~= nil and curHp == 0 and maxHp == 0 then
    curHp = toInt(fireEffectData.curHp)
    maxHp = toInt(fireEffectData.maxHp)
    self.recoverSpeed = fireEffectData.recoverSpeed
    self.lastHpTime = fireEffectData.lastHpTime
    self.fireSpeed = fireEffectData.fireSpeed
    self.fireUnavailableTime = fireEffectData.unavailableTime
  end
  self.curHp = curHp
  self.maxHp = maxHp
  if curTime < conductor.nextPhaseEndTime then
    local nextPhaseEndTime = conductor.nextPhaseEndTime
    local StrRemainTime = UITimeManager:GetInstance():MilliSecondToFmtString(nextPhaseEndTime - curTime)
    self.nextPhaseEndTime = nextPhaseEndTime
    if conductor.nextPhase == ThermalPhase.Frozen then
      self:SetActive(true)
      self.frozen:SetActive(false)
      self.phase_changing:SetActive(true)
      self.phase_changing_icon:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/WorldPoint/FX_S2saiji_wendu_bing.png")
      self.config_tip_name = "freeze_status_info"
      self.timer_tip_name = Localization:GetString("season_s2_status_name7012")
      self.phase_changing_txt:SetText(self.timer_tip_name .. StrRemainTime)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.phase_changing.rectTransform)
    elseif conductor.phase == ThermalPhase.Frozen and conductor.nextPhase == ThermalPhase.Normal then
      self:SetActive(true)
      self.frozen:SetActive(true)
      self.phase_changing:SetActive(false)
      self.config_tip_name = "freeze_status_info"
      self.frozen_icon:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/WorldPoint/FX_S2saiji_bingdon_icon.png")
      self.frozen_timer_tip_name = Localization:GetString("season_s2_status_name7013")
      self.frozen_pro:SetValue(curHp / math.max(maxHp, 1))
      self.frozen_value:SetText(string.GetFormattedSeparatorNum(curHp) .. "/" .. string.GetFormattedSeparatorNum(maxHp))
      self.frozen_txt:SetText(self.frozen_timer_tip_name .. StrRemainTime)
    elseif conductor.nextPhase == ThermalPhase.Fire then
      self:SetActive(true)
      self.frozen:SetActive(false)
      self.phase_changing:SetActive(true)
      self.phase_changing_icon:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/WorldPoint/FX_S2saiji_wendu_huo.png")
      self.config_tip_name = "fire_status_info"
      self.timer_tip_name = Localization:GetString("season_s2_status_name7014")
      self.phase_changing_txt:SetText(self.timer_tip_name .. StrRemainTime)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.phase_changing.rectTransform)
    elseif conductor.phase == ThermalPhase.Fire and conductor.nextPhase == ThermalPhase.Normal then
      self:SetActive(true)
      self.frozen:SetActive(true)
      self.phase_changing:SetActive(false)
      self.config_tip_name = "fire_status_info"
      self.frozen_icon:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/WorldPoint/FX_S2saiji_wendu_huo.png")
      self.frozen_timer_tip_name = Localization:GetString("season_s2_status_name7015")
      self.frozen_pro:SetValue(curHp / math.max(maxHp, 1))
      self.frozen_value:SetText(string.GetFormattedSeparatorNum(curHp) .. "/" .. string.GetFormattedSeparatorNum(maxHp))
      self.frozen_txt:SetText(self.frozen_timer_tip_name .. StrRemainTime)
    else
      self:SetActive(false)
      return
    end
    self:Update1000MS()
  elseif conductor.phase == ThermalPhase.Frozen then
    if curHp == 0 and maxHp == 0 then
      self:SetActive(false)
      return
    end
    self:SetActive(true)
    self.frozen:SetActive(true)
    self.phase_changing:SetActive(false)
    self.config_tip_name = "freeze_status_info"
    self.frozen_icon:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/WorldPoint/FX_S2saiji_bingdon_icon.png")
    self.frozen_pro:SetValue(curHp / math.max(maxHp, 1))
    self.frozen_value:SetText(string.GetFormattedSeparatorNum(curHp) .. "/" .. string.GetFormattedSeparatorNum(maxHp))
    self.frozen_txt:SetLocalText("season_s2_status_name_freeze")
  elseif conductor.phase == ThermalPhase.Fire or fireEffectData ~= nil and curTime < toInt(self.fireUnavailableTime) then
    if curHp == 0 and maxHp == 0 then
      self:SetActive(false)
      return
    end
    self:SetActive(true)
    self.frozen:SetActive(true)
    self.phase_changing:SetActive(false)
    self.config_tip_name = "fire_status_info"
    self.frozen_icon:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/WorldPoint/FX_S2saiji_wendu_huo.png")
    self.frozen_pro:SetValue(curHp / math.max(maxHp, 1))
    self.frozen_value:SetText(string.GetFormattedSeparatorNum(curHp) .. "/" .. string.GetFormattedSeparatorNum(maxHp))
    self.frozen_txt:SetLocalText("season_s2_status_name_fire")
    self:Update1000MS()
  else
    self:SetActive(false)
  end
end

function SeasonFrozenStatus:Update1000MS()
  if self.nextPhaseEndTime then
    local pointInfo = CS.SceneManager.World:GetPointInfoByUuid(self.pointUuid)
    if pointInfo and pointInfo.thermalConductor then
      self.nextPhaseEndTime = pointInfo.thermalConductor.nextPhaseEndTime
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local StrRemainTime = UITimeManager:GetInstance():MilliSecondToFmtString(self.nextPhaseEndTime - curTime)
    if self.timer_tip_name then
      self.phase_changing_txt:SetText(self.timer_tip_name .. StrRemainTime)
    end
    if self.frozen_timer_tip_name then
      self.frozen_txt:SetText(self.frozen_timer_tip_name .. StrRemainTime)
    end
  end
  if self.recoverSpeed and self.lastHpTime then
    local cur_hp = self.curHp
    if self.fireUnavailableTime then
      cur_hp = BuildingUtils.GetBuildHp(cur_hp, self.lastHpTime, self.fireUnavailableTime / 1000, self.recoverSpeed, self.fireSpeed)
    else
      local curTime = UITimeManager:GetInstance():GetServerSeconds()
      local deltaTime = curTime - self.lastHpTime
      cur_hp = math.min(deltaTime * self.recoverSpeed + cur_hp, self.maxHp)
    end
    cur_hp = math.floor(math.min(cur_hp, self.maxHp))
    cur_hp = math.max(cur_hp, 0)
    if self.maxHp ~= nil and cur_hp >= self.maxHp then
      self.recoverSpeed = nil
      self.frozen_pro:SetValue(1)
      self.frozen_value:SetText(string.GetFormattedSeparatorNum(self.maxHp) .. "/" .. string.GetFormattedSeparatorNum(self.maxHp))
    else
      self.frozen_pro:SetValue(cur_hp / math.max(self.maxHp, 1))
      self.frozen_value:SetText(string.GetFormattedSeparatorNum(cur_hp) .. "/" .. string.GetFormattedSeparatorNum(self.maxHp))
    end
  end
  if self.fireUnavailableTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime >= self.fireUnavailableTime then
      self.fireUnavailableTime = nil
      self:SetActive(false)
    end
  end
end

return SeasonFrozenStatus
