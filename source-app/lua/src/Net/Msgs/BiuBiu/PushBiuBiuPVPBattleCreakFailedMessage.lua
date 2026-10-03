local PushBiuBiuPVPBattleCreakFailedMessage = BaseClass("PushBiuBiuPVPBattleCreakFailedMessage", SFSBaseMessage)
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
    room:CreakBattleFailed()
  end
end

PushBiuBiuPVPBattleCreakFailedMessage.OnCreate = OnCreate
PushBiuBiuPVPBattleCreakFailedMessage.HandleMessage = HandleMessage
return PushBiuBiuPVPBattleCreakFailedMessage
