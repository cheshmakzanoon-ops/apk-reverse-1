local ZMBuildingBuildState = BaseClass("ZMBuildingBuildState")

function ZMBuildingBuildState:__init(stateMgr)
  self.stateMgr = stateMgr
  self.soundId = nil
end

function ZMBuildingBuildState:__delete()
  self.stateMgr = nil
  self:OnExit()
end

function ZMBuildingBuildState:OnEnter()
  self.soundId = DataCenter.LWSoundManager:PlaySound(SoundAssetId.feiting_building)
end

function ZMBuildingBuildState:OnExit()
  if self.soundId then
    DataCenter.LWSoundManager:StopSound(self.soundId)
    self.soundId = nil
  end
  if self.stateMgr then
    self.stateMgr.index = 0
    self.stateMgr:ClearWorkers()
  end
end

function ZMBuildingBuildState:OnUpdate()
end

return ZMBuildingBuildState
