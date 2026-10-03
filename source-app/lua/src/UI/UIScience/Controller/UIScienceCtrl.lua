local UIScienceCtrl = BaseClass("UIScienceCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIScience)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Background, false)
end

local function IsUnLockScience(self, scienceId)
  local template = DataCenter.ScienceManager:GetScienceTemplate(scienceId)
  if template == nil then
    return false
  end
  local needScience = template.needScience
  if needScience ~= nil then
    for _, v in ipairs(needScience) do
      if not DataCenter.ScienceManager:HasScienceByIdAndLevel(v.scienceId, v.level) then
        return false
      end
    end
  end
  local needBuild = template.needBuild
  if needBuild ~= nil then
    for _, v in ipairs(needBuild) do
      if not DataCenter.BuildManager:HasBuildByIdAndLevel(v.buildId, v.level) then
        return false
      end
    end
  end
  return true
end

local function IsScienceLvMax(self, scienceId)
  local curLv = DataCenter.ScienceManager:GetScienceLevel(scienceId)
  local maxLv = DataCenter.ScienceManager:GetScienceMaxLevel(scienceId)
  if curLv == maxLv then
    return true
  end
  return false
end

UIScienceCtrl.CloseSelf = CloseSelf
UIScienceCtrl.Close = Close
UIScienceCtrl.IsUnLockScience = IsUnLockScience
UIScienceCtrl.IsScienceLvMax = IsScienceLvMax
return UIScienceCtrl
