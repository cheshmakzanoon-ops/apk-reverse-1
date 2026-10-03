local UIWorldSiegePointSeasonCtrl = BaseClass("UIWorldSiegePointSeasonCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local TradeStataionPointData = require("DataCenter.AllianceCityTip.Season.TradeStation.TradeStataionPointData")

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldSiegePointSeason)
end

local function InitData(self, cityId, pointId, serverId, uuid)
  local curServerId = serverId or LuaEntry.Player:GetCurServerId()
  self.uuid = uuid
  self.cityId = cityId
  self.pointId = pointId
  self.serverId = curServerId
  local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, curServerId)
  if cityTemplate then
    curServerId = cityTemplate:GetCurServerId(self.serverId)
    self.serverId = curServerId
    self.isKingCity = cityTemplate:IsThroneCity()
    self.worldCityType = cityTemplate.type
    self.seasonNum = cityTemplate:getIntValue("season", 0)
    local seasonInfo = SeasonUtil.GetSeasonInfo(curServerId)
    if seasonInfo then
      self.seasonType = seasonInfo:GetServerSubdivisionType(false)
    end
    if cityTemplate.type == WorldAllianceCityType.Stronghold then
      SFSNetwork.SendMessage(MsgDefines.WorldGetCityStrongholdDetail, cityId, curServerId)
    elseif cityTemplate.type == WorldAllianceCityType.TradingStation then
      DataCenter.SeasonTradeShopDataManager:ReqTradeDetail(cityId, curServerId)
    elseif cityTemplate.type == WorldAllianceCityType.GoldTree then
      local pointInfo = CS.SceneManager.World:GetPointInfo(self.pointId)
      local allianceCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
      if not allianceCityPointInfo then
        UIUtil.ShowTipsId(120632)
      elseif allianceCityPointInfo.finishTime and 0 < allianceCityPointInfo.finishTime then
        DataCenter.SeasonGoldTreeManager:RequestAnnounceList(0, curServerId)
      else
        SFSNetwork.SendMessage(MsgDefines.GoldTreePowerRankView, allianceCityPointInfo.treeId, curServerId)
      end
    elseif cityTemplate.type == WorldAllianceCityType.Mountain then
    elseif cityTemplate.type == WorldAllianceCityType.Canon or cityTemplate.type == WorldAllianceCityType.MissileFactory or cityTemplate.type == WorldAllianceCityType.CrossZoneOutpostCanon then
      if SeasonUtil.GetSeason() >= 4 then
        WorldBattleUtil.TryRequestCityInfo(SeasonUtil.GetKingCityId(curServerId), curServerId)
      end
      WorldBattleUtil.TryRequestCityInfo(cityId, curServerId)
    else
      WorldBattleUtil.TryRequestCityInfo(cityId, curServerId)
    end
  end
  if self.seasonType == SeasonMapType.NineNationRainforest then
    DataCenter.SeasonAllyFriendManager:SetHandshakeUnique(false)
  end
end

local function GetAllianceCityData(self, cityId)
  local oneData = {}
  oneData.cityId = cityId
  oneData.isInAlliance = false
  oneData.pointId = self.pointId
  oneData.uuid = self.uuid
  oneData.serverId = self.serverId
  oneData.isKingCity = self.isKingCity
  oneData.worldCityType = self.worldCityType
  oneData.skipBtnSort = false
  oneData.seasonType = self.seasonType
  local hasGiveUpBtn = false
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local isMyCampServer = DataCenter.SeasonFactionWarDataManager:IsInSameCampByServer(mySourceServerId, self.serverId)
  local showDeclareBtn = false
  local allianceUid = ""
  local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if data ~= nil then
    allianceUid = data.uid
    if allianceUid ~= nil and allianceUid ~= "" then
      oneData.isInAlliance = true
    end
  end
  local mgr = DataCenter.WorldAllianceCityDataManager
  local bigMapIndex = 0
  local ignoreViewMode = SeasonUtil.CanCrossInteraction(self.serverId)
  local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, self.serverId)
  if cityTemplate ~= nil then
    bigMapIndex = cityTemplate.bigMapIndex
    oneData.isKingCity = cityTemplate:IsThroneCity()
    oneData.meta = cityTemplate
    oneData.type = cityTemplate.type
    oneData.level = cityTemplate.level
    oneData.name = cityTemplate.name
    oneData.city_dmg_param = cityTemplate.city_dmg_param
    oneData.show_pic = cityTemplate.show_pic
    oneData.avatar = cityTemplate.avatar
    oneData.avatar_big = cityTemplate.avatar_big
    oneData.force = cityTemplate.force
    oneData.destroy_force = cityTemplate.destroy_force
    oneData.stronghold_max = cityTemplate.stronghold_max
    if bigMapIndex ~= 5 and self.seasonType == SeasonMapType.NineNationRainforest and cityTemplate:IsThroneCity() then
      local force = LuaEntry.DataConfig:TryGetNum("season_s6_zone_war_force", "k2", 0)
      local destroy_force = LuaEntry.DataConfig:TryGetNum("season_s6_zone_war_force", "k3", 0)
      oneData.force = force
      oneData.destroy_force = destroy_force
      oneData.forceTipKey = "season_s6_throne_info"
      oneData.forceTipUI = UIWindowNames.UILWSeasonS6CrossOccupyDetail
    end
    oneData.defence_buff = cityTemplate.defence_buff
    oneData.loot_rewards = cityTemplate.loot_rewards
    oneData.sever_loot_reward = cityTemplate.sever_loot_reward
    oneData.the_show_reward_str = cityTemplate.show_reward
    oneData.alliance_destroy_reward_show = cityTemplate.alliance_destroy_reward_show
    oneData.rewardStr = DataCenter.RewardManager:ParseRewardsStr(cityTemplate.show_reward)
    if not string.IsNullOrEmpty(cityTemplate.alliance_destroy_reward_show) then
      oneData.destroyRewardStr = DataCenter.RewardManager:ParseRewardsStr(cityTemplate.alliance_destroy_reward_show)
    end
    oneData.userName = ""
    local cityInfo = mgr:GetAllianceCityDataByCityId(cityId)
    if cityInfo ~= nil and cityInfo.cityName ~= nil and cityInfo.cityName ~= "" then
      oneData.userName = cityInfo.cityName
    end
    oneData.resistance = toInt(cityTemplate.city_resistance_b or 0)
    oneData.selfValue = SeasonUtil.GetSelfSeasonResistanceValue()
    oneData.selfPercent = SeasonUtil.GetSeasonResistanceSelf(oneData.selfValue, oneData.resistance, 0) - 1
    oneData.otherPercent = SeasonUtil.GetSeasonResistanceOther(oneData.selfValue, oneData.resistance, 0)
    oneData.monsterNum = cityTemplate.monster_num
    oneData.maxDurability = cityTemplate.wall
    oneData.cityRecoverSpeed = cityTemplate.wall_recover
    oneData.monsterRecoverTime = cityTemplate.army_recover_time
    local recommend = cityTemplate.recommend_soldier
    oneData.recommend_power = toInt(recommend)
    oneData.buffDes = ""
    oneData.buffAddNum = ""
    local buff = cityTemplate.buff
    if buff ~= nil then
      local buffArr = string.split(buff, "|")
      if 0 < #buffArr then
        local buffStr = string.split(buffArr[1], ";")
        if 1 < #buffStr then
          local effectId = tonumber(buffStr[1])
          if effectId ~= 30145 then
            local value = tonumber(buffStr[2])
            local buffAddNum, nameStr = UIUtil.GetEffectStr(nil, value, effectId)
            if buffAddNum and nameStr then
              oneData.buffDes = nameStr
              oneData.buffAddNum = buffAddNum
            end
          end
        end
        if 1 < #buffArr then
          local buffStr2 = string.split(buffArr[2], ";")
          if 1 < #buffStr2 then
            local effectId = tonumber(buffStr2[1])
            if effectId ~= nil and effectId ~= 30145 then
              local value = tonumber(buffStr2[2])
              local nameStr = GetTableData(TableName.LW_Effect_Number, effectId, "name")
              oneData.buffDes2 = nameStr
              local type = toInt(GetTableData(TableName.LW_Effect_Number, effectId, "type"))
              if type == EffectLocalTypeInEffectDesc.Num then
                oneData.buffAddNum2 = string.GetFormattedSeperatorNum(value)
              elseif type == EffectLocalTypeInEffectDesc.Percent then
                oneData.buffAddNum2 = string.GetFormattedPercentStr(value)
              elseif type == EffectLocalTypeInEffectDesc.Thousandth then
                oneData.buffAddNum2 = string.GetFormattedThousandthStr(value)
              else
                oneData.buffAddNum2 = ""
                Logger.LogError("city effectId is error, " .. effectId .. " , " .. cityId)
              end
            end
          end
        end
      end
    end
    local lordBuff = cityTemplate:getValue("lord_buff")
    if not string.IsNullOrEmpty(lordBuff) then
      local buffArr = string.split(lordBuff, "|")
      if 0 < #buffArr then
        self:ParseBuff(oneData, "lordBuff", buffArr[1])
      end
    end
    oneData.tax_rate = cityTemplate.tax_rate
    oneData.alliance_discount = 1 - cityTemplate.alliance_discount
    oneData.dead_rate = ""
    local wounded_rate = cityTemplate.wounded_rate
    local injury_rate = cityTemplate.injury_rate
    if wounded_rate and injury_rate then
      local rate = 100 - wounded_rate - injury_rate
      oneData.dead_rate = rate .. "%"
    end
    oneData.temperatureCfg = cityTemplate.temperatureCfg
    oneData.season_snow_stone_id = toInt(cityTemplate.season_snow_stone_id)
    oneData.season_snow_stone_value = toInt(cityTemplate.season_snow_stone_value)
    oneData.season_snow_coal_id = toInt(cityTemplate.season_snow_coal_id)
    oneData.season_snow_coal_value = toInt(cityTemplate.season_snow_coal_value)
  end
  local pointInfo = CS.SceneManager.World:GetPointInfoByUuid(self.uuid)
  if pointInfo ~= nil and pointInfo ~= nil then
    oneData.pointId = pointInfo.pointIndex
    oneData.uuid = pointInfo.uuid
    oneData.serverId = pointInfo.serverId
    local myAllianceId = LuaEntry.Player:GetAllianceUid()
    local isJumpToServerMode = CrossServerUtil.IsJumpToServerMode()
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    local allianceCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
    if allianceCityPointInfo ~= nil then
      oneData.ruinTime = allianceCityPointInfo.ruinTime or 0
      oneData.openTime = allianceCityPointInfo.openTime or 0
      oneData.state = allianceCityPointInfo.state
      oneData.protectTime = allianceCityPointInfo.protectTime or 0
      oneData.alAbbr = allianceCityPointInfo.alAbbr
      oneData.alName = allianceCityPointInfo.alName
      oneData.allianceId = allianceCityPointInfo.allianceId
      oneData.durability = allianceCityPointInfo.durability
      oneData.ownerServerId = allianceCityPointInfo.serverId
      oneData.lastDurabilityTime = allianceCityPointInfo.lastDurabilityTime
      oneData.buildPoint = allianceCityPointInfo.buildPoint
      oneData.buildStartTime = allianceCityPointInfo.buildStartTime
      oneData.giveUpEndTime = toInt(allianceCityPointInfo.giveUpTime) * 1000
      oneData.soldierRemain = allianceCityPointInfo.soldierRemain
      local loginServerId = LuaEntry.Player:GetSelfServerId()
      local cityAllianceId = allianceCityPointInfo.allianceId
      local isKingCityAndCanBattle = false
      local inProtectMode = curTime < toInt(oneData.protectTime)
      oneData.btnList = {}
      if DataCenter.MasteryManager:GetUnlockedSkillTemplateByUsePos(MasterySkillUsePosType.AllianceCity) then
        table.insert(oneData.btnList, WorldPointBtnType.MasterySkill)
      end
      if oneData.type == WorldAllianceCityType.Stronghold then
        oneData.canBattle = not inProtectMode
        oneData.battleStartTime = allianceCityPointInfo.battleStartTime
        oneData.battleEndTime = allianceCityPointInfo.battleEndTime
        oneData.buildPointInfo = allianceCityPointInfo.buildPointInfo
        local isAttackMode = false
        if string.IsNullOrEmpty(cityAllianceId) or string.IsNullOrEmpty(myAllianceId) then
          if oneData.buildPointInfo == nil or string.IsNullOrEmpty(oneData.buildPointInfo.allianceId) or oneData.buildPointInfo.allianceId ~= myAllianceId then
            isAttackMode = true
            table.insert(oneData.btnList, WorldPointBtnType.ScoutCity)
            table.insert(oneData.btnList, WorldPointBtnType.RallyCity)
            table.insert(oneData.btnList, WorldPointBtnType.AttackCity)
            if (oneData.state == AllianceCityState.OCCUPIED or oneData.state == AllianceCityState.SERVER_OCCUPIED) and DataCenter.SeasonBankManager:BankActive(allianceCityPointInfo) and not DataCenter.SeasonBankManager:CanRob(allianceCityPointInfo.bankRobInfo) then
              table.insert(oneData.btnList, WorldPointBtnType.BankDeposit)
            end
          else
            UIUtil.InsertAssistanceCityBtn(oneData.btnList, self.pointId, WorldPointBtnType.AssistanceCity)
          end
        elseif cityAllianceId == myAllianceId then
          local canAssist = true
          if oneData.state == AllianceCityState.OCCUPIED or oneData.state == AllianceCityState.SERVER_OCCUPIED then
            local isGivingUp = oneData.giveUpEndTime and 0 < oneData.giveUpEndTime
            if isGivingUp then
              table.insert(oneData.btnList, WorldPointBtnType.GiveUpAllianceCity_Cancel)
            else
              hasGiveUpBtn = true
              table.insert(oneData.btnList, WorldPointBtnType.GiveUpAllianceCity)
            end
            if DataCenter.SeasonBankManager:BankActive(allianceCityPointInfo) then
              if DataCenter.SeasonBankManager:CanRob(allianceCityPointInfo.bankRobInfo) then
                table.insert(oneData.btnList, WorldPointBtnType.BankRob)
                canAssist = false
              else
                table.insert(oneData.btnList, WorldPointBtnType.BankDeposit)
              end
            end
          end
          UIUtil.InsertAssistanceCityBtn(oneData.btnList, self.pointId, canAssist and WorldPointBtnType.AssistanceCity)
        else
          isAttackMode = true
          table.insert(oneData.btnList, WorldPointBtnType.ScoutCity)
          table.insert(oneData.btnList, WorldPointBtnType.RallyCity)
          table.insert(oneData.btnList, WorldPointBtnType.AttackCity)
          if (oneData.state == AllianceCityState.OCCUPIED or oneData.state == AllianceCityState.SERVER_OCCUPIED) and DataCenter.SeasonBankManager:BankActive(allianceCityPointInfo) and not DataCenter.SeasonBankManager:CanRob(allianceCityPointInfo.bankRobInfo) then
            table.insert(oneData.btnList, WorldPointBtnType.BankDeposit)
          end
        end
        if isAttackMode and not SeasonUtil.AttackCityStrongholdSeason() then
          oneData.btnList = {}
        end
        if self.seasonType == SeasonMapType.NineNationRainforest and mgr:IsMyCamp(self.serverId, cityId) then
          table.insert(oneData.btnList, WorldPointBtnType.Fishing)
        end
        UIUtil.CheckEventTrigger(OpMode.ClickBtnStrongholdCity, 0, 1)
      elseif oneData.type == WorldAllianceCityType.Mountain then
      elseif oneData.type == WorldAllianceCityType.CrossZoneOutpostCanon then
        local battleStartTime = toInt(allianceCityPointInfo.battleStartTime)
        local inBattleMode = 0 <= battleStartTime and curTime >= battleStartTime
        if inProtectMode or oneData.state == 0 or not inBattleMode then
          oneData.forbidden = true
          local skinModel = SeasonUtil.GetCanonAnimModel(cityId, self.uuid, cityTemplate)
          if skinModel then
            local simAnim = skinModel:GetComponent(typeof(CS.SimpleAnimation))
            if simAnim and not simAnim:IsPlaying("idle") then
              simAnim:Play("idle")
            end
          end
        elseif loginServerId == self.serverId then
          local tmpOwnerServerId = toInt(allianceCityPointInfo.tmpOwnerServerId)
          if tmpOwnerServerId == mySourceServerId then
            table.insert(oneData.btnList, WorldPointBtnType.AssistanceCity)
          else
            table.insert(oneData.btnList, WorldPointBtnType.ScoutCity)
            if oneData.isInAlliance == true then
              table.insert(oneData.btnList, WorldPointBtnType.RallyCity)
            end
            table.insert(oneData.btnList, WorldPointBtnType.AttackCity)
          end
        end
      elseif WorldPointType.WORLD_CITY_TRADE == pointInfo.PointType then
        cityAllianceId = allianceCityPointInfo.tempAllianceId
        local tradeData = TradeStataionPointData.New()
        tradeData:ParseData(allianceCityPointInfo, pointInfo.serverId)
        ignoreViewMode = true
        oneData.tradeData = tradeData
        oneData.tradeShopState = tradeData:GetShopState()
        local curTimeState = tradeData:GetTimeState()
        local myPoint = LuaEntry.Player:GetUid() == tradeData.uid
        local myAlliance = tradeData.allianceId == LuaEntry.Player:GetAllianceUid()
        local hasLord = tradeData:HasLord()
        if curTimeState == AllianceCityShowTimeState.TradeLock then
          oneData.skipBtnSort = true
          if hasLord then
            table.insert(oneData.btnList, WorldPointBtnType.SeasonTradeShopEnter)
          end
          if 0 < tradeData:GetShopRefreshNum() and myPoint then
            table.insert(oneData.btnList, WorldPointBtnType.SeasonTradeShopRefresh)
          end
          if myPoint then
            if 0 < tradeData:GetGiveUpTimeLeft() then
              table.insert(oneData.btnList, WorldPointBtnType.GiveUpTradeStation_Cancel)
            else
              table.insert(oneData.btnList, WorldPointBtnType.GiveUpTradeStation)
            end
          elseif not myAlliance then
            table.insert(oneData.btnList, WorldPointBtnType.AttackCity)
          end
        elseif curTimeState == AllianceCityShowTimeState.TradeBattle then
          table.insert(oneData.btnList, WorldPointBtnType.TradeStationBattleInfo)
          if not string.IsNullOrEmpty(cityAllianceId) and myAllianceId == cityAllianceId then
            UIUtil.InsertAssistanceCityBtn(oneData.btnList, self.pointId, WorldPointBtnType.AssistanceCity)
          else
            table.insert(oneData.btnList, WorldPointBtnType.ScoutCity)
            table.insert(oneData.btnList, WorldPointBtnType.AttackCity)
          end
          if myPoint then
            if 0 < tradeData:GetGiveUpTimeLeft() then
              table.insert(oneData.btnList, WorldPointBtnType.GiveUpTradeStation_Cancel)
            else
              table.insert(oneData.btnList, WorldPointBtnType.GiveUpTradeStation)
            end
          end
        else
          if hasLord then
            table.insert(oneData.btnList, WorldPointBtnType.SeasonTradeShopEnter)
          end
          if 0 < tradeData:GetShopRefreshNum() and myPoint then
            table.insert(oneData.btnList, WorldPointBtnType.SeasonTradeShopRefresh)
          end
          if myPoint then
            local infoServer = DataCenter.SeasonDataManager:GetServerSeasonInfo()
            if infoServer then
              local settleTime = infoServer:GetSeasonSettleTime()
              if 0 < settleTime and curTime > settleTime then
                if 0 < tradeData:GetGiveUpTimeLeft() then
                  table.insert(oneData.btnList, WorldPointBtnType.GiveUpTradeStation_Cancel)
                else
                  table.insert(oneData.btnList, WorldPointBtnType.GiveUpTradeStation)
                end
              end
            end
          end
        end
        if not SeasonUtil.IsInSeason() then
          oneData.btnList = {}
        end
        UIUtil.CheckEventTrigger(OpMode.ClickBtnTradeShop, 0, 1)
      elseif WorldPointType.CITY_ALTAR == pointInfo.PointType then
        UIUtil.CheckEventTrigger(OpMode.ClickBtnAltarCity, 0, 1)
        local altarData = DataCenter.SeasonCityAltarManager:GetPointData(allianceCityPointInfo, pointInfo.serverId)
        oneData.altarData = altarData
        local timeState, time = altarData:GetTimeState()
        local hasOwner = altarData:HasOwner()
        local belongMyAlliance = altarData:BelongMyAlliance()
        if timeState == AllianceCityShowTimeState.AltarBattle then
          local tmpOwner = altarData:GetTmpOwner()
          local occupying = tmpOwner ~= nil and not string.IsNullOrEmpty(tmpOwner.allianceId)
          local otherOccupying = occupying and tmpOwner.allianceId ~= LuaEntry.Player.allianceId
          local myOccupying = occupying and tmpOwner.allianceId == LuaEntry.Player.allianceId
          local needAssist = myOccupying or belongMyAlliance and not otherOccupying
          if needAssist then
            UIUtil.InsertAssistanceCityBtn(oneData.btnList, self.pointId, WorldPointBtnType.AssistanceCity)
          else
            table.insert(oneData.btnList, WorldPointBtnType.AttackCity)
          end
        elseif belongMyAlliance then
          if altarData:CheckOptAuth() then
            if altarData:CanFish() then
              table.insert(oneData.btnList, WorldPointBtnType.CityAltarFish)
            end
            if altarData:IsGivingUp() then
              table.insert(oneData.btnList, WorldPointBtnType.CityAltarCancelGiveUp)
            else
              table.insert(oneData.btnList, WorldPointBtnType.CityAltarGiveUp)
            end
          end
        else
          table.insert(oneData.btnList, WorldPointBtnType.AttackCity)
        end
      elseif WorldPointType.GOLD_TREE == pointInfo.PointType then
        if not UIUtil.CheckEventTrigger(OpMode.ClickBtnS4Tree, 0, 1) and SeasonUtil.IsInSeason() and oneData.serverId == LuaEntry.Player:GetSourceServerId() then
          if allianceCityPointInfo.finishTime and 0 < allianceCityPointInfo.finishTime then
            if DataCenter.SeasonGoldTreeManager:IsActive() then
              table.insert(oneData.btnList, WorldPointBtnType.GoldTreeBless)
            end
          else
            local workerData = DataCenter.SeasonPowerWorkerManager:GetPowerWorkerByPointId(oneData.pointId)
            if workerData and workerData.uuid then
              table.insert(oneData.btnList, WorldPointBtnType.ChargeBack)
            else
              table.insert(oneData.btnList, WorldPointBtnType.GoldTreeCharge)
            end
          end
        end
      else
        if oneData.isKingCity then
          if bigMapIndex == 5 then
            UIUtil.CheckEventTrigger(OpMode.ClickBtnBigKingCity, 0, 1)
          else
            UIUtil.CheckEventTrigger(OpMode.ClickBtnKingCity, 0, 1)
          end
        elseif oneData.type == WorldAllianceCityType.City then
          UIUtil.CheckEventTrigger(OpMode.ClickBtnWorldCity, 0, 1)
          if not IsNull(pointInfo.CityInfo) then
            local cityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
            oneData.shieldInfo = cityPointInfo.shieldInfo
          end
          if oneData.shieldInfo and oneData.shieldInfo.allianceCity then
            local allianceCity = oneData.shieldInfo.allianceCity
            local serverTime = UITimeManager:GetInstance():GetServerTime()
            local timeCheck = serverTime < allianceCity.chargeEndTime
            if timeCheck then
              local allianceInfo = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
              if allianceInfo then
                local participantAllianceIds = allianceCity.participantAllianceIds
                for k, v in ipairs(participantAllianceIds) do
                  if v == allianceInfo.uid then
                    table.insert(oneData.btnList, WorldPointBtnType.AllianceSkillReinforceCharge)
                    SFSNetwork.SendMessage(MsgDefines.GetFortifyChargeInfo, pointInfo.uuid)
                    break
                  end
                end
              end
            end
          end
        end
        oneData.CrossKingBuildPointInfo = allianceCityPointInfo.buildPointInfo
        oneData.isCrossServerThrone = (oneData.type == WorldAllianceCityType.Canon or oneData.type == WorldAllianceCityType.MissileFactory or oneData.type == WorldAllianceCityType.CrossZoneOutpostCanon or oneData.isKingCity) and (oneData.state == AllianceCityState.SERVER_NEUTRAL or oneData.state == AllianceCityState.SERVER_OCCUPIED or oneData.state == AllianceCityState.SERVER_BUILD_THRONE)
        if oneData.isKingCity or oneData.type == WorldAllianceCityType.Canon or oneData.type == WorldAllianceCityType.MissileFactory or oneData.type == WorldAllianceCityType.CrossZoneOutpostCanon or oneData.isCrossServerThrone then
          if oneData.isCrossServerThrone then
            local totalPoint = SeasonUtil.GetWorldBattleTotalPoint(oneData.serverId)
            if totalPoint <= oneData.buildPoint then
              oneData.state = AllianceCityState.SERVER_OCCUPIED
            end
          end
          local timeOpen = oneData.openTime
          local timeEnd = oneData.protectTime
          if curTime > timeOpen and curTime < timeEnd then
            if oneData.isCrossServerThrone then
              isKingCityAndCanBattle = oneData.state ~= AllianceCityState.SERVER_OCCUPIED
            elseif LuaEntry.Player:AtHomeNow() then
              local activityServerData = DataCenter.GovernmentManager.activityServerData
              if activityServerData == nil or activityServerData.actFightStep ~= 2 then
                isKingCityAndCanBattle = oneData.isKingCity
              end
            end
          end
          oneData.canBattle = isKingCityAndCanBattle
        else
          oneData.canBattle = not inProtectMode
        end
        if oneData.type == WorldAllianceCityType.MissileFactory and not isKingCityAndCanBattle then
          oneData.forbidden = true
          local skinModel = SeasonUtil.GetCanonAnimModel(cityId, self.uuid, cityTemplate)
          if skinModel then
            local simAnim = skinModel:GetComponent(typeof(CS.SimpleAnimation))
            if simAnim and not simAnim:IsPlaying("idle") then
              simAnim:Play("idle")
            end
          end
        elseif oneData.type == WorldAllianceCityType.Canon and not isKingCityAndCanBattle then
          oneData.forbidden = true
          local skinModel = SeasonUtil.GetCanonAnimModel(cityId, self.uuid, cityTemplate)
          if skinModel then
            local simAnim = skinModel:GetComponent(typeof(CS.SimpleAnimation))
            if simAnim and not simAnim:IsPlaying("idle") then
              simAnim:Play("idle")
            end
          end
        elseif oneData.isCrossServerThrone then
          if pointInfo:IsFrozen() then
            if oneData.isInAlliance and oneData.canBattle then
              table.insert(oneData.btnList, cityAllianceId == allianceUid and WorldPointBtnType.DigIceAlly or WorldPointBtnType.DigIceEnemy)
            end
          elseif not isKingCityAndCanBattle or oneData.state == AllianceCityState.SERVER_OCCUPIED then
            oneData.forbidden = true
          elseif oneData.state == AllianceCityState.SERVER_NEUTRAL then
            table.insert(oneData.btnList, WorldPointBtnType.ScoutCity)
            if oneData.isInAlliance == true and (self.seasonType == SeasonMapType.NineNationRainforest or not SeasonUtil.IsNineNationKingMember(oneData.serverId)) then
              table.insert(oneData.btnList, WorldPointBtnType.RallyCity)
            end
            table.insert(oneData.btnList, WorldPointBtnType.AttackCity)
          elseif oneData.state == AllianceCityState.SERVER_BUILD_THRONE then
            if oneData.type == WorldAllianceCityType.MissileFactory then
              if oneData.isInAlliance and cityAllianceId == allianceUid then
                UIUtil.InsertAssistanceCityBtn(oneData.btnList, self.pointId, WorldPointBtnType.AssistanceCity)
              else
                table.insert(oneData.btnList, WorldPointBtnType.ScoutCity)
                if oneData.isInAlliance == true and (self.seasonType == SeasonMapType.NineNationRainforest or not SeasonUtil.IsNineNationKingMember()) then
                  table.insert(oneData.btnList, WorldPointBtnType.RallyCity)
                end
                table.insert(oneData.btnList, WorldPointBtnType.AttackCity)
              end
            else
              local sourceServerId = LuaEntry.Player:GetSourceServerId()
              if SeasonUtil.IsAlly(oneData.ownerServerId, sourceServerId, oneData.allianceId) then
                UIUtil.InsertAssistanceCityBtn(oneData.btnList, self.pointId, WorldPointBtnType.AssistanceCity)
              else
                table.insert(oneData.btnList, WorldPointBtnType.ScoutCity)
                if oneData.isInAlliance == true and (self.seasonType == SeasonMapType.NineNationRainforest or not SeasonUtil.IsNineNationKingMember()) then
                  table.insert(oneData.btnList, WorldPointBtnType.RallyCity)
                end
                table.insert(oneData.btnList, WorldPointBtnType.AttackCity)
              end
            end
          end
          if not SeasonUtil.IsBattleMember(oneData.serverId) then
            if self.seasonType == SeasonMapType.NineNationRainforest then
              if not DataCenter.SeasonAllyFriendManager:IsMyAllianceFriend(cityAllianceId) then
                oneData.btnList = {}
                oneData.forbidden = true
              end
            else
              oneData.btnList = {}
              oneData.forbidden = true
            end
          end
        elseif oneData.isInAlliance == true then
          if oneData.canBattle and pointInfo:IsFrozen() then
            table.insert(oneData.btnList, cityAllianceId == allianceUid and WorldPointBtnType.DigIceAlly or WorldPointBtnType.DigIceEnemy)
          end
          if (oneData.state == AllianceCityState.BUILDING or oneData.state == AllianceCityState.SERVER_BUILD_THRONE) and cityAllianceId == allianceUid then
            UIUtil.InsertAssistanceCityBtn(oneData.btnList, self.pointId, WorldPointBtnType.AssistanceCity)
          elseif (oneData.state == AllianceCityState.BUILDING or oneData.state == AllianceCityState.OCCUPIED) and oneData.type == WorldAllianceCityType.City and DataCenter.SeasonAllyFriendManager:IsMyFriendAlly(cityAllianceId) then
            UIUtil.InsertAssistanceCityBtn(oneData.btnList, self.pointId, WorldPointBtnType.AssistanceAllyFriendCity)
          elseif (oneData.state == AllianceCityState.OCCUPIED or oneData.state == AllianceCityState.SERVER_OCCUPIED) and cityAllianceId == allianceUid then
            UIUtil.InsertAssistanceCityBtn(oneData.btnList, self.pointId, WorldPointBtnType.AssistanceCity)
            if not oneData.isKingCity then
              local isGivingUp = oneData.giveUpEndTime and 0 < oneData.giveUpEndTime
              if isGivingUp then
                table.insert(oneData.btnList, WorldPointBtnType.GiveUpAllianceCity_Cancel)
              else
                hasGiveUpBtn = true
                table.insert(oneData.btnList, WorldPointBtnType.GiveUpAllianceCity)
              end
            end
            if LuaEntry.Player:AtHomeNow() then
              local detectEvent = DataCenter.RadarCenterDataManager:GetCityEventDataByPointIndex(self.pointId)
              if detectEvent and detectEvent.template and detectEvent.template.type == DetectEventType.ScoutOccupyCity and detectEvent.state == DetectEventState.DETECT_EVENT_STATE_NOT_FINISH then
                table.insert(oneData.btnList, WorldPointBtnType.DetectOccupyCity)
              end
            end
          elseif oneData.isKingCity then
            if isKingCityAndCanBattle and LuaEntry.Player:AtHomeNow() and not pointInfo:IsFrozen() then
              table.insert(oneData.btnList, WorldPointBtnType.ScoutCity)
              table.insert(oneData.btnList, WorldPointBtnType.RallyCity)
              table.insert(oneData.btnList, WorldPointBtnType.AttackCity)
            end
          else
            local state, info = DataCenter.AllianceDeclareWarManager:GetDeclareState()
            local isSelf = false
            if info and cityId == tonumber(info.content) then
              isSelf = true
              if state == DeclareWarState.PreDeclare then
              else
                if not pointInfo:IsFrozen() then
                  table.insert(oneData.btnList, WorldPointBtnType.ScoutCity)
                  table.insert(oneData.btnList, WorldPointBtnType.RallyCity)
                  table.insert(oneData.btnList, WorldPointBtnType.AttackCity)
                end
                if DataCenter.AllianceBaseDataManager:IsR4orR5() then
                  table.insert(oneData.btnList, WorldPointBtnType.CancelDeclareWar)
                end
              end
              if LuaEntry.Player:AtHomeNow() then
                local detectEvent = DataCenter.RadarCenterDataManager:GetCityEventDataByPointIndex(self.pointId)
                if detectEvent and detectEvent.template and detectEvent.template.type == DetectEventType.ScoutDeclareCity and detectEvent.state == DetectEventState.DETECT_EVENT_STATE_NOT_FINISH then
                  table.insert(oneData.btnList, WorldPointBtnType.DetectScoutCity)
                end
              end
            end
            if not isSelf then
              oneData.forbidden = isJumpToServerMode
              if oneData and oneData.state ~= AllianceCityState.DESTROY then
                if DataCenter.SeasonCampDestroyManager:IsEnemyServer(self.serverId) then
                  table.insert(oneData.btnList, WorldPointBtnType.CampDestroy)
                else
                  table.insert(oneData.btnList, WorldPointBtnType.DeclareWar)
                end
              end
              showDeclareBtn = true
            end
            if DataCenter.OffSeason1RecaptureManager:IsInRecaptureAct() then
              oneData.btnList = {}
              if DataCenter.OffSeason1QueenOfBloodManager:CanAssistance(cityId) then
                UIUtil.InsertAssistanceCityBtn(oneData.btnList, self.pointId, WorldPointBtnType.AssistanceCity)
              end
            end
          end
        else
          if oneData.canBattle and pointInfo:IsFrozen() then
            table.insert(oneData.btnList, WorldPointBtnType.DigIceEnemy)
          end
          if oneData.isKingCity then
            if isKingCityAndCanBattle and LuaEntry.Player:AtHomeNow() and not pointInfo:IsFrozen() then
              table.insert(oneData.btnList, WorldPointBtnType.ScoutCity)
              table.insert(oneData.btnList, WorldPointBtnType.AttackCity)
            end
          else
            oneData.forbidden = isJumpToServerMode
            table.insert(oneData.btnList, WorldPointBtnType.DeclareWar)
          end
        end
      end
    end
  end
  local tempOpenTime = oneData.openTime or -1
  if CrossServerUtil:GetIsCrossServer() then
    if not ignoreViewMode then
      oneData.btnList = {}
    end
  elseif not oneData.forbidden and (tempOpenTime > UITimeManager:GetInstance():GetServerTime() or tempOpenTime == -1) and oneData.type == WorldAllianceCityType.City then
    if showDeclareBtn then
      oneData.btnList = {
        WorldPointBtnType.DeclareWar
      }
    else
      oneData.btnList = {}
    end
  end
  if oneData.type == WorldAllianceCityType.Stronghold then
    local marchInfo = CS.SceneManager.World:GetMonster(self.pointId)
    if marchInfo ~= nil and marchInfo.uuid ~= nil then
      local monsterId = marchInfo.monsterId
      local serverId = marchInfo.serverId
      local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
      if monster ~= nil and serverId == self.serverId and monster.special == WorldMonsterSpecialType.CityStrongholdBOSS then
        oneData.btnList = {}
      end
    end
  end
  local isGivingUp = oneData.giveUpEndTime and 0 < oneData.giveUpEndTime
  if isGivingUp then
    oneData.isGivingUp = true
    oneData.givingUpEndTime = oneData.giveUpEndTime
  end
  if not oneData.isCrossServerThrone and oneData.isKingCity and DataCenter.SeasonNuclearPowerPlantDataManager:BuildNuclearPowerBtnOpen() then
    if oneData.btnList == nil then
      oneData.btnList = {}
    end
    oneData.forbidden = false
    table.insert(oneData.btnList, WorldPointBtnType.BuildNuclear)
  end
  if oneData.type == WorldAllianceCityType.City and DataCenter.SeasonFarmerManager:IsActive() then
    oneData.btnList = {}
    if LuaEntry.Player:AtHomeNow() then
      table.insert(oneData.btnList, WorldPointBtnType.ShowCityAttachmentList)
    end
  end
  if oneData.type == WorldAllianceCityType.King or oneData.type == WorldAllianceCityType.City then
    local cityInfo = mgr:GetAllianceCityDataByCityId(toInt(cityId), self.serverId)
    if cityInfo ~= nil and cityInfo.destroyServerId ~= nil and 0 < toInt(cityInfo.destroyServerId) then
      oneData.btnList = {}
      oneData.destroyServerId = cityInfo.destroyServerId
    end
  end
  if hasGiveUpBtn and self.seasonType == SeasonMapType.NineNationRainforest and DataCenter.SeasonAllyFriendManager:HasFriend() then
    SFSNetwork.SendMessage(MsgDefines.CheckAllyHandshakeUnique, cityId)
  end
  return oneData
end

local function GetAllianceCityDetail(self, cityId, worldCityType)
  local data = DataCenter.WorldPointDetailManager:GetAllianceCityData(cityId)
  if data == nil and worldCityType == WorldAllianceCityType.TradingStation then
    data = {}
    data.cityId = cityId
    data.type = WorldAllianceCityType.TradingStation
  elseif worldCityType == WorldAllianceCityType.Mountain then
    return nil
  end
  return data
end

local function OnMarkClick(self, server, point, oname, olv, panelType)
  local share_param = {}
  share_param.sid = server
  share_param.pos = point
  share_param.oname = oname
  share_param.olv = olv
  panelType = panelType or MarkGroup.Personal
  share_param.panelType = panelType
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionAdd, {anim = true}, share_param)
  self:CloseSelf()
end

local function OnShareClick(self, server, point, oname, uname, olv, alAbbr)
  local share_param = {}
  share_param.sid = server
  share_param.pos = point
  if not string.IsNullOrEmpty(alAbbr) then
    share_param.oname = 311026
    share_param.onameParam1 = alAbbr
    share_param.onameParamKey2 = oname
  else
    share_param.oname = tostring(oname)
  end
  share_param.uname = uname
  share_param.olv = olv
  local info = CS.SceneManager.World:GetPointInfo(point)
  if info then
    local virusLayer = info and info.virusLayer or 0
    if virusLayer <= 0 then
      virusLayer = info:GetCityVirusLayer() or 0
    end
    if 0 < virusLayer then
      share_param.statusLayer = virusLayer
      share_param.statusIcon = string.format(LoadPath.LodIcon, "Mjc_saiji2_bingdu_icon.png")
    end
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
  self:CloseSelf()
end

function UIWorldSiegePointSeasonCtrl:ParseBuff(data, key, buffStr)
  if data then
    local buffStr2 = string.split(buffStr, ";")
    if 1 < #buffStr2 then
      local effectId = tonumber(buffStr2[1])
      if effectId ~= 30145 then
        local value = tonumber(buffStr2[2])
        local nameStr = GetTableData(TableName.LW_Effect_Number, effectId, "name")
        data[key .. "Des"] = nameStr
        local type = toInt(GetTableData(TableName.LW_Effect_Number, effectId, "type"))
        data[key .. "Add"] = UIUtil.GetEffectStr(type, value)
      end
    end
  end
end

UIWorldSiegePointSeasonCtrl.CloseSelf = CloseSelf
UIWorldSiegePointSeasonCtrl.GetAllianceCityData = GetAllianceCityData
UIWorldSiegePointSeasonCtrl.InitData = InitData
UIWorldSiegePointSeasonCtrl.OnMarkClick = OnMarkClick
UIWorldSiegePointSeasonCtrl.OnShareClick = OnShareClick
UIWorldSiegePointSeasonCtrl.GetAllianceCityDetail = GetAllianceCityDetail
return UIWorldSiegePointSeasonCtrl
