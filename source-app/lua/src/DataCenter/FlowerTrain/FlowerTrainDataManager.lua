local FlowerTrainDataManager = BaseClass("FlowerTrainDataManager")
local ActivityPartynewDropshowTemplate = require("DataCenter/ActBanquetAttackMonster/ActivityPartynewDropshowTemplate")
local Localization = CS.GameEntry.Localization
local MarchFlowerTrainGroupData = require("DataCenter.FlowerTrain.Data.MarchFlowerTrainGroupData")
local BaseSingleFlowerTrainData = require("DataCenter.FlowerTrain.Data.BaseSingleFlowerTrainData")

function FlowerTrainDataManager:__init()
  self.flowerTrainMetaDic = {}
  self.flowerTrainParaMetaDic = {}
  self.flowerTrainConfigMetaDic = {}
  self.flowerTrainDisplayMetaDic = {}
  self.flowerTrainGroupDataDic = {}
  self.itemDropProbCfgDic = nil
  self.interactiveRecordDataDic = {}
  self.interactiveRecordExpireTime = nil
  self.worldBoxShowMetaDic = {}
  self.playerSelfFlowerTrainDic = {}
  self.lastClaimLvBoxTime = nil
end

function FlowerTrainDataManager:__delete()
  self.flowerTrainMetaDic = nil
  self.flowerTrainParaMetaDic = nil
  self.flowerTrainConfigMetaDic = nil
  self.flowerTrainDisplayMetaDic = nil
  self.flowerTrainGroupDataDic = nil
  self.itemDropProbCfgDic = nil
  self.interactiveRecordDataDic = nil
  self.interactiveRecordExpireTime = nil
  self.worldBoxShowMetaDic = nil
  self.playerSelfFlowerTrainDic = nil
  self.lastClaimLvBoxTime = nil
end

function FlowerTrainDataManager:InitData(msg)
  if msg.flowerTrainArr then
    self:UpdateSelfAllFlowerTrainData(msg.flowerTrainArr)
  end
  if msg.flower_train_day_times then
    self:UpdateInteractionNumData(msg)
  end
end

function FlowerTrainDataManager:UpdateFlowerTrainData(march)
  local marchUuid = march.uuid
  local flowerTrainData = self:GetFlowerTrainGroupDataByMarchUuid(marchUuid)
  if not flowerTrainData then
    flowerTrainData = MarchFlowerTrainGroupData.New()
    self.flowerTrainGroupDataDic[marchUuid] = flowerTrainData
  end
  flowerTrainData:UpdateData(march)
end

function FlowerTrainDataManager:GetFlowerTrainGroupDataByMarchUuid(uuid)
  if not self.flowerTrainGroupDataDic then
    self.flowerTrainGroupDataDic = {}
  end
  return self.flowerTrainGroupDataDic[uuid]
end

function FlowerTrainDataManager:GetFlowerTrainLvMeta(lvMetaId)
  if not self.flowerTrainMetaDic then
    self.flowerTrainMetaDic = {}
  end
  if self.flowerTrainMetaDic[lvMetaId] then
    return self.flowerTrainMetaDic[lvMetaId]
  end
  local meta = LocalController:instance():getLine(TableName.Flower_Train_Level, lvMetaId)
  if not meta then
    Logger.LogError("FlowerTrainDataManager:GetFlowerTrainMeta meta is nil, lvMetaId: " .. lvMetaId)
    return nil
  end
  self.flowerTrainMetaDic[lvMetaId] = meta
  return meta
end

function FlowerTrainDataManager:GetFlowerTrainParaMeta(paraMetaId)
  if not paraMetaId then
    return nil
  end
  if not self.flowerTrainParaMetaDic then
    self.flowerTrainParaMetaDic = {}
  end
  if self.flowerTrainParaMetaDic[paraMetaId] then
    return self.flowerTrainParaMetaDic[paraMetaId]
  end
  local meta = LocalController:instance():getLine(TableName.Flower_Train_Para, paraMetaId)
  if not meta then
    Logger.LogError("FlowerTrainDataManager:GetFlowerTrainMeta meta is nil, paraMetaId: " .. paraMetaId)
    return nil
  end
  self.flowerTrainParaMetaDic[paraMetaId] = meta
  return meta
end

function FlowerTrainDataManager:GetFlowerTrainConfigMeta(configMetaId)
  if not self.flowerTrainConfigMetaDic then
    self.flowerTrainConfigMetaDic = {}
  end
  if self.flowerTrainConfigMetaDic[configMetaId] then
    return self.flowerTrainConfigMetaDic[configMetaId]
  end
  local meta = LocalController:instance():getLine(TableName.Flower_Train_Config, configMetaId)
  if not meta then
    Logger.LogError("FlowerTrainDataManager:GetFlowerTrainMeta meta is nil, configMetaId: " .. configMetaId)
    return nil
  end
  self.flowerTrainConfigMetaDic[configMetaId] = meta
  return meta
end

function FlowerTrainDataManager:GetFlowerTrainDisplayMeta(displayMetaId)
  if not self.flowerTrainDisplayMetaDic then
    self.flowerTrainDisplayMetaDic = {}
  end
  if self.flowerTrainDisplayMetaDic[displayMetaId] then
    return self.flowerTrainDisplayMetaDic[displayMetaId]
  end
  local meta = LocalController:instance():getLine(TableName.Flower_Train_Display, displayMetaId)
  if not meta then
    Logger.LogError("FlowerTrainDataManager:GetFlowerTrainMeta meta is nil, displayMetaId: " .. displayMetaId)
    return nil
  end
  self.flowerTrainDisplayMetaDic[displayMetaId] = meta
  return meta
end

function FlowerTrainDataManager:GetItemDropProbCfgByDropShowId(dropShowType)
  if self.itemDropProbCfgDic ~= nil and table.count(self.itemDropProbCfgDic) > 0 then
    return self.itemDropProbCfgDic
  end
  if dropShowType == nil or dropShowType == 0 then
    Logger.LogError("GetItemDropProbCfgByDropShowId \229\186\148\228\188\160\229\133\165\230\173\163\231\161\174\231\154\132 Activity_PartyNew_DropShow id")
    return
  end
  self.itemDropProbCfgDic = {}
  LocalController:instance():visitTable(TableName.Activity_PartyNew_DropShow, function(id, lineData)
    if lineData ~= nil then
      local group_id = lineData:getIntValue("group_id")
      local type_id = lineData:getIntValue("type")
      if group_id == dropShowType and (type_id == 6 or type_id == 7) then
        local activityDropInfoTemplate = ActivityPartynewDropshowTemplate.New()
        activityDropInfoTemplate:UpdateData(lineData)
        if lineData.id ~= nil then
          local key = type_id * 100 + lineData.treasure_id
          if self.itemDropProbCfgDic[key] == nil then
            self.itemDropProbCfgDic[key] = {}
          end
          table.insert(self.itemDropProbCfgDic[key], activityDropInfoTemplate)
        end
      end
    end
  end)
  for _, v in pairs(self.itemDropProbCfgDic) do
    table.sort(v, function(a, b)
      return a.id < b.id
    end)
  end
  return self.itemDropProbCfgDic
end

function FlowerTrainDataManager:UpdateInteractionNumData(msg)
  if not msg then
    Logger.LogError("FlowerTrainDataManager:UpdateInteractionNumData msg is nil")
    return
  end
  if msg.flower_train_day_times then
    for goodsId, v in pairs(msg.flower_train_day_times) do
      local interactiveServerDataDic = {}
      if v.praise then
        interactiveServerDataDic[FlowerTrainInteractiveType.Like] = v.praise
      end
      if v.cheer then
        interactiveServerDataDic[FlowerTrainInteractiveType.Cheer] = v.cheer
      end
      if v.receiveLvBox then
        interactiveServerDataDic[FlowerTrainInteractiveType.ClaimLvLvBox] = v.receiveLvBox
      end
      for type, count in pairs(interactiveServerDataDic) do
        local recordData = self.interactiveRecordDataDic[type]
        if not recordData then
          recordData = {}
          self.interactiveRecordDataDic[type] = recordData
        end
        recordData[toInt(goodsId)] = count
      end
    end
  end
  self.interactiveRecordExpireTime = msg.flower_train_day_times_expire or nil
end

function FlowerTrainDataManager:GetCurInteractionCount(goodsId, type)
  if not goodsId then
    Logger.LogError("FlowerTrainDataManager:GetCurInteractionCount goodsId is nil")
    return 0
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.interactiveRecordExpireTime and now > self.interactiveRecordExpireTime then
    self.interactiveRecordDataDic = {}
    self.interactiveRecordExpireTime = nil
    return 0
  end
  if not self.interactiveRecordDataDic or not self.interactiveRecordDataDic[type] then
    return 0
  end
  local recordData = self.interactiveRecordDataDic[type]
  if not recordData then
    return 0
  end
  local count = recordData[tonumber(goodsId)]
  return count or 0
end

function FlowerTrainDataManager:GetWorldBoxRewardShowMeta(boxShowParaId)
  local meta = self.worldBoxShowMetaDic[boxShowParaId]
  if not meta then
    meta = LocalController:instance():getLine(TableName.Flower_Train_Drop_Box, boxShowParaId)
    if not meta then
      Logger.LogError("FlowerTrainDataManager:GetWorldBoxRewardShowMeta meta is nil, boxShowParaId: " .. boxShowParaId)
      return nil
    end
    self.worldBoxShowMetaDic[boxShowParaId] = meta
  end
  return meta
end

function FlowerTrainDataManager:UpdateSelfAllFlowerTrainData(dataList)
  self.playerSelfFlowerTrainDic = {}
  if not dataList then
    return
  end
  for _, data in ipairs(dataList) do
    self:UpdateSelfFlowerTrainData(data)
  end
end

function FlowerTrainDataManager:GetPlayerSelfFlowerTrainData(trainUuid)
  if not self.playerSelfFlowerTrainDic or not table.containsKey(self.playerSelfFlowerTrainDic, trainUuid) then
    Logger.LogError("FlowerTrainDataManager:GetPlayerSelfFlowerTrainData playerSelfFlowerTrainDic is nil or not contains trainUuid: " .. trainUuid)
    return nil
  end
  return self.playerSelfFlowerTrainDic[trainUuid]
end

function FlowerTrainDataManager:UpdateSelfFlowerTrainData(data)
  if not data then
    return
  end
  local uuid = data.uuid
  local playerSingleFlowerTrainData = self.playerSelfFlowerTrainDic[uuid]
  if not playerSingleFlowerTrainData then
    playerSingleFlowerTrainData = BaseSingleFlowerTrainData.New()
    self.playerSelfFlowerTrainDic[uuid] = playerSingleFlowerTrainData
  end
  playerSingleFlowerTrainData:UpdateData(data)
end

function FlowerTrainDataManager:RemoveSelfFlowerTrainData(flowerTrainUuid)
  if not self.playerSelfFlowerTrainDic then
    return
  end
  if not table.containsKey(self.playerSelfFlowerTrainDic, flowerTrainUuid) then
    return
  end
  self.playerSelfFlowerTrainDic[flowerTrainUuid] = nil
end

function FlowerTrainDataManager:GetPlayerAllFlowerTrainDataList()
  local ret = {}
  if self.playerSelfFlowerTrainDic then
    for _, v in pairs(self.playerSelfFlowerTrainDic) do
      table.insert(ret, v)
    end
  end
  return ret
end

function FlowerTrainDataManager:GetPlayerAllArrivedFlowerTrainDataList(isSort)
  local ret = {}
  if self.playerSelfFlowerTrainDic then
    for _, v in pairs(self.playerSelfFlowerTrainDic) do
      if v:GetIsArrived() then
        table.insert(ret, v)
      end
    end
  end
  if isSort then
    table.sort(ret, function(a, b)
      local isArrivedA = a.isArrived and 1 or 0
      local isArrivedB = b.isArrived and 1 or 0
      return isArrivedA > isArrivedB
    end)
  end
  return ret
end

function FlowerTrainDataManager:GetPlayerAllRunningFlowerTrainDataList()
  local ret = {}
  if self.playerSelfFlowerTrainDic then
    for _, v in pairs(self.playerSelfFlowerTrainDic) do
      if not v:GetIsArrived() then
        table.insert(ret, v)
      end
    end
  end
  return ret
end

function FlowerTrainDataManager:OnClaimLvBoxReward()
  local now = UITimeManager:GetInstance():GetServerTime()
  self.lastClaimLvBoxTime = now
end

function FlowerTrainDataManager:GetLastClaimBoxRewardTime()
  return self.lastClaimLvBoxTime or 0
end

return FlowerTrainDataManager
