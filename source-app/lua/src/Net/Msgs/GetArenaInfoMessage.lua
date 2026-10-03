local GetArenaInfoMessage = BaseClass("GetArenaInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("type", type)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ArenaManager:UpdateBaseInfo(t)
  end
end

GetArenaInfoMessage.OnCreate = OnCreate
GetArenaInfoMessage.HandleMessage = HandleMessage
return GetArenaInfoMessage
