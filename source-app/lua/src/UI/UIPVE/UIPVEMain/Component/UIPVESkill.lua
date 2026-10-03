local UIPVESkill = BaseClass("UIPVESkill", UIBaseContainer)
local base = UIBaseContainer
local this_path = ""
local skill_slider_path = "SkillSlider"
local effect_active_path = "EffectActiveGo"
local effect_show_path = "EffectShowGo"
local skill_img_path = "SkillImage"
local ActiveImg = "Assets/Main/Sprites/pve/UIpve_skill_Light_up.png"
local UnActiveImg = "Assets/Main/Sprites/pve/UIpve_skill_Not_lit.png"
local MaxNum = 34
local BuffId = 2001
local State = {
  UnActive = 1,
  Active = 2,
  Show = 3
}

function UIPVESkill:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

function UIPVESkill:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIPVESkill:ComponentDefine()
  self.btn = self:AddComponent(UIButton, this_path)
  self.empty_ray_cast = self:AddComponent(UIEmpty4Raycast, this_path)
  self.skill_slider = self:AddComponent(UIImage, skill_slider_path)
  self.effect_active = self:AddComponent(UIBaseContainer, effect_active_path)
  self.effect_show = self:AddComponent(UIBaseContainer, effect_show_path)
  self.skill_img = self:AddComponent(UIImage, skill_img_path)
  self.btn:SetOnClick(function()
    self:OnSkillBtnClick()
  end)
end

function UIPVESkill:ComponentDestroy()
  self.btn = nil
  self.skill_slider = nil
  self.empty_ray_cast = nil
  self.effect_active = nil
  self.effect_show = nil
  self.skill_img = nil
end

function UIPVESkill:DataDefine()
  self.visible = nil
  self.curNum = 0
  self.allNum = MaxNum
  self.state = State.UnActive
  self.firingTween = nil
end

function UIPVESkill:DataDestroy()
  self.visible = nil
  self.curNum = 0
  self.allNum = MaxNum
  self.state = State.UnActive
  if self.firingTween then
    self.firingTween:Kill()
    self.firingTween = nil
  end
end

function UIPVESkill:OnEnable()
  base.OnEnable(self)
end

function UIPVESkill:OnDisable()
  base.OnDisable(self)
end

function UIPVESkill:OnAddListener()
  base.OnAddListener(self)
end

function UIPVESkill:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIPVESkill:ReInit()
  if DataCenter.BattleLevel:CanShowPveSkill() then
    self:SetVisible(true)
    if self.firingTween then
      self.firingTween:Kill()
      self.firingTween = nil
    end
    self.skill_slider:SetFillAmount(self.curNum / self.allNum)
    self:CheckEffect()
  else
    self:SetVisible(false)
  end
end

function UIPVESkill:RefreshNum(curNum)
  if self.visible and self.curNum ~= curNum then
    self.curNum = curNum
    local percent = self.curNum / self.allNum
    if self.firingTween then
      self.firingTween:Kill()
      self.firingTween = nil
    end
    self.skill_slider:SetFillAmount(percent)
    if 1 <= percent then
      self.state = State.Active
    else
      self.state = State.UnActive
    end
    self:CheckEffect()
  end
end

function UIPVESkill:SetSliderFiring()
  local template = DataCenter.PveBuffTemplateManager:GetTemplate(BuffId)
  if template == nil then
    return
  end
  if self.firingTween then
    self.firingTween:Kill()
    self.firingTween = nil
  end
  self.skill_slider:SetFillAmount(1)
  self.firingTween = self.skill_slider.unity_image:DOFillAmount(0, template.time):SetEase(CS.DG.Tweening.Ease.Linear):SetUpdate(true)
end

function UIPVESkill:SetVisible(visible)
  if self.visible ~= visible then
    self.visible = visible
    self.gameObject:SetActive(visible)
  end
end

function UIPVESkill:OnSkillBtnClick()
  if self.curNum >= self.allNum and self.state == State.Active then
    self.state = State.Show
    self:CheckEffect()
    DataCenter.BattleLevel:AddBuffById(BuffId)
    self:SetSliderFiring()
  end
end

function UIPVESkill:AddNum(num)
  if self.visible then
    local willNum = self.curNum + num
    if willNum > self.allNum then
      willNum = self.allNum
    elseif willNum < 0 then
      willNum = 0
    end
    self:RefreshNum(willNum)
  end
end

function UIPVESkill:RemoveOneBuff(id)
  if id == BuffId and self.state == State.Show then
    self:RefreshNum(0)
  end
end

function UIPVESkill:CheckEffect()
  if self.state == State.UnActive then
    self.effect_active:SetActive(false)
    self.effect_show:SetActive(false)
    self:LoadImg(UnActiveImg)
  elseif self.state == State.Active then
    self.effect_active:SetActive(true)
    self.effect_show:SetActive(false)
    self:LoadImg(ActiveImg)
  elseif self.state == State.Show then
    self.effect_active:SetActive(false)
    self.effect_show:SetActive(true)
    self:LoadImg(ActiveImg)
  end
end

function UIPVESkill:LoadImg(name)
  if self.imgName ~= name then
    self.imgName = name
    self.skill_img:LoadSprite(name)
  end
end

function UIPVESkill:GetNum()
  if self.state == State.Show then
    return 0
  end
  return self.curNum
end

return UIPVESkill
