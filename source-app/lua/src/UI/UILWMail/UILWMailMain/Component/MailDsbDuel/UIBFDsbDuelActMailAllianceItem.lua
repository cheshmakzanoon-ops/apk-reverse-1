local base = UIBaseContainer
local UIBFDsbDuelActMailAllianceItem = BaseClass("UIBFDsbDuelActMailAllianceItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActMailAllianceItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActMailAllianceItem:OnDestroy()
  self.data = nil
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActMailAllianceItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textServerId = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textPointTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textPeopleTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textBattleRankTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.imgContent = self.viewSkin:AddComponent(self, UIImage, 7)
  self.btnEmptyContent = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnEmptyContent:SetOnClick(function()
    self:OnBtnEmptyContentClick()
  end)
  self.textEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.btnPointBg = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnPointBg:SetOnClick(function()
    self:OnBtnPointBgClick()
  end)
  self.textEmpty:SetLocalText("dsb_duel_tips_1021")
end

function UIBFDsbDuelActMailAllianceItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgIcon = nil
  self.textName = nil
  self.textServerId = nil
  self.textPointTxt = nil
  self.textPeopleTxt = nil
  self.textBattleRankTxt = nil
  self.imgContent = nil
  self.btnEmptyContent = nil
  self.textEmpty = nil
  self.btnPointBg = nil
end

function UIBFDsbDuelActMailAllianceItem:DataDefine()
end

function UIBFDsbDuelActMailAllianceItem:DataDestroy()
end

function UIBFDsbDuelActMailAllianceItem:OnAddListener()
  base.OnAddListener(self)
end

function UIBFDsbDuelActMailAllianceItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActMailAllianceItem:OnBtnEmptyContentClick()
  local strTip = Localization:GetString("dsb_duel_tips_1022")
  UIUtil.ShowBubbleTips(strTip, self.btnEmptyContent.transform.position, 0, 30, 0, nil, nil, {reversal = true})
end

function UIBFDsbDuelActMailAllianceItem:SetData(data)
  local bEmpty = data == BattlefieldDsbConst.EmptyRole
  self.btnEmptyContent:SetActive(bEmpty)
  self.imgContent:SetActive(not bEmpty)
  if bEmpty then
    return
  end
  self.imgIcon:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, data.allianceInfo.icon))
  self.textName:SetText(string.format("[%s]", data.allianceInfo.abbr))
  self.textServerId:SetText("#" .. data.allianceInfo.serverId)
  self.textPointTxt:SetText(data.score)
  self.textPeopleTxt:SetText(data.member)
  if data.rank >= 1 and data.rank <= 4 then
    self.textBattleRankTxt:SetLocalText("dsb_duel_interface_10" .. 18 + data.rank)
  end
  local color = BattlefieldDsbDuelUtils.GetColorByRoleType(data.side or 1)
  if data.allianceInfo.allianceId == LuaEntry.Player.allianceId then
    color = BattlefieldDsbDuelUtils.GetMyColor()
  end
  if color then
    self.imgContent:LoadSprite(color.actAllianceItemBg)
    self.textName:SetColorHex(color.txtColor)
  end
  self.data = data
end

function UIBFDsbDuelActMailAllianceItem:OnBtnPointBgClick()
  if not self.data or self.data == BattlefieldDsbConst.EmptyRole then
    return
  end
  local score = self.data.score
  local oriScore = self.data.oriScore
  local emptyRoles = self.data.emptyRoles
  if not oriScore then
    return
  end
  if emptyRoles and 0 < emptyRoles then
    local notice = Localization:GetString("dsb_duel_tips_1019", string.GetFormattedSeparatorNum(score), emptyRoles, string.GetFormattedSeparatorNum(oriScore))
    UIUtil.ShowBubbleTipsAuto(notice, self.btnPointBg.transform.position, 0, -20, 0)
  end
end

return UIBFDsbDuelActMailAllianceItem
