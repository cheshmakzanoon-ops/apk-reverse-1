local PveHeroManager = BaseClass("PveHeroManager")

local function __init(self)
  self.curHeroes = {}
  self.haveHeroesFromMessage = false
  self.banHeroIds = {}
  self.hiredHeroes = {}
end

local function __delete(self)
  self.curHeroes = nil
  self.haveHeroesFromMessage = nil
  self.banHeroIds = nil
  self.hiredHeroes = nil
end

local function GetCurHeroes(self)
  return self.curHeroes
end

local function SetCurHeroes(self, curHeroes)
  self.curHeroes = curHeroes
end

local function HaveHeroesFromMessage(self)
  return self.haveHeroesFromMessage or false
end

local function ClearCurHeroes(self)
  self.curHeroes = {}
end

local function UpdateCurHeroesFromMessage(self, message)
  self.curHeroes = {}
  if not table.IsNullOrEmpty(message.heroes) then
    local list = {}
    for _, v in ipairs(message.heroes) do
      local heroData = DataCenter.BattleLevel:GetPveHeroData(v.uuid)
      if heroData ~= nil then
        table.insert(list, v)
      end
    end
    table.sort(list, function(a, b)
      return a.index < b.index
    end)
    for _, v in ipairs(list) do
      table.insert(self.curHeroes, v.uuid)
    end
    self.haveHeroesFromMessage = true
  else
    self.haveHeroesFromMessage = false
  end
end

local function UseDefaultHeroes(self)
  if table.IsNullOrEmpty(self.curHeroes) then
    self.curHeroes = {}
    local heroes = DataCenter.HeroDataManager:GetHeroSortList()
    for i, v in ipairs(heroes) do
      self.curHeroes[i] = v.uuid
      if 5 < i then
        break
      end
    end
  end
end

local function ClearBanHeroIds(self)
  self.banHeroIds = {}
end

local function BanHero(self, heroId)
  if table.hasvalue(self.banHeroIds, heroId) then
    return
  end
  table.insert(self.banHeroIds, heroId)
  for i, heroUuid in ipairs(self.curHeroes) do
    local heroData = DataCenter.BattleLevel:GetPveHeroData(heroUuid)
    if heroData.heroId == heroId then
      DataCenter.BattleLevel:OnHeroChanged(i, heroUuid, false)
      table.remove(self.curHeroes, i)
      SFSNetwork.SendMessage(MsgDefines.UserResetPVEHero, self.levelId, self.curHeroes)
      PveActorMgr:GetInstance():SetHeros(self.curHeroes)
      DataCenter.BattleLevel.uiPveMain:SetHeroes(self.curHeroes)
      break
    end
  end
end

local function IsHeroBanned(self, heroId)
  return table.hasvalue(self.banHeroIds, heroId)
end

local function ClearHiredHeroes(self)
  self.hiredHeroes = {}
end

local function UpdateHiredHeroes(self, pveBuffs)
  self.hiredHeroes = {}
  for _, v in ipairs(pveBuffs) do
    local heroData = HeroUtils.GetHireHeroDataByBattleBuff(v.bId)
    if heroData ~= nil then
      if heroData.usedCount < heroData.totalCount then
        self.hiredHeroes[heroData.uuid] = heroData
      else
        self.hiredHeroes[heroData.uuid] = nil
      end
    end
  end
end

local function GetHiredHeroByUuid(self, heroUuid)
  return self.hiredHeroes[heroUuid]
end

local function GetHiredHeroes(self)
  return self.hiredHeroes
end

PveHeroManager.__init = __init
PveHeroManager.__delete = __delete
PveHeroManager.GetCurHeroes = GetCurHeroes
PveHeroManager.SetCurHeroes = SetCurHeroes
PveHeroManager.HaveHeroesFromMessage = HaveHeroesFromMessage
PveHeroManager.ClearCurHeroes = ClearCurHeroes
PveHeroManager.UpdateCurHeroesFromMessage = UpdateCurHeroesFromMessage
PveHeroManager.UseDefaultHeroes = UseDefaultHeroes
PveHeroManager.ClearBanHeroIds = ClearBanHeroIds
PveHeroManager.BanHero = BanHero
PveHeroManager.IsHeroBanned = IsHeroBanned
PveHeroManager.ClearHiredHeroes = ClearHiredHeroes
PveHeroManager.UpdateHiredHeroes = UpdateHiredHeroes
PveHeroManager.GetHiredHeroByUuid = GetHiredHeroByUuid
PveHeroManager.GetHiredHeroes = GetHiredHeroes
return PveHeroManager
