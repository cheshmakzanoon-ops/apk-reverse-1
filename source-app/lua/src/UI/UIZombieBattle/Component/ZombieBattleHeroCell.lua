local ZombieBattleHeroCell = BaseClass("ZombieBattleHeroCell", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local Screen = CS.UnityEngine.Screen
local NORMAL_SCALE = 0.8
local BIG_SCALE = 0.95
local TANK_HEIGHT = Vector3.New(0, 80, 0)

function ZombieBattleHeroCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function ZombieBattleHeroCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ZombieBattleHeroCell:ComponentDefine()
  self.bg = self:AddComponent(UIBaseComponent, "Bg")
  self.animator = self:AddComponent(UIAnimator, "Bg")
  self.animator:Play("Eff_ui_jinengshifang_default", 0, 0)
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
end

function ZombieBattleHeroCell:ComponentDestroy()
  self.icon = nil
  self.bg = nil
  self.cdImg = nil
  self.lock = nil
  self.ring = nil
  self.hpImg = nil
  self.cdText = nil
  self.animator = nil
  self.skillBubble = nil
end

function ZombieBattleHeroCell:DataDefine()
  self.timeStopDuration = 0
  self.skillCD = 1
end

function ZombieBattleHeroCell:DataDestroy()
  if self.loopAnim then
    self.loopAnim:Stop()
    self.loopAnim = nil
  end
  if self.updateTimer ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
  self.member = nil
  self.skill = nil
end

function ZombieBattleHeroCell:OnZombieBattleDestroy()
  if self.updateTimer ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

function ZombieBattleHeroCell:TryPlayToCastAnim()
  if self.skill then
    self.animator:Play("Eff_ui_jinengshifang_tubiaojineng_daiji", 0, 0)
    self.loopAnim = TimerManager:GetInstance():DelayInvoke(function()
      self.animator:Play("Eff_ui_jinengshifang_tubiao_kuang_daiji", 0, 0)
    end, 0.5)
  end
end

function ZombieBattleHeroCell:OnUpdate()
  local curHP, maxHP = self.member:GetCurAndMaxHp()
  self.hpImg:SetFillAmount(curHP / maxHP)
  if curHP <= 0 then
    CS.UIGray.SetGray(self.icon.transform, true, true)
    self.cdImg:SetFillAmount(0)
    self.cdText:SetText("")
    self.animator:Play("Eff_ui_jinengshifang_default", 0, 0)
    self.skillBubble:SetActive(false)
    self:DataDestroy()
    return
  end
  if not self.member:UltimateIsLock() and self.skill then
    local curCD, maxCD = self.skill:GetCurAndMaxCD()
    if 0.4 < curCD then
      self.cdImg:SetFillAmount(curCD / maxCD)
      self.cdText:SetText(string.format("%.1fs", curCD))
    elseif 0 < curCD then
      self.cdImg:SetFillAmount(curCD / maxCD)
      self.cdText:SetText(string.format("%.1fs", curCD))
      if 0.4 < self.skillCD then
        self:TryPlayToCastAnim()
      end
    else
      if not self.loopAnim then
        self:TryPlayToCastAnim()
      end
      self.cdImg:SetFillAmount(0)
      self.cdText:SetText("")
      if self.view.isAuto and self.member:UltimateIsReady() then
        self:OnClick()
      end
    end
    self.skillCD = curCD
    if 0 < self.timeStopDuration then
      self.timeStopDuration = self.timeStopDuration - Time.deltaTime
      self:SetBubblePos()
    end
  end
end

function ZombieBattleHeroCell:OnEnable()
  base.OnEnable(self)
end

function ZombieBattleHeroCell:OnDisable()
  base.OnDisable(self)
  if self.updateTimer ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

function ZombieBattleHeroCell:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.OnRefreshUltimateLock)
  self:AddUIListener(EventId.ZombieBattleDestroy, self.OnZombieBattleDestroy)
end

function ZombieBattleHeroCell:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.OnRefreshUltimateLock)
  self:RemoveUIListener(EventId.ZombieBattleDestroy, self.OnZombieBattleDestroy)
end

function ZombieBattleHeroCell:SetData(member)
  if member then
    self.icon:SetActive(true)
    self.member = member
    self.skill = member.skillManager:GetUltimateSkill()
    self.icon:SetData(member.hero.uuid, function()
      self:OnClick()
    end)
    self.bg:SetLocalScaleXYZ(NORMAL_SCALE, NORMAL_SCALE, NORMAL_SCALE)
    self.cdImg:SetFillAmount(0)
    self.cdText:SetText("")
    if self.skill then
      self.skillImg:LoadSprite(self.skill.meta.icon)
      self.skillImg2:LoadSprite(self.skill.meta.icon)
    end
    if self.member:UltimateIsLock() and self.member:UltimateCanUnlock() then
      self:ShowCanUnlock()
    else
      self:HideLock()
    end
    if not self.updateTimer then
      function self.updateTimer()
        self:OnUpdate()
      end
      
      UpdateManager:GetInstance():AddUpdate(self.updateTimer)
    end
  else
    self.icon:SetActive(false)
  end
end

function ZombieBattleHeroCell:OnRefreshUltimateLock()
  if self.member then
    if self.member:UltimateIsLock() then
      if self.member:UltimateCanUnlock() then
        self:ShowCanUnlock()
      else
        self:ShowCantUnlock()
      end
    else
      self:HideLock()
    end
  end
end

function ZombieBattleHeroCell:HideLock()
  self.lock:SetActive(false)
end

function ZombieBattleHeroCell:ShowCanUnlock()
  self.lock:SetActive(true)
  CS.UIGray.SetGray(self.skillImg.transform, false, true)
end

function ZombieBattleHeroCell:ShowCantUnlock()
  self.lock:SetActive(true)
  CS.UIGray.SetGray(self.skillImg.transform, true, true)
end

function ZombieBattleHeroCell:OnClick()
  if not self.member then
    return
  end
  if self.member:UltimateIsLock() then
    if self.member:UltimateCanUnlock() then
      self.member:UnlockUltimate()
    else
      self:ShowCantUnlock()
      UIUtil.ShowTipsId(154287)
      return
    end
  end
  local success = self.member:HandleInput(MemberCommand.Ultimate)
  if success then
    if self.loopAnim then
      self.loopAnim:Stop()
      self.loopAnim = nil
    end
    self.animator:Play("Eff_ui_jinengshifang_tubiaojineng", 0, 0)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_skill_release)
    self.timeStopDuration = self.member:GetUltimateTimeStopDuration()
    self.view:Spot(self.member, self.timeStopDuration)
    self:SetBubblePos()
    self.skillBubble:SetActive(true)
    self.skillBubble:SetLocalScaleXYZ(0.4, 0.4, 0.4)
    self.skillBubble:Play("Eff_ui_jinengshifang_show", 0, 0)
  end
end

function ZombieBattleHeroCell:SetBubblePos()
  local worldPos = self.member:GetPosition()
  local skillWorldPos = CS.CSUtils.WorldPositionToUISpacePosition(worldPos) + TANK_HEIGHT
  self.skillBubble:SetPosition(skillWorldPos)
end

return ZombieBattleHeroCell
