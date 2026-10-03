local SceneStatePVE = BaseClass("SceneStatePVE")

function SceneStatePVE:__init()
end

function SceneStatePVE:__delete()
end

function SceneStatePVE:OnEnter()
  RedMat = nil
  WhiteMat = nil
  local useGPU = DataCenter.FunctionOnManager:IsServerSwitchOn(ServerSwitch.PveGpuSkinFull)
  CS.PVEBattleLogic.Unit.UnitViewFacade.UseGPUSkinMaterial(useGPU)
end

function SceneStatePVE:OnExit()
  RedMat = nil
  WhiteMat = nil
end

return SceneStatePVE
