local PushBiuBiuPVPRemMessage = BaseClass("PushBiuBiuPVPRemMessage", SFSBaseMessage)
local base = SFSBaseMessage

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
    room:Rem(t)
  end
end

PushBiuBiuPVPRemMessage.OnCreate = OnCreate
PushBiuBiuPVPRemMessage.HandleMessage = HandleMessage
return PushBiuBiuPVPRemMessage
