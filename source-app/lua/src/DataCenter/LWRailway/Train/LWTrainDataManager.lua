local LWTrainDataManager = BaseClass("LWTrainDataManager")
local TrainData = require("DataCenter.LWRailway.Train.TrainData")
local TrainMeta = require("DataCenter.LWRailway.Train.TrainMeta")
local ITEM_TYPE = {
  TOP = 1,
  MIDDLE = 2,
  BOTTOM = 3
}
local Localization = CS.GameEntry.Localization

function LWTrainDataManager:__init()
  self.enemyTrucks = {}
  self.enemyTrains = {}
  self.allTrains = {}
  self.allTrainsByMarchUuid = {}
  self:AddListener()
  self.CheckTrainRefreshInterval = nil
  self.CheckMyTrainRefreshInterval = nil
end

function LWTrainDataManager:__delete()
  self:ClearData()
  self:RemoveListener()
end

function LWTrainDataManager:ClearData()
  self.allTrains = {}
  self.allTrainsByMarchUuid = {}
  self.trainMeta = nil
  self.CheckTrainRefreshInterval = nil
  self.CheckMyTrainRefreshInterval = nil
end

function LWTrainDataManager:AddListener()
end

function LWTrainDataManager:RemoveListener()
end

function LWTrainDataManager:InitMeta()
  if self.trainMeta then
    return
  end
  self.trainMeta = {}
  LocalController:instance():visitTable(TableName.LW_Train_Property, function(id, lineData)
    if lineData ~= nil then
      local item = TrainMeta.New()
      item:InitConfig(lineData)
      if item.id ~= nil then
        self.trainMeta[item.id] = item
      end
    end
  end)
end

function LWTrainDataManager:GetMeta(id)
  self:InitMeta()
  return self.trainMeta[id]
end

function LWTrainDataManager:GetAllMeta()
  self:InitMeta()
  return self.trainMeta
end

function LWTrainDataManager:AddOneTrain(msg, isCSharp)
  local newTrain = TrainData.New(msg, isCSharp)
  self.allTrains[newTrain.uuid] = newTrain
  self.allTrainsByMarchUuid[newTrain.marchUid] = newTrain
  return newTrain
end

function LWTrainDataManager:AddOrUpdateTrain(msg)
  if not msg then
    return
  end
  local train = self:GetOneTrain(msg.uuid)
  if train then
    train:Refresh(msg, true)
  else
    self:AddOneTrain(msg, true)
  end
end

function LWTrainDataManager:OnCheckTrainRefreshReceived(msg)
  if msg then
    if msg.train then
      local uuid = msg.train.uuid
      local train = self:GetOneTrain(uuid)
      if train then
        train:Refresh(msg.train)
        if train.type == TrainType.Train then
          DataCenter.LW3V3Manager:TryRefreshRobTrain(uuid)
        else
          EventManager:GetInstance():Broadcast(EventId.CheckTrainRefreshReceived, uuid)
        end
      end
      train = DataCenter.LWMyStationDataManager:GetMyTrainByUuid(uuid)
      if train then
        train:Refresh(msg.train)
        EventManager:GetInstance():Broadcast(EventId.CheckMyTrainRefreshReceived, uuid)
      end
    elseif msg.lastUpdateTime and msg.uuid then
      local train = self:GetOneTrain(msg.uuid)
      if train then
        train:RefreshLastUpdateTime(msg.lastUpdateTime)
      end
      train = DataCenter.LWMyStationDataManager:GetMyTrainByUuid(msg.uuid)
      if train then
        train:RefreshLastUpdateTime(msg.lastUpdateTime)
      end
    end
  end
end

function LWTrainDataManager:TryCheckTrainRefresh(trainData)
  if trainData == nil then
    return
  end
  local uuid = trainData.uuid
  if uuid == nil then
    return
  end
  if self.CheckTrainRefreshInterval == nil then
    local val = self:GetTrainPara(39)
    local interval = tonumber(val) or 1
    self.CheckTrainRefreshInterval = interval * 1000
  end
  if self.CheckMyTrainRefreshInterval == nil then
    local val = self:GetTrainPara(51)
    local interval = tonumber(val) or 1
    self.CheckMyTrainRefreshInterval = interval * 1000
  end
  local lastUpdateTime = trainData.lastUpdateTime or 0
  local cur = UITimeManager:GetInstance():GetServerTime()
  local interval = self.CheckTrainRefreshInterval
  if trainData:IsMyTrain() then
    interval = self.CheckMyTrainRefreshInterval
  end
  if interval > cur - lastUpdateTime then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.CheckTrainRefresh, uuid, trainData.serverId)
end

function LWTrainDataManager:RefreshOneTrain(msg)
  local train = self:GetOneTrain(msg.uuid)
  if train then
    train:Refresh(msg)
  end
end

function LWTrainDataManager:GetOneTrain(uuid)
  return self.allTrains[uuid]
end

function LWTrainDataManager:GetOneTrainByMarchUuid(uuid)
  return self.allTrainsByMarchUuid[uuid]
end

function LWTrainDataManager:GetOneTrainByMarchInfo(marchInfo)
  return self.allTrainsByMarchUuid[marchInfo.uuid]
end

function LWTrainDataManager:GetTrainPara(index)
  local meta = LocalController:instance():getLine(TableName.LW_Train_Para, index)
  return meta and meta.val
end

function LWTrainDataManager:TryGetTrainList(isRefresh)
  if not isRefresh then
    local lastTime = CommonUtil.PlayerPrefsGetLong("REFRESH_TRAIN_LIST_TIME", 0)
    local todayZero = UITimeManager:GetInstance():TodayZero()
    isRefresh = lastTime < todayZero
  end
  SFSNetwork.SendMessage(MsgDefines.GetTrainList, isRefresh)
  if isRefresh then
    local now = UITimeManager:GetInstance():GetServerTime()
    CommonUtil.PlayerPrefsSetLong("REFRESH_TRAIN_LIST_TIME", now)
  end
end

function LWTrainDataManager:OnTrainListGet(msg)
  local ls = msg.ls
  if ls then
    for i = 1, #self.enemyTrucks do
      self.enemyTrucks[i]:Destroy()
    end
    self.enemyTrucks = {}
    for i = 1, #ls do
      self.enemyTrucks[i] = TrainData.New(ls[i])
    end
  end
  local allianceTrainList = msg.allianceTrainList
  if allianceTrainList then
    for i = 1, #self.enemyTrains do
      self.enemyTrains[i]:Destroy()
    end
    self.enemyTrains = {}
    for i = 1, #allianceTrainList do
      self.enemyTrains[i] = TrainData.New(allianceTrainList[i])
    end
  end
  EventManager:GetInstance():Broadcast(EventId.RefreshTrainListData, TrainTab.Enemy)
end

function LWTrainDataManager:GetAllyTrainList()
end

function LWTrainDataManager:GetEnemyTrain()
  return self.enemyTrains[1]
end

function LWTrainDataManager:GetEnemyTruckList()
  return self.enemyTrucks
end

function LWTrainDataManager:GetProbabilityDataList()
  if self.probabilityDataList == nil then
    self.probabilityDataList = {}
    local dropInfoDetail = self:GetTrainPara(49)
    local dataIndex = 0
    local dropList = string.split(dropInfoDetail, ",")
    for _, v in ipairs(dropList) do
      dataIndex = dataIndex + 1
      local topIndex = dataIndex
      self.probabilityDataList[topIndex] = {
        type = ITEM_TYPE.TOP
      }
      local dropGroup = string.split(v, "|")
      local groupItemCount = #dropGroup
      local groupSplitCount = Mathf.Ceil(groupItemCount / 5)
      for j = 1, groupSplitCount do
        dataIndex = dataIndex + 1
        local midIndex = dataIndex
        self.probabilityDataList[midIndex] = {
          type = ITEM_TYPE.MIDDLE
        }
        self.probabilityDataList[midIndex].data = {}
        for t = 1, 5 do
          local itemIndex = (j - 1) * 5 + t
          if groupItemCount < itemIndex then
            break
          end
          local groupItem = dropGroup[itemIndex]
          local dropItem = string.split(groupItem, ";")
          local count = #dropItem
          if count == 5 then
            self.probabilityDataList[topIndex].name = Localization:GetString(dropItem[1])
            local type = tonumber(dropItem[2])
            local id = tonumber(dropItem[3])
            local num = tonumber(dropItem[4])
            local rate = tonumber(dropItem[5])
            rate = rate * 100
            table.insert(self.probabilityDataList[midIndex].data, {
              type = type,
              id = id,
              num = num,
              rate = rate
            })
          elseif count == 4 then
            local type = tonumber(dropItem[1])
            local id = tonumber(dropItem[2])
            local num = tonumber(dropItem[3])
            local rate = tonumber(dropItem[4])
            rate = rate * 100
            table.insert(self.probabilityDataList[midIndex].data, {
              type = type,
              id = id,
              num = num,
              rate = rate
            })
          end
        end
      end
      dataIndex = dataIndex + 1
      local bottomIndex = dataIndex
      self.probabilityDataList[bottomIndex] = {
        type = ITEM_TYPE.BOTTOM
      }
    end
  end
  return self.probabilityDataList
end

function LWTrainDataManager:IsTrainRobQuickFuncOpen()
  if GMUtils.GetBool(GMConst.TruckQuickRobFuncOpen) then
    return true
  end
  local isOpen = LuaEntry.DataConfig:CheckSwitch("truck_quick_plunder_switch")
  if not isOpen then
    return false
  end
  return FunctionSeasonUtil.IsFuncOpen(FunctionSeasonUtil.FuncType.TrunkQuickAttack)
end

return LWTrainDataManager
