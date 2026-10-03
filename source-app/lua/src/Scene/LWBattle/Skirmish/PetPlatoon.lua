local Base = require("Scene.LWBattle.Skirmish.BasePlatoon")
local PetPlatoon = BaseClass("PetPlatoon", Base)
local PetCaptain = require("Scene.LWBattle.Skirmish.Unit.PetCaptain")

function PetPlatoon:__init(logic, army, index, captainInitShowState, param)
  Base.__init(self, logic, army, index, captainInitShowState)
  self.heroData = param
  self.index = self.heroData.index
  self:CreateCaptain()
end

function PetPlatoon:CreateCaptain()
  self.captain = ObjectPool:GetInstance():Load(PetCaptain)
  self.captain:Init(self.logic, self, self.heroData, Vector3.zero, self.index, self.captainInitShowState)
  self.logic:AddCaptain(self.index, self.captain)
  self.logic:AddUnit(self.captain)
end

function PetPlatoon:Destroy()
  self.logic:RemoveUnit(self.captain)
  Base.Destroy(self)
end

function PetPlatoon:ChangeStage(stage)
  if stage == SkirmishStage.Load then
  elseif stage == SkirmishStage.Opening then
  end
  self.captain:ChangeStage(stage)
end

function PetPlatoon:StopMoving()
  self.captain:StopMoving()
  self.isMoving = false
end

return PetPlatoon
