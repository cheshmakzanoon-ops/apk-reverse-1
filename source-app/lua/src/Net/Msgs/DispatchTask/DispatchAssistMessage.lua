local DispatchAssistMessage = BaseClass("DispatchAssistMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function DispatchAssistMessage:OnCreate(uuid, targetServer)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
  self.sfsObj:PutInt("targetServer", targetServer)
end

function DispatchAssistMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if message.reward then
      message.fromDispatchAssistMessage = true
      DataCenter.RewardManager:AddRewardsAndRes(message)
      DataCenter.ActDispatchTaskDataManager:ShowReward(message)
    end
    DataCenter.ActDispatchTaskDataManager:UpdateTodayNum(message)
    if message.uuid then
      DataCenter.ActDispatchTaskDataManager:DeleteAllianceTasks({
        message.uuid
      })
    end
  end
end

return DispatchAssistMessage
