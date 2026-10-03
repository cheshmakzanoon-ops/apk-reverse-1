local UIWorldSiegePointBtn = BaseClass("UIWorldSiegePointBtn", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local this_path = ""
local btn_image_path = "BtnImage"
local effect_path = "effect"
local btn_text_path = "BtnImage/BtnText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, btn_image_path)
  self.btnImage = self:AddComponent(UIImage, btn_image_path)
  self.anim = self:TryAddComponent(UIAnimator, this_path)
  if self.anim then
    self.anim:Enable(false)
  end
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  self.effect = self:AddComponent(UIBaseContainer, effect_path)
  self.effect:SetActive(false)
  self.btn_text = self:AddComponent(UIText, btn_text_path)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.btnImage = nil
  self.time_obj = nil
  self.anim = nil
end

local function DataDefine(self)
  self.param = nil
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  self.btnImage:LoadSpriteAuto(LoadPath.GetBuildBtnSpritePath(param.btnType))
  self.btnImage.transform.localPosition = param.position
  self.btn_text:SetText("")
  CS.UIGray.SetGray(self.btnImage.transform, false, true)
  self:RefreshAllOut()
  if self.param and self.param.btnType == WorldPointBtnType.AllOut then
    SFSNetwork.SendMessage(MsgDefines.AlAutoMarchCD)
    self.btn_text:SetActive(true)
  end
end

local function OnBtnClick(self)
  if not LuaEntry.Player:IsInSelfServer() then
    UIUtil.ShowTipsId("season_tips143")
    return
  end
  local isThroneCity = self.param.info.isKingCity
  local isThroneCityBattery = self.param.info.type == WorldAllianceCityType.Canon
  local isCrossServerThrone = self.param.info.isCrossServerThrone
  if isCrossServerThrone then
    if not SeasonUtil.CanJoinBattle(self.param.info.serverId) then
      return UIUtil.ShowTipsId(801496)
    end
  elseif (isThroneCity or isThroneCityBattery) and not LuaEntry.Player:IsInSourceServer() then
    return UIUtil.ShowTipsId(801496)
  end
  if self.param.btnType == WorldPointBtnType.AttackCity then
    if not isThroneCity and not isThroneCityBattery then
      local data = DataCenter.AllianceDeclareWarManager:GetSelfDeclareWarData()
      if data then
        if self.param.info.cityId ~= tonumber(data.content) then
          return UIUtil.ShowTipsId(302325)
        else
          local curTime = UITimeManager:GetInstance():GetServerTime()
          if curTime >= tonumber(data.et) then
            return UIUtil.ShowTipsId(302312)
          end
        end
      else
        return UIUtil.ShowTipsId(302312)
      end
    end
    local allianceuid = LuaEntry.Player.allianceId
    if allianceuid == "" then
      UIUtil.ShowTipsId(390172)
      if LuaEntry.Player:IsFirstJoinAlliance() == true then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
      end
    else
      local myAlId = LuaEntry.Player.allianceId
      local myCitiesCount = DataCenter.WorldAllianceCityDataManager:GetCitiesCountByAlId(myAlId, true)
      local cityMax = LuaEntry.DataConfig:TryGetNum("worldcity_s0", "k12")
      local effectNum = LuaEntry.Effect:GetGameEffect(EffectDefine.ALLIANCE_CITY_MAX_NUM)
      cityMax = cityMax + effectNum
      if isCrossServerThrone or isThroneCityBattery then
      elseif not isThroneCity and myCitiesCount >= cityMax then
        UIUtil.ShowTipsId(300727)
        return
      elseif DataCenter.WorldAllianceCityDataManager:GetAllianceAlreadyHaveCity(allianceuid) == true then
        if DataCenter.WorldAllianceCityDataManager:GetCityIsNearBySelfAlliance(allianceuid, self.param.info.cityId) == false then
          UIUtil.ShowTipsId(300711)
          return
        end
      elseif self.param.info.level > 1 then
        if self.param.info.level < 7 then
          UIUtil.ShowTipsId(300710)
        else
          UIUtil.ShowTipsId(300711)
        end
        return
      end
      local targetType = MarchTargetType.ATTACK_ALLIANCE_CITY
      if isThroneCity then
        targetType = MarchTargetType.ATTACK_THRONE
      end
      if isCrossServerThrone then
        targetType = MarchTargetType.ATTACK_SERVER_THRONE_BUILDING
      end
      MarchUtil.OnClickStartMarch(targetType, self.param.info.pointId, self.param.info.uuid, -1, 0)
    end
  elseif self.param.btnType == WorldPointBtnType.RallyCity then
    if not isThroneCity and not isThroneCityBattery then
      local data = DataCenter.AllianceDeclareWarManager:GetSelfDeclareWarData()
      if data then
        if self.param.info.cityId ~= tonumber(data.content) then
          return UIUtil.ShowTipsId(302325)
        else
          local curTime = UITimeManager:GetInstance():GetServerTime()
          if curTime >= tonumber(data.et) then
            return UIUtil.ShowTipsId(302312)
          end
        end
      else
        return UIUtil.ShowTipsId(302312)
      end
    end
    local allianceuid = LuaEntry.Player.allianceId
    if allianceuid == "" then
      UIUtil.ShowTipsId(390172)
      if LuaEntry.Player:IsFirstJoinAlliance() == true then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
      end
    else
      local myAlId = LuaEntry.Player.allianceId
      local myCitiesCount = DataCenter.WorldAllianceCityDataManager:GetCitiesCountByAlId(myAlId, true)
      local cityMax = LuaEntry.DataConfig:TryGetNum("worldcity_s0", "k12")
      local effectNum = LuaEntry.Effect:GetGameEffect(EffectDefine.ALLIANCE_CITY_MAX_NUM)
      cityMax = cityMax + effectNum
      if isCrossServerThrone or isThroneCityBattery then
      elseif not isThroneCity and myCitiesCount >= cityMax then
        UIUtil.ShowTipsId(300727)
        return
      elseif DataCenter.WorldAllianceCityDataManager:GetAllianceAlreadyHaveCity(allianceuid) == true then
        if DataCenter.WorldAllianceCityDataManager:GetCityIsNearBySelfAlliance(allianceuid, self.param.info.cityId) == false then
          UIUtil.ShowTipsId(300711)
          return
        end
      elseif self.param.info.level > 1 then
        if self.param.info.level < 7 then
          UIUtil.ShowTipsId(300710)
        else
          UIUtil.ShowTipsId(300711)
        end
        return
      end
      local targetType = MarchTargetType.RALLY_FOR_ALLIANCE_CITY
      if isThroneCity then
        targetType = MarchTargetType.RALLY_THRONE
      end
      if isCrossServerThrone then
        targetType = MarchTargetType.RALLY_SERVER_THRONE_BUILDING
      end
      MarchUtil.OnClickStartMarch(targetType, self.param.info.pointId, self.param.info.uuid, -1, 1)
    end
  elseif self.param.btnType == WorldPointBtnType.AssistanceCity then
    local allianceuid = LuaEntry.Player.allianceId
    if allianceuid == "" then
      UIUtil.ShowTipsId(390172)
    elseif WorldBattleUtil.EnableShowWorldAssistanceInfo() and not BattleFieldUtil.InBattleField() and not isThroneCity and not isCrossServerThrone then
      local _info = DataCenter.FormationAssistanceDataManager:GetFocusedCityAssistanceInfo(self.param.info.cityId)
      if _info and _info.my then
        UIUtil.ShowTipsId(121219)
        return
      end
      WorldBattleUtil.TrySendAssistanceMarch({
        uuid = self.param.info.uuid,
        playerUid = "",
        pointId = self.param.info.pointId,
        asType = AssistanceType.AllianceCity,
        isThroneCity = isThroneCity,
        isCrossServerThrone = isCrossServerThrone
      })
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, self.param.info.uuid, "", self.param.info.pointId, AssistanceType.AllianceCity, isThroneCity, isCrossServerThrone)
    end
  elseif self.param.btnType == WorldPointBtnType.ScoutCity then
    local allianceuid = LuaEntry.Player.allianceId
    if allianceuid == "" then
      UIUtil.ShowTipsId(390172)
      if LuaEntry.Player:IsFirstJoinAlliance() == true then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
      end
    else
      if not isThroneCity and not isThroneCityBattery then
        local data = DataCenter.AllianceDeclareWarManager:GetSelfDeclareWarData()
        if data then
          if self.param.info.cityId ~= tonumber(data.content) then
            return UIUtil.ShowTipsId(302325)
          end
        else
          return UIUtil.ShowTipsId(302312)
        end
      end
      local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_RADAR_CENTER)
      if not buildData then
        UIUtil.ShowTipsId(300608)
        self.view.ctrl:CloseSelf()
        return
      end
      if isCrossServerThrone or isThroneCityBattery then
      elseif not isThroneCity and self.param.info.level > 1 and DataCenter.WorldAllianceCityDataManager:GetAllianceAlreadyHaveCity(LuaEntry.Player.allianceId) == false then
        UIUtil.ShowTipsId(302013)
        return
      end
      local targetType = MarchTargetType.SCOUT_ALLIANCE_CITY
      if isThroneCity then
        targetType = MarchTargetType.SCOUT_THRONE
      end
      if isCrossServerThrone then
        targetType = MarchTargetType.SCOUT_SERVER_THRONE_BUILDING
      end
      local needConfirm, status, title, content, needBreakProtect = DataCenter.StatusManager:ShowTipForWarFever()
      if needConfirm then
        if status ~= nil and title ~= nil then
          local tempUuid = self.param.info.uuid
          local tempPointId = self.param.info.pointId
          UIUtil.ShowSecondMessage(title, content, 2, "", "", function()
            MarchUtil.LaunchScout(targetType, tempPointId, tempUuid)
          end, function(needSellConfirm)
            DataCenter.StatusManager:SetWarFeverConfirmFlag(needSellConfirm)
          end)
        else
          MarchUtil.LaunchScout(targetType, self.param.info.pointId, self.param.info.uuid)
        end
      elseif needBreakProtect == true then
        local tempUuid = self.param.info.uuid
        local tempPointId = self.param.info.pointId
        UIUtil.ShowMessage(content, 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          MarchUtil.LaunchScout(targetType, tempPointId, tempUuid)
        end, function()
        end)
      else
        MarchUtil.LaunchScout(targetType, self.param.info.pointId, self.param.info.uuid)
      end
    end
  elseif self.param.btnType == WorldPointBtnType.GiveUpAllianceCity_Cancel then
    if DataCenter.AllianceBaseDataManager:IsR4orR5() then
      local cityId = self.param.info.cityId
      local myAlCityInfo = DataCenter.WorldAllianceCityDataManager:GetMyAlCityInfo(cityId)
      local isGivingUp = myAlCityInfo and myAlCityInfo.giveUpEndTime and 0 < myAlCityInfo.giveUpEndTime
      if isGivingUp then
        do
          local cityTemplate = LocalController:instance():getLine(TableName.WorldCity, myAlCityInfo.cityId)
          local name = Localization:GetString("140205", cityTemplate:getValue("level"), Localization:GetString(cityTemplate:getValue("name")))
          local content = Localization:GetString("393057", name)
          UIUtil.ShowMessage(content, 2, nil, nil, function()
            SFSNetwork.SendMessage(MsgDefines.GiveUpAlCity, tonumber(cityId), true)
          end, nil, nil)
        end
      end
    else
      UIUtil.ShowTipsId(393018)
    end
  elseif self.param.btnType == WorldPointBtnType.GiveUpAllianceCity then
    if DataCenter.AllianceBaseDataManager:IsR4orR5() then
      local cityId = self.param.info.cityId
      local myAlCityInfo = DataCenter.WorldAllianceCityDataManager:GetMyAlCityInfo(cityId)
      if myAlCityInfo then
        do
          local name = GetTableData(TableName.WorldCity, cityId, "name")
          local isGivingUp = myAlCityInfo.giveUpEndTime and 0 < myAlCityInfo.giveUpEndTime
          if not isGivingUp then
            local content = Localization:GetString("393056", Localization:GetString(name))
            local showName = Localization:GetString("science_condition", self.param.info.level, Localization:GetString(name))
            UIUtil.ShowMessage(content, 2, nil, nil, function()
              local configTime = Mathf.Round(LuaEntry.DataConfig:TryGetNum("worldcity_s0", "k13", 3600) / 60)
              UIUtil.ShowTips(Localization:GetString(393063, showName, configTime))
              SFSNetwork.SendMessage(MsgDefines.GiveUpAlCity, tonumber(cityId), false)
            end, nil, nil)
          end
        end
      end
    else
      UIUtil.ShowTipsId(393018)
    end
  elseif self.param.btnType == WorldPointBtnType.CancelDeclareWar then
    local cityId = self.param.info.cityId
    UIUtil.ShowMessage(Localization:GetString("new_city_activity_battle_tips1024"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      local data = DataCenter.AllianceDeclareWarManager:GetSelfDeclareWarData()
      if data and tonumber(data.content) == cityId then
        local serverId = data.serverId or LuaEntry.Player:GetSelfServerId()
        SFSNetwork.SendMessage(MsgDefines.AllianceDeclareWarCancel, data.uuid, serverId)
      end
    end)
  elseif self.param.btnType == WorldPointBtnType.AllOut then
    local readyTs = DataCenter.SiegeDataManager:GetAllOutReadyTS()
    local now = UITimeManager:GetInstance():GetServerTime()
    if readyTs > now then
      local countDown = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutHour(readyTs - now)
      UIUtil.ShowTips(Localization:GetString("new_city_activity_battle_tips1033", countDown))
    else
      local cityId = self.param.info.cityId
      UIUtil.ShowMessage(Localization:GetString("new_city_activity_battle_tips1032"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        SFSNetwork.SendMessage(MsgDefines.UserCreateOfflineAutoMarch, cityId)
      end)
    end
  elseif self.param.btnType == WorldPointBtnType.DetectScoutCity then
    local detectData = DataCenter.RadarCenterDataManager:GetCityEventDataByPointIndex(self.view.ctrl.pointId)
    if detectData and detectData.template.type == DetectEventType.ScoutDeclareCity then
      DataCenter.FakeScoutMarchManager:AddMarchIndex(self.view.ctrl.pointId, detectData)
      self.view.ctrl:CloseSelf(false)
    else
      UIUtil.ShowTipsId(803041)
    end
  elseif self.param.btnType == WorldPointBtnType.DetectOccupyCity then
    local detectData = DataCenter.RadarCenterDataManager:GetCityEventDataByPointIndex(self.view.ctrl.pointId)
    if detectData and detectData.template.type == DetectEventType.ScoutOccupyCity then
      DataCenter.FakeScoutMarchManager:AddMarchIndex(self.view.ctrl.pointId, detectData)
      self.view.ctrl:CloseSelf(false)
    else
      UIUtil.ShowTipsId(803041)
    end
  elseif self.param.btnType == WorldPointBtnType.DeclareWar then
    if CrossServerUtil:NeedIntercept(500019) then
      return
    end
    if not LuaEntry.Player:IsInAlliance() then
      UIUtil.ShowTipsId(393055)
      return
    end
    if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
      UIUtil.ShowTipsId(143604)
      return
    end
    local state, declareInfo = DataCenter.AllianceDeclareWarManager:GetDeclareState()
    if state == DeclareWarState.Formal then
      UIUtil.ShowTipsId(143548)
      return
    end
    local myAlId = LuaEntry.Player.allianceId
    local myCitiesCount = DataCenter.WorldAllianceCityDataManager:GetCitiesCountByAlId(myAlId, true)
    local cityMax = LuaEntry.DataConfig:TryGetNum("worldcity_s0", "k12")
    local effectNum = LuaEntry.Effect:GetGameEffect(EffectDefine.ALLIANCE_CITY_MAX_NUM)
    cityMax = cityMax + effectNum
    if not isThroneCity and myCitiesCount >= cityMax then
      UIUtil.ShowTipsId(300727)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDeclareCondition, {anim = true}, self.param.info.cityId)
      return
    end
    local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    local createTime = 0
    if baseData and baseData.createTime then
      createTime = baseData.createTime
    end
    local allianceHour = math.floor((UITimeManager:GetInstance():GetServerTime() - createTime) / 3600000)
    local k7 = DataCenter.AllianceDeclareWarManager:GetConfigData("k7")
    if allianceHour < k7 then
      UIUtil.ShowTips(Localization:GetString("new_city_activity_battle_declear_tips1004", k7))
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDeclareCondition, {anim = true}, self.param.info.cityId)
      return
    end
    local curMember = 0
    if baseData and baseData.curMember then
      curMember = baseData.curMember
    end
    local k5 = DataCenter.AllianceDeclareWarManager:GetConfigData("k5")
    if curMember < k5 then
      UIUtil.ShowTips(Localization:GetString("new_city_activity_battle_declear_tips1005", k5))
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDeclareCondition, {anim = true}, self.param.info.cityId)
      return
    end
    local protectTime = DataCenter.WorldAllianceCityDataManager:GetCityProtectTime(tonumber(self.param.info.cityId))
    local now = UITimeManager:GetInstance():GetServerTime()
    local isPre = protectTime > now
    local needCheckDeclareTime = false
    if isPre then
      if UITimeManager:GetInstance():IsTodayServer(protectTime) then
        needCheckDeclareTime = true
      end
    else
      needCheckDeclareTime = true
    end
    if needCheckDeclareTime then
      local timeDeclare = DataCenter.AllianceDeclareWarManager:GetDeclareTime()
      local k6 = DataCenter.AllianceDeclareWarManager:GetConfigData("k6")
      if timeDeclare >= k6 then
        UIUtil.ShowTips(Localization:GetString("new_city_activity_battle_declear_tips1003", timeDeclare, k6))
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIDeclareCondition, {anim = true}, self.param.info.cityId)
        return
      end
    end
    if DataCenter.WorldAllianceCityDataManager:GetAllianceAlreadyHaveCity(LuaEntry.Player.allianceId) == true then
      if DataCenter.WorldAllianceCityDataManager:GetCityIsNearBySelfAlliance(LuaEntry.Player.allianceId, self.param.info.cityId) == false then
        UIUtil.ShowTipsId(300711)
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIDeclareCondition, {anim = true}, self.param.info.cityId)
        return
      end
    elseif self.param.info.level > 1 then
      UIUtil.ShowTipsId(110226)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDeclareCondition, {anim = true}, self.param.info.cityId)
      return
    end
    local param = {}
    param.cityId = self.param.info.cityId
    param.pointId = self.param.info.pointId
    param.uuid = self.param.info.uuid
    if state == DeclareWarState.PreDeclare then
      local oldCityName = DataCenter.AllianceCityTemplateManager:GetFormatName(tonumber(declareInfo.content))
      local newCityName = DataCenter.AllianceCityTemplateManager:GetFormatName(tonumber(param.cityId))
      local str = Localization:GetString("new_city_activity_battle_tips1002", oldCityName, newCityName)
      UIUtil.ShowMessage(str, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        DataCenter.AllianceDeclareWarManager:SetWarCityParam(param)
        SFSNetwork.SendMessage(MsgDefines.AllianceGetCityDeclareTimes, LuaEntry.Player:GetCurServerId(), param.cityId)
      end)
    else
      DataCenter.AllianceDeclareWarManager:SetWarCityParam(param)
      SFSNetwork.SendMessage(MsgDefines.AllianceGetCityDeclareTimes, LuaEntry.Player:GetCurServerId(), param.cityId)
    end
  elseif self.param.btnType == WorldPointBtnType.AllianceCityRally then
    DataCenter.AllianceBaseDataManager:TrySetRally(self.param.info.pointId)
  elseif self.param.btnType == WorldPointBtnType.DetectEventAttackCityS0Radar then
    local memberInfo = {
      headPic = LuaEntry.Player.pic,
      uid = LuaEntry.Player:GetUid(),
      headPicVer = LuaEntry.Player.picVer,
      name = LuaEntry.Player.name
    }
    DataCenter.AttackCityAnimManager:ShowPointAnim(self.param.info.uuid, {memberInfo}, true, self.param.info.serverId)
    local uuid = self.param.info.uuid
    local serverId = self.param.info.serverId
    local detectUuid = DataCenter.AttackCityS0DataManager:GetDetectEventInfoByTypeAndCityId(DetectEventType.AttackCityS0_City_Scout, self.param.info.cityId)
    local param = {
      uuid = detectUuid,
      eventType = DetectEventType.AttackCityS0_City_Scout
    }
    DataCenter.AttackCityS0DataManager:SetCityDetectRadarDoing(detectUuid, true)
    TimerManager:GetInstance():DelayInvoke(function()
      DataCenter.AttackCityAnimManager:ShowPointAnim(uuid, {memberInfo}, false, serverId)
      TimerManager:GetInstance():DelayInvoke(function()
        SFSNetwork.SendMessage(MsgDefines.DetectEventCityCompetitionS0Start, param)
        DataCenter.LWGuideFlowManager:TryTriggerFlexibly(7004)
      end, 3.3)
    end, 3.3)
  end
  if self.view.ctrl then
    self.view.ctrl:CloseSelf()
  end
end

local function PlayAnim(self, name)
  if self.anim then
    self.anim:Play(name, 0, 0)
  end
end

local function Update1000MS(self)
  self:RefreshAllOut()
end

local function RefreshAllOut(self)
  if self.param and self.param.btnType == WorldPointBtnType.AllOut then
    local readyTs = DataCenter.SiegeDataManager:GetAllOutReadyTS()
    local now = UITimeManager:GetInstance():GetServerTime()
    if readyTs > now then
      local countDown = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutHour(readyTs - now)
      self.btn_text:SetText(countDown)
      CS.UIGray.SetGray(self.btnImage.transform, true, true)
    else
      self.btn_text:SetText("")
      CS.UIGray.SetGray(self.btnImage.transform, false, true)
    end
  end
end

UIWorldSiegePointBtn.OnCreate = OnCreate
UIWorldSiegePointBtn.OnDestroy = OnDestroy
UIWorldSiegePointBtn.OnEnable = OnEnable
UIWorldSiegePointBtn.OnDisable = OnDisable
UIWorldSiegePointBtn.ComponentDefine = ComponentDefine
UIWorldSiegePointBtn.ComponentDestroy = ComponentDestroy
UIWorldSiegePointBtn.DataDefine = DataDefine
UIWorldSiegePointBtn.DataDestroy = DataDestroy
UIWorldSiegePointBtn.ReInit = ReInit
UIWorldSiegePointBtn.OnBtnClick = OnBtnClick
UIWorldSiegePointBtn.PlayAnim = PlayAnim
UIWorldSiegePointBtn.Update1000MS = Update1000MS
UIWorldSiegePointBtn.RefreshAllOut = RefreshAllOut
return UIWorldSiegePointBtn
