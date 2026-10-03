local base = UIBaseContainer
local LWBoxRewardComponent = BaseClass("LWBoxRewardComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local GameObject = CS.UnityEngine.GameObject

function LWBoxRewardComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWBoxRewardComponent:OnDestroy()
  self:KillTween()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWBoxRewardComponent:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, "boxBig")
  self.boxBig = self:AddComponent(UIBaseContainer, "boxBig/bigBox")
  self.imgBigBox = self:AddComponent(UIRawImage, "boxBig/bigBox/bigBox")
  self.imgBigBoxOpen = self:AddComponent(UIRawImage, "boxBig/bigBox/bigBoxOpen")
  self.animator = self:AddComponent(UIAnimator, "boxBig")
end

function LWBoxRewardComponent:ComponentDestroy()
  self.boxBig = nil
  self.imgBigBox = nil
  self.imgBigBoxOpen = nil
end

function LWBoxRewardComponent:DataDefine()
end

function LWBoxRewardComponent:DataDestroy()
end

function LWBoxRewardComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateAllianceMilitarySelect, self.OnSelectChange)
  self:AddUIListener(EventId.OpenAllianceMilitaryBox, self.OnOpenBox)
end

function LWBoxRewardComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateAllianceMilitarySelect, self.OnSelectChange)
  self:RemoveUIListener(EventId.OpenAllianceMilitaryBox, self.OnOpenBox)
  base.OnRemoveListener(self)
end

function LWBoxRewardComponent:SetData(template, isSelect, data)
  self.template = template
  local hasGot = data.status == SalaryStatus.HasGot
  if self.animator then
    if hasGot then
      self.animator:Play("V_ui_LWAllianceMilitaryPayMain_box_open_idle")
    else
      self.animator:Play("V_ui_LWAllianceMilitaryPayMain_box_close_idle")
    end
  end
  self:SetSelect(isSelect, true)
  local color = template.boxColor
  self.imgBigBox:LoadSprite(string.format(LoadPath.LWAllianceMilitaryPayTexturePath, AllianceSalaryRewardTexture[color]))
  self.imgBigBoxOpen:LoadSprite(string.format(LoadPath.LWAllianceMilitaryPayTexturePath, AllianceSalaryRewardTexture[color]))
end

function LWBoxRewardComponent:SetSelect(isSelect, noAnim)
  self:KillTween()
  if isSelect then
    if noAnim then
      self.root.transform:Set_localScale(1, 1, 1)
    else
      self.tween = self.root.transform:DOScale(1, 0.15):SetEase(CS.DG.Tweening.Ease.Linear)
    end
  elseif noAnim then
    self.root.transform:Set_localScale(0.8, 0.8, 0.8)
  else
    self.tween = self.root.transform:DOScale(0.8, 0.15):SetEase(CS.DG.Tweening.Ease.Linear)
  end
end

function LWBoxRewardComponent:OnSelectChange(templateId)
  local isSelect = templateId == self.template.id
  self:SetSelect(isSelect)
end

function LWBoxRewardComponent:OnOpenBox(configId)
  if not self.template or configId ~= self.template.id then
    return
  end
  if self.animator then
    self.animator:Play("V_ui_LWAllianceMilitaryPayMain_box_open")
  end
end

function LWBoxRewardComponent:KillTween()
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
end

return LWBoxRewardComponent
