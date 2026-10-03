local PushPushBattleMonsterFailMessage = BaseClass("PushPushBattleMonsterFailMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushPushBattleMonsterFailMessage:OnCreate()
  base.OnCreate(self)
end

function PushPushBattleMonsterFailMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  local errCode = message.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(message.monsterId)
    local data = {changeTitle = true, monsterConfig = monster}
    if monster ~= nil then
      local resistance_type = toInt(monster.resistance_type)
      if monster.monster_resistance > 0 then
        data.resistance = monster.monster_resistance + SeasonUtil.GetBloodyNightResistanceValueAdd()
      else
        data.resistance = 0
      end
      data.selfValue = SeasonUtil.GetSelfSeasonResistanceValue()
      data.selfPercent = SeasonUtil.GetSeasonResistanceSelf(data.selfValue, data.resistance, resistance_type) - 1
      data.otherPercent = SeasonUtil.GetSeasonResistanceOther(data.selfValue, data.resistance, resistance_type)
      UIUtil.ShowResistanceWarning(data, false, nil)
    end
  end
end

return PushPushBattleMonsterFailMessage
