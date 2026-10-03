local BattlefieldBuildTemplate = BaseClass("BattlefieldBuildTemplate")
local MyStrStart = string.startswith

function BattlefieldBuildTemplate:__init(battlefieldType)
  self.battlefieldType = battlefieldType
  self:ResetData()
end

function BattlefieldBuildTemplate:__delete()
  self:ResetData()
end

function BattlefieldBuildTemplate:ResetData()
  self.id = 0
  self.name = 0
  self.rotation = 0
  self.size = 0
  self.type = 0
  self.des = 0
  self.pos_up = ""
  self.pos_down = ""
  self.pic = ""
  self.coordinate = ""
  self.model = ""
  self.small_map_icon = ""
  self.map_icon = ""
  self.protect_time = 0
  self.safe_point_duration = 0
  self.safe_percent = 1
  self.point_produce_per_second = 0
  self.gather_point_per_second = 0
  self.gather_total = 0
  self.point_init = 0
  self.occupy_time = 0
  self.special_effect_number = 0
  self.special_effect_para = nil
  self.hp = 0
  self.aim_time = 0
  self.attack_duration = 0
  self.aim_effect = ""
  self.aim_line_effect = ""
  self.attack_effect = ""
  self.bullet_effect = ""
  self.boom_effect = ""
  self.buff_get_CD = 0
  self.effect = ""
  self.effectInfo = nil
  self.effectList = nil
end

function BattlefieldBuildTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = row:getIntValue("id")
  self.name = row:getValue("name")
  self.rotation = row:getIntValue("rotation")
  self.size = row:getIntValue("size")
  self.type = row:getIntValue("type")
  self.des = row:getValue("des")
  if string.IsNullOrEmpty(self.des) then
    self.des = row:getValue("desc")
  end
  self.pos_up = string.string2array_i_oneSep(row:getValue("pos_up", "0,0,0"), ",")
  self.pos_down = string.string2array_i_oneSep(row:getValue("pos_down", "0,0,0"), ",")
  self.pic = row:getValue("pic")
  self.coordinate = row:getValue("coordinate")
  if not string.IsNullOrEmpty(self.coordinate) then
    self.x, self.y = string.match(self.coordinate, "(%d+)[:,;](%d+)")
    self.mainIndex = SceneUtils.WorldToTileIndex(Vector3.New(toInt(self.x) * TileSize, 0, toInt(self.y) * TileSize), ForceChangeScene.World)
  else
    self.x = 0
    self.y = 0
    self.mainIndex = 0
  end
  self.model = row:getValue("model")
  self.small_map_icon = row:getValue("small_map_icon")
  self.map_icon = row:getValue("map_icon")
  if string.IsNullOrEmpty(self.map_icon) then
    self.map_icon = row:getValue("desc_pic")
  end
  self.protect_time = row:getIntValue("protect_time")
  self.safe_point_duration = row:getIntValue("safe_point_duration")
  self.safe_percent = row:getIntValue("safe_point_percent", 1) / 10000
  self.point_produce_per_second = row:getIntValue("point_produce_per_second")
  self.gather_point_per_second = row:getIntValue("gather_point_per_second")
  if self.gather_point_per_second == 0 then
    self.gather_point_per_second = row:getIntValue("collect_point_per_second")
  end
  self.gather_total = row:getIntValue("gather_total")
  if self.gather_total == 0 then
    self.gather_total = row:getIntValue("collect_total")
  end
  self.point_init = row:getIntValue("point_init")
  self.occupy_time = row:getIntValue("occupy_time")
  self.special_effect_number = row:getIntValue("special_effect_para")
  self.special_effect_para = string.string2array_num_oneSep(row:getValue("special_effect_para"), ",")
  self.hp = row:getIntValue("hp")
  self.aim_time = row:getIntValue("aim_time")
  self.attack_duration = row:getIntValue("attack_duration")
  self.aim_effect = row:getValue("aim_effect")
  self.aim_line_effect = row:getValue("aim_line_effect")
  self.attack_effect = row:getValue("attack_effect")
  self.bullet_effect = row:getValue("bullet_effect")
  self.boom_effect = row:getValue("boom_effect")
  self.buff_get_CD = row:getIntValue("buff_get_CD")
  self.effect = row:getIntValue("effect")
  self.effectInfo = nil
  self.effectList = {}
  if 0 < self.effect and 0 < self.special_effect_number then
    local oneData = {
      id = self.effect,
      value = self.special_effect_number * 0.01,
      num_type = EffectLocalTypeInEffectDesc.Percent,
      nameID = LocalController:instance():getValue("lw_effect_number", self.effect, "name"),
      descID = row:getValue("effect_desc"),
      effect_icon = row:getValue("effect_icon")
    }
    oneData.icon = oneData.effect_icon
    if self.effect == EffectDefine.LW_DRAGON_MV_CD_ADD_PERCENT then
      function oneData.getDesc()
        return Localization:GetString("dsb_duel_tips_1017")
      end
    end
    table.insert(self.effectList, oneData)
    self.effectInfo = oneData
    local mgr = BattleFieldUtil.GetTemplateMgr(self.battlefieldType)
    if mgr then
      mgr:SetEffectInfo(self.effect, oneData)
    end
  end
end

function BattlefieldBuildTemplate:GetModelPath()
  return self.model
end

local ImageBasePath = "Assets/Main/Sprites/UI/UIWinterStorm/Texture/%s"

function BattlefieldBuildTemplate:FixPath(str)
  if MyStrStart(str, "Assets") then
    return str
  end
  local basePath
  if self.battlefieldType == BattleFieldType.Desert then
    basePath = LoadPath.LWBattleFieldDesertDetailPath
  elseif self.battlefieldType == BattleFieldType.WinterStorm then
    basePath = LoadPath.LWBattleFieldWinterDetailPath
  elseif self.battlefieldType == BattleFieldType.EpidemicZone then
    basePath = LoadPath.LWBattleFieldEpidemicDetailPath
  elseif self.battlefieldType == BattleFieldType.DsbDuel then
    basePath = LoadPath.LWBattleFieldDsbDuelDetailPath
  end
  if basePath then
    return string.format(basePath, str)
  end
  return str
end

function BattlefieldBuildTemplate:GetIconPath()
  return self:FixPath(self.pic)
end

function BattlefieldBuildTemplate:GetDetailPath()
  return self:FixPath(self.map_icon)
end

function BattlefieldBuildTemplate:GetRulesIconPath()
  if self.battlefieldType == BattleFieldType.Desert or self.battlefieldType == BattleFieldType.WinterStorm then
    return self:GetDetailPath()
  end
  return self:GetIconPath()
end

function BattlefieldBuildTemplate:IsRes()
  return self.type == BattleFieldBuildType.RES
end

function BattlefieldBuildTemplate:IsScoreBox()
  return self.type == BattleFieldBuildType.SCORE
end

function BattlefieldBuildTemplate:IsPowerTower()
  return self.type == BattleFieldBuildType.POWER
end

function BattlefieldBuildTemplate:IsDefence()
  return self.type == BattleFieldBuildType.DEFENCE
end

function BattlefieldBuildTemplate:IsBuff()
  return self.type == BattleFieldBuildType.BUFF
end

function BattlefieldBuildTemplate:IsBuild()
  return self.type ~= BattleFieldBuildType.SCORE and self.type ~= BattleFieldBuildType.RES
end

function BattlefieldBuildTemplate:ShowHeadUI()
  return self.type ~= BattleFieldBuildType.RES
end

return BattlefieldBuildTemplate
