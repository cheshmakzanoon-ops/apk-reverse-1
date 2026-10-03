local LotteryWorkerCardMessage = BaseClass("LotteryWorkerCardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, useFree, isTen, officerId)
  base.OnCreate(self)
  self.sfsObj:PutInt("useFree", useFree)
  self.sfsObj:PutInt("isTen", isTen)
  self.sfsObj:PutInt("officerId", officerId)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    local lang = Localization:GetString(message.errorCode)
    UIUtil.ShowTips(lang or message.errorCode)
    return
  end
  if message.reward ~= nil then
    DataCenter.RewardManager:AddRewardsAndRes(message)
  end
  DataCenter.WorkerLotteryDataManager:UpdateWorkerLotteryData(message)
  EventManager:GetInstance():Broadcast(EventId.WorkericRecruitmentData, message)
end

LotteryWorkerCardMessage.OnCreate = OnCreate
LotteryWorkerCardMessage.HandleMessage = HandleMessage
return LotteryWorkerCardMessage
