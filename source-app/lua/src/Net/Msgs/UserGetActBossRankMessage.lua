local UserGetActBossRankMessage = BaseClass("UserGetActBossRankMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, uuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", uuid)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(t.errorCode))
  else
    DataCenter.ActBossDataManager:RefreshRankDataList(t)
    EventManager:GetInstance():Broadcast(EventId.OnActBossRankRefresh)
  end
end

UserGetActBossRankMessage.OnCreate = OnCreate
UserGetActBossRankMessage.HandleMessage = HandleMessage
return UserGetActBossRankMessage
