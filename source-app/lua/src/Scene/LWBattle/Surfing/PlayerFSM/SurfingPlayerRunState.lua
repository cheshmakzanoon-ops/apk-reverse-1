local SurfingPlayerRunState = BaseClass("SurfingPlayerRunState")

function SurfingPlayerRunState:__init(unit)
  self.unit = unit
end

function SurfingPlayerRunState:__delete()
  self.unit = nil
end

function SurfingPlayerRunState:OnEnter()
  self.unit:TryCrossFadeSimpleAnim("run", 1, 0)
end

function SurfingPlayerRunState:OnExit()
end

function SurfingPlayerRunState:OnUpdate(deltaTime)
end

return SurfingPlayerRunState
