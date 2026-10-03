local LWSoundTemplate = BaseClass("LWSoundTemplate")

local function __init(self)
  self.id = 0
  self.sound_num = 0
  self.sound_time = 0
  self.sound = {}
  self.soundPath2 = {}
  self.sound_type = 0
  self.sound_set = -1
  self.sound_volume = 1
  self.sound_change = false
  self.reactive = -1
  self.loop_gap = -1
  self.pre_time = -1
  self.speed = 1
  self.usePath2 = false
  self.soundPathTable = {}
  self.audioSource = {}
  self.soundDelayMin = 0
  self.soundDelayMax = 0
  self.instanceGroupId = 0
  self.instanceLimit = 0
  self.whenPriorityEqual = 0
  self.fadeIn = 0
  self.fadeOut = 0
  self.loop = 0
  self.loopEndGap = 0
  self.randomType = 0
  self.randomPitchMin = -1
  self.randomPitchMax = -1
  self.randomVolumeMin = -1
  self.randomVolumeMax = -1
end

local function __delete(self)
  self.id = nil
  self.sound_num = nil
  self.sound_time = nil
  self.sound = nil
  self.soundPath2 = nil
  self.sound_type = nil
  self.sound_set = nil
  self.sound_volume = nil
  self.sound_change = nil
  self.reactive = nil
  self.loop_gap = nil
  self.pre_time = nil
  self.speed = nil
  self.usePath2 = nil
  self.soundPathTable = nil
  self.audioSource = nil
  self.soundDelayMin = nil
  self.soundDelayMax = nil
  self.instanceGroupId = nil
  self.instanceLimit = nil
  self.whenPriorityEqual = nil
  self.fadeIn = nil
  self.fadeOut = nil
  self.loop = nil
  self.loopEndGap = nil
  self.randomType = nil
  self.randomPitchMin = nil
  self.randomPitchMax = nil
  self.randomVolumeMin = nil
  self.randomVolumeMax = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.sound_num = row:getValue("sound_num") or 0
  self.sound_time = row:getValue("sound_time") or 0
  local soundStr = row:getValue("sound")
  self.sound = StringPool.New(soundStr, ";")
  local sound2Str = row:getValue("sound2")
  self.soundPath2 = StringPool.New(sound2Str, ";")
  self.sound_type = tonumber(row:getValue("sound_type")) or 0
  self.sound_set = tonumber(row:getValue("sound_set")) or -1
  self.sound_volume = tonumber(row:getValue("sound_volume")) or 1
  self.sound_change = (tonumber(row:getValue("sound_change")) or 0) == 1
  self.reactive = tonumber(row:getValue("reactive")) or -1
  self.loop_gap = tonumber(row:getValue("loop_gap")) or -1
  self.pre_time = tonumber(row:getValue("pre_time")) or -1
  local speedStr = row:getValue("speed")
  local speedTemp = 1
  if not string.IsNullOrEmpty(speedStr) then
    speedTemp = tonumber(speedStr)
  end
  self.speed = speedTemp
  if string.IsNullOrEmpty(soundStr) and not string.IsNullOrEmpty(sound2Str) then
    self.usePath2 = true
    self.soundPathTable = self.soundPath2.pool
  else
    self.usePath2 = false
  end
  self.audioSource = row:getValue("audiosource") or ""
  local delayStr = tostring(row:getValue("sound_delay_play") or "0")
  local delayArr = string.split(delayStr, ",")
  self.soundDelayMin = tonumber(delayArr[1]) or 0
  self.soundDelayMax = tonumber(delayArr[2] or delayArr[1]) or self.soundDelayMin
  if self.soundDelayMin > self.soundDelayMax then
    self.soundDelayMin, self.soundDelayMax = self.soundDelayMax, self.soundDelayMin
  end
  self.instanceGroupId = tonumber(row:getValue("max_instances_group_id")) or 0
  self.instanceLimit = tonumber(row:getValue("sound_instance_limit")) or 0
  self.whenPriorityEqual = tonumber(row:getValue("when_priority_equal")) or -1
  self.fadeIn = tonumber(row:getValue("fade_in")) or 0
  self.fadeOut = tonumber(row:getValue("fade_out")) or 0
  self.loop = tonumber(row:getValue("loop")) or 0
  self.loopEndGap = tonumber(row:getValue("loop_end_gap")) or 0
  self.randomType = tonumber(row:getValue("random")) or 0
  local randomPitchStr = row:getValue("random_pitch") or ""
  if not string.IsNullOrEmpty(randomPitchStr) then
    local randomPitch = string.split(randomPitchStr, ",")
    if #randomPitch == 1 then
      self.randomPitchMin = tonumber(randomPitch[1]) or -1
      self.randomPitchMax = tonumber(randomPitch[1]) or -1
    else
      self.randomPitchMin = tonumber(randomPitch[1]) or -1
      self.randomPitchMax = tonumber(randomPitch[2]) or -1
    end
  end
  local randomVolumeStr = row:getValue("random_volume") or ""
  if not string.IsNullOrEmpty(randomVolumeStr) then
    local randomVolume = string.split(randomVolumeStr, ",")
    if #randomVolume == 1 then
      self.randomVolumeMin = tonumber(randomVolume[1]) or -1
      self.randomVolumeMax = tonumber(randomVolume[1]) or -1
    else
      self.randomVolumeMin = tonumber(randomVolume[1]) or -1
      self.randomVolumeMax = tonumber(randomVolume[2]) or -1
    end
  end
end

LWSoundTemplate.__init = __init
LWSoundTemplate.__delete = __delete
LWSoundTemplate.InitData = InitData
return LWSoundTemplate
