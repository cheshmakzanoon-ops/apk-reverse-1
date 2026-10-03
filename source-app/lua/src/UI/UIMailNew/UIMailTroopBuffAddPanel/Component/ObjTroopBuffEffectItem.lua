local ObjTroopBuffEffectItem = BaseClass("ObjTroopBuffEffectItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local _cp_txtBuffName = "txtBuffName"
local _cp_txtBuffValue = "txtBuffValue"

function ObjTroopBuffEffectItem:OnCreate()
  base.OnCreate(self)
  self._txtBuffName = self:AddComponent(UIText, _cp_txtBuffName)
  self._txtBuffValue = self:AddComponent(UIText, _cp_txtBuffValue)
end

function ObjTroopBuffEffectItem:SetData(BattleEffectInfo)
  local effectId = BattleEffectInfo.effectId
  local value = BattleEffectInfo.value
  self._effectId = effectId
  self._value = value
  local effectDesc = GetTableData(TableName.EffectNumDesc, effectId, "des")
  self._txtBuffName:SetLocalText(effectDesc)
  local effectType = GetTableData(TableName.EffectNumDesc, effectId, "type")
  if string.IsNullOrEmpty(effectType) then
    effectType = "0"
  end
  if effectType == "1" then
    value = value .. "%"
  end
  self._txtBuffValue:SetText(value)
end

local Color_Green = Color32.New(0.15294117647058825, 0.7764705882352941, 0.5490196078431373, 1)
local Color_Red = Color32.New(0.9176470588235294, 0.25882352941176473, 0.25882352941176473, 1)
local Color_Grey = Color32.New(0.7176470588235294, 0.4, 0.18823529411764706, 1)

function ObjTroopBuffEffectItem:SetExtraData(targetBattleEffect)
  local targetValue = 0.0
  for effectId, value in pairs(targetBattleEffect) do
    if self._effectId == effectId then
      targetValue = value
      break
    end
  end
  if targetValue < self._value then
    self._txtBuffValue:SetColor(Color_Green)
  elseif targetValue > self._value then
    self._txtBuffValue:SetColor(Color_Red)
  else
    self._txtBuffValue:SetColor(Color_Grey)
  end
end

return ObjTroopBuffEffectItem
