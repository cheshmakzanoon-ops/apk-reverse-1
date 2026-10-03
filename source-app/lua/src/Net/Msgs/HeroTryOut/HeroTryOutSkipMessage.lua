local HeroTryOutSkipMessage = BaseClass("HeroTryOutSkipMessage", SFSBaseMessage)
local base = SFSBaseMessage

function HeroTryOutSkipMessage:OnCreate(heroId, tagId)
  base.OnCreate(self)
  self.sfsObj:PutInt("heroId", heroId)
  self.sfsObj:PutInt("tagId", tagId)
end

function HeroTryOutSkipMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.HeroTryOutManager:OnHeroTryOutSkipMessageCallback(t)
  end
end

return HeroTryOutSkipMessage
