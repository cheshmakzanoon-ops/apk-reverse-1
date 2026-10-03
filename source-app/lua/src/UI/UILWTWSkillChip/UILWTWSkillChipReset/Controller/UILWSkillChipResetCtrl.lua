local UILWSkillChipResetCtrl = BaseClass("UILWSkillChipResetCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWSkillChipReset)
end

local function GetCanResetChipDataList()
  local chipList = {}
  local chipsDict = {}
  local equipDataList = DataCenter.TWSkillChipManager:GetAllChips()
  for _, v in pairs(equipDataList) do
    if v:IsFree() and (v:GetLevel() > 1 or v:GetStar() > 0) then
      table.insert(chipList, v)
      chipsDict[v.uuid] = v
    end
  end
  table.sort(chipList, function(a, b)
    if a:GetQuality() ~= b:GetQuality() then
      return a:GetQuality() > b:GetQuality()
    end
    if a:GetLevel() ~= b:GetLevel() then
      return a:GetLevel() > b:GetLevel()
    end
    if a:GetType() ~= b:GetType() then
      return a:GetType() < b:GetType()
    end
    return a.uuid < b.uuid
  end)
  return chipList, chipsDict
end

UILWSkillChipResetCtrl.CloseSelf = CloseSelf
UILWSkillChipResetCtrl.GetCanResetChipDataList = GetCanResetChipDataList
return UILWSkillChipResetCtrl
