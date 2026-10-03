local UILWTWSkillChipBagCtrl = BaseClass("UILWTWSkillChipBagCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTWSkillChipBag)
end

local function SortByType(a, b)
  local aType = a:GetType()
  local bType = b:GetType()
  if aType ~= bType then
    return aType < bType
  end
  local aQuality = a:GetQuality()
  local bQuality = b:GetQuality()
  if aQuality ~= bQuality then
    return aQuality > bQuality
  end
  local aStar = a:GetStar()
  local bStar = b:GetStar()
  if aStar ~= bStar then
    return aStar > bStar
  end
  local aLevel = a:GetLevel()
  local bLevel = b:GetLevel()
  if aLevel ~= bLevel then
    return aLevel > bLevel
  end
  local aId = a:GetId()
  local bId = b:GetId()
  if aId ~= bId then
    return aId < bId
  end
  return a:GetUUID() < b:GetUUID()
end

local function SortByStar(a, b)
  local aStar = a:GetStar()
  local bStar = b:GetStar()
  if aStar ~= bStar then
    return aStar > bStar
  end
  local aQuality = a:GetQuality()
  local bQuality = b:GetQuality()
  if aQuality ~= bQuality then
    return aQuality > bQuality
  end
  local aLevel = a:GetLevel()
  local bLevel = b:GetLevel()
  if aLevel ~= bLevel then
    return aLevel > bLevel
  end
  local aType = a:GetType()
  local bType = b:GetType()
  if aType ~= bType then
    return aType < bType
  end
  local aId = a:GetId()
  local bId = b:GetId()
  if aId ~= bId then
    return aId < bId
  end
  return a:GetUUID() < b:GetUUID()
end

local function SortByLevel(a, b)
  local aLevel = a:GetLevel()
  local bLevel = b:GetLevel()
  if aLevel ~= bLevel then
    return aLevel > bLevel
  end
  local aQuality = a:GetQuality()
  local bQuality = b:GetQuality()
  if aQuality ~= bQuality then
    return aQuality > bQuality
  end
  local aStar = a:GetStar()
  local bStar = b:GetStar()
  if aStar ~= bStar then
    return aStar > bStar
  end
  local aType = a:GetType()
  local bType = b:GetType()
  if aType ~= bType then
    return aType < bType
  end
  local aId = a:GetId()
  local bId = b:GetId()
  if aId ~= bId then
    return aId < bId
  end
  return a:GetUUID() < b:GetUUID()
end

local function SortByQuality(a, b)
  local aQuality = a:GetQuality()
  local bQuality = b:GetQuality()
  if aQuality ~= bQuality then
    return aQuality > bQuality
  end
  local aStar = a:GetStar()
  local bStar = b:GetStar()
  if aStar ~= bStar then
    return aStar > bStar
  end
  local aLevel = a:GetLevel()
  local bLevel = b:GetLevel()
  if aLevel ~= bLevel then
    return aLevel > bLevel
  end
  local aType = a:GetType()
  local bType = b:GetType()
  if aType ~= bType then
    return aType < bType
  end
  local aId = a:GetId()
  local bId = b:GetId()
  if aId ~= bId then
    return aId < bId
  end
  return a:GetUUID() < b:GetUUID()
end

local DATA_TABLE = {}

local function GetChipsData(chipType, sortType)
  local count = #DATA_TABLE
  if 0 < count then
    for i = 1, count do
      DATA_TABLE[i] = nil
    end
  end
  local allChips
  if chipType == 0 then
    allChips = DataCenter.TWSkillChipManager:GetAllChips()
  else
    allChips = DataCenter.TWSkillChipManager:GetChipsByHeroType(chipType)
  end
  if allChips then
    local count = 1
    for k, v in pairs(allChips) do
      DATA_TABLE[count] = v
      count = count + 1
    end
  end
  local sort_func
  if sortType == 1 then
    sort_func = SortByType
  elseif sortType == 2 then
    sort_func = SortByStar
  elseif sortType == 3 then
    sort_func = SortByLevel
  elseif sortType == 4 then
    sort_func = SortByQuality
  end
  if sort_func then
    table.sort(DATA_TABLE, sort_func)
  end
  return DATA_TABLE
end

local function HasChips()
  local allChips = DataCenter.TWSkillChipManager:GetAllChips()
  return not table.IsNullOrEmpty(allChips)
end

UILWTWSkillChipBagCtrl.CloseSelf = CloseSelf
UILWTWSkillChipBagCtrl.GetChipsData = GetChipsData
UILWTWSkillChipBagCtrl.HasChips = HasChips
return UILWTWSkillChipBagCtrl
