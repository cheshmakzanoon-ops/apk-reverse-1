local TacticalWeaponCell = BaseClass("TacticalWeaponCell", UIBaseContainer)
local base = UIBaseContainer
local Screen = CS.UnityEngine.Screen
local NORMAL_SCALE = 0.8
local BIG_SCALE = 0.95
local TANK_HEIGHT = Vector3.New(0, 80, 0)

function TacticalWeaponCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function TacticalWeaponCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TacticalWeaponCell:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "")
  self.icon = self:AddComponent(UIImage, "TacticalWeaponIcon")
  self.btn:SetOnClick(function()
    if self.member then
      local selfEquips = DataCenter.TacticalWeaponManager:GetAllSelfWearingEquips()
      local skinId = DataCenter.TacticalWeaponManager:GetWeaponSkinId()
      local skillChips
      if self.member.skillChips then
        skillChips = {}
        for _, chip in pairs(self.member.skillChips) do
          if chip then
            local chipInfo = {}
            chipInfo.star = chip:GetStar()
            chipInfo.lv = chip:GetLevel()
            chipInfo.cfgId = chip:GetId()
            chipInfo.type = chip:GetType()
            table.insert(skillChips, chipInfo)
          end
        end
      end
      local power = DataCenter.TacticalWeaponManager:GetWeaponTotalPower()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWTacticalWeaponTip, {anim = true}, self.member.weaponData, selfEquips, self.icon, skinId, skillChips, power)
    end
  end)
  self.animator = self:AddComponent(UIAnimator, "")
  self.animator:Play("Eff_ui_jinengshifang_default", 0, 0)
  self.mask = self:AddComponent(UIImage, "TacticalWeaponCoolDownMask")
  self.levelNumberText = self:AddComponent(UIText, "TacticalWeaponLevelNumberText")
  self.skillBubble = self:AddComponent(UIAnimator, "Eff_UI_jinengshifang")
  self.skillBubble:SetActive(false)
  self.skillImg2 = self:AddComponent(UIImage, "Eff_UI_jinengshifang/Image/Image")
end

function TacticalWeaponCell:ComponentDestroy()
  self.btn = nil
  self.icon = nil
  self.animator = nil
  self.mask = nil
  self.levelNumberText = nil
  self.skillBubble = nil
  self.skillImg2 = nil
end

function TacticalWeaponCell:DataDefine()
  self.timeStopDuration = 0
  self.skillCD = 1
end

function TacticalWeaponCell:DataDestroy()
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

function TacticalWeaponCell:OnZombieBattleDestroy()
  if self.updateTimer ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

function TacticalWeaponCell:OnUpdate()
  if self.skill then
    local curCD, maxCD = self.skill:GetCurAndMaxCD()
    if 0.4 < curCD then
      self.mask:SetFillAmount(curCD / maxCD)
    elseif 0 < curCD then
      self.mask:SetFillAmount(curCD / maxCD)
      if 0.4 < self.skillCD then
        self.animator:Play("Eff_ui_jinengshifang_tubiaojineng_daiji", 0, 0)
        self.loopAnim = TimerManager:GetInstance():DelayInvoke(function()
          self.animator:Play("Eff_ui_jinengshifang_tubiao_kuang_daiji", 0, 0)
        end, 0.5)
      end
    else
      self.mask:SetFillAmount(0)
      if self.member:UltimateIsReady() then
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

function TacticalWeaponCell:OnEnable()
  base.OnEnable(self)
end

function TacticalWeaponCell:OnDisable()
  base.OnDisable(self)
  if self.updateTimer ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

function TacticalWeaponCell:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ZombieBattleDestroy, self.OnZombieBattleDestroy)
end

function TacticalWeaponCell:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ZombieBattleDestroy, self.OnZombieBattleDestroy)
end

function TacticalWeaponCell:SetData(member)
  if member then
    self:SetActive(true)
    self.levelNumberText:SetText(string.format("Lv.%d", member.weaponData.level))
    self.member = member
    self.skill = member.skillManager:GetUltimateSkill()
    self.mask:SetFillAmount(0)
    if self.skill then
      self.skillImg2:LoadSprite(self.skill.meta.icon)
    end
    if not self.updateTimer then
      function self.updateTimer()
        self:OnUpdate()
      end
      
      UpdateManager:GetInstance():AddUpdate(self.updateTimer)
    end
  else
    self:SetActive(false)
  end
end

function TacticalWeaponCell:OnClick()
  if not self.member then
    return
  end
  local success = self.member:HandleInput(MemberCommand.Ultimate)
  if success then
    if self.loopAnim then
      self.loopAnim:Stop()
      self.loopAnim = nil
    end
    self.animator:Play("Eff_ui_jinengshifang_tubiaojineng", 0, 0)
    self.timeStopDuration = self.member:GetUltimateTimeStopDuration()
  end
end

function TacticalWeaponCell:SetBubblePos()
  local worldPos = self.member:GetPosition()
  local skillWorldPos = CS.CSUtils.WorldPositionToUISpacePosition(worldPos) + TANK_HEIGHT
  self.skillBubble:SetPosition(skillWorldPos)
end

return TacticalWeaponCell
