local base = UIAsyncContainer
local LWUISheepCardItem = BaseClass("LWUISheepCardItem", base)
local btn_card_path = "SheepCard"
local img_bg_path = "SheepCard/Bg"
local img_icon_path = "SheepCard/Icon"
local img_mask_path = "SheepCard/Mask"
local l_w_u_i_sheep_card_glow_path = "LWUISheepCardGlow"

function LWUISheepCardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.card = nil
  self.parent = nil
  self.firstRemoveIndex = nil
  self.removeIndex = nil
  self.isRemove = nil
  self.backShowIndex = nil
  self.backTempIndex = nil
  self.curRemoveIndex = ni
  self.tweens = {}
  self.rewards = nil
  self.removeAnim = nil
  self.refreshTween = {
    moveSpeed = nil,
    tarPosA = nil,
    needATime = nil,
    angle = nil,
    radius = nil,
    addRadius = nil,
    angleSpeed = nil,
    radiusSpeed = nil,
    opTime = nil,
    needBTime = nil,
    needCTime = nil,
    tarPosC = nil
  }
end

function LWUISheepCardItem:OnDestroy()
  self.card = nil
  self.parent = nil
  self.firstRemoveIndex = nil
  self.removeIndex = nil
  self.isRemove = nil
  self.backShowIndex = nil
  self.backTempIndex = nil
  self.curRemoveIndex = nil
  self.rewards = nil
  for _, v in ipairs(self.tweens) do
    v:Kill()
  end
  self.tweens = nil
  self.refreshTween = nil
  self.removeAnim = nil
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUISheepCardItem:ComponentDefine()
  self.btn_card = self:AddComponent(UIButton, btn_card_path)
  self.img_bg = self:AddComponent(UIImage, img_bg_path)
  self.img_icon = self:AddComponent(UIImage, img_icon_path)
  self.img_mask = self:AddComponent(UIImage, img_mask_path)
  self.btn_card:SetInteractable(true)
  self.btn_card:SetOnClick(BindCallback(self, self.OnClickCard))
  self.l_w_u_i_sheep_card_glow = self:AddComponent(UIBaseContainer, l_w_u_i_sheep_card_glow_path)
end

function LWUISheepCardItem:ComponentDestroy()
  self.btn_card = nil
  self.img_bg = nil
  self.img_icon = nil
  self.img_mask = nil
  self.l_w_u_i_sheep_card_glow = nil
end

function LWUISheepCardItem:ClearAnimData()
  if self.tweens ~= nil then
    for _, v in ipairs(self.tweens) do
      v:Kill()
    end
    self.tweens = {}
  end
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  self.refreshTween = {}
  self.removeAnim = nil
  self.l_w_u_i_sheep_card_glow:SetActive(false)
end

function LWUISheepCardItem:OnClickCard()
  if DataCenter.LWSheepDataManager:IsEnd() then
    UIUtil.ShowTipsId(370100)
    return
  end
  if self.parent.refresh or not self.parent:ISCanOp() then
    return
  end
  local success, _, isRemove, addVisualCards, isTemp = self.parent.engine:ClickCard(self.card)
  if success then
    self.btn_card:SetInteractable(false)
    self.parent:OnClickCard(isRemove, addVisualCards, self, isTemp)
  end
end

function LWUISheepCardItem:ForcePos(pos)
  self.rectTransform.anchoredPosition = Vector2(pos.x, pos.y)
end

function LWUISheepCardItem:RefreshIcon()
  local icon = GetTableData(TableName.LW_SEASON_BLOCK_SHEEP, self.card.pictureId, "appearance")
  self.img_icon:LoadSprite(icon)
end

function LWUISheepCardItem:RefreshMask()
  local visual = self.parent.visualList[self.card.gridId] ~= nil
  self.img_mask:SetActive(not visual)
  self.btn_card:SetInteractable(visual)
end

function LWUISheepCardItem:RefreshShow(card, parent)
  if IsNull(self.gameObject) then
    return
  end
  self.gameObject.name = string.format("%d_%d_%d", card.pos.x, card.pos.y, card.pos.z)
  self.parent = parent
  self.card = card
  local pos = self.card:GetUIPosInGameArena()
  self:ForcePos(pos)
  self:RefreshIcon()
  self:RefreshMask()
  self.btn_card:SetLocalScaleXYZ(1, 1, 1)
end

function LWUISheepCardItem:RefreshItem(card, parent)
  if IsNull(self.gameObject) then
    return
  end
  self.gameObject.name = string.format("%d_%d_%d", card.pos.x, card.pos.y, card.pos.z)
  self.parent = parent
  self.card = card
  self:RefreshIcon()
  self:RefreshMask()
  self.btn_card:SetLocalScaleXYZ(1, 1, 1)
end

function LWUISheepCardItem:RefreshRemove(card, parent, index)
  if IsNull(self.gameObject) then
    return
  end
  self.gameObject.name = string.format("%d_%d_%d", card.pos.x, card.pos.y, card.pos.z)
  self.parent = parent
  self.curRemoveIndex = index
  self.card = card
  local pos = self.card:GetUIPosXInRemoveArena(index)
  self:ForcePos({x = pos, y = 0})
  self:RefreshIcon()
  self.img_mask:SetActive(false)
  self.btn_card:SetInteractable(false)
  self.btn_card:SetLocalScaleXYZ(1, 1, 1)
end

function LWUISheepCardItem:RefreshCard(card)
  self.gameObject.name = string.format("%d_%d_%d", card.pos.x, card.pos.y, card.pos.z)
  self.card = card
end

function LWUISheepCardItem:RefreshTemporary(card, parent)
  if IsNull(self.gameObject) then
    return
  end
  self.gameObject.name = string.format("%d_%d_%d", card.pos.x, card.pos.y, card.pos.z)
  self.parent = parent
  self.card = card
  local pos = self.card:GetUIPosXInTempArena()
  self:ForcePos({x = pos, y = 0})
  self:RefreshIcon()
  self:RefreshMask()
  self.btn_card:SetLocalScaleXYZ(1, 1, 1)
end

function LWUISheepCardItem:PlayRemoveAnim(callback, callback1)
  if not self.removeAnim then
    self.removeAnim = true
    self.l_w_u_i_sheep_card_glow:SetActive(false)
    self.l_w_u_i_sheep_card_glow:SetActive(true)
    table.insert(self.tweens, self.btn_card.transform:DOScale(Vector3.New(0, 0, 0), 0.1):OnComplete(function()
      callback1()
    end):SetEase(CS.DG.Tweening.Ease.Linear))
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.removeAnim = false
      self.btn_card:SetLocalScaleXYZ(1, 1, 1)
      callback()
      self.l_w_u_i_sheep_card_glow:SetActive(false)
      if self.delayTimer then
        self.delayTimer:Stop()
        self.delayTimer = nil
      end
    end, 1)
  end
end

function LWUISheepCardItem:SetBackShowIndex()
  self.backShowIndex = self.card.gridId
  self.firstRemoveIndex = nil
  self.removeIndex = nil
  self.isRemove = nil
end

function LWUISheepCardItem:SetBackTempIndex()
  self.backTempIndex = self.card.gridId
  self.firstRemoveIndex = nil
  self.removeIndex = nil
  self.isRemove = nil
end

function LWUISheepCardItem:SetRefreshOriginPos(angle, radius, tarPos, needTime)
  self.refreshTween.angle = angle
  self.refreshTween.radius = radius
  local reTarPos = tarPos - Vector3.New(self.rectTransform.sizeDelta.x * 0.5, self.rectTransform.sizeDelta.y * 0.5)
  self.refreshTween.tarPosA = reTarPos
  self.refreshTween.needATime = needTime
  local distance = Vector3.Distance(self.transform.position, reTarPos)
  self.refreshTween.moveSpeed = distance / needTime
end

function LWUISheepCardItem:SetRefreshMaxRadius(angleSpeed, addRadius, needTime)
  self.refreshTween.addRadius = addRadius
  self.refreshTween.angleSpeed = angleSpeed
  self.refreshTween.needBTime = needTime
  self.refreshTween.radiusSpeed = addRadius / (needTime - 0.3)
  self.refreshTween.opTime = 0
end

function LWUISheepCardItem:SetRefreshEndPos(time)
  self.refreshTween.needCTime = time
end

function LWUISheepCardItem:DoRefreshAnim()
  if self.refreshTween.tarPosA ~= nil then
    UIUtil.MovePosition(self, self.refreshTween.tarPosA, 0, self.refreshTween.moveSpeed, function()
      self.refreshTween.tarPosA = nil
      self.refreshTween.needATime = nil
    end)
  elseif self.refreshTween.addRadius ~= nil then
    local dt = Time.deltaTime
    self.refreshTween.opTime = self.refreshTween.opTime + Time.deltaTime
    self.refreshTween.angle = self.refreshTween.angle + dt * self.refreshTween.angleSpeed
    self.refreshTween.radius = self.refreshTween.radius + self.refreshTween.radiusSpeed * dt
    local circlePos = self.view.sheep_show_arena.transform.position
    local angle_in_degrees = self.refreshTween.angle * (math.pi / 180)
    local tarPos = circlePos + self.refreshTween.radius * Vector2.New(math.sin(angle_in_degrees), math.cos(angle_in_degrees))
    tarPos = tarPos - Vector3.New(self.rectTransform.sizeDelta.x * 0.5, self.rectTransform.sizeDelta.y * 0.5)
    self:SetPosition(tarPos)
    if self.refreshTween.opTime > self.refreshTween.needBTime then
      self.refreshTween.angle = nil
      self.refreshTween.radius = nil
      self.refreshTween.addRadius = nil
      self.refreshTween.angleSpeed = nil
      self.refreshTween.radiusSpeed = nil
      self.refreshTween.opTime = nil
      self.refreshTween.needBTime = nil
    end
  end
end

function LWUISheepCardItem:ClearRefreshAnimC()
  self.refreshTween.needCTime = nil
  table.clear(self.refreshTween)
end

return LWUISheepCardItem
