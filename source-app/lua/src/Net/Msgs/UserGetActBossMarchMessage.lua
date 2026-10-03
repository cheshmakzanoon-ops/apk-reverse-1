local UserGetActBossMarchMessage = BaseClass("UserGetActBossMarchMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errorCode = t.errorCode
  if errorCode ~= nil then
    if errorCode ~= "E100172" and errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(errorCode))
    end
  else
    DataCenter.ActBossDataManager:RefreshActBossDataList(t)
    EventManager:GetInstance():Broadcast(EventId.OnActBossDataRefresh)
  end
end

UserGetActBossMarchMessage.OnCreate = OnCreate
UserGetActBossMarchMessage.HandleMessage = HandleMessage
return UserGetActBossMarchMessage
