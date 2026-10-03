local SkirmishDominatorCell = BaseClass("SkirmishDominatorCell", UIBaseContainer)
local base = UIBaseContainer
local DominatorSkillNodeComponent = require("UI.UISkirmish.Main.Component.DominatorSkillNodeComponent")
local NORMAL_SCALE = 0.8
local TANK_HEIGHT = Vector3.New(0, 80, 0)

function SkirmishDominatorCell:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function SkirmishDominatorCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SkirmishDominatorCell:ComponentDefine()
  self.animator = self:AddComponent(UIAnimator, "dominatorIcon")
  self.cdImg = self:AddComponent(UIImage, "dominatorIcon/cdMask")
  self.skillImg2 = self:AddComponent(UIImage, "dominatorIcon/Eff_UI_jinengshifang/Image/Image")
  self.skillBubble = self:AddComponent(UIAnimator, "dominatorIcon/Eff_UI_jinengshifang")
  self.skillBubble:SetActive(false)
  self.skillNode = self:AddComponent(DominatorSkillNodeComponent, "skillNode")
  self.skillNode:SetActive(true)
  self.dominatorIcon = self:AddComponent(UIImage, "dominatorIcon/icon")
  self.hpImg = self:AddComponent(UIImage, "hp")
  self.hpImg:SetFillAmount(1)
end

function SkirmishDominatorCell:ComponentDestroy()
  self.cdImg = nil
  self.animator = nil
  self.skillBubble = nil
  self.skillNode = nil
  self.dominatorIcon = nil
  self.hpImg = nil
end

function SkirmishDominatorCell:DataDefine()
  self.logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  self.skillCD = 1
end

function SkirmishDominatorCell:DataDestroy()
  if self.loopAnim then
    self.loopAnim:Stop()
    self.loopAnim = nil
  end
  if self.updateTimer ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
  self.dominator = nil
  self.skill = nil
end

function SkirmishDominatorCell:OnSkirmishEndStage()
  if self.updateTimer ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

function SkirmishDominatorCell:OnUpdate()
  if not self.skill then
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

function SkirmishDominatorCell:OnEnable()
  base.OnEnable(self)
end

function SkirmishDominatorCell:OnDisable()
  base.OnDisable(self)
  if self.updateTimer ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

function SkirmishDominatorCell:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SkirmishFightStage, self.OnSkirmishFightStage)
  self:AddUIListener(EventId.SkirmishEndStage, self.OnSkirmishEndStage)
  self:AddUIListener(EventId.SkirmishUltimateBubble, self.OnSkirmishUltimateBubble)
  self:AddUIListener(EventId.SkirmishCastUltimate, self.OnSkirmishCastUltimate)
  self:AddUIListener(EventId.SkirmishChangeHp, self.OnSkirmishChangeHp)
end

function SkirmishDominatorCell:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.SkirmishFightStage, self.OnSkirmishFightStage)
  self:RemoveUIListener(EventId.SkirmishEndStage, self.OnSkirmishEndStage)
  self:RemoveUIListener(EventId.SkirmishUltimateBubble, self.OnSkirmishUltimateBubble)
  self:RemoveUIListener(EventId.SkirmishCastUltimate, self.OnSkirmishCastUltimate)
  self:RemoveUIListener(EventId.SkirmishChangeHp, self.OnSkirmishChangeHp)
end

function SkirmishDominatorCell:OnSkirmishUltimateBubble(action)
  if self.index == action.casterIndex then
    self:SetBubblePos()
    self.skillBubble:SetActive(true)
    self.skillBubble:Play("Eff_ui_jinengshifang_show", 0, 0)
    local ultimateRingEffect = "Assets/_Art_LastWar/Effect/Prefab/UI/Common/Eff_world_hero_guangquan.prefab"
    self.logic:ShowEffectObj(ultimateRingEffect, nil, nil, 2, self.dominator.transform)
  end
end

function SkirmishDominatorCell:OnSkirmishCastUltimate(action)
  if self.index == action.casterIndex then
    if self.loopAnim then
      self.loopAnim:Stop()
      self.loopAnim = nil
    end
    self.animator:Play("Eff_ui_jinengshifang_tubiaojineng", 0, 0)
  end
end

function SkirmishDominatorCell:InitData(index)
  self.index = index
  self.dominator = self.logic:GetCaptain(index)
  if not self.dominator then
    self:SetActive(false)
    return
  end
  local dominatorData = self.dominator.hero
  local mainTemplate = DataCenter.DominatorTemplateManager:GetMainTemplateById(dominatorData.heroId)
  if mainTemplate then
    self.dominatorIcon:LoadSprite(mainTemplate:GetSmallPicPath())
  else
    self.dominatorIcon:LoadSprite(LoadPath.DominatorDefaultRoundIcon)
  end
  self.cdImg:SetFillAmount(1)
  CS.UIGray.SetGray(self.dominatorIcon.transform, false, true)
  self.skill = self.dominator.skillManager:GetUltimateSkill()
  if self.skill then
    self.skillImg2:LoadSprite(self.skill.meta.icon)
  end
  self.hpImg:SetFillAmount(self.dominator.initBlood / self.dominator.maxBlood)
end

function SkirmishDominatorCell:OnSkirmishFightStage()
  if self.skill and not self.skill.lock and not self.updateTimer then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
end

function SkirmishDominatorCell:SetBubblePos()
  local worldPos = self.dominator:GetPosition()
  local skillWorldPos = CS.CSUtils.WorldPositionToUISpacePosition(worldPos) + TANK_HEIGHT
  self.skillBubble:SetPosition(skillWorldPos)
end

function SkirmishDominatorCell:OnSkirmishChangeHp(param)
  if self.index ~= param[1] then
    return
  end
  local percent = param[2]
  self.hpImg:SetFillAmount(percent)
  if percent <= 0 then
    CS.UIGray.SetGray(self.dominatorIcon.transform, true, true)
    self.cdImg:SetFillAmount(0)
    self.animator:Play("Eff_ui_jinengshifang_default", 0, 0)
    self.skillBubble:SetActive(false)
    self:DataDestroy()
  end
end

return SkirmishDominatorCell
