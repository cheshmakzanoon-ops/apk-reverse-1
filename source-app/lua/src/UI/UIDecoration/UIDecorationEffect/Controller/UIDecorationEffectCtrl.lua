local UIDecorationEffectCtrl = BaseClass("UIDecorationEffectCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIDecorationEffect)
end

local function GetPanelData(self)
  local result = {}
  local allDecoration = DataCenter.DecorationDataManager:GetAllActiveDecoration()
  local tmp = {}
  for _, decorationId in ipairs(allDecoration) do
    local data = DataCenter.DecorationDataManager:GetSkinDataById(decorationId)
    if data then
      local template = DataCenter.DecorationTemplateManager:GetTemplate(decorationId)
      if template ~= nil then
        if data:IsWear() then
          for _, v in pairs(template.wearEffect) do
            if tmp[v.key] == nil then
              tmp[v.key] = v.value
            else
              tmp[v.key] = tmp[v.key] + v.value
            end
          end
        end
        for _, v in pairs(template.ownEffect) do
          local key = v.key
          local value = v.value
          if key == 75949 then
            key = 75950
          end
          if tmp[key] == nil then
            tmp[key] = value
          else
            tmp[key] = tmp[key] + value
          end
        end
      end
    end
  end
  for k, v in pairs(tmp) do
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
  else
    result = "<color=#099B4A>" .. result .. "</color>"
  end
  return result
end

UIDecorationEffectCtrl.CloseSelf = CloseSelf
UIDecorationEffectCtrl.GetPanelData = GetPanelData
UIDecorationEffectCtrl.GetEffectNumWithType = GetEffectNumWithType
return UIDecorationEffectCtrl
