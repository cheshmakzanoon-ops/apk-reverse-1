local ItemExchangeManager = BaseClass("ItemExchangeManager")
ItemExchangeManager.itemExchangeTemplateDict = {}

function ItemExchangeManager:__init()
  self.itemExchangeServerData = {}
  self.itemExchangeTemplateDict = {}
  self.showExpireMinTime = nil
  self:CollectAllExchangeTemplate()
end

function ItemExchangeManager:__delete()
  self.itemExchangeServerData = nil
  self.itemExchangeTemplateDict = nil
  self.showExpireMinTime = nil
end

function ItemExchangeManager:CollectAllExchangeTemplate()
  if LocalController:instance():hasTable(TableName.GoodsExchangeTab) then
    LocalController:instance():visitTable(TableName.GoodsExchangeTab, function(id, configData)
      local template = ItemExchangeTemplate.New()
      local initResult = template:InitData(configData)
      if initResult == true then
        self.itemExchangeTemplateDict[id] = template
      end
    end)
  else
    Logger.LogError("--- GoodsExchangeTab not exist")
  end
end

function ItemExchangeManager:GetItemExchangeTemplateByItemId(itemId)
  if self.itemExchangeTemplateDict == nil then
    return nil
  end
  if self.itemExchangeTemplateDict[checknumber(itemId)] == nil then
    return nil
  else
    return self.itemExchangeTemplateDict[checknumber(itemId)]
  end
end

function ItemExchangeManager:SendExchangeItemMsg(itemId, count)
  local template = self:GetItemExchangeTemplateByItemId(checknumber(itemId))
  local isExpiredInItemInfoData = DataCenter.ItemData:CheckItemIsExpiredInOtherParamData(itemId)
  if (template == nil or not template:IsExpiredNow()) and not isExpiredInItemInfoData then
    return
  end
  local userCount = DataCenter.ItemData:GetItemCount(itemId)
  if count > userCount then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ExchangeExpiredItem, itemId, count)
end

function ItemExchangeManager:SetItemExchangeServerData(message)
  local data = message.dataArr
  self.itemExchangeServerData = {}
  if data and 0 < #data then
    for k, v in pairs(data) do
      self.itemExchangeServerData[tonumber(v.id)] = {
        expireTime = v.expireTime,
        timeType = v.timeType or 1,
        para = v.para
      }
    end
  end
end

function ItemExchangeManager:GetItemExchangeServerDataById(id)
  local exchangeServerData
  if self.itemExchangeServerData and self.itemExchangeServerData[id] then
    exchangeServerData = self.itemExchangeServerData[id]
  end
  return exchangeServerData
end

function ItemExchangeManager:IsShowWillExpired(id, ignoreDelay)
  if id == nil then
    return false
  end
  id = tonumber(id)
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(id)
  if template == nil then
    return false
  end
  if template.show_will_expire ~= 1 then
    return false
  end
  local exchangeServerData = self:GetItemExchangeServerDataById(id)
  if exchangeServerData == nil then
    return false
  end
  if self.showExpireMinTime == nil then
    local day = LuaEntry.DataConfig:TryGetNum("gift_show_expire", "k1", 7)
    local ONE_DAY = 86400
    self.showExpireMinTime = day * ONE_DAY
  end
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if ignoreDelay then
    return exchangeServerData.expireTime > 0 and curTime < exchangeServerData.expireTime
  else
    return exchangeServerData.expireTime > 0 and curTime > exchangeServerData.expireTime - self.showExpireMinTime and curTime < exchangeServerData.expireTime
  end
end

function ItemExchangeManager:GetWillExpireTime(id)
  if id == nil then
    return 0
  end
  id = tonumber(id)
  local time = 0
  local exchangeServerData = DataCenter.ItemExchangeManager:GetItemExchangeServerDataById(id)
  if exchangeServerData and exchangeServerData.expireTime then
    time = exchangeServerData.expireTime
  end
  return time
end

return ItemExchangeManager
