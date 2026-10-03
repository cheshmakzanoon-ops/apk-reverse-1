local base = require("Scene.LWBattle.Skirmish.Unit.Captain")
local PetCaptain = BaseClassCache("Captain", base)
local FireStateBorn = require("Scene.LWBattle.Skirmish.UnitFSM.FireStateBorn")

function PetCaptain:DataDefine(heroData)
  base.DataDefine(self, heroData)
  local petId = heroData.summonId
  if petId and 0 < petId then
    local petTemplate = DataCenter.CommonSimpleTemplateManager:GetTemplate(TableName.LW_SUMMONS, petId)
    local searchType, layer, showHPBar = PveUtil.GetPetInfo(petTemplate.target_rule)
    self.heroId = petTemplate.heroId
    self.showHPBar = showHPBar
  end
end

function PetCaptain:TryCheckAliveTime()
  if self.expireTime > 0 and self.logic and self.logic.GetFightTime and self.expireTime <= self.logic:GetFightTime() then
    self.curBlood = 0
    self:GoDie()
    self.startCheckDeath = false
  end
end

function PetCaptain:OnUpdate(deltaTime)
  base.OnUpdate(self, deltaTime)
  self:TryCheckAliveTime()
end

function PetCaptain:InitFSM()
  base.InitFSM(self)
  self.fsm:AddState(SkirmishFireState.Born, FireStateBorn.New(self))
  self.fsm:ChangeState(SkirmishFireState.Born)
end

return PetCaptain
