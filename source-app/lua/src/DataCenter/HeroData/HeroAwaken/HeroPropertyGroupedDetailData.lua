local HeroPropertyGroupedDetailData = BaseClass("HeroPropertyGroupedDetailData")

function HeroPropertyGroupedDetailData:__init()
  self.detailArray = nil
end

function HeroPropertyGroupedDetailData:__delete()
  self.detailArray = nil
end

function HeroPropertyGroupedDetailData:UpdateData(detailArray)
  self.detailArray = detailArray or {}
end

function HeroPropertyGroupedDetailData:GetTotalPropertyValueInAllGroup(effectId)
  local totalValue = 0
  local effectIdStr = tostring(effectId)
  if self.detailArray ~= nil then
    for _, v in ipairs(self.detailArray) do
      if v.effect then
        for id, value in pairs(v.effect) do
          if id == effectIdStr then
            totalValue = totalValue + value
          end
        end
      end
    end
  end
  return totalValue
end

function HeroPropertyGroupedDetailData:GetTotalPropertyValueInGroup(effectId, groupType)
  local totalValue = 0
  local effectIdStr = tostring(effectId)
  if self.detailArray ~= nil then
    for _, v in ipairs(self.detailArray) do
      if v.type == groupType and v.effect then
        for id, value in pairs(v.effect) do
          if id == effectIdStr then
            totalValue = totalValue + value
          end
        end
      end
    end
  end
  return totalValue
end

return HeroPropertyGroupedDetailData
