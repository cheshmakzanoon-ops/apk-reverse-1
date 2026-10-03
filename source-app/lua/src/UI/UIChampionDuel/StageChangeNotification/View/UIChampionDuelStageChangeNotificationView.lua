local UIChampionDuelStageChangeNotificationView = BaseClass("UIChampionDuelStageChangeNotificationView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIChampionDuelStageChangeNotificationView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:UpdateUI()
end

function UIChampionDuelStageChangeNotificationView:ReopenWithoutCreate()
  self:UpdateUI()
end

function UIChampionDuelStageChangeNotificationView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChampionDuelStageChangeNotificationView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.compSemifinal = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.compKnockout = self.viewSkin:AddComponent(self, UIBaseComponent, 3)
  self.textScoreLeft = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textScoreRight = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textKnockoutTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textKnockoutBoby = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnUICommonBlackMask = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnUICommonBlackMask:SetOnClick(function()
    self:OnBtnUICommonBlackMaskClick()
  end)
end

function UIChampionDuelStageChangeNotificationView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.compSemifinal = nil
  self.compKnockout = nil
  self.textScoreLeft = nil
  self.textScoreRight = nil
  self.textKnockoutTitle = nil
  self.textKnockoutBoby = nil
  self.btnClose = nil
  self.btnUICommonBlackMask = nil
end

function UIChampionDuelStageChangeNotificationView:DataDefine()
end

function UIChampionDuelStageChangeNotificationView:DataDestroy()
end

function UIChampionDuelStageChangeNotificationView:OnAddListener()
  base.OnAddListener(self)
end

function UIChampionDuelStageChangeNotificationView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIChampionDuelStageChangeNotificationView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIChampionDuelStageChangeNotificationView:OnBtnUICommonBlackMaskClick()
  self.ctrl:CloseSelf()
end

function UIChampionDuelStageChangeNotificationView:UpdateUI()
  local param = self:GetUserData()
  local stageId = param ~= nil and param.stageId or 0
  local season = param ~= nil and param.season or 0
  local isRematch = stageId == ChampionDuelState.Rematch
  self.textTitle:SetLocalText(isRematch and "champion_duel_limit_1006" or "champion_duel_limit_1007")
  self.textKnockoutTitle:SetLocalText(isRematch and "champion_duel_rules_tittle1011" or "champion_duel_limit_1005")
  self.textKnockoutBoby:SetLocalText(isRematch and "champion_duel_rules_detail1012" or "champion_duel_desc_1002")
  self.compSemifinal:SetActive(isRematch)
  self.compKnockout:SetActive(not isRematch)
  self.textScoreLeft:SetText(isRematch and 2 or 3)
  self.textScoreRight:SetText(isRematch and 1 or 2)
  CommonUtil.PlayerPrefsSetInt(string.format("%s_%s_%s", SettingKeys.CHAMPION_DUEL_STAGE_CHANGE, season, stageId), 1)
end

return UIChampionDuelStageChangeNotificationView
