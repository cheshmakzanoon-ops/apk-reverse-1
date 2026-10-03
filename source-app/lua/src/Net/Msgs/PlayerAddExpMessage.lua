local PlayerAddExpMessage = BaseClass("PlayerAddExpMessage", SFSBaseMessage)
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
    DataCenter.PlayerLevelManager:PlayerAddExp(t)
  end
end

PlayerAddExpMessage.OnCreate = OnCreate
PlayerAddExpMessage.HandleMessage = HandleMessage
return PlayerAddExpMessage
