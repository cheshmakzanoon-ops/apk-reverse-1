local PushWorldFlagUpdateMessage = BaseClass("PushWorldFlagUpdateMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.WarFlagDataManager:PushOneWarFlag(t)
  end
end

PushWorldFlagUpdateMessage.HandleMessage = HandleMessage
return PushWorldFlagUpdateMessage
