local HeroEntrustInfo = BaseClass("HeroEntrustInfo")

function HeroEntrustInfo:__init()
  self.id = 0
  self.state = 0
  self.payArr = {}
end

function HeroEntrustInfo:__delete()
  self.id = 0
  self.state = 0
  self.payArr = {}
end

function HeroEntrustInfo:UpdateInfo(message)
  if message == nil then
    return
  end
  self.id = message.id
  self.state = message.state
  self.payArr = message.payArr
end

function HeroEntrustInfo:IsAllComplete()
  return self.state == HeroEntrustState.Yes
end

function HeroEntrustInfo:IsCompleteByIndex(index)
  if self.payArr ~= nil then
    for k, v in ipairs(self.payArr) do
      if v == index then
        return true
      end
    end
  end
  return false
end

function HeroEntrustInfo:GetUnCompleteIndexList()
  if not self:IsAllComplete() then
    local result = {}
    local template = DataCenter.HeroEntrustTemplateManager:GetHeroEntrustTemplate(self.id)
    if template ~= nil then
      for k, v in ipairs(template.need) do
        if not self:IsCompleteByIndex(k) then
          table.insert(result, k)
        end
      end
    end
    return result
  end
end

return HeroEntrustInfo
