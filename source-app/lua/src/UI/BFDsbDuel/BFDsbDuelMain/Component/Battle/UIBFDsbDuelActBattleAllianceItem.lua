local base = UIBaseContainer
local UIBFDsbDuelActBattleAllianceItem = BaseClass("UIBFDsbDuelActBattleAllianceItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActBattleAllianceItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActBattleAllianceItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActBattleAllianceItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textServerId = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textGroup = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textGroupRankTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.imgGroupRank = self.viewSkin:AddComponent(self, UIImage, 6)
  self.textGroupRankTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.compEmptyContent = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.textEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.compInBattleContent = self.viewSkin:AddComponent(self, UIBaseContainer, 11)
  self.compOutBattleContent = self.viewSkin:AddComponent(self, UIBaseContainer, 12)
  self.textPointTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
  self.textPeopleTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.textBattleRankTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.imgContent = self.viewSkin:AddComponent(self, UIImage, 16)
  self.btnContent = self.viewSkin:AddComponent(self, UIButton, 17)
  self.btnContent:SetOnClick(function()
    self:OnBtnContentClick()
  end)
  self.textGroupRankTxt2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.compMatchingContent = self.viewSkin:AddComponent(self, UIBaseComponent, 19)
  self.textMatching = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 20)
  self.btnPointBg = self.viewSkin:AddComponent(self, UIButton, 21)
  self.btnPointBg:SetOnClick(function()
    self:OnBtnPointBgClick()
  end)
  self.textEmpty:SetLocalText("dsb_duel_tips_1021")
  self.textMatching:SetLocalText("dsb_duel_interface_1032")
  self.maxPlayerNum = LuaEntry.DataConfig:TryGetNum("dragon_battle_base", "k4", 20)
end

function UIBFDsbDuelActBattleAllianceItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgIcon = nil
  self.textName = nil
  self.textServerId = nil
  self.textGroup = nil
  self.textGroupRankTitle = nil
  self.imgGroupRank = nil
  self.textGroupRankTxt = nil
  self.compContent = nil
  self.compEmptyContent = nil
  self.textEmpty = nil
  self.compInBattleContent = nil
  self.compOutBattleContent = nil
  self.textPointTxt = nil
  self.textPeopleTxt = nil
  self.textBattleRankTxt = nil
  self.imgContent = nil
  self.btnContent = nil
  self.textGroupRankTxt2 = nil
  self.compMatchingContent = nil
  self.textMatching = nil
  self.btnPointBg = nil
end

function UIBFDsbDuelActBattleAllianceItem:DataDefine()
end

function UIBFDsbDuelActBattleAllianceItem:DataDestroy()
end

function UIBFDsbDuelActBattleAllianceItem:OnAddListener()
  base.OnAddListener(self)
end

function UIBFDsbDuelActBattleAllianceItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActBattleAllianceItem:SetEmpty()
end

function UIBFDsbDuelActBattleAllianceItem:SetData(data, battleRank, isInBattle)
  self.data = data
  if self.data == BattlefieldDsbConst.EmptyRole then
    self:SetEmpty()
    return
  end
  self.isInBattle = isInBattle
  self.compContent:SetActive(not data.isEmpty)
  self.compEmptyContent:SetActive(data.isEmpty and not data.isMatching)
  self.compMatchingContent:SetActive(data.isEmpty and data.isMatching)
  if not data.isEmpty then
    self.imgIcon:LoadSpriteAuto(string.format(AL_FLAG_SPRITE_PATH, data.icon))
    local color = BattlefieldDsbDuelUtils.GetColorByRoleType(data:GetRole() or 0)
    if data.allianceId == LuaEntry.Player.allianceId or data.uid == LuaEntry.Player.allianceId then
      color = BattlefieldDsbDuelUtils.GetMyColor()
    end
    if data.isMatching then
      self.imgContent:LoadSpriteAuto("Assets/Main/Sprites/UI/BF_Dsb_Duel/UI/lrb_daluandou_jifen_bai.png")
      self.textName:SetColorHex("#FFFFFF")
    elseif color then
      self.imgContent:LoadSpriteAuto(color.actAllianceItemBg)
      self.textName:SetColorHex(color.txtColor)
    end
    self.textName:SetText(string.format("[%s]", data.abbr))
    self.textServerId:SetText("#" .. tostring(data.serverId or data.ownerServerId))
    self.textGroupRankTitle:SetLocalText("dsb_duel_interface_1024")
    self.compInBattleContent:SetActive(isInBattle)
    self.compOutBattleContent:SetActive(not isInBattle)
    if isInBattle then
      self.textPointTxt:SetText(data.battleScore)
      self.textPeopleTxt:SetText(data.battleMember .. "/" .. self.maxPlayerNum)
      self.textBattleRankTxt:SetLocalText("dsb_duel_interface_10" .. 18 + battleRank)
    else
      self.textGroup:SetText(BattlefieldDsbDuelUtils.GetGroupLetter(data.group))
      self.textGroupRankTxt:SetText(data.rank)
      self.textGroupRankTxt2:SetText(data.rank)
      self.imgGroupRank:SetActive(data.rank <= 3)
      self.textGroupRankTxt2:SetActive(data.rank > 3)
      if data.rank <= 3 then
        if data.rank == 1 then
          self.imgGroupRank:LoadSpriteAuto("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang01.png")
        elseif data.rank == 2 then
          self.imgGroupRank:LoadSpriteAuto("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang02.png")
        elseif data.rank == 3 then
          self.imgGroupRank:LoadSpriteAuto("Assets/Main/Sprites/UI/LWCommon/Sprite/FX_wordboss_paihangbang_icon_huizhang03.png")
        end
      end
    end
  end
end

function UIBFDsbDuelActBattleAllianceItem:OnBtnContentClick()
  if self.data == BattlefieldDsbConst.EmptyRole then
    UIUtil.ShowTipsId("dsb_duel_tips_1022")
    return
  end
  if self.data.allianceId == LuaEntry.Player.allianceId or self.data.uid == LuaEntry.Player.allianceId then
    local notice = self:GetMyRoleNotice()
    if self.isInBattle and notice then
      UIUtil.ShowBubbleTipsAuto(notice, Vector3.New(self.transform.position.x, self.transform.position.y + 100, self.transform.position.z), 0, 0, 0, nil, nil, {reversal = true})
    end
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceDetail, {anim = true, hideTop = false}, self.data.name, self.data.allianceId, self.data.serverId)
  end
end

function UIBFDsbDuelActBattleAllianceItem:GetMyRoleNotice()
  local allianceList = BattlefieldDsbDuelUtils.ActInfo:GetTeamBattleAllianceInfo(self.holder.data.isTeamA and BattlefieldDsbConst.TeamType.A or BattlefieldDsbConst.TeamType.B)
  local myRole
  for k, v in ipairs(allianceList) do
    if v.allianceId == LuaEntry.Player.allianceId then
      myRole = v
      break
    end
  end
  if myRole then
    local sb = StringBuilder.New()
    local myScore = myRole.battleScore
    sb:AppendLine(Localization:GetString("dsb_duel_interface_1044", string.GetFormattedSeparatorNum(myScore)))
    for rank, _ in ipairs(allianceList) do
      if _ ~= myRole and _ ~= BattlefieldDsbConst.EmptyRole then
        if myScore >= _.battleScore then
          sb:AppendLine(Localization:GetString("dsb_duel_interface_1043", rank, string.GetFormattedSeparatorNum(myScore - _.battleScore)))
        else
          sb:AppendLine(Localization:GetString("dsb_duel_interface_1042", rank, string.GetFormattedSeparatorNum(_.battleScore - myScore)))
        end
      end
    end
    return sb:ToString()
  end
end

function UIBFDsbDuelActBattleAllianceItem:OnBtnPointBgClick()
  if not self.data or self.data == BattlefieldDsbConst.EmptyRole then
    return
  end
  local actInfo = BattlefieldDsbDuelUtils.ActInfo
  if not actInfo then
    return
  end
  if not actInfo:IsInTeamResultShowPhase() then
    return
  end
  local score = self.data.battleScore
  local oriScore = self.data.battleOriScore
  local emptyRoles = self.data.emptyRoles
  if not oriScore then
    return
  end
  if emptyRoles and 0 < emptyRoles then
    local notice = Localization:GetString("dsb_duel_tips_1019", string.GetFormattedSeparatorNum(score), emptyRoles, string.GetFormattedSeparatorNum(oriScore))
    UIUtil.ShowBubbleTipsAuto(notice, self.btnPointBg.transform.position, 0, -20, 0)
  end
end

return UIBFDsbDuelActBattleAllianceItem
