local UIBFDsbDuelActWeekEndPopUpView = BaseClass("UIBFDsbDuelActWeekEndPopUpView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActWeekEndPopUpView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIBFDsbDuelActWeekEndPopUpView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActWeekEndPopUpView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textOtherTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textRankChangeTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 3)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textText1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textText2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textText3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.btnItem1 = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnItem1:SetOnClick(function()
    self:OnBtnItem1Click()
  end)
end

function UIBFDsbDuelActWeekEndPopUpView:ComponentDestroy()
  self.viewSkin = nil
  self.textOtherTitle = nil
  self.textRankChangeTxt = nil
  self.imgIcon = nil
  self.textName = nil
  self.textText1 = nil
  self.textText2 = nil
  self.textText3 = nil
  self.btnPanel = nil
  self.btnItem1 = nil
end

function UIBFDsbDuelActWeekEndPopUpView:DataDefine()
  BattlefieldDsbDuelUtils.ActInfo:SendActInfoMsg()
end

function UIBFDsbDuelActWeekEndPopUpView:DataDestroy()
end

function UIBFDsbDuelActWeekEndPopUpView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DsbDuelActInfoUpdate, self.ReInit)
end

function UIBFDsbDuelActWeekEndPopUpView:OnRemoveListener()
  self:RemoveUIListener(EventId.DsbDuelActInfoUpdate, self.ReInit)
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActWeekEndPopUpView:ReInit()
  BattlefieldDsbDuelUtils.ActInfo:SetIsShownWeekEndPopUp(true)
  self.textOtherTitle:SetLocalText("dsb_duel_interface_1052")
  local alData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if alData then
    self.imgIcon:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, alData.icon))
    self.textName:SetText(UIUtil.FormatAllianceAndName(alData.abbr, alData.name))
  end
  local teamA = BattlefieldDsbDuelUtils.ActInfo:GetTeamInfo(BattlefieldDsbConst.TeamType.A)
  if teamA then
    self.textRankChangeTxt:SetLocalText("dsb_duel_interface_1056", string.format(" %s ", teamA.lastRank), string.format(" %s ", teamA.rank2))
    self.textText1:SetLocalText("dsb_duel_interface_1053", string.format(" %s ", string.GetFormattedStr(teamA.lastScore)), string.format(" %s ", string.GetFormattedStr(teamA.score)))
    self.textText2:SetLocalText("dsb_duel_interface_1054", string.format(" %s ", string.GetFormattedStr(teamA.lastSmallScore)), string.format(" %s ", string.GetFormattedStr(teamA.smallScore)))
    self.textText3:SetLocalText("dsb_duel_interface_1055", string.format(" %s ", string.GetFormattedStr(teamA.lastPower)), string.format(" %s ", string.GetFormattedStr(teamA.power)))
  end
end

function UIBFDsbDuelActWeekEndPopUpView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
end

function UIBFDsbDuelActWeekEndPopUpView:OnBtnItem1Click()
end

return UIBFDsbDuelActWeekEndPopUpView
