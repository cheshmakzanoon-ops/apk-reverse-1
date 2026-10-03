local UIGMBarCtrl = BaseClass("UIGMBarCtrl", UIBaseCtrl)

function UIGMBarCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMBar)
end

local function _Sort(a, b)
  local _a = a.order or 1
  local _b = b.order or 1
  return _a > _b
end

function UIGMBarCtrl:GetItemsData()
  local items = {}
  for k, v in pairs(GMConfig.Bars) do
    local barName = k
    local config = GMUtils.GetBarItemByName(barName)
    if GMUtils.GetBool(v.key, v.defaultShow) then
      table.insert(items, config)
    end
  end
  if 1 < #items then
    table.sort(items, _Sort)
  end
  return items
end

return UIGMBarCtrl
