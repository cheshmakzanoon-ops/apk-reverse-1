local UIAllyDuelGroupTipItem = BaseClass("UIAllyDuelGroupTipItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local desTxt_path = "Content/TxtDesc"
local valueTxt_path = "Content/TxtValue"
local moneyImg_path = "Content/ImgMoney"
local groupIcon_path = "Content/GroupIcon"

local function OnCreate(self)
  base.OnCreate(self)
  self.desTxt = self:AddComponent(UIText, desTxt_path)
  self.valueTxt = self:AddComponent(UIText, valueTxt_path)
  self.moneyImg = self:AddComponent(UIImage, moneyImg_path)
  self.groupIcon = self:AddComponent(UIImage, groupIcon_path)
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function RefreshData(self, data, index)
  if data == nil then
    Logger.LogError("\230\156\170\230\159\165\230\137\190\229\136\176score\232\161\168\228\184\173group\233\133\141\231\189\174\229\135\134\231\161\174\230\149\176\230\141\174")
    return
  end
  self.data = data
  local id = data.id
  local name = data.name
  local value = data.value
  if value ~= nil and type(value) == "table" and value.Length > 0 then
    local valueLuaTable = {}
    for i = 1, value.Length do
      table.insert(valueLuaTable, value[i - 1])
    end
    local descExpand = CommonUtil.GetNameByParams(name, valueLuaTable)
    self.desTxt:SetText(descExpand)
  elseif data.valueStr ~= nil then
    local valueArr = string.split(data.valueStr, ",")
    local descExpand = CommonUtil.GetNameByParams(name, valueArr)
    self.desTxt:SetText(descExpand)
  else
    self.desTxt:SetLocalText(name, value)
  end
  if string.IsNullOrEmpty(data.points) or tonumber(data.points) == 0 then
    self.valueTxt:SetLocalText(372564)
  else
    local num = self:JudgeScienceEffect()
    self.valueTxt:SetText("+ " .. num)
  end
  local scoreId = self.data.id
  local iconPath = tonumber(GetTableData(TableName.Score, scoreId, "icon_path")) or ""
  self.groupIcon:SetActive(not string.IsNullOrEmpty(iconPath))
  if not string.IsNullOrEmpty(iconPath) then
    self.groupIcon:LoadSprite(iconPath)
  end
end

function UIAllyDuelGroupTipItem:JudgeScienceEffect()
  local num = self.data.points * 10
  local numStr = ""
  local effectNum = LuaEntry.Effect:GetAllianceArmsEffectNum(num, self.data.effectList)
  if num < effectNum then
    effectNum = effectNum * 0.1
    local finalNum = string.GetFormattedSeperatorNum(effectNum)
    numStr = string.format("<color=#94e138>%s</color>", finalNum)
    return numStr
  end
  num = num * 0.1
  return string.GetFormattedSeperatorNum(num)
end

UIAllyDuelGroupTipItem.OnCreate = OnCreate
UIAllyDuelGroupTipItem.OnDestroy = OnDestroy
UIAllyDuelGroupTipItem.RefreshData = RefreshData
return UIAllyDuelGroupTipItem
