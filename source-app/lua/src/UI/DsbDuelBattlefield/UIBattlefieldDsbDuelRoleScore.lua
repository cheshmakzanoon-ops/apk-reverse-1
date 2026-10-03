local base = UIBaseContainer
local UIBattlefieldDsbDuelRoleScore = BaseClass("UIBattlefieldDsbDuelRoleScore", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIBattlefieldDsbDuelRoleScore:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBattlefieldDsbDuelRoleScore:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBattlefieldDsbDuelRoleScore:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTmpAbbr = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTmpRank = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTmpScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTmpSpd = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.imgFlag = self.viewSkin:AddComponent(self, UIImage, 5)
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 6)
  self.btnUIBattlefieldDsbDuelRoleScore = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnUIBattlefieldDsbDuelRoleScore:SetOnClick(function()
    self:OnBtnUIBattlefieldDsbDuelRoleScoreClick()
  end)
  self.compRoleNode = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.textTmpEmptyLabel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
end

function UIBattlefieldDsbDuelRoleScore:ComponentDestroy()
  self.viewSkin = nil
  self.textTmpAbbr = nil
  self.textTmpRank = nil
  self.textTmpScore = nil
  self.textTmpSpd = nil
  self.imgFlag = nil
  self.imgBg = nil
  self.btnUIBattlefieldDsbDuelRoleScore = nil
  self.compRoleNode = nil
  self.textTmpEmptyLabel = nil
end

function UIBattlefieldDsbDuelRoleScore:DataDefine()
end

function UIBattlefieldDsbDuelRoleScore:DataDestroy()
end

function UIBattlefieldDsbDuelRoleScore:OnAddListener()
  base.OnAddListener(self)
end

function UIBattlefieldDsbDuelRoleScore:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBattlefieldDsbDuelRoleScore:Setup(rank, roleInfo)
  local bEmpty = roleInfo == BattlefieldDsbConst.EmptyRole
  self.roleId = bEmpty and BattlefieldDsbConst.RoleType.None or roleInfo:GetRoleID()
  self.textTmpAbbr:SetText(BattlefieldDsbDuelUtils.GetAllianceAbbr(bEmpty and "---" or roleInfo.allianceAbbr))
  self.textTmpRank:SetLocalText("800323", rank)
  self.textTmpScore:SetActive(not bEmpty)
  self.textTmpSpd:SetActive(not bEmpty)
  self.imgFlag:SetActive(not bEmpty)
  self.textTmpEmptyLabel:SetActive(bEmpty)
  if bEmpty then
    self.textTmpEmptyLabel:SetLocalText("dsb_duel_tips_1021")
    local color = UIUtil.HexToColor("#cdcdcd")
    self.textTmpAbbr:SetColor(color)
    self.textTmpRank:SetColor(color)
    self.imgBg:LoadSpriteAsync(string.format(LoadPath.LWBattleFieldDsbDuelPath, "zxl_daluandou_zhanchang_k2.png"))
  else
    self.textTmpScore:SetText(string.GetFormattedStr(roleInfo.score or 0))
    self.textTmpSpd:SetLocalText("battlefield_common_tips_1", roleInfo.speed)
    self.imgFlag:LoadSpriteAsync(string.format(AL_FLAG_SPRITE_PATH, tostring(roleInfo.allianceIcon)))
    self.textTmpRank:SetColorRGBA(1, 1, 1, 1)
    local color = BattlefieldDsbDuelUtils.GetColorByRoleType(self.roleId, true)
    if color then
      self.textTmpAbbr:SetColor(color.colorLabel)
      self.imgBg:LoadSpriteAsync(string.format(LoadPath.LWBattleFieldDsbDuelPath, color.spBattlefieldBorder))
    end
  end
end

function UIBattlefieldDsbDuelRoleScore:OnBtnUIBattlefieldDsbDuelRoleScoreClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattlefieldDsbDuelBattleRankView, {anim = true}, {
    role = self.roleId
  })
end

return UIBattlefieldDsbDuelRoleScore
