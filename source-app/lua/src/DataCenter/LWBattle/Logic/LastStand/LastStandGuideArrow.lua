local LastStandGuideArrow = BaseClass("LastStandGuideArrow")
local Resource = CS.GameEntry.Resource
local Quaternion = CS.UnityEngine.Quaternion
local Time = CS.UnityEngine.Time

function LastStandGuideArrow:__init()
  self.owner = nil
  self.targetPos = nil
  self.radius = 0.5
  self.arrowObject = nil
  self.transform = nil
  self.isActive = false
  self.updateTimer = nil
  self.req = nil
  
  function self.updateTimer()
    self:Update()
  end
  
  self.update = UpdateManager:GetInstance():AddUpdate(self.updateTimer)
end

function LastStandGuideArrow:InitArrow(owner, targetPos, radius, callBack)
  if not owner or not targetPos then
    return
  end
  self.owner = owner
  self.targetPos = targetPos
  self.radius = radius or 0.3
  self.isActive = true
  self.req = Resource:InstantiateAsync("Assets/Main/Prefabs/LastStand/LastStandGuideArrow.prefab")
  self.req:completed("+", function(req)
    self.arrowObject = req.gameObject
    self.transform = self.arrowObject.transform
    self.image = self.transform:Find("GameObject"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    self.transform:SetParent(self.owner.transform)
    self.transform.localPosition = Vector3.zero
    self.transform.localScale = Vector3.one
    if callBack then
      callBack()
    end
  end)
end

function LastStandGuideArrow:SetTarget(newTarget)
  self.targetPos = newTarget
  if not self.targetPos then
    self:Hide()
  else
    self:Show()
  end
end

function LastStandGuideArrow:SetRadius(newRadius)
  self.radius = newRadius
end

function LastStandGuideArrow:Show()
  if self.isActive then
    return
  end
  self.isActive = true
  if self.arrowObject then
    self.arrowObject:SetActive(true)
  end
end

function LastStandGuideArrow:Hide()
  if not self.isActive then
    return
  end
  self.isActive = false
  if self.arrowObject then
    self.arrowObject:SetActive(false)
  end
end

function LastStandGuideArrow:Update()
  if not (self.isActive and self.transform and self.owner) or not self.targetPos then
    return
  end
  local ownerPosition = self.owner:GetPosition()
  local distance = Vector3.Distance(ownerPosition, self.targetPos)
  if distance < 5 then
    self.image.gameObject:SetActive(false)
    return
  else
    self.image.gameObject:SetActive(true)
  end
  self:UpdateArrowPositionAndRotation(self.targetPos)
end

function LastStandGuideArrow:GetTargetPosition()
end

function LastStandGuideArrow:UpdateArrowPositionAndRotation(targetPosition)
  if not self.transform then
    return
  end
  local ownerPosition = self.owner:GetPosition()
  local direction = targetPosition - ownerPosition
  direction.y = 0
  if direction.magnitude > 0.1 then
    local normalizedDir = direction.normalized
    local circlePosition = normalizedDir * self.radius
    self.transform.localPosition = Vector3(circlePosition.x, 0.1, circlePosition.z)
    local angle = Mathf.Atan2(direction.x, direction.z) * Mathf.Rad2Deg
    self.transform.localRotation = Quaternion.Euler(0, angle, 0)
  end
end

function LastStandGuideArrow:__delete()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.update = nil
  end
  if self.req then
    self.req:Destroy()
  end
  self.owner = nil
  self.targetPos = nil
  self.arrowObject = nil
  self.transform = nil
  self.spriteRenderer = nil
  self.isActive = false
end

return LastStandGuideArrow
