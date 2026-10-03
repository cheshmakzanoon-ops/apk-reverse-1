local UIPVESelectAdventureSubCtrl = BaseClass("UIPVESelectAdventureSubCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPVESelectAdventureSub)
end

local function GetMonsterPower(self, monsterId)
  local armyId = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.Monster), monsterId, "army")
  armyId = armyId[1] or 0
  local powerStr = GetTableData(TableName.Army, armyId, "pve_power") or ""
  local powerList = string.split(powerStr, "|")
  local totalPower = 0
  for _, str in ipairs(powerList) do
    totalPower = totalPower + (tonumber(str) or 0)
  end
  local armyStr = GetTableData(TableName.Army, armyId, "arm") or ""
  local armyList = string.split(armyStr, "|")
  local totalArmy = 0
  for _, str in ipairs(armyList) do
    local spls = string.split(str, ";")
    totalArmy = totalArmy + (tonumber(spls[2]) or 0)
  end
  return totalPower, totalArmy
end

UIPVESelectAdventureSubCtrl.CloseSelf = CloseSelf
UIPVESelectAdventureSubCtrl.GetMonsterPower = GetMonsterPower
return UIPVESelectAdventureSubCtrl
