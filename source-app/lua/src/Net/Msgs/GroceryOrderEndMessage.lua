local GroceryOrderEndMessage = BaseClass("GroceryOrderEndMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutLong("uuid", param.uuid)
  end
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  DataCenter.RewardManager:AddRewardsAndRes(message)
  if message.reward ~= nil then
    DataCenter.RewardManager:ShowCommonReward(message)
  end
  DataCenter.GroceryStoreOrderDataManager:GroceryStoreOrderEndHandle(message)
end

GroceryOrderEndMessage.OnCreate = OnCreate
GroceryOrderEndMessage.HandleMessage = HandleMessage
return GroceryOrderEndMessage
