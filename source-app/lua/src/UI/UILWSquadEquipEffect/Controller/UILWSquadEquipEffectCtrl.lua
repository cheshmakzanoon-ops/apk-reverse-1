local UILWSquadEquipEffectCtrl = BaseClass("UILWSquadEquipEffectCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UILWSquadEquipEffect)
end

local function GetPanelData(self, buildUuid)
  local result = {}
  local effects = DataCenter.CommonEquipDataManager:CollectEquipsEffectByOwnerUid(CommonEquipType.SquadEquip, buildUuid)
  for k, v in pairs(effects) do
    local effectId = k
    local value = v
    local nameStr = HeroUtils.GetHeroPropertyNameId(effectId)
    local name = Localization:GetString(nameStr)
    local type = toInt(GetTableData(TableName.LW_Effect_Number, effectId, "type"))
    local addValue = self:GetEffectNumWithType(effectId, value, type)
    local para = {}
    para.name = name
    para.value = addValue
    table.insert(result, para)
  end
  return result
end

local function GetEffectNumWithType(self, effectId, value, type)
  local result = HeroUtils.GetFormattedPropertyValue(effectId, value)
  if type == 1 then
    if 0 < value then
      result = "<color=#099B4A>" .. result .. "</color>"
    else
      result = "<color=#F53C3D>" .. result .. "</color>"
    end
  elseif type == 2 then
    result = "<color=#099B4A>" .. result .. "</color>"
  elseif type == 3 then
    result = "<color=#F53C3D>" .. result .. "</color>"
  elseif type == 4 then
    result = "<color=#099B4A>" .. result .. "</color>"
  end
  return result
end

UILWSquadEquipEffectCtrl.CloseSelf = CloseSelf
UILWSquadEquipEffectCtrl.GetPanelData = GetPanelData
UILWSquadEquipEffectCtrl.GetEffectNumWithType = GetEffectNumWithType
return UILWSquadEquipEffectCtrl
