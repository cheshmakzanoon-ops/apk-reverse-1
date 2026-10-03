local PveSkillEffectTemplate = BaseClass("PveSkillEffectTemplate")

local function __init(self)
end

local function __delete(self)
  self.moveEffectTargetPos = nil
  self.moveEffectMoveTime = nil
  self.moveEffectLifeTime = nil
  self.moveEffectResPath = nil
  self.sound_id_fire_1 = nil
  self.sound_id_fire_2 = nil
  self.fireShakeParam = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.fire_action = row:getValue("fire_action")
  self.fire_effect = row:getValue("fire_effect")
  self.cast_effect = row:getValue("cast_effect")
  self.warn_effect = row:getValue("warn_effect")
  self.fire_effect_time = tonumber(row:getValue("fire_effect_time")) or 0
  self.cast_effect_time = tonumber(row:getValue("cast_effect_time")) or 0
  self.warn_effect_time = tonumber(row:getValue("warn_effect_time")) or 0
  self.warn_effect_bullet = row:getValue("warn_effect_bullet") == "1"
  self.fire_effect_bullet = row:getValue("fire_effect_bullet") == 1
  self.fire_effect_time = self.fire_effect_time * 0.001
  self.cast_effect_time = self.cast_effect_time * 0.001
  self.warn_effect_time = self.warn_effect_time * 0.001
  self.fire_delay = tonumber(row:getValue("fire_delay")) or 0
  self.fire_delay = self.fire_delay * 0.001
  self.sound_id_fire_1 = tonumber(row:getValue("sound_id_fire_1") or 0)
  self.sound_id_fire_2 = tonumber(row:getValue("sound_id_fire_2") or 0)
  local shake = row:getValue("fire_shake")
  if string.IsNullOrEmpty(shake) then
    self.fireShakeParam = nil
  else
    local strs = string.split(shake, "|")
    self.fireShakeParam = {
      duration = tonumber(strs[1]),
      strength = Vector3.New(tonumber(strs[2]), tonumber(strs[3]), tonumber(strs[4])),
      vibrato = tonumber(strs[5])
    }
  end
  self.fireVibrateParam = row:getValue("fire_vibrate")
  self.position_effect = row:getValue("position_effect")
  if self.position_effect and 4 <= #self.position_effect and not string.IsNullOrEmpty(self.position_effect[1]) then
    local posStringList = string.split(self.position_effect[1], ";")
    self.moveEffectTargetPos = {
      tonumber(posStringList[1]),
      tonumber(posStringList[2])
    }
    self.moveEffectMoveTime = tonumber(self.position_effect[2]) * 0.001
    self.moveEffectLifeTime = tonumber(self.position_effect[3]) * 0.001 + self.moveEffectMoveTime
    self.moveEffectResPath = self.position_effect[4]
  end
  self.bone_effect_slot = row:getValue("bone_effect_slot")
end

PveSkillEffectTemplate.__init = __init
PveSkillEffectTemplate.__delete = __delete
PveSkillEffectTemplate.InitData = InitData
return PveSkillEffectTemplate
