local TorchRelayBattleCheerBase = BaseClass("TorchRelayBattleCheerBase")

function TorchRelayBattleCheerBase:__init()
end

function TorchRelayBattleCheerBase:Init()
  self:AddListener()
end

function TorchRelayBattleCheerBase:Release()
  self:RemoveListener()
end

function TorchRelayBattleCheerBase:__delete()
end

function TorchRelayBattleCheerBase:AddListener()
end

function TorchRelayBattleCheerBase:RemoveListener()
end

function TorchRelayBattleCheerBase:Destroy()
end

function TorchRelayBattleCheerBase:OnUpdate(dt)
end

function TorchRelayBattleCheerBase:GetSceneIndex()
  return -1
end

function TorchRelayBattleCheerBase:GetRare()
  return -1
end

function TorchRelayBattleCheerBase:GetTemplate()
end

function TorchRelayBattleCheerBase:TriggerMainUI()
  if self.cheerData and self.logic and self.logic.mainView then
    self.logic.mainView:OnCheerTriggered(self.cheerData)
  end
end

return TorchRelayBattleCheerBase
