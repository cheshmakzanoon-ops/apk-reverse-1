local BuildUpgradeStockManager = BaseClass("BuildUpgradeStockManager")
local BuildUpgradeStockInfo = require("DataCenter.BuildManager.BuildUpgradeStockInfo")

function BuildUpgradeStockManager:__init()
  self.upgradeStocks = {}
end

function BuildUpgradeStockManager:__delete()
  self.upgradeStocks = {}
end

function BuildUpgradeStockManager:InitData(message)
  self.upgradeStocks = {}
  if message.upgradeStocks ~= nil then
    for k, v in ipairs(message.upgradeStocks) do
      self:AddOneUpgradeStock(v)
    end
  end
end

function BuildUpgradeStockManager:AddOneUpgradeStock(message)
  if message ~= nil then
    local id = message.uuid
    local one = self:GetUpgradeStockById(id)
    if one == nil then
      one = BuildUpgradeStockInfo.New()
      one:UpdateInfo(message)
      self.upgradeStocks[id] = one
    else
      one:UpdateInfo(message)
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshBuildUpgradeStock, id)
  end
end

function BuildUpgradeStockManager:RemoveOneUpgradeStock(id)
  self.upgradeStocks[id] = nil
  EventManager:GetInstance():Broadcast(EventId.RefreshBuildUpgradeStock, id)
end

function BuildUpgradeStockManager:GetUpgradeStockById(id)
  return self.upgradeStocks[id]
end

function BuildUpgradeStockManager:Startup()
end

function BuildUpgradeStockManager:PushUBUpgradeStockDelHandle(message)
  if message.uuid ~= nil then
    self:RemoveOneUpgradeStock(message.uuid)
  end
end

function BuildUpgradeStockManager:SendUBStoreUpgrade(param)
  SFSNetwork.SendMessage(MsgDefines.UBStoreUpgrade, param)
end

function BuildUpgradeStockManager:UBStoreUpgradeHandle(message)
  local errCode = message.errorCode
  if errCode == nil then
    local stock = message.stock
    if stock ~= nil then
      self:AddOneUpgradeStock(stock)
    end
    if message.remainGold ~= nil then
      LuaEntry.Player.gold = message.remainGold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    if message.resource ~= nil then
      LuaEntry.Resource:UpdateResource(message.resource)
    end
  else
    UIUtil.ShowTipsId(errCode)
  end
end

return BuildUpgradeStockManager
