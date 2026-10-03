local base = UIBaseContainer
local UIBFDsbDuelActHistoryAllianceItem = BaseClass("UIBFDsbDuelActHistoryAllianceItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActHistoryAllianceItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActHistoryAllianceItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActHistoryAllianceItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textServerId = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textPointTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textPeopleTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textScoreTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnScoreBg = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnScoreBg:SetOnClick(function()
    self:OnBtnScoreBgClick()
  end)
  self.btnEmptyContent = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnEmptyContent:SetOnClick(function()
    self:OnBtnEmptyContentClick()
  end)
  self.textEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.btnPointBg = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnPointBg:SetOnClick(function()
    self:OnBtnPointBgClick()
  end)
  self.btnContent = self.viewSkin:AddComponent(self, UIButton, 12)
  self.btnContent:SetOnClick(function()
    self:OnBtnContentClick()
  end)
  self.textEmpty:SetLocalText("dsb_duel_tips_1021")
end

function UIBFDsbDuelActHistoryAllianceItem:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.imgIcon = nil
  self.textName = nil
  self.textServerId = nil
  self.textPointTxt = nil
  self.textPeopleTxt = nil
  self.textScoreTxt = nil
  self.btnScoreBg = nil
  self.btnEmptyContent = nil
  self.textEmpty = nil
  self.btnPointBg = nil
  self.btnContent = nil
end

function UIBFDsbDuelActHistoryAllianceItem:DataDefine()
end

function UIBFDsbDuelActHistoryAllianceItem:DataDestroy()
end

function UIBFDsbDuelActHistoryAllianceItem:OnAddListener()
  base.OnAddListener(self)
end

function UIBFDsbDuelActHistoryAllianceItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActHistoryAllianceItem:OnBtnContentClick()
  if self.data and self.data.allianceId ~= LuaEntry.Player.allianceId then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true, hideTop = false}, self.data.name, self.data.allianceId, self.data.serverId)
  end
end

function UIBFDsbDuelActHistoryAllianceItem:OnBtnEmptyContentClick()
  local strTip = Localization:GetString("dsb_duel_tips_1022")
  UIUtil.ShowBubbleTips(strTip, self.btnEmptyContent.transform.position, 0, 30, 0, nil, nil, {reversal = true})
end

function UIBFDsbDuelActHistoryAllianceItem:SetData(data, rank)
  self.data = data
  self.textTitle:SetText("No." .. rank)
  local bEmpty = data == BattlefieldDsbConst.EmptyRole
  self.btnContent:SetActive(not bEmpty)
  self.btnEmptyContent:SetActive(bEmpty)
  if bEmpty then
    return
  end
  self.imgIcon:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, data.icon))
  self.textName:SetText(string.format("[%s]", data.abbr))
  self.textServerId:SetText("#" .. tostring(data.server or data.ownerServerId))
  self.textPointTxt:SetText(data.battleScore)
  self.textPeopleTxt:SetText(data.member)
  self.textScoreTxt:SetText(data.battleAddScore)
  local color = BattlefieldDsbDuelUtils.GetColorByRoleType(data.role or 1)
  if data.allianceId == LuaEntry.Player.allianceId then
    color = BattlefieldDsbDuelUtils.GetMyColor()
  end
  if color then
    self.btnContent:LoadSpriteAuto(color.actAllianceItemBg)
    self.textName:SetColorHex(color.txtColor)
  end
end

function UIBFDsbDuelActHistoryAllianceItem:OnBtnScoreBgClick()
  local bEmpty = not self.data or self.data == BattlefieldDsbConst.EmptyRole
  if bEmpty then
    return
  end
  BattlefieldDsbDuelUtils.ShowWinningTipsParams(self.btnScoreBg.transform.position, {
    offset = Vector2.New(0, -20),
    name0 = Localization:GetString("dsb_duel_tips_1007"),
    name1 = Localization:GetString("dsb_duel_interface_10" .. 18 + self.data.rank),
    point0 = self.data.winAddExtraScore,
    point1 = self.data.battleAddScore - self.data.winAddExtraScore,
    icon0 = BattlefieldDsbConst.ScoreIconPath,
    icon1 = BattlefieldDsbConst.ScoreIconPath,
    vertical = BattlefieldTipsVertical.Down
  })
end

function UIBFDsbDuelActHistoryAllianceItem:OnBtnPointBgClick()
  if not self.data or self.data == BattlefieldDsbConst.EmptyRole then
    return
  end
  local score = self.data.battleScore
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

return UIBFDsbDuelActHistoryAllianceItem
