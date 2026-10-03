local HeroStarUpMessage = BaseClass("HeroStarUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutLong("uuid", param.uuid)
    if param.arr ~= nil then
      local oneArr = SFSArray.New()
      for k, v in pairs(param.arr) do
        local one = SFSObject.New()
        one:PutUtfString("itemId", k)
        one:PutInt("count", v)
        oneArr:AddSFSObject(one)
      end
      self.sfsObj:PutSFSArray("itemArr", oneArr)
    end
  end
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.HeroDataManager:UpdateOneHero(message.heroInfo)
    EventManager:GetInstance():Broadcast(EventId.HeroStarUpBack)
  end
end

HeroStarUpMessage.OnCreate = OnCreate
HeroStarUpMessage.HandleMessage = HandleMessage
return HeroStarUpMessage
