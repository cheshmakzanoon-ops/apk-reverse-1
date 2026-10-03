local LWUIMeteoriteConditionNoticeCtrl = BaseClass("LWUIMeteoriteConditionNoticeCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function LWUIMeteoriteConditionNoticeCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIMeteoriteConditionNotice)
end

local function Sort(a, b)
  local ok_a = a.ok or false
  local ok_b = b.ok or false
  if ok_a ~= ok_b then
    return ok_b
  end
  local sort_a = a.sort or 100
  local sort_b = b.sort or 100
  return sort_a < sort_b
end

function LWUIMeteoriteConditionNoticeCtrl:SortConditions(list)
  if not list then
    return
  end
  table.sort(list, Sort)
end

return LWUIMeteoriteConditionNoticeCtrl
