local UIFormationAssistanceCtrl = BaseClass("UIFormationAssistanceCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFormationAssistance)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function SetUuid(self, bUuid, uid)
  self.bUuid = bUuid
  self.ownerUid = uid
end

local function OnCloseClick(self)
  self:CloseSelf()
end

local function GetBuildData(self, asType)
  local data = {}
  data.maxNum = 0
  data.join = true
  data.alreadyHave = false
  local info = DataCenter.FormationAssistanceDataManager:GetAssistanceData(self.bUuid)
  if info ~= nil then
    data.maxNum = info.maxAssistance
    if info.memberList ~= nil or info.holdMemberList ~= nil then
      local memberCount = 0
      if info.memberList then
        memberCount = table.count(info.memberList)
      end
      local holdCount = 0
      if info.holdMemberList then
        holdCount = table.count(info.holdMemberList)
      end
      local totalCount = memberCount + holdCount
      if totalCount >= data.maxNum then
        data.join = false
      end
      local selfUid = LuaEntry.Player.uid
      local needCheck = asType == AssistanceType.MainCity or asType == AssistanceType.AllianceCity or asType == AssistanceType.DragonBuild or asType == AssistanceType.Build or asType == AssistanceType.Desert or asType == AssistanceType.CityStronghold or asType == AssistanceType.TradeState or asType == AssistanceType.AllianceBuild or asType == AssistanceType.ASSISTANCE_OUTPOST or asType == AssistanceType.ASSISTANCE_ZWL_BUILDING or asType == AssistanceType.ASSISTANCE_ALTAR
      if asType == AssistanceType.EpidemicBuild then
        needCheck = DataCenter.ActEpidemicZoneManager:GetCurRole() ~= EpidemicZoneRole.Lord
      end
      if needCheck then
        if info.memberList then
          table.walk(info.memberList, function(k, v)
            if v.ownerUid == selfUid then
              data.alreadyHave = true
            end
          end)
        end
        if info.holdMemberList and not data.alreadyHave then
          table.walk(info.holdMemberList, function(k, v)
            if v.ownerUid == selfUid then
              data.alreadyHave = true
            end
          end)
        end
      end
    end
  end
  return data
end

local function OnJoinClick(self, asType, pointId, isThroneCity, isCrossServerThrone)
  local info = DataCenter.FormationAssistanceDataManager:GetAssistanceData(self.bUuid)
  if info ~= nil then
    self:Close()
    if asType == AssistanceType.MainCity then
      local marchTargetType = MarchTargetType.ASSISTANCE_CITY
      if BattleFieldUtil.InBattleField(BattleFieldType.WinterStorm) then
        marchTargetType = MarchTargetType.ASSISTANCE_WINTER_STORM_CITY
      elseif BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) or BattleFieldUtil.InBattleField(BattleFieldType.DsbDuel) then
        marchTargetType = MarchTargetType.ASSISTANCE_EPIDEMIC_CITY
      end
      if not BattleFieldUtil.InBattleField() and info:IsWarFever() and LuaEntry.Effect:CheckCityBuff(CityBuffType.CityShield) then
        UIUtil.ShowMessage(Localization:GetString("458215"), 2, nil, nil, function()
          MarchUtil.OnClickStartMarch(marchTargetType, pointId, self.bUuid)
        end)
      else
        MarchUtil.OnClickStartMarch(marchTargetType, pointId, self.bUuid)
      end
    elseif asType == AssistanceType.Build then
      MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_BUILD, pointId, self.bUuid)
    elseif asType == AssistanceType.AllianceCity then
      local seasonType = SeasonUtil.GetSeasonType(false, true, ServerEnum.View)
      local targetType = MarchTargetType.ASSISTANCE_ALLIANCE_CITY
      if isThroneCity then
        targetType = MarchTargetType.ASSISTANCE_THRONE
      end
      if isCrossServerThrone then
        if seasonType == SeasonMapType.NineNationRainforest then
          if self.serverId == nil or self.cityId == nil then
            local pointInfo = CS.SceneManager.World:GetPointInfoByUuid(self.bUuid)
            if pointInfo ~= nil then
              self.serverId = pointInfo.serverId
              self.cityId = pointInfo.CityId
            end
          end
          if self.serverId ~= nil and self.cityId ~= nil then
            local kingCityId = SeasonUtil.GetKingCityId(self.serverId)
            local kingCenterId = SeasonUtil.GetCenterCityId(self.serverId)
            if self.cityId == kingCityId then
              targetType = MarchTargetType.RAINFOREST_THRONE_ASSISTANCE
            elseif self.cityId == kingCenterId then
              if SeasonUtil.IsNineNationKingMember() then
                targetType = MarchTargetType.ASSISTANCE_CENTER_THRONE
              else
                targetType = MarchTargetType.ASSISTANCE_SERVER_THRONE_BUILDING
              end
            end
          elseif isThroneCity then
            targetType = MarchTargetType.RAINFOREST_THRONE_ASSISTANCE
          end
        elseif SeasonUtil.IsNineNationKingMember() then
          targetType = MarchTargetType.ASSISTANCE_CENTER_THRONE
        else
          targetType = MarchTargetType.ASSISTANCE_SERVER_THRONE_BUILDING
        end
      end
      MarchUtil.OnClickStartMarch(targetType, pointId, self.bUuid)
    elseif asType == AssistanceType.CityStronghold then
      MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_CITY_STRONGHOLD, pointId, self.bUuid)
    elseif asType == AssistanceType.AllianceBuild then
      MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_ALLIANCE_BUILDING, pointId, self.bUuid)
    elseif asType == AssistanceType.Desert then
      MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_DESERT, pointId, self.bUuid)
    elseif asType == AssistanceType.DragonBuild then
      MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_DRAGON_BUILDING, pointId, self.bUuid)
    elseif asType == AssistanceType.WinterEntity then
      MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_WINTER_ENTITY, pointId, self.bUuid)
    elseif asType == AssistanceType.EpidemicBuild then
      MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_EPIDEMIC_BUILDING, pointId, self.bUuid)
    elseif asType == AssistanceType.TradeState then
      MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_CITY_TRADE, pointId, self.bUuid)
    elseif asType == AssistanceType.ASSISTANCE_ALTAR then
      MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_CITY_ALTAR, pointId, self.bUuid)
    elseif asType == AssistanceType.ASSISTANCE_OUTPOST then
      MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_OUTPOST_BUILDING, pointId, self.bUuid)
    elseif asType == AssistanceType.ASSISTANCE_ZWL_BUILDING then
      MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_ZWL_BUILDING, pointId, self.bUuid)
    end
  end
end

local function GetPlayerIdList(self)
  local list = {}
  local info = DataCenter.FormationAssistanceDataManager:GetAssistanceData(self.bUuid)
  if not info then
    return list
  end
  if info.showList ~= nil then
    for k, v in ipairs(info.showList) do
      table.insert(list, v.uuid)
    end
  end
  return list
end

local function GetPlayerItemData(self, marchUuid, isCrossServerThrone)
  local oneData = {}
  local info = DataCenter.FormationAssistanceDataManager:GetAssistanceData(self.bUuid)
  if not info then
    return oneData
  end
  local data
  if info.memberList ~= nil and info.memberList[marchUuid] ~= nil then
    data = info.memberList[marchUuid]
  end
  if not data and info.holdMemberList ~= nil and info.holdMemberList[marchUuid] ~= nil then
    data = info.holdMemberList[marchUuid]
  end
  if data then
    oneData.ownerUid = data.ownerUid
    oneData.ownerName = data.ownerName
    oneData.status = data.status
    oneData.startTime = data.startTime
    oneData.endTime = data.endTime
    oneData.curHp = data.curHp
    oneData.maxHp = data.maxHp
    oneData.power = data.power
    oneData.pic = data.ownerIcon
    oneData.picVer = data.ownerIconVer
    oneData.headSkinId = data.headSkinId
    oneData.headSkinET = data.headSkinET
    oneData.serverId = data.playerServerId
    oneData.allianceId = data.allianceId
    oneData.allianceAbbr = data.allianceAbbr
    oneData.allianceName = data.allianceName
    oneData.allianceIcon = data.allianceIcon
    oneData.playerInfo = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(data.ownerUid, true)
    if isCrossServerThrone and oneData.playerInfo == nil then
      DataCenter.PlayerInfoDataManager:RequestPlayerDataMulti(data.ownerUid)
    end
  end
  return oneData
end

local function GetPlayerSoldierData(self, marchUuid)
  local info = DataCenter.FormationAssistanceDataManager:GetAssistanceData(self.bUuid)
  local showList = {}
  if not info then
    return showList
  end
  local member
  if info.memberList and info.memberList[marchUuid] then
    member = info.memberList[marchUuid]
  end
  if not member and info.holdMemberList and info.holdMemberList[marchUuid] then
    member = info.holdMemberList[marchUuid]
  end
  if member then
    local data = member.armyInfos
    local heros = data.heros
    showList.heros = {}
    for i = 1, #heros do
      showList.heros[i] = {}
      showList.heros[i].heroId = heros[i].heroId
      showList.heros[i].quality = heros[i].heroQuality
      showList.heros[i].lv = heros[i].heroLevel
      showList.heros[i].rankLv = heros[i].rankLv
      showList.heros[i].weaponLevel = heros[i].weaponLevel
      showList.heros[i].awakenLv = heros[i].awakenLv
      showList.heros[i].heroSkinId = heros[i].heroSkinId
    end
  end
  return showList
end

local function OnRetreatClick(self, marchUuid)
  local info = DataCenter.FormationAssistanceDataManager:GetAssistanceData(self.bUuid)
  if not info then
    return
  end
  if info.memberList ~= nil and info.memberList[marchUuid] ~= nil then
    info.memberList[marchUuid] = nil
    DataCenter.FormationAssistanceDataManager:TryRetreatMarchTeam(self.bUuid, marchUuid)
  elseif info.holdMemberList ~= nil and info.holdMemberList[marchUuid] ~= nil then
    info.holdMemberList[marchUuid] = nil
    DataCenter.FormationAssistanceDataManager:TryRetreatMarchTeam(self.bUuid, marchUuid)
  end
end

local function GetPlayerData(self, uid, pointId, asType)
  local data = {}
  data.playerData = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(uid, true)
  data.name = ""
  data.level = 0
  if asType == AssistanceType.Build then
    local info = CS.SceneManager.World:GetPointInfo(pointId)
    if info ~= nil then
      cast(info, typeof(CS.BuildPointInfo))
      if info ~= nil then
        local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(info.itemId)
        if buildTemplate ~= nil then
          data.name = buildTemplate.name
        end
      end
    end
  elseif asType == AssistanceType.Desert then
    local worldTileInfo = CS.SceneManager.World:GetWorldTileInfo(pointId)
    if worldTileInfo ~= nil then
      local desertInfo = worldTileInfo:GetWorldDesertInfo()
      if desertInfo ~= nil then
        local desertId = desertInfo.desertId
        data.name = GetTableData(TableName.Desert, desertId, "desert_name")
        data.level = GetTableData(TableName.Desert, desertId, "desert_level")
      end
    end
  end
  return data
end

local function GetBattleFieldData(self, pointId, bfType)
  local pointInfo = CS.SceneManager.World:GetPointInfo(pointId)
  local detail = pointInfo ~= nil and pointInfo.detail or nil
  if detail ~= nil then
    local buildId = detail.BuildId or detail.ItemId
    if bfType == BattleFieldType.Desert then
      return DataCenter.DragonBuildTemplateManager:GetTemplate(buildId)
    elseif bfType == BattleFieldType.WinterStorm then
      return DataCenter.WinterStormTemplateManager:GetTemplate(buildId)
    elseif bfType == BattleFieldType.EpidemicZone then
      return DataCenter.EpidemicBuildTemplateMgr:GetTemplate(buildId)
    end
  end
  return nil
end

local function GetAllianceCityData(self, pointId)
  local oneData = {}
  local pointInfo = CS.SceneManager.World:GetPointInfo(pointId)
  if pointInfo ~= nil then
    local allianceCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
    if allianceCityPointInfo ~= nil then
      oneData.cityId = allianceCityPointInfo.cityId
      oneData.alAbbr = allianceCityPointInfo.alAbbr or ""
      oneData.alName = allianceCityPointInfo.alName or ""
      oneData.allianceId = allianceCityPointInfo.allianceId
      local cityTemplate = LocalController:instance():getLine(TableName.WorldCity, oneData.cityId)
      if cityTemplate ~= nil then
        oneData.level = cityTemplate:getValue("level")
        oneData.name = Localization:GetString(cityTemplate:getValue("name"))
      end
      local cityInfo = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(oneData.cityId)
      if cityInfo ~= nil and cityInfo.cityName ~= nil and cityInfo.cityName ~= "" then
        oneData.name = cityInfo.cityName
      end
    end
  end
  return oneData
end

local function GetAllianceBuildData(self, pointId)
  local oneData = {}
  local pointInfo = CS.SceneManager.World:GetPointInfo(pointId)
  if pointInfo ~= nil then
    local info
    if pointInfo.pointType == WorldPointType.WORLD_CITY_STRONGHOLD then
      info = PBController.ParsePbFromBytes(pointInfo.extraInfo, "protobuf.CityStrongholdPointInfo")
      if info then
        local template = DataCenter.AllianceCityTemplateManager:GetTemplate(info.strongholdId)
        oneData.alAbbr = info.alAbbr
        if template ~= nil then
          oneData.name = template.name
        end
      end
    else
      info = PBController.ParsePbFromBytes(pointInfo.extraInfo, "protobuf.AllianceBuildingPointInfo")
      if info then
        local mineID = info.buildId
        oneData.alAbbr = info.alAbbr
        local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(mineID)
        if template ~= nil then
          oneData.name = template.name
        end
      end
    end
  end
  return oneData
end

UIFormationAssistanceCtrl.SetUuid = SetUuid
UIFormationAssistanceCtrl.CloseSelf = CloseSelf
UIFormationAssistanceCtrl.Close = Close
UIFormationAssistanceCtrl.OnJoinClick = OnJoinClick
UIFormationAssistanceCtrl.GetPlayerSoldierData = GetPlayerSoldierData
UIFormationAssistanceCtrl.GetPlayerIdList = GetPlayerIdList
UIFormationAssistanceCtrl.GetPlayerItemData = GetPlayerItemData
UIFormationAssistanceCtrl.OnRetreatClick = OnRetreatClick
UIFormationAssistanceCtrl.OnCloseClick = OnCloseClick
UIFormationAssistanceCtrl.GetBuildData = GetBuildData
UIFormationAssistanceCtrl.GetPlayerData = GetPlayerData
UIFormationAssistanceCtrl.GetBattleFieldData = GetBattleFieldData
UIFormationAssistanceCtrl.GetAllianceCityData = GetAllianceCityData
UIFormationAssistanceCtrl.GetAllianceBuildData = GetAllianceBuildData
return UIFormationAssistanceCtrl
