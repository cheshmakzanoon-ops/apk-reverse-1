local LWUITrailTowerItemRender = BaseClass("LWUITrailTowerItemRender", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local nameText_path = "TrailTowerNameText"
local desText_path = "TrailTowerDesText"
local rawImage_path = "TrailTowerRawImage"
local leftImage_path = "LeftImage"
local rightImage_path = "RightImage"

function LWUITrailTowerItemRender:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWUITrailTowerItemRender:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUITrailTowerItemRender:ComponentDefine()
  self.rawImage = self:AddComponent(UIRawImage, rawImage_path)
  self.nameText = self:AddComponent(UIText, nameText_path)
  self.desText = self:AddComponent(UIText, desText_path)
  self.leftImage = self:AddComponent(UIImage, leftImage_path)
  self.rightImage = self:AddComponent(UIImage, rightImage_path)
end

function LWUITrailTowerItemRender:ComponentDestroy()
  self.rawImage = nil
  self.nameText = nil
  self.desText = nil
  self.leftImage = nil
  self.rightImage = nil
end

function LWUITrailTowerItemRender:SetData(index, trailTowerInfo, scrollViewData)
  local trailTowerTemplate = DataCenter.LWTrailTowerTemplateManager:GetTrailTowerTemplateById(trailTowerInfo.trailTowerId)
  self.itemIndex = index
  if trailTowerTemplate ~= nil then
    self.nameText:SetText(Localization:GetString(trailTowerTemplate.name))
    self.desText:SetText(Localization:GetString(trailTowerTemplate.des))
    self.rawImage:LoadSprite(trailTowerTemplate.bannerPath)
  end
  self.scrollViewData = scrollViewData
  self:SetAnchoredPosition(scrollViewData.localPos, true)
  self:SetSiblingIndex(scrollViewData.siblingIndex)
  self:SetLocalScale(scrollViewData.localScale)
  self.rawImage:SetColorRGBA(scrollViewData.color, scrollViewData.color, scrollViewData.color, 1)
  self.leftImage:SetAlpha(scrollViewData.alpha)
  self.rightImage:SetAlpha(scrollViewData.alpha)
end

function LWUITrailTowerItemRender:Move(scrollViewData, immediately)
  if not IsNull(self.sequence) then
    self.sequence:Kill()
    self.sequence = nil
  end
  self.scrollViewData = scrollViewData
  if immediately then
    self:SetAnchoredPosition(scrollViewData.localPos, true)
    self:SetSiblingIndex(scrollViewData.siblingIndex)
    self:SetLocalScale(scrollViewData.localScale)
    self.rawImage:SetColorRGBA(scrollViewData.color, scrollViewData.color, scrollViewData.color, 1)
    self.leftImage:SetAlpha(scrollViewData.alpha)
    self.rightImage:SetAlpha(scrollViewData.alpha)
  else
    self:SetSiblingIndex(self.scrollViewData.siblingIndex)
    if self.scrollViewData.alpha == 0 then
      self.leftImage:SetAlpha(self.scrollViewData.alpha)
      self.rightImage:SetAlpha(self.scrollViewData.alpha)
    else
      self.leftImage:DOFade(self.scrollViewData.alpha, 0.3)
      self.rightImage:DOFade(self.scrollViewData.alpha, 0.3)
    end
    self.sequence = CS.DG.Tweening.DOTween.Sequence()
    self.sequence:Append(self.transform:DOLocalMoveX(scrollViewData.localPos.x, 0.3):SetEase(CS.DG.Tweening.Ease.OutQuad))
    self.sequence:Join(self.transform:DOScale(Vector3.New(scrollViewData.localScale.x, scrollViewData.localScale.y, scrollViewData.localScale.z), 0.3):SetEase(CS.DG.Tweening.Ease.OutQuad))
    self.sequence:Join(CS.DG.Tweening.DOTween.To(function()
      return self.rawImage:GetColorRGBA()
    end, function(value)
      self.rawImage:SetColorRGBA(value, value, value, 1)
    end, self.scrollViewData.color, 0.3):SetEase(CS.DG.Tweening.Ease.OutQuad))
    self.sequence:OnComplete(function()
      self.sequence = nil
    end)
  end
end

return LWUITrailTowerItemRender
