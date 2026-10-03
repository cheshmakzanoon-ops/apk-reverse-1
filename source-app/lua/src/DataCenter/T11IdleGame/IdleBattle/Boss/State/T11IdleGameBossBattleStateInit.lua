local T11IdleGameBossBattleStateInit = BaseClass("T11IdleGameBossBattleStateInit")
local Const = require("DataCenter/T11IdleGame/IdleBattle/T11IdleGameIdleBattleConstant")

function T11IdleGameBossBattleStateInit:__init(logic)
  self.logic = logic
end

function T11IdleGameBossBattleStateInit:__delete()
  self.logic = nil
end

function T11IdleGameBossBattleStateInit:OnEnter()
  if not self.logic then
    return
  end
  self.logic:CreateSceneRoot(function()
    self:OnSceneRootLoaded()
  end)
end

function T11IdleGameBossBattleStateInit:OnExit()
end

function T11IdleGameBossBattleStateInit:OnUpdate()
end

function T11IdleGameBossBattleStateInit:Dispose()
end

function T11IdleGameBossBattleStateInit:OnSceneRootLoaded()
  if not self.logic then
    return
  end
  self.logic:CreateSquad(function()
    self:OnSquadLoaded()
  end)
end

function T11IdleGameBossBattleStateInit:OnSquadLoaded()
  if not self.logic then
    return
  end
  self.logic:OnInitFinish()
end

return T11IdleGameBossBattleStateInit
