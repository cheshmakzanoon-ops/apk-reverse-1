local HeroDetailEffectMessage = BaseClass("HeroDetailEffectMessage", SFSBaseMessage)
local base = SFSBaseMessage

function HeroDetailEffectMessage:OnCreate(heroUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("heroUuid", heroUuid)
end

function HeroDetailEffectMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.heroUuid and t.detailArray then
    local heroInfo = DataCenter.HeroDataManager:GetHeroByUuid(t.heroUuid)
    if heroInfo then
      heroInfo:UpdatePropertyGroupedDetailData(t.detailArray)
      EventManager:GetInstance():Broadcast(EventId.HeroPropertyGroupedDetailDataUpdate, t.heroUuid)
    end
  end
end

return HeroDetailEffectMessage
