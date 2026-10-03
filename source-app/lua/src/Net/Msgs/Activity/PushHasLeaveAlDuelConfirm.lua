local PushHasLeaveAlDuelConfirm = BaseClass("PushHasLeaveAlDuelConfirm", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LeagueMatchManager:PushHasLeaveAlDuelConfirm(t)
  end
end

PushHasLeaveAlDuelConfirm.OnCreate = OnCreate
PushHasLeaveAlDuelConfirm.HandleMessage = HandleMessage
return PushHasLeaveAlDuelConfirm
