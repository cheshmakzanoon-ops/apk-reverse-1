local SeasonOutpostManager = BaseClass("SeasonOutpostManager")
local FetchOutpostRepairInfo = require("Net.Msgs.Season5.Outpost.FetchOutpostRepairInfoMessage")
local FetchOutpostDetailInfo = require("Net.Msgs.Season5.Outpost.FetchOutpostDetailInfoMessage")

function SeasonOutpostManager:__init()
end

function SeasonOutpostManager:__delete()
end

function SeasonOutpostManager:TryGetNum(key, default)
  local seasonType = SeasonUtil.GetSeasonType(false, true, ServerEnum.Source)
  if seasonType == SeasonMapType.NineNationRainforest then
    return LuaEntry.DataConfig:TryGetNum("wonder_zone_war_put_out_s6", key, default)
  elseif seasonType == SeasonMapType.NineNation then
    return LuaEntry.DataConfig:TryGetNum("wonder_zone_war_put_out", key, default)
  end
  return default
end

function SeasonOutpostManager:GetOutpostPos(cityIndex)
  if self.theOutpostPosList == nil then
    return nil
  end
  return self.theOutpostPosList[toInt(cityIndex)]
end

function SeasonOutpostManager:IsMyOutpost(serverId, cityId)
  if self.theOutpostPosList == nil then
    return false
  end
  for k, v in pairs(self.theOutpostPosList) do
    if v and v.cityId == cityId and v.serverId == serverId then
      return true
    end
  end
  return false
end

function SeasonOutpostManager:SetOutpostPos(cityIndex, cityId)
  if self.theOutpostPosList == nil then
    self.theOutpostPosList = {}
  end
  local index = toInt(cityIndex)
  local theCityId = toInt(cityId)
  local data = self.theOutpostPosList[index]
  if data and data.cityId and data.serverId and data.meta then
    data.cityId = theCityId
    local repairInfo = FetchOutpostRepairInfo.GetRepairInfo(data.serverId, theCityId, true)
    if repairInfo then
      data.repairInfo = repairInfo
      if repairInfo.outpostInfo and repairInfo.outpostInfo.state == 1 then
        data.detailInfo = FetchOutpostDetailInfo.GetDetailInfo(data.serverId, theCityId, true)
      end
    end
  else
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    local template = DataCenter.AllianceCityTemplateManager:GetTemplate(theCityId, mySourceServerId)
    if template then
      local CityServerId = template:GetSourceServerId()
      local repairInfo = FetchOutpostRepairInfo.GetRepairInfo(CityServerId, theCityId, true)
      if repairInfo then
        self.theOutpostPosList[index] = {
          cityId = theCityId,
          serverId = CityServerId,
          meta = template,
          repairInfo = repairInfo
        }
        if repairInfo.outpostInfo and repairInfo.outpostInfo.state == 1 then
          self.theOutpostPosList[index].detailInfo = FetchOutpostDetailInfo.GetDetailInfo(CityServerId, theCityId, true)
        end
      else
        self.theOutpostPosList[index] = {
          cityId = theCityId,
          serverId = CityServerId,
          meta = template
        }
      end
    else
      Logger.LogError("city not exist")
    end
  end
  EventManager:GetInstance():DelayBroadcast(0.1, EventId.OutpostListUpdate)
end

function SeasonOutpostManager:GetPutInfoByCityId(cityId)
  if self.theSourceMapOutpostList == nil then
    return nil
  end
  local data = self.theSourceMapOutpostList[toInt(cityId)]
  if data then
    return data.serverId
  end
  return nil
end

function SeasonOutpostManager:SetSourceMapOutpostList(data)
  if data.serverList then
    local dataList = {}
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    for _, v in ipairs(data.serverList) do
      for theIndex, theCityId in pairs(v.selectCity) do
        dataList[theCityId] = {
          index = theIndex,
          serverId = v.serverId
        }
        if v.serverId == mySourceServerId then
          DataCenter.SeasonOutpostManager:SetOutpostPosList(v)
        end
      end
    end
    self.theSourceMapOutpostList = dataList
  end
end

function SeasonOutpostManager:SetOutpostPosList(data)
  if data and data.selectCity then
    local theSourceMapOutpostList = self.theSourceMapOutpostList or {}
    local theOutpostPosList = {}
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    for cityIndex, cityId in pairs(data.selectCity) do
      local template = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, mySourceServerId)
      if template then
        local index = toInt(cityIndex)
        local theCityId = toInt(cityId)
        local CityServerId = template:GetSourceServerId()
        local repairInfo = FetchOutpostRepairInfo.GetRepairInfo(CityServerId, theCityId, true)
        if repairInfo then
          theOutpostPosList[index] = {
            cityId = theCityId,
            serverId = CityServerId,
            meta = template,
            repairInfo = repairInfo
          }
          if repairInfo.outpostInfo and repairInfo.outpostInfo.state == 1 then
            theOutpostPosList[index].detailInfo = FetchOutpostDetailInfo.GetDetailInfo(CityServerId, theCityId, true)
          end
        else
          theOutpostPosList[index] = {
            cityId = theCityId,
            serverId = CityServerId,
            meta = template
          }
        end
      else
        Logger.LogError("city not exist")
      end
      theSourceMapOutpostList[cityId] = {
        index = cityIndex,
        serverId = data.serverId
      }
    end
    self.theOutpostPosList = theOutpostPosList
    self.theSourceMapOutpostList = theSourceMapOutpostList
    EventManager:GetInstance():DelayBroadcast(0.1, EventId.OutpostListUpdate)
  end
end

function SeasonOutpostManager:SetOutpostRepairInfo(serverId, cityId, repairInfo)
  if SeasonUtil.IsInSameGroup(serverId, ServerEnum.Source) and self.theOutpostPosList then
    for k, v in pairs(self.theOutpostPosList) do
      if v and v.cityId == cityId then
        v.repairInfo = repairInfo
        if repairInfo.outpostInfo and repairInfo.outpostInfo.state == 1 then
          v.detailInfo = FetchOutpostDetailInfo.GetDetailInfo(v.serverId, v.cityId, true)
        end
      end
    end
    EventManager:GetInstance():DelayBroadcast(0.1, EventId.OutpostListUpdate)
  end
end

function SeasonOutpostManager:SetOutpostDetailInfo(serverId, cityId, detailInfo)
  if SeasonUtil.IsInSameGroup(serverId, ServerEnum.Source) and self.theOutpostPosList then
    for k, v in pairs(self.theOutpostPosList) do
      if v and v.cityId == cityId then
        v.detailInfo = detailInfo
      end
    end
    EventManager:GetInstance():DelayBroadcast(0.1, EventId.OutpostListUpdate)
  end
end

function SeasonOutpostManager:CalcPutData()
  if self.putActivityInfoList then
    if CommonUtil ~= nil and CommonUtil.IsEditor() then
      for index, theCityData in ipairs(self.putActivityInfoList) do
        local timeStr0 = UITimeManager:GetInstance():TimeStampToTimeForServer(theCityData.unlock_time)
        local timeStr1 = UITimeManager:GetInstance():TimeStampToTimeForServer(theCityData.put_start_time)
        local timeStr2 = UITimeManager:GetInstance():TimeStampToTimeForServer(theCityData.put_end_time)
        Logger.Log(string.format("[%s] \232\167\163\233\148\129\230\151\182\233\151\180 = %s, \230\148\190\231\189\174\229\188\128\229\167\139 = %s, \230\148\190\231\189\174\231\187\147\230\157\159 = %s ", index, timeStr0, timeStr1, timeStr2))
      end
    end
    return self.putActivityInfoList
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local actData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonWarZoneOutpostFix.Type)
  local startTime = UITimeManager:GetInstance():GetZeroTime(actData.startTime)
  local para_6 = actData.para_6
  local put_time = toInt(actData.para_7) * 1000
  local para_8 = actData.para_8
  if string.IsNullOrEmpty(para_8) then
    para_8 = para_6
  end
  local dayListUnlock = string.split_ii_array(para_6, ";")
  local dayListPut = string.split_ii_array(para_8, ";")
  local dataList = {
    {
      index = 1,
      unlock_time = 0,
      put_start_time = 0,
      put_end_time = 0,
      finish_time = 0
    },
    {
      index = 2,
      unlock_time = 0,
      put_start_time = 0,
      put_end_time = 0,
      finish_time = 0
    },
    {
      index = 3,
      unlock_time = 0,
      put_start_time = 0,
      put_end_time = 0,
      finish_time = 0
    },
    {
      index = 4,
      unlock_time = 0,
      put_start_time = 0,
      put_end_time = 0,
      finish_time = actData.endTime
    }
  }
  local theCityData, prev_data
  for i, day in ipairs(dayListUnlock) do
    theCityData = dataList[i]
    if theCityData then
      theCityData.unlock_time = startTime + (day - 1) * OneDayTime * 1000
    end
  end
  for i, day in ipairs(dayListPut) do
    theCityData = dataList[i]
    if theCityData then
      theCityData.put_start_time = startTime + (day - 1) * OneDayTime * 1000
      theCityData.put_end_time = theCityData.put_start_time + put_time
      if prev_data then
        prev_data.finish_time = theCityData.put_start_time
      end
    end
    prev_data = theCityData
  end
  self.putActivityInfoList = dataList
  return dataList
end

function SeasonOutpostManager:SetOutpostBattleInfo(serverId, cityId, data)
  if self.OutpostBattleListInfo == nil then
    self.OutpostBattleListInfo = {}
  end
  self.OutpostBattleListInfo[serverId * 10000 + cityId] = data
end

function SeasonOutpostManager:GetOutpostBattleInfo(cityId, serverId)
  if self.OutpostBattleListInfo == nil then
    SFSNetwork.SendMessage(MsgDefines.FetchOutpostBattleOccupyList, serverId, cityId)
    return nil
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local data = self.OutpostBattleListInfo[serverId * 10000 + cityId]
  if data == nil or now - toInt(data.now) > 5000 or (data.ownerServerId == nil or data.ownerServerId == 0) and now - toInt(data.now) >= 1000 then
    SFSNetwork.SendMessage(MsgDefines.FetchOutpostBattleOccupyList, serverId, cityId)
  end
  return data
end

function SeasonOutpostManager:SetOutpostCampBattleInfo(serverId, cityId, data)
  if self.OutpostBattleListInfo == nil then
    self.OutpostBattleListInfo = {}
  end
  self.OutpostBattleListInfo[serverId * 10000 + cityId] = data
end

function SeasonOutpostManager:GetOutpostCampBattleInfo(cityId, serverId)
  if self.OutpostBattleListInfo == nil then
    SFSNetwork.SendMessage(MsgDefines.FetchOutpostCampBattleOccupyList, serverId, cityId)
    return nil
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  local data = self.OutpostBattleListInfo[serverId * 10000 + cityId]
  if data == nil or now - toInt(data.now) > 5000 or (data.ownerServerId == nil or data.ownerServerId == 0) and now - toInt(data.now) >= 1000 then
    SFSNetwork.SendMessage(MsgDefines.FetchOutpostCampBattleOccupyList, serverId, cityId)
  end
  return data
end

return SeasonOutpostManager
