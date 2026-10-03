local SkirmishWeaponCell = BaseClass("SkirmishWeaponCell", UIBaseContainer)
local base = UIBaseContainer
local NORMAL_SCALE = 0.8
local TANK_HEIGHT = Vector3.New(0, 80, 0)

function SkirmishWeaponCell:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function SkirmishWeaponCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SkirmishWeaponCell:ComponentDefine()
  self.animator = self:AddComponent(UIAnimator, "")
  self.cdImg = self:AddComponent(UIImage, "TacticalWeaponCoolDownMask")
  self.levelNumberText = self:AddComponent(UIText, "TacticalWeaponLevelNumberText")
  self.skillImg2 = self:AddComponent(UIImage, "Eff_UI_jinengshifang/Image/Image")
  self.skillBubble = self:AddComponent(UIAnimator, "Eff_UI_jinengshifang")
  self.skillBubble:SetActive(false)
end

function SkirmishWeaponCell:ComponentDestroy()
  self.cdImg = nil
  self.animator = nil
  self.skillBubble = nil
end

function SkirmishWeaponCell:DataDefine()
  self.logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  self.skillCD = 1
end

function SkirmishWeaponCell:DataDestroy()
  if self.loopAnim then
    self.loopAnim:Stop()
    self.loopAnim = nil
  end
  if self.updateTimer ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
  self.weapon = nil
  self.skill = nil
end

function SkirmishWeaponCell:OnSkirmishEndStage()
  if self.updateTimer ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

function SkirmishWeaponCell:OnUpdate()
  if not self.skill or not self.skill:IsActive() then
    return
  end
  local curCD, maxCD = self.skill:GetCurAndMaxCD()
  if 0.4 < curCD then
    self.cdImg:SetFillAmount(curCD / maxCD)
  elseif 0 < curCD then
    self.cdImg:SetFillAmount(curCD / maxCD)
    if 0.4 < self.skillCD then
      self.animator:Play("Eff_ui_jinengshifang_tubiaojineng_daiji", 0, 0)
      self.loopAnim = TimerManager:GetInstance():DelayInvoke(function()
        self.animator:Play("Eff_ui_jinengshifang_tubiao_kuang_daiji", 0, 0)
      end, 0.5)
    end
  else
    self.cdImg:SetFillAmount(0)
  end
  self.skillCD = curCD
end

function SkirmishWeaponCell:OnEnable()
  base.OnEnable(self)
end

function SkirmishWeaponCell:OnDisable()
  base.OnDisable(self)
  if self.updateTimer ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

function SkirmishWeaponCell:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SkirmishFightStage, self.OnSkirmishFightStage)
  self:AddUIListener(EventId.SkirmishEndStage, self.OnSkirmishEndStage)
  self:AddUIListener(EventId.SkirmishUltimateBubble, self.OnSkirmishUltimateBubble)
  self:AddUIListener(EventId.SkirmishCastUltimate, self.OnSkirmishCastUltimate)
end

function SkirmishWeaponCell:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.SkirmishFightStage, self.OnSkirmishFightStage)
  self:RemoveUIListener(EventId.SkirmishEndStage, self.OnSkirmishEndStage)
  self:RemoveUIListener(EventId.SkirmishUltimateBubble, self.OnSkirmishUltimateBubble)
  self:RemoveUIListener(EventId.SkirmishCastUltimate, self.OnSkirmishCastUltimate)
end

function SkirmishWeaponCell:OnSkirmishUltimateBubble(action)
  if self.index == action.casterIndex then
    self:SetBubblePos()
    self.skillBubble:SetActive(true)
    self.skillBubble:Play("Eff_ui_jinengshifang_show", 0, 0)
    local ultimateRingEffect = "Assets/_Art_LastWar/Effect/Prefab/UI/Common/Eff_world_hero_guangquan.prefab"
    self.logic:ShowEffectObj(ultimateRingEffect, nil, nil, 2, self.weapon.transform)
  end
end

function SkirmishWeaponCell:OnSkirmishCastUltimate(action)
  if self.index == action.casterIndex then
    if self.loopAnim then
      self.loopAnim:Stop()
      self.loopAnim = nil
    end
    self.animator:Play("Eff_ui_jinengshifang_tubiaojineng", 0, 0)
  end
end

function SkirmishWeaponCell:InitData(index)
  self.index = index
  self.weapon = self.logic:GetCaptain(index)
  if not self.weapon then
    self:SetActive(false)
    return
  else
    self:SetActive(true)
  end
  local weaponData = self.logic.battleData.weaponData[self.index]
  if weaponData then
    self.levelNumberText:SetText(weaponData.heroLevel)
  else
    self.levelNumberText:SetText("")
  end
  self.cdImg:SetFillAmount(1)
  self.skill = self.weapon.skillManager:GetUltimateSkill()
  if self.skill then
    self.skillImg2:LoadSprite(self.skill.meta.icon)
  end
end

function SkirmishWeaponCell:OnSkirmishFightStage()
  if self.skill and not self.skill.lock and not self.updateTimer then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
end

function SkirmishWeaponCell:SetBubblePos()
  local worldPos = self.weapon:GetPosition()
  local skillWorldPos = CS.CSUtils.WorldPositionToUISpacePosition(worldPos) + TANK_HEIGHT
  self.skillBubble:SetPosition(skillWorldPos)
end

function SkirmishWeaponCell:InitHp(percent)
  local x = percent * self:GetMaxValue()
  if self.fg then
    self.fg:Set_sizeDelta(x, 14)
  end
  if self.mg then
    self.mg:Set_sizeDelta(x, 14)
  end
end

function SkirmishWeaponCell:SetHp(percent)
  if self.fg then
    self.fg:Set_sizeDelta(percent * self:GetMaxValue(), 14)
  end
  local tweenParam = {}
  tweenParam.delay = DELAY
  tweenParam.percent = percent
  table.insert(self.queue, 1, tweenParam)
end

return SkirmishWeaponCell
