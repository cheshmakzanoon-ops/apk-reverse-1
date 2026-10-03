local GiftUnlockTemplate = BaseClass("GiftUnlockTemplate")
local Localization = CS.GameEntry.Localization
local loadstring = loadstring or load

local function __init(self)
  self.id = 0
  self.show_condition_arr = nil
  self.unlock_condition_arr = nil
end

local function __delete(self)
  self.id = nil
  self.show_condition_arr = nil
  self.unlock_condition_arr = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  local show_condition_str = row:getValue("show_condition")
  if not string.IsNullOrEmpty(show_condition_str) then
    self.show_condition_arr = string.string2array_num_oneSep(show_condition_str, ";")
  end
  local unlock_condition_str = row:getValue("unlock_condition")
  if not string.IsNullOrEmpty(unlock_condition_str) then
    self.unlock_condition_arr = string.string2array_num_oneSep(unlock_condition_str, ";")
  end
end

GiftUnlockTemplate.__init = __init
GiftUnlockTemplate.__delete = __delete
GiftUnlockTemplate.InitData = InitData
return GiftUnlockTemplate
