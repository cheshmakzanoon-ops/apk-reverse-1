local HeroRecycleMessage = BaseClass("HeroRecycleMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, heroUuids)
  base.OnCreate(self)
  self.sfsObj:PutLongArray("uuids", heroUuids)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.HeroDataManager:RemoveHeroes(message.uuids)
    EventManager:GetInstance():Broadcast(EventId.HeroRecycleBack)
    UIUtil.ShowTips(Localization:GetString(151034, message.retSkillPoint))
  end
end

HeroRecycleMessage.OnCreate = OnCreate
HeroRecycleMessage.HandleMessage = HandleMessage
return HeroRecycleMessage
