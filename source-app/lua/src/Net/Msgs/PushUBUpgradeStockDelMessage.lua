local PushUBUpgradeStockDelMessage = BaseClass("PushUBUpgradeStockDelMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushUBUpgradeStockDelMessage:OnCreate()
  base.OnCreate(self)
end

function PushUBUpgradeStockDelMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  DataCenter.BuildUpgradeStockManager:PushUBUpgradeStockDelHandle(message)
end

return PushUBUpgradeStockDelMessage
