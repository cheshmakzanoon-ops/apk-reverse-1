local base = UIBaseContainer
local UILWAlFeatureMemberItem = BaseClass("UILWAlFeatureMemberItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UICommonHead = require("Framework.UI.Component.UICommonHead")
local MALE_ICON_PATH = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_nan.png"
local FEMALE_ICON_PATH = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_nv.png"

function UILWAlFeatureMemberItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlFeatureMemberItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlFeatureMemberItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compBg1Img = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.compBg2Img = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.compUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 3)
  self.imgGenderIcon = self.viewSkin:AddComponent(self, UIImage, 4)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textPower = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textEngagement = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.imgOfficialIcon = self.viewSkin:AddComponent(self, UIImage, 8)
  self.textAllianceName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.btnUse = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnUse:SetOnClick(function()
    self:OnBtnUseClick()
  end)
  self.textUseBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.textInvited = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.btnPowerIcon = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnPowerIcon:SetOnClick(function()
    self:OnBtnPowerIconClick()
  end)
  self.btnEngagementIcon = self.viewSkin:AddComponent(self, UIButton, 14)
  self.btnEngagementIcon:SetOnClick(function()
    self:OnBtnEngagementIconClick()
  end)
  self.compRecordPanel = self.viewSkin:AddComponent(self, UIBaseComponent, 15)
  self.textRecord = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.compSureImg = self.viewSkin:AddComponent(self, UIBaseComponent, 17)
  self.compRefuseImg = self.viewSkin:AddComponent(self, UIBaseComponent, 18)
  self.textPowerFire = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.textEngagementFire = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.compEngagementFire = self.viewSkin:AddComponent(self, UIBaseComponent, 21)
  self.compPowerFire = self.viewSkin:AddComponent(self, UIBaseComponent, 22)
  self.imgMigrateMark = self.viewSkin:AddComponent(self, UIImage, 23)
  self.compUIPlayerHead:SetEnableClickShowInfo(true, true)
  self.textInvited:SetLocalText("alliance_invite_status_waiting")
  self.textUseBtn:SetLocalText("390198")
  self.btnUse:SetSafeClickMode(true)
  self.imgMigrateMark:SetActive(false)
end

function UILWAlFeatureMemberItem:ComponentDestroy()
  self.viewSkin = nil
  self.compBg1Img = nil
  self.compBg2Img = nil
  self.compUIPlayerHead = nil
  self.imgGenderIcon = nil
  self.textName = nil
  self.textPower = nil
  self.textEngagement = nil
  self.imgOfficialIcon = nil
  self.textAllianceName = nil
  self.btnUse = nil
  self.textUseBtn = nil
  self.textInvited = nil
  self.btnPowerIcon = nil
  self.btnEngagementIcon = nil
  self.compRecordPanel = nil
  self.textRecord = nil
  self.compSureImg = nil
  self.compRefuseImg = nil
  self.textPowerFire = nil
  self.textEngagementFire = nil
  self.compEngagementFire = nil
  self.compPowerFire = nil
  self.imgMigrateMark = nil
end

function UILWAlFeatureMemberItem:DataDefine()
end

function UILWAlFeatureMemberItem:DataDestroy()
  self.targetUid = nil
end

function UILWAlFeatureMemberItem:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlFeatureMemberItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlFeatureMemberItem:OnBtnUseClick()
  if self.targetUid then
    local remainCount = self.view.ctrl.remainCount
    if 0 < remainCount then
      SFSNetwork.SendMessage(MsgDefines.AllianceManagerRecommendationInvite, self.targetUid)
    else
      UIUtil.ShowTipsId("alliance_invite_tips_usedup")
    end
  end
end

function UILWAlFeatureMemberItem:OnBtnPowerIconClick()
  UIUtil.ShowBubbleTipsAuto(Localization:GetString("100644"), self.btnPowerIcon:GetPosition(), 0, -30, 0, nil, nil)
end

function UILWAlFeatureMemberItem:OnBtnEngagementIconClick()
  UIUtil.ShowBubbleTipsAuto(Localization:GetString("alliance_invite_desc_activityPoint"), self.btnEngagementIcon:GetPosition(), 0, -30, 0, nil, nil)
end

function UILWAlFeatureMemberItem:SetData(data)
  local roleInfo = data.roleInfo
  self.targetUid = roleInfo.uid
  self.compBg1Img:SetActive(data.isInvited)
  self.compBg2Img:SetActive(not data.isInvited)
  self.compUIPlayerHead:ParseHeadInfo(data.roleInfo)
  local averagePower = DataCenter.AllianceBaseDataManager:GetAveragePower()
  if averagePower and data.roleInfo.power and averagePower > data.roleInfo.power then
    self.textPower:SetActive(true)
    self.textPowerFire:SetActive(false)
    self.textPower:SetText(string.GetFormattedStr0(data.roleInfo.power or 0))
    self.compPowerFire:SetActive(false)
  else
    self.textPower:SetActive(false)
    self.textPowerFire:SetActive(true)
    self.textPowerFire:SetText(string.GetFormattedStr0(data.roleInfo.power or 0))
    self.compPowerFire:SetActive(true)
  end
  if data.engagePoint and data.engagePoint < DataCenter.AllianceFeatureManager.engagePointMax then
    self.textEngagement:SetActive(true)
    self.textEngagementFire:SetActive(false)
    self.textEngagement:SetText(string.GetFormattedStr0(data.engagePoint or 0))
    self.compEngagementFire:SetActive(false)
  else
    self.textEngagement:SetActive(false)
    self.textEngagementFire:SetActive(true)
    self.textEngagementFire:SetText(string.GetFormattedStr0(data.engagePoint or 0))
    self.compEngagementFire:SetActive(true)
  end
  if data.isInvited then
    self.btnUse:SetActive(false)
    if data.state then
      if data.state == 1 then
        self.textInvited:SetActive(false)
        self.compRecordPanel:SetActive(true)
        self.compSureImg:SetActive(true)
        self.compRefuseImg:SetActive(false)
        self.textRecord:SetLocalText("alliance_invite_status_joined")
      elseif data.state == -1 then
        self.textInvited:SetActive(false)
        self.compRecordPanel:SetActive(true)
        self.compSureImg:SetActive(false)
        self.compRefuseImg:SetActive(true)
        self.textRecord:SetLocalText("alliance_invite_status_rejected")
      else
        self.textInvited:SetActive(true)
        self.compRecordPanel:SetActive(false)
      end
    else
      self.textInvited:SetActive(true)
      self.compRecordPanel:SetActive(false)
    end
  else
    self.btnUse:SetActive(true)
    self.textInvited:SetActive(false)
    self.compRecordPanel:SetActive(false)
  end
  self.imgGenderIcon:SetActive(false)
  if roleInfo.gender and 0 < roleInfo.gender then
    if roleInfo.gender == 1 then
      self.imgGenderIcon:SetActive(true)
      self.imgGenderIcon:LoadSprite(MALE_ICON_PATH)
    elseif roleInfo.gender == 2 then
      self.imgGenderIcon:SetActive(true)
      self.imgGenderIcon:LoadSprite(FEMALE_ICON_PATH)
    end
  end
  if roleInfo.mainBuildingLevel then
    self.textName:SetText(roleInfo.name .. "  " .. Localization:GetString("140002", roleInfo.mainBuildingLevel))
  else
    self.textName:SetText(roleInfo.name)
  end
  if not string.IsNullOrEmpty(roleInfo.abbr) then
    self.textAllianceName:SetText("[" .. roleInfo.abbr .. "]" .. roleInfo.allianceName)
  else
    self.textAllianceName:SetLocalText("451033")
  end
  local rank = roleInfo.allianceRank
  if type(rank) == "number" and rank >= LWAlMemberRankType.R4 and rank <= LWAlMemberRankType.R5 then
    self.imgOfficialIcon:SetActive(true)
    self.imgOfficialIcon:LoadSprite(LWAlMemberRankParam[rank].Icon)
  else
    self.imgOfficialIcon:SetActive(false)
  end
  if data.migrate == nil then
  end
  local migrate = data.migrate
  self.imgMigrateMark:SetActive(migrate)
end

return UILWAlFeatureMemberItem
