local base = require("DataCenter.LWBattle.Logic.SkyBattle.LogicState.BattleBaseState")
local Const = require("Scene.LWBattle.Const")
local BattleExitState = BaseClass("BattleExitState", base)

function BattleExitState:__init(logic)
end

function BattleExitState:__delete()
end

function BattleExitState:OnEnter(state)
  base.OnEnter(self)
  Logger.Log("skyBattle\239\188\154BattleExitState")
  local curPos = self.logic.team:GetPosition()
  local rushXvalue = self.logic:GetParkourRushX()
  self.controlPoint1 = Vector3.New(curPos.x, 0, curPos.z)
  self.controlPoint2 = Vector3.New(rushXvalue, 0, curPos.z + EXIT_CTRL_POINT_OFFSET)
  self.controlPoint3 = Vector3.New(rushXvalue, 0, curPos.z + EXIT_CTRL_POINT_OFFSET + math.abs(rushXvalue - curPos.x))
  self.duration = (math.abs(self.controlPoint3.x - self.controlPoint1.x) + math.abs(self.controlPoint3.z - self.controlPoint1.z)) / EXIT_SPEED
  self.b = Vector3.zero
  self.timeSinceEnter = 0
  self.goStraight = false
  self.logic.team:ChangeStage(state)
  local memberCount = self.logic.team:GetRemainUnitCount()
  self.logic.remainMember = memberCount
  self.logic:CheckToShowWinResult()
end

function BattleExitState:OnUpdate(deltaTime)
  if self.timeSinceEnter then
    self.timeSinceEnter = self.timeSinceEnter + deltaTime
    if self.timeSinceEnter < self.duration then
      local timePercent = self.timeSinceEnter / self.duration
      local a = self.controlPoint1 + (self.controlPoint2 - self.controlPoint1) * timePercent
      local b = self.controlPoint2 + (self.controlPoint3 - self.controlPoint2) * timePercent
      for _, v in pairs(self.logic.team.teamUnits) do
        local member = v
        local offset = member.localPosition
        self.b.x = offset.x + b.x
        self.b.z = offset.z + b.z
        if member.transform then
          member.transform:LookAt(self.b)
        end
      end
      local newPos = a + (b - a) * timePercent
      self.logic.team:SetPosition(newPos.x, newPos.z)
    else
      local deltaT = self.timeSinceEnter - self.duration
      local deltaZ = deltaT * EXIT_SPEED
      self.logic.team:SetPosition(self.controlPoint3.x, self.controlPoint3.z + deltaZ)
      if not self.goStraight then
        self.goStraight = true
        for _, v in pairs(self.logic.team.teamUnits) do
          local member = v
          local offset = member.localPosition
          self.b.x = offset.x + self.controlPoint3.x
          self.b.z = self.controlPoint3.z + 1024
          if member.transform then
            member.transform:LookAt(self.b)
          end
        end
      end
    end
  end
end

function BattleExitState:OnExit()
  base.OnExit(self)
  self.controlPoint1 = nil
  self.controlPoint2 = nil
  self.controlPoint3 = nil
  self.timeSinceEnter = nil
  self.b = nil
end

return BattleExitState
