local LWAlAlertBubbleTip = BaseClass("LWAlAlertBubbleTip", UIBaseContainer)
local base = UIBaseContainer
local click_btn_path = "Btn"
local icon_path = "Btn/Icon"
local txt_path = "Btn/Txt"

function LWAlAlertBubbleTip:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWAlAlertBubbleTip:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWAlAlertBubbleTip:ComponentDefine()
  self.txt = self:AddComponent(UITextMeshProUGUIEx, txt_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self:OnClick()
  end)
  self.clickBtn:SetLocalPositionXYZ(-53, 0, 0)
end

function LWAlAlertBubbleTip:ComponentDestroy()
  self.clickBtn = nil
  self.icon = nil
  self.txt = nil
end

function LWAlAlertBubbleTip:OnEnable()
  base.OnEnable(self)
  self:OnRefreshShow()
end

function LWAlAlertBubbleTip:OnDisable()
  base.OnDisable(self)
end

function LWAlAlertBubbleTip:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateAllianceHelpNum, self.OnRefreshShow)
  self:AddUIListener(EventId.UpdateAlertRedPoint, self.OnRefreshShow)
  self:AddUIListener(EventId.AlOfficialSkillAlertEffect, self.OnRefreshShow)
end

function LWAlAlertBubbleTip:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateAllianceHelpNum, self.OnRefreshShow)
  self:RemoveUIListener(EventId.UpdateAlertRedPoint, self.OnRefreshShow)
  self:RemoveUIListener(EventId.AlOfficialSkillAlertEffect, self.OnRefreshShow)
  base.OnRemoveListener(self)
end

function LWAlAlertBubbleTip:OnClick()
  if self.forCityGhost then
    if DataCenter.AllianceWarDataManager:TryJumpToCityGhost() then
      self:OnRefreshShow()
      GoToUtil.CloseAllWindows()
    else
      self:OnRefreshShow()
      DataCenter.AllianceWarDataManager:OpenALWarMain(true)
    end
    return
  end
  if self.alertEffect then
    self:OnRefreshShow()
    DataCenter.AllianceWarDataManager:OpenALWarMain(true, self.jumpTab)
  else
    DataCenter.AllianceWarDataManager:OpenALWarMain(true, self.jumpTab)
  end
end

function LWAlAlertBubbleTip:OnRefreshShow()
  self.forCityGhost = false
  self.alertEffect = DataCenter.AllianceSkillManager:GetActiveEffectAlert(false, AlOfficialSkillType.GuardianTower)
  if self.alertEffect then
    self.txt:SetActive(false)
    self:TrySetShow(true)
    self.clickBtn:LoadSprite("Assets/Main/Sprites/UI/UIMain/LWMainUI/zyf_zhujiemian_tongmeng_qipao.png")
    local unityConfig = DataCenter.AllianceSkillManager:GetAllianceUnityConfigBySkillId(self.alertEffect.skillId)
    if unityConfig and not string.IsNullOrEmpty(unityConfig.AlertIcon) then
      self.icon:LoadSprite(unityConfig:GetLuaData().AlertIcon)
    elseif self.alertEffect.effectType == AlAlertType.AresMissile then
      local seasonType = SeasonUtil.GetSeasonType()
      if seasonType == SeasonMapType.Darkness then
        self.icon:LoadSprite("Assets/Main/SeasonRes/Shared/Sprites/AllianceGovernmentSkill/missile04/ljq_zhujiemian_shandianqiu.png")
      else
        self.icon:LoadSprite("Assets/Main/Sprites/UI/UIMain/LWMainUI/lyp_tongmeng_yujing_tubiao2.png")
      end
    elseif self.alertEffect.effectType == AlAlertType.MissileFactory then
      self.icon:LoadSprite("Assets/Main/Sprites/UI/UIMain/LWMainUI/lyp_tongmeng_yujing_tubiao2.png")
    else
      self.icon:LoadSprite("Assets/Main/Sprites/UI/UIAllianceMark/ljq_zhujiemian_dajisi.png")
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.clickBtn.transform)
    self.jumpTab = AllianceWarTabType.SoloAndAOSE
    return
  end
  if DataCenter.AllianceAlertDataManager:GetAlertNum() > 0 then
    self.txt:SetActive(false)
    self:TrySetShow(true)
    self.clickBtn:LoadSprite("Assets/Main/Sprites/UI/UIMain/LWMainUI/lyp_tongmeng_yujing_qipao.png")
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UIMain/LWMainUI/lyp_tongmeng_yujing_tubiao.png")
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.clickBtn.transform)
    self.jumpTab = AllianceWarTabType.SoloAndAOSE
    return
  end
  if 0 < DataCenter.AllianceWarDataManager:GetAlertNum() then
    self.txt:SetActive(false)
    self:TrySetShow(true)
    self.clickBtn:LoadSprite("Assets/Main/Sprites/UI/UIMain/LWMainUI/lyp_tongmeng_yujing_qipao.png")
    self.icon:LoadSprite("Assets/Main/Sprites/UI/UIMain/LWMainUI/lyp_tongmeng_yujing_tubiao.png")
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.clickBtn.transform)
    self.jumpTab = AllianceWarTabType.Rally
    return
  end
  self:TrySetShow(false)
end

function LWAlAlertBubbleTip:TrySetShow(bool)
  if not bool then
    self:SetShow(false)
  end
  self.holder:TrySetShow(MainAlBubbleType.Alert, bool)
end

function LWAlAlertBubbleTip:SetShow(bool)
  self.clickBtn:SetActive(bool)
end

return LWAlAlertBubbleTip
