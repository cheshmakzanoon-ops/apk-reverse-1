local BountyHunterBullet = BaseClass("BountyHunterBullet")
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local TouchObjectEventTrigger = CS.TouchObjectEventTrigger
local SHOOT_TIME = 0.25
local BULLET_SCALE = 1
local HIT_EFF_SCALE = 1

local function __init(self, parentTrans)
  self.isLoadFinish = false
  self.index = 0
  self.parentTrans = parentTrans
end

local function __delete(self)
  self.isLoadFinish = nil
  if self.delayShowTimer then
    self.delayShowTimer:Stop()
    self.delayShowTimer = nil
  end
  if self.bulletLoadReq then
    self.bulletLoadReq:Destroy()
    self.bulletLoadReq = nil
  end
  if self.hitEffLoadReq then
    self.hitEffLoadReq:Destroy()
    self.hitEffLoadReq = nil
  end
  if self.hitEffTimer then
    self.hitEffTimer:Stop()
    self.hitEffTimer = nil
  end
  self.index = nil
end

function BountyHunterBullet:ReInit(bulletPrefabPath, hitPrefabPath, startWorldPos, endWorldPos, shootCallback, delayTime)
  self.startWorldPos = startWorldPos
  self.endWorldPos = endWorldPos
  self.shootTime = SHOOT_TIME
  self.bulletPrefabPath = bulletPrefabPath
  self.hitPrefabPath = hitPrefabPath
  self.shootCallback = shootCallback
  if self.bulletLoadReq then
    self.bulletLoadReq:Destroy()
    self.bulletLoadReq = nil
  end
  if self.delayShowTimer then
    self.delayShowTimer:Stop()
    self.delayShowTimer = nil
  end
  self.delayShowTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.bulletLoadReq = self:LoadModel(self.bulletPrefabPath, self.parentTrans, nil, nil, BULLET_SCALE, function()
      self:OnBulletModelLoadFinish()
    end)
  end, delayTime)
end

function BountyHunterBullet:LoadModel(prefabPath, parent, initLocalPos, initRotation, scale, callback)
  if string.IsNullOrEmpty(prefabPath) then
    Logger.LogError("path is null!")
    return
  end
  self.callback = callback
  self.isLoadFinish = false
  local loadModelReq = Resource:InstantiateAsync(prefabPath)
  loadModelReq:completed("+", function(req)
    if req.isError then
      if callback then
        callback()
      end
      Logger.LogError("bounty hunter bullet model load fail")
      return
    end
    local transform = req.gameObject.transform
    transform:Set_localScale(1, 1, 1)
    if parent then
      transform:SetParent(parent.transform)
    end
    if initLocalPos then
      transform:Set_localPosition(initLocalPos.x, initLocalPos.y, initLocalPos.z)
    else
      transform:Set_localPosition(0, 0, 0)
    end
    if initRotation then
      transform:Set_localRotation(initRotation.x, initRotation.y, initRotation.z, 1)
    else
      transform:Set_localRotation(0, 0, 0, 1)
    end
    if scale then
      transform:Set_localScale(scale, scale, scale)
    end
    transform.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("timeline"))
    if callback then
      callback()
    end
  end)
  return loadModelReq
end

function BountyHunterBullet:OnBulletModelLoadFinish()
  if not self.bulletLoadReq or not self.bulletLoadReq.gameObject then
    return
  end
  local bulletTrans = self.bulletLoadReq.gameObject.transform
  bulletTrans.gameObject:SetActive(true)
  bulletTrans.position = self.startWorldPos
  local dir = self.endWorldPos - self.startWorldPos
  local targetRotation = Quaternion.LookRotation(Vector3(dir.x, dir.y, dir.z))
  bulletTrans.rotation = targetRotation
  self.moveTween = bulletTrans:DOMove(self.endWorldPos, self.shootTime)
  self.moveTween:OnComplete(function()
    self.moveTween = nil
    self:ShowHitEff()
  end)
end

function BountyHunterBullet:ShowHitEff()
  if self.bulletLoadReq and self.bulletLoadReq.gameObject then
    self.bulletLoadReq.gameObject:SetActive(false)
  end
  if self.hitEffLoadReq then
    self.hitEffLoadReq:Destroy()
    self.hitEffLoadReq = nil
  end
  self.hitEffLoadReq = self:LoadModel(self.hitPrefabPath, nil, nil, nil, HIT_EFF_SCALE, function()
    self:OnHitEffModelLoadFinish()
  end)
end

function BountyHunterBullet:OnHitEffModelLoadFinish()
  if not self.hitEffLoadReq or not self.hitEffLoadReq.gameObject then
    if self.shootCallback then
      self.shootCallback()
    end
    return
  end
  self.hitEffLoadReq.gameObject.transform.position = self.endWorldPos
  self.hitEffLoadReq.gameObject:SetActive(true)
  self.hitEffTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.hitEffTimer = nil
    if self.shootCallback then
      self.shootCallback()
    end
  end, 1)
end

function BountyHunterBullet:Hide()
  if self.bulletLoadReq and self.bulletLoadReq.gameObject then
    self.bulletLoadReq.gameObject:SetActive(false)
  end
  if self.hitEffLoadReq and self.hitEffLoadReq.gameObject then
    self.hitEffLoadReq.gameObject:SetActive(false)
  end
end

function BountyHunterBullet:StopAllTween()
  if self.moveTween then
    self.moveTween:Kill()
    self.moveTween = nil
  end
end

function BountyHunterBullet:Destroy()
  if self.loadModelReq then
    self.loadModelReq:Destroy()
    self.loadModelReq = nil
  end
  self.isLoadFinish = nil
  if self.bulletLoadReq then
    self.bulletLoadReq:Destroy()
    self.bulletLoadReq = nil
  end
  if self.hitEffLoadReq then
    self.hitEffLoadReq:Destroy()
    self.hitEffLoadReq = nil
  end
  if self.hitEffTimer then
    self.hitEffTimer:Stop()
    self.hitEffTimer = nil
  end
  self.index = nil
end

BountyHunterBullet.__init = __init
BountyHunterBullet.__delete = __delete
return BountyHunterBullet
