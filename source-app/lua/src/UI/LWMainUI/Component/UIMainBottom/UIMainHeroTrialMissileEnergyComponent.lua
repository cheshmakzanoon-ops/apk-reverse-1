local base = UIBaseContainer
local UIMainHeroTrialMissileEnergyComponent = BaseClass("UIMainHeroTrialMissileEnergyComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIMainHeroTrialMissileEnergyComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIMainHeroTrialMissileEnergyComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMainHeroTrialMissileEnergyComponent:ComponentDefine()
  self.btnClick = self:AddComponent(UIButton, "Click")
  self.btnClick:SetOnClick(function()
    self:OnBtnClickClick()
  end)
  self.imgProgressBg = self:AddComponent(UIImage, "Click/root/Progress")
  self.textTiming = self:AddComponent(UITextMeshProUGUIEx, "Click/TimingText")
  self.textTip = self:AddComponent(UITextMeshProUGUIEx, "Click/TipText")
  self.textTip:SetText(Localization:GetString("challenge_zombie_transmitted_btn"))
end

function UIMainHeroTrialMissileEnergyComponent:ComponentDestroy()
  self.btnClick = nil
  self.imgProgressBg = nil
  self.textTiming = nil
  self.textTip = nil
  self.progressValue = 0
end

function UIMainHeroTrialMissileEnergyComponent:DataDefine()
end

function UIMainHeroTrialMissileEnergyComponent:DataDestroy()
end

function UIMainHeroTrialMissileEnergyComponent:OnAddListener()
  base.OnAddListener(self)
end

function UIMainHeroTrialMissileEnergyComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIMainHeroTrialMissileEnergyComponent:ReInit()
  if not DataCenter.ActivityKillZombieManager:CheckNewAllianceChallengeDonateInfoShow() then
    self:Hide()
    return
  end
  local info = DataCenter.ActivityKillZombieManager.newAllianceChallengeDonateInfo
  if info == nil then
    self:Hide()
    return
  end
  if info.configId then
    local curCount = info.count or 0
    local maxCount = info.maxCount or 1
    if 0 < maxCount then
      local progress = curCount / maxCount
      self.progressValue = progress
      self.imgProgressBg:SetFillAmount(progress)
    else
      self.progressValue = 0
      self.imgProgressBg:SetFillAmount(0)
    end
  end
  local fireTime = toInt(info.endTimeStamp or 0)
  self.fireTime = fireTime
  local now = UITimeManager:GetInstance():GetServerTime()
  local remainTime = fireTime - now
  self:RefreshTime(remainTime)
  self:SetActive(true)
end

function UIMainHeroTrialMissileEnergyComponent:RefreshTime(remainTime)
  if remainTime and 0 < remainTime then
    if self.textTiming then
      self.textTiming:SetText(math.floor(remainTime / 1000) .. "s")
    end
  else
    self:Hide()
  end
end

function UIMainHeroTrialMissileEnergyComponent:Update100MS()
  if self.fireTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.fireTime - now
    self:RefreshTime(remainTime)
  end
end

function UIMainHeroTrialMissileEnergyComponent:Hide()
  self:SetActive(false)
end

function UIMainHeroTrialMissileEnergyComponent:OnBtnClickClick()
  if not DataCenter.ActivityKillZombieManager:CheckNewAllianceChallengeDonateInfoShow() then
    self:Hide()
    return
  end
  local info = DataCenter.ActivityKillZombieManager.newAllianceChallengeDonateInfo
  if info == nil then
    self:Hide()
    return
  end
  local marsUid = info.marsUid or ""
  if marsUid == LuaEntry.Player:GetUid() then
    GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos()), CS.SceneManager.World.InitZoom)
    if self.progressValue >= 1 then
      SFSNetwork.SendMessage(MsgDefines.AllianceMonsterChallengeSkillUse)
      UIUtil.ShowTipsId("challenge_zombie_warlord_succeed")
      return
    end
    if self.fireTime then
      local now = UITimeManager:GetInstance():GetServerTime()
      local remainTime = self.fireTime - now
      if remainTime <= 10000 then
        UIUtil.ShowTipsId("challenge_zombie_transmitted_2_tips")
        return
      end
    end
    UIUtil.ShowTipsId("challenge_zombie_warlord_ready_tips")
    return
  end
  if info.marsPointId and info.marsPointId > 0 and info.marsBuildingId and 0 < info.marsBuildingId then
    MarchUtil.LaunchScout(MarchTargetType.ALLIANCE_MONSTER_CHALLENGE_NEW_DONATE, info.marsPointId, info.marsBuildingId)
    GoToUtil.GotoPos(SceneUtils.TileIndexToWorld(info.marsPointId), CS.SceneManager.World.InitZoom)
  end
end

return UIMainHeroTrialMissileEnergyComponent
