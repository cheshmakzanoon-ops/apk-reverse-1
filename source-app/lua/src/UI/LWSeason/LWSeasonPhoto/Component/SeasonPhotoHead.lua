local base = UIBaseContainer
local SeasonPhotoHead = BaseClass("SeasonPhotoHead", base)
local icon_path = "HeadIcon"
local frame_path = "HeadFrame"
local trigger_path = ""
local lock_path = "HeadLock"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.icon = self:AddComponent(UIBaseContainer, icon_path)
  self.frame = self:AddComponent(UIImage, frame_path)
  self.trigger = self:AddComponent(UIEventTrigger, trigger_path)
  self.lock = self:AddComponent(UIBaseContainer, lock_path)
  self.trigger:OnPointerClick(function(eventData)
    self:OnPointerClick(eventData)
  end)
  local head = self.transform:Find("HeadIcon")
  self.uiPlayerHead = head:GetComponent(typeof(CS.UIPlayerHead))
end

local function ComponentDestroy(self)
  if not IsNull(self.uiPlayerHead) then
    self.uiPlayerHead:SetCustomLoadCallback(nil)
  end
  if self.simpleAnim then
    self.simpleAnim:Stop()
    self.simpleAnim = nil
  end
  self.uiPlayerHead = nil
  self.simpleAnim = nil
  self.icon = nil
  self.frame = nil
  self.trigger = nil
  self.lock = nil
end

local function DataDefine(self)
  self.initDrag = false
end

local function DataDestroy(self)
end

function SeasonPhotoHead:ReInit(index, data, member, tileSize, canEdit)
  self.index = index
  self.data = data
  self.member = member
  self.canEdit = canEdit
  self.canMove = canEdit and data and (data.uid == LuaEntry.Player.uid or member.otherModify and DataCenter.AllianceBaseDataManager:IsR4orR5())
  if self.canEdit then
    self:InitDrag()
    self.lock:SetActive(not self.canMove)
  else
    self.lock:SetActive(false)
  end
  if data and data.posX and tileSize then
    self:SetPosition(data.posX, data.posY, tileSize)
  end
  local pic, picVer = data and data.pic, data and data.picVer
  if string.IsNullOrEmpty(pic) and (not picVer or picVer <= 0) then
    pic = member.pic
    picVer = member.picVer
  end
  if member.frame ~= nil and member.frame ~= "" then
    self.frame:LoadSpriteAsyncEx(member.frame)
  end
  self:SetHead(member.uid, pic, picVer)
end

function SeasonPhotoHead:SetPosition(tileX, tileY, tileSize, save)
  if save then
    self.data.posX = tileX
    self.data.posY = tileY
  end
  self:SetLocalPositionXYZ(tileX * tileSize, tileY * tileSize, 0)
end

function SeasonPhotoHead:ResetPosition(tileSize)
  self:SetLocalPositionXYZ(self.data.posX * tileSize, self.data.posY * tileSize, 0)
end

function SeasonPhotoHead:SetLocalPositionXYZ(x, y, z)
  if self.rectTransform then
    self.rectTransform:Set_localPosition(x, y, z)
  end
end

function SeasonPhotoHead:CheckOverlap(targetX, targetY, targetHeadSize)
  local selfX = self.data.posX
  local selfY = self.data.posY
  local selfHeadSize = self.member.headSize
  if targetX >= selfX + selfHeadSize or selfX >= targetX + targetHeadSize or targetY >= selfY + selfHeadSize or selfY >= targetY + targetHeadSize then
    return false
  end
  return true
end

function SeasonPhotoHead:OnPointerClick(eventData)
  if eventData.dragging then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = false}, self.member.uid)
end

function SeasonPhotoHead:InitDrag()
  if self.initDrag or not self.trigger then
    return
  end
  self.initDrag = true
  self.trigger:OnBeginDrag(function(eventData)
    self:OnBeginDrag(eventData)
  end)
  self.trigger:OnEndDrag(function(eventData)
    self:OnEndDrag(eventData)
  end)
  self.trigger:OnDrag(function(eventData)
    self:OnDrag(eventData)
  end)
end

function SeasonPhotoHead:OnBeginDrag(eventData)
  if not self.canEdit then
    return
  end
  if not self.canMove then
    if DataCenter.AllianceBaseDataManager:IsR4orR5() then
      UIUtil.ShowTipsId("season_alliance_photo_tips_5")
    else
      UIUtil.ShowTipsId("season_alliance_photo_tips_24")
    end
    return
  end
  EventManager:GetInstance():Broadcast(EventId.SeasonPhotoHeadBeginDrag, self)
  self:SetSiblingIndex(999)
end

function SeasonPhotoHead:OnEndDrag(eventData)
  if not self.canEdit then
    return
  end
  local pos = eventData.position
  EventManager:GetInstance():Broadcast(EventId.SeasonPhotoHeadEndDrag, {
    x = pos.x,
    y = pos.y
  })
end

function SeasonPhotoHead:OnDrag(eventData)
  if not self.canEdit then
    return
  end
  local pos = eventData.position
  EventManager:GetInstance():Broadcast(EventId.SeasonPhotoHeadDrag, {
    x = pos.x,
    y = pos.y
  })
end

function SeasonPhotoHead:PlayAnim(anim)
  if not self.simpleAnim then
    self.simpleAnim = self:AddComponent(UISimpleAnimation, "")
  end
  anim = anim or "Default"
  self.simpleAnim:Stop()
  self.simpleAnim:Play(anim)
end

function SeasonPhotoHead:SetHead(uid, pic, picVer)
  local useBig = false
  self.pic = pic
  self.picVer = picVer
  if uid then
    local specifiedRes
    if pic and pic ~= "" and type(pic) == "string" then
      local pic1, pic2 = string.match(pic, "(Assets/Main/.*)(Assets/Main/.*)")
      if pic1 and pic2 then
        specifiedRes = pic2
      elseif string.startswith(pic, "Assets/Main/") then
        specifiedRes = pic
      end
    end
    if specifiedRes then
      self.uiPlayerHead:UseSpecifiedRes(specifiedRes)
    elseif not pic and not picVer then
      self.uiPlayerHead:UseSystemHead()
    else
      self.uiPlayerHead:SetData(uid, pic, tonumber(picVer), useBig)
    end
  elseif pic and pic ~= "" and type(pic) == "string" and string.startswith(pic, "Assets/Main/") then
    self.uiPlayerHead:UseSpecifiedRes(pic)
  elseif pic and pic ~= "" and type(pic) == "string" and string.startswith(pic, "player_head_") then
    self.uiPlayerHead:SetData("", pic, 0, false)
  else
    self.uiPlayerHead:UseSystemHead()
  end
end

SeasonPhotoHead.OnCreate = OnCreate
SeasonPhotoHead.OnDestroy = OnDestroy
SeasonPhotoHead.OnEnable = OnEnable
SeasonPhotoHead.OnDisable = OnDisable
SeasonPhotoHead.ComponentDefine = ComponentDefine
SeasonPhotoHead.ComponentDestroy = ComponentDestroy
SeasonPhotoHead.DataDefine = DataDefine
SeasonPhotoHead.DataDestroy = DataDestroy
return SeasonPhotoHead
