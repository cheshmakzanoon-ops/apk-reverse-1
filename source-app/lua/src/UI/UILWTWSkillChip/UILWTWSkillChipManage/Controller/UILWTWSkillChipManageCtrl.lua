local UILWTWSkillChipManageCtrl = BaseClass("UILWTWSkillChipManageCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWTWSkillChipManage)
end

local LIST = {}

local function RefershEquipDataList(type, heroType, setId)
  local equipDataList = DataCenter.TWSkillChipManager:GetChipsByType(type)
  local list = LIST
  if 0 < #list then
    for i = 1, #list do
      list[i] = nil
    end
  end
  local count = 1
  for _, v in pairs(equipDataList) do
    if v:GetMasterSet() ~= setId and (heroType == 0 or v:GetHeroType() == heroType) then
      list[count] = v
      count = count + 1
    end
  end
  table.sort(list, function(a, b)
    local bothFree = false
    if a:IsFree() and b:IsFree() then
      bothFree = true
    end
    if not bothFree then
      if a:IsFree() then
        return true
      end
      if b:IsFree() then
        return false
      end
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
    return a.uuid < b.uuid
  end)
  return list
end

UILWTWSkillChipManageCtrl.CloseSelf = CloseSelf
UILWTWSkillChipManageCtrl.RefershEquipDataList = RefershEquipDataList
return UILWTWSkillChipManageCtrl
