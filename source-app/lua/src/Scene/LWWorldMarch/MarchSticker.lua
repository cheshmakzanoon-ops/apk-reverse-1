local MarchSticker = BaseClass("MarchSticker")
local frameRate = 18
local Shader = CS.UnityEngine.Shader
local unity_time = CS.UnityEngine.Time

function MarchSticker:Init(squad, req)
  self.squad = squad
  self.m_req = req
end

function MarchSticker:__delete()
  DOTween.Kill(self.transform)
  self.gameObject = nil
  self.transform = nil
  self.stickerData = nil
  self.squad = nil
  if self.m_req then
    self.m_req:Destroy()
  end
  self.m_req = nil
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
  if self.specialDelay then
    self.specialDelay:Stop()
    self.specialDelay = nil
  end
  self.mesh = nil
  self.mesh_static = nil
end

function MarchSticker:OnCreate(localPos, props)
  if self.m_req then
    self.gameObject = self.m_req.gameObject
    self.transform = self.gameObject.transform
  end
  self.gameObject:SetActive(false)
  if self.squad then
    self.transform:SetParent(self.squad.transform)
  end
  if not localPos then
    self.transform:Set_localPosition(0, 3.5, 0)
  else
    self.transform:Set_localPosition(localPos.x, localPos.y, localPos.z)
  end
  self.props = props
  self.playSpeed = Shader.PropertyToID("_PlaySpeed")
  self.mainTex = Shader.PropertyToID("_MainTex")
  self.startX = Shader.PropertyToID("_StartX")
  self.curShowIndex = Shader.PropertyToID("_CurShowIndex")
  self.startTime = Shader.PropertyToID("_StartTime")
end

function MarchSticker:ShowSticker(stickerId, bUuid, numParam, isSimpleMode)
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
  if self.specialDelay then
    self.specialDelay:Stop()
    self.specialDelay = nil
  end
  if IsNull(self.gameObject) or IsNull(self.transform) then
    return
  end
  local rowCfg = LocalController:instance():getLine(TableName.LW_Sticker, tostring(stickerId))
  self.numParam = numParam
  if not rowCfg then
    return
  end
  self.gameObject:SetActive(false)
  self.gameObject:SetActive(true)
  if not self.mesh then
    self.mesh = self.gameObject.transform:Find("sticker").gameObject:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  end
  if not self.mesh_static then
    self.mesh_static = self.gameObject.transform:Find("sticker_static").gameObject:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
  end
  self.mesh.gameObject:SetActive(not isSimpleMode)
  self.mesh_static.gameObject:SetActive(isSimpleMode)
  if isSimpleMode then
    local spritePath = string.format(ChatStickerCoverPath, rowCfg.name)
    if stickerId == 5 and numParam then
      spritePath = string.format(ChatStickerDicePath, numParam)
    end
    self.mesh_static:LoadSpriteAsync(spritePath, function()
      if IsNotNull(self.mesh_static) then
        self.mesh_static.size = Vector2.New(2, 2)
      end
    end)
  else
    if self.props == nil then
      self.props = CS.UnityEngine.MaterialPropertyBlock()
    end
    local spritePath = ""
    local startPosX = 0
    if string.IsNullOrEmpty(rowCfg.para1) then
      spritePath = string.format(ChatStickerDynamicPath, rowCfg.name)
      startPosX = 0
    else
      spritePath = ChatStickerImagePatch .. rowCfg.para1
      startPosX = tonumber(rowCfg.para2)
    end
    self.mesh:LoadSpriteAsync(spritePath, function()
      if IsNull(self.mesh) then
        return
      end
      self.props:SetFloat(self.playSpeed, frameRate)
      self.props:SetFloat(self.curShowIndex, 0)
      self.props:SetFloat(self.startTime, unity_time.timeSinceLevelLoad)
      self.props:SetTexture(self.mainTex, self.mesh.sprite.texture)
      self.props:SetFloat(self.startX, startPosX)
      self.mesh:SetPropertyBlock(self.props)
      self.mesh.size = Vector2.New(2, 2)
    end)
  end
  DOTween.Kill(self.transform)
  self.transform:Set_localScale(0, 0, 0)
  self.transform:DOScale(Vector3.one, 0.2)
  local specialShowTime = 0
  if stickerId == 5 and numParam and not isSimpleMode then
    specialShowTime = 0.5
  end
  self.delay = TimerManager:GetInstance():DelayInvoke(function()
    DOTween.Kill(self.transform)
    self.transform:DOScale(Vector3.zero, 0.2):OnComplete(function()
      self.gameObject:SetActive(false)
    end):SetEase(CS.DG.Tweening.Ease.InOutCubic)
  end, rowCfg.frame_rate / frameRate + specialShowTime)
  if 0 < specialShowTime then
    self.specialDelay = TimerManager:GetInstance():DelayInvoke(function()
      local path = string.format(ChatStickerDicePath, numParam)
      self.mesh:LoadSprite(path)
      self.mesh.size = Vector2.New(2, 2)
    end, rowCfg.frame_rate / frameRate)
  end
end

return MarchSticker
