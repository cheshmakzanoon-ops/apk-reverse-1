local PushBiuBiuPVPBattleCreakOkMessage = BaseClass("PushBiuBiuPVPBattleCreakOkMessage", SFSBaseMessage)
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
    local room = DataCenter.LWBiuBiuDataManager:GetRoom()
    room:CreakBattleOk(t)
  end
end

PushBiuBiuPVPBattleCreakOkMessage.OnCreate = OnCreate
PushBiuBiuPVPBattleCreakOkMessage.HandleMessage = HandleMessage
return PushBiuBiuPVPBattleCreakOkMessage
