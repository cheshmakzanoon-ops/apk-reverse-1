local BattleCardRandomAttrShowTemplate = BaseClass("BattleCardRandomAttrShowTemplate")

function BattleCardRandomAttrShowTemplate:__init()
  self.id = 0
  self.effect_name = 0
  self.quality = {}
  self.quality_range = {}
end

function BattleCardRandomAttrShowTemplate:__delete()
  self.id = nil
  self.effect_name = nil
  self.quality = nil
  self.quality_range = nil
  self.qualityList = nil
end

function BattleCardRandomAttrShowTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.effect_name = rowData:getValue("effect_name") or 0
  self.quality = rowData:getValue("quality") or {}
  self.quality_range = rowData:getValue("quality_range") or {}
  self.qualityList = {}
  for i, v in ipairs(self.quality) do
    local pair = {}
    pair.quality = v
    if not string.IsNullOrEmpty(self.quality_range[i]) then
      local split = string.split(self.quality_range[i], ";")
      if #split == 2 then
        pair.rangeMin = tonumber(split[1])
        pair.rangeMax = tonumber(split[2])
        table.insert(self.qualityList, pair)
      else
        Logger.LogError("self.quality_range is error,  id:" .. self.id .. " index:" .. i)
      end
    else
      Logger.LogError("self.quality_range is error,  id:" .. self.id .. " index:" .. i)
    end
  end
end

function BattleCardRandomAttrShowTemplate:GetQuality(value)
  local quality = 1
  for i, v in ipairs(self.qualityList) do
    if value >= v.rangeMin and value <= v.rangeMax then
      quality = v.quality
      break
    end
  end
  return quality
end

return BattleCardRandomAttrShowTemplate
