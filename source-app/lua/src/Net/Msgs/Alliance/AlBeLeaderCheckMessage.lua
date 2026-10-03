local AlBeLeaderCheckMessage = BaseClass("AlBeLeaderCheckMessage", SFSBaseMessage)
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
  elseif t.res then
    DataCenter.AllianceLeaderManager:UpdateBeLeader(t.res)
  end
end

AlBeLeaderCheckMessage.OnCreate = OnCreate
AlBeLeaderCheckMessage.HandleMessage = HandleMessage
return AlBeLeaderCheckMessage
