local PushDragonPlayerNumMessage = BaseClass("PushDragonPlayerNumMessage", SFSBaseMessage)
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
    DataCenter.ActDragonManager:OnHandleBattlePlayerNum(t)
  end
end

PushDragonPlayerNumMessage.OnCreate = OnCreate
PushDragonPlayerNumMessage.HandleMessage = HandleMessage
return PushDragonPlayerNumMessage
