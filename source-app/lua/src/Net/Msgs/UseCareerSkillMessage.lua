local UseCareerSkillMessage = BaseClass("UseCareerSkillMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, skillId)
  base.OnCreate(self)
  self.sfsObj:PutInt("skillId", skillId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  if t.careerSkill then
    local careerSkill = t.careerSkill
    DataCenter.PlayerCareerManager:UpdateCareerSkills({careerSkill})
    EventManager:GetInstance():Broadcast(EventId.CareerSkillUpdate, careerSkill.skillId)
  end
end

UseCareerSkillMessage.OnCreate = OnCreate
UseCareerSkillMessage.HandleMessage = HandleMessage
return UseCareerSkillMessage
