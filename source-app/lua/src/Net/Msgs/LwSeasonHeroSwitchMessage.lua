local LwSeasonHeroSwitchMessage = BaseClass("LwSeasonHeroSwitchMessage", SFSBaseMessage)
local base = SFSBaseMessage

function LwSeasonHeroSwitchMessage:OnCreate(srcHeroUuid, dstHeroUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("src_hero_uuid", srcHeroUuid)
  self.sfsObj:PutLong("dst_hero_uuid", dstHeroUuid)
end

function LwSeasonHeroSwitchMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    EventManager:GetInstance():Broadcast(EventId.ExchangeHeroFail)
  elseif t.src_hero_uuid and t.dst_hero_uuid then
    local param = {}
    param.srcHeroUuid = t.src_hero_uuid
    param.dstHeroUuid = t.dst_hero_uuid
    if t.skillPoint then
      param.skillPoint = t.skillPoint
    end
    if t.srcSkill then
      param.srcSkill = t.srcSkill
    end
    if t.dstSkill then
      param.dstSkill = t.dstSkill
    end
    EventManager:GetInstance():Broadcast(EventId.ExchangeHeroSuccess, param)
  end
end

return LwSeasonHeroSwitchMessage
