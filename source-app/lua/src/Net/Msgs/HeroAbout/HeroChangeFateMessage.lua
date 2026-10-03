local HeroChangeFateMessage = BaseClass("HeroChangeFateMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutLong("uuid", param.uuid)
  end
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.HeroDataManager:UpdateOneHero(message.heroInfo)
    EventManager:GetInstance():Broadcast(EventId.HeroChangeFateBack)
  end
end

HeroChangeFateMessage.OnCreate = OnCreate
HeroChangeFateMessage.HandleMessage = HandleMessage
return HeroChangeFateMessage
