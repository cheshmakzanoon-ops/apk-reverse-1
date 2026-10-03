local PushUserChestDataChangeMessage = BaseClass("PushUserChestDataChangeMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWSeasonWastelandDataManager:PushWastelandMessage(t)
  end
end

PushUserChestDataChangeMessage.HandleMessage = HandleMessage
return PushUserChestDataChangeMessage
