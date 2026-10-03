local PushHeroDispatchMissionStealMessage = BaseClass("PushHeroDispatchMissionStealMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushHeroDispatchMissionStealMessage:OnCreate()
  base.OnCreate(self)
end

function PushHeroDispatchMissionStealMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActDispatchTaskDataManager:PushHeroDispatchMissionStealHandler(message)
  end
end

return PushHeroDispatchMissionStealMessage
