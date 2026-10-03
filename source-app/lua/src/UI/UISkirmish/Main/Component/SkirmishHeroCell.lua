local SkirmishHeroCell = BaseClass("SkirmishHeroCell", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local SkirmishHeroAwakenEnergyComponent = require("UI/UISkirmish/Main/Component/SkirmishHeroAwakenEnergyComponent")
local NORMAL_SCALE = 0.8
local TANK_HEIGHT = Vector3.New(0, 80, 0)

function SkirmishHeroCell:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function SkirmishHeroCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SkirmishHeroCell:ComponentDefine()
  self.bg = self:AddComponent(UIBaseComponent, "Bg")
  self.animator = self:AddComponent(UIAnimator, "Bg")
  self.cdImg = self:AddComponent(UIImage, "Bg/UIHeroCellSmall/cd")
  self.lock = self:AddComponent(UIBaseComponent, "Bg/UIHeroCellSmall/skill/lock")
  self.skillImg = self:AddComponent(UIImage, "Bg/UIHeroCellSmall/skill/skillImg")
  self.skillImg2 = self:AddComponent(UIImage, "Eff_UI_jinengshifang/Image/Image")
  self.ring = self:AddComponent(UIBaseComponent, "Bg/UIHeroCellSmall/ring")
  self.ring:SetActive(false)
  self.skillNode = self:AddComponent(UIBaseComponent, "Bg/UIHeroCellSmall/skill")
  self.skillNode:SetActive(false)
  self.hpImg = self:AddComponent(UIImage, "Bg/UIHeroCellSmall/hp")
  self.cdText = self:AddComponent(UIText, "Bg/UIHeroCellSmall/cdText")
  self.icon = self:AddComponent(UIHeroCellSmall, "Bg/UIHeroCellSmall")
  self.hpImg:SetFillAmount(1)
  self.skillBubble = self:AddComponent(UIAnimator, "Eff_UI_jinengshifang")
  self.skillBubble:SetActive(false)
  CS.UIGray.SetGray(self.icon.transform, false, true)
  self.energyBg = self:AddComponent(UIBaseComponent, "Bg/UIHeroCellSmall/energyBg")
  self.energyImg = self:AddComponent(UIImage, "Bg/UIHeroCellSmall/energyBg/energy")
  self.noEnergy = self:AddComponent(UIBaseComponent, "Bg/UIHeroCellSmall/noEnergy")
  self.heroAwakenEnergyRoot = self:AddComponent(UIBaseContainer, "SkirmishHeroAwakenEnergyRoot")
  self.heroAwakenEnergyVfx = self:AddComponent(UIVfx, "Bg/UIHeroCellSmall/energyBg/energy/Eff_ui_heroawaken_energy_active")
  self.heroAwakenEnergyReq = nil
  self.heroAwakenEnergyComp = nil
end

function SkirmishHeroCell:ComponentDestroy()
  self.icon = nil
  self.bg = nil
  self.cdImg = nil
  self.lock = nil
  self.ring = nil
  self.hpImg = nil
  self.cdText = nil
  self.animator = nil
  self.skillBubble = nil
  self.energyBg = nil
  self.energyImg = nil
  self.noEnergy = nil
  self.heroAwakenEnergyRoot = nil
  self.heroAwakenEnergyVfx = nil
  self.heroAwakenEnergyReq = nil
  self.heroAwakenEnergyComp = nil
end

function SkirmishHeroCell:DataDefine()
  self.logic = DataCenter.LWBattleManager:GetCurBattleLogic()
  self.skillCD = 1
  self.awakenSkillCD = 1
  self.captain = nil
  self.skill = nil
  self.awakenSkill = nil
  self.hasCastAwakenSkill = false
  self.heroData = nil
end

function SkirmishHeroCell:DataDestroy()
  if self.loopAnim then
    self.loopAnim:Stop()
    self.loopAnim = nil
  end
  if self.updateTimer ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
  if self.heroAwakenEnergyTimer then
    self.heroAwakenEnergyTimer:Stop()
    self.heroAwakenEnergyTimer = nil
  end
  if self.heroAwakenEnergyReq then
    self.heroAwakenEnergyReq:Destroy()
    self.heroAwakenEnergyReq = nil
  end
  self.captain = nil
  self.skill = nil
  self.awakenSkill = nil
  self.hasCastAwakenSkill = nil
  self.heroData = nil
end

function SkirmishHeroCell:OnSkirmishEndStage()
  if self.updateTimer ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

function SkirmishHeroCell:OnUpdateSkill()
  if self.skill == nil then
    return
  end
  local curCD, maxCD = self.skill:GetCurAndMaxCD()
  if 0.4 < curCD then
    self.cdImg:SetFillAmount(curCD / maxCD)
    self.cdText:SetText(string.format("%.1fs", curCD))
  elseif 0 < curCD then
    self.cdImg:SetFillAmount(curCD / maxCD)
    self.cdText:SetText(string.format("%.1fs", curCD))
    if 0.4 < self.skillCD then
      self.animator:Play("Eff_ui_jinengshifang_tubiaojineng_daiji", 0, 0)
      self.loopAnim = TimerManager:GetInstance():DelayInvoke(function()
        self.animator:Play("Eff_ui_jinengshifang_tubiao_kuang_daiji", 0, 0)
      end, 0.5)
    end
  else
    self.cdImg:SetFillAmount(0)
    self.cdText:SetText("")
  end
  self.skillCD = curCD
end

function SkirmishHeroCell:OnUpdateAwakenSkill()
  if self.awakenSkill == nil then
    return
  end
  local curCD, maxCD = self.awakenSkill:GetCurAndMaxCD()
  if 0.4 < curCD then
    if not self.hasCastAwakenSkill then
      self.energyImg:SetFillAmount(1 - curCD / maxCD)
      if curCD <= 0.5 and 0.4 < self.awakenSkillCD and not self.hasShownHeroAwakenFirstAnim then
        self.hasShownHeroAwakenFirstAnim = true
        self.animator:Play("Eff_ui_jinengshifang_heroawaken", 0, 0)
      end
    end
  elseif 0 < curCD then
    if not self.hasCastAwakenSkill then
      self.energyImg:SetFillAmount(1 - curCD / maxCD)
    end
  else
    self.energyImg:SetFillAmount(1)
  end
  self.awakenSkillCD = curCD
end

function SkirmishHeroCell:OnUpdate()
  if not self.skill and not self.awakenSkill then
    return
  end
  local isPausing = self.logic and self.logic.IsGamePaused and self.logic:IsGamePaused()
  if isPausing then
    return
  end
  self:OnUpdateSkill()
  self:OnUpdateAwakenSkill()
end

function SkirmishHeroCell:OnEnable()
  base.OnEnable(self)
end

function SkirmishHeroCell:OnDisable()
  base.OnDisable(self)
  if self.updateTimer ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

function SkirmishHeroCell:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SkirmishFightStage, self.OnSkirmishFightStage)
  self:AddUIListener(EventId.SkirmishEndStage, self.OnSkirmishEndStage)
  self:AddUIListener(EventId.SkirmishUltimateBubble, self.OnSkirmishUltimateBubble)
  self:AddUIListener(EventId.SkirmishCastUltimate, self.OnSkirmishCastUltimate)
  self:AddUIListener(EventId.SkirmishCastHeroAwakenSkill, self.OnSkirmishCastHeroAwakenSkill)
  self:AddUIListener(EventId.SkirmishChangeHp, self.OnSkirmishChangeHp)
end

function SkirmishHeroCell:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.SkirmishFightStage, self.OnSkirmishFightStage)
  self:RemoveUIListener(EventId.SkirmishEndStage, self.OnSkirmishEndStage)
  self:RemoveUIListener(EventId.SkirmishUltimateBubble, self.OnSkirmishUltimateBubble)
  self:RemoveUIListener(EventId.SkirmishCastUltimate, self.OnSkirmishCastUltimate)
  self:RemoveUIListener(EventId.SkirmishCastHeroAwakenSkill, self.OnSkirmishCastHeroAwakenSkill)
  self:RemoveUIListener(EventId.SkirmishChangeHp, self.OnSkirmishChangeHp)
end

function SkirmishHeroCell:OnSkirmishUltimateBubble(action)
  if self.index == action.casterIndex then
    if not self.captain then
      return
    end
    self:SetBubblePos()
    self.skillBubble:SetActive(true)
    self.skillBubble:Play("Eff_ui_jinengshifang_show", 0, 0)
    local ultimateRingEffect = "Assets/_Art_LastWar/Effect/Prefab/UI/Common/Eff_world_hero_guangquan.prefab"
    self.logic:ShowEffectObj(ultimateRingEffect, nil, nil, 2, self.captain.transform)
  end
end

function SkirmishHeroCell:OnSkirmishCastHeroAwakenSkill(captain)
  if captain ~= nil and self.index == captain.index then
    if self.loopAnim then
      self.loopAnim:Stop()
      self.loopAnim = nil
    end
    self.hasCastAwakenSkill = true
    self.heroAwakenEnergyVfx:Replay()
    self.cdImg:SetFillAmount(0)
    self.cdText:SetText("")
    if self.heroAwakenEnergyComp ~= nil then
      self.heroAwakenEnergyComp:Show()
      if self.heroAwakenEnergyTimer then
        self.heroAwakenEnergyTimer:Stop()
        self.heroAwakenEnergyTimer = nil
      end
      self.heroAwakenEnergyTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.noEnergy:SetActive(true)
        self.energyBg:SetActive(false)
      end, 1)
    else
      self.noEnergy:SetActive(true)
      self.energyBg:SetActive(false)
    end
  end
end

function SkirmishHeroCell:OnSkirmishCastUltimate(action)
  if self.index == action.casterIndex then
    if self.loopAnim then
      self.loopAnim:Stop()
      self.loopAnim = nil
    end
    self.animator:Play("Eff_ui_jinengshifang_tubiaojineng", 0, 0)
  end
end

function SkirmishHeroCell:OnSkirmishChangeHp(param)
  if self.index ~= param[1] then
    return
  end
  local percent = param[2]
  self.hpImg:SetFillAmount(percent)
  if percent <= 0 then
    CS.UIGray.SetGray(self.icon.transform, true, true)
    self.cdImg:SetFillAmount(0)
    self.cdText:SetText("")
    self.animator:Play("Eff_ui_jinengshifang_default", 0, 0)
    self.skillBubble:SetActive(false)
    self.heroAwakenEnergyVfx:Stop()
    self:DataDestroy()
  end
end

function SkirmishHeroCell:InitData(index)
  self.index = index
  self.heroData = nil
  if self.logic == nil or self.logic.GetCaptain == nil then
    return
  end
  self.captain = self.logic:GetCaptain(index)
  if not self.captain then
    self.icon:SetActive(false)
    return
  end
  local heroData = self.logic.battleData.heroData[self.index]
  self.heroData = heroData
  self.hpImg:SetFillAmount(heroData.initHp / heroData.maxHp)
  self.icon:SetActive(true)
  self.icon:InitWithConfigId(heroData.heroId, nil, heroData.heroLevel, heroData.rankLv, heroData.weaponLevel, heroData.awakenLv, heroData.heroSkinId)
  self.bg:SetLocalScaleXYZ(NORMAL_SCALE, NORMAL_SCALE, NORMAL_SCALE)
  self.cdImg:SetFillAmount(1)
  self.cdText:SetText("")
  self.skill = self.captain:GetUltimateSkill()
  if self.skill then
    self.skillImg:LoadSprite(self.skill.meta.icon)
    self.skillImg2:LoadSprite(self.skill.meta.icon)
    self.lock:SetActive(self.skill.lock)
  end
  self.awakenSkill = self.captain:GetHeroAwakenSkill()
  self.hasShownHeroAwakenFirstAnim = false
  local showEnergy = self.awakenSkill ~= nil
  self.energyBg:SetActive(showEnergy)
  self.noEnergy:SetActive(false)
  if showEnergy then
    self.energyImg:SetFillAmount(0)
  end
  self:RefreshHeroAwakenEnergyComponent()
end

function SkirmishHeroCell:OnSkirmishFightStage()
  if self.skill and not self.skill.lock and not self.updateTimer then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
end

function SkirmishHeroCell:SetBubblePos()
  local worldPos = self.captain:GetPosition()
  local skillWorldPos = CS.CSUtils.WorldPositionToUISpacePosition(worldPos) + TANK_HEIGHT
  self.skillBubble:SetPosition(skillWorldPos)
end

function SkirmishHeroCell:InitHp(percent)
  local x = percent * self:GetMaxValue()
  if self.fg then
    self.fg:Set_sizeDelta(x, 14)
  end
  if self.mg then
    self.mg:Set_sizeDelta(x, 14)
  end
end

function SkirmishHeroCell:SetHp(percent)
  if self.fg then
    self.fg:Set_sizeDelta(percent * self:GetMaxValue(), 14)
  end
  local tweenParam = {}
  tweenParam.delay = DELAY
  tweenParam.percent = percent
  table.insert(self.queue, 1, tweenParam)
end

function SkirmishHeroCell:RefreshHeroAwakenEnergyComponent()
  if self.awakenSkill ~= nil and self.heroData ~= nil then
    if self.heroAwakenEnergyReq == nil and self.heroAwakenEnergyComp == nil then
      self.heroAwakenEnergyReq = self:GameObjectInstantiateAsync(UIAssets.HeroAwakenSkirmishEnergy, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.heroAwakenEnergyRoot.transform)
        go.transform:Set_localScale(1, 1, 1)
        go.transform:Set_localPosition(0, 0, 0)
        self.heroAwakenEnergyComp = self:AddComponent(SkirmishHeroAwakenEnergyComponent, go)
        self.heroAwakenEnergyComp:ReInit(self.heroData.heroSkinId, self.heroData.heroInfo.modelId)
        self.heroAwakenEnergyComp:Hide()
      end)
    end
    self.heroAwakenEnergyVfx:PreLoad(VfxAssets.HeroAwakenSkirmishEnergyEffect, {
      lifeType = UIVfxLifeType.Stay
    })
  else
    if self.heroAwakenEnergyReq ~= nil then
      self.heroAwakenEnergyReq:Destroy()
      self.heroAwakenEnergyReq = nil
    end
    self.heroAwakenEnergyComp = nil
  end
end

return SkirmishHeroCell
