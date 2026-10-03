local WorldTroopLineQueen = BaseClass("WorldTroopLineQueen")

function WorldTroopLineQueen:__init(transform)
  self.transform = transform
  self.lineRenderer = transform:Find("FrontLine"):GetComponent(typeof(CS.UnityEngine.LineRenderer))
  self.circleObj = transform:Find("Circle").gameObject
  self.circleObj:SetActive(false)
end

function WorldTroopLineQueen:__delete()
  self:Destroy()
end

function WorldTroopLineQueen:Destroy()
  self.transform = nil
  self.lineRenderer = nil
  self.circleObj = nil
end

function WorldTroopLineQueen:Clear()
  self.lineRenderer.positionCount = 0
  self.circleObj:SetActive(false)
end

function WorldTroopLineQueen:UpdatePath(startPos, endPos)
  if startPos == nil or endPos == nil or startPos == endPos then
    return
  end
  self.lineRenderer.positionCount = 2
  self.lineRenderer:SetPosition(0, startPos)
  self.lineRenderer:SetPosition(1, endPos)
  self.circleObj:SetActive(true)
  self.circleObj.transform:Set_position(endPos.x, endPos.y, endPos.z)
end

return WorldTroopLineQueen
