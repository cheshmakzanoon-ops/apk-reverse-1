local CityNpcManager = BaseClass("CityNpcManager")
local Resource = CS.GameEntry.Resource
local CityNpc = require("Scene.CityNpc.CityNpc")

function CityNpcManager:__init()
  self.npc = {}
  self.protectNpc = {}
  self.talkDataDict = {}
  self.followCamera = nil
end

function CityNpcManager:__delete()
  self:RemoveAll(true)
  self.npc = {}
  self.protectNpc = {}
  self.talkDataDict = nil
  self.followCamera = nil
end

function CityNpcManager:AddOneNpc(modelName, posArr, aniName, angle, nextType, npcFuncType)
  if self.npc[modelName] == nil then
    self.npc[modelName] = {}
  end
  if self.npc[modelName].param == nil then
    self.npc[modelName].param = {}
  end
  self.npc[modelName].param.modelName = modelName
  self.npc[modelName].param.posArr = posArr
  self.npc[modelName].param.animName = aniName
  self.npc[modelName].param.angle = angle
  self.npc[modelName].param.nextType = nextType
  if self.npc[modelName].inst == nil then
    self.npc[modelName].inst = Resource:InstantiateAsync(string.format(LoadPath.CityScene, modelName))
    self.npc[modelName].inst:completed("+", function(req)
      local effect = CityNpc.New()
      effect:OnCreate(req)
      self.npc[modelName].param.npcFuncType = npcFuncType
      effect:ReInit(self.npc[modelName].param)
      self.npc[modelName].model = effect
    end)
  elseif self.npc[modelName].model ~= nil then
    self.npc[modelName].model:ReInit(self.npc[modelName].param)
  end
end

function CityNpcManager:RemoveOneNpc(modelName)
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

function CityNpcManager:SaveArchive()
  local archive = CityPioneerArchive:GetInstance()
  for k, v in pairs(self.npc) do
    local posArr = {}
    if v.param.posArr ~= nil then
      table.insert(posArr, v.param.posArr[table.count(v.param.posArr)])
    end
    archive:SetNpc(k, posArr, v.param.angle)
  end
end

function CityNpcManager:InitNpc()
end

function CityNpcManager:RemoveAll(includeProtect)
  for t, n in pairs(self.npc) do
    if includeProtect or not self.protectNpc[t] then
      self:RemoveOneNpc(t)
    end
  end
end

function CityNpcManager:ProtectNpc(modelName, protect)
  self.protectNpc[modelName] = protect
end

function CityNpcManager:GetNpcObjectByName(modelName)
  local request = self.npc[modelName]
  return request and request.inst.gameObject or nil
end

function CityNpcManager:ToggleNpcTalkTrigger(modelName, t, data)
  local request = self.npc[modelName]
  if request == nil then
    Logger.LogError("ToggleNpcTalkTrigger request is nil\239\188\129modelName:" .. modelName)
    return
  end
  if request.inst.gameObject == nil then
    TimerManager:GetInstance():DelayInvoke(function()
      self:ToggleNpcTalkTrigger(modelName, t, data)
    end, 0.5)
    return
  end
  local instanceId = request.inst.gameObject:GetInstanceID()
  self.talkDataDict[instanceId] = data
end

function CityNpcManager:GetNpcTalkData(instanceId)
  return self.talkDataDict[instanceId]
end

function CityNpcManager:GetNpcPositionByName(modelName)
  if self.npc[modelName] ~= nil then
    if self.npc[modelName].model ~= nil then
      return self.npc[modelName].model.transform.position
    end
    if self.npc[modelName].param ~= nil and self.npc[modelName].param.posArr ~= nil and table.count(self.npc[modelName].param.posArr) > 0 then
      return SceneUtils.TileToWorld(self.npc[modelName].param.posArr[1])
    end
  end
end

function CityNpcManager:SetFollowNpc(npcName)
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

function CityNpcManager:SetNpcVisible(visible)
  for k, v in pairs(self.npc) do
    if v.model ~= nil then
      v.model.gameObject:SetActive(visible)
      local param = {}
      param.target = v.model.transform
      param.visible = visible
      EventManager:GetInstance():Broadcast(EventId.RefreshNpcTalkBubbleActive, param)
    end
  end
end

return CityNpcManager
