local UILWSeasonStoveCenterPower = BaseClass("UILWSeasonStoveCenterPower", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local res_info_path = "DonateRoot/ResInfo"
local res_info_num_path = "DonateRoot/ResInfoNum"
local desc_path = "DonateRoot/desc"
local counter_path = "DonateRoot/counter"
local point_path = "PowerRoot/Power/point"
local from_path = "PowerRoot/Power/from"
local middle_path = "PowerRoot/Power/middle"
local to_path = "PowerRoot/Power/to"
local now_path = "PowerRoot/Power/now"
local cost_counter_path = "PowerRoot/Cost/costCounter"
local turn_on_path = "PowerRoot/Work/TurnOn"
local limit_on_path = "PowerRoot/Work/LimitOn"
local on_off_label_path = "PowerRoot/Work/OnOffLabel"
local power_label_path = "PowerRoot/Work/PowerLabel"
local btn_build_path = "DonateRoot/btnDonate"
local btn_txt_path = "DonateRoot/btnDonate/Count/DonateText"
local turn_on_btn_path = "PowerRoot/Work/TurnOn/TurnOnBtn"
local limit_on_btn_path = "PowerRoot/Work/LimitOn/LimitOnBtn"
local icon_path = "DonateRoot/GameObject/icon"
local yellow_path = "PowerRoot/Power/Fire/yellow"
local red_path = "PowerRoot/Power/Fire/red"

function UILWSeasonStoveCenterPower:OnCreate()
  base.OnCreate(self)
  self.buildingUuid = nil
  self.waitPowerOnOff = nil
  self.waitLimitOnOff = nil
  self.lastOpTime = nil
  self.anim_yellow = self:AddComponent(UICanvasGroup, yellow_path)
  self.anim_red = self:AddComponent(UICanvasGroup, red_path)
  self.anim_yellow:SetActive(false)
  self.anim_red:SetActive(false)
  self.res_info = self:AddComponent(UISlider, res_info_path)
  self.res_info_num = self:AddComponent(UITextMeshProUGUIEx, res_info_num_path)
  self.desc = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.counter = self:AddComponent(UITextMeshProUGUIEx, counter_path)
  self.btn_txt = self:AddComponent(UITextMeshProUGUIEx, btn_txt_path)
  self.btn_build = self:AddComponent(UILongPressTrigger, btn_build_path)
  self.btn_build:SetCallback(function()
    return self:DoResDonateClick()
  end)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.point = self:AddComponent(UIImage, point_path)
  self.from = self:AddComponent(UITextMeshProUGUIEx, from_path)
  self.middle = self:AddComponent(UITextMeshProUGUIEx, middle_path)
  self.to = self:AddComponent(UITextMeshProUGUIEx, to_path)
  self.workStatus = self:AddComponent(UITextMeshProUGUIEx, now_path)
  self.cost_counter = self:AddComponent(UITextMeshProUGUIEx, cost_counter_path)
  self.turn_on = self:AddComponent(UIToggle, turn_on_path)
  self.limit_on = self:AddComponent(UIToggle, limit_on_path)
  self.on_off_label = self:AddComponent(UITextMeshProUGUIEx, on_off_label_path)
  self.power_label = self:AddComponent(UITextMeshProUGUIEx, power_label_path)
  self.turn_on_btn = self:AddComponent(UIButton, turn_on_btn_path)
  self.limit_on_btn = self:AddComponent(UIButton, limit_on_btn_path)
  self.turn_on_btn:SetOnClick(function()
    if not LuaEntry.Player:IsLoginSourceServer() then
      UIUtil.ShowTipsId("season_tips166")
      return
    end
    self:TogglePowerOnOff()
  end)
  self.limit_on_btn:SetOnClick(function()
    if not LuaEntry.Player:IsLoginSourceServer() then
      UIUtil.ShowTipsId("season_tips166")
      return
    end
    self:ToggleLimitOnOff()
  end)
  self.turn_on_btn:SetSafeClickMode(true)
  self.limit_on_btn:SetSafeClickMode(true)
  self.desc:SetActive(false)
  self.turn_on:SetIsOn(false)
  self.limit_on:SetIsOn(false)
  self.point:SetEulerAnglesXYZ(0, 0, 95)
  CS.UIGray.SetGray(self.btn_build.transform, true, false)
end

function UILWSeasonStoveCenterPower:OnDestroy()
  self.btn_build:StopLongPressListener()
  self.desc:SetActive(false)
  self.turn_on:SetIsOn(false)
  self.limit_on:SetIsOn(false)
  base.OnDestroy(self)
end

function UILWSeasonStoveCenterPower:UpdateData()
  local theStoveCenter = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
  self.theStoveCenter = theStoveCenter
  if theStoveCenter == nil then
    self.turn_on:SetIsOn(false)
    self.limit_on:SetIsOn(false)
    self.desc:SetActive(false)
    self.btn_build:StopLongPressListener()
    return
  end
  local level = theStoveCenter.level
  local resCoal = LuaEntry.Resource:GetCntByResType(ResourceType.AllianceCoal)
  local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(level + BuildingTypes.SEASON_STOVE_CENTER)
  self.updating = true
  self.meta = meta
  self.buildingUuid = theStoveCenter.uuid
  self.res_info:SetValue(resCoal / meta.coal_limit)
  self.res_info_num:SetText(string.GetFormattedSeparatorNum(resCoal) .. "/" .. string.GetFormattedSeparatorNum(meta.coal_limit))
  local temperatureCfg = meta.temperatureCfg
  if temperatureCfg then
    self.from:SetText(temperatureCfg.default_temperature .. "\194\176C")
    self.middle:SetText(temperatureCfg.active_temperature .. "\194\176C")
    self.to:SetText(temperatureCfg.overload_temperature .. "\194\176C")
  else
    self.from:SetText("0\194\176C")
    self.middle:SetText("50\194\176C")
    self.to:SetText("100\194\176C")
  end
  local status = DataCenter.AllianceMineManager:GetAllianceStoveCenterStatus()
  if status then
    self:ChangePointRotation(self.status, status, self.meta)
  else
    self.desc:SetActive(false)
    self.turn_on:SetIsOn(false)
    self.limit_on:SetIsOn(false)
    self.workStatus:SetLocalText("390978")
    self.point:SetEulerAnglesXYZ(0, 0, 95)
    self.cost_counter:SetText("0/" .. Localization:GetString("100165"))
  end
  local allianceDonateCount = DataCenter.AllianceMineManager.allianceDonateCount
  self.coal_donate_count = meta.coal_donate_count
  self.coal_donate_limit = meta.coal_donate_limit
  self.counter:SetLocalText(141114, self.coal_donate_limit - allianceDonateCount .. "/" .. self.coal_donate_limit)
  self.on_off_label:SetLocalText("season_s2_alliance_building_ui018")
  self.power_label:SetLocalText("season_s2_alliance_building_ui019")
  self.maxCoal = meta.coal_limit
  self.useCoalNormal = meta.coal_normal
  self.useCoalOverload = meta.coal_overload
  self.descStr = Localization:GetString("season_s2_alliance_building_ui013")
  self.btn_txt:SetText(meta.coal_donate_count)
  self:Update1000MS()
  self.btn_build:StartLongPressListener()
  self.updating = false
  CS.UIGray.SetGray(self.btn_build.transform, false, true)
end

function UILWSeasonStoveCenterPower:ChangePointRotation(OldStatus, NewStatus, meta)
  if NewStatus then
    local x, y, z = self.point:GetEulerAnglesXYZ()
    local oldValue = z
    local newValue = 95
    if 180 < z then
      oldValue = z - 360
    end
    if NewStatus.state == 1 then
      newValue = 0
      self.desc:SetActive(true)
      self.turn_on:SetIsOn(true)
      self.limit_on:SetIsOn(false)
      self.anim_yellow:SetActive(true)
      self.anim_red:SetActive(false)
      self.workStatus:SetLocalText("season_s2_temperature_status_name04")
      self.cost_counter:SetText(string.GetFormattedSeparatorNum(meta.coal_normal) .. "/" .. Localization:GetString("100165"))
    elseif NewStatus.state == 2 then
      newValue = -95
      self.desc:SetActive(true)
      self.turn_on:SetIsOn(true)
      self.limit_on:SetIsOn(true)
      self.anim_yellow:SetActive(false)
      self.anim_red:SetActive(true)
      self.workStatus:SetLocalText("season_s2_temperature_status_name05")
      self.cost_counter:SetText(string.GetFormattedSeparatorNum(meta.coal_overload) .. "/" .. Localization:GetString("100165"))
    else
      newValue = 95
      self.desc:SetActive(false)
      self.turn_on:SetIsOn(false)
      self.limit_on:SetIsOn(false)
      self.anim_yellow:SetActive(false)
      self.anim_red:SetActive(false)
      self.workStatus:SetLocalText("season_s2_temperature_status_name03")
      self.cost_counter:SetText("0/" .. Localization:GetString("100165"))
    end
    if math.abs(newValue - oldValue) > 10 then
      if oldValue > newValue then
        DOTween.Sequence():Append(self.point.transform:DOLocalRotate(Vector3.New(0, 0, 0), 0.15)):Append(self.point.transform:DOLocalRotate(Vector3.New(0, 0, newValue - 8), 0.15)):Append(self.point.transform:DOLocalRotate(Vector3.New(0, 0, newValue + 4), 0.1)):Append(self.point.transform:DOLocalRotate(Vector3.New(0, 0, newValue), 0.05))
      else
        DOTween.Sequence():Append(self.point.transform:DOLocalRotate(Vector3.New(0, 0, 0), 0.15)):Append(self.point.transform:DOLocalRotate(Vector3.New(0, 0, newValue + 8), 0.15)):Append(self.point.transform:DOLocalRotate(Vector3.New(0, 0, newValue - 4), 0.1)):Append(self.point.transform:DOLocalRotate(Vector3.New(0, 0, newValue), 0.05))
      end
    end
    self.status = NewStatus
  end
end

function UILWSeasonStoveCenterPower:Update1000MS()
  if self.descStr == nil then
    return
  end
  if self.status then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local restTime = self.status.endTime - curTime
    if 0 <= restTime then
      self.desc:SetText(self.descStr .. UITimeManager:GetInstance():MilliSecondToFmtString(restTime))
    else
      self.desc:SetText(self.descStr .. "00:00:00")
    end
    if self.status.state == 1 and not self.turn_on:GetIsOn() then
      self.turn_on:SetIsOn(true)
    elseif self.status.state == 2 and not self.limit_on:GetIsOn() then
      self.limit_on:SetIsOn(true)
    elseif self.status.state == 0 then
      if self.limit_on:GetIsOn() then
        self.limit_on:SetIsOn(false)
      end
      if self.turn_on:GetIsOn() then
        self.turn_on:SetIsOn(false)
      end
    end
    if self.status.state == 1 or self.status.state == 2 then
      local hasCoal = LuaEntry.Resource:GetCntByResType(ResourceType.AllianceCoal)
      self.res_info:SetValue(hasCoal / self.meta.coal_limit)
      self.res_info_num:SetText(string.GetFormattedSeparatorNum(hasCoal) .. "/" .. string.GetFormattedSeparatorNum(self.meta.coal_limit))
    end
  else
    self.desc:SetText(self.descStr .. "00:00:00")
  end
end

function UILWSeasonStoveCenterPower:TogglePowerOnOff()
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.lastOpTime ~= nil and now - toInt(self.lastOpTime) < 3000 then
    return
  end
  if self.updating or self.buildingUuid == nil then
    return
  end
  if LuaEntry.Player:IsInAlliance() == false then
    UIUtil.ShowTipsId(371059)
    return
  end
  if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    UIUtil.ShowTipsId(803040)
    return
  end
  local hasCoal = LuaEntry.Resource:GetCntByResType(ResourceType.AllianceCoal)
  local on = not self.turn_on:GetIsOn()
  if on and hasCoal < self.useCoalNormal then
    UIUtil.ShowTipsId("season_s2_alliance_building_tips013")
    return
  end
  if on and self.theStoveCenter and (self.theStoveCenter:GetDurability() == 0 or self.theStoveCenter.status == AllianceMineStatus.Ruin) then
    UIUtil.ShowTipsId("season_s2_tips_300")
    return
  end
  if on and self.status and self.status.openTimeNext then
    local cd_time = self.status.openTimeNext - now
    if 1000 < cd_time then
      local cd = UITimeManager:GetInstance():MilliSecondToFmtString(cd_time)
      UIUtil.ShowTips(Localization:GetString("season_s2_alliance_building_tips015", cd))
      return
    end
  end
  if not on then
    local msg = Localization:GetString("season_s2_alliance_tips_03")
    UIUtil.ShowMessage(msg, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self.lastOpTime = UITimeManager:GetInstance():GetServerTime()
      self.waitPowerOnOff = on and 1 or 0
      SFSNetwork.SendMessage(MsgDefines.StoveCenterSwitchState, self.buildingUuid, self.waitPowerOnOff)
    end)
    return
  end
  self.lastOpTime = now
  self.waitPowerOnOff = on and 1 or 0
  SFSNetwork.SendMessage(MsgDefines.StoveCenterSwitchState, self.buildingUuid, self.waitPowerOnOff)
  if on then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.s2_alliance_furnace_ignition, false)
  end
end

function UILWSeasonStoveCenterPower:ToggleLimitOnOff()
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.lastOpTime ~= nil and now - toInt(self.lastOpTime) < 3000 then
    return
  end
  if self.updating or self.buildingUuid == nil then
    return
  end
  if LuaEntry.Player:IsInAlliance() == false then
    UIUtil.ShowTipsId(371059)
    return
  end
  if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
    UIUtil.ShowTipsId(803040)
    return
  end
  local hasCoal = LuaEntry.Resource:GetCntByResType(ResourceType.AllianceCoal)
  local on = not self.limit_on:GetIsOn()
  if on and self.theStoveCenter and self.theStoveCenter:Injuried() then
    UIUtil.ShowTipsId("season_s2_alliance_building_tips009")
    return
  end
  if on and hasCoal < self.useCoalOverload then
    UIUtil.ShowTipsId("season_s2_alliance_building_tips010")
    return
  end
  if on and not self.turn_on:GetIsOn() then
    UIUtil.ShowTipsId("season_s2_alliance_building_tips012")
    return
  end
  if on and self.status and self.status.overLoadTimeNext then
    local cd_time = self.status.overLoadTimeNext - now
    if 1000 < cd_time then
      local cd = UITimeManager:GetInstance():MilliSecondToFmtString(cd_time)
      UIUtil.ShowTips(Localization:GetString("season_s2_alliance_building_tips015", cd))
      return
    end
  end
  self.lastOpTime = now
  self.waitLimitOnOff = on and 2 or 1
  SFSNetwork.SendMessage(MsgDefines.StoveCenterSwitchState, self.buildingUuid, self.waitLimitOnOff)
end

function UILWSeasonStoveCenterPower:OnDonate()
  local allianceDonateCount = DataCenter.AllianceMineManager.allianceDonateCount
  local iconPath = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.AllianceCoal)
  local btnPos = self.btn_build.transform.position
  local techPointPos = self.icon.transform.position
  UIUtil.DoFly(RewardType.AllianceCoal, 3, iconPath, btnPos, techPointPos)
  self.counter:SetLocalText(141114, self.coal_donate_limit - allianceDonateCount .. "/" .. self.coal_donate_limit)
  if self.meta then
    UIUtil.ShowTips(Localization:GetString("season_s2_donate_tips01", self.meta.coal_contribute_unit or 1))
  end
end

function UILWSeasonStoveCenterPower:OnResourceUpdate()
  if self.meta then
    local resCoal = LuaEntry.Resource:GetCntByResType(ResourceType.AllianceCoal)
    self.res_info:SetValue(resCoal / self.meta.coal_limit)
    self.res_info_num:SetText(string.GetFormattedSeparatorNum(resCoal) .. "/" .. string.GetFormattedSeparatorNum(self.meta.coal_limit))
  end
end

function UILWSeasonStoveCenterPower:OnStoveCenterUpdate()
  if self.meta then
    local status = DataCenter.AllianceMineManager:GetAllianceStoveCenterStatus()
    if status then
      self.waitPowerOnOff = nil
      self.waitLimitOnOff = nil
      self.lastOpTime = nil
      self:ChangePointRotation(self.status, status, self.meta)
    end
  else
    self:UpdateData()
  end
end

function UILWSeasonStoveCenterPower:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceStoveCenterDonateUpdate, self.OnDonate)
  self:AddUIListener(EventId.AllianceStoveCenterUpdate, self.OnStoveCenterUpdate)
  self:AddUIListener(EventId.AllianceResourceUpdate, self.OnResourceUpdate)
end

function UILWSeasonStoveCenterPower:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceStoveCenterDonateUpdate, self.OnDonate)
  self:RemoveUIListener(EventId.AllianceStoveCenterUpdate, self.OnStoveCenterUpdate)
  self:RemoveUIListener(EventId.AllianceResourceUpdate, self.OnResourceUpdate)
  base.OnRemoveListener(self)
end

function UILWSeasonStoveCenterPower:DoResDonateClick()
  if not LuaEntry.Player:IsLoginSourceServer() then
    UIUtil.ShowTipsId("season_tips166")
    return false
  end
  local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.status and baseData then
    local donate_hour_cd = LuaEntry.DataConfig:TryGetNum("s2_alliance_center", "k1", 24)
    local canDonate = now - baseData.joinTime > donate_hour_cd * 3600000
    if not canDonate then
      UIUtil.ShowTips(Localization:GetString("season_s2_alliance_building_tips014", donate_hour_cd))
      return false
    end
    if DataCenter.AllianceMineManager.allianceDonateCount >= self.status.coal_donate_limit then
      UIUtil.ShowTips(Localization:GetString("season_s2_alliance_building_tips016"))
      return false
    end
  end
  local personalCoal = LuaEntry.Resource:GetCntByResType(ResourceType.FLINT)
  if self.coal_donate_count and personalCoal < self.coal_donate_count then
    UIUtil.ShowTipsId(120020)
    local data = {}
    table.insert(data, {
      resType = ResourceType.FLINT,
      need = self.coal_donate_count
    })
    LWResourceLackUtil:GotoResLack(data)
    return false
  elseif self.buildingUuid then
    SFSNetwork.SendMessage(MsgDefines.StoveCenterDonate, self.buildingUuid)
    return true
  end
  return false
end

return UILWSeasonStoveCenterPower
