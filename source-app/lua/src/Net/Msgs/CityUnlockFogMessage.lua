local CityUnlockFogMessage = BaseClass("CityUnlockFogMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Data = CS.GameEntry.Data

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutInt("fogId", param.fogId)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  Data.Fog:UnlockFog(t.fogId)
  EventManager:GetInstance():Broadcast(EventId.OpenFogSuccess, t.fogId)
  if DataCenter.GuideCityManager.isUnlockFog then
    DataCenter.GuideCityManager:RefreshGuideSignal()
  end
end

CityUnlockFogMessage.OnCreate = OnCreate
CityUnlockFogMessage.HandleMessage = HandleMessage
return CityUnlockFogMessage
