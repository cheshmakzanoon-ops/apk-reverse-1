local UIWorldSiegePointSeasonBtn = BaseClass("UIWorldSiegePointSeasonBtn", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local this_path = ""
local btn_image_path = "BtnImage"
local btn_text_path = "BtnImage/BtnText"
local effect_path = "effect"
local c_d_test_path = "BtnImage/CDTest"

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
  self.btn_text = self:TryAddComponent(UIText, btn_text_path)
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
  if self.btn_text then
    self.btn_text:SetActive(false)
  end
  self.cd_test = self:TryAddComponent(UIText, c_d_test_path)
  if self.cd_test then
    self.cd_test:SetActive(false)
  end
end

local function ComponentDestroy(self)
  CS.UIGray.SetGray(self.btnImage.transform, false, true)
  if self.btn_text then
    self.btn_text:SetActive(false)
  end
  if self.cd_test then
    self.cd_test:SetActive(false)
  end
  self.btn = nil
  self.btnImage = nil
  self.time_obj = nil
  self.anim = nil
  self.btn_text = nil
  self.cd_test = nil
end

local function DataDefine(self)
  self.param = nil
end

local function DataDestroy(self)
  self.param = nil
end

function UIWorldSiegePointSeasonBtn:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshReinforcementChargeCount, self.OnRefinementDetail)
end

function UIWorldSiegePointSeasonBtn:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshReinforcementChargeCount, self.OnRefinementDetail)
  base.OnRemoveListener(self)
end

local function ReInit(self, param)
  self.param = param
  self.btnImage:LoadSpriteAuto(LoadPath.GetBuildBtnSpritePath(param.btnType))
  self.btnImage.transform.localPosition = param.position
  self.serverId = self.param.info.serverId
  self:OnRefinementDetail()
end

local function OnBtnClick(self, params)
  if params then
    self.param = params
  end
  local seasonType = self.param.info.seasonType
  local city_type = self.param.info.type
  local btnType = self.param.btnType
  if btnType == WorldPointBtnType.CampDestroy then
    if not DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.SeasonCampDestroyNoticeSilence) then
      btnType = WorldPointBtnType.DeclareWar
      self.param.btnType = WorldPointBtnType.DeclareWar
    else
      local cachedParam = self.param
      UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonCampDestroyNotice, {anim = true}, function()
        cachedParam.btnType = WorldPointBtnType.DeclareWar
        self:OnBtnClick(cachedParam)
      end)
      return
    end
  end
  local serverId = self.serverId
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local isCityStronghold = city_type == WorldAllianceCityType.Stronghold
  local isTradeStation = city_type == WorldAllianceCityType.TradingStation
  local cityTemplate = self.param.info.meta
  if cityTemplate and seasonType == SeasonMapType.NineNation then
    local only_original_zone = cityTemplate.only_original_zone
    if only_original_zone == -1 and (btnType == WorldPointBtnType.AttackCity or btnType == WorldPointBtnType.RallyCity or btnType == WorldPointBtnType.DeclareCityPrepare or btnType == WorldPointBtnType.DeclareWar or btnType == WorldPointBtnType.ScoutCity) and mySourceServerId ~= serverId then
      UIUtil.ShowTipsId("s5_map_ui_38")
      return
    end
  end
  if serverId ~= loginServerId then
    local isBigMapMode, curSameGroup, srcSameGroup, loginSameGroup = SeasonUtil.InSeasonBigMapMode(serverId)
    if isBigMapMode and isCityStronghold and srcSameGroup and loginSameGroup and (btnType == WorldPointBtnType.AttackCity or btnType == WorldPointBtnType.AssistanceCity or btnType == WorldPointBtnType.AssistanceAllyFriendCity) then
    elseif btnType == WorldPointBtnType.SeasonTradeShopEnter or btnType == WorldPointBtnType.SeasonTradeShopRefresh or btnType == WorldPointBtnType.GiveUpTradeStation or btnType == WorldPointBtnType.GiveUpTradeStation_Cancel or btnType == WorldPointBtnType.BankRob or btnType == WorldPointBtnType.BankDeposit then
      if not srcSameGroup then
        UIUtil.ShowTipsId("season_tips143")
        return
      end
    elseif not SeasonUtil.CanCrossInteraction(serverId, true, true) then
      return
    end
  end
  if not self.param.info.forbidden or btnType == WorldPointBtnType.MasterySkill then
  else
    UIUtil.ShowTipsId("season_tips146")
    return
  end
  if seasonType == SeasonMapType.NineNationRainforest and city_type == WorldAllianceCityType.City and (btnType == WorldPointBtnType.DeclareCityPrepare or btnType == WorldPointBtnType.DeclareWar) then
    local seasonInfo = SeasonUtil.GetSeasonInfo(serverId)
    if seasonInfo and seasonInfo:IsInBattleServerGroupInt(mySourceServerId) then
      local cityId = self.param.info.cityId
      local ownerServerId = toInt(self.param.info.ownerServerId)
      local ownerAllianceId = self.param.info.allianceId
      local cityData = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(cityId, serverId)
      if cityData ~= nil and cityData:IsNotRuins() and cityData.occupyServerId ~= nil and cityData.occupyServerId ~= 0 then
        local camp1 = seasonInfo:GetCampIdByServerId(cityData.occupyServerId)
        local camp2 = seasonInfo:GetCampIdByServerId(mySourceServerId)
        if camp1 == camp2 then
          UIUtil.ShowTipsId("season_s6_clarewar_tips02")
          return
        end
      end
      if 0 < ownerServerId then
        local camp1 = seasonInfo:GetCampIdByServerId(ownerServerId)
        local camp2 = seasonInfo:GetCampIdByServerId(mySourceServerId)
        if camp1 == camp2 then
          UIUtil.ShowTipsId("season_s6_clarewar_tips02")
          return
        end
      end
    end
  end
  if city_type == WorldAllianceCityType.Stronghold then
    local myAllianceId = LuaEntry.Player.allianceId
    if btnType == WorldPointBtnType.Fishing then
      DataCenter.FishingDataManager:TryEnterFishPond(self.param.info.serverId, self.param.info.cityId)
    end
    if btnType == WorldPointBtnType.AttackCity or btnType == WorldPointBtnType.RallyCity or btnType == WorldPointBtnType.AssistanceCity or btnType == WorldPointBtnType.AssistanceAllyFriendCity or btnType == WorldPointBtnType.ScoutCity then
      local config = SeasonUtil.GetCurServerConfig()
      if config and toInt(config.mode) > 1 then
        UIUtil.ShowTipsId("season_tips195")
        return
      end
      if string.IsNullOrEmpty(myAllianceId) then
        UIUtil.ShowTipsId(371059)
        if LuaEntry.Player:IsFirstJoinAlliance() == true then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
        else
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
        end
        return
      end
    end
    if btnType == WorldPointBtnType.AttackCity or btnType == WorldPointBtnType.RallyCity then
      do
        local cityId = self.param.info.cityId
        local allianceBase = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
        local stronghold_k10 = SeasonUtil.GetStrongholdConfig(serverId, true, "k10", 1)
        local stronghold_k11 = SeasonUtil.GetStrongholdConfig(serverId, true, "k11", 0)
        if allianceBase and 0 < stronghold_k10 and 0 <= stronghold_k11 then
          do
            local allianceMember = toInt(allianceBase.curMember)
            local alliancePower = toInt(allianceBase.fightPower)
            if stronghold_k10 > allianceMember or stronghold_k11 > alliancePower then
              do
                local msg = Localization:GetString("season_s6_alliance_skill_60001_desc04")
                UIUtil.ShowMessage(msg, 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
                  Logger.LogInfo(string.format("AttackStronghold serverId = %s , cityId = %s , allianceId = %s , member = %s , power = %s", serverId, cityId, myAllianceId, allianceMember, alliancePower))
                end)
                return
              end
            end
          end
        end
      end
    end
  end
  if city_type == WorldAllianceCityType.Stronghold and btnType ~= WorldPointBtnType.BankDeposit and not LuaEntry.Player:IsInAlliance() then
    UIUtil.ShowTipsId(2010218)
    return
  end
  if (city_type == WorldAllianceCityType.City or city_type == WorldAllianceCityType.Stronghold) and SeasonUtil.GetSeasonType() == SeasonMapType.CityStronghold and (btnType == WorldPointBtnType.AttackCity or btnType == WorldPointBtnType.RallyCity) then
    local allianceId = LuaEntry.Player:GetAllianceUid()
    local myAlCityInfo = DataCenter.WorldAllianceCityDataManager:GetAllianceCityData(allianceId, self.param.info.cityId)
    if myAlCityInfo == nil and not SeasonUtil.CanAttackCityStronghold(self.param.info.cityId) then
      UIUtil.ShowTipsId("season_tips201")
      return
    end
    if myAlCityInfo == nil and city_type == WorldAllianceCityType.Stronghold then
      local occupyNum = DataCenter.SeasonDataManager.occupyNum
      local occupyMaxNum = DataCenter.SeasonDataManager.occupyMaxNum
      local dailyOccupyNum = DataCenter.SeasonDataManager.dailyOccupyNum
      if occupyMaxNum ~= 0 and occupyNum >= occupyMaxNum then
        UIUtil.ShowTipsId("season_tips213")
        return
      end
      local strongholdAttackMax = 10
      if seasonType == SeasonMapType.CityStronghold then
        strongholdAttackMax = toInt(LuaEntry.DataConfig:TryGetNum("season_new_s1_stronghold", "k3", 3))
      elseif seasonType == SeasonMapType.Snow then
        strongholdAttackMax = toInt(LuaEntry.DataConfig:TryGetNum("season_new_s2_stronghold", "k3", 3))
      elseif seasonType == SeasonMapType.Mummy then
        strongholdAttackMax = toInt(LuaEntry.DataConfig:TryGetNum("season_new_s3_stronghold", "k3", 3))
      elseif seasonType == SeasonMapType.Darkness then
        strongholdAttackMax = toInt(LuaEntry.DataConfig:TryGetNum("season_new_s4_stronghold", "k3", 3))
      elseif seasonType == SeasonMapType.NineNation then
        strongholdAttackMax = toInt(LuaEntry.DataConfig:TryGetNum("season_new_s5_stronghold", "k3", 3))
      elseif seasonType == SeasonMapType.NineNationRainforest then
        strongholdAttackMax = toInt(LuaEntry.DataConfig:TryGetNum("season_new_s6_stronghold", "k3", 3))
      end
      if strongholdAttackMax ~= 0 and dailyOccupyNum >= strongholdAttackMax then
        UIUtil.ShowTipsId("season_tips214")
        return
      end
    end
  end
  if city_type == WorldAllianceCityType.MissileFactory and (btnType == WorldPointBtnType.AttackCity or btnType == WorldPointBtnType.RallyCity) then
    local ownerServerId = self.param.info.ownerServerId
    local ownerAllianceId = self.param.info.allianceId
    if not DataCenter.SeasonFactionWarDataManager:IsSameCampOrSameAllianceOrMe(ownerServerId, ownerAllianceId, nil) then
      self:DoClickAction()
      return
    end
    UIUtil.TryShowConfirm(TodayNoSecondConfirmType.AttackMissileFactory, Localization:GetString("season_activity_1000086_tips42"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self:DoClickAction()
    end, function()
    end, nil, nil, false, nil, nil)
  else
    self:DoClickAction()
  end
end

function UIWorldSiegePointSeasonBtn:CanCrossInteraction()
  return self.param.info and SeasonUtil.CanCrossInteraction(self.param.info.serverId, true, true)
end

function UIWorldSiegePointSeasonBtn:DoClickAction()
  local seasonType = self.param.info.seasonType
  local serverId = self.param.info.serverId
  local city_type = self.param.info.type
  local cityId = self.param.info.cityId
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local protectTime = self.param.info.protectTime
  local cityMgr = DataCenter.WorldAllianceCityDataManager
  local isThroneCity = city_type == WorldAllianceCityType.King
  local isThroneCityBattery = city_type == WorldAllianceCityType.Canon
  local isMissileFactory = city_type == WorldAllianceCityType.MissileFactory
  local isCityStronghold = city_type == WorldAllianceCityType.Stronghold
  local isTradeStation = city_type == WorldAllianceCityType.TradingStation
  local isAltar = city_type == WorldAllianceCityType.Altar
  local isCrossServerThrone = self.param.info.isCrossServerThrone
  local canBattle = self.param.info.canBattle
  local ownerAllianceId = self.param.info.allianceId
  local ignoreThroneCity = self.param.btnType == WorldPointBtnType.BuildNuclear
  local inProtectMode = curTime < protectTime
  local kingCityId = SeasonUtil.GetKingCityId(serverId)
  local kingCenterId = SeasonUtil.GetCenterCityId(serverId)
  local btnType = self.param.btnType
  if isCrossServerThrone then
    if not SeasonUtil.CanJoinBattle(serverId) then
      return UIUtil.ShowTipsId(801496)
    end
  elseif (not (not isThroneCity or ignoreThroneCity) or isThroneCityBattery or isMissileFactory) and not LuaEntry.Player:IsInSourceServer() then
    return UIUtil.ShowTipsId(801496)
  else
    if not isThroneCity and (self.param.btnType == WorldPointBtnType.AttackCity or self.param.btnType == WorldPointBtnType.RallyCity) and SeasonUtil.GetSeasonType() == SeasonMapType.CityStronghold and not SeasonUtil.CanAttackCityStronghold(self.param.info.cityId) then
      UIUtil.ShowTipsId(300711)
      return
    else
    end
  end
  if isCityStronghold then
    if self.param.btnType ~= WorldPointBtnType.BankDeposit and not LuaEntry.Player:IsInAlliance() then
      UIUtil.ShowTipsId(2010218)
      return
    end
    if seasonType == SeasonMapType.NineNationRainforest and (btnType == WorldPointBtnType.AttackCity or btnType == WorldPointBtnType.RallyCity or btnType == WorldPointBtnType.ScoutCity) then
      local hasOwner = ownerAllianceId ~= nil and ownerAllianceId ~= ""
      local isDeclareDay = DataCenter.UILWSeasonAllianceWarTimeManager:IsDeclareDay()
      if hasOwner and inProtectMode and not canBattle then
        if isCityStronghold then
          return UIUtil.ShowTipsId("season_tips240")
        else
          return UIUtil.ShowTipsId(300709)
        end
      end
      if hasOwner and not isDeclareDay then
        return UIUtil.ShowTipsId("s6_stronghold_tips01")
      end
    end
  end
  if self.param.btnType == WorldPointBtnType.ShowCityAttachmentList then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonCityAttachmentPopList, {anim = true}, self.param.info.cityId, self.param.info.pointId)
  elseif self.param.btnType == WorldPointBtnType.AttackCity then
    if inProtectMode and not canBattle then
      if isCityStronghold then
        return UIUtil.ShowTipsId("season_tips240")
      else
        return UIUtil.ShowTipsId(300709)
      end
    end
    if not isThroneCity and not isThroneCityBattery and not isCityStronghold and not isTradeStation and not isMissileFactory and not isAltar then
      local data = DataCenter.AllianceDeclareWarManager:GetSelfDeclareWarData()
      if data then
        if self.param.info.cityId ~= tonumber(data.content) then
          return UIUtil.ShowTipsId(302325)
        elseif curTime * 1000 >= tonumber(data.et) then
          return UIUtil.ShowTipsId(302312)
        end
      else
        return UIUtil.ShowTipsId(302312)
      end
    end
    local allianceuid = LuaEntry.Player.allianceId
    if allianceuid == "" then
      UIUtil.ShowTipsId(371059)
      if LuaEntry.Player:IsFirstJoinAlliance() == true then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
      end
    else
      if isCityStronghold then
        if seasonType == SeasonMapType.NineNation and not DataCenter.AllianceDeclareWarManager:CanAttackStronghold(self.param.info.serverId, self.param.info.level) then
          UIUtil.ShowTipsId("season_s5_activity_1200059_desc26")
          return
        end
        if seasonType == SeasonMapType.NineNation or seasonType == SeasonMapType.NineNationRainforest then
          local pointInfo = CS.SceneManager.World:GetPointInfo(self.param.info.pointId)
          if pointInfo ~= nil then
            local extraInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo)
            if extraInfo ~= nil and not string.IsNullOrEmpty(extraInfo.allianceId) then
              local timeIndex = extraInfo.warTimeIndex
              if not DataCenter.UILWSeasonAllianceWarTimeManager:IsAllianceWarTime(timeIndex) then
                UIUtil.ShowTipsId("s5_alliance_battle_time_tips05")
                return
              end
            end
          end
        end
      end
      local myAlId = LuaEntry.Player.allianceId
      if isCrossServerThrone or isThroneCityBattery or isMissileFactory then
      elseif isTradeStation then
        local pointInfo = self.param.info.tradeData
        local now = UITimeManager:GetInstance():GetServerTime()
        if now < pointInfo.battleStartTime or now > pointInfo.battleEndTime then
          UIUtil.ShowTipsId("season_s3_trade_tips11")
          return
        end
        local loginServerId = LuaEntry.Player:GetSelfServerId()
        local curIndex = LuaEntry.Player:GetMainWorldPos()
        if not DataCenter.BirthPointTemplateManager:IsInAllianceCityField(curIndex, loginServerId) then
          UIUtil.ShowTipsId("season_s3_trade_tips09")
          return
        end
      elseif isAltar then
        local altarData = self.param.info.altarData
        local now = UITimeManager:GetInstance():GetServerTime()
        if altarData == nil or now < altarData.BattleStartTime or now > altarData.BattleEndTime then
          UIUtil.ShowTipsId("season_s3_trade_tips11")
          return
        end
      elseif not isThroneCity and not isCityStronghold and SeasonUtil.IsOccupyCityCountReachedMax(serverId) then
        UIUtil.ShowTipsId(300727)
        return
      end
      local targetType = MarchTargetType.ATTACK_ALLIANCE_CITY
      if isThroneCity then
        targetType = MarchTargetType.ATTACK_THRONE
      end
      if isCrossServerThrone then
        if seasonType == SeasonMapType.NineNationRainforest then
          if kingCityId == cityId then
            targetType = MarchTargetType.RAINFOREST_THRONE_ATTACK
          else
            targetType = MarchTargetType.ATTACK_CENTER_THRONE
          end
        elseif SeasonUtil.IsNineNationKingMember(self.param.info.serverId) then
          if not LuaEntry.Player:IsInSelfServer() then
            UIUtil.ShowTipsId("season_tips143")
            return
          end
          targetType = MarchTargetType.ATTACK_CENTER_THRONE
        else
          targetType = MarchTargetType.ATTACK_SERVER_THRONE_BUILDING
        end
      end
      if isCityStronghold then
        targetType = MarchTargetType.ATTACK_CITY_STRONGHOLD
      end
      if isTradeStation then
        targetType = MarchTargetType.ATTACK_CITY_TRADE
      end
      if isAltar then
        targetType = MarchTargetType.ATTACK_CITY_ALTAR
      end
      MarchUtil.OnClickStartMarch(targetType, self.param.info.pointId, self.param.info.uuid, -1, 0)
    end
  elseif self.param.btnType == WorldPointBtnType.DigIceAlly then
    if not self:CanCrossInteraction() then
      return
    end
    MarchUtil.OnClickStartMarch(MarchTargetType.DIG_ICE_ALLY, self.param.info.pointId, self.param.info.uuid, -1, 1)
  elseif self.param.btnType == WorldPointBtnType.DigIceEnemy then
    if not self:CanCrossInteraction() then
      return
    end
    MarchUtil.OnClickStartMarch(MarchTargetType.DIG_ICE_ENEMY, self.param.info.pointId, self.param.info.uuid, -1, 1)
  elseif self.param.btnType == WorldPointBtnType.TradeStationBattleInfo then
    RailwayUtil.OnClickTradeStationBattleDetailBtn(self.view.ctrl.pointId)
  elseif self.param.btnType == WorldPointBtnType.RallyCity then
    if not self:CanCrossInteraction() then
      return
    end
    if inProtectMode and not canBattle then
      if isCityStronghold then
        return UIUtil.ShowTipsId("season_tips240")
      else
        return UIUtil.ShowTipsId(300709)
      end
    end
    if not isThroneCity and not isThroneCityBattery and not isCityStronghold and not isMissileFactory then
      local data = DataCenter.AllianceDeclareWarManager:GetSelfDeclareWarData()
      if data then
        if self.param.info.cityId ~= tonumber(data.content) then
          return UIUtil.ShowTipsId(302325)
        elseif curTime * 1000 >= tonumber(data.et) then
          return UIUtil.ShowTipsId(302312)
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
      if isCrossServerThrone or isThroneCityBattery or isMissileFactory then
      elseif not isThroneCity and not isCityStronghold and SeasonUtil.IsOccupyCityCountReachedMax(serverId) then
        UIUtil.ShowTipsId(300727)
        return
      end
      local targetType = MarchTargetType.RALLY_FOR_ALLIANCE_CITY
      if isThroneCity then
        targetType = MarchTargetType.RALLY_THRONE
      end
      if isCrossServerThrone then
        if seasonType == SeasonMapType.NineNationRainforest and kingCityId == cityId then
          targetType = MarchTargetType.RAINFOREST_THRONE_RALLY
        elseif seasonType == SeasonMapType.NineNation and SeasonUtil.IsNineNationKingMember(self.param.info.serverId) then
          if not LuaEntry.Player:IsInSelfServer() then
            UIUtil.ShowTipsId("season_tips143")
            return
          end
          targetType = MarchTargetType.RALLY_CENTER_THRONE
        else
          targetType = MarchTargetType.RALLY_SERVER_THRONE_BUILDING
        end
      end
      if isCityStronghold then
        targetType = MarchTargetType.RALLY_CITY_STRONGHOLD
      end
      MarchUtil.OnClickStartMarch(targetType, self.param.info.pointId, self.param.info.uuid, -1, 1)
    end
  elseif self.param.btnType == WorldPointBtnType.AssistanceCity then
    if not self:CanCrossInteraction() then
      return
    end
    if WorldBattleUtil.EnableShowWorldAssistanceInfo() and not BattleFieldUtil.InBattleField() then
      local allianceuid = LuaEntry.Player.allianceId
      if allianceuid == "" then
        UIUtil.ShowTipsId(371059)
        return
      end
      local asType
      local _info = DataCenter.FormationAssistanceDataManager:GetFocusedCityAssistanceInfo(self.param.info.cityId)
      if _info and _info.my then
        UIUtil.ShowTipsId(121219)
        return
      end
      if isCityStronghold then
        asType = AssistanceType.CityStronghold
      elseif isTradeStation then
        asType = AssistanceType.TradeState
      elseif isAltar then
        asType = AssistanceType.ASSISTANCE_ALTAR
      else
        asType = AssistanceType.AllianceCity
      end
      if asType then
        WorldBattleUtil.TrySendAssistanceMarch({
          uuid = self.param.info.uuid,
          playerUid = "",
          pointId = self.param.info.pointId,
          asType = asType,
          isThroneCity = isThroneCity,
          isCrossServerThrone = isCrossServerThrone,
          cityId = cityId,
          serverId = serverId,
          kingCityId = kingCityId,
          kingCenterId = kingCenterId,
          seasonType = seasonType
        })
      end
    else
      local allianceuid = LuaEntry.Player.allianceId
      if allianceuid == "" then
        UIUtil.ShowTipsId(371059)
      elseif isCityStronghold then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, self.param.info.uuid, "", self.param.info.pointId, AssistanceType.CityStronghold, isThroneCity, isCrossServerThrone)
      elseif isTradeStation then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, self.param.info.uuid, "", self.param.info.pointId, AssistanceType.TradeState, isThroneCity, isCrossServerThrone)
      elseif isAltar then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, self.param.info.uuid, "", self.param.info.pointId, AssistanceType.ASSISTANCE_ALTAR, isThroneCity, isCrossServerThrone)
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, self.param.info.uuid, "", self.param.info.pointId, AssistanceType.AllianceCity, isThroneCity, isCrossServerThrone)
      end
    end
  elseif self.param.btnType == WorldPointBtnType.AssistanceAllyFriendCity then
    if not self:CanCrossInteraction() then
      return
    end
    if WorldBattleUtil.EnableShowWorldAssistanceInfo() and not BattleFieldUtil.InBattleField() then
      local allianceuid = LuaEntry.Player.allianceId
      if allianceuid == "" then
        UIUtil.ShowTipsId(371059)
        return
      end
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
      local allianceuid = LuaEntry.Player.allianceId
      if allianceuid == "" then
        UIUtil.ShowTipsId(371059)
      elseif isCityStronghold then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, self.param.info.uuid, "", self.param.info.pointId, AssistanceType.CityStronghold, false, false)
      elseif city_type == WorldAllianceCityType.City then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, self.param.info.uuid, "", self.param.info.pointId, AssistanceType.AllianceCity, false, false)
      end
    end
  elseif self.param.btnType == WorldPointBtnType.ScoutCity then
    if not self:CanCrossInteraction() then
      return
    end
    if inProtectMode and not canBattle then
      if isCityStronghold then
        return UIUtil.ShowTipsId("season_tips240")
      else
        return UIUtil.ShowTipsId(300709)
      end
    end
    local allianceuid = LuaEntry.Player.allianceId
    if allianceuid == "" then
      UIUtil.ShowTipsId(371059)
      if LuaEntry.Player:IsFirstJoinAlliance() == true then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
      end
    else
      if not isThroneCity and not isThroneCityBattery and not isCityStronghold and not isTradeStation and not isMissileFactory and not isAltar then
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
        self:CloseSelf()
        return
      end
      local targetType = MarchTargetType.SCOUT_ALLIANCE_CITY
      if isThroneCity then
        targetType = MarchTargetType.SCOUT_THRONE
      end
      if isCrossServerThrone then
        if seasonType == SeasonMapType.NineNationRainforest and kingCityId == cityId then
          targetType = MarchTargetType.RAINFOREST_THRONE_SCOUT
        elseif seasonType == SeasonMapType.NineNation and SeasonUtil.IsNineNationKingMember(self.param.info.serverId) then
          if not LuaEntry.Player:IsInSelfServer() then
            UIUtil.ShowTipsId("season_tips143")
            return
          end
          targetType = MarchTargetType.SCOUT_CENTER_THRONE
        else
          targetType = MarchTargetType.SCOUT_SERVER_THRONE_BUILDING
        end
      end
      if isCityStronghold then
        targetType = MarchTargetType.SCOUT_CITY_STRONGHOLD
      end
      if isTradeStation then
        targetType = MarchTargetType.SCOUT_CITY_TRADE
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
      local giveUpEndTime = toInt(self.param.info.giveUpEndTime)
      if LuaEntry.Player:IsInSelfServer() then
        local myAlCityInfo = cityMgr:GetMyAlCityInfo(cityId)
        if myAlCityInfo then
          giveUpEndTime = toInt(myAlCityInfo.giveUpEndTime)
        end
      end
      if 0 < giveUpEndTime then
        local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, LuaEntry.Player:GetCurServerId())
        self:DoGiveUp(cityTemplate, true)
      end
    else
      UIUtil.ShowTipsId(393018)
    end
  elseif self.param.btnType == WorldPointBtnType.MasterySkill then
    DataCenter.MasteryManager:ClickWorldMasteryBtn(self.param.info)
  elseif self.param.btnType == WorldPointBtnType.GiveUpAllianceCity then
    if DataCenter.AllianceBaseDataManager:IsR4orR5() then
      local giveUpEndTime = toInt(self.param.info.giveUpEndTime)
      if LuaEntry.Player:IsInSelfServer() then
        local myAlCityInfo = cityMgr:GetMyAlCityInfo(cityId)
        if myAlCityInfo then
          giveUpEndTime = toInt(myAlCityInfo.giveUpEndTime)
        end
      end
      if giveUpEndTime == 0 then
        local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, LuaEntry.Player:GetCurServerId())
        if cityTemplate.type == WorldAllianceCityType.City then
          local declare_war_cd = toInt(cityTemplate.declare_war_cd)
          if 0 < declare_war_cd then
            local content = Localization:GetString("season_tips217", Localization:GetString("season_s2_achievement_alliance_04", declare_war_cd))
            UIUtil.ShowMessage(content, 2, nil, nil, function()
              self:DoGiveUp(cityTemplate)
            end, nil, nil)
          else
            self:DoGiveUp(cityTemplate)
          end
        elseif cityTemplate.type == WorldAllianceCityType.Stronghold then
          local declare_war_cd = toInt(cityTemplate.declare_war_cd)
          if 0 < declare_war_cd then
            local content = Localization:GetString("season5_reoccupy_tips02", Localization:GetString("season_s2_achievement_alliance_04", declare_war_cd))
            UIUtil.ShowMessage(content, 2, nil, nil, function()
              self:DoGiveUp(cityTemplate)
            end, nil, nil)
          else
            self:DoGiveUp(cityTemplate)
          end
        else
          self:DoGiveUp(cityTemplate)
        end
      end
    else
      UIUtil.ShowTipsId(393018)
    end
  elseif self.param.btnType == WorldPointBtnType.CancelDeclareWar then
    local delayParam = {
      delayTime = 10,
      des1 = "season_alliance_reward_tips_1",
      des2 = "season_alliance_reward_tips_2"
    }
    UIUtil.ShowSecondMessage("", Localization:GetString("new_city_activity_battle_tips1024"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      local data = DataCenter.AllianceDeclareWarManager:GetSelfDeclareWarData()
      if data and tonumber(data.content) == cityId then
        local cityServerId = data.serverId or LuaEntry.Player:GetSelfServerId()
        SFSNetwork.SendMessage(MsgDefines.AllianceDeclareWarCancel, data.uuid, cityServerId)
      end
    end, nil, nil, nil, nil, nil, nil, nil, nil, false, nil, delayParam)
  elseif self.param.btnType == WorldPointBtnType.DetectScoutCity then
    if not self:CanCrossInteraction() then
      return
    end
    local detectData = DataCenter.RadarCenterDataManager:GetCityEventDataByPointIndex(self.view.ctrl.pointId)
    if detectData and detectData.template.type == DetectEventType.ScoutDeclareCity then
      DataCenter.FakeScoutMarchManager:AddMarchIndex(self.view.ctrl.pointId, detectData)
      self:CloseSelf(false)
    else
      UIUtil.ShowTipsId(803041)
    end
  elseif self.param.btnType == WorldPointBtnType.DetectOccupyCity then
    if not self:CanCrossInteraction() then
      return
    end
    local detectData = DataCenter.RadarCenterDataManager:GetCityEventDataByPointIndex(self.view.ctrl.pointId)
    if detectData and detectData.template.type == DetectEventType.ScoutOccupyCity then
      DataCenter.FakeScoutMarchManager:AddMarchIndex(self.view.ctrl.pointId, detectData)
      self:CloseSelf(false)
    else
      UIUtil.ShowTipsId(803041)
    end
  elseif self.param.btnType == WorldPointBtnType.DeclareWar then
    local debugMode = false
    if not LuaEntry.Player:IsInAlliance() then
      UIUtil.ShowTipsId(393055)
      return
    end
    if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
      UIUtil.ShowTipsId(143604)
      return
    end
    if seasonType == SeasonMapType.NineNationRainforest then
      local _mgr = DataCenter.SeasonCampDestroyManager
      if self.param.info and self.param.info.serverId == LuaEntry.Player:GetSourceServerId() then
      elseif _mgr:IsActive() then
        if not _mgr:IsDeclareDay() then
          UIUtil.ShowTipsId("season_s6_activity_1200112_desc26")
          return
        end
        local _aid = self.param and self.param.info and self.param.info.allianceId
        local pTimeSec = self.param.info.protectTime or 0
        local _warTimeIdx
        local pointInfo = CS.SceneManager.World:GetPointInfo(self.param.info.pointId)
        if pointInfo ~= nil then
          local extraInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo)
          if extraInfo ~= nil and not string.IsNullOrEmpty(extraInfo.allianceId) then
            _warTimeIdx = extraInfo.warTimeIndex
          end
        end
        if not string.IsNullOrEmpty(_aid) then
          local _startTime, _endTime = DataCenter.UILWSeasonAllianceWarTimeManager:GetNextWarTime(pTimeSec * 1000, _warTimeIdx, true, true)
          local _now = UITimeManager:GetInstance():GetServerTime()
          if _endTime < _now or _startTime > _now then
            UIUtil.ShowTipsId("season_s6_activity_1200112_desc27")
            return
          end
        end
      else
        UIUtil.ShowTipsId("season_s6_activity_1200112_desc25")
      end
    end
    local state, declareInfo = DataCenter.AllianceDeclareWarManager:GetDeclareState()
    if state == DeclareWarState.Formal then
      UIUtil.ShowTipsId(143548)
      return
    end
    if seasonType == SeasonMapType.NineNation and not DataCenter.AllianceDeclareWarManager:CanDeclareCity(self.param.info.serverId, self.param.info.level) then
      UIUtil.ShowTips(CS.GameEntry.Localization:GetString("season_s5_activity_1200059_desc27"))
      return
    end
    local myAlId = LuaEntry.Player.allianceId
    if not isThroneCity and SeasonUtil.IsOccupyCityCountReachedMax(serverId) then
      UIUtil.ShowTipsId(300727)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDeclareCondition, {anim = true}, self.param.info.cityId, serverId)
      return
    end
    if inProtectMode and ownerAllianceId ~= nil and ownerAllianceId ~= "" and myAlId ~= ownerAllianceId then
      UIUtil.ShowTipsId("season_tips146")
      return
    end
    if not debugMode then
      local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      local createTime = 0
      if baseData and baseData.createTime then
        createTime = baseData.createTime
      end
      local allianceHour = math.floor((UITimeManager:GetInstance():GetServerTime() - createTime) / 3600000)
      local k7 = DataCenter.AllianceDeclareWarManager:GetConfigData("k7")
      if allianceHour < k7 then
        UIUtil.ShowTips(Localization:GetString("new_city_activity_battle_declear_tips1004", k7))
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIDeclareCondition, {anim = true}, self.param.info.cityId, self.param.info.serverId)
        return
      end
      local curMember = 0
      if baseData and baseData.curMember then
        curMember = baseData.curMember
      end
      local k5 = DataCenter.AllianceDeclareWarManager:GetConfigData("k5")
      if curMember < k5 then
        UIUtil.ShowTips(Localization:GetString("new_city_activity_battle_declear_tips1005", k5))
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIDeclareCondition, {anim = true}, self.param.info.cityId, self.param.info.serverId)
        return
      end
    end
    local now = UITimeManager:GetInstance():GetServerSeconds()
    local isPre = protectTime > now
    local needCheckDeclareTime = false
    if isPre then
      if DataCenter.ActivityListDataManager:CheckIfActivityOpen(EnumActivity.SeasonCrossDeclareWarActivity.Type) then
        UIUtil.ShowTipsId("season_tips228")
        return
      end
      if UITimeManager:GetInstance():IsTodayServer(protectTime) then
        needCheckDeclareTime = true
      end
    else
      needCheckDeclareTime = true
      if not LuaEntry.Player:AtHomeNow() then
        local decalreValid = DataCenter.ActivityListDataManager:CheckIfActivityOpen(EnumActivity.SeasonCrossDeclareWarActivity.Type) or DataCenter.ActivityListDataManager:CheckIfActivityOpen(EnumActivity.Season6CampDestroy.Type)
        if not decalreValid then
          UIUtil.ShowTipsId("season_tips249")
          return
        end
      end
    end
    if needCheckDeclareTime then
      local timeDeclare = DataCenter.AllianceDeclareWarManager:GetDeclareTime()
      local k6 = DataCenter.AllianceDeclareWarManager:GetConfigData("k6")
      if timeDeclare >= k6 then
        UIUtil.ShowTips(Localization:GetString("new_city_activity_battle_declear_tips1003", timeDeclare, k6))
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIDeclareCondition, {anim = true}, self.param.info.cityId, self.param.info.serverId)
        return
      end
    end
    if seasonType ~= SeasonMapType.Desert or seasonType ~= SeasonMapType.Nothing then
      if not SeasonUtil.CanAttackCityStronghold(self.param.info.cityId) then
        UIUtil.ShowTipsId("season_tips218")
        return
      end
    elseif seasonType == SeasonMapType.Desert then
      local alreadyExitOccupy = false
      local vecPos = SceneUtils.IndexToTilePos(self.param.info.pointId, ForceChangeScene.World)
      local rangeList = BuildingUtils.GetBuildRoundPos(vecPos, 5, 5)
      for i = 1, #rangeList do
        alreadyExitOccupy = SeasonUtil.IsDesertOccupy(SceneUtils.TilePosToIndex(rangeList[i], ForceChangeScene.World))
        if alreadyExitOccupy then
          break
        end
      end
      if not alreadyExitOccupy then
        UIUtil.ShowTipsId("season_city_battle_tips001")
        WorldDesertSelectEffectManager:GetInstance():ShowWarnPos(self.param.info.pointId, 5, 6)
        return
      end
    end
    if seasonType == SeasonMapType.NineNation or seasonType == SeasonMapType.NineNationRainforest then
      local isWarTimeFuncOpen = DataCenter.UILWSeasonAllianceWarTimeManager:IsFuncOpen()
      local hasOwner = checkstring(ownerAllianceId) ~= ""
      local isDeclareDay = DataCenter.UILWSeasonAllianceWarTimeManager:IsDeclareDay()
      local isCrossDeclareActiveOpen = DataCenter.ActivityListDataManager:CheckIfActivityOpen(EnumActivity.SeasonCrossDeclareWarActivity.Type)
      if not hasOwner and not inProtectMode and isWarTimeFuncOpen and not isDeclareDay then
        UIUtil.ShowTipsId("s5_alliance_battle_time_tips03")
        return
      end
      if hasOwner then
        if inProtectMode then
          UIUtil.ShowTipsId("season_tips251")
          return
        end
        if isCrossDeclareActiveOpen then
          if not isDeclareDay then
            UIUtil.ShowTipsId("s5_alliance_battle_time_tips03")
            return
          end
          if isWarTimeFuncOpen then
            local isWarTime = true
            local pointInfo = CS.SceneManager.World:GetPointInfo(self.param.info.pointId)
            if pointInfo ~= nil then
              local extraInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo)
              if extraInfo ~= nil and not string.IsNullOrEmpty(extraInfo.allianceId) then
                local timeIndex = extraInfo.warTimeIndex
                isWarTime = DataCenter.UILWSeasonAllianceWarTimeManager:IsAllianceWarTime(timeIndex)
              end
            end
            if not isWarTime then
              UIUtil.ShowTipsId("s5_alliance_battle_time_tips04")
              return
            end
          end
        end
      end
    end
    if self.view and self.view.serverData then
      local declareAlliances = self.view.serverData.declareAlliances
      if declareAlliances and 0 < #declareAlliances and table.indexof(declareAlliances, myAlId) == false then
        self:ShowDeclareWar("season_sever_declare_war_022")
        return
      else
      end
      local firstOccupyInfo
      if LuaEntry.Player:AtHomeNow() then
        firstOccupyInfo = self.view.serverData.firstOccupyInfo
      else
        firstOccupyInfo = self.view.serverData.firstCrossOccupyInfo
      end
      if firstOccupyInfo.alAbbr ~= nil and firstOccupyInfo.alAbbr ~= "" then
        self:ShowDeclareWar("season_sever_declare_war_023")
        return
      end
    end
    self:DoDeclareWar()
    return
  elseif self.param.btnType == WorldPointBtnType.BuildNuclear then
    if not self:CanCrossInteraction() then
      return
    end
    local list = DataCenter.WorldMarchDataManager:GetOwnerMarches()
    local num = 0
    if list ~= nil then
      for k, v in pairs(list) do
        if v:GetMarchTargetType() == MarchTargetType.BuildingNuclearPowerPlant and v.targetUUid == self.param.info.uuid then
          num = num + 1
        end
      end
    end
    local attackTime = DataCenter.SeasonNuclearPowerPlantDataManager:GetDailyAttackOrBuildTime(self.param.info.uuid)
    local maxCount = DataCenter.SeasonNuclearPowerPlantDataManager:GetBuildNuclearFurnaceMaxTime()
    if num >= maxCount - attackTime then
      UIUtil.ShowTipsId("season_tips253")
      return
    else
      MarchUtil.OnClickStartMarch(MarchTargetType.BuildingNuclearPowerPlant, self.param.info.pointId, self.param.info.uuid, -1, 1)
    end
  elseif self.param.btnType == WorldPointBtnType.SeasonTradeShopRefresh then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonTradeShopRefresh, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, self.param.info.tradeData)
  elseif self.param.btnType == WorldPointBtnType.SeasonTradeShopEnter then
    if self.param.info.tradeShopState == 0 then
      UIUtil.ShowTipsId("season_s3_trade_city012")
      return
    end
    if self.param.info.tradeShopState == 2 then
      UIUtil.ShowTipsId("season_s3_trade_city014")
      return
    end
    if self.param.info.tradeShopState == 1 then
      DataCenter.SeasonTradeShopDataManager:EnterShop(self.param.info.cityId)
      return
    end
    Logger.LogError("Shop Error state : " .. self.param.info.tradeShopState)
  elseif self.param.btnType == WorldPointBtnType.GiveUpTradeStation then
    UIUtil.ShowSecondMessageByParam({
      tipText = Localization:GetString("season_s3_activity_1000072_desc57"),
      btnNum = 1,
      showToggle = false,
      sureAction = function()
        local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, serverId)
        if cityTemplate and cityTemplate.type == WorldAllianceCityType.TradingStation then
          self:DoGiveUp(cityTemplate, false, serverId)
        end
      end,
      delayConfirm = {delayTime = 5}
    })
  elseif self.param.btnType == WorldPointBtnType.GiveUpTradeStation_Cancel then
    local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(self.param.info.cityId, self.param.info.serverId)
    self:DoGiveUp(cityTemplate, true, self.param.info.serverId)
  elseif self.param.btnType == WorldPointBtnType.CityAltarGiveUp then
    local uuid = self.param.info.uuid
    local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, serverId)
    if cityTemplate and cityTemplate.type == WorldAllianceCityType.Altar then
      self:DoGiveUp(cityTemplate, false, serverId, uuid)
    end
  elseif self.param.btnType == WorldPointBtnType.CityAltarCancelGiveUp then
    local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(self.param.info.cityId, self.param.info.serverId)
    self:DoGiveUp(cityTemplate, true, self.param.info.serverId, self.param.info.uuid)
  elseif self.param.btnType == WorldPointBtnType.CityAltarFish then
    local uuid = self.param.info.uuid
    local param = {}
    param.uuid = uuid
    param.serverId = serverId
    UIManager:GetInstance():OpenWindow(UIWindowNames.S6CityAltarFish, {anim = true}, param)
  elseif self.param.btnType == WorldPointBtnType.CallBack then
    if not self:CanCrossInteraction() then
      return
    end
    local assistanceCount = CS.SceneManager.World:GetMyAssistanceCount(self.param.info.pointId)
    if 0 < assistanceCount then
      local _uuid = DataCenter.WorldMarchDataProxy:GetFirstMyAssistanceMarchUuid(self.param.info.pointId)
      if _uuid ~= 0 then
        MarchUtil.OnBackHome(_uuid)
      end
    end
  elseif self.param.btnType == WorldPointBtnType.AllianceCityRally then
    DataCenter.AllianceBaseDataManager:TrySetRally(self.param.info.pointId)
  elseif self.param.btnType == WorldPointBtnType.ChargeBack then
    local workerData = DataCenter.SeasonPowerWorkerManager:GetPowerWorkerByPointId(self.param.info.pointId)
    if workerData and workerData.uuid then
      SFSNetwork.SendMessage(MsgDefines.CallbackMyPowerWorker, workerData.uuid)
    else
      UIUtil.ShowTipsId("120632")
    end
  elseif self.param.btnType == WorldPointBtnType.GoldTreeCharge then
    MarchUtil.LaunchPowerHelp(MarchTargetType.CHARGE_GOLD_TREE, self.param.info.pointId, self.param.info.uuid)
  elseif self.param.btnType == WorldPointBtnType.GoldTreeBless then
    DataCenter.SeasonGoldTreeManager:OpenUI()
  elseif self.param.btnType == WorldPointBtnType.BankRob then
    if not self:CanCrossInteraction() then
      return
    end
    MarchUtil.OnClickStartMarch(MarchTargetType.CROSS_BANK_ATTACK, self.param.info.pointId, self.param.info.uuid)
  elseif self.param.btnType == WorldPointBtnType.BankDeposit then
    if not self:CanCrossInteraction() then
      return
    end
    if not DataCenter.SeasonBankManager:CheckDepositCondition(self.param.info.cityId, self.param.info.serverId, true) then
      return
    end
    local detail = DataCenter.WorldPointDetailManager:GetAllianceCityData(self.param.info.cityId)
    local serviceScope = detail and detail.bankDetail and detail.bankDetail.setting.serviceScope or 2
    if not DataCenter.SeasonBankManager:CanDepositByScope(serviceScope, self.param.info.ownerServerId, self.param.info.allianceId, true) then
      return
    end
    UIUtil.OpenFormationSelectUI(2, MarchTargetType.CROSS_BANK_DEPOSIT, self.param.info.pointId, self.param.info.uuid, nil, true, nil, LuaEntry.Player:GetCurServerId())
  elseif self.param.btnType == WorldPointBtnType.AllianceSkillReinforceCharge then
    local chargeData = DataCenter.AllianceGovernmentCommonSkillManager:GetChargeData()
    local shieldInfo = self.param.info.shieldInfo
    local skillId
    if shieldInfo then
      skillId = shieldInfo.allianceCity.skillId
    end
    if not chargeData then
      return
    end
    if not skillId then
      UIUtil.ShowTipsId("season_s6_government_skill_desc84")
      return
    end
    if chargeData.usedCount >= chargeData.maxCount then
      UIUtil.ShowTipsId("season_s6_government_skill_desc80")
      return
    end
    local readyTs = DataCenter.ArmyFormationDataManager:GetScoutCD(self.param.info.uuid)
    local now = UITimeManager:GetInstance():GetServerSeconds()
    if readyTs > now then
      local countDown = UITimeManager:GetInstance():SecondToFmtStringWithoutHour(readyTs - now)
      UIUtil.ShowTips(Localization:GetString("season_s6_government_skill_desc79", countDown))
      return
    end
    MarchUtil.LaunchScout(MarchTargetType.CROSS_FORTIFY_CITY_CHARGE, self.view.ctrl.pointId, self.view.ctrl.uuid)
  end
  self:CloseSelf()
end

function UIWorldSiegePointSeasonBtn:DoGiveUp(cityTemplate, isCancel, serverId, uuid)
  isCancel = isCancel or false
  serverId = serverId or LuaEntry.Player:GetCurServerId()
  local cityType = cityTemplate.type
  local name, content = cityTemplate.name
  local cityId = toInt(cityTemplate.id)
  if isCancel then
    name = Localization:GetString("140205", cityTemplate.level, Localization:GetString(cityTemplate.name))
    content = Localization:GetString("393057", name)
    UIUtil.ShowMessage(content, 2, nil, nil, function()
      if cityType == WorldAllianceCityType.Stronghold then
        SFSNetwork.SendMessage(MsgDefines.GiveUpAlCityStronghold, cityId, isCancel, serverId)
      elseif cityType == WorldAllianceCityType.TradingStation then
        SFSNetwork.SendMessage(MsgDefines.GiveUpTradeDelay, serverId, cityId, isCancel)
      elseif cityType == WorldAllianceCityType.Altar then
        SFSNetwork.SendMessage(MsgDefines.CityaltarGiveupCancel, uuid, serverId)
      else
        SFSNetwork.SendMessage(MsgDefines.GiveUpAlCity, cityId, isCancel, serverId)
      end
    end, nil, nil)
    return
  end
  content = Localization:GetString("393056", Localization:GetString(name))
  if SeasonUtil.CanAllianceMakeFriends(serverId) and DataCenter.SeasonAllyFriendManager:HasFriend() and DataCenter.SeasonAllyFriendManager:CheckLink(cityId) then
    if DataCenter.SeasonAllyFriendManager:IsHandshakeUnique() then
      content = content .. "\n" .. Localization:GetString("s6_alliance_ally_info21")
    else
      local cityList = DataCenter.SeasonAllyFriendManager:GetLinkCityList()
      if cityList and cityList[cityId] == true and table.count(cityList) == 1 then
        content = content .. "\n" .. Localization:GetString("s6_alliance_ally_info21")
      end
    end
  end
  if cityType == WorldAllianceCityType.Altar then
    content = Localization:GetString("season_s6_activity1200109_desc27")
  end
  UIUtil.ShowMessage(content, 2, nil, nil, function()
    if cityType == WorldAllianceCityType.Stronghold then
      SFSNetwork.SendMessage(MsgDefines.GiveUpAlCityStronghold, cityId, isCancel, serverId)
    elseif cityType == WorldAllianceCityType.TradingStation then
      SFSNetwork.SendMessage(MsgDefines.GiveUpTradeDelay, serverId, cityId, isCancel)
    elseif cityType == WorldAllianceCityType.Altar then
      SFSNetwork.SendMessage(MsgDefines.CityaltarGiveup, uuid, serverId)
    else
      SFSNetwork.SendMessage(MsgDefines.GiveUpAlCity, cityId, isCancel, serverId)
    end
  end, nil, nil)
end

function UIWorldSiegePointSeasonBtn:ShowDeclareWar(key)
  local param = self.param
  
  local function functionClose()
    self:CloseSelf()
  end
  
  UIUtil.ShowMessage(Localization:GetString(key or "season_sever_declare_war_023"), 2, nil, nil, function()
    self:DoDeclareWar(param)
    self:CloseSelf()
  end, functionClose, functionClose)
end

function UIWorldSiegePointSeasonBtn:DoDeclareWar(viewParam)
  viewParam = viewParam or self.param
  if not viewParam then
    return
  end
  local param = {}
  param.cityId = viewParam.info.cityId
  param.pointId = viewParam.info.pointId
  param.uuid = viewParam.info.uuid
  param.serverId = viewParam.info.serverId
  local state, declareInfo = DataCenter.AllianceDeclareWarManager:GetDeclareState()
  if state == DeclareWarState.PreDeclare then
    local oldCityName = DataCenter.AllianceCityTemplateManager:GetFormatName(tonumber(declareInfo.content))
    local newCityName = DataCenter.AllianceCityTemplateManager:GetFormatName(tonumber(param.cityId))
    local str = Localization:GetString("new_city_activity_battle_tips1002", oldCityName, newCityName)
    UIUtil.ShowMessage(str, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      DataCenter.AllianceDeclareWarManager:SetWarCityParam(param)
      SFSNetwork.SendMessage(MsgDefines.AllianceGetCityDeclareTimes, LuaEntry.Player:GetCurServerId(), param.cityId)
    end)
  else
    local seasonType = SeasonUtil.GetSeasonType()
    if seasonType == SeasonMapType.NineNation then
      local protectTime = 0
      protectTime = math.max(protectTime, checknumber(viewParam.info.openTime))
      protectTime = math.max(protectTime, checknumber(viewParam.info.protectTime))
      if 0 < protectTime then
        local leftTime = protectTime - UITimeManager:GetInstance():GetServerSeconds()
        local hour = math.floor(leftTime / OneHourTime)
        local limit = DataCenter.AllianceDeclareWarManager:GetConfigData("k13")
        if hour >= limit then
          UIUtil.ShowTips(CS.GameEntry.Localization:GetString("S5_pre_declare_tips01", limit))
          return
        end
      end
    end
    DataCenter.AllianceDeclareWarManager:SetWarCityParam(param)
    SFSNetwork.SendMessage(MsgDefines.AllianceGetCityDeclareTimes, LuaEntry.Player:GetCurServerId(), param.cityId)
  end
end

function UIWorldSiegePointSeasonBtn:OnRefinementDetail()
  if self.param.btnType == WorldPointBtnType.AllianceSkillReinforceCharge then
    local chargeData = DataCenter.AllianceGovernmentCommonSkillManager:GetChargeData()
    if not chargeData then
      self.btn_text:SetActive(false)
      return
    end
    self.btn_text:SetActive(true)
    if chargeData.usedCount >= chargeData.maxCount then
      CS.UIGray.SetGray(self.btnImage.transform, true, true)
      self.btn_text:SetText(string.format("<color=\"#f53c3d\">%s</color>/%s", chargeData.maxCount - chargeData.usedCount, chargeData.maxCount))
    else
      CS.UIGray.SetGray(self.btnImage.transform, false, true)
      self.btn_text:SetText(string.format("<color=\"#FFFFFF\">%s</color>/%s", chargeData.maxCount - chargeData.usedCount, chargeData.maxCount))
    end
    if self.cd_test then
      self.cd_test:SetActive(true)
    end
    self:Update1000MS()
  elseif self.cd_test then
    self.cd_test:SetActive(false)
  end
end

function UIWorldSiegePointSeasonBtn:Update1000MS()
  if self.param.btnType == WorldPointBtnType.AllianceSkillReinforceCharge and self.cd_test and self.param and self.param.info.shieldInfo then
    local shieldInfo = self.param.info.shieldInfo
    local now = UITimeManager:GetInstance():GetServerTime()
    if shieldInfo.allianceCity then
      local endTime = shieldInfo.allianceCity.chargeEndTime
      self.cd_test:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(endTime - now))
    end
  end
end

function UIWorldSiegePointSeasonBtn:CloseSelf()
  if self and self.view and self.view.ctrl then
    self.view.ctrl:CloseSelf()
  end
end

local function PlayAnim(self, name)
  if self.anim then
    self.anim:Play(name, 0, 0)
  end
end

UIWorldSiegePointSeasonBtn.OnCreate = OnCreate
UIWorldSiegePointSeasonBtn.OnDestroy = OnDestroy
UIWorldSiegePointSeasonBtn.OnEnable = OnEnable
UIWorldSiegePointSeasonBtn.OnDisable = OnDisable
UIWorldSiegePointSeasonBtn.ComponentDefine = ComponentDefine
UIWorldSiegePointSeasonBtn.ComponentDestroy = ComponentDestroy
UIWorldSiegePointSeasonBtn.DataDefine = DataDefine
UIWorldSiegePointSeasonBtn.DataDestroy = DataDestroy
UIWorldSiegePointSeasonBtn.ReInit = ReInit
UIWorldSiegePointSeasonBtn.OnBtnClick = OnBtnClick
UIWorldSiegePointSeasonBtn.PlayAnim = PlayAnim
return UIWorldSiegePointSeasonBtn
