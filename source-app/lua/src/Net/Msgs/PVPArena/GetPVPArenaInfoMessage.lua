local GetPVPArenaInfoMessage = BaseClass("GetPVPArenaInfoMessage", SFSBaseMessage)
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
    DataCenter.NewGaleArenaManager:OnGetArenaInfo(t.galeArenaInfo)
  end
end

GetPVPArenaInfoMessage.OnCreate = OnCreate
GetPVPArenaInfoMessage.HandleMessage = HandleMessage
return GetPVPArenaInfoMessage
