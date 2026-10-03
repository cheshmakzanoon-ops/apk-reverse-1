local BattlefieldDsbDuelTemplateManager = BaseClass("BattlefieldDsbDuelTemplateManager", BattlefieldTemplateMgrBase)
local BattlefieldDsbDuelActTemplateInfo = require("DataCenter.BattlefieldDsbDuel.Template.BattlefieldDsbDuelActTemplateInfo")
local BattlefieldDsbDuelBattleTemplateInfo = require("DataCenter.BattlefieldDsbDuel.Template.BattlefieldDsbDuelBattleTemplateInfo")
local Localization = CS.GameEntry.Localization

function BattlefieldDsbDuelTemplateManager:OnInit()
  self.bfType = BattleFieldType.DsbDuel
  self.actTemplateInfo = nil
  self.battleTemplateInfo = nil
  self.templateBuffs = nil
end

function BattlefieldDsbDuelTemplateManager:__delete()
  if self.actTemplateInfo then
    self.actTemplateInfo:Delete()
    self.actTemplateInfo = nil
  end
  if self.battleTemplateInfo then
    self.battleTemplateInfo:Delete()
    self.battleTemplateInfo = nil
  end
end

function BattlefieldDsbDuelTemplateManager:GetActTemplateInfo()
  if not self.actTemplateInfo then
    self.actTemplateInfo = BattlefieldDsbDuelActTemplateInfo.New()
  end
  return self.actTemplateInfo
end

function BattlefieldDsbDuelTemplateManager:GetBattleTemplateInfo()
  if not self.battleTemplateInfo then
    self.battleTemplateInfo = BattlefieldDsbDuelBattleTemplateInfo.New()
  end
  return self.battleTemplateInfo
end

function BattlefieldDsbDuelTemplateManager:GetBuildTemplate(buildId)
  return self:GetTemplate(buildId)
end

function BattlefieldDsbDuelTemplateManager:GetBuffDesc(template)
  if template == nil then
    return
  end
  local buffShowMap = template.buffShowMap
  if table.IsNullOrEmpty(buffShowMap) then
    return Localization:GetString(template.desc)
  end
  local effects = template.effects or {}
  local values = {}
  for _, v in ipairs(buffShowMap) do
    if v == 99 then
      table.insert(values, template.duration_time)
    else
      local eff = effects[v]
      local effVal = eff ~= nil and eff.lordEffectVal or 0
      local effId = eff.lordEffectId
      local type = toInt(GetTableData(TableName.LW_Effect_Number, tonumber(effId), "type"))
      if type ~= 0 then
        effVal = effVal * 1.0E-4
      end
      local value = UIUtil.ParseEffectValue(effId, effVal)
      table.insert(values, value)
    end
  end
  return Localization:GetString(template.desc, table.unpack(values))
end

function BattlefieldDsbDuelTemplateManager:GetBuffTemplate(id)
  if self.templateBuffs == nil then
    self.templateBuffs = {}
  end
  local template = self.templateBuffs[id]
  if self.templateBuffs[id] == nil then
    local tbName = DataCenter.BattlefieldDsbDuelManager:GetCfgValue(BattleFieldTableKey.PARAM)
    local lineData = LocalController.instance():getLine(tbName, id)
    if lineData ~= nil then
      template = {}
      template.id = id
      template.name = lineData:getValue("name")
      template.desc = lineData:getValue("desc")
      template.icon = string.format(LoadPath.LWBattleFieldPath, lineData:getValue("map_icon"))
      template.probability = lineData:getIntValue("probability")
      template.duration_time = lineData:getIntValue("duration_time")
      template.active_effect = lineData:getValue("active_effect")
      local effects = {}
      local mySplit = string.split
      local list = mySplit(lineData:getValue("effect_number"), "|")
      if 0 < #list then
        for _, v in ipairs(list) do
          local tmp = mySplit(v, ";")
          table.insert(effects, {
            lordEffectId = tmp[1] or 0,
            lordEffectVal = tmp[2] or 0
          })
        end
      end
      template.effects = effects
      template.buffShowMap = string.string2array_num_oneSep(lineData:getValue("buff_para_show_map"), ",")
      
      function template.getDesc()
        return self:GetBuffDesc(template)
      end
      
      self.templateBuffs[id] = template
    end
  end
  return template
end

local MiniState = {
  Occupied_1 = 1,
  Occupied_2 = 2,
  Occupied_3 = 3,
  Occupied_4 = 4,
  Occupied_Mine = 5,
  Fixing = 9,
  Normal = 11
}

function BattlefieldDsbDuelTemplateManager:GetMiniMapSpritePathByBuildId(detail)
  if not detail then
    return "", MiniState.Normal
  end
  local buildId = detail.BuildId
  local config = self:GetBuildTemplate(buildId)
  if config == nil then
    return "", MiniState.Normal
  end
  if config:IsBuild() then
    local state = self:GetMiniState(detail)
    return string.format(LoadPath.LWBattleFieldDsbDuelWorldPath, string.format("%s%s", config.small_map_icon, state)), state
  end
  return string.format(LoadPath.LWBattleFieldPath, config.small_map_icon), MiniState.Normal
end

function BattlefieldDsbDuelTemplateManager:GetBattlefieldPreviewSpritePath(detail)
  if not detail then
    return
  end
  local buildId = detail.BuildId
  local config = self:GetBuildTemplate(buildId)
  if config == nil then
    return ""
  end
  if config:IsScoreBox() then
    return string.format(LoadPath.LWBattleFieldPath, "zyf_shuomingjianmian_icon9_huang.png")
  end
  if config:IsRes() then
    return string.format(LoadPath.LWBattleFieldPath, "zyf_shuomingjianmian_icon5_huang.png")
  end
  return self:GetMiniMapSpritePathByBuildId(detail)
end

function BattlefieldDsbDuelTemplateManager:GetMiniState(detail)
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  if curTime < detail.OpenTime then
    return MiniState.Fixing
  end
  local role = detail.Role
  if role == 0 then
    return MiniState.Normal
  end
  if role == BattlefieldDsbDuelUtils.GetMyRoleId() then
    return MiniState.Occupied_Mine
  end
  if role == 1 then
    return MiniState.Occupied_1
  elseif role == 2 then
    return MiniState.Occupied_2
  elseif role == 3 then
    return MiniState.Occupied_3
  elseif role == 4 then
    return MiniState.Occupied_4
  end
  return MiniState.Normal
end

return BattlefieldDsbDuelTemplateManager
