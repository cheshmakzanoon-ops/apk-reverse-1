local base = UIBaseContainer
local UIBattlefieldDsbDuelBattleRankViewRoleItem = BaseClass("UIBattlefieldDsbDuelBattleRankViewRoleItem", base)
local Localization = CS.GameEntry.Localization

function UIBattlefieldDsbDuelBattleRankViewRoleItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBattlefieldDsbDuelBattleRankViewRoleItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBattlefieldDsbDuelBattleRankViewRoleItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textTmpRank = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.imgFlag = self.viewSkin:AddComponent(self, UIImage, 3)
  self.textTmpALName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTmpScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textTmpSpd = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textTmpMember = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.btnUIBattlefieldDsbDuelBattleRankViewRoleItem = self.viewSkin:AddComponent(self, UIButton, 8)
  self.btnUIBattlefieldDsbDuelBattleRankViewRoleItem:SetOnClick(function()
    self:OnBtnUIBattlefieldDsbDuelBattleRankViewRoleItemClick()
  end)
  self.compImgSelection = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.compTipPos = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.compRoleNode = self.viewSkin:AddComponent(self, UIBaseComponent, 11)
  self.compEmptyNode = self.viewSkin:AddComponent(self, UIBaseComponent, 12)
  self.textTmpEmptyLabel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 13)
end

function UIBattlefieldDsbDuelBattleRankViewRoleItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg = nil
  self.textTmpRank = nil
  self.imgFlag = nil
  self.textTmpALName = nil
  self.textTmpScore = nil
  self.textTmpSpd = nil
  self.textTmpMember = nil
  self.btnUIBattlefieldDsbDuelBattleRankViewRoleItem = nil
  self.compImgSelection = nil
  self.compTipPos = nil
  self.compRoleNode = nil
  self.compEmptyNode = nil
  self.textTmpEmptyLabel = nil
end

function UIBattlefieldDsbDuelBattleRankViewRoleItem:DataDefine()
end

function UIBattlefieldDsbDuelBattleRankViewRoleItem:DataDestroy()
  self.roleInfo = nil
end

function UIBattlefieldDsbDuelBattleRankViewRoleItem:OnAddListener()
  base.OnAddListener(self)
end

function UIBattlefieldDsbDuelBattleRankViewRoleItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBattlefieldDsbDuelBattleRankViewRoleItem:Refresh(view, rank, roleInfo)
  self.view = view
  self.textTmpRank:SetLocalText("800323", rank or "")
  self.roleInfo = roleInfo
  if roleInfo == BattlefieldDsbConst.EmptyRole then
    self.compRoleNode:SetActive(false)
    self.compEmptyNode:SetActive(true)
    self.textTmpEmptyLabel:SetLocalText("dsb_duel_tips_1021")
  else
    self.compRoleNode:SetActive(true)
    self.compEmptyNode:SetActive(false)
    self.role = roleInfo.role
    self.textTmpALName:SetText(BattlefieldDsbDuelUtils.GetAllianceAbbr(roleInfo.allianceAbbr))
    self.imgFlag:LoadSpriteAsync(string.format(AL_FLAG_SPRITE_PATH, roleInfo.allianceIcon))
    self.textTmpSpd:SetLocalText("battlefield_common_tips_1", roleInfo.speed)
    self.textTmpScore:SetText(string.GetFormattedStr(roleInfo.score or 0))
    self.textTmpMember:SetText(string.format("%s/%s", roleInfo.count, LuaEntry.DataConfig:TryGetNum("dragon_battle_base", "k4", 20)))
    local color = BattlefieldDsbDuelUtils.GetColorByRoleType(roleInfo:GetRoleID(), true)
    if color then
      self.imgBg:LoadSpriteAsync(color.actAllianceItemBg)
      self.textTmpALName:SetColor(color.colorLabel)
    end
  end
end

function UIBattlefieldDsbDuelBattleRankViewRoleItem:OnBtnUIBattlefieldDsbDuelBattleRankViewRoleItemClick()
  if not self.view then
    return
  end
  if self.roleInfo == BattlefieldDsbConst.EmptyRole then
    UIUtil.ShowTipsId("dsb_duel_tips_1022")
    return
  end
  self.view:RefreshRoleSelection(self.roleInfo, true)
end

function UIBattlefieldDsbDuelBattleRankViewRoleItem:RefreshRoleSelection(roleInfo)
  local isSelected = self.roleInfo == roleInfo
  self.compImgSelection:SetActive(isSelected)
  return isSelected
end

function UIBattlefieldDsbDuelBattleRankViewRoleItem:GetTipPos()
  return self.compTipPos.transform.position
end

return UIBattlefieldDsbDuelBattleRankViewRoleItem
