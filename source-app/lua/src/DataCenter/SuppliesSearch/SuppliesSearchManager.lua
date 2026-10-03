local SuppliesSearchManager = BaseClass("SuppliesSearchManager", CEventable)
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting

function SuppliesSearchManager:GetSuppliesSearchInfoByType(nType, uuid)
  local tInfo
  if nType == SuppliesSearchType.Detect then
    local tDetectData = DataCenter.RadarCenterDataManager:GetDetectEventInfo(uuid)
    tInfo = tDetectData.suppliesSearchInfo
  else
    local tBuildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
    tInfo = tBuildData.suppliesSearchInfo
  end
  return tInfo
end

function SuppliesSearchManager:OpenSuppliesSearchWindow(type, uuid)
  local tParam = {}
  tParam.type = type
  tParam.uuid = uuid
  tParam.suppliesSearchInfo = self:GetSuppliesSearchInfoByType(type, uuid)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISuppliesSearch, {anim = true}, tParam)
end

function SuppliesSearchManager:DoSuppliesSearch(nType, uuid)
  if nType == SuppliesSearchType.Detect then
    SFSNetwork.SendMessage(MsgDefines.DetectEventSuppliesSearchNext, uuid)
  else
    SFSNetwork.SendMessage(MsgDefines.BuildingSuppliesSearchNext, uuid)
  end
end

function SuppliesSearchManager:GetReward(nType, uuid)
  if nType == SuppliesSearchType.Detect then
    SFSNetwork.SendMessage(MsgDefines.DetectEventGetSuppliesSearchReward, uuid)
  else
    SFSNetwork.SendMessage(MsgDefines.BuildingGetSuppliesSearchReward, uuid)
  end
end

function SuppliesSearchManager:GetRewardShow(self, rewardId)
  local result = {}
  local line = LocalController:instance():getLine(TableName.RewardConfig, rewardId)
  if line == nil then
    return result
  end
  local itemValues = line:getValue("item") or ""
  local numValues = line:getValue("num") or ""
  if not string.IsNullOrEmpty(itemValues) and not string.IsNullOrEmpty(numValues) then
    local ids = string.split(itemValues, "|")
    local nums = string.split(numValues, "|")
    if ids ~= nil and 0 < #ids then
      for i, id in pairs(ids) do
        local oneData = {}
        oneData.itemId = id
        oneData.count = nums[i] or 0
        oneData.rewardType = RewardType.GOODS
        table.insert(result, oneData)
      end
    end
  end
  return result
end

function SuppliesSearchManager:UpdateSuppliesSearchInfo(nType, message)
  if not message then
    return
  end
  if nType == SuppliesSearchType.Detect then
    local uuid = message.eventUuid
    local tDetectData = DataCenter.RadarCenterDataManager:GetDetectEventInfo(uuid)
    tDetectData.suppliesSearchInfo = message.suppliesSearchInfo
  else
    local uuid = message.buildingUuid
    local tBuildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
    tBuildData.suppliesSearchInfo = message.suppliesSearchInfo
  end
  EventManager:GetInstance():Broadcast(EventId.OnGetSuppliesSearchResult, message)
end

function SuppliesSearchManager:Test()
  self:OpenSuppliesSearchWindow(SuppliesSearchType.Detect, "1234567890")
end

return SuppliesSearchManager
