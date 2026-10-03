local PveHeroEffectTemplate = BaseClass("PveHeroEffectTemplate")

local function __init(self)
end

local function __delete(self)
  self.sound_id_hit = nil
  self.sound_id_dead = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.hit_effect = row:getValue("hit_effect")
  self.hit_effect_direction = tonumber(row:getValue("hit_effect_direction")) or 0
  self.death_effect_nomal = row:getValue("death_effect_nomal")
  local death_blood_path = row:getValue("death_blood_path")
  if not string.IsNullOrEmpty(death_blood_path) then
    local strList = string.split(death_blood_path, "|")
    self.death_blood_path = {}
    for i, v in ipairs(strList) do
      self.death_blood_path[i] = "Assets/Main/Prefabs/LWBattle/" .. v .. ".prefab"
    end
  else
    self.death_blood_path = nil
  end
  self.sound_id_hit = row:getValue("sound_id_hit") or 0
  self.hitVibrateParam = row:getValue("hit_vibrate")
  local shake = row:getValue("death_shake")
  if string.IsNullOrEmpty(shake) then
    self.deathShakeParam = nil
  else
    local strs = string.split(shake, "|")
    self.deathShakeParam = {}
    self.deathShakeParam.duration = tonumber(strs[1])
    self.deathShakeParam.strength = Vector3.New(tonumber(strs[2]), tonumber(strs[3]), tonumber(strs[4]))
    self.deathShakeParam.vibrato = tonumber(strs[5])
  end
  self.sound_id_dead = tonumber(row:getValue("sound_id_dead") or 0)
  self.hit_action = row:getValue("hit_action")
  self.death_action = row:getValue("death_action")
  self.deathVibrateParam = row:getValue("death_vibrate")
  self.hit_effect_num = row:getValue("hit_effect_num") or 0
  self.death_pos = row:getValue("death_pos") or 0
  self.bubble_point_str = row:getValue("bubble_point")
  self.death_effect_blue = row:getValue("death_effect_blue")
  self.death_effect_red = row:getValue("death_effect_red")
  local born_shake = row:getValue("born_shake")
  if string.IsNullOrEmpty(born_shake) then
    self.bornShakeParam = nil
  else
    local strs = string.split(born_shake, "|")
    self.bornShakeParam = {}
    self.bornShakeParam.duration = tonumber(strs[1])
    self.bornShakeParam.strength = Vector3.New(tonumber(strs[2]), tonumber(strs[3]), tonumber(strs[4]))
    self.bornShakeParam.vibrato = tonumber(strs[5])
  end
end

local function GetRandomBlood(self)
  if self.death_blood_path then
    local rand = math.random(#self.death_blood_path)
    return self.death_blood_path[rand]
  end
  return nil
end

function PveHeroEffectTemplate.getters:bubble_point()
  if self._bubble_point == nil then
    self._bubble_point = {}
    if not string.IsNullOrEmpty(self.bubble_point_str) then
      local strArr = string.split(self.bubble_point_str, ";")
      if not table.IsNullOrEmpty(strArr) and table.count(strArr) == 3 then
        self._bubble_point.nodePath = strArr[1]
        self._bubble_point.scale = tonumber(strArr[2])
        self._bubble_point.showThreshold = tonumber(strArr[3])
      end
    end
  end
  return self._bubble_point
end

PveHeroEffectTemplate.__init = __init
PveHeroEffectTemplate.__delete = __delete
PveHeroEffectTemplate.InitData = InitData
PveHeroEffectTemplate.GetRandomBlood = GetRandomBlood
return PveHeroEffectTemplate
