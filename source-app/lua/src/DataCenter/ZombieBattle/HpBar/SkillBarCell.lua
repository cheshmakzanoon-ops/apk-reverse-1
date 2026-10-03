local SkillBarCell = BaseClass("SkillBarCell", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local NORMAL_SCALE = 0.8
local TANK_HEIGHT = Vector3.New(0, 80, 0)
local Resource = CS.GameEntry.Resource
local baseNode = "Content/ZombieBattleHeroCell/"

function SkillBarCell:__init()
end

function SkillBarCell:__delete()
  self:OnDestroy()
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
  self.target = nil
end

function SkillBarCell:Load(member, transform, height)
  self.member = member
  self.target = transform
  self.camera = CS.UnityEngine.Camera.main
  self.height = height
  if height < 0 then
    self.height = 1
  end
  self.myWorldPos = Vector3.zero
  self.req = Resource:InstantiateAsync("Assets/Main/Prefabs/LWBattle/SkillBar.prefab")
  self.req:completed("+", function(req)
    local go = req.gameObject
    local CanvasNormal = UIManager:GetInstance():GetLayer(UILayer.Scene.Name).gameObject
    go.transform:SetParent(CanvasNormal.transform)
    self.gameObject = go
    self.transform = go.transform
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.__var_arg = self.gameObject
    self:OnCreate()
    self:SetData(self.member)
  end)
end

function SkillBarCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SkillBarCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SkillBarCell:ComponentDefine()
  self.bg = self:AddComponent(UIBaseComponent, baseNode .. "Bg")
  self.animator = self:AddComponent(UIAnimator, baseNode .. "Bg")
  self.animator:Play("Eff_ui_jinengshifang_default", 0, 0)
  self.cdImg = self:AddComponent(UIImage, baseNode .. "Bg/UIHeroCellSmall/cd")
  self.lock = self:AddComponent(UIBaseComponent, baseNode .. "Bg/UIHeroCellSmall/skill/lock")
  self.skillImg = self:AddComponent(UIImage, baseNode .. "Bg/UIHeroCellSmall/skill/skillImg")
  self.skillImg2 = self:AddComponent(UIImage, baseNode .. "Eff_UI_jinengshifang/Image/Image")
  self.ring = self:AddComponent(UIBaseComponent, baseNode .. "Bg/UIHeroCellSmall/ring")
  self.ring:SetActive(false)
  self.skillNode = self:AddComponent(UIBaseComponent, baseNode .. "Bg/UIHeroCellSmall/skill")
  self.skillNode:SetActive(false)
  self.cdText = self:AddComponent(UIText, baseNode .. "Bg/UIHeroCellSmall/cdText")
  self.icon = self:AddComponent(UIHeroCellSmall, baseNode .. "Bg/UIHeroCellSmall")
  self.skillBubble = self:AddComponent(UIAnimator, baseNode .. "Eff_UI_jinengshifang")
  self.skillBubble:SetActive(false)
  CS.UIGray.SetGray(self.icon.transform, false, true)
  self.powerEffect = self:AddComponent(UIBaseContainer, baseNode .. "Bg/Eff_ui_power_touxiang")
  self.powerEffect:SetActive(false)
end

function SkillBarCell:ComponentDestroy()
  self.icon = nil
  self.bg = nil
  self.cdImg = nil
  self.lock = nil
  self.ring = nil
  self.cdText = nil
  self.animator = nil
  self.skillBubble = nil
end

function SkillBarCell:DataDefine()
  self.timeStopDuration = 0
  self.skillCD = 1
end

function SkillBarCell:DataDestroy()
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
  self.fire = false
end

function SkillBarCell:OnUpdate()
  if self.skill and not self.skill.lock then
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
      self.member:ForceCastUltimate(self.skill)
    end
    self.skillCD = curCD
    local skillState = self.skill.state
    local skillFire = true
    if skillState == SkillCastState.Cooldown or skillState == SkillCastState.Ready then
      skillFire = false
    end
    if skillFire ~= self.fire then
      self.fire = skillFire
      if skillFire then
        self:OnFireState()
      end
    end
    if 0 < self.timeStopDuration then
      self.timeStopDuration = self.timeStopDuration - Time.deltaTime
      self:SetBubblePos()
    end
  end
  if self.transform then
    self:UpdatePos()
  end
end

function SkillBarCell:UpdatePos()
  if self.target == nil then
    return
  end
  self.myWorldPos.x, self.myWorldPos.y, self.myWorldPos.z = self.target:Get_position()
  self.myWorldPos.y = self.myWorldPos.y + self.height
  self.transform.position = CS.CSUtils.WorldPositionToUISpacePosition(self.myWorldPos)
end

function SkillBarCell:OnEnable()
  base.OnEnable(self)
end

function SkillBarCell:OnDisable()
  base.OnDisable(self)
  if self.updateTimer ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

function SkillBarCell:OnAddListener()
  base.OnAddListener(self)
end

function SkillBarCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SkillBarCell:SetData(member)
  self.fire = false
  if member then
    self.icon:SetActive(true)
    self.member = member
    local allActiveSkills = member.skillManager:GetAllActiveSkills()
    for i, v in pairs(allActiveSkills) do
      if not self.skill and v.meta:IsUltimateSkill() then
        self.skill = v
        break
      end
    end
    if member.hero.fromTemplate then
      local uniqueWeaponLv = 0
      if member.hero.GetUniqueWeaponLv then
        uniqueWeaponLv = member.hero:GetUniqueWeaponLv()
      end
      self.icon:InitWithConfigId(member.hero.heroId, nil, member.hero.level, member.hero:GetRank(), uniqueWeaponLv, member.hero:GetHeroAwakenRankLevel(), member.hero:GetSkinId())
    else
      self.icon:SetData(member.hero.uuid)
    end
    self.bg:SetLocalScaleXYZ(NORMAL_SCALE, NORMAL_SCALE, NORMAL_SCALE)
    self.cdImg:SetFillAmount(0)
    self.cdText:SetText("")
    if self.skill then
      self.skillImg:LoadSprite(self.skill.meta.icon)
      self.skillImg2:LoadSprite(self.skill.meta.icon)
    end
    self:HideLock()
    if not self.updateTimer then
      function self.updateTimer()
        self:OnUpdate()
      end
      
      UpdateManager:GetInstance():AddUpdate(self.updateTimer)
    end
    self.icon:SetRank(nil)
    self.icon:ToggleLevel(false)
  else
    self.icon:SetActive(false)
  end
end

function SkillBarCell:TryRefreshSkill()
  if IsNotNull(self.transform) and self.member then
    self.skill = nil
    self:SetData(self.member)
  end
end

function SkillBarCell:OnRefreshUltimateLock()
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

function SkillBarCell:HideLock()
  self.lock:SetActive(false)
end

function SkillBarCell:OnFireState()
  if self.loopAnim then
    self.loopAnim:Stop()
    self.loopAnim = nil
  end
  self.animator:Play("Eff_ui_jinengshifang_tubiaojineng", 0, 0)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_skill_release)
  self.timeStopDuration = 0 < self.skill.meta.time_stop_duration and self.skill.meta.time_stop_duration or 3
  self:SetBubblePos()
  self.skillBubble:SetActive(true)
  self.skillBubble:SetLocalScaleXYZ(0.4, 0.4, 0.4)
  self.skillBubble:Play("Eff_ui_jinengshifang_show", 0, 0)
end

function SkillBarCell:SetBubblePos()
  local worldPos = self.member:GetPosition()
  local skillWorldPos = CS.CSUtils.WorldPositionToUISpacePosition(worldPos) + TANK_HEIGHT
  self.skillBubble:SetPosition(skillWorldPos)
end

function SkillBarCell:ShowPowerEffect()
  self.powerEffect:SetActive(false)
  self.powerEffect:SetActive(true)
end

return SkillBarCell
