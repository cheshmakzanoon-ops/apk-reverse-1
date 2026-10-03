local base = UIBaseContainer
local SkyBattlePlaneSkinItemComponent = BaseClass("SkyBattlePlaneSkinItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function SkyBattlePlaneSkinItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SkyBattlePlaneSkinItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SkyBattlePlaneSkinItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 2)
  self.compCurSkinFlag = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.imgQualityBg = self.viewSkin:AddComponent(self, UIImage, 4)
  self.compLockFlag = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.btn = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.imgShowedFlag = self.viewSkin:AddComponent(self, UIImage, 7)
  self.imgShowedFlag:SetActive(false)
  self.compCurSkinFlag:SetActive(false)
  self.compLockFlag:SetActive(false)
end

function SkyBattlePlaneSkinItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compRoot = nil
  self.imgBg = nil
  self.compCurSkinFlag = nil
  self.imgQualityBg = nil
  self.compLockFlag = nil
  self.btn = nil
  self.imgShowedFlag = nil
end

function SkyBattlePlaneSkinItemComponent:DataDefine()
end

function SkyBattlePlaneSkinItemComponent:DataDestroy()
end

function SkyBattlePlaneSkinItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function SkyBattlePlaneSkinItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SkyBattlePlaneSkinItemComponent:ReInit(data, isSelected, click)
  self.data = data
  self.isSelected = isSelected
  self.onClickHandler = click
  self.compRoot:SetLocalScaleXYZ(1, 1, 1)
  self:RefreshView()
end

function SkyBattlePlaneSkinItemComponent:RefreshView()
  local icon = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_PLANE, self.data.id, "icon")
  self.imgBg:LoadSprite(icon)
  local planeQuality = LocalController:instance():getValue(TableName.LW_SKY_BATTLE_PLANE, self.data.id, "color") or 0
  self.imgQualityBg:LoadSprite(DataCenter.LWSkyBattleGrowthChapterManager:GetQualityIcon(planeQuality))
  self.compLockFlag:SetActive(not self.data.owned)
  self.compCurSkinFlag:SetActive(self.isSelected)
end

function SkyBattlePlaneSkinItemComponent:OnBtnClick()
  if self.onClickHandler then
    self.onClickHandler()
  end
end

function SkyBattlePlaneSkinItemComponent:Move(moveData, noAnim)
  DOTween.Kill(self.compRoot.transform)
  self.moveData = moveData
  if noAnim then
    self.compRoot:SetLocalScaleXYZ(moveData.scale, moveData.scale, moveData.scale)
  else
    local targetScale = Vector3.New(moveData.scale, moveData.scale, moveData.scale)
    self.compRoot.transform:DOScale(targetScale, 0.3):SetEase(CS.DG.Tweening.Ease.OutQuad)
  end
end

function SkyBattlePlaneSkinItemComponent:SetSelected(selected)
  self.isSelected = selected
  self.compCurSkinFlag:SetActive(selected)
end

function SkyBattlePlaneSkinItemComponent:SetShow(show)
  self.isShow = show
  self.imgShowedFlag:SetActive(show)
end

return SkyBattlePlaneSkinItemComponent
