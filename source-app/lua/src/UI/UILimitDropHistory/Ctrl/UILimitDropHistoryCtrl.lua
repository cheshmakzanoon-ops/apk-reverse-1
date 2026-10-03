local UILimitDropHistoryCtrl = BaseClass("UILimitDropHistoryCtrl", UIBaseCtrl)
local ITEM_PREFAB_SCRIPT_CONFIG = {
  [LimitDropHistoryItemType.DayTitleItem4First] = {
    prefab = "InfoExpandBar4First",
    cls = "UI.UILimitDropHistory.Component.InfoExpandBarComponent"
  },
  [LimitDropHistoryItemType.DayTitleItem] = {
    prefab = "InfoExpandBar",
    cls = "UI.UILimitDropHistory.Component.InfoExpandBarComponent"
  },
  [LimitDropHistoryItemType.DropInfo] = {
    prefab = "DropinfoItem",
    cls = "UI.UILimitDropHistory.Component.DropinfoItemComponent"
  },
  [LimitDropHistoryItemType.DropLimit] = {
    prefab = "DropLimitInfoItem",
    cls = "UI.UILimitDropHistory.Component.DropLimitInfoItemComponent"
  }
}

function UILimitDropHistoryCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILimitDropHistory)
end

function UILimitDropHistoryCtrl:GetDayLogData(activityId, type, expandCfgDic, useCache)
  local data = DataCenter.ActLimitedTimeFeastData:GetActivityDropHistory(activityId)
  if not data or not useCache then
    local curDay = self:GetCurActDayIndex(activityId)
    DataCenter.ActLimitedTimeFeastData:ReqActivityDropHistory(activityId, curDay, type)
    return
  end
  return data:GetAllDayHistoryData(type, expandCfgDic)
end

function UILimitDropHistoryCtrl:GetLastExistDataDayIndex(activityId, type)
  local data = DataCenter.ActLimitedTimeFeastData:GetActivityDropHistory(activityId)
  local activityPassDay = self:GetCurActDayIndex(activityId)
  if not data then
    return activityPassDay
  end
  local sortDayArr = data:GetSortDayList(type)
  if not sortDayArr or #sortDayArr <= 0 then
    return activityPassDay
  end
  return sortDayArr[1]
end

function UILimitDropHistoryCtrl:GetShowDataList(dropData)
  if not dropData then
    return
  end
end

function UILimitDropHistoryCtrl:GetCurActDayIndex(activityId)
  return DataCenter.ActivityListDataManager:GetCurActDayIndex(activityId)
end

function UILimitDropHistoryCtrl:GetPrefabAndScriptName(itemData)
  if not itemData then
    return nil
  end
  local type = itemData.type
  if type == LimitDropHistoryItemType.DayTitleItem and itemData.data.expandState then
    type = LimitDropHistoryItemType.DayTitleItem4First
  end
  local cfg = ITEM_PREFAB_SCRIPT_CONFIG[type]
  return cfg.prefab, cfg.cls
end

return UILimitDropHistoryCtrl
