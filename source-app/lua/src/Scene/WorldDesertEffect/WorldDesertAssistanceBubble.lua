local WorldDesertAssistanceBubble = BaseClass("WorldDesertAssistanceBubble")
local SpriteRenderer = CS.UnityEngine.SpriteRenderer

function WorldDesertAssistanceBubble:OnCreate(go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
    self.headIcon = self.transform:Find("Transform/HeadIcon"):GetComponent(typeof(CS.UIPlayerHead))
    self.foreground = self.transform:Find("Transform/Foreground"):GetComponent(typeof(SpriteRenderer))
    local adjuster = self.gameObject:GetComponent(typeof(CS.AutoAdjustLod))
    if adjuster ~= nil then
      adjuster.enabled = true
    end
  end
end

function WorldDesertAssistanceBubble:OnDestroy()
  self.request = nil
  self.gameObject = nil
  self.transform = nil
  self.headIcon = nil
  self.foreground = nil
end

function WorldDesertAssistanceBubble:ReInit(desertUuid, pointIndex, user)
  if IsNull(self.gameObject) then
    return
  end
  self.desertUuid = desertUuid
  self.pointIndex = pointIndex
  self.user = user
  self.playerUid = user.Uid
  local posV3 = SceneUtils.TileIndexToWorld(self.pointIndex, ForceChangeScene.World)
  posV3.z = posV3.z - 2
  self.transform.position = posV3
  self.headIcon:SetData(user.Uid, user.Pic, tonumber(user.PicVer), false)
  self.headIcon:SetCustomLoadCallback(function()
    if self.headIcon ~= nil and self.headIcon.transform ~= nil and not IsNull(self.headIcon.transform) then
      local icon = self.headIcon.transform:GetComponent(typeof(SpriteRenderer))
      if not IsNull(icon) then
        icon:Set_size(1, 1)
      end
    end
  end)
end

return WorldDesertAssistanceBubble
