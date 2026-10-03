local PveDropRewardInfoManager = BaseClass("PveDropRewardInfoManager")
local PveDropRewardInfo = require("DataCenter.PveDropRewardInfoManager.PveDropRewardInfo")

function PveDropRewardInfoManager:__init()
  self.dropReward = {}
end

function PveDropRewardInfoManager:__delete()
  self.dropReward = {}
end

function PveDropRewardInfoManager:Startup()
end

function PveDropRewardInfoManager:DropRewardHandle(message)
  if message.dropItems ~= nil then
    for k, v in pairs(message.dropItems) do
      self:AddOneDropRewardInfo(v)
    end
  end
end

function PveDropRewardInfoManager:AddOneDropRewardInfo(message, noSendEvent)
  local uuid = message.uuid
  if self.dropReward[uuid] == nil then
    self.dropReward[uuid] = PveDropRewardInfo.New()
  end
  self.dropReward[uuid]:UpdateData(message)
  if not noSendEvent then
    EventManager:GetInstance():Broadcast(EventId.PveDropRewardAdd, uuid)
  end
end

function PveDropRewardInfoManager:RemoveOneDropRewardInfo(uuid)
  if self.dropReward[uuid] ~= nil then
    self.dropReward[uuid] = nil
  end
  EventManager:GetInstance():Broadcast(EventId.PveDropRewardRemove, uuid)
end

function PveDropRewardInfoManager:SendReceiveDropItem(param)
  SFSNetwork.SendMessage(MsgDefines.ReceivePveTriggerDropItem, param)
end

function PveDropRewardInfoManager:ReceivePveTriggerDropItemHandle(message)
  if message.errorCode == nil then
    if message.uuid ~= nil then
      self:RemoveOneDropRewardInfo(message.uuid)
    end
  else
    UIUtil.ShowTipsId(message.errorCode)
  end
end

function PveDropRewardInfoManager:GetDropRewardInfoByUuid(uuid)
  return self.dropReward[uuid]
end

function PveDropRewardInfoManager:GetAllDropRewardInfo()
  return self.dropReward
end

function PveDropRewardInfoManager:GetDropRewardInfoByPosXY(x, y)
  for k, v in pairs(self.dropReward) do
    if v.x == x and v.y == y then
      return v
    end
  end
end

return PveDropRewardInfoManager
