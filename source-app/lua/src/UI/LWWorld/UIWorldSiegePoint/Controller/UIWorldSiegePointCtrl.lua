local UIWorldSiegePointCtrl = BaseClass("UIWorldSiegePointCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldSiegePoint)
end

local function InitData(self, cityId, pointId)
  local curServerId = LuaEntry.Player:GetCurServerId()
  self.cityId = cityId
  self.pointId = pointId
  self.isKingCity = cityId == 48
  self.serverId = curServerId
  WorldBattleUtil.TryRequestCityInfo(self.cityId)
end

local function GetAllianceCityData(self, cityId)
  local oneData = {}
  oneData.cityId = cityId
  oneData.isInAlliance = false
  oneData.pointId = self.pointId
  local allianceUid = ""
  local data = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if data ~= nil then
    allianceUid = data.uid
    if allianceUid ~= nil and allianceUid ~= "" then
      oneData.isInAlliance = true
    end
  end
  local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, self.serverId)
  if cityTemplate ~= nil then
    oneData.type = cityTemplate:getIntValue("type", 1)
    oneData.isKingCity = oneData.type == WorldAllianceCityType.King
    oneData.level = cityTemplate:getValue("level")
    oneData.defence_buff = cityTemplate:getValue("defence_buff")
    oneData.loot_rewards = cityTemplate:getIntValue("loot_rewards", 10)
    oneData.avatar_big = cityTemplate.avatar_big
    local rewardStr = cityTemplate:getValue("show_reward")
    oneData.rewardStr = DataCenter.RewardManager:ParseRewardsStr(rewardStr)
    oneData.userName = ""
    oneData.name = cityTemplate:getValue("name")
    local cityInfo = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(cityId)
    if cityInfo ~= nil and cityInfo.cityName ~= nil and cityInfo.cityName ~= "" then
      oneData.userName = cityInfo.cityName
    end
    oneData.monsterNum = cityTemplate:getValue("monster_num")
    oneData.maxDurability = cityTemplate:getValue("wall")
    oneData.cityRecoverSpeed = cityTemplate:getValue("wall_recover")
    oneData.monsterRecoverTime = cityTemplate:getValue("army_recover_time")
    local recommend = cityTemplate:getValue("recommend_soldier")
    oneData.recommend_power = toInt(recommend)
    oneData.buffDes = ""
    oneData.buffAddNum = ""
    local buff = cityTemplate:getValue("buff")
    if buff ~= nil then
      local buffArr = string.split(buff, "|")
      if 0 < #buffArr then
        local buffStr = string.split(buffArr[1], ";")
        if 1 < #buffStr then
          local effectId = tonumber(buffStr[1])
          if effectId ~= nil and effectId ~= 30145 then
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
    oneData.dead_rate = ""
    local wounded_rate = toInt(cityTemplate:getValue("wounded_rate"))
    local injury_rate = toInt(cityTemplate:getValue("injury_rate"))
    if wounded_rate ~= nil and injury_rate ~= nil then
      local rate = 100 - wounded_rate - injury_rate
      oneData.dead_rate = rate .. "%"
    end
  end
  local pointInfo = CS.SceneManager.World:GetPointInfo(self.pointId)
  if pointInfo ~= nil and pointInfo ~= nil then
    oneData.pointId = pointInfo.pointIndex
    oneData.uuid = pointInfo.uuid
    oneData.serverId = pointInfo.serverId
    local isJumpToServerMode = CrossServerUtil.IsJumpToServerMode()
    local curTime = UITimeManager:GetInstance():GetServerSeconds()
    local allianceCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
    if allianceCityPointInfo ~= nil then
      oneData.openTime = allianceCityPointInfo.openTime
      oneData.state = allianceCityPointInfo.state
      oneData.protectTime = allianceCityPointInfo.protectTime
      oneData.alAbbr = allianceCityPointInfo.alAbbr
      oneData.alName = allianceCityPointInfo.alName
      oneData.icon = allianceCityPointInfo.icon
      oneData.allianceId = allianceCityPointInfo.allianceId
      oneData.durability = allianceCityPointInfo.durability
      oneData.ownerServerId = allianceCityPointInfo.serverId
      oneData.lastDurabilityTime = allianceCityPointInfo.lastDurabilityTime
      oneData.buildPoint = allianceCityPointInfo.buildPoint
      oneData.buildStartTime = allianceCityPointInfo.buildStartTime
      oneData.CrossKingBuildPointInfo = allianceCityPointInfo.buildPointInfo
      local cityAllianceId = allianceCityPointInfo.allianceId
      local isKingCityAndCanBattle = false
      oneData.btnList = {}
      oneData.isCrossServerThrone = (oneData.type == WorldAllianceCityType.Canon or oneData.type == WorldAllianceCityType.King) and (oneData.state == AllianceCityState.SERVER_NEUTRAL or oneData.state == AllianceCityState.SERVER_OCCUPIED or oneData.state == AllianceCityState.SERVER_BUILD_THRONE)
      if oneData.type == WorldAllianceCityType.King or oneData.isCrossServerThrone then
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
              isKingCityAndCanBattle = oneData.type == WorldAllianceCityType.King
            end
          end
        end
      end
      oneData.canBattle = isKingCityAndCanBattle
      if oneData.type == 2 and not isKingCityAndCanBattle then
        local skinModel = SeasonUtil.GetCanonAnimModel(cityId, nil, cityTemplate)
        if skinModel then
          local simAnim = skinModel:GetComponent(typeof(CS.SimpleAnimation))
          if simAnim and not simAnim:IsPlaying("idle") then
            simAnim:Play("idle")
          end
        end
      elseif oneData.isCrossServerThrone then
        if not isKingCityAndCanBattle or oneData.state == AllianceCityState.SERVER_OCCUPIED then
        elseif oneData.state == AllianceCityState.SERVER_NEUTRAL then
          table.insert(oneData.btnList, WorldPointBtnType.ScoutCity)
          if oneData.isInAlliance == true then
            table.insert(oneData.btnList, WorldPointBtnType.RallyCity)
          end
          table.insert(oneData.btnList, WorldPointBtnType.AttackCity)
        elseif oneData.state == AllianceCityState.SERVER_BUILD_THRONE then
          local sourceServerId = LuaEntry.Player:GetSourceServerId()
          if SeasonUtil.IsAlly(oneData.ownerServerId, sourceServerId, oneData.allianceId) then
            table.insert(oneData.btnList, WorldPointBtnType.AssistanceCity)
          else
            table.insert(oneData.btnList, WorldPointBtnType.ScoutCity)
            if oneData.isInAlliance == true then
              table.insert(oneData.btnList, WorldPointBtnType.RallyCity)
            end
            table.insert(oneData.btnList, WorldPointBtnType.AttackCity)
          end
        end
        if not SeasonUtil.IsBattleMember(oneData.serverId) then
          oneData.btnList = {}
        end
      elseif oneData.isInAlliance == true then
        if oneData.state == AllianceCityState.BUILDING and cityAllianceId == allianceUid then
          table.insert(oneData.btnList, WorldPointBtnType.AssistanceCity)
        elseif oneData.state == AllianceCityState.OCCUPIED and cityAllianceId == allianceUid then
          local detectEvent = DataCenter.RadarCenterDataManager:GetCityEventDataByPointIndex(self.pointId)
          if detectEvent and detectEvent.template.type == DetectEventType.ScoutOccupyCity and detectEvent.state == DetectEventState.DETECT_EVENT_STATE_NOT_FINISH then
            table.insert(oneData.btnList, WorldPointBtnType.DetectOccupyCity)
          else
            table.insert(oneData.btnList, WorldPointBtnType.AssistanceCity)
            if oneData.type ~= WorldAllianceCityType.King then
              local myAlCityInfo = DataCenter.WorldAllianceCityDataManager:GetMyAlCityInfo(cityId)
              local isGivingUp = myAlCityInfo and myAlCityInfo.giveUpEndTime and 0 < myAlCityInfo.giveUpEndTime
              if isGivingUp then
                table.insert(oneData.btnList, WorldPointBtnType.GiveUpAllianceCity_Cancel)
              else
                table.insert(oneData.btnList, WorldPointBtnType.GiveUpAllianceCity)
              end
            end
          end
        elseif oneData.isKingCity then
          if isKingCityAndCanBattle and LuaEntry.Player:AtHomeNow() then
            table.insert(oneData.btnList, WorldPointBtnType.ScoutCity)
            table.insert(oneData.btnList, WorldPointBtnType.RallyCity)
            table.insert(oneData.btnList, WorldPointBtnType.AttackCity)
          end
        else
          local state, info = DataCenter.AllianceDeclareWarManager:GetDeclareState()
          local isSelf = false
          if info and cityId == tonumber(info.content) then
            isSelf = true
            local detectEvent = DataCenter.RadarCenterDataManager:GetCityEventDataByPointIndex(self.pointId)
            if detectEvent and detectEvent.template.type == DetectEventType.ScoutDeclareCity and detectEvent.state == DetectEventState.DETECT_EVENT_STATE_NOT_FINISH then
              table.insert(oneData.btnList, WorldPointBtnType.DetectScoutCity)
            elseif state == DeclareWarState.PreDeclare then
              if DataCenter.AttackCityS0DataManager:HaveRadarEventInThisCity(cityId) then
                table.insert(oneData.btnList, WorldPointBtnType.DetectEventAttackCityS0Radar)
                DataCenter.LoginGuideManager:PlayAttackCityS0RadarGuide()
              end
            else
              table.insert(oneData.btnList, WorldPointBtnType.ScoutCity)
              table.insert(oneData.btnList, WorldPointBtnType.RallyCity)
              table.insert(oneData.btnList, WorldPointBtnType.AttackCity)
              if DataCenter.AllianceBaseDataManager:IsR4orR5() then
                table.insert(oneData.btnList, WorldPointBtnType.CancelDeclareWar)
                table.insert(oneData.btnList, WorldPointBtnType.AllOut)
              end
            end
          end
          if not isSelf and not isJumpToServerMode then
            table.insert(oneData.btnList, WorldPointBtnType.DeclareWar)
            if DataCenter.AttackCityS0DataManager:HaveRadarEventInThisCity(cityId) then
              table.insert(oneData.btnList, WorldPointBtnType.DetectEventAttackCityS0Radar)
              DataCenter.LoginGuideManager:PlayAttackCityS0RadarGuide()
            end
          end
        end
      elseif oneData.isKingCity then
        if isKingCityAndCanBattle and LuaEntry.Player:AtHomeNow() then
          table.insert(oneData.btnList, WorldPointBtnType.ScoutCity)
          table.insert(oneData.btnList, WorldPointBtnType.AttackCity)
        end
      elseif not isJumpToServerMode then
        table.insert(oneData.btnList, WorldPointBtnType.DeclareWar)
      end
    end
  end
  if CrossServerUtil:GetIsCrossServer() then
    oneData.btnList = {}
  end
  local myAlCityInfo = DataCenter.WorldAllianceCityDataManager:GetMyAlCityInfo(cityId)
  local isGivingUp = myAlCityInfo and myAlCityInfo.giveUpEndTime and 0 < myAlCityInfo.giveUpEndTime
  if isGivingUp then
    oneData.isGivingUp = true
    oneData.givingUpEndTime = myAlCityInfo.giveUpEndTime
  end
  return oneData
end

local function GetAllianceCityDetail(self, cityId)
  local data = {}
  data = DataCenter.WorldPointDetailManager:GetAllianceCityData(cityId)
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

local function OnShareClick(self, server, point, oname, uname, olv)
  local share_param = {}
  share_param.sid = server
  share_param.pos = point
  share_param.oname = oname
  share_param.uname = uname
  share_param.olv = olv
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
  self:CloseSelf()
end

UIWorldSiegePointCtrl.CloseSelf = CloseSelf
UIWorldSiegePointCtrl.GetAllianceCityData = GetAllianceCityData
UIWorldSiegePointCtrl.InitData = InitData
UIWorldSiegePointCtrl.OnMarkClick = OnMarkClick
UIWorldSiegePointCtrl.OnShareClick = OnShareClick
UIWorldSiegePointCtrl.GetAllianceCityDetail = GetAllianceCityDetail
return UIWorldSiegePointCtrl
