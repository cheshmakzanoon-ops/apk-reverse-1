local ShowRadarMonsterScene = BaseClass("ShowRadarMonsterScene")

function ShowRadarMonsterScene:OnCreate()
  self:ComponentDefine()
  self:DataDefine()
end

function ShowRadarMonsterScene:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function ShowRadarMonsterScene:ComponentDefine()
end

function ShowRadarMonsterScene:ComponentDestroy()
end

function ShowRadarMonsterScene:DataDefine()
  self.param = {}
end

function ShowRadarMonsterScene:DataDestroy()
  self.param = {}
end

function ShowRadarMonsterScene:ReInit(param)
  self.param = param
  local marchInfo = CS.SceneManager.World:GetMarch(param.eventInfo.uuid)
  if marchInfo ~= nil then
    local worldTroop = CS.SceneManager.World:GetTroop(marchInfo.uuid)
    if worldTroop ~= nil then
      if worldTroop.SetVisible ~= nil then
        worldTroop:SetVisible(true)
      end
      local model = worldTroop:GetModel()
      if model ~= nil then
        local gpuAnim = model.transform:GetComponentInChildren(typeof(CS.GPUSkinningAnimator), true)
        if gpuAnim ~= nil then
          gpuAnim:Play("show")
          gpuAnim:PlayQueued("idle")
        end
      end
    end
  end
end

return ShowRadarMonsterScene
