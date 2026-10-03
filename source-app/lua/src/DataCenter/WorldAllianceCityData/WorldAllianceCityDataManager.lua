local WorldAllianceCityDataManager = BaseClass("WorldAllianceCityDataManager")
local AllianceCityOccupyInfo = require("DataCenter.WorldAllianceCityData.AllianceCityOccupyInfo")
local MyAlCityInfo = require("DataCenter.WorldAllianceCityData.MyAlCityInfo")
local OccupyRewardInfo = require("DataCenter.WorldAllianceCityData.OccupyRewardInfo")
local TradeStationItemData = require("DataCenter.WorldAllianceCityData.TradeStationItemData")

local function Startup(self)
end

local function __init(self)
  self.strongholdBattleState = {}
  self.data = {}
  self.allCityInfo = {}
  self.allianceEffectDic = {}
  self.allianceCityEffectDic = {}
  self.allianceStrongholdEffectDic = {}
  self.allianceAltarEffectDic = {}
  self.myAlCityList = {}
  self.allOccupyReward = {}
  self.initOccupy = false
  self.newOccupyQueue = {}
  self.suppliesCountData = {}
  self.actNuclearScore = {}
  self.allianceTradeStationMap = {}
  self.requestTimeRecord = {}
end

local function __delete(self)
  self.data = {}
  self.allianceEffectDic = {}
  self.allianceCityEffectDic = {}
  self.allianceStrongholdEffectDic = {}
  self.allianceAltarEffectDic = {}
  self.allOccupyReward = {}
  self.initOccupy = nil
  self.newOccupyQueue = {}
  self.suppliesCountData = nil
  self.actNuclearScore = nil
  self.allianceTradeStationMap = nil
end

function WorldAllianceCityDataManager:InitAllCityDataRequest()
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local seasonData = SeasonUtil.GetSeasonInfo(loginServerId)
  local seasonType = SeasonMapType.Nothing
  if seasonData then
    seasonType = seasonData:GetServerType(false)
  end
  if seasonType == SeasonMapType.NineNation then
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    SFSNetwork.SendMessage(MsgDefines.FetchWorldOccupyInfo, loginServerId)
    if mySourceServerId ~= loginServerId and seasonData ~= nil and not seasonData:IsInBattleServerGroupInt(mySourceServerId) then
      SFSNetwork.SendMessage(MsgDefines.FetchWorldOccupyInfo, mySourceServerId)
    end
  end
  self:UpdateAllCityDataRequest(nil, loginServerId, seasonType)
end

function WorldAllianceCityDataManager:UpdateAllCityDataRequest(theType, theServerId, theSeasonType)
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local serverId = theServerId or loginServerId
  if theSeasonType == nil then
    local info = SeasonUtil.GetSeasonInfo(serverId)
    if info == nil then
      theSeasonType = SeasonMapType.Nothing
    else
      theSeasonType = info:GetServerType()
    end
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local requestTimeRecord = self.requestTimeRecord
  local isNineNation = theSeasonType == SeasonMapType.NineNation
  if theSeasonType == SeasonMapType.NineNation then
    DataCenter.SeasonNineKingManager:SendCenterThroneInfo(theServerId)
    if DataCenter.ActivityListDataManager:IsActivityOpen(EnumActivity.SeasonWarZoneOutpostAttack.Type) then
      local FetchOutpostBattleInfo = require("Net.Msgs.Season5.Outpost.FetchOutpostBattleInfoMessage")
      if FetchOutpostBattleInfo then
        FetchOutpostBattleInfo.GetBattleInfo(true, false)
      end
    end
  end
  SFSNetwork.SendMessage(MsgDefines.GetCityWarInfo, serverId)
  if theType == nil or theType == WorldAllianceCityType.City then
    local time_key = "City" .. serverId
    if requestTimeRecord[time_key] == nil or 3000 < now - requestTimeRecord[time_key] then
      if not isNineNation then
        SFSNetwork.SendMessage(MsgDefines.GetWorldCityInfo, serverId)
      end
      SFSNetwork.SendMessage(MsgDefines.BloodyQueenS1RestGainCityOccupationRankFirstInfo, serverId)
      if serverId == loginServerId then
        SFSNetwork.SendMessage(MsgDefines.WorldGetAllianceCityEffect)
        SFSNetwork.SendMessage(MsgDefines.GetAllAlCityInfo)
      end
      requestTimeRecord[time_key] = now
    end
  end
  if (theType == nil or theType == WorldAllianceCityType.Stronghold) and SeasonUtil.SeasonHasCityStronghold(theSeasonType) then
    local time_key = "Stronghold" .. serverId
    if requestTimeRecord[time_key] == nil or 3000 < now - requestTimeRecord[time_key] then
      if not isNineNation then
        SFSNetwork.SendMessage(MsgDefines.GetWorldCityStrongholdInfo, serverId)
      end
      SFSNetwork.SendMessage(MsgDefines.GetStrongholdBattleState, serverId)
      if serverId == loginServerId then
        SFSNetwork.SendMessage(MsgDefines.GetAllAlCityStrongholdInfo)
        SFSNetwork.SendMessage(MsgDefines.WorldGetAllianceCityStrongholdEffect)
      end
      requestTimeRecord[time_key] = now
    end
  end
  if (theType == nil or theType == WorldAllianceCityType.TradingStation) and SeasonUtil.SeasonHasTradingStation(theSeasonType) then
    local time_key = "TradingStation" .. serverId
    if requestTimeRecord[time_key] == nil or 3000 < now - requestTimeRecord[time_key] then
      if not isNineNation then
        SFSNetwork.SendMessage(MsgDefines.GetWorldCityTradeInfo, serverId)
      end
      SFSNetwork.SendMessage(MsgDefines.GetAllServerTradeMessage, serverId)
      requestTimeRecord[time_key] = now
    end
  end
  if (theType == nil or theType == WorldAllianceCityType.Altar) and SeasonUtil.SeasonHasAltar(theSeasonType, serverId) then
    local time_key = "Altar" .. serverId
    if requestTimeRecord[time_key] == nil or 3000 < now - requestTimeRecord[time_key] then
      DataCenter.WorldAllianceCityDataManager:TrySendGetAltarEffect(theSeasonType, serverId)
      requestTimeRecord[time_key] = now
    end
  end
  if theSeasonType == SeasonMapType.Snow then
    SFSNetwork.SendMessage(MsgDefines.WorldGetSuppliesCityInfo, serverId)
  end
end

local function IsCityInServer(cityId, serverId, theSeasonType)
  if theSeasonType == SeasonMapType.NineNation then
    local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, serverId)
    if cityTemplate and cityTemplate.bigMapIndex then
      local seasonInfo = SeasonUtil.GetSeasonInfo(serverId)
      local theServerId = seasonInfo:GetNinePalacesServer(cityTemplate.bigMapIndex)
      return theServerId == serverId
    end
  end
  return true
end

local function IsLandlordCity(cityId)
  local landlordCenterServerId = DataCenter.LandlordMgr:GetCenterServerId()
  local isInLandlordNewMapPeriod = DataCenter.LandlordMgr:IsInNewCenterMapPeriod()
  if isInLandlordNewMapPeriod and landlordCenterServerId and landlordCenterServerId ~= 0 then
    return DataCenter.LandlordMgr:IsLandlordCity(cityId, landlordCenterServerId)
  end
end

function WorldAllianceCityDataManager:UpdateAllCityDataFullData(content, _serverId)
  if content == nil or self.data == nil or _serverId == nil then
    return
  end
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  if _serverId == mySourceServerId or _serverId == loginServerId then
    SFSNetwork.SendMessage(MsgDefines.WorldAllCityRewardInfo)
  end
  local info = SeasonUtil.GetSeasonInfo(_serverId)
  local theSeasonType = SeasonMapType.Nothing
  if info ~= nil then
    theSeasonType = info:GetServerType()
  end
  local serverId = SeasonUtil.GetSeasonGroupName(_serverId)
  local isFirst = self.data[serverId] == nil
  local data = self.data[serverId] or {
    allAllianceCityList = {},
    tradeStationList = {},
    strongholdList = {},
    altarList = {},
    allianceCityList = {},
    allianceColorList = {},
    destroyCityList = {}
  }
  local obj = PBController.ParsePb1(content, "protobuf.WorldAllianceOccupyInfo")
  if obj ~= nil then
    local dirtyEffect = false
    local list = obj.AllianceOccupyInfo
    if list ~= nil then
      local tblName = SeasonUtil.GetWorldCityTableNameByServerId(_serverId)
      local tblMgr = LocalController:instance()
      local theTemplateAll = DataCenter.AllianceCityTemplateManager.templatesByTableName[tblName]
      local strongholdList = {}
      local altarList = {}
      local cityList = {}
      local tradeStationList = {}
      local myCityCountOld = 0
      local myStrongholdCountOld = 0
      local myAltarCountOld = 0
      local myAllianceId = LuaEntry.Player.allianceId
      if not string.IsNullOrEmpty(myAllianceId) and data.allianceCityList then
        local myCityList = data.allianceCityList[myAllianceId]
        if myCityList ~= nil then
          myCityCountOld = #myCityList
        end
      end
      if not string.IsNullOrEmpty(myAllianceId) and data.strongholdList then
        local myStrongholdList = data.strongholdList[myAllianceId]
        if myStrongholdList ~= nil then
          myStrongholdCountOld = #myStrongholdList
        end
      end
      if not string.IsNullOrEmpty(myAllianceId) and data.altarList then
        local myAltarList = data.altarList[myAllianceId]
        if myAltarList ~= nil then
          myAltarCountOld = #myAltarList
        end
      end
      data.allianceColorList = {}
      data.allAllianceCityList = {}
      for _, v in ipairs(list) do
        local allianceId = v.allianceId
        local cityType = 0
        if v and v.cityInfo then
          for _, city in ipairs(v.cityInfo) do
            if city and city.cityId then
              local cityId = city.cityId
              local oneData = AllianceCityOccupyInfo.New()
              oneData:ParseDataV2(cityId, v)
              data.allianceColorList[allianceId] = oneData.color
              if (info == nil or info:InHaltMode()) and IsLandlordCity(cityId) then
              else
                data.allAllianceCityList[cityId] = oneData
              end
              if theTemplateAll ~= nil then
                cityType = theTemplateAll[tostring(cityId)] and theTemplateAll[tostring(cityId)].type
              else
                cityType = tblMgr:getIntValue(tblName, cityId, "type", 0)
              end
              if cityType then
                if cityType == WorldAllianceCityType.City then
                  oneData.isCity = true
                  if cityList[allianceId] == nil then
                    cityList[allianceId] = {}
                  end
                  table.insert(cityList[allianceId], cityId)
                elseif cityType == WorldAllianceCityType.Stronghold then
                  oneData.isCityStronghold = true
                  if strongholdList[allianceId] == nil then
                    strongholdList[allianceId] = {}
                  end
                  table.insert(strongholdList[allianceId], cityId)
                elseif cityType == WorldAllianceCityType.Altar then
                  oneData.isAltar = true
                  if altarList[allianceId] == nil then
                    altarList[allianceId] = {}
                  end
                  table.insert(altarList[allianceId], cityId)
                elseif cityType == WorldAllianceCityType.TradingStation then
                  oneData.isTradeStation = true
                  if tradeStationList[allianceId] == nil then
                    tradeStationList[allianceId] = {}
                  end
                  table.insert(tradeStationList[allianceId], cityId)
                end
              end
            end
          end
        end
        if v and v.destroyInfo then
          for _, city in ipairs(v.destroyInfo) do
            if city and city.cityId then
              local cityId = city.cityId
              local oneData = AllianceCityOccupyInfo.New()
              oneData:ParseDataV2(cityId, v)
              data.allianceColorList[allianceId] = oneData.color
              if (info == nil or info:InHaltMode()) and IsLandlordCity(cityId) then
              else
                data.allAllianceCityList[cityId] = oneData
              end
              oneData.destroyServerId = oneData.occupyServerId
              oneData.destroyAllianceId = allianceId
              oneData.destroyAllianceAbbr = v.abbr
              oneData.destroyAllianceName = v.allianceName
            end
          end
        end
      end
      data.allianceCityList = cityList
      data.strongholdList = strongholdList
      data.altarList = altarList
      data.tradeStationList = tradeStationList
      self.data[serverId] = data
      if not string.IsNullOrEmpty(myAllianceId) then
        if not dirtyEffect then
          local myCityList = cityList[myAllianceId]
          local myCityCountNew = 0
          if myCityList then
            myCityCountNew = #myCityList
          end
          dirtyEffect = myCityCountOld ~= myCityCountNew
        end
        if not dirtyEffect then
          local myStrongholdList = strongholdList[myAllianceId]
          local myStrongholdCountNew = 0
          if myStrongholdList then
            myStrongholdCountNew = #myStrongholdList
          end
          dirtyEffect = myStrongholdCountOld ~= myStrongholdCountNew
        end
        if not dirtyEffect then
          local myAltarList = altarList[myAllianceId]
          local myAltarCountNew = 0
          if myAltarList then
            myAltarCountNew = #myAltarList
          end
          dirtyEffect = myAltarCountOld ~= myAltarCountNew
        end
      end
    end
    local serverDestroyInfo = obj.serverDestroyInfo
    if serverDestroyInfo ~= nil then
      for _, v in ipairs(serverDestroyInfo) do
        local attackServerId = v.serverId
        if v and v.destroyCityIds then
          for _, cityId in ipairs(v.destroyCityIds) do
            if data.destroyCityList[cityId] ~= attackServerId then
              dirtyEffect = true
            end
            data.destroyCityList[cityId] = attackServerId
            if data.allAllianceCityList[cityId] ~= nil then
              data.allAllianceCityList[cityId].destroyServerId = attackServerId
            end
          end
        end
      end
    end
    if dirtyEffect then
      SFSNetwork.SendMessage(MsgDefines.WorldGetAllianceCityEffect)
      SFSNetwork.SendMessage(MsgDefines.WorldGetAllianceCityStrongholdEffect)
      DataCenter.WorldAllianceCityDataManager:TrySendGetAltarEffect(theSeasonType, _serverId)
      EventManager:GetInstance():Broadcast(EventId.MyAlCityListChanged, serverId)
    end
  end
  if isFirst == true then
    EventManager:GetInstance():Broadcast(EventId.WorldCityOwnerInfoReceived, _serverId)
  else
    EventManager:GetInstance():Broadcast(EventId.WorldCityOwnerInfoChanged, _serverId)
  end
end

local function UpdateAllCityData(self, message, _serverId, theType)
  if message == nil or self.data == nil or _serverId == nil then
    return
  end
  if _serverId == LuaEntry.Player:GetSourceServerId() then
    SFSNetwork.SendMessage(MsgDefines.WorldAllCityRewardInfo)
  end
  local info = SeasonUtil.GetSeasonInfo(_serverId)
  local theSeasonType = SeasonMapType.Nothing
  if info ~= nil then
    theSeasonType = info:GetServerType()
  end
  local serverId = SeasonUtil.GetSeasonGroupName(_serverId)
  local isFirst = self.data[serverId] == nil
  local data = self.data[serverId] or {
    allAllianceCityList = {},
    tradeStationList = {},
    strongholdList = {},
    altarList = {},
    allianceCityList = {},
    allianceColorList = {}
  }
  if message.content ~= nil and message.content ~= "" then
    local obj = PBController.ParsePb1(message.content, "protobuf.WorldAllAllianceCityInfo")
    if obj ~= nil then
      local myAllianceId = LuaEntry.Player.allianceId
      local list = obj.infoes
      if list ~= nil then
        if theType == WorldAllianceCityType.Stronghold then
          local myStrongholdCountOld = 0
          if not string.IsNullOrEmpty(myAllianceId) and data.strongholdList then
            local myStrongholdList = data.strongholdList[myAllianceId]
            if myStrongholdList ~= nil then
              myStrongholdCountOld = #myStrongholdList
            end
          end
          for k, v in pairs(data.allAllianceCityList) do
            if v and v.isCityStronghold and IsCityInServer(v.cityId, _serverId, theSeasonType) then
              data.allAllianceCityList[k] = nil
            end
          end
          local strongholdList = {}
          for k, v in pairs(list) do
            local oneData = AllianceCityOccupyInfo.New()
            oneData:ParseData(v)
            oneData.isCityStronghold = true
            if oneData.cityId ~= 0 and oneData.allianceId ~= "" then
              if strongholdList[oneData.allianceId] == nil then
                strongholdList[oneData.allianceId] = {}
              end
              table.insert(strongholdList[oneData.allianceId], oneData.cityId)
              data.allianceColorList[oneData.allianceId] = oneData.color
              data.allAllianceCityList[oneData.cityId] = oneData
            end
          end
          data.strongholdList = strongholdList
          self.data[serverId] = data
          if not string.IsNullOrEmpty(myAllianceId) then
            local myStrongholdList = strongholdList[myAllianceId]
            local myStrongholdCountNew = 0
            if myStrongholdList then
              myStrongholdCountNew = #myStrongholdList
            end
            if myStrongholdCountOld ~= myStrongholdCountNew then
              SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyStrongholdList)
              SFSNetwork.SendMessage(MsgDefines.WorldGetAllianceCityStrongholdEffect)
              EventManager:GetInstance():Broadcast(EventId.MyAlCityListChanged, serverId)
            end
          end
        elseif theType == WorldAllianceCityType.City then
          local myCityCountOld = 0
          if not string.IsNullOrEmpty(myAllianceId) then
            local myCityList = data.allianceCityList[myAllianceId]
            if myCityList ~= nil then
              myCityCountOld = #myCityList
            end
          end
          for k, v in pairs(data.allAllianceCityList) do
            if v and v.isCity and IsCityInServer(v.cityId, _serverId, theSeasonType) then
              data.allAllianceCityList[k] = nil
            end
          end
          local cityList = {}
          for k, v in pairs(list) do
            local oneData = AllianceCityOccupyInfo.New()
            oneData:ParseData(v)
            oneData.isCity = true
            if oneData.cityId ~= 0 and oneData.allianceId ~= "" then
              if cityList[oneData.allianceId] == nil then
                cityList[oneData.allianceId] = {}
              end
              table.insert(cityList[oneData.allianceId], oneData.cityId)
              data.allianceColorList[oneData.allianceId] = oneData.color
              data.allAllianceCityList[oneData.cityId] = oneData
            end
          end
          data.allianceCityList = cityList
          self.data[serverId] = data
          if not string.IsNullOrEmpty(myAllianceId) then
            local myCityList = cityList[myAllianceId]
            local myCityCountNew = 0
            if myCityList then
              myCityCountNew = #myCityList
            end
            if myCityCountOld ~= myCityCountNew then
              SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyCityList)
              SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyStrongholdList)
              EventManager:GetInstance():Broadcast(EventId.MyAlCityListChanged, serverId)
            end
          end
        elseif theType == WorldAllianceCityType.TradingStation then
          for k, v in pairs(data.allAllianceCityList) do
            if v and v.isTradeStation and IsCityInServer(v.cityId, _serverId, theSeasonType) then
              data.allAllianceCityList[k] = nil
            end
          end
          local tradeStationList = {}
          for k, v in pairs(list) do
            local oneData = AllianceCityOccupyInfo.New()
            oneData:ParseData(v)
            oneData.isTradeStation = true
            if oneData.cityId ~= 0 and oneData.allianceId ~= "" then
              if tradeStationList[oneData.allianceId] == nil then
                tradeStationList[oneData.allianceId] = {}
              end
              table.insert(tradeStationList[oneData.allianceId], oneData.cityId)
              data.allianceColorList[oneData.allianceId] = oneData.color
              data.allAllianceCityList[oneData.cityId] = oneData
            end
          end
          data.tradeStationList = tradeStationList
          self.data[serverId] = data
        elseif theType == WorldAllianceCityType.Altar then
          for k, v in pairs(data.allAllianceCityList) do
            if v and v.isAltar and IsCityInServer(v.cityId, _serverId, theSeasonType) then
              data.allAllianceCityList[k] = nil
            end
          end
          local myAltarCountOld = 0
          if not string.IsNullOrEmpty(myAllianceId) and data.altarList then
            myAltarCountOld = table.count(data.altarList[myAllianceId])
          end
          local altarList = {}
          for k, v in pairs(list) do
            local oneData = AllianceCityOccupyInfo.New()
            oneData:ParseData(v)
            oneData.isAltar = true
            if oneData.cityId ~= 0 and oneData.allianceId ~= "" then
              if altarList[oneData.allianceId] == nil then
                altarList[oneData.allianceId] = {}
              end
              table.insert(altarList[oneData.allianceId], oneData.cityId)
              data.allianceColorList[oneData.allianceId] = oneData.color
              data.allAllianceCityList[oneData.cityId] = oneData
            end
          end
          data.altarList = altarList
          self.data[serverId] = data
          if table.count(data.altarList) ~= myAltarCountOld then
            DataCenter.WorldAllianceCityDataManager:TrySendGetAltarEffect(theSeasonType, _serverId)
          end
        end
      end
    end
  end
  if isFirst == true then
    EventManager:GetInstance():Broadcast(EventId.WorldCityOwnerInfoReceived)
  else
    EventManager:GetInstance():Broadcast(EventId.WorldCityOwnerInfoChanged, serverId)
  end
end

local function UpdateMyAlCities(self, t, stronghold)
  if not t or not t.cityInfos then
    return
  end
  local tempInfo = t.cityInfos
  local dirty = self.myAlCityList or {}
  self.myAlCityList = {}
  for i, v in pairs(tempInfo) do
    local oneData = MyAlCityInfo.New()
    oneData:ParseData(v)
    if oneData.cityId ~= nil and oneData.cityId ~= 0 then
      self.myAlCityList[oneData.cityId] = oneData
    end
  end
  for k, v in pairs(dirty) do
    if v and v.stronghold ~= stronghold then
      self.myAlCityList[k] = v
    end
  end
  EventManager:GetInstance():Broadcast(EventId.UpdateMyAlCities)
end

local function UpdateOneGivingUpCity(self, t, stronghold)
  local cityId = toInt(t.cityId or t.strongholdId)
  if self.myAlCityList ~= nil and self.myAlCityList[cityId] ~= nil then
    self.myAlCityList[cityId]:SetGiveUpTime(t.giveUpTime)
    EventManager:GetInstance():Broadcast(EventId.UpdateMyAlCities)
  end
end

local function UpdateCityName(self, t)
  local cityId = toInt(t.cityId or t.strongholdId)
  self.myAlCityList[cityId]:SetChangeName(t.cityName)
  self.myAlCityList[cityId]:SetChangeNameTime(t.changeNameTime)
  EventManager:GetInstance():Broadcast(EventId.AllianceCityNameChange, cityId)
end

local function OnAlCityGiveUpFail(self, t, stronghold)
  local cityId = toInt(t.cityId or t.strongholdId)
  self.myAlCityList[cityId]:SetGiveUpTime(0)
  local name = ""
  if self.myAlCityList[cityId] ~= nil then
    name = self.myAlCityList[cityId].cityName
  end
  if name == nil or name == "" then
    name = GetTableData(TableName.WorldCity, cityId, "name")
  end
  UIUtil.ShowTips(Localization:GetString("300721", name))
  EventManager:GetInstance():Broadcast(EventId.UpdateMyAlCities)
end

function WorldAllianceCityDataManager:GetFireNumByBlood(cur, max)
  if not self.city_onfire_k1 then
    local k1 = LuaEntry.DataConfig:TryGetStr("city_onfire", "k1", "0.99|0.7|0.5|0.3")
    local city_onfire_k1 = string.split(k1, "|")
    self.city_onfire_k1 = {}
    for i = 1, #city_onfire_k1 do
      self.city_onfire_k1[i] = tonumber(city_onfire_k1[i])
    end
    self.city_onfire_k2 = LuaEntry.DataConfig:TryGetNum("city_onfire", "k2", 4)
  end
  if cur == max or max <= 0 then
    return 0, self.city_onfire_k2
  end
  local percent = cur / max
  if percent > self.city_onfire_k1[1] then
    return 0, self.city_onfire_k2
  end
  for i = 2, #self.city_onfire_k1 do
    if percent > self.city_onfire_k1[i] then
      return i - 1, self.city_onfire_k2
    end
  end
  return #self.city_onfire_k1, self.city_onfire_k2
end

local function GetMyAlCityInfo(self, cityId)
  return self.myAlCityList[toInt(cityId)]
end

function WorldAllianceCityDataManager:GetMyAlCityList()
  return self.myAlCityList or {}
end

local function GetAllianceAlreadyHaveCity(self, allianceId)
  if SeasonUtil.IsInSeasonDesertMode() then
    return true
  end
  local _serverId = LuaEntry.Player:GetCurServerId()
  local serverId = SeasonUtil.GetSeasonGroupName(_serverId)
  local data = self.data[serverId]
  if data == nil or data.allAllianceCityList == nil then
    return false
  end
  local have = false
  table.walk(data.allAllianceCityList, function(k, v)
    if have == false and v.allianceId == allianceId and v:IsNotRuins() then
      have = true
    end
  end)
  return have
end

local function IsAllianceAlreadyHaveCity(self, allianceId, level)
  local _serverId = LuaEntry.Player:GetCurServerId()
  local serverId = SeasonUtil.GetSeasonGroupName(_serverId)
  local data = self.data[serverId]
  if data == nil or data.allAllianceCityList == nil then
    return false
  end
  local have = false
  local levelCheck = toInt(level)
  for k, v in pairs(data.allAllianceCityList) do
    if have == false and v.allianceId == allianceId and v:IsNotRuins() and toInt(GetTableData(TableName.WorldCity, v.cityId, "level")) == levelCheck then
      have = true
      break
    end
  end
  return have
end

local function GetCityIsNearBySelfAlliance(self, allianceId, curCityId, skipAllyFriend)
  if SeasonUtil.IsInSeasonDesertMode() then
    return true
  end
  if not skipAllyFriend and DataCenter.SeasonAllyFriendManager:HasFriend() then
    local allyAllianceId = DataCenter.SeasonAllyFriendManager:GetFriendAllyId()
    if allyAllianceId ~= allianceId and self:GetCityIsNearBySelfAlliance(allyAllianceId, curCityId, true) then
      return true
    end
  end
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local serverId = LuaEntry.Player:GetCurServerId()
  local theServerId = SeasonUtil.GetSeasonGroupName(serverId)
  local data = self.data[theServerId]
  if data == nil or data.allAllianceCityList == nil then
    return false
  end
  local cityData = data.allAllianceCityList[toInt(curCityId)]
  if cityData ~= nil and cityData.allianceId == allianceId and cityData:IsNotRuins() then
    return true
  end
  local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(curCityId, serverId)
  if cityTemplate and type(cityTemplate.nearBy) == "table" and table.isarray(cityTemplate.nearBy) then
    local season = cityTemplate:getIntValue("season", 0)
    for k, neighbourCityId in ipairs(cityTemplate.nearBy) do
      local cityId = toInt(neighbourCityId)
      cityData = data.allAllianceCityList[cityId]
      if 0 < cityId and cityData ~= nil and cityData:IsNotRuins() then
        if cityData.allianceId == allianceId then
          return true
        end
        if cityTemplate.bigMapIndex == 5 and season == 5 or season == 6 or season == 7 then
          local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, serverId)
          if meta ~= nil and cityData.occupyServerId == mySourceServerId and meta.type == WorldAllianceCityType.CrossZoneOutpost then
            return true
          end
        end
      end
    end
  end
  return false
end

function WorldAllianceCityDataManager:GetAllAdjCityByAllianceId(allianceId)
  local ret = {}
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local serverId = SeasonUtil.GetSeasonGroupName(loginServerId)
  local data = self.data[serverId]
  if data == nil or data.allianceCityList == nil then
    return {}
  end
  local cityIds = data.allianceCityList[allianceId]
  if cityIds == nil or #cityIds == 0 then
    if data.allAllianceCityList == nil then
      return {}
    end
    local cityWarInfo = DataCenter.WorldAllianceCityDataManager:GetCityWarInfo(loginServerId)
    if cityWarInfo and cityWarInfo.cityInfoList then
      for _, v in pairs(cityWarInfo.cityInfoList) do
        local template = DataCenter.AllianceCityTemplateManager:GetTemplate(v.cityId)
        if template.level == 1 then
          if v.firstOccupyTime and 0 >= v.firstOccupyTime then
            table.insert(ret, 1, template)
          else
            table.insert(ret, template)
          end
        end
      end
    end
  else
    local hashSet = {}
    for _, cityId in pairs(cityIds) do
      hashSet[cityId] = true
    end
    for _, cityId in pairs(cityIds) do
      local template = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
      for _, adjId in pairs(template.nearBy) do
        if not hashSet[adjId] and not ret[adjId] then
          table.insert(ret, DataCenter.AllianceCityTemplateManager:GetTemplate(adjId))
        end
      end
    end
  end
  return ret
end

local function GetCityIsNearByAllianceDesert(self, alId, curCityId)
  local alreadyExitOccupy = true
  if SeasonUtil.IsInSeason() then
    alreadyExitOccupy = false
    local strPos = GetTableData(TableName.WorldCity, curCityId, "location")
    local tabPos = string.split(strPos, "|")
    if table.count(tabPos) ~= 2 then
      return false
    end
    local tileSize = GetTableData(TableName.WorldCity, curCityId, "season_tile_size", 5)
    local vecPos = Vector2.New(tonumber(tabPos[1]), tonumber(tabPos[2]))
    local rangeList = BuildingUtils.GetBuildRoundPos(vecPos, tileSize, tileSize)
    for i = 1, #rangeList do
      if alreadyExitOccupy == false then
        alreadyExitOccupy = SeasonUtil.IsDesertOccupy(SceneUtils.TilePosToIndex(rangeList[i], ForceChangeScene.World))
        if alreadyExitOccupy then
          break
        end
      end
    end
  end
  return alreadyExitOccupy
end

local function GetCitiesByAlId(self, alId, serverId)
  if toInt(serverId) <= 0 then
    serverId = LuaEntry.Player:GetCurServerId()
  end
  serverId = SeasonUtil.GetSeasonGroupName(serverId)
  local data = self.data[serverId]
  if data == nil or data.allianceCityList == nil then
    return nil
  end
  return data.allianceCityList[alId]
end

local function GetCitiesCountByAlId(self, alId, excludeKingCity)
  local _serverId = LuaEntry.Player:GetCurServerId()
  local serverId = SeasonUtil.GetSeasonGroupName(_serverId)
  local data = self.data[serverId]
  if data == nil or data.allianceCityList == nil then
    return 0
  end
  local cities = data.allianceCityList[alId]
  if cities ~= nil then
    local cityCount = #cities
    if excludeKingCity == true then
      for _, cityId in ipairs(cities) do
        if SeasonUtil.IsKingCity(cityId, _serverId) then
          cityCount = cityCount - 1
        end
      end
    end
    return cityCount
  end
  return 0
end

function WorldAllianceCityDataManager:GetAllCityTemplateByAlId(alId, excludeKingCity)
  local _serverId = LuaEntry.Player:GetCurServerId()
  local serverId = SeasonUtil.GetSeasonGroupName(_serverId)
  local data = self.data[serverId]
  if data == nil or data.allianceCityList == nil or data.allianceCityList[alId] == nil then
    return {}
  end
  local mgr = DataCenter.AllianceCityTemplateManager
  local cities = data.allianceCityList[alId]
  local ret = {}
  local kingCityId, kingCityPosIndex = SeasonUtil.GetKingCityId(_serverId)
  for _, cityId in ipairs(cities) do
    if not excludeKingCity or cityId ~= kingCityId then
      table.insert(ret, mgr:GetTemplate(cityId, _serverId))
    end
  end
  return ret
end

local function GetStrongholdCountByAlId(self, alId, excludeKingCity, theServerId)
  if toInt(theServerId) <= 0 then
    theServerId = LuaEntry.Player:GetCurServerId()
  end
  local serverId = SeasonUtil.GetSeasonGroupName(theServerId)
  local data = self.data[serverId]
  if data == nil or data.strongholdList == nil then
    return 0
  end
  local cities = data.strongholdList[alId]
  if cities ~= nil then
    return #cities
  end
  return 0
end

local function GetStrongholdsByAlId(self, alId, serverId)
  if toInt(serverId) <= 0 then
    serverId = LuaEntry.Player:GetCurServerId()
  end
  serverId = SeasonUtil.GetSeasonGroupName(serverId)
  local data = self.data[serverId]
  if data == nil or data.strongholdList == nil then
    return nil
  end
  return data.strongholdList[alId]
end

function WorldAllianceCityDataManager:GetTradeStationByAlId(alId, serverId)
  if toInt(serverId) <= 0 then
    serverId = LuaEntry.Player:GetCurServerId()
  end
  serverId = SeasonUtil.GetSeasonGroupName(serverId)
  local data = self.data[serverId]
  if data == nil or data.tradeStationList == nil then
    return nil
  end
  return data.tradeStationList[alId]
end

function WorldAllianceCityDataManager:GetAllianceCityByAlId(alId, serverId)
  if toInt(serverId) <= 0 then
    serverId = LuaEntry.Player:GetCurServerId()
  end
  serverId = SeasonUtil.GetSeasonGroupName(serverId)
  local data = self.data[serverId]
  if data == nil then
    return nil
  end
  return data.allianceCityList and data.allianceCityList[alId], data.strongholdList and data.strongholdList[alId], data.tradeStationList and data.tradeStationList[alId]
end

local function GetAllianceColorList(self)
  local _serverId = LuaEntry.Player:GetCurServerId()
  local serverId = SeasonUtil.GetSeasonGroupName(_serverId)
  local data = self.data[serverId]
  if data then
    return data.allianceColorList
  end
  return {}
end

local function GetAllianceCityList(self, serverId)
  if LuaEntry and LuaEntry.Player then
    if serverId == nil then
      serverId = LuaEntry.Player:GetCurServerId()
    end
    serverId = SeasonUtil.GetSeasonGroupName(serverId)
    local data = self.data[serverId]
    if data and data.allAllianceCityList then
      return data.allAllianceCityList
    end
  end
  return {}
end

function WorldAllianceCityDataManager:GetAllianceDestroyCityList(serverId)
  if LuaEntry and LuaEntry.Player then
    if serverId == nil then
      serverId = LuaEntry.Player:GetCurServerId()
    end
    serverId = SeasonUtil.GetSeasonGroupName(serverId)
    local data = self.data[serverId]
    if data and data.destroyCityList then
      return data.destroyCityList
    end
  end
  return {}
end

local function GetAllianceCityDataByCityId(self, cityId, serverId)
  if serverId == nil then
    serverId = LuaEntry.Player:GetCurServerId()
  end
  serverId = SeasonUtil.GetSeasonGroupName(serverId)
  local data = self.data[serverId]
  if data and data.allAllianceCityList then
    return data.allAllianceCityList[toInt(cityId)]
  end
  return nil
end

function WorldAllianceCityDataManager:GetDestroyCityServerId(serverId, cityId)
  if serverId == nil then
    serverId = LuaEntry.Player:GetCurServerId()
  end
  serverId = SeasonUtil.GetSeasonGroupName(serverId)
  local data = self.data[serverId]
  if data and data.destroyCityList then
    return toInt(data.destroyCityList[toInt(cityId)])
  end
  return 0
end

function WorldAllianceCityDataManager:GetAllianceCityData(allianceId, cityId)
  local _serverId = LuaEntry.Player:GetCurServerId()
  local serverId = SeasonUtil.GetSeasonGroupName(_serverId)
  local data = self.data[serverId]
  if data and data.allAllianceCityList then
    local cityInfo = data.allAllianceCityList[toInt(cityId)]
    if cityInfo and cityInfo.allianceId == allianceId then
      return true
    end
  end
  return nil
end

local function UpdateAllianceCityEffect(self, message, stronghold, altar)
  if stronghold then
    self.allianceStrongholdEffectDic = {}
    if message ~= nil and message.effect ~= nil then
      for k, v in pairs(message.effect) do
        local effectId = toInt(k)
        local effectValue = tonumber(v)
        self.allianceStrongholdEffectDic[effectId] = effectValue
      end
    end
  elseif altar then
    self.allianceAltarEffectDic = {}
    if message ~= nil and message.effect ~= nil then
      for k, v in pairs(message.effect) do
        local effectId = toInt(k)
        local effectValue = tonumber(v)
        self.allianceAltarEffectDic[effectId] = effectValue
      end
    end
  else
    self.allianceCityEffectDic = {}
    if message ~= nil and message.effect ~= nil then
      for k, v in pairs(message.effect) do
        local effectId = toInt(k)
        local effectValue = tonumber(v)
        self.allianceCityEffectDic[effectId] = effectValue
      end
    end
  end
  self.allianceEffectDic = {}
  if self.allianceCityEffectDic then
    for effectId, effectValue in pairs(self.allianceCityEffectDic) do
      self.allianceEffectDic[effectId] = (self.allianceEffectDic[effectId] or 0) + effectValue
    end
  end
  if self.allianceStrongholdEffectDic then
    for effectId, effectValue in pairs(self.allianceStrongholdEffectDic) do
      self.allianceEffectDic[effectId] = (self.allianceEffectDic[effectId] or 0) + effectValue
    end
  end
  if self.allianceAltarEffectDic then
    for effectId, effectValue in pairs(self.allianceAltarEffectDic) do
      self.allianceEffectDic[effectId] = (self.allianceEffectDic[effectId] or 0) + effectValue
    end
  end
  EventManager:GetInstance():Broadcast(EventId.MyAlCityListChanged, LuaEntry.Player:GetSelfServerId())
end

local function GetAllianceCityEffectById(self, id)
  local effectId = toInt(id)
  local num = 0
  if self.allianceEffectDic ~= nil and self.allianceEffectDic[effectId] ~= nil then
    num = self.allianceEffectDic[effectId]
  end
  return num
end

local function GetAllianceCityEffects(self)
  return self.allianceEffectDic or {}
end

function WorldAllianceCityDataManager:CleanAllianceCityEffects()
  self.allianceEffectDic = {}
end

function WorldAllianceCityDataManager:OnLeaveAlliance()
  self.allianceEffectDic = {}
  self.allianceCityEffectDic = {}
  self.allianceStrongholdEffectDic = {}
  self.allianceAltarEffectDic = {}
  self.myAlCityList = {}
  EventManager:GetInstance():Broadcast(EventId.MyAlCityListChanged, LuaEntry.Player:GetSelfServerId())
end

local function CheckIfHasAlCity(self)
  local myAlId = LuaEntry.Player.allianceId
  local myAlCities = DataCenter.WorldAllianceCityDataManager:GetCitiesByAlId(myAlId)
  return myAlCities and 0 < #myAlCities
end

local function CheckIfIsAlTerritory(self, pointId)
  local myAlId = LuaEntry.Player.allianceId
  local myAlCities = DataCenter.WorldAllianceCityDataManager:GetCitiesByAlId(myAlId)
  if myAlCities then
    local zoneId = SceneUtils.GetZoneIdByPosId(pointId)
    for i, v in ipairs(myAlCities) do
      if v == zoneId then
        return true
      end
    end
  end
  return false
end

function WorldAllianceCityDataManager:GetCityProtectTime(cityId)
  local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId)
  if not cityMeta or cityMeta.type ~= WorldAllianceCityType.City then
    return 0
  end
  local curTimeSeconds = UITimeManager:GetInstance():GetServerSeconds()
  local protectTime = DataCenter.AllianceCityTipManager:GetProtectedTime(LuaEntry.Player:GetSelfServerId(), cityId)
  if protectTime ~= nil and protectTime ~= 0 and curTimeSeconds < protectTime * 0.001 then
    return protectTime
  end
  local cityWarInfo = DataCenter.WorldAllianceCityDataManager.theCityWarInfo
  if cityWarInfo then
    if cityWarInfo.noOpenList then
      local cityInfo = cityWarInfo.noOpenList[cityId]
      if cityInfo and cityInfo.openTime then
        return cityInfo.openTime
      end
    end
    if cityWarInfo.cityInfoList then
      local cityInfo = cityWarInfo.cityInfoList[cityId]
      if cityInfo and cityInfo.protectTime then
        return cityInfo.protectTime
      end
    end
  end
  if CS.SceneManager.World then
    local pointInfo = CS.SceneManager.World:GetPointInfo(cityMeta:GetPointId())
    if pointInfo ~= nil then
      local extraInfo = PBController.ParsePbFromBytes(pointInfo.extraInfo, "protobuf.AllianceCityPointInfo")
      if extraInfo ~= nil and extraInfo.protectTime and curTimeSeconds < extraInfo.protectTime then
        return extraInfo.protectTime * 1000
      end
    end
  end
  return 0
end

function WorldAllianceCityDataManager:SetAllOccupyReward(msg)
  if self.allOccupyReward then
    for _, v in pairs(self.allOccupyReward) do
      v:Delete()
    end
  end
  self.allOccupyReward = {}
  for i, v in pairs(msg) do
    local oneData = OccupyRewardInfo.New()
    oneData:ParseData(v)
    self.allOccupyReward[oneData.cityId] = oneData
  end
  self:InitNewOccupyQueue()
end

function WorldAllianceCityDataManager:PushCityRewardInfo(msg)
  if not self.allOccupyReward[msg.cityId] then
    self.allOccupyReward[msg.cityId] = OccupyRewardInfo.New()
  end
  self.allOccupyReward[msg.cityId]:ParseData(msg)
  if self.allOccupyReward[msg.cityId]:HaveRewardToGet() then
    local newOccupy = AllianceCityOccupyInfo.New()
    newOccupy:ParseDataFormRewardInfo(self.allOccupyReward[msg.cityId])
    table.insert(self.newOccupyQueue, newOccupy)
    DataCenter.ActivityTipsManager:Enqueue(MainUITipCondition.CityWarSuccess)
  else
    for k, v in ipairs(self.newOccupyQueue) do
      if v.cityId == msg.cityId then
        table.remove(self.newOccupyQueue, k)
        break
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.CityRewardRefresh, self.allOccupyReward[msg.cityId])
end

function WorldAllianceCityDataManager:InitNewOccupyQueue()
  if self.initOccupy then
    return
  end
  self.initOccupy = true
  if not LuaEntry.Player:IsInAlliance() then
    return
  end
  local data = self.data[LuaEntry.Player:GetSourceServerId()]
  if not data then
    return
  end
  for _, v in pairs(self.allOccupyReward) do
    if v:HaveRewardToGet() then
      local newOccupy = AllianceCityOccupyInfo.New()
      newOccupy:ParseDataFormRewardInfo(v)
      table.insert(self.newOccupyQueue, newOccupy)
    end
  end
  self:LoadOldMyCities()
end

function WorldAllianceCityDataManager:LoadOldMyCities()
  if not LuaEntry.Player:IsInAlliance() then
    return nil
  end
  if self.oldMyCities == nil then
    self.oldMyCities = {}
    local myAllianceId = LuaEntry.Player.allianceId
    local myCitiesStr = CommonUtil.PlayerPrefsGetString("MY_ALLIANCE_CITIES", "")
    myCitiesStr = string.split(myCitiesStr, "|")
    if myCitiesStr[1] == myAllianceId then
      if string.IsNullOrEmpty(myCitiesStr[2]) then
        return nil
      end
      local cities = string.split(myCitiesStr[2], ",")
      for _, v in pairs(cities) do
        if string.len(v) ~= 0 then
          self.oldMyCities[tonumber(v)] = true
        end
      end
    else
      CommonUtil.PlayerPrefsSetString("MY_ALLIANCE_CITIES", myAllianceId .. "|")
      return nil
    end
  end
end

function WorldAllianceCityDataManager:SaveOldMyCities(cityId)
  if not LuaEntry.Player:IsInAlliance() then
    return
  end
  if self.oldMyCities == nil then
    return
  end
  local myAllianceId = LuaEntry.Player.allianceId
  self.oldMyCities[cityId] = true
  local myCitiesStr = string.format("%s|", myAllianceId)
  for k, v in pairs(self.oldMyCities) do
    myCitiesStr = myCitiesStr .. k .. ","
  end
  CommonUtil.PlayerPrefsSetString("MY_ALLIANCE_CITIES", myCitiesStr)
end

function WorldAllianceCityDataManager:ViewedOldMyCity(cityId)
  if self.oldMyCities and self.oldMyCities[cityId] ~= nil then
    return true
  end
  return false
end

function WorldAllianceCityDataManager:GetOccupyRewardByCityId(cityId)
  return self.allOccupyReward[cityId]
end

function WorldAllianceCityDataManager:UpdateOccupyReward(cityId, targetUid)
  if self.allOccupyReward[cityId] and self.allOccupyReward[cityId].ranks then
    for _, v in pairs(self.allOccupyReward[cityId].ranks) do
      if v.roleInfo.uid == targetUid then
        v.isThumbsUp = true
        if v.thumbsUpCount then
          v.thumbsUpCount = v.thumbsUpCount + 1
        end
        break
      end
    end
  end
end

function WorldAllianceCityDataManager:PushCityOccupy(msg)
end

function WorldAllianceCityDataManager:GetFirstNewOccupy()
  if #self.newOccupyQueue > 0 then
    return self.newOccupyQueue[1]
  end
end

function WorldAllianceCityDataManager:OccupyRewardCount()
  return #self.newOccupyQueue
end

function WorldAllianceCityDataManager:RemoveFirstNewOccupy(cityId)
  if #self.newOccupyQueue > 0 then
    for k, v in ipairs(self.newOccupyQueue) do
      if v.cityId == cityId then
        table.remove(self.newOccupyQueue, k)
        break
      end
    end
  end
end

function WorldAllianceCityDataManager:GetNearestMyCityTemplate(targetIndex, excludeLevel)
  if targetIndex == nil or targetIndex <= 0 then
    return nil
  end
  local pos = SceneUtils.IndexToTilePos(targetIndex, ForceChangeScene.World)
  local minDis = 99999
  local ret
  for k, _ in pairs(self.myAlCityList) do
    local meta = DataCenter.AllianceCityTemplateManager:GetTemplate(k)
    if excludeLevel ~= nil and excludeLevel == meta.level then
    else
      local dis = math.abs(meta.pos.x - pos.x) + math.abs(meta.pos.y - pos.y)
      if minDis > dis then
        ret = meta
        minDis = dis
      end
    end
  end
  return ret
end

function WorldAllianceCityDataManager:PushStrongholdFirstOccupyAnimation(msg)
  local curServerId = LuaEntry.Player:GetCurServerId()
  local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(msg.strongholdId, curServerId)
  local world = CS.SceneManager.World
  if cityTemplate and world then
    local worldPos = SceneUtils.TileToWorld(cityTemplate.pos, ForceChangeScene.World, curServerId)
    world:CreateBattleVFX("Assets/_Art/Effect/prefab/scene/xinshou/VFX_xinshuo_tuohuang_cangqiong.prefab", 3.5, function(go)
      go.transform:Set_position(worldPos.x, worldPos.y, worldPos.z)
    end)
  end
end

function WorldAllianceCityDataManager:GetCityWarInfo(serverId, requestWhenNotExist)
  local data
  if serverId == nil then
    data = self.theCityWarInfo
  else
    data = self.allCityInfo[toInt(serverId)]
  end
  if data == nil and requestWhenNotExist == true then
    if serverId == nil then
      SFSNetwork.SendMessage(MsgDefines.GetCityWarInfo)
    else
      SFSNetwork.SendMessage(MsgDefines.GetCityWarInfo, serverId)
    end
  end
  return data
end

function WorldAllianceCityDataManager:FetchBitMapCityWarInfo()
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local centerServerId = DataCenter.SeasonDataManager:GetNinePalacesServer(5, ServerEnum.Source)
  local cityWarInfoSource = self.allCityInfo[mySourceServerId]
  local cityWarInfoCenter = self.allCityInfo[centerServerId]
  if cityWarInfoSource == nil and 0 < mySourceServerId then
    SFSNetwork.SendMessage(MsgDefines.GetCityWarInfo, mySourceServerId)
  end
  if cityWarInfoCenter == nil and 0 < centerServerId then
    SFSNetwork.SendMessage(MsgDefines.GetCityWarInfo, centerServerId)
  end
  return cityWarInfoSource, cityWarInfoCenter
end

function WorldAllianceCityDataManager:HasFirstOccupy(serverId, cityId)
  local cityWarInfo = self.allCityInfo[toInt(serverId)]
  if cityWarInfo then
    for _, v in pairs(cityWarInfo.cityInfoList) do
      if v.cityId == cityId then
        return toInt(v.firstOccupyTime) > 0
      end
    end
  end
  return false
end

function WorldAllianceCityDataManager:OnGetCityWarInfo(msg)
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local nServerId = toInt(msg.serverId)
  local cityInfoList = {}
  for _, v in ipairs(msg.cityInfoList) do
    cityInfoList[v.cityId] = v
  end
  msg.cityInfoList = cityInfoList
  local noOpenList = {}
  for _, v in ipairs(msg.noOpenList) do
    noOpenList[v.cityId] = v
  end
  msg.noOpenList = noOpenList
  if nServerId <= 0 or nServerId == loginServerId then
    self.theCityWarInfo = msg
    self.allCityInfo[loginServerId] = msg
  else
    self.allCityInfo[nServerId] = msg
  end
  EventManager:GetInstance():Broadcast(EventId.GetActivityDetail)
end

function WorldAllianceCityDataManager:SetThroneNuclearScore(score, serverId)
  if self.actNuclearScore == nil then
    self.actNuclearScore = {}
  end
  if score ~= nil then
    local tServerId = serverId
    if tServerId == nil then
      tServerId = LuaEntry.Player:GetSelfServerId()
    end
    self.actNuclearScore[tServerId] = score
  end
end

function WorldAllianceCityDataManager:ReSetThroneNuclearScore()
  self.actNuclearScore = nil
end

function WorldAllianceCityDataManager:GetThroneNuclearScore(serverId)
  if self.actNuclearScore then
    return toInt(self.actNuclearScore[serverId] or 0)
  end
  return 0
end

function WorldAllianceCityDataManager:TryFetchStrongholdBattleState(_serverId)
  local serverId = toInt(_serverId)
  if 0 < serverId then
    local now = UITimeManager:GetInstance():GetServerTime()
    if self.strongholdBattleState == nil then
      self.strongholdBattleState = {}
      self.strongholdBattleState[serverId] = {time = now}
      SFSNetwork.SendMessage(MsgDefines.GetStrongholdBattleState, serverId)
    else
      local data = self.strongholdBattleState[serverId]
      if data == nil or data.time == nil or now - data.time > 60000 then
        SFSNetwork.SendMessage(MsgDefines.GetStrongholdBattleState, serverId)
        self.strongholdBattleState[serverId] = data or {}
        self.strongholdBattleState[serverId].time = now
      end
    end
  end
end

function WorldAllianceCityDataManager:CleanStrongholdBattleState(serverId)
  if self.strongholdBattleState == nil then
    self.strongholdBattleState = {}
  end
  self.strongholdBattleState[toInt(serverId)] = {}
end

function WorldAllianceCityDataManager:SetStrongholdBattleState(serverId, inBattleIds)
  if self.strongholdBattleState == nil then
    self.strongholdBattleState = {}
  end
  local data = {}
  data.time = UITimeManager:GetInstance():GetServerTime()
  for _, cityId in ipairs(inBattleIds) do
    data[cityId] = true
  end
  self.strongholdBattleState[toInt(serverId)] = data
  EventManager:GetInstance():Broadcast(EventId.StrongholdBattleStateUpdate)
end

function WorldAllianceCityDataManager:UpdateStrongholdBattleState(serverId, cityId, isBattle)
  if self.strongholdBattleState == nil then
    self.strongholdBattleState = {}
  end
  local data = self.strongholdBattleState[toInt(serverId)]
  if data == nil then
    self.strongholdBattleState[toInt(serverId)] = {
      [cityId] = isBattle
    }
  else
    data[cityId] = isBattle
  end
  if not isBattle then
    self:UpdateStrongholdBattleData(serverId, cityId, nil)
  end
  EventManager:GetInstance():Broadcast(EventId.StrongholdBattleStateUpdate)
end

function WorldAllianceCityDataManager:GetStrongholdBattleState(serverId, cityId)
  if self.strongholdBattleState == nil then
    return false
  end
  local data = self.strongholdBattleState[toInt(serverId)]
  if data == nil then
    return false
  end
  return data[cityId]
end

function WorldAllianceCityDataManager:UpdateStrongholdBattleData(serverId, cityId, progress)
  if self.strongholdBattleData == nil then
    self.strongholdBattleData = {}
  end
  local data = self.strongholdBattleData[toInt(serverId)]
  if data == nil then
    self.strongholdBattleData[toInt(serverId)] = {
      [cityId] = progress
    }
  else
    data[cityId] = progress
  end
end

function WorldAllianceCityDataManager:GetStrongholdBattleData(serverId, cityId)
  if self.strongholdBattleData == nil then
    return false
  end
  local data = self.strongholdBattleData[toInt(serverId)]
  if data == nil then
    return nil
  end
  return data[cityId]
end

function WorldAllianceCityDataManager:UpdateSuppliesData(msg)
  if msg.server then
    local serverId = toInt(msg.server)
    local data = {}
    self.suppliesCountData[toInt(serverId)] = data
    local info = msg.ice_supplies_info
    if info then
      for key, value in pairs(info) do
        local cityId = value.cityId
        local num = value.num
        data[cityId] = num
      end
    end
  end
end

function WorldAllianceCityDataManager:GetCitySuppliesNum(cityId)
  local serverId = LuaEntry.Player:GetCurServerId()
  local data = self.suppliesCountData[toInt(serverId)]
  if data and data[cityId] then
    return data[cityId]
  end
  return 0
end

function WorldAllianceCityDataManager:SetAllianceCityForceDetail(allianceId, data)
  if self.theAllianceCityForceDetail == nil then
    self.theAllianceCityForceDetail = {}
  end
  if allianceId and data then
    self.theAllianceCityForceDetail[allianceId] = data
  end
end

function WorldAllianceCityDataManager:GetAllianceCityForceDetail(allianceId, requestWhenNotExist)
  if self.theAllianceCityForceDetail == nil then
    if requestWhenNotExist then
      SFSNetwork.SendMessage(MsgDefines.FetchAllianceCityForceDetail, allianceId)
    end
    return nil
  end
  local data = self.theAllianceCityForceDetail[allianceId]
  if requestWhenNotExist and data == nil then
    SFSNetwork.SendMessage(MsgDefines.FetchAllianceCityForceDetail, allianceId)
  end
  return data
end

function WorldAllianceCityDataManager:CleanLandlordCityOccupyData()
  if self.data == nil or DataCenter.LandlordMgr == nil then
    return
  end
  local centerServerId = toInt(DataCenter.LandlordMgr:GetCenterServerId())
  if centerServerId <= 0 then
    return
  end
  local serverKey = SeasonUtil.GetSeasonGroupName(centerServerId)
  local oneServerData = self.data[serverKey]
  if oneServerData == nil then
    return
  end
  local hasChanged = false
  local tblName = SeasonUtil.GetWorldCityTableNameByServerId(centerServerId)
  if string.IsNullOrEmpty(tblName) then
    return
  end
  local tblMgr = LocalController:instance()
  if oneServerData.allAllianceCityList then
    for cityId, cityInfo in pairs(oneServerData.allAllianceCityList) do
      local cityType = tblMgr:getIntValue(tblName, toInt(cityId), "type", 0)
      if cityType == WorldAllianceCityType.LLNormalCity or cityType == WorldAllianceCityType.LLThroneCity then
        oneServerData.allAllianceCityList[cityId] = nil
        hasChanged = true
      end
    end
  end
  if hasChanged then
    EventManager:GetInstance():Broadcast(EventId.WorldCityOwnerInfoChanged, centerServerId)
  end
end

function WorldAllianceCityDataManager:GetAllianceLoadIcon(cityId, type, level)
  local config = SeasonUtil.GetCurServerConfig()
  local forSeason = config and config.mode ~= nil and config.mode ~= 0
  local pic = "Assets/Main/Sprites/LodIcon/cfm_daditu_chengshi_01.png"
  if type == WorldAllianceCityType.TradingStation then
    pic = "Assets/Main/SeasonRes/Shared/Sprites/LWCommon/LodIcon/zyf_S3_wujisuofang_2.png"
  elseif type == WorldAllianceCityType.Stronghold then
    pic = "Assets/Main/Sprites/LodIcon/judian_new_S1_icon.png"
  elseif forSeason then
    pic = "Assets/Main/Sprites/LodIcon/chengshi_new_S1_icon.png"
  end
  if level == 7 and (type == WorldAllianceCityType.Canon or type == WorldAllianceCityType.MissileFactory or type == WorldAllianceCityType.King) then
    if type == WorldAllianceCityType.MissileFactory then
      local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, LuaEntry.Player:GetCurServerId())
      if cityMeta then
        pic = string.format("Assets/Main/Sprites/LodIcon/lrb_wujisuofang_icon0%s.png", toInt(cityId - 1000))
      else
        pic = "Assets/Main/Sprites/LodIcon/lyp_daditu_chengshi_01.png"
      end
    elseif type == WorldAllianceCityType.Canon then
      local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, LuaEntry.Player:GetCurServerId())
      if cityMeta then
        pic = string.format("Assets/Main/Sprites/LodIcon/lrb_wujisuofang_icon0%s.png", toInt(cityId - 1000))
      else
        pic = "Assets/Main/Sprites/LodIcon/lyp_daditu_chengshi_01.png"
      end
    elseif forSeason then
      local cityMeta = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, LuaEntry.Player:GetCurServerId())
      pic = cityMeta and cityMeta.lod_icon
      if string.IsNullOrEmpty(pic) then
        if SeasonUtil.SeasonHasMilitaryCenter(config:GetServerType()) then
          pic = "Assets/Main/Sprites/LodIcon/zyf_wangzhuoqizi_shoujiwuzi.png"
        else
          pic = "Assets/Main/Sprites/LodIcon/wangzuo_new_S1_icon.png"
        end
      end
    else
      pic = "Assets/Main/Sprites/LodIcon/lyp_daditu_chengshi_04.png"
    end
  end
  return pic
end

function WorldAllianceCityDataManager:GetAllianceLodIconColor(cityId, type, pointId_, serverId)
  local MyAllianceId = "NotInAlliance"
  local MyCampId, allianceId, ownerServerId, ownerCampId
  local isLandlordCityOpen = true
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  if LuaEntry.Player:IsInAlliance() then
    MyAllianceId = LuaEntry.Player:GetAllianceUid()
  end
  if type == WorldAllianceCityType.LLNormalCity or type == WorldAllianceCityType.LLThroneCity then
    if DataCenter.LandlordMgr:GetActCurStage() ~= LLConst.LandlordStage.NONE then
      MyCampId = DataCenter.LandlordMgr:GetMyGroup()
    elseif DataCenter.LandlordMgr:IsInNewCenterMapPeriod() then
      MyCampId = LLConst.LandLordGroup.NONE
    end
  end
  local cityInfo = self:GetAllianceCityDataByCityId(cityId, serverId)
  if cityInfo ~= nil then
    allianceId = cityInfo.allianceId
    ownerServerId = cityInfo.occupyServerId
  else
    local pointInfo = CS.SceneManager.World and CS.SceneManager.World:GetPointInfoWithServer(pointId_, serverId)
    if pointInfo ~= nil then
      local extraInfo = SeasonUtil.TryParseAllianceCityPointInfo(pointInfo.PointType, pointInfo.extraInfo, pointInfo)
      if extraInfo ~= nil then
        allianceId = extraInfo.allianceId
        ownerServerId = extraInfo.serverId
        if DataCenter.LandlordMgr:IsLandlordCity(cityId, serverId) then
          ownerCampId = extraInfo.tmpOwnerCampId or LLConst.LandLordGroup.NONE
          local unlockWeek = DataCenter.LandlordMgr:GetCityUnlockWeek(cityId)
          if unlockWeek == 1 and DataCenter.LandlordMgr:GetActData() and DataCenter.LandlordMgr:GetCurWeek() == 0 then
            isLandlordCityOpen = true
          else
            isLandlordCityOpen = DataCenter.LandlordMgr:IsUnlockCityByWeek(cityId)
          end
        end
      end
    end
  end
  local config = SeasonUtil.GetSeasonInfo(serverId or LuaEntry.Player:GetCurServerId())
  local inSeason = false
  local seasonType = SeasonMapType.Nothing
  if config ~= nil then
    inSeason = config:InNormalMode() or config:InHaltMode()
    seasonType = config:GetServerType(false)
  end
  if inSeason and (type == WorldAllianceCityType.City or type == WorldAllianceCityType.Stronghold or type == WorldAllianceCityType.Altar or type == WorldAllianceCityType.TradingStation) then
    if string.IsNullOrEmpty(allianceId) then
      return Color.New(0.91, 0.91, 0.91, 1)
    end
    if cityInfo then
      local colorIndex = toInt(cityInfo.color) + 1
      local outlineColor
      local meta = CS.SceneSkinManager.Instance:GetCurSkinMeta()
      if meta and meta.world_city_color then
        outlineColor = GetTableData(meta.world_city_color, colorIndex, "outlineColor")
      else
        outlineColor = GetTableData(TableName.world_city_color, colorIndex, "outlineColor")
      end
      local RR, GG, BB = string.match(outlineColor, "(%w%w)(%w%w)(%w%w)")
      if RR and GG and BB then
        return Color.New(tonumber("0x" .. RR) / 255, tonumber("0x" .. GG) / 255, tonumber("0x" .. BB) / 255, 1)
      end
    end
    return Color.New(1, 1, 1, 1)
  end
  local iconColor = Color.New(1, 1, 1, 1)
  local forSeason = inSeason
  if forSeason then
    iconColor = Color.New(0.91, 0.91, 0.91, 1)
  end
  if type == WorldAllianceCityType.Canon or type == WorldAllianceCityType.MissileFactory or type == WorldAllianceCityType.CrossZoneOutpostCanon then
    if ownerServerId == nil or ownerServerId == 0 or ownerServerId == "" then
      iconColor = Color.New(1, 1, 1, 1)
    elseif SeasonUtil.IsAlly(ownerServerId, LuaEntry.Player:GetSourceServerId(), allianceId) then
      iconColor = Color.New(0.15294117647058825, 0.7490196078431373, 0.9921568627450981, 1)
    else
      iconColor = Color.New(0.8117647058823529, 0.16470588235294117, 0.16470588235294117, 1)
    end
  elseif ownerServerId == nil or ownerServerId == 0 or ownerServerId == "" then
    if forSeason then
      if allianceId == MyAllianceId then
        iconColor = Color.New(0.17254901960784313, 0.6549019607843137, 1, 1)
      elseif allianceId ~= nil and allianceId ~= "" then
        if LuaEntry.Player:AtHomeNow() then
          iconColor = Color.New(0.7137254901960784, 0.7137254901960784, 0.7137254901960784, 1)
        else
          iconColor = Color.New(0.9725490196078431, 0.34901960784313724, 0.403921568627451, 1)
        end
      else
        iconColor = Color.New(0.91, 0.91, 0.91, 1)
      end
    else
      iconColor = Color.New(1, 1, 1, 1)
    end
  elseif SeasonUtil.IsAlly(ownerServerId, LuaEntry.Player:GetSourceServerId(), allianceId) then
    if allianceId == MyAllianceId then
      iconColor = Color.New(0.17254901960784313, 0.6549019607843137, 1, 1)
    else
      iconColor = Color.New(0.7137254901960784, 0.7137254901960784, 0.7137254901960784, 1)
    end
  elseif MyCampId then
    if MyCampId == ownerCampId and ownerCampId ~= LLConst.LandLordGroup.NONE then
      iconColor = Color.New(0.15294117647058825, 0.7490196078431373, 0.9921568627450981, 1)
    elseif MyCampId ~= ownerCampId and ownerCampId ~= LLConst.LandLordGroup.NONE then
      iconColor = Color.New(0.8117647058823529, 0.16470588235294117, 0.16470588235294117, 1)
    elseif not isLandlordCityOpen then
      iconColor = Color.New(0.6784313725490196, 0.6784313725490196, 0.6784313725490196, 1)
    else
      iconColor = Color.New(1, 0.7529411764705882, 0.21568627450980393, 1)
    end
  else
    iconColor = Color.New(0.9725490196078431, 0.34901960784313724, 0.403921568627451, 1)
  end
  return iconColor
end

function WorldAllianceCityDataManager:GetAllAllianceTradeStation(msg)
  local preUuidList = {}
  for k, v in pairs(self.allianceTradeStationMap) do
    preUuidList[k] = true
  end
  local newUuidList = {}
  if msg and msg.allianceWorldCityTradeServerArr then
    for i, v in ipairs(msg.allianceWorldCityTradeServerArr) do
      if v.worldCityTradeArr and v.serverId then
        for j, jV in ipairs(v.worldCityTradeArr) do
          local uuid = jV.uuid
          newUuidList[uuid] = true
          local data = self.allianceTradeStationMap[uuid]
          if data == nil then
            data = TradeStationItemData.New()
            self.allianceTradeStationMap[uuid] = data
          end
          data:ParseData(jV)
        end
      end
    end
  end
  local delteUuidList = {}
  for k, v in pairs(self.allianceTradeStationMap) do
    if preUuidList[k] and newUuidList[k] == nil then
      delteUuidList[k] = true
    end
  end
  for k, v in pairs(delteUuidList) do
    self.allianceTradeStationMap[k] = nil
  end
  EventManager:GetInstance():Broadcast(EventId.GetAllAllianceTradeStationData)
end

function WorldAllianceCityDataManager:GetAllAllianceTradeStationData()
  return self.allianceTradeStationMap
end

function WorldAllianceCityDataManager:GetTradeStationRecordData(msg)
  if msg then
    local resultData = {}
    resultData.recordType = msg.type
    resultData.serverId = msg.serverId
    resultData.tradeId = msg.tradeId
    resultData.dataList = {}
    local recordType = msg.type
    local serverId = msg.serverId
    local tradeId = msg.tradeId
    for i, v in ipairs(msg.cityTradeLogArr) do
      local recordData = {}
      recordData.content = CommonUtil.GetStrLog(v.code, v, false)
      recordData.time = v.time
      recordData.userInfo = {}
      recordData.userInfo.name = v.userInfo.name
      recordData.userInfo.uid = v.userInfo.uid
      recordData.userInfo.abbr = v.userInfo.abbr
      recordData.userInfo.abbr = v.userInfo.abbr
      recordData.userInfo.srcServer = v.userInfo.srcServer
      recordData.userInfo.pic = v.userInfo.pic
      recordData.userInfo.picver = v.userInfo.picver
      recordData.userInfo.headFrame = v.userInfo.headFrame
      recordData.userInfo.headSkinId = v.userInfo.headSkinId
      recordData.userInfo.headSkinET = v.userInfo.headSkinET
      recordData.userInfo.allianceId = v.userInfo.allianceId
      table.insert(resultData.dataList, recordData)
    end
    EventManager:GetInstance():Broadcast(EventId.TradeStationRecordDataChange, resultData)
  end
  EventManager:GetInstance():Broadcast(EventId.TradeStationRecordDataChange, nil)
  return
end

function WorldAllianceCityDataManager:TryFetchTradeStationState(_serverId)
  local serverId = toInt(_serverId)
  if serverId <= 0 then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.tradeStationRequestTimeStamps == nil then
    self.tradeStationRequestTimeStamps = {}
  end
  local time = self.tradeStationRequestTimeStamps[serverId]
  if not time or 60000 < now - time then
    self.tradeStationRequestTimeStamps[serverId] = now
    SFSNetwork.SendMessage(MsgDefines.GetAllServerTradeMessage, serverId)
  end
end

function WorldAllianceCityDataManager:ClearTradeStationState(_serverId)
  local serverId = toInt(_serverId)
  if self.tradeStationRequestTimeStamps == nil then
    self.tradeStationRequestTimeStamps = {}
  end
  self.tradeStationRequestTimeStamps[serverId] = nil
end

function WorldAllianceCityDataManager:IsMyCamp(serverId, cityId)
  local cityInfo = self:GetAllianceCityDataByCityId(cityId, serverId)
  if cityInfo then
    return DataCenter.SeasonFactionWarDataManager:IsInSameCampByServer(cityInfo.occupyServerId)
  end
  return false
end

function WorldAllianceCityDataManager:IsDestroyByMyCamp(serverId, cityId)
  local cityInfo = self:GetAllianceCityDataByCityId(cityId, serverId)
  if cityInfo then
    return DataCenter.SeasonFactionWarDataManager:IsInSameCampByServer(cityInfo.destroyServerId)
  end
  return false
end

function WorldAllianceCityDataManager:GetCampOccCityOrStrongholdList(isCity)
  local campCityList = {}
  local myCampId = DataCenter.SeasonFactionWarDataManager.myCampId
  local campInfo = DataCenter.SeasonFactionWarDataManager:GetGroupingData() or {}
  local myCampServerList = {}
  for k, v in pairs(campInfo) do
    if v.campId == myCampId then
      table.insert(myCampServerList, v.serverId)
    end
  end
  local s1, s2, s3, s4 = table.unpack(myCampServerList)
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local allCityList = DataCenter.WorldAllianceCityDataManager:GetAllianceCityList(mySourceServerId)
  if allCityList then
    for cityId, v in pairs(allCityList) do
      if v:IsRuins() then
      elseif v.occupyServerId == s1 or v.occupyServerId == s2 or v.occupyServerId == s3 or v.occupyServerId == s4 then
        local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, mySourceServerId)
        if isCity and cityTemplate:IsCity() then
          campCityList[v.cityId] = v
        elseif not isCity and cityTemplate:IsCityStronghold() then
          campCityList[v.cityId] = v
        end
      end
    end
  end
  return campCityList
end

function WorldAllianceCityDataManager:GetCampDestroyCityList()
  local campCityList = {}
  local myCampId = DataCenter.SeasonFactionWarDataManager.myCampId
  local campInfo = DataCenter.SeasonFactionWarDataManager:GetGroupingData() or {}
  local myCampServerList = {}
  for k, v in pairs(campInfo) do
    if v.campId == myCampId then
      table.insert(myCampServerList, v.serverId)
    end
  end
  local s1, s2, s3, s4 = table.unpack(myCampServerList)
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local allCityList = DataCenter.WorldAllianceCityDataManager:GetAllianceDestroyCityList(mySourceServerId)
  if allCityList then
    for cityId, serverId in pairs(allCityList) do
      if serverId == s1 or serverId == s2 or serverId == s3 or serverId == s4 then
        campCityList[cityId] = serverId
      end
    end
  end
  return campCityList
end

function WorldAllianceCityDataManager:TrySendGetAltarEffect(seasonType, serverId)
  if SeasonUtil.SeasonHasAltar(seasonType, serverId) then
    SFSNetwork.SendMessage(MsgDefines.CityaltarEffect)
  end
end

WorldAllianceCityDataManager.__init = __init
WorldAllianceCityDataManager.__delete = __delete
WorldAllianceCityDataManager.GetCityIsNearBySelfAlliance = GetCityIsNearBySelfAlliance
WorldAllianceCityDataManager.GetAllianceAlreadyHaveCity = GetAllianceAlreadyHaveCity
WorldAllianceCityDataManager.IsAllianceAlreadyHaveCity = IsAllianceAlreadyHaveCity
WorldAllianceCityDataManager.UpdateAllCityData = UpdateAllCityData
WorldAllianceCityDataManager.Startup = Startup
WorldAllianceCityDataManager.GetAllianceCityList = GetAllianceCityList
WorldAllianceCityDataManager.GetAllianceColorList = GetAllianceColorList
WorldAllianceCityDataManager.GetAllianceCityDataByCityId = GetAllianceCityDataByCityId
WorldAllianceCityDataManager.UpdateMyAlCities = UpdateMyAlCities
WorldAllianceCityDataManager.GetMyAlCityInfo = GetMyAlCityInfo
WorldAllianceCityDataManager.GetCitiesByAlId = GetCitiesByAlId
WorldAllianceCityDataManager.GetCitiesCountByAlId = GetCitiesCountByAlId
WorldAllianceCityDataManager.GetStrongholdsByAlId = GetStrongholdsByAlId
WorldAllianceCityDataManager.GetStrongholdCountByAlId = GetStrongholdCountByAlId
WorldAllianceCityDataManager.UpdateOneGivingUpCity = UpdateOneGivingUpCity
WorldAllianceCityDataManager.OnAlCityGiveUpFail = OnAlCityGiveUpFail
WorldAllianceCityDataManager.UpdateAllianceCityEffect = UpdateAllianceCityEffect
WorldAllianceCityDataManager.GetAllianceCityEffectById = GetAllianceCityEffectById
WorldAllianceCityDataManager.UpdateCityName = UpdateCityName
WorldAllianceCityDataManager.CheckIfHasAlCity = CheckIfHasAlCity
WorldAllianceCityDataManager.CheckIfIsAlTerritory = CheckIfIsAlTerritory
WorldAllianceCityDataManager.GetAllianceCityEffects = GetAllianceCityEffects

function WorldAllianceCityDataManager:Description()
  local sb = StringBuilder.New()
  sb:AppendLine("")
  sb:AppendLine("====== \229\159\142\229\184\130\230\149\176\230\141\174\232\175\166\230\131\133 ======")
  if self.data == nil then
    sb:AppendLine("\230\149\176\230\141\174\228\184\186\231\169\186")
    return sb:ToString()
  end
  sb:AppendLine("city      | abbr    | occupyServerId | destroyServerId | color")
  local totalCount = 0
  for serverId, data in pairs(self.data) do
    local cityList = data.allAllianceCityList or {}
    local cityArray = {}
    for cityId, cityInfo in pairs(cityList) do
      table.insert(cityArray, {cityId = cityId, info = cityInfo})
    end
    table.sort(cityArray, function(a, b)
      return (a.cityId or 0) < (b.cityId or 0)
    end)
    sb:AppendLine("")
    sb:AppendLineFormat("[\230\156\141\229\138\161\229\153\168 %s] \229\133\177 %d \228\184\170\229\159\142\229\184\130", serverId, #cityArray)
    for _, item in ipairs(cityArray) do
      local cityId = item.cityId
      local info = item.info
      local abbr = info.abbr or ""
      local occupyServerId = info.occupyServerId or 0
      local destroyServerId = info.destroyServerId or 0
      local color = info.color or 0
      if string.len(abbr) > 8 then
        abbr = string.sub(abbr, 1, 8)
      end
      sb:AppendLineFormat("%-10d | %-8s | %-14d | %-15d | %d", cityId, abbr, occupyServerId, destroyServerId, color)
      totalCount = totalCount + 1
    end
  end
  sb:AppendLine("")
  sb:AppendLineFormat("\230\128\187\232\174\161: %d \228\184\170\229\159\142\229\184\130", totalCount)
  sb:AppendLine("================================")
  return sb:ToString()
end

return WorldAllianceCityDataManager
