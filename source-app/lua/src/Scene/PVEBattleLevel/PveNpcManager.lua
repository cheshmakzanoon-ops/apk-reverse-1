local PveNpcManager = BaseClass("PveNpcManager")
local Resource = CS.GameEntry.Resource
local CityNpc = require("Scene.PVEBattleLevel.PveNpc")
local ExtraFollowNpcPos = {
  Vector3.New(0, 0, -1),
  Vector3.New(-1, 0, 0),
  Vector3.New(1, 0, 0),
  Vector3.New(0, 0, 1),
  Vector3.New(1, 0, 1),
  Vector3.New(-1, 0, 1),
  Vector3.New(1, 0, -1),
  Vector3.New(-1, 0, -1)
}

function PveNpcManager:__init()
  self.npc = {}
  self.followCamera = nil
end

function PveNpcManager:__delete()
  self.npc = {}
  self.followCamera = nil
end

function PveNpcManager:AddOneNpc(param)
  local modelName = param.modelName
  if self.npc[modelName] == nil then
    self.npc[modelName] = {}
  end
  self.npc[modelName].param = param
  param.mgr = self
  if self.npc[modelName].inst == nil then
    self.npc[modelName].inst = Resource:InstantiateAsync(string.format(LoadPath.CityScene, modelName))
    self.npc[modelName].inst:completed("+", function(req)
      local effect = CityNpc.New()
      effect:OnCreate(req)
      effect:ReInit(self.npc[modelName].param)
      self.npc[modelName].model = effect
    end)
  elseif self.npc[modelName].model ~= nil then
    self.npc[modelName].model:ReInit(self.npc[modelName].param)
  end
end

function PveNpcManager:RemoveOneNpc(modelName)
  if self.npc[modelName] ~= nil then
    if self.npc[modelName].model ~= nil then
      self.npc[modelName].model:OnDestroy()
    end
    if self.npc[modelName].inst then
      self.npc[modelName].inst:Destroy()
    end
    self.npc[modelName] = nil
  end
end

function PveNpcManager:RemoveAll()
  for t, n in pairs(self.npc) do
    self:RemoveOneNpc(t)
  end
  self.npc = {}
end

function PveNpcManager:GetNpcObjectByName(modelName)
  local request = self.npc[modelName]
  return request and request.inst.gameObject or nil
end

function PveNpcManager:GetNpcPositionByName(modelName)
  if self.npc[modelName] ~= nil then
    if self.npc[modelName].model ~= nil then
      return self.npc[modelName].model.transform.position
    end
    if self.npc[modelName].param ~= nil and self.npc[modelName].param.posArr ~= nil and table.count(self.npc[modelName].param.posArr) > 0 then
      return SceneUtils.TileToWorld(self.npc[modelName].param.posArr[1])
    end
  end
end

function PveNpcManager:SetFollowNpc(npcName)
  if self.followCamera ~= npcName then
    if self.followCamera ~= nil and self.npc[self.followCamera] ~= nil then
      self.npc[self.followCamera].param.follow = false
      if self.npc[self.followCamera].model ~= nil then
        self.npc[self.followCamera].model.param.follow = false
        self.npc[self.followCamera].model:RefreshFollow()
      end
    end
    if npcName ~= nil and self.npc[npcName] ~= nil then
      self.npc[npcName].param.follow = true
      if self.npc[npcName].model ~= nil then
        self.npc[npcName].model.param.follow = true
        self.npc[npcName].model:RefreshFollow()
      end
    end
    self.followCamera = npcName
  end
end

function PveNpcManager:SetNpcVisible(visible)
  for k, v in pairs(self.npc) do
    if v.model ~= nil then
      v.model.gameObject:SetActive(visible)
    end
  end
end

function PveNpcManager:OnUpdate()
  for k, v in pairs(self.npc) do
    if v.model ~= nil then
      v.model:Update()
    end
  end
end

function PveNpcManager:OnPlayerMoveSignal(pos)
  for k, v in pairs(self.npc) do
    if v.model ~= nil then
      v.model:OnPlayerMoveSignal(pos)
    end
  end
end

function PveNpcManager:SetNpcDialog(npcName, dialogId)
  if self.npc[npcName] ~= nil then
    self.npc[npcName].param.dialogId = dialogId
    if self.npc[npcName].model ~= nil then
      self.npc[npcName].model.param.dialogId = dialogId
    end
  end
end

function PveNpcManager:GetExtraFollowNpcPos(index)
  local posCount = table.count(ExtraFollowNpcPos)
  if index <= posCount then
    return ExtraFollowNpcPos[index]
  else
    return Vector3.New(-0.7 * (index - posCount), 0, -1)
  end
end

function PveNpcManager:GetFollowNpcCount()
  local count = 0
  for k, v in pairs(self.npc) do
    if v.param ~= nil and v.param.isFollow then
      count = count + 1
    end
  end
  return count
end

return PveNpcManager
