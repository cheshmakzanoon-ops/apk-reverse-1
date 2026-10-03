local PveWaitMoveManager = BaseClass("PveWaitMoveManager")
local Resource = CS.GameEntry.Resource
local Const = require("Scene.PVEBattleLevel.Const")
local PveWaitMove = require("Scene.PVEBattleLevel.PveWaitMove")

function PveWaitMoveManager:__init()
  self.waitMove = {}
end

function PveWaitMoveManager:__delete()
  self.waitMove = nil
end

function PveWaitMoveManager:AddOneWaitMove(resType, num, position, id)
  if self.waitMove == nil then
    self.waitMove = {}
  end
  if self.waitMove[id] == nil then
    self.waitMove[id] = {}
  end
  if self.waitMove[id].inst == nil then
    local param = {}
    param.id = id
    param.position = position
    param.resType = resType
    param.num = num
    self.waitMove[id].param = param
    self.waitMove[id].inst = Resource:InstantiateAsync(Const.WaitMovePath[Const.UnlockToResType[resType]])
    self.waitMove[id].inst:completed("+", function(req)
      local effect = PveWaitMove.New()
      effect:OnCreate(req)
      effect:ReInit(self.waitMove[id].param)
      self.waitMove[id].model = effect
    end)
  elseif self.waitMove[id].model ~= nil then
    self.waitMove[id].model:AddNum(num)
  else
    self.waitMove[id].param.num = self.waitMove[id].param.num + num
  end
end

function PveWaitMoveManager:RemoveOneWaitMove(id)
  if self.waitMove[id] ~= nil then
    if self.waitMove[id].model ~= nil then
      self.waitMove[id].model:OnDestroy()
    end
    if self.waitMove[id].inst then
      self.waitMove[id].inst:Destroy()
    end
    self.waitMove[id] = nil
  end
end

function PveWaitMoveManager:RemoveAll()
  if self.waitMove then
    for t, n in pairs(self.waitMove) do
      self:RemoveOneWaitMove(t)
    end
    self.waitMove = {}
  end
end

function PveWaitMoveManager:OnUpdate()
  local time = Time.deltaTime
  for k, v in pairs(self.waitMove) do
    if v.model ~= nil then
      v.model:OnUpdate(time)
    end
  end
end

function PveWaitMoveManager:RefreshMoveManCount(id)
  if self.waitMove and self.waitMove[id] ~= nil and self.waitMove[id].model ~= nil then
    self.waitMove[id].model:RefreshMoveManCount()
  end
end

return PveWaitMoveManager
