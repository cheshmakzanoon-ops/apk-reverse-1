local UIScienceTabNewCtrl = BaseClass("UIScienceTabNewCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIScienceTab)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Background, false)
end

local function GetRecommendScience(self)
  local recommends = LuaEntry.DataConfig:TryGetStr("science_recommend", "k1")
  if not recommends or recommends == "" then
    return nil
  end
  local recommendIdTb = string.split(recommends, "|")
  for i, id in ipairs(recommendIdTb) do
    local intId = tonumber(id)
    local baseID = CommonUtil.GetScienceBaseType(intId)
    local tempLv = CommonUtil.GetScienceLv(intId)
    local hasScience = DataCenter.ScienceManager:HasScienceByIdAndLevel(baseID, tempLv)
    if not hasScience and DataCenter.ScienceManager:GetScienceQueueByScienceId(baseID) ~= nil then
      return intId
    end
  end
end

local function CheckIfShowNewUI(self)
  local k1 = LuaEntry.DataConfig:TryGetStr("science_interface", "k1") or 0
  local needLv = string.IsNullOrEmpty(k1) and 0 or tonumber(k1)
  local useNew = DataCenter.BuildManager:HasBuildByIdAndLevel(BuildingTypes.FUN_BUILD_SCIENE, needLv)
  return useNew
end

UIScienceTabNewCtrl.CloseSelf = CloseSelf
UIScienceTabNewCtrl.Close = Close
UIScienceTabNewCtrl.GetRecommendScience = GetRecommendScience
UIScienceTabNewCtrl.CheckIfShowNewUI = CheckIfShowNewUI
return UIScienceTabNewCtrl
