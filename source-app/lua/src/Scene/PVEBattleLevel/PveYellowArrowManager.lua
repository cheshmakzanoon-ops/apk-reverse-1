local PveYellowArrowManager = BaseClass("PveYellowArrowManager")
local Resource = CS.GameEntry.Resource
local Const = require("Scene.PVEBattleLevel.Const")
local PveYellowArrow = require("Scene.PVEBattleLevel.PveYellowArrow")

function PveYellowArrowManager:__init()
  self.arrow = {}
end

function PveYellowArrowManager:__delete()
  self.arrow = nil
end

function PveYellowArrowManager:AddOneArrow(position, height, showPos)
  local pos = Vector3.New(position.x, position.y, position.z)
  if self.arrow == nil then
    self.arrow = {}
  end
  local id = DataCenter.BattleLevel:GetPosId(pos)
  if self.arrow[id] == nil then
    self.arrow[id] = {}
  end
  if self.arrow[id].inst == nil then
    local param = {}
    param.id = id
    if showPos == nil then
      local modelPos = DataCenter.BattleLevel:GetModelPos(pos)
      if modelPos ~= nil then
        pos = modelPos
      end
      if height ~= nil then
        pos.y = height
      end
      param.position = pos
    else
      param.position = showPos
    end
    self.arrow[id].param = param
    self.arrow[id].inst = Resource:InstantiateAsync(UIAssets.GuideWorldArrow)
    self.arrow[id].inst:completed("+", function(req)
      local effect = PveYellowArrow.New()
      effect:OnCreate(req)
      effect:ReInit(self.arrow[id].param)
      self.arrow[id].model = effect
    end)
  end
end

function PveYellowArrowManager:RemoveOneArrow(id)
  if self.arrow[id] ~= nil then
    if self.arrow[id].model ~= nil then
      self.arrow[id].model:OnDestroy()
    end
    if self.arrow[id].inst then
      self.arrow[id].inst:Destroy()
    end
    self.arrow[id] = nil
  end
end

function PveYellowArrowManager:RemoveAll()
  if self.arrow then
    for k, v in pairs(self.arrow) do
      self:RemoveOneArrow(k)
    end
    self.arrow = {}
  end
end

function PveYellowArrowManager:SetArrowVisible(id, visible)
  if self.arrow[id] ~= nil and self.arrow[id].model ~= nil then
    self.arrow[id].model:SetVisible(visible)
  end
end

function PveYellowArrowManager:RemoveOneArrow(id)
  if self.arrow[id] ~= nil then
    if self.arrow[id].model ~= nil then
      self.arrow[id].model:OnDestroy()
    end
    if self.arrow[id].inst then
      self.arrow[id].inst:Destroy()
    end
    self.arrow[id] = nil
  end
end

return PveYellowArrowManager
