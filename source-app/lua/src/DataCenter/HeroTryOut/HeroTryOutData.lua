local HeroTryOutData = BaseClass("HeroTryOutData")

function HeroTryOutData:__init()
  self.serverData = nil
  self.initFromGetInfoMsg = false
end

function HeroTryOutData:__delete()
  self.serverData = nil
  self.initFromGetInfoMsg = nil
end

function HeroTryOutData:InitData(serverData, isFromGetInfoMsg)
  self.serverData = serverData
  if isFromGetInfoMsg then
    self.initFromGetInfoMsg = true
  end
end

function HeroTryOutData:UpdateData(serverData)
  self.serverData = serverData
end

function HeroTryOutData:HasInitDataFromGetInfoMsg()
  return self.initFromGetInfoMsg
end

function HeroTryOutData:GetDataByHeroId(heroId)
  if self.serverData ~= nil then
    for _, v in pairs(self.serverData) do
      if v.heroId == heroId then
        return v
      end
    end
  end
end

function HeroTryOutData:GetFinishedTryOutIdByTagAndGroup(heroId, tagId, groupId)
  local heroData = self:GetDataByHeroId(heroId)
  if heroData == nil or heroData.tagAndGroup == nil then
    return nil
  end
  for _, v in ipairs(heroData.tagAndGroup) do
    if v.tag == tagId and v.groupId == groupId then
      return v.stageId
    end
  end
  return nil
end

function HeroTryOutData:SetTryOutId(tryOutId)
  local template = DataCenter.HeroTryOutManager:GetLWHeroTryOutTemplateById(tryOutId)
  if template == nil then
    return
  end
  local heroId = template.hero_id
  if self.serverData == nil then
    self.serverData = {}
  end
  for i, v in pairs(self.serverData) do
    if v.heroId == heroId then
      v.id = tryOutId
      return
    end
  end
  table.insert(self.serverData, {heroId = heroId, id = tryOutId})
end

return HeroTryOutData
