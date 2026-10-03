local UILWAllianceSkillItem = BaseClass("UILWAllianceSkillItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization

function UILWAllianceSkillItem:OnCreate()
  base.OnCreate(self)
  self.icon = self:AddComponent(UIImage, "ImgQuality/icon")
  self.title = self:AddComponent(UITextMeshProUGUIEx, "title")
  self.desc = self:AddComponent(UITextMeshProUGUIEx, "desc")
  self.btnJump = self:AddComponent(UIButton, "icon/JumpBtn")
  self.btnUse = self:AddComponent(UIButton, "Btnuse")
  self.btnCD = self:AddComponent(UIButton, "Btncd")
  self.timeNode = self:AddComponent(UITextMeshProUGUIEx, "Btncd/time")
  self.btnJump:SetOnClick(function()
    if self.offcialType then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceGovernmentSkill, {anim = true, hideTop = true}, self.offcialType)
    end
  end)
  self.btnUse:SetOnClick(function()
    if self.offcialType == LWAlMemberOffcialType.Al_Ambassadoe and self.pointData.pointId and self.pointData.uuid then
      DataCenter.AllianceGovernmentSkillManager:UseSkill(AlOfficialSkillType.GuardianTower, self.pointData.pointId, self.pointData.uuid)
    else
      UIUtil.ShowTipsId("avatar_tips006")
    end
  end)
  self.btnCD:SetOnClick(function()
    UIUtil.ShowTipsId("100381")
  end)
  self.btnCD:SetActive(false)
  self.btnUse:SetActive(false)
end

function UILWAllianceSkillItem:OnDestroy()
  self.icon = nil
  self.title = nil
  self.desc = nil
  self.btnJump = nil
  self.btnUse = nil
  self.btnCD = nil
  self.timeNode = nil
  base.OnDestroy(self)
end

function UILWAllianceSkillItem:Update1000MS()
  if self.coolOverTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.coolOverTime - now
    if 0 < remainTime then
      self.timeNode:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.coolOverTime = nil
      self.btnCD:SetActive(false)
      self.btnUse:SetActive(true)
    end
  end
end

function UILWAllianceSkillItem:ReInit(offcialType, pointData)
  local isAmbassadoe = false
  self.offcialType = offcialType
  self.pointData = pointData
  if offcialType == LWAlMemberOffcialType.Al_Ambassadoe then
    local memberInfo = DataCenter.AllianceGovernmentSkillManager:GetMemberInfoByOfficialPos(LWAlMemberOffcialType.Al_Ambassadoe)
    if memberInfo ~= nil and memberInfo.uid == LuaEntry.Player.uid then
      isAmbassadoe = true
    end
    local cfg = DataCenter.AllianceGovernmentSkillManager:GetUsableConfigBySkillType(AlOfficialSkillType.GuardianTower)
    if cfg ~= nil then
      if string.IsNullOrEmpty(cfg.skill_icon) then
        self.icon:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/AllianceGovernmentSkill/Ambassador/mjc_guanzhijineng_icon_dianta.png")
      else
        self.icon:LoadSprite(cfg.skill_icon)
      end
      self.title:SetLocalText(cfg.name)
      self.desc:SetLocalText(cfg.desc)
    end
    local now = UITimeManager:GetInstance():GetServerTime()
    local skillEffectData, coolOverTime = DataCenter.AllianceGovernmentSkillManager:GetUsedSkillStateDataByType(AlOfficialSkillType.GuardianTower)
    if skillEffectData == nil then
      if now < toInt(coolOverTime) then
        self.coolOverTime = coolOverTime
        self.btnCD:SetActive(true)
        self.btnUse:SetActive(false)
        CS.UIGray.SetGray(self.btnCD.transform, true, true)
      else
        self.btnCD:SetActive(false)
        self.btnUse:SetActive(true)
      end
    else
      coolOverTime = toInt(skillEffectData.coolOverTime)
      if now < coolOverTime then
        self.coolOverTime = coolOverTime
        self.btnCD:SetActive(true)
        self.btnUse:SetActive(false)
        CS.UIGray.SetGray(self.btnCD.transform, true, true)
      else
        self.btnCD:SetActive(false)
        self.btnUse:SetActive(true)
      end
    end
  end
  self.isAmbassadoe = isAmbassadoe
end

return UILWAllianceSkillItem
