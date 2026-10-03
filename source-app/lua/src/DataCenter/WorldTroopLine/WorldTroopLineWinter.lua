local WorldTroopLineWinter = BaseClass("WorldTroopLineWinter")

function WorldTroopLineWinter:__init(transform)
  self.transform = transform
  self.backLineMyRenderer = transform:Find("BackLineMy"):GetComponent(typeof(CS.UnityEngine.LineRenderer))
  self.frontLineMyRenderer = transform:Find("FrontLineMy"):GetComponent(typeof(CS.UnityEngine.LineRenderer))
  self.backLineEnemyRenderer = transform:Find("BackLineEnemy"):GetComponent(typeof(CS.UnityEngine.LineRenderer))
  self.frontLineEnemyRenderer = transform:Find("FrontLineEnemy"):GetComponent(typeof(CS.UnityEngine.LineRenderer))
  self.midCircleOffset = CS.UnityEngine.Vector3(0, 0, 2)
end

function WorldTroopLineWinter:__delete()
  self:Destroy()
end

function WorldTroopLineWinter:Destroy()
  self.transform = nil
  self.backLineRenderer = nil
  self.frontLineRenderer = nil
  self.backLineMyRenderer = nil
  self.frontLineMyRenderer = nil
  self.backLineEnemyRenderer = nil
  self.frontLineEnemyRenderer = nil
end

function WorldTroopLineWinter:Clear()
  if not IsNull(self.backLineMyRenderer) then
    self.backLineMyRenderer.positionCount = 0
  end
  if not IsNull(self.frontLineMyRenderer) then
    self.frontLineMyRenderer.positionCount = 0
  end
  if not IsNull(self.backLineEnemyRenderer) then
    self.backLineEnemyRenderer.positionCount = 0
  end
  if not IsNull(self.frontLineEnemyRenderer) then
    self.frontLineEnemyRenderer.positionCount = 0
  end
end

function WorldTroopLineWinter:SetRotation(dir)
  self.midCircleOffset = dir * self.midCircleRadius
end

function WorldTroopLineWinter:SetScale(scale)
  self.midCircleRadius = scale * 2
end

function WorldTroopLineWinter:InitStart(startPos)
  self.startPosition = startPos
  if not IsNull(self.backLineRenderer) then
    self.backLineRenderer.positionCount = 2
    self.backLineRenderer:SetPosition(0, startPos)
  end
end

function WorldTroopLineWinter:InitEnd(endPos)
  self.endPosition = endPos
  if not IsNull(self.frontLineRenderer) then
    self.frontLineRenderer.positionCount = 2
    self.frontLineRenderer:SetPosition(1, endPos)
  end
end

function WorldTroopLineWinter:UpdatePath(curPos)
  if not self.startPosition or not self.endPosition then
    return
  end
  if not IsNull(self.backLineRenderer) then
    local displace = curPos - self.startPosition
    local distance = math.abs(displace.x) + math.abs(displace.z)
    self.backLineRenderer.positionCount = 2
    if distance < self.midCircleRadius * 1.4 then
      self.backLineRenderer:SetPosition(1, self.startPosition)
    else
      self.backLineRenderer:SetPosition(1, curPos - self.midCircleOffset)
    end
  end
  if not IsNull(self.frontLineRenderer) then
    local displace = curPos - self.endPosition
    local distance = math.abs(displace.x) + math.abs(displace.z)
    self.frontLineRenderer.positionCount = 2
    if distance < self.midCircleRadius * 1.4 then
      self.frontLineRenderer:SetPosition(0, self.endPosition)
    else
      self.frontLineRenderer:SetPosition(0, curPos + self.midCircleOffset)
    end
  end
end

function WorldTroopLineWinter:SetColor(bMy)
  self.backLineMyRenderer.gameObject:SetActive(bMy)
  self.backLineEnemyRenderer.gameObject:SetActive(not bMy)
  self.frontLineMyRenderer.gameObject:SetActive(bMy)
  self.frontLineEnemyRenderer.gameObject:SetActive(not bMy)
  self.backLineRenderer = bMy and self.backLineMyRenderer or self.backLineEnemyRenderer
  self.frontLineRenderer = bMy and self.frontLineMyRenderer or self.frontLineEnemyRenderer
end

return WorldTroopLineWinter
