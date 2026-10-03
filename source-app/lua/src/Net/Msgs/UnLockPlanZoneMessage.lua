local UnLockPlanZoneMessage = BaseClass("UnLockPlanZoneMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, bUuid)
  base.OnCreate(self)
  if bUuid ~= nil then
    self.sfsObj:PutLong("bUuid", bUuid)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(t.errorCode))
  else
    DataCenter.FactoryDataManager:RefreshFactoryList(t)
    if t.remainGold ~= nil then
      LuaEntry.Player.gold = t.remainGold
      EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    if t.resource ~= nil then
      LuaEntry.Resource:UpdateResource(t.resource)
    end
    if t.accPoint ~= nil then
      DataCenter.AllianceBaseDataManager:UpdateAccPoint(t.accPoint)
    end
    EventManager:GetInstance():Broadcast(EventId.AddFactoryBox)
  end
end

UnLockPlanZoneMessage.OnCreate = OnCreate
UnLockPlanZoneMessage.HandleMessage = HandleMessage
return UnLockPlanZoneMessage
