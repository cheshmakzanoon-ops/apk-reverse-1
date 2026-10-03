local base = UIBaseContainer
local LWBoxRewardSpecialComponent = BaseClass("LWBoxRewardSpecialComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local GameObject = CS.UnityEngine.GameObject

function LWBoxRewardSpecialComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWBoxRewardSpecialComponent:OnDestroy()
  self:KillTween()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWBoxRewardSpecialComponent:ComponentDefine()
  self.root = self:AddComponent(UIBaseContainer, "boxBig")
  self.boxBig = self:AddComponent(UIBaseContainer, "boxBig/bigBox")
  self.imgBigBox = self:AddComponent(UIRawImage, "boxBig/bigBox/bigBox")
  self.imgBigBoxOpen = self:AddComponent(UIRawImage, "boxBig/bigBox/bigBoxOpen")
  self.animator = self:AddComponent(UIAnimator, "boxBig")
end

function LWBoxRewardSpecialComponent:ComponentDestroy()
  self.boxBig = nil
  self.imgBigBox = nil
  self.imgBigBoxOpen = nil
end

function LWBoxRewardSpecialComponent:DataDefine()
end

function LWBoxRewardSpecialComponent:DataDestroy()
end

function LWBoxRewardSpecialComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateAllianceMilitarySelect, self.OnSelectChange)
  self:AddUIListener(EventId.OpenAllianceMilitaryBox, self.OnOpenBox)
end

function LWBoxRewardSpecialComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateAllianceMilitarySelect, self.OnSelectChange)
  self:RemoveUIListener(EventId.OpenAllianceMilitaryBox, self.OnOpenBox)
  base.OnRemoveListener(self)
end

function LWBoxRewardSpecialComponent:SetData(template, isSelect, data)
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
  self.imgBigBox:LoadSprite(template.imgCloseIcon)
  self.imgBigBoxOpen:LoadSprite(template.imgOpenIcon)
end

function LWBoxRewardSpecialComponent:SetSelect(isSelect, noAnim)
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

function LWBoxRewardSpecialComponent:OnSelectChange(templateId)
  local isSelect = templateId == self.template.id
  self:SetSelect(isSelect)
end

function LWBoxRewardSpecialComponent:OnOpenBox(configId)
  if not self.template or configId ~= self.template.id then
    return
  end
  if self.animator then
    self.animator:Play("V_ui_LWAllianceMilitaryPayMain_box_open")
  end
end

function LWBoxRewardSpecialComponent:KillTween()
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
end

return LWBoxRewardSpecialComponent
