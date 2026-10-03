local WorkerLotteryInfoMessage = BaseClass("WorkerLotteryInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, officerId)
  base.OnCreate(self)
  self.sfsObj:PutInt("officerId", officerId)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    local lang = Localization:GetString(message.errorCode)
    UIUtil.ShowTips(lang or message.errorCode)
    return
  end
  DataCenter.WorkerLotteryDataManager:UpdateWorkerLotteryData(message)
  EventManager:GetInstance():Broadcast(EventId.WorkerLotteryInfoGet)
end

WorkerLotteryInfoMessage.OnCreate = OnCreate
WorkerLotteryInfoMessage.HandleMessage = HandleMessage
return WorkerLotteryInfoMessage
