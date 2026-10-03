local PushLittleGamePVPBattleCreakOkMessage = BaseClass("PushLittleGamePVPBattleCreakOkMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, speak, cost)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local room = DataCenter.LWGGGoDataManager:GetRoom()
    room:CreakBattleOk(t)
  end
end

PushLittleGamePVPBattleCreakOkMessage.OnCreate = OnCreate
PushLittleGamePVPBattleCreakOkMessage.HandleMessage = HandleMessage
return PushLittleGamePVPBattleCreakOkMessage
