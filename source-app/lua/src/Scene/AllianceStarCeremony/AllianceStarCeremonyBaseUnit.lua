local PlayerShow = require("Scene.PlayerShow.PlayerShow")
local AllianceStarCeremonyBaseUnit = BaseClass("AllianceStarCeremonyBaseUnit")

function AllianceStarCeremonyBaseUnit:__init()
  self.playerShow = nil
end

function AllianceStarCeremonyBaseUnit:__delete()
  self.inited = nil
  self.skinParam = nil
  if self.playerShow then
    self.playerShow:Delete()
    ObjectPool:GetInstance():Save(self.playerShow)
    self.playerShow = nil
  end
end

function AllianceStarCeremonyBaseUnit:Init(skinParam)
  self.inited = true
  self.skinParam = skinParam
  local loadResCallback = self.skinParam.loadResCallback
  
  function self.skinParam.loadResCallback(obj)
    self:LoadResCallback(obj)
    if loadResCallback then
      loadResCallback(obj)
    end
  end
  
  self.playerShow = ObjectPool:GetInstance():Load(PlayerShow)
  self.playerShow:Init(skinParam)
end

function AllianceStarCeremonyBaseUnit:SetPosition(pos)
  self.playerShow:SetPosition(pos)
end

function AllianceStarCeremonyBaseUnit:GetPosition()
  return self.playerShow:GetPosition()
end

function AllianceStarCeremonyBaseUnit:PlaySimpleAnim(name, speed)
  self.playerShow:PlaySimpleAnim(name, speed)
end

function AllianceStarCeremonyBaseUnit:SampleAnimationAtTime(name, time)
  self.playerShow:SampleAnimationAtTime(name, time)
end

function AllianceStarCeremonyBaseUnit:PlaySampleAnimationAtTime(name, normalizedTime, speed)
  self.playerShow:PlaySampleAnimationAtTime(name, normalizedTime, speed)
end

function AllianceStarCeremonyBaseUnit:GetAnimLength(name)
  return self.playerShow:GetAnimLength(name)
end

function AllianceStarCeremonyBaseUnit:PlayQueued(name)
  self.playerShow:PlayQueued(name)
end

function AllianceStarCeremonyBaseUnit:StopAnim()
  self.playerShow:StopAnim()
end

function AllianceStarCeremonyBaseUnit:CrossFadeQueued(name, time, queueMode)
  self.playerShow:CrossFadeQueued(name, time, queueMode)
end

function AllianceStarCeremonyBaseUnit:LoadResCallback(obj)
end

function AllianceStarCeremonyBaseUnit:Update(dt)
end

return AllianceStarCeremonyBaseUnit
