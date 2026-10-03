local HeroStationUseSkillMessage = BaseClass("HeroStationUseSkillMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, skillId)
  base.OnCreate(self)
  self.sfsObj:PutInt("skillId", skillId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.HeroStationManager:HandleHeroStationUseSkillMessage(t)
end

HeroStationUseSkillMessage.OnCreate = OnCreate
HeroStationUseSkillMessage.HandleMessage = HandleMessage
return HeroStationUseSkillMessage
