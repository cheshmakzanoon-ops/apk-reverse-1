local Get3V3ArenaInfoMessage = BaseClass("Get3V3ArenaInfoMessage", SFSBaseMessage)
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
    DataCenter.LW3V3ArenaManager:OnGetArenaInfo(t)
  end
end

Get3V3ArenaInfoMessage.OnCreate = OnCreate
Get3V3ArenaInfoMessage.HandleMessage = HandleMessage
return Get3V3ArenaInfoMessage
