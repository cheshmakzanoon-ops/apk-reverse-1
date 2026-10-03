local base = require("Scene.Monopoly.Base.BaseObject")
local MapDecorate = BaseClass("MapDecorate", base)

function MapDecorate:OnDelete()
  if self.originChildrenVisible then
    for k, v in pairs(self.originChildrenVisible) do
      local child = self.gameObject.transform:Find(k)
      if not IsNull(child) then
        child.gameObject:SetActive(v)
      end
    end
  end
  self.originChildrenVisible = nil
  self.visible = nil
  self.childrenVisible = nil
  if self.res then
    self.res:Destroy()
    self.res = nil
    self.gameObject = nil
    self.effectNode = nil
    if self.trigger then
      self.trigger.onPointerClick = nil
      self.trigger = nil
    end
    self.triggerTransform = nil
  end
end

function MapDecorate:ArrivalBefore()
  self.res = self:CreateObject(string.format(UIAssets.MonopolyTiles, self.data.pad_before), function(req)
    local pos = self.data:GetLeftLowerWorldPos()
    req.gameObject.transform:Set_position(pos.x + 1, pos.y, pos.z - 1)
    if self.mgr.parent.transform then
      req.gameObject.transform:SetParent(self.mgr.parent.transform)
    end
    self.gameObject = req.gameObject
    if self.visible == nil then
      self.gameObject:SetActive(true)
    else
      self.gameObject:SetActive(self.visible)
    end
    if self.childrenVisible then
      for k, v in pairs(self.childrenVisible) do
        local child = self.gameObject.transform:Find(k)
        if not IsNull(child) then
          child.gameObject:SetActive(v)
        end
      end
    end
    self.effectNode = self.gameObject.transform:Find("EffectNode")
    if not IsNull(self.effectNode) then
      local curLandLock = DataCenter.MonopolyManager:GetCurrentLandLock()
      local diff = DataCenter.LWCivilizationSparkExtend:MonopolyManager_getLandLockIdDiff(self.data.land_lock, curLandLock)
      local show = 0 <= diff and diff <= 1
      self.effectNode.gameObject:SetActive(show)
    end
    if 0 < self.data.stage_feature_building_id then
      self.trigger = req.gameObject:GetComponentInChildren(typeof(CS.TouchObjectEventTrigger))
      if self.trigger then
        self.triggerTransform = self.trigger.gameObject.transform
        
        function self.trigger.onPointerClick()
          self:OnTriggerClick()
        end
      end
    end
  end)
end

function MapDecorate:OnTriggerClick()
end

function MapDecorate:SetVisible(visible)
  self.visible = visible
  if not IsNull(self.gameObject) then
    self.gameObject:SetActive(visible)
  end
end

function MapDecorate:SetChildVisible(visible, childPath)
  if self.originChildrenVisible == nil then
    self.originChildrenVisible = {}
  end
  if self.childrenVisible == nil then
    self.childrenVisible = {}
  end
  self.childrenVisible[childPath] = visible
  if not IsNull(self.gameObject) then
    local child = self.gameObject.transform:Find(childPath)
    if not IsNull(child) then
      if self.originChildrenVisible[childPath] == nil then
        self.originChildrenVisible[childPath] = child.gameObject.activeSelf
      end
      child.gameObject:SetActive(visible)
    end
  end
end

return MapDecorate
