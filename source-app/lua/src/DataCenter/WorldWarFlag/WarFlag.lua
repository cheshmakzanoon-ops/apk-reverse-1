local WarFlag = BaseClass("WarFlag")
local ResourceManager = CS.GameEntry.Resource
local SpriteRenderer = typeof(CS.UnityEngine.SpriteRenderer)

function WarFlag:__init()
  self.isVisible = true
end

function WarFlag:__delete()
  self:Destroy()
end

function WarFlag:Destroy()
  self.data = nil
  self:DestroyFlagEntity()
end

function WarFlag:UpdateData(data)
  self.data = data
  self.uuid = data.uuid
  local scale = 0.5 + self.data.meta.halo_radius
  local lodRangeScale = scale * 3.95
  self.scale = Vector3.New(scale, scale, scale)
  self.lodRangeScale = Vector3.New(lodRangeScale, 1, lodRangeScale)
end

function WarFlag:RefreshImpl()
  if IsNull(self.goWarFlagBase) then
    return
  end
  if not self.isVisible then
    self:DestroyFlagEntity()
    return
  end
  if self.model and not self.asyncModel and IsNotNull(self.goModel) and self.data.meta.prefab then
    self.asyncModel = UIAsyncNode.New("[WarFlag][Model]", self.goModel.transform, self.data.meta.prefab, function(go)
      if IsNotNull(go) then
        local range = go.transform:Find("range")
        if IsNotNull(range) then
          range.localScale = self.scale
        end
      end
      self.asyncModel:SetActive(true)
      self:RefreshImpl()
    end)
  end
  self.goIconNode:SetActive(self.icon)
  self.goModel:SetActive(self.model)
end

function WarFlag:RefreshVisibleState(lod, displayLevel, minX, minY, maxX, maxY)
  if not self.data then
    self.isVisible = false
  else
    self.isVisible = not (maxX < self.data.minX) and not (minX > self.data.maxX) and not (maxY < self.data.minY) and not (minY > self.data.maxY)
  end
  if self.isVisible then
    self.model, self.icon = WorldSimpleModeUtils.ShowWarFlag()
  else
    self.model, self.icon = false, false
  end
  if self.isVisible then
    if not self.baseRequest and not string.IsNullOrEmpty(self.data.meta.flagBasePrefab) then
      self.baseRequest = ResourceManager:InstantiateAsync(self.data.meta.flagBasePrefab)
      self.baseRequest:completed("+", function()
        self.goWarFlagBase = self.baseRequest.gameObject
        self.tranWarFlagBase = self.goWarFlagBase.transform
        self.goModel = self.tranWarFlagBase:Find("ModelNode").gameObject
        self.goIconNode = self.tranWarFlagBase:Find("IconNode").gameObject
        self.spIcon = self.tranWarFlagBase:Find("IconNode/IconScaleNode/Icon"):GetComponent(SpriteRenderer)
        self.tranWarFlagBase:SetParent(CS.SceneManager.World.DynamicObjNode)
        self.tranWarFlagBase:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        self.tranWarFlagBase:Find("IconNode/Range").localScale = self.lodRangeScale
        if CommonUtil.IsDebug() then
          self.goWarFlagBase.name = string.format("[WarFlag][%s]%s", self.data.cfgId, self.data.uuid)
        end
        local worldPos = SceneUtils.TileIndexToWorld(self.data.pointId, ForceChangeScene.World, self.data.serverId)
        self.tranWarFlagBase:Set_position(worldPos.x, worldPos.y, worldPos.z)
        self:RefreshImpl()
      end)
    else
      self:RefreshImpl()
    end
  else
    self:DestroyFlagEntity()
  end
end

function WarFlag:DestroyFlagEntity()
  if self.asyncModel then
    self.asyncModel:Delete()
    self.asyncModel = nil
  end
  if self.baseRequest then
    self.baseRequest:Destroy()
    self.baseRequest = nil
  end
  self.goWarFlagBase = nil
  self.tranWarFlagBase = nil
  self.goModel = nil
  self.goIconNode = nil
  self.spIcon = nil
end

function WarFlag:Description()
  local sb = StringBuilder.New()
  if self.data then
    sb:AppendFormat("[%s]%s[%s]", self.isVisible and "\229\143\175\232\167\129" or "\228\184\141\229\143\175\232\167\129", self.data:Description(), self.request and "\229\183\178\229\138\160\232\189\189" or "-")
  else
    sb:AppendFormat("[%s]%s[%s]", self.isVisible and "\229\143\175\232\167\129" or "\228\184\141\229\143\175\232\167\129", "NULL", self.request and "\229\183\178\229\138\160\232\189\189" or "-")
  end
  return sb:ToString()
end

return WarFlag
