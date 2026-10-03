local MarchFlowerTrainGroupData = BaseClass("MarchFlowerTrainGroupData")
local Localization = CS.GameEntry.Localization
local MarchSingleFlowerTrainData = require("DataCenter.FlowerTrain.Data.MarchSingleFlowerTrainData")

function MarchFlowerTrainGroupData:__init()
  self.marchUuid = nil
  self.marchType = nil
  self.singleTrainDataList = {}
  self.singleTrainDataDic = {}
  self.historyStationList = {}
  self.nextNextStation = nil
end

function MarchFlowerTrainGroupData:__delete()
  self.marchUuid = nil
  self.marchType = nil
  self.singleTrainDataList = nil
  self.singleTrainDataDic = nil
  self.historyStationList = nil
  self.nextNextStation = nil
end

function MarchFlowerTrainGroupData:UpdateData(marchInfo)
  self.marchInfo = marchInfo
  self.marchUuid = marchInfo.uuid
  self.marchType = marchInfo:GetMarchType()
  local flowerTrainData = marchInfo.flowerTrain
  local flowerTrainServerDataList = flowerTrainData.flowerTrainDataList
  if not flowerTrainServerDataList then
    Logger.LogError("MarchFlowerTrainGroupData:UpdateData flowerTrainServerDataList is nil")
    return
  end
  for i = 0, flowerTrainServerDataList.Count - 1 do
    local index = i + 1
    local serverData = flowerTrainServerDataList[i]
    local singleTrainUuid = serverData.uuid
    local singleTrainData = self:GetSingleTrainData(singleTrainUuid)
    if not singleTrainData then
      self:AddOneSingleTrainData(index, serverData, marchInfo)
    else
      singleTrainData:UpdateData(index, serverData, marchInfo)
    end
  end
  self.historyStationList = {}
  for i = 0, flowerTrainData.historyStationList.Count - 1 do
    table.insert(self.historyStationList, flowerTrainData.historyStationList[i])
  end
  self.nextNextStation = flowerTrainData.preStation
end

function MarchFlowerTrainGroupData:AddOneSingleTrainData(index, serverData, marchInfo)
  local singleTrainData = MarchSingleFlowerTrainData.New()
  singleTrainData:UpdateData(index, serverData, marchInfo)
  self.singleTrainDataDic[serverData.uuid] = singleTrainData
  table.insert(self.singleTrainDataList, singleTrainData)
end

function MarchFlowerTrainGroupData:RemoveSingleTrainData(serverData)
end

function MarchFlowerTrainGroupData:GetSingleTrainData(singleTrainUid)
  return self.singleTrainDataDic[singleTrainUid]
end

function MarchFlowerTrainGroupData:GetAllSingleTrainDataList()
  return self.singleTrainDataList or {}
end

function MarchFlowerTrainGroupData:GetFirstSingleTrainData()
  if not self.singleTrainDataList or #self.singleTrainDataList < 1 then
    Logger.LogError("MarchFlowerTrainGroupData:GetFirstSingleTrainData singleTrainDataList is nil or empty")
    return nil
  end
  return self.singleTrainDataList[1]
end

function MarchFlowerTrainGroupData:GetSingleTrainDataByIndex(index)
  return self.singleTrainDataList[index]
end

function MarchFlowerTrainGroupData:GetMarchUuid()
  return self.marchUuid
end

return MarchFlowerTrainGroupData
