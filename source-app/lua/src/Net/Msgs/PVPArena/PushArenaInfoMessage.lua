local PushArenaInfoMessage = BaseClass("PushArenaInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LW3V3ArenaManager:OnGetArenaInfo(t.arena3v3Info)
    DataCenter.LWPVPArenaManager:OnGetArenaInfo(t)
    DataCenter.NewPeakArenaManager:OnGetArenaInfo(t.newArenaInfo)
  end
end

PushArenaInfoMessage.OnCreate = OnCreate
PushArenaInfoMessage.HandleMessage = HandleMessage
return PushArenaInfoMessage
