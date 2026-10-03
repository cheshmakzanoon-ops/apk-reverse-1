local WorldTroopLineQueen = require("DataCenter.LWOffSeason1.TroopLine.WorldTroopLineQueen")
local WorldTroopLineQueenManager = BaseClass("WorldTroopLineQueenManager", CEventable)
local Resource = CS.GameEntry.Resource
local LinePath = "Assets/Main/Prefabs/LWOffSeason1/TroopLine/TroopLineQueen.prefab"

function WorldTroopLineQueenManager:__init()
  self.troopLines = {}
  self.lineReqs = {}
  self:RegisterEvent(EventId.OnEnterCrossServer, self.Clear)
  self:RegisterEvent(EventId.OnEnterCity, self.Clear)
end

function WorldTroopLineQueenManager:__delete()
  self:Clear()
end

function WorldTroopLineQueenManager:Clear()
  if self.troopLines ~= nil then
    for _, line in pairs(self.troopLines) do
      line:Delete()
    end
    self.troopLines = {}
  end
  if self.lineReqs ~= nil then
    for _, req in pairs(self.lineReqs) do
      req:Destroy()
    end
    self.lineReqs = {}
  end
end

function WorldTroopLineQueenManager:CreateLine(uuid, startPos, endPos)
  if self.lineReqs[uuid] == nil then
    local request = Resource:InstantiateAsync(LinePath)
    self.lineReqs[uuid] = request
    request:completed("+", function(req)
      local _go = req.gameObject
      if IsNull(_go) then
        req:Destroy()
        self.lineReqs[uuid] = nil
        return
      end
      _go.name = "WorldTroopLineQueen_" .. uuid
      _go.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
      local troopLine = WorldTroopLineQueen.New(_go.transform)
      if troopLine ~= nil then
        self.troopLines[uuid] = troopLine
        troopLine:UpdatePath(startPos, endPos)
      end
    end)
  elseif self.troopLines[uuid] then
    self.troopLines[uuid]:UpdatePath(startPos, endPos)
  end
end

function WorldTroopLineQueenManager:RemoveLine(uuid)
  if self.troopLines[uuid] then
    self.troopLines[uuid]:Delete()
    self.troopLines[uuid] = nil
  end
  if self.lineReqs[uuid] then
    self.lineReqs[uuid]:Destroy()
    self.lineReqs[uuid] = nil
  end
end

return WorldTroopLineQueenManager
