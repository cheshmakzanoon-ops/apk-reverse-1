local SurfingPlayerEntranceState = BaseClass("SurfingPlayerEntranceState")

function SurfingPlayerEntranceState:__init(unit)
  self.unit = unit
end

function SurfingPlayerEntranceState:__delete()
  self.unit = nil
end

function SurfingPlayerEntranceState:OnEnter(id)
  local tmp = DataCenter.ParkourHeroTemplateManager:GetTemplate(id)
  if tmp then
    local anim = tmp:GetEntranceAnim()
    self.unit:TryCrossFadeSimpleAnim(anim, 1, 0)
  end
end

function SurfingPlayerEntranceState:OnExit()
end

function SurfingPlayerEntranceState:OnUpdate(deltaTime)
end

return SurfingPlayerEntranceState
