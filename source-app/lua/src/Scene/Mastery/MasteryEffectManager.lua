local MasteryEffectManager = BaseClass("MasteryEffectManager", Singleton)
local ResourceManager = CS.GameEntry.Resource
local Offset = Vector3.New(1.2, 0, -2.2)

function MasteryEffectManager:__init()
  self.reinforceEffects = {}
  self:AddListener()
end

function MasteryEffectManager:__delete()
  self:RemoveListener()
  for _, v in pairs(self.reinforceEffects) do
    if v.request then
      v.request:Destroy()
    end
    if v.timer then
      v.timer:Stop()
    end
  end
  self.reinforceEffects = nil
end

function MasteryEffectManager:AddListener()
end

function MasteryEffectManager:RemoveListener()
end

function MasteryEffectManager:OnReinforceWallEffect(pointId)
  if not pointId or pointId < 0 then
    return
  end
  self:RemoveReinforceEffect(pointId)
  local worldPos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, LuaEntry.Player:GetCurServerId())
  local effectPath = "Assets/Main/SeasonRes/S6/Prefabs/WorldCity/worldcity_S6_qianshaozhan_fix.prefab"
  local request = ResourceManager:InstantiateAsync(effectPath)
  local effectData = {request = request}
  self.reinforceEffects[pointId] = effectData
  request:completed("+", function()
    if request.isError or IsNull(CS.SceneManager.World) then
      self.reinforceEffects[pointId] = nil
      return
    end
    local go = request.gameObject
    go:SetActive(true)
    go.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    go.transform.position = worldPos + Offset
    effectData.timer = TimerManager:GetInstance():DelayInvoke(function()
      self:RemoveReinforceEffect(pointId)
    end, 3)
  end)
end

function MasteryEffectManager:RemoveReinforceEffect(pointId)
  local data = self.reinforceEffects[pointId]
  if data then
    if data.request then
      data.request:Destroy()
    end
    if data.timer then
      data.timer:Stop()
    end
    self.reinforceEffects[pointId] = nil
  end
end

return MasteryEffectManager
