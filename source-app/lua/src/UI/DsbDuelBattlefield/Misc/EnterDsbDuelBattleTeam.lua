local base = UIBaseContainer
local EnterDsbDuelBattleTeam = BaseClass("EnterDsbDuelBattleTeam", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function EnterDsbDuelBattleTeam:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function EnterDsbDuelBattleTeam:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function EnterDsbDuelBattleTeam:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgBg1 = self.viewSkin:AddComponent(self, UIImage, 1)
  self.imgBg2 = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textTmpRank = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTmpAbbr = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTmpScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textTmpMember = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textTmpEmpty = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
  self.textTmpEmpty:SetLocalText("dsb_duel_tips_1021")
end

function EnterDsbDuelBattleTeam:ComponentDestroy()
  self.viewSkin = nil
  self.imgBg1 = nil
  self.imgBg2 = nil
  self.textTmpRank = nil
  self.textTmpAbbr = nil
  self.textTmpScore = nil
  self.textTmpMember = nil
  self.textTmpEmpty = nil
  self.compContent = nil
end

function EnterDsbDuelBattleTeam:DataDefine()
end

function EnterDsbDuelBattleTeam:DataDestroy()
end

function EnterDsbDuelBattleTeam:OnAddListener()
  base.OnAddListener(self)
end

function EnterDsbDuelBattleTeam:OnRemoveListener()
  base.OnRemoveListener(self)
end

function EnterDsbDuelBattleTeam:Refresh(rank, info)
  self.textTmpRank:SetLocalText("800323", rank)
  local bEmpty = info == BattlefieldDsbConst.EmptyRole
  self.compContent:SetActive(not bEmpty)
  self.textTmpEmpty:SetActive(bEmpty)
  if bEmpty then
    self.textTmpRank:SetColorHex("#cdcdcd")
    self.imgBg2:LoadSpriteAsync(string.format(LoadPath.LWBattleFieldDsbDuelPath, "zxl_daluandou_zhanchang_k.png"))
    self.imgBg1:LoadSpriteAsync(string.format(LoadPath.LWBattleFieldDsbDuelPath, "zxl_daluandou_zanli_duiwu_k.png"))
  else
    self.textTmpRank:SetColorRGBA(1, 1, 1, 1)
    self.textTmpAbbr:SetText(BattlefieldDsbDuelUtils.GetAllianceAbbr(info.abbr))
    self.textTmpScore:SetText(string.GetFormattedStr(info.battleScore))
    self.textTmpMember:SetText(string.format("%s/%s", info.battleMember, LuaEntry.DataConfig:TryGetNum("dragon_battle_base", "k4", 20)))
    local color
    if info.allianceId == LuaEntry.Player.allianceId then
      self.textTmpAbbr:SetColor(BattlefieldDsbConst.SelfAllianceColor)
      color = BattlefieldDsbDuelUtils.GetMyColor()
    else
      color = BattlefieldDsbDuelUtils.GetColorByRoleType(info.role)
    end
    if color then
      self.imgBg2:LoadSpriteAsync(string.format(LoadPath.LWBattleFieldDsbDuelPath, color.spBattlefieldBorder))
      self.imgBg1:LoadSpriteAsync(string.format(LoadPath.LWBattleFieldDsbDuelPath, color.spEnterBg))
      self.textTmpAbbr:SetColorHex(color.txtColor)
    end
  end
end

return EnterDsbDuelBattleTeam
