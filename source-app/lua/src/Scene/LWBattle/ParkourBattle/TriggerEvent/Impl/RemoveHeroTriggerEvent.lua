local RemoveHeroTriggerEvent = BaseClass("RemoveHeroTriggerEvent")

function RemoveHeroTriggerEvent:__init()
end

function RemoveHeroTriggerEvent:__delete()
end

function RemoveHeroTriggerEvent:Execute(param)
  for _ = 1, param.para do
    local rand = {}
    local heros = DataCenter.LWBattleManager.logic.team.teamUnits
    for _, hero in pairs(heros) do
      table.insert(rand, hero)
    end
    if 0 < #rand then
      DataCenter.LWBattleManager.logic:DealMemberDie(rand[math.random(#rand)])
    end
  end
end

return RemoveHeroTriggerEvent
