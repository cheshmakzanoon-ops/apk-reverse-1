local UIS0AllianceBossRewardPreviewView = BaseClass("UIS0AllianceBossRewardPreviewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local OptionData = CS.TMPro.TMP_Dropdown.OptionData
local UIS0AllianceBossAllianceRewardPreview = require("UI.UIS0AllianceBoss.Component.UIS0AllianceBossAllianceRewardPreview")
local UIS0AllianceBossPersonalRewardPreview = require("UI.UIS0AllianceBoss.Component.UIS0AllianceBossPersonalRewardPreview")
local content_path = "Dropdown List/Viewport/Content"
local ITEM_HEIGHT = 55
local VIEWPORT_HEIGHT = 4.5 * ITEM_HEIGHT
local TOP_OFFSET = 7

function UIS0AllianceBossRewardPreviewView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
end

function UIS0AllianceBossRewardPreviewView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIS0AllianceBossRewardPreviewView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnEmpty = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnEmpty:SetOnClick(function()
    self:OnBtnEmptyClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTip = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compNodeActive01 = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.textInactive02 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textActive01 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textInactive01 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.compNodeActive02 = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.textActive02 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.textDifficultySelection = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 11)
  self.compDrop = self.viewSkin:AddComponent(self, UIDropdown, 12)
  self.compAlliance = self.viewSkin:AddComponent(self, UIS0AllianceBossAllianceRewardPreview, 13)
  self.compPersonal = self.viewSkin:AddComponent(self, UIS0AllianceBossPersonalRewardPreview, 14)
  self.btnTab01 = self.viewSkin:AddComponent(self, UIButton, 15)
  self.btnTab01:SetOnClick(function()
    self:OnBtnTab01Click()
  end)
  self.btnTab02 = self.viewSkin:AddComponent(self, UIButton, 16)
  self.btnTab02:SetOnClick(function()
    self:OnBtnTab02Click()
  end)
  self.compDrop:SetOnValueChanged(function(index)
    self:OnValueChanged(index)
  end)
  self.compDrop:RegisterCreateDropdownListCallBack(function()
    self:SetDefaultDropDownPos()
  end)
end

function UIS0AllianceBossRewardPreviewView:ComponentDestroy()
  self.compDrop:Clear()
  self.viewSkin = nil
  self.btnEmpty = nil
  self.textTitle = nil
  self.textTip = nil
  self.btnClose = nil
  self.compNodeActive01 = nil
  self.textInactive02 = nil
  self.textActive01 = nil
  self.textInactive01 = nil
  self.compNodeActive02 = nil
  self.textActive02 = nil
  self.textDifficultySelection = nil
  self.compDrop = nil
  self.compAlliance = nil
  self.compPersonal = nil
  self.btnTab01 = nil
  self.btnTab02 = nil
end

function UIS0AllianceBossRewardPreviewView:DataDefine()
  self.viewDifficulty = nil
  self.minDifficulty = nil
  self.maxDifficulty = nil
  self.gotAllianceReward = nil
  self.gotPersonalReward = nil
  self.gotAllianceBonus = nil
  self.contentPos = Vector2.New(0, 0)
  self.selectTab = nil
end

function UIS0AllianceBossRewardPreviewView:DataDestroy()
  self.viewDifficulty = nil
  self.minDifficulty = nil
  self.maxDifficulty = nil
  self.gotAllianceReward = nil
  self.gotPersonalReward = nil
  self.gotAllianceBonus = nil
  self.contentPos = nil
  self.selectTab = nil
end

function UIS0AllianceBossRewardPreviewView:OnAddListener()
  base.OnAddListener(self)
end

function UIS0AllianceBossRewardPreviewView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIS0AllianceBossRewardPreviewView:InitView()
  self.textTitle:SetLocalText("s0_alliance_boss_reward_title")
  self.textTip:SetLocalText("s0_alliance_boss_alliance_reward_tip")
  self.textInactive01:SetLocalText("s0_alliance_boss_alliance_reward_title")
  self.textActive01:SetLocalText("s0_alliance_boss_alliance_reward_title")
  self.textInactive02:SetLocalText("s0_alliance_boss_personal_reward_title")
  self.textActive02:SetLocalText("s0_alliance_boss_personal_reward_title")
  self.textDifficultySelection:SetLocalText("s0_alliance_boss_difficulty_select")
  self.minDifficulty = 1
  self.maxDifficulty = DataCenter.AllianceBossS0TemplateManager.maxDifficulty
  self:RefreshDrop(self.minDifficulty, self.maxDifficulty)
  local param = self:GetUserData()
  local type = 1
  if param then
    self.viewDifficulty = param.viewDifficulty
    type = param.type or 1
  end
  self.selectTab = type
  local mgr = DataCenter.S0AllianceBossDataManager
  self.curDifficulty = mgr.curDifficulty or 0
  if self.viewDifficulty == nil or self.viewDifficulty == 0 and self.curDifficulty > 0 then
    self.viewDifficulty = self.curDifficulty
  end
  self.viewDifficulty = self.viewDifficulty or 1
  self.compDrop:SetValue(self.viewDifficulty - 1)
  self.compDrop:SetText(Localization:GetString("s0_alliance_boss_difficulty_label", self.viewDifficulty))
  self:RefreshTabState()
end

function UIS0AllianceBossRewardPreviewView:RefreshView()
  if self.bossDifficultyIds == nil then
    self.bossDifficultyIds = DataCenter.AllianceBossS0TemplateManager:GetBossDifficultyIds()
  end
  local bossId = self.bossDifficultyIds and self.bossDifficultyIds[self.viewDifficulty]
  if bossId then
    local bossTemp = DataCenter.AllianceBossS0TemplateManager:GetTemplate(bossId)
    if bossTemp then
      local viewCurChallenge = self.viewDifficulty == self.curDifficulty
      local curStatus = DataCenter.S0AllianceBossDataManager.actStatus
      viewCurChallenge = viewCurChallenge and curStatus >= AllianceBossS0ActStatus.Prepare
      if self.selectTab == 1 then
        self.compAlliance:RefreshView(bossTemp, viewCurChallenge)
      else
        self.compPersonal:RefreshView(bossTemp, viewCurChallenge)
      end
    end
  end
end

function UIS0AllianceBossRewardPreviewView:RefreshTabState()
  if self.selectTab == 1 then
    self.compNodeActive01:SetActive(true)
    self.compNodeActive02:SetActive(false)
    self.compAlliance:SetActive(true)
    self.compPersonal:SetActive(false)
  else
    self.compNodeActive01:SetActive(false)
    self.compNodeActive02:SetActive(true)
    self.compAlliance:SetActive(false)
    self.compPersonal:SetActive(true)
  end
  self:RefreshView()
end

function UIS0AllianceBossRewardPreviewView:RefreshDrop(min, max)
  for i = min, max do
    local temp = OptionData()
    temp.text = Localization:GetString("s0_alliance_boss_difficulty_label", i)
    self.compDrop:Add(temp)
  end
end

function UIS0AllianceBossRewardPreviewView:OnValueChanged(index)
  self.viewDifficulty = index + 1
  self:RefreshView()
end

function UIS0AllianceBossRewardPreviewView:SetDefaultDropDownPos()
  if self.compDrop == nil then
    return
  end
  local content = self.compDrop.transform:Find(content_path)
  if IsNull(content) then
    return
  end
  local nSelectValue = self.compDrop:GetValue()
  local nTotalHeight = self.maxDifficulty * ITEM_HEIGHT
  nTotalHeight = nTotalHeight + TOP_OFFSET
  local targetPos = nSelectValue * ITEM_HEIGHT
  local nCenterOffset = VIEWPORT_HEIGHT / 2
  local nMaxScroll = nTotalHeight - VIEWPORT_HEIGHT
  local nTargetY = math.min(targetPos - nCenterOffset, nMaxScroll)
  nTargetY = math.max(nTargetY, 0)
  self.contentPos.y = nTargetY
  content.transform.anchoredPosition = self.contentPos
end

function UIS0AllianceBossRewardPreviewView:OnBtnEmptyClick()
  self:OnBtnCloseClick()
end

function UIS0AllianceBossRewardPreviewView:OnBtnCloseClick()
  if self.ctrl then
    self.ctrl:CloseSelf()
  end
end

function UIS0AllianceBossRewardPreviewView:OnBtnTab01Click()
  self.selectTab = 1
  self:RefreshTabState()
end

function UIS0AllianceBossRewardPreviewView:OnBtnTab02Click()
  self.selectTab = 2
  self:RefreshTabState()
end

return UIS0AllianceBossRewardPreviewView
