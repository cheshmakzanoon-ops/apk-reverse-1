local WorldTroopLine = BaseClass("WorldTroopLine")

function WorldTroopLine:__init(transform)
  self.transform = transform
  self.homeLineRenderer = transform:Find("HomeLine"):GetComponent(typeof(CS.UnityEngine.LineRenderer))
  self.startSprite = transform:Find("StartSize/StartSprite"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.startSize = transform:Find("StartSize")
  self.backLineRenderer = transform:Find("BackLine"):GetComponent(typeof(CS.UnityEngine.LineRenderer))
  self.middleSprite = transform:Find("MiddleSize/MiddleSprite"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.middleSize = transform:Find("MiddleSize")
  self.frontLineRenderer = transform:Find("FrontLine"):GetComponent(typeof(CS.UnityEngine.LineRenderer))
  self.endSprite = transform:Find("EndSize/EndSprite"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  self.endSize = transform:Find("EndSize")
  self.midCircleOffset = CS.UnityEngine.Vector3(0, 0, 2)
end

function WorldTroopLine:__delete()
  self:Destroy()
end

function WorldTroopLine:Destroy()
  self.transform = nil
  self.homeLineRenderer = nil
  self.startSprite = nil
  self.startSize = nil
  self.backLineRenderer = nil
  self.middleSprite = nil
  self.middleSize = nil
  self.frontLineRenderer = nil
  self.endSprite = nil
  self.endSize = nil
end

function WorldTroopLine:Clear()
  if not IsNull(self.homeLineRenderer) then
    self.homeLineRenderer.gameObject:SetActive(false)
  end
  if not IsNull(self.backLineRenderer) then
    self.backLineRenderer.positionCount = 0
  end
  if not IsNull(self.frontLineRenderer) then
    self.frontLineRenderer.positionCount = 0
  end
end

function WorldTroopLine:SetRotation(dir)
  self.midCircleOffset = dir * self.midCircleRadius
  if not IsNull(self.middleSize) then
    local direction = Vector3.New(dir.x, dir.y, dir.z)
    local mag = direction:Magnitude()
    if 1.0E-6 < mag then
      self.middleSize.transform.localRotation = Quaternion.LookRotation(direction)
    end
  end
end

function WorldTroopLine:SetScale(scale)
  if not IsNull(self.startSize) then
    self.startSize.localScale = Vector3.one * scale
  end
  if not IsNull(self.middleSize) then
    self.middleSize.localScale = Vector3.one * scale
  end
  if not IsNull(self.endSize) then
    self.endSize.localScale = Vector3.one * scale
  end
  self.midCircleRadius = scale * 2
end

function WorldTroopLine:InitHomePath(homePos, startPos)
  if not IsNull(self.homeLineRenderer) then
    self.homeLineRenderer.gameObject:SetActive(true)
    self.homeLineRenderer.positionCount = 2
    self.homeLineRenderer:SetPosition(0, homePos)
    self.homeLineRenderer:SetPosition(1, startPos)
  end
end

function WorldTroopLine:InitStart(startPos)
  self.startPosition = startPos
  if not IsNull(self.startSize) then
    self.startSize.transform.position = startPos
  end
  if not IsNull(self.backLineRenderer) then
    self.backLineRenderer.positionCount = 2
    self.backLineRenderer:SetPosition(0, startPos)
  end
end

function WorldTroopLine:InitEnd(endPos)
  self.endPosition = endPos
  if not IsNull(self.endSize) then
    self.endSize.transform.position = endPos
  end
  if not IsNull(self.frontLineRenderer) then
    self.frontLineRenderer.positionCount = 2
    self.frontLineRenderer:SetPosition(1, endPos)
  end
end

function WorldTroopLine:UpdatePath(curPos)
  if not self.startPosition or not self.endPosition then
    return
  end
  if not IsNull(self.middleSize) then
    self.middleSize.transform.position = curPos
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

function WorldTroopLine:SetColor(camp)
  local lineColor = DataCenter.WorldTroopLineManager:GetColor(camp, WorldTroopColorType.line)
  local lightColor = DataCenter.WorldTroopLineManager:GetColor(camp, WorldTroopColorType.light)
  if not IsNull(self.startSprite) then
    self.startSprite.color = lineColor
  end
  if not IsNull(self.middleSprite) then
    self.middleSprite.color = lineColor
  end
  if not IsNull(self.endSprite) then
    self.endSprite.color = lineColor
  end
  if not IsNull(self.frontLineRenderer) then
    self.frontLineRenderer.startColor = lineColor
    self.frontLineRenderer.endColor = lineColor
  end
  if not IsNull(self.homeLineRenderer) then
    self.homeLineRenderer.startColor = lineColor
    self.homeLineRenderer.endColor = lineColor
  end
  if not IsNull(self.backLineRenderer) then
    self.backLineRenderer.startColor = lightColor
    self.backLineRenderer.endColor = lightColor
  end
end

return WorldTroopLine
