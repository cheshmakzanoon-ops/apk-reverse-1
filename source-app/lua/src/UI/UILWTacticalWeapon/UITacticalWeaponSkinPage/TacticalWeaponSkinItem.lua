local TacticalWeaponSkinItem = BaseClass("TacticalWeaponSkinItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function TacticalWeaponSkinItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function TacticalWeaponSkinItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TacticalWeaponSkinItem:OnEnable()
  base.OnEnable(self)
end

function TacticalWeaponSkinItem:OnDisable()
  base.OnDisable(self)
end

function TacticalWeaponSkinItem:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, "root")
  self.compSelectBgFlag = self:AddComponent(UIImage, "root/selectBgFlag")
  self.imgBg = self:AddComponent(UIImage, "root/bg")
  self.compCurSkinFlag = self:AddComponent(UIBaseContainer, "root/curSkinFlag")
  self.imgQualityArrow = self:AddComponent(UIImage, "root/curSkinFlag/qualityArrow")
  self.compLockFlag = self:AddComponent(UIBaseContainer, "root/lockFlag")
  self.btn = self:AddComponent(UIButton, "root/btn")
  self.btn:SetOnClick(function()
    self:ClickBtn()
  end)
end

function TacticalWeaponSkinItem:ComponentDestroy()
  self.root:SetLocalScaleXYZ(1, 1, 1)
  self.compSelectBgFlag:SetAlpha(0)
  self.compSelectBgFlag = nil
  self.imgBg = nil
  self.compCurSkinFlag = nil
  self.imgQualityArrow = nil
  self.compLockFlag = nil
  self.root = nil
end

function TacticalWeaponSkinItem:DataDefine()
end

function TacticalWeaponSkinItem:DataDestroy()
  self.data = nil
  self.currentSelect = nil
end

function TacticalWeaponSkinItem:ReInit(data, currentSelect, click)
  self.data = data
  self.currentSelect = currentSelect
  self.onClickHandler = click
  self:RefreshView()
end

function TacticalWeaponSkinItem:RefreshView()
  self.compSelectBgFlag:SetActive(self.data.id == self.currentSelect)
  local template = DataCenter.DecorationTemplateManager:GetTemplate(self.data.id)
  if template then
    if not string.IsNullOrEmpty(template.special_image) then
      self.imgBg:LoadSprite(string.format("Assets/Main/Sprites/UI/LWUITacticalWeapon/%s", template.special_image))
    end
    self.imgQualityArrow:LoadSprite(self:GetQualityArrow(template.quality))
  end
  self.compLockFlag:SetActive(not self.data.isUnlock)
  self.compCurSkinFlag:SetActive(self.data.inUse)
  self.template = template
end

function TacticalWeaponSkinItem:GetQuality()
  return self.template.quality
end

function TacticalWeaponSkinItem:ClickBtn()
  if self.onClickHandler then
    self.onClickHandler()
  end
end

function TacticalWeaponSkinItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DecorationIconSelect, self.OnSelectEvent)
end

function TacticalWeaponSkinItem:OnRemoveListener()
  self:RemoveUIListener(EventId.DecorationIconSelect, self.OnSelectEvent)
  base.OnRemoveListener(self)
end

function TacticalWeaponSkinItem:OnSelectEvent(decorationId)
  self.currentSelect = decorationId
  self.compSelectBgFlag:SetActive(self.data.id == self.currentSelect)
end

function TacticalWeaponSkinItem:Move(moveData, playAni)
  if not IsNull(self.sequence) then
    self.sequence:Kill()
    self.sequence = nil
  end
  self.moveData = moveData
  if playAni then
    self.root:SetLocalScaleXYZ(moveData.scale, moveData.scale, moveData.scale)
    self.compSelectBgFlag:SetAlpha(moveData.alpha)
  else
    if self.moveData.alpha == 0 then
      self.compSelectBgFlag:SetAlpha(self.moveData.alpha)
    else
      self.compSelectBgFlag:DOFade(self.moveData.alpha, 0.3)
    end
    local targetScale = Vector3.New(moveData.scale, moveData.scale, moveData.scale)
    self.root.transform:DOScale(targetScale, 0.3):SetEase(CS.DG.Tweening.Ease.OutQuad)
  end
end

function TacticalWeaponSkinItem:OnSelect()
  EventManager:GetInstance():Broadcast(EventId.DecorationIconSelect, self.data.id)
end

function TacticalWeaponSkinItem:GetQualityArrow(quality)
  return string.format("Assets/Main/Sprites/UI/LWUITacticalWeapon/FX_wurenjipifu_jiaobiao0%s.png", quality - 2)
end

return TacticalWeaponSkinItem
