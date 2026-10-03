local UILWHeroHOFPanelCtrl = BaseClass("UILWHeroHOFPanelCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWHeroHOF, {anim = true, playEffect = false})
end

local function GetHeroesByType(self, type)
  local typeHeroes = DataCenter.HeroDataManager:GetHeroesByType(type)
  local heroes = {}
  for i, v in pairs(typeHeroes) do
    if v:IsUnlockHonorWall() then
      table.insert(heroes, v)
    end
  end
  table.sort(heroes, function(a, b)
    if a.quality == b.quality then
      return a.heroId < b.heroId
    else
      return a.quality > b.quality
    end
  end)
  local heroesUuid = {}
  for i, v in pairs(heroes) do
    table.insert(heroesUuid, v.uuid)
  end
  return heroesUuid
end

local function CollectHeroesEffect(self, heroes)
  local effects = {}
  for i, heroInfo in pairs(heroes) do
    if heroInfo then
      local heroEffects = heroInfo:CollectHonorEffect()
      for key, value in pairs(heroEffects) do
        if not effects[key] then
          effects[key] = 0
        end
        effects[key] = effects[key] + value
      end
    end
  end
  return effects
end

UILWHeroHOFPanelCtrl.CloseSelf = CloseSelf
UILWHeroHOFPanelCtrl.GetHeroesByType = GetHeroesByType
UILWHeroHOFPanelCtrl.CollectHeroesEffect = CollectHeroesEffect
return UILWHeroHOFPanelCtrl
