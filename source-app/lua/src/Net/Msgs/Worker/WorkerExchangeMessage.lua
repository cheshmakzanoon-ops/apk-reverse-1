local WorkerExchangeMessage = BaseClass("WorkerExchangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, itemId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("itemId", tostring(itemId))
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local reward = message.reward
    if reward and 0 < #reward and reward[1].type == RewardType.WORKER then
      local workerId = reward[1].value.workerId
      local workerUid = reward[1].value.workerUid
      local data = {workerId = workerId, workerUid = workerUid}
      EventManager:GetInstance():Broadcast(EventId.WorkerFragUnlock, data)
    end
  end
end

WorkerExchangeMessage.OnCreate = OnCreate
WorkerExchangeMessage.HandleMessage = HandleMessage
return WorkerExchangeMessage
