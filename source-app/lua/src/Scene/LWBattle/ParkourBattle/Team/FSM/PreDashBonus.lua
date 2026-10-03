local PreDashBonus = BaseClass("PreDashBonus")

function PreDashBonus:__init(unit)
  self.unit = unit
end

function PreDashBonus:__delete()
  self.unit = nil
end

function PreDashBonus:OnEnter()
end

function PreDashBonus:OnExit()
end

function PreDashBonus:OnUpdate()
end

return PreDashBonus
