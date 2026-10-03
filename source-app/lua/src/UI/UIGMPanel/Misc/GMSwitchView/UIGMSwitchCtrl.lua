local UIGMSwitchCtrl = BaseClass("UIGMSwitchCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGMSwitchView)
end

local function _Sort(a, b)
  return string.lower(a.key) < string.lower(b.key)
end

local function _Match(text, keyword)
  if not text or not keyword then
    return false
  end
  local lowerText = string.lower(text)
  local lowerKeyword = string.lower(keyword)
  return string.find(lowerText, lowerKeyword, 1, true) ~= nil
end

function UIGMSwitchCtrl:GetSwitchArray(keyword)
  local array = {}
  if string.IsNullOrEmpty(keyword) then
    keyword = nil
  end
  local config = LuaEntry.DataConfig and LuaEntry.DataConfig.dataConfig
  if config then
    for k, v in pairs(config) do
      if not keyword or _Match(k, keyword) then
        table.insert(array, {key = k, val = v})
      end
    end
  end
  table.sort(array, _Sort)
  return array
end

UIGMSwitchCtrl.CloseSelf = CloseSelf
return UIGMSwitchCtrl
