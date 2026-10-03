local CityPioneerYellowArrowManager = BaseClass("CityPioneerYellowArrowManager")
local Resource = CS.GameEntry.Resource
local CityPioneerYellowArrow = require("Scene.CityPioneer.CityPioneerYellowArrow")

function CityPioneerYellowArrowManager:__init()
  self.arrow = {}
end

function CityPioneerYellowArrowManager:__delete()
  self:RemoveAll()
  self.arrow = nil
end

function CityPioneerYellowArrowManager:Startup()
end

function CityPioneerYellowArrowManager:AddOneArrow(position, height, nextPosArr)
  if self.arrow == nil then
    self.arrow = {}
  end
  local id = self:GetPosId(position)
  if self.arrow[id] == nil then
    self.arrow[id] = {}
  end
  if self.arrow[id].inst == nil then
    local modelPos = self:GetModelPos(position)
    if modelPos ~= nil then
      position = modelPos
    end
    local param = {}
    param.id = id
    if height ~= nil then
      position.y = height
    end
    param.position = position
    param.nextPosArr = nextPosArr
    self.arrow[id].param = param
    self.arrow[id].inst = Resource:InstantiateAsync(UIAssets.GuideWorldArrow)
    self.arrow[id].inst:completed("+", function(req)
      local effect = CityPioneerYellowArrow.New()
      effect:OnCreate(req)
      effect:ReInit(self.arrow[id].param)
      self.arrow[id].model = effect
    end)
  end
end

function CityPioneerYellowArrowManager:RemoveOneArrow(id)
  if self.arrow[id] ~= nil then
    if self.arrow[id].model ~= nil then
      self.arrow[id].model:OnDestroy()
    end
    if self.arrow[id].inst then
      self.arrow[id].inst:Destroy()
    end
    if self.arrow[id].param ~= nil then
      local nextArr = self.arrow[id].param.nextPosArr
      if nextArr ~= nil and table.count(nextArr) > 0 then
        local param = table.remove(nextArr, 1)
        self:AddOneArrow(param.pos, param.height, nextArr)
      end
    end
    self.arrow[id] = nil
  end
end

function CityPioneerYellowArrowManager:RemoveAll()
  if self.arrow then
    for k, v in pairs(self.arrow) do
      if v.model ~= nil then
        v.model:OnDestroy()
      end
      if v.inst then
        v.inst:Destroy()
      end
    end
    self.arrow = {}
  end
end

function CityPioneerYellowArrowManager:SetArrowVisible(id, visible)
  if self.arrow[id] ~= nil and self.arrow[id].model ~= nil then
    self.arrow[id].model:SetVisible(visible)
  end
end

function CityPioneerYellowArrowManager:RemoveOneArrowByPos(pos)
  self:RemoveOneArrow(self:GetPosId(pos))
end

function CityPioneerYellowArrowManager:GetPosId(pos)
  return pos.x .. " " .. pos.z
end

function CityPioneerYellowArrowManager:GetModelPos(pos)
  local pointId = SceneUtils.WorldToTileIndex(pos)
  local obj = CS.SceneManager.World:GetObjectByPointId(pointId)
  if obj ~= nil then
    pos.y = 2
  end
  return pos
end

return CityPioneerYellowArrowManager
