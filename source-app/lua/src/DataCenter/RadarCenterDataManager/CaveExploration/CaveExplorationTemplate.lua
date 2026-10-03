local CaveExplorationTemplate = BaseClass("CaveExplorationTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = nil
  self.image = nil
  self.icon1 = nil
  self.icon2 = nil
  self.name = nil
  self.description = nil
  self.help = nil
  self.desc_1 = nil
  self.desc_2 = nil
  self.level_reward = nil
  self.nextRewardIcon = nil
  self.nextRewardQuality = nil
  self.confirmTip = nil
  self.reward_deduction = nil
  self.lineType = nil
  self.goods_show = nil
  self.desc_goods_type = nil
  self.other_tips = nil
  self.reward_tips = nil
  self.spine = nil
  self.share_components = nil
end

local function __delete(self)
  self.id = nil
  self.image = nil
  self.icon1 = nil
  self.icon2 = nil
  self.name = nil
  self.description = nil
  self.help = nil
  self.desc_1 = nil
  self.desc_2 = nil
  self.level_reward = nil
  self.nextRewardIcon = nil
  self.nextRewardQuality = nil
  self.reward_deduction = nil
  self.curRewardIcon = nil
  self.curRewardQuality = nil
  self.confirmTip = nil
  self.lineType = nil
  self.goods_show = nil
  self.desc_goods_type = nil
  self.other_tips = nil
  self.reward_tips = nil
  self.share_components = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.image = row:getValue("image")
  self.icon1 = row:getValue("icon1")
  if not string.IsNullOrEmpty(self.icon1) then
    local t = string.split(self.icon1, ";")
    if t and #t == 2 then
      self.icon1Path = t[1]
      self.icon1Pos = {x = 0, y = 0}
      local pos = string.split(t[2], ",")
      if pos and 2 <= #pos then
        self.icon1Pos.x = toInt(pos[1])
        self.icon1Pos.y = toInt(pos[2])
      end
    end
  end
  self.icon2 = row:getValue("icon2")
  if not string.IsNullOrEmpty(self.icon2) then
    local t = string.split(self.icon2, ";")
    if t and #t == 2 then
      self.icon2Path = t[1]
      self.icon2Pos = {x = 0, y = 0}
      local pos = string.split(t[2], ",")
      if pos and 2 <= #pos then
        self.icon2Pos.x = toInt(pos[1])
        self.icon2Pos.y = toInt(pos[2])
      end
    end
  end
  self.name = row:getValue("name")
  self.description = row:getValue("description")
  self.help = row:getValue("help")
  self.level_reward = toInt(row:getValue("level_reward"))
  self.desc_1 = row:getValue("desc_1")
  if not string.IsNullOrEmpty(self.desc_1) then
    local t = string.split(self.desc_1, "|")
    if t and #t == 2 then
      self.entranceIcon1 = t[1]
      self.entranceDes1 = t[2]
    elseif t and #t == 3 then
      self.entranceIcon1 = t[1]
      self.entranceDes1 = t[2]
      self.entranceDesParam1 = t[3]
    end
  end
  self.desc_2 = row:getValue("desc_2")
  if not string.IsNullOrEmpty(self.desc_2) then
    local t = string.split(self.desc_2, "|")
    if t and #t == 2 then
      self.entranceIcon2 = t[1]
      self.entranceDes2 = t[2]
    elseif t and #t == 3 then
      self.entranceIcon2 = t[1]
      self.entranceDes2 = t[2]
      self.entranceDesParam2 = t[3]
    end
  end
  local descType = row:getValue("desc_1_type")
  if not string.IsNullOrEmpty(descType) then
    local t = string.split(descType, "|")
    if t and #t == 2 then
      self.entranceType1 = toInt(t[1])
      if self.entranceType1 ~= 1 then
        self.entranceParam1 = t[2]
      end
    end
  else
    self.entranceType1 = 0
  end
  descType = row:getValue("desc_2_type")
  if not string.IsNullOrEmpty(descType) then
    local t = string.split(descType, "|")
    if t and #t == 2 then
      self.entranceType2 = toInt(t[1])
      if self.entranceType2 ~= 1 then
        self.entranceParam2 = t[2]
      end
    end
  else
    self.entranceType2 = 0
  end
  local next_level_reward_icon = row:getValue("next_level_reward_icon")
  if not string.IsNullOrEmpty(next_level_reward_icon) then
    local t = string.split(next_level_reward_icon, ",")
    if t and #t == 2 then
      self.nextRewardIcon = t[1]
      self.nextRewardQuality = toInt(t[2])
    elseif t and #t == 1 then
      self.nextRewardIcon = t[1]
    end
  end
  local level_reward_icon = row:getValue("level_reward_icon")
  if not string.IsNullOrEmpty(level_reward_icon) then
    local t = string.split(level_reward_icon, ",")
    if t and #t == 2 then
      self.curRewardIcon = t[1]
      self.curRewardQuality = toInt(t[2])
    elseif t and #t == 1 then
      self.curRewardIcon = t[1]
    end
  end
  local desc_1_second_confirmation = row:getValue("desc_1_second_confirmation")
  if not string.IsNullOrEmpty(desc_1_second_confirmation) then
    local t = string.split(desc_1_second_confirmation, ",")
    if t and #t == 2 then
      local dialog = t[1]
      local param = t[2]
      self.confirmTip = Localization:GetString(dialog, param)
    end
  end
  self.reward_deduction = row:getIntValue("reward_deduction")
  self.lineType = row:getIntValue("type")
  self.goods_show = row:getIntValue("goods_show")
  self.desc_goods_type = row:getValue("desc_goods_type")
  self.other_tips = row:getValue("other_tips")
  self.reward_tips = row:getValue("reward_tips")
  self.spine = row:getValue("spine")
  self.share_components = toInt(row:getValue("share_components"))
end

function CaveExplorationTemplate:GetTypeByIndex(idx)
  if idx == 1 then
    return self.entranceType1
  elseif idx == 2 then
    return self.entranceType2
  else
    return 0
  end
end

function CaveExplorationTemplate:Description()
  return self.id and tostring(self.id) or "???"
end

function CaveExplorationTemplate:CanShowGoods()
  return self.goods_show ~= 0
end

function CaveExplorationTemplate:CanUseGoods()
  return not string.IsNullOrEmpty(self.desc_goods_type)
end

function CaveExplorationTemplate:GetCostCout()
  if not self:CanUseGoods() then
    return 0
  end
  return toInt(string.split(self.desc_goods_type, ",")[2])
end

function CaveExplorationTemplate:GetSpineInfo()
  if string.IsNullOrEmpty(self.spine) then
    return nil
  end
  local spineStr = string.split(self.spine, "|")
  local spineInfo = {}
  for index = 1, #spineStr do
    local nameTable = {}
    local spineAnim = spineStr[index]
    local spineNameStr = string.split(spineAnim, ",")
    for nameIndex = 1, #spineNameStr do
      nameTable[nameIndex] = {
        animName = spineNameStr[nameIndex]
      }
    end
    spineInfo[index] = {anims = nameTable}
  end
  return spineInfo
end

CaveExplorationTemplate.__init = __init
CaveExplorationTemplate.__delete = __delete
CaveExplorationTemplate.InitData = InitData
return CaveExplorationTemplate
