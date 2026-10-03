local PushBattlePassTaskUpdateMessage = BaseClass("PushBattlePassTaskUpdateMessage", SFSBaseMessage)
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
    DataCenter.ActBattlePassData:PushBattlePassTaskUpdateHandle(t)
  end
end

PushBattlePassTaskUpdateMessage.OnCreate = OnCreate
PushBattlePassTaskUpdateMessage.HandleMessage = HandleMessage
return PushBattlePassTaskUpdateMessage
