local PushFishPondRemovePlayerMessage = BaseClass("PushFishPondRemovePlayerMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushFishPondRemovePlayerMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushFishPondRemovePlayerMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.FishingDataManager:HandleLeaveFishPond()
  end
end

return PushFishPondRemovePlayerMessage
