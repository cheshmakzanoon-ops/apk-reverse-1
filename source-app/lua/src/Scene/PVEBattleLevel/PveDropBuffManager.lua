local PveDropBuffManager = BaseClass("PveDropBuffManager")
local Resource = CS.GameEntry.Resource
local PveDropBuff = require("Scene.PVEBattleLevel.PveDropBuff")

function PveDropBuffManager:__init()
  self.dropBuff = {}
end

function PveDropBuffManager:__delete()
  self.dropBuff = nil
end

function PveDropBuffManager:AddOneDropBuff(buffId, position)
  if self.dropBuff == nil then
    self.dropBuff = {}
  end
  local id = tostring(NameCount)
  NameCount = NameCount + 1
  if self.dropBuff[id] == nil then
    self.dropBuff[id] = {}
  end
  local template = DataCenter.PveBuffTemplateManager:GetTemplate(buffId)
  if template ~= nil and self.dropBuff[id].inst == nil then
    self.dropBuff[id].inst = Resource:InstantiateAsync(string.format(LoadPath.CityScene, template.model))
    self.dropBuff[id].inst:completed("+", function(req)
      local effect = PveDropBuff.New()
      effect:OnCreate(req)
      local param = {}
      param.id = id
      param.position = position
      param.buffId = buffId
      effect:ReInit(param)
      self.dropBuff[id].model = effect
    end)
  end
end

function PveDropBuffManager:RemoveOneDropBuff(id)
  if self.dropBuff[id] ~= nil then
    if self.dropBuff[id].model ~= nil then
      self.dropBuff[id].model:OnDestroy()
    end
    if self.dropBuff[id].inst then
      self.dropBuff[id].inst:Destroy()
    end
    self.dropBuff[id] = nil
  end
end

function PveDropBuffManager:RemoveAll()
  if self.dropBuff then
    for t, n in pairs(self.dropBuff) do
      self:RemoveOneDropBuff(t)
    end
    self.dropBuff = {}
  end
end

function PveDropBuffManager:OnPlayerMoveSignal(pos)
  if self.dropBuff ~= nil then
    for k, v in pairs(self.dropBuff) do
      if v.model ~= nil then
        v.model:OnPlayerMoveSignal(pos)
      end
    end
  end
end

return PveDropBuffManager
