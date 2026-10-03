local PushGhostReconStealMessage = BaseClass("PushGhostReconStealMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushGhostReconStealMessage:OnCreate()
  base.OnCreate(self)
end

function PushGhostReconStealMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActDispatchTaskDataManager:PushHeroDispatchMissionStealHandler(message)
  end
end

return PushGhostReconStealMessage
