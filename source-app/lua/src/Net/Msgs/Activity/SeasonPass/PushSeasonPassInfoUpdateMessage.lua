local PushSeasonPassInfoUpdateMessage = BaseClass("PushSeasonPassInfoUpdateMessage", SFSBaseMessage)
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
    DataCenter.SeasonPassManager:OnRecvPassInfoPush(t)
  end
end

PushSeasonPassInfoUpdateMessage.OnCreate = OnCreate
PushSeasonPassInfoUpdateMessage.HandleMessage = HandleMessage
return PushSeasonPassInfoUpdateMessage
