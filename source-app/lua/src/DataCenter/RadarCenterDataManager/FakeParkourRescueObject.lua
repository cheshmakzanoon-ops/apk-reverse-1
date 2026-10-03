local base = UIAsyncNode
local FakeParkourRescueObject = BaseClass("FakeParkourRescueObject", base)
local Resource = CS.GameEntry.Resource
local firstManHideTime = 0.6
local secondManHideTime = 1.2
local firstShowBoomEffectTime = 3
local secondShowBoomEffectTime = 3.5
local boomEffectPath = "Assets/_Art/Effect/prefab/scene/Common/VFX_baozha.prefab"

function FakeParkourRescueObject:OnCreate()
  base.OnCreate(self)
  local transform = self.transform
  if IsNull(transform) then
    return
  end
  self.boomEffectObject = nil
  self.needShowFirstBoomEffect = true
  self.needShowSecondBoomEffect = true
  self.isCollect = false
  self.boomEffectObjectReq = nil
  self.firstMan = transform:Find("Model/normalType/A_Hero_bubing02_1").gameObject
  self.secondMan = transform:Find("Model/normalType/A_Hero_bubing02_2").gameObject
  self.firstMan:SetActive(true)
  self.firstManActive = true
  self.secondMan:SetActive(true)
  self.secondManActive = true
  self.updateTime = 0
end

function FakeParkourRescueObject:OnDestroy()
  if self.boomEffectObject then
    self.boomEffectObject:Delete()
    self.boomEffectObject = nil
  end
  self.updateTime = nil
  self.boomEffectObject = nil
  self.needShowFirstBoomEffect = nil
  self.needShowSecondBoomEffect = nil
  self.isCollect = nil
  self.firstMan = nil
  self.secondMan = nil
  self.firstManActive = nil
  self.secondManActive = nil
  base.OnDestroy(self)
end

function FakeParkourRescueObject:UpdateData()
end

function FakeParkourRescueObject:Update()
  if not self.isCollect then
    return
  end
  self.updateTime = self.updateTime + Time.deltaTime
  if self.firstMan and self.firstManActive and self.updateTime > firstManHideTime then
    self.firstMan:SetActive(false)
    self.firstManActive = false
  end
  if self.secondMan and self.secondManActive and self.updateTime > secondManHideTime then
    self.secondMan:SetActive(false)
    self.secondManActive = false
  end
  if self.updateTime > secondShowBoomEffectTime and self.needShowSecondBoomEffect then
    self.needShowSecondBoomEffect = false
    self:HideBoomParticle()
    self:ShowBoomParticle()
  end
  if self.updateTime > firstShowBoomEffectTime and self.needShowFirstBoomEffect then
    self.needShowFirstBoomEffect = false
    self:HideBoomParticle()
    self:ShowBoomParticle()
  end
end

function FakeParkourRescueObject:DoWhenCollectStart()
  self.isCollect = true
end

function FakeParkourRescueObject:ShowBoomParticle()
  if self.boomEffectObject ~= nil then
    self.boomEffectObject:SetActive(true)
  else
    local transform = self.transform
    if IsNull(transform) then
      return
    end
    self.boomEffectObject = UIAsyncNode.New("boomEffectObject", transform, boomEffectPath, function(go)
      if IsNotNull(go) then
        go.transform:Set_localScale(0.3, 0.3, 0.3)
      end
    end)
    self.boomEffectObject:SetActive(true)
  end
end

function FakeParkourRescueObject:HideBoomParticle()
  if self.boomEffectObject ~= nil then
    self.boomEffectObject:SetActive(false)
  end
end

return FakeParkourRescueObject
