local HeroTryOutBattleMessage = BaseClass("HeroTryOutBattleMessage", SFSBaseMessage)
local base = SFSBaseMessage

function HeroTryOutBattleMessage:OnCreate(heroTryOutId, heroInfos)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", heroTryOutId)
  if heroInfos ~= nil then
    self.sfsObj:PutSFSArray("heroInfos", heroInfos)
  end
end

function HeroTryOutBattleMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.HeroTryOutManager:OnHeroTryOutBattleMessageCallback(t)
  end
end

return HeroTryOutBattleMessage
