local SynFoodFactoryMessage = BaseClass("SynFoodFactoryMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, bUuid)
  base.OnCreate(self)
  local serverTime = math.ceil(UITimeManager:GetInstance():GetServerTime())
  self.sfsObj:PutLong("clientTime", serverTime)
  if bUuid ~= nil then
    self.sfsObj:PutLong("bUuid", bUuid)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    local errorCode = t.errorCode
    if errorCode ~= SeverErrorCode then
      UIUtil.ShowTips(Localization:GetString(t.errorCode))
    end
  else
    if t.serverTime ~= nil then
      CS.GameEntry.Timer:UpdateServerMilliseconds(t.serverTime)
      UITimeManager:GetInstance():UpdateServerMsDeltaTime(t.serverTime)
    end
    DataCenter.FactoryDataManager:RefreshFactoryList(t)
    EventManager:GetInstance():Broadcast(EventId.GetFactoryData)
  end
end

SynFoodFactoryMessage.OnCreate = OnCreate
SynFoodFactoryMessage.HandleMessage = HandleMessage
return SynFoodFactoryMessage
