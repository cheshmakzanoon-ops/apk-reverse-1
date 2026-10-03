local WorldTroopLine = require("DataCenter.WorldTroopLine.WorldTroopLine")
local TroopLinePrefab = "Assets/Main/Prefabs/March/TroopLine.prefab"
local TroopLine = BaseClass("TroopLine")

function TroopLine:__init(march)
  self.lineInst = nil
  self.line = nil
  self.march = march
  self:CreateMarchLine()
end

function TroopLine:__delete()
  self:Destroy()
end

function TroopLine:Destroy()
  if self.lineInst then
    self.lineInst:Destroy()
    self.lineInst = nil
  end
  self.line = nil
  self.march = nil
end

function TroopLine:CreateMarchLine()
  self.lineInst = CS.GameEntry.Resource:InstantiateAsync(TroopLinePrefab)
  self.lineInst:completed("+", function(req)
    if req.isError then
      return
    end
    req.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    self.line = WorldTroopLine.New(req.gameObject.transform)
    self:InitView()
  end)
end

function TroopLine:SetData(march)
  self.march = march
  self:InitView()
end

function TroopLine:InitView()
  local march = self.march
  if self.line then
    self.line:Clear()
    self:SetColor(march)
    self:SetScale(march)
    self:SetRotation(march)
    self:SetStart(march)
    self:SetEnd(march)
  end
end

function TroopLine:SetColor(march)
  local camp = DataCenter.WorldTroopLineManager:GetCamp(march)
  self.line:SetColor(camp)
end

function TroopLine:SetScale(march)
  self.line:SetScale(1)
end

function TroopLine:SetRotation(march)
  if march.pathList and march.pathList[0] and march.pathList[0].dir then
    self.line:SetRotation(march.pathList[0].dir)
  end
end

function TroopLine:SetStart(march)
  self.startPos = march.startWorldPos
  self.line:InitStart(self.startPos)
  if march.homePos > 0 and march.targetPos ~= march.homePos and march.startPos ~= march.homePos then
    self.line:InitHomePath(march.homeWorldPos, self.startPos)
  end
end

function TroopLine:SetEnd(march)
  if march.realTargetPos > 0 then
    self.endPos = SceneUtils.TileIndexToWorld(march.realTargetPos)
  elseif march.pathList and march.pathList[march.pathList.Length - 1] then
    self.endPos = march.pathList[march.pathList.Length - 1].pos
  end
  if self.endPos then
    self.line:InitEnd(self.endPos)
  else
  end
end

function TroopLine:SetCurPos(march, curPos)
  if self.line then
    if not self.endPos then
      self:SetEnd(march)
    end
    self.line:UpdatePath(curPos)
  end
end

return TroopLine
