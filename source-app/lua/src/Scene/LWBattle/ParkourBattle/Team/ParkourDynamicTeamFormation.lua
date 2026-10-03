local base = require("Scene.LWBattle.ParkourBattle.Team.ParkourFormation")
local ParkourDynamicTeamFormation = BaseClass("ParkourDynamicTeamFormation", base)
local Const = require("Scene.LWBattle.ParkourBattle.Team.ParkourDynamicTeamConst")
local BattleConst = require("Scene.LWBattle.Const")

function ParkourDynamicTeamFormation:__init(defaultPosMax, defaultHero, posMax)
  if posMax then
    self.defaultPosMax = posMax
  else
    self.defaultPosMax = defaultPosMax
  end
  self.defaultHero = defaultHero
  self.formationPos = nil
  self.dynamicPos = nil
  self.formationPosCount = 0
  self.dynamicPosCount = 0
  self.posCount = 0
  self.dynamicSize = nil
  self.dynamicBasePosInfo = nil
  self.inFormationHeroIds = nil
end

function ParkourDynamicTeamFormation:__delete()
  self.defaultHero = nil
  self.dynamicPosMax = nil
  self.formationPos = nil
  self.dynamicPos = nil
  self.formationPosCount = nil
  self.dynamicPosCount = nil
  self.posCount = nil
  self.dynamicSize = nil
  self.dynamicBasePosInfo = nil
end

function ParkourDynamicTeamFormation:Init(initBattleFormation, backwards, defense, formationSpecialType)
  base.Init(self, initBattleFormation, backwards, defense, formationSpecialType)
  self.hasFormationPos = not initBattleFormation
  if self.hasFormationPos then
    self.formationSpecialType = formationSpecialType
    if formationSpecialType then
      self:ReInitHeroPos(initBattleFormation, formationSpecialType, true)
      self:SetFormationCount(#self.formationPos)
    else
      if initBattleFormation then
        self.formationPos = {
          [1] = Vector3.New(-1.8, 0, 2.5),
          [2] = Vector3.New(1.8, 0, 2.5),
          [3] = Vector3.New(-2.9, 0, 0),
          [4] = Vector3.New(0, 0, 0),
          [5] = Vector3.New(2.9, 0, 0)
        }
      else
        self.formationPos = {
          [1] = Vector3.New(-2.3, 0, 2.5),
          [2] = Vector3.New(2.3, 0, 2.5),
          [3] = Vector3.New(-3.3, 0, -1.5),
          [4] = Vector3.New(0, 0, -1.5),
          [5] = Vector3.New(3.3, 0, -1.5)
        }
      end
      self:SetFormationCount(5)
    end
    self.dynamicSize = Const.HeroSize[Const.SizeLevel.Level1]
    local dynamicPosType = Const.PosType.CenterHero
    self.dynamicBasePosInfo = Const.PosInfo[dynamicPosType]
    self.dynamicPosMax = math.min(self.defaultPosMax, #self.dynamicBasePosInfo)
  else
    self.dynamicSize = self:GetMaxSizeByHeroStr(self.defaultHero)
    local dynamicPosType = Const.PosType.Normal
    self.dynamicBasePosInfo = Const.PosInfo[dynamicPosType]
    self.dynamicPosMax = math.min(self.defaultPosMax, #self.dynamicBasePosInfo)
  end
  self.dynamicPos = {}
  self:SetDynamicPosCount(0)
  self.canResize = self.dynamicPosCount <= self.dynamicPosMax
end

function ParkourDynamicTeamFormation:ChangeToBattleFormation(teamUnits)
  base.ChangeToBattleFormation(self)
  if teamUnits then
    self.inFormationHeroIds = {}
    for i, v in pairs(teamUnits) do
      self.inFormationHeroIds[i] = v.hero.heroId
    end
  end
  if string.IsNullOrEmpty(self.defaultHero) then
    self:ReSize(self.posCount, true)
  end
end

function ParkourDynamicTeamFormation:GetOffsetByIndex(index)
  base.GetOffsetByIndex(self, index)
  if index <= self.formationPosCount then
    return self.formationPos[index]
  end
  index = index - self.formationPosCount
  if index <= self.dynamicPosCount then
    return self.dynamicPos[index]
  end
  return self.dynamicPos[self.dynamicPosMax]
end

function ParkourDynamicTeamFormation:ReSize(index, force)
  base.ReSize(self, index, force)
  if not self.canResize then
    return self.posCount
  end
  if self.hasFormationPos then
    local addCount = index - self.formationPosCount
    if addCount <= 0 and not force then
      return self.formationPosCount
    end
    if force then
      if self.formationSpecialType then
        self:ReInitHeroPos(true, self.formationSpecialType, false)
      elseif self.formationPos == nil then
        self.formationPos = {
          [1] = Vector3.New(-1.8, 0, 2.5),
          [2] = Vector3.New(1.8, 0, 2.5),
          [3] = Vector3.New(-2.9, 0, 0),
          [4] = Vector3.New(0, 0, 0),
          [5] = Vector3.New(2.9, 0, 0)
        }
      else
        self.formationPos[1] = Vector3.New(-1.8, 0, 2.5)
        self.formationPos[2] = Vector3.New(1.8, 0, 2.5)
        self.formationPos[3] = Vector3.New(-2.9, 0, 0)
        self.formationPos[4] = Vector3.New(0, 0, 0)
        self.formationPos[5] = Vector3.New(2.9, 0, 0)
      end
      self:ResetDynamicBasePosByHeroPos()
    end
  end
  local dynamicIndex = math.min(index - self.formationPosCount, self.dynamicPosMax)
  if dynamicIndex > self.dynamicPosCount then
    local start = self.dynamicPosCount + 1
    local heroSize = self.dynamicSize
    for i = start, dynamicIndex do
      local posInfo = self.dynamicBasePosInfo[i]
      table.insert(self.dynamicPos, Vector3.New(posInfo[1] * heroSize, 0, posInfo[2] * heroSize))
    end
    self:SetDynamicPosCount(#self.dynamicPos)
  end
  self.canResize = self.dynamicPosCount <= self.dynamicPosMax
  return self.posCount
end

function ParkourDynamicTeamFormation:GetWeaponPos()
  base.GetWeaponPos(self)
  if self.formationPosCount > 0 then
    return self.formationPos[1]
  end
  return self.dynamicPos[1]
end

function ParkourDynamicTeamFormation:ReInitHeroPos(initBattleFormation, formationSpecialType, force)
  local formationPos = BattleConst.ParkourSpecialCircleTeamFormationPosition.UnInitBattleFormation[formationSpecialType]
  if initBattleFormation then
    formationPos = BattleConst.ParkourSpecialCircleTeamFormationPosition.InitBattleFormation[formationSpecialType]
  end
  if self.formationPos == nil or force then
    self.formationPos = {}
    for i = 1, #formationPos do
      self.formationPos[i] = formationPos[i]:Clone()
    end
  else
    for i = 1, #formationPos do
      self.formationPos[i] = formationPos[i]:Clone()
    end
  end
end

function ParkourDynamicTeamFormation:ResetDynamicPos()
  self:ResetDynamicBasePosByHeroPos()
  local heroSize = self.dynamicSize
  for i, v in ipairs(self.dynamicPos) do
    local info = self.dynamicBasePosInfo[i]
    if info then
      v.x = info[1] * heroSize
      v.z = info[2] * heroSize
    else
      v.x = v.x * heroSize
      v.z = v.z * heroSize
    end
  end
end

function ParkourDynamicTeamFormation:GetMaxSizeByHeroStr(hero)
  hero = tostring(hero)
  local split = string.split(hero, "|")
  local size = Const.SizeLevel.Level1
  for i, v in ipairs(split) do
    local curSize = self:GetSizeByHeroId(v)
    if size < curSize then
      size = curSize
    end
  end
  return size
end

function ParkourDynamicTeamFormation:GetSizeByHeroId(heroId)
  local size = Const.HeroSize[Const.SizeLevel.Level2]
  local heroCfg = DataCenter.HeroTemplateManager:GetTemplate(heroId)
  if heroCfg and heroCfg.appearance then
    local cfg = DataCenter.AppearanceTemplateManager:GetTemplate(heroCfg.appearance)
    if cfg and cfg.dynamicPosSize and cfg.dynamicPosSize > 0 then
      size = cfg.dynamicPosSize
    end
  end
  return size
end

function ParkourDynamicTeamFormation:OnReplaceAppearance(newHeroId)
  local size = self:GetSizeByHeroId(newHeroId)
  if self.dynamicSize and size > self.dynamicSize then
    self.dynamicSize = size
    self:ResetDynamicPos()
    return true
  end
  return false
end

function ParkourDynamicTeamFormation:ResetDynamicBasePosByHeroPos()
  if self.inFormationHeroIds == nil then
    return
  end
  local newBaseInfo = {}
  local curSize = self.dynamicSize
  for i, v in ipairs(Const.PosInfo[Const.PosType.CenterHero]) do
    local canAdd = true
    for j = 1, self.formationPosCount do
      local heroSize = curSize
      if self.inFormationHeroIds[j] then
        heroSize = self:GetSizeByHeroId(self.inFormationHeroIds[j])
      end
      local heroPos = self.formationPos[j]
      local dx = heroPos.x - v[1] * curSize
      local dz = heroPos.z - v[2] * curSize
      local r = (curSize + heroSize) / 2
      canAdd = dx * dx + dz * dz > r * r
      if not canAdd then
        break
      end
    end
    if canAdd then
      table.insert(newBaseInfo, v)
    end
  end
  self.dynamicBasePosInfo = newBaseInfo
  self.dynamicPosMax = math.min(self.defaultPosMax, #self.dynamicBasePosInfo)
end

function ParkourDynamicTeamFormation:SetFormationCount(count)
  self.formationPosCount = count
  self.posCount = self.formationPosCount + self.dynamicPosCount
end

function ParkourDynamicTeamFormation:SetDynamicPosCount(count)
  self.dynamicPosCount = count
  self.posCount = self.formationPosCount + self.dynamicPosCount
end

local function GenDynamicPos()
  local size = 13
  local tab = CS.CSUtils.PoissonDiscSampler(1, size, size)
  local pos = {}
  for i = 0, tab.Length - 1 do
    local x = tab[i].x - size / 2
    local y = tab[i].y - size / 2
    if math.sqrt(x * x + y * y) <= size / 2 then
      table.insert(pos, {x, y})
    end
  end
  
  local function distance(p)
    local dx = p[1]
    local dz = p[2]
    return math.sqrt(dx * dx + dz * dz)
  end
  
  table.sort(pos, function(a, b)
    return distance(a) < distance(b)
  end)
  return pos
end

function ParkourDynamicTeamFormation:ReGenDynamicPos()
  self.dynamicBasePosInfo = GenDynamicPos(self)
  self.dynamicPosMax = math.min(self.defaultPosMax, #self.dynamicBasePosInfo)
  self:ResetDynamicPos()
end

return ParkourDynamicTeamFormation
