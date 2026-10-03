local PayForHeroEntrustMessage = BaseClass("PayForHeroEntrustMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, param)
  base.OnCreate(self)
  if param ~= nil then
    self.sfsObj:PutInt("id", param.id)
    self.sfsObj:PutInt("index", param.index)
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.HeroEntrustManager:PayForHeroEntrustHandle(t)
end

PayForHeroEntrustMessage.OnCreate = OnCreate
PayForHeroEntrustMessage.HandleMessage = HandleMessage
return PayForHeroEntrustMessage
