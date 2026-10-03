local GiftDetailShowDataManager = BaseClass("GiftDetailShowDataManager")
local GiftDetailShowData = require("DataCenter.GiftSystem.GiftDetailShowData")
local Localization = CS.GameEntry.Localization
local ExpiredTime = 30000
local rapidjson = require("rapidjson")

local function __init(self)
  self.saveData = {}
  self.giftModelUnlockDict = {}
end

local function __delete(self)
  self.saveData = nil
  self.giftModelUnlockDict = nil
end

function GiftDetailShowDataManager:InitData(msg)
  if msg.gift_unlock then
    for _, v in pairs(msg.gift_unlock) do
      local gift_id = v.gift_id
      local unlock = v.unlock
      if self.giftModelUnlockDict[gift_id] == nil then
        self.giftModelUnlockDict[gift_id] = {}
      end
      for k, v in pairs(unlock) do
        self.giftModelUnlockDict[gift_id][v] = true
      end
    end
  end
end

function GiftDetailShowDataManager:SetGiftModelUnlockData(msg)
  local gift_id = msg.gift_id
  local unlock = msg.unlock
  if self.giftModelUnlockDict[gift_id] == nil then
    self.giftModelUnlockDict[gift_id] = {}
  end
  self.giftModelUnlockDict[gift_id][unlock] = true
end

function GiftDetailShowDataManager:CheckGiftNumIsUnlock(giftId, num)
  if self.giftModelUnlockDict[giftId] and self.giftModelUnlockDict[giftId][num] then
    return true
  end
  return false
end

function GiftDetailShowDataManager:CheckDataNeedUpdate(playerUuid, itemId)
  local isNeedUpdate = true
  if self.saveData[playerUuid] and self.saveData[playerUuid][itemId] then
    local showData = self.saveData[playerUuid][itemId]
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if showData.isDirty == false and curTime - showData.updateTime < ExpiredTime then
      isNeedUpdate = false
    end
  end
  return isNeedUpdate
end

function GiftDetailShowDataManager:GetDataWithoutCheckExpired(playerUuid, itemId)
  local data
  if self.saveData[playerUuid] and self.saveData[playerUuid][itemId] then
    data = self.saveData[playerUuid][itemId].data
  end
  return data
end

function GiftDetailShowDataManager:SetDataDirty(playerUuid, itemId)
  if self.saveData[playerUuid] and self.saveData[playerUuid][itemId] then
    self.saveData[playerUuid][itemId].isDirty = true
  end
end

function GiftDetailShowDataManager:SetMsgData(msgData)
  local targetUid = msgData.targetUid
  if targetUid == nil then
    targetUid = LuaEntry.Player.uid
  end
  self:SetData(targetUid, msgData.itemId, msgData)
end

function GiftDetailShowDataManager:SetData(playerUuid, itemId, data)
  if self.saveData[playerUuid] == nil then
    self.saveData[playerUuid] = {}
  end
  if self.saveData[playerUuid][itemId] == nil then
    self.saveData[playerUuid][itemId] = {
      data = GiftDetailShowData.New(),
      updateTime = 0,
      isDirty = false
    }
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local showData = self.saveData[playerUuid][itemId]
  showData.data:UpdateData(data)
  showData.updateTime = curTime
  showData.isDirty = false
end

function GiftDetailShowDataManager:SetMsgChangeData(msgData)
  local targetUid = msgData.targetUid
  if targetUid == nil then
    targetUid = LuaEntry.Player.uid
  end
  self:SetChangeData(targetUid, msgData.params.itemId, msgData)
end

function GiftDetailShowDataManager:SetChangeData(playerUuid, itemId, data)
  if self.saveData[playerUuid] == nil then
    return
  end
  if self.saveData[playerUuid][itemId] == nil then
    return
  end
  local showData = self.saveData[playerUuid][itemId]
  showData.data:UpdateChangeData(data)
  if data.params and data.params.count and playerUuid == LuaEntry.Player.uid then
    local info = DataCenter.PlayerInfoDataManager.selfPlayerData
    local goods = DataCenter.GiftSystemManager:GetGiftGoods(itemId)
    if info and goods then
      local getItemId = goods.convert_item
      local unlockTab = {}
      if not string.IsNullOrEmpty(info.unlockShow) then
        unlockTab = rapidjson.decode(info.unlockShow)
      end
      unlockTab[tostring(getItemId)] = tostring(data.params.count)
      info.unlockShow = rapidjson.encode(unlockTab)
      for k, v in pairs(info.giftDataList) do
        if v.itemId == getItemId then
          v.unlockNum = data.params.count
        end
      end
    end
  end
end

function GiftDetailShowDataManager:OnGetSendGiftMsg(msg)
  local targetUid
  if msg.otherPlayerInfo and msg.otherPlayerInfo.uid then
    targetUid = msg.otherPlayerInfo.uid
  end
  local itemId = msg.itemId
  if targetUid and itemId then
    self:TryChangePlayerInfoGiftShowData(targetUid, itemId, msg.num)
    if self.saveData[targetUid] and self.saveData[targetUid][itemId] then
      self:SetDataDirty(targetUid, itemId)
      EventManager:GetInstance():Broadcast(EventId.OnGiftDetailDataDirty, {targetUid = targetUid, itemId = itemId})
    end
  end
end

function GiftDetailShowDataManager:TryChangePlayerInfoGiftShowData(targetUid, itemId, itemNum)
  if targetUid == nil or targetUid == LuaEntry.Player.uid then
    return
  end
  if itemId == nil or itemNum == nil then
    return
  end
  local userInfo = DataCenter.PlayerInfoDataManager:GetPlayerDataByUid(targetUid, true)
  if userInfo and userInfo.giftDataList then
    local isFind = false
    for i = 1, #userInfo.giftDataList do
      local data = userInfo.giftDataList[i]
      local curItemId = data.itemId
      local curItemNum = data.count
      local originId = DataCenter.GiftSystemManager:GetOriginId(curItemId)
      if itemId == originId then
        isFind = true
        data.count = curItemNum + itemNum
        break
      end
    end
    if isFind then
      EventManager:GetInstance():Broadcast(EventId.OnOtherPlayerGiftShowDataChange, userInfo)
    end
  end
end

GiftDetailShowDataManager.__init = __init
GiftDetailShowDataManager.__delete = __delete
return GiftDetailShowDataManager
