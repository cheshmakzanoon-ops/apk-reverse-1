local DispatchStealMessage = BaseClass("DispatchStealMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function DispatchStealMessage:OnCreate(uuid, targetServer)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("targetServer", targetServer)
end

function DispatchStealMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if message.reward then
      message.fromDispatchStealMessage = true
      DataCenter.RewardManager:AddRewardsAndRes(message)
      DataCenter.ActDispatchTaskDataManager:ShowReward(message)
    end
    DataCenter.ActDispatchTaskDataManager:UpdateTodayNum(message)
    DataCenter.ActDispatchTaskDataManager:UpdateSteal(message.uuid)
  end
end

return DispatchStealMessage
