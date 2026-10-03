local base = UIBaseContainer
local UIBattlefieldDsbDuelBattleResultItem = BaseClass("UIBattlefieldDsbDuelBattleResultItem", base)
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization

function UIBattlefieldDsbDuelBattleResultItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBattlefieldDsbDuelBattleResultItem:OnDestroy()
  self.data = nil
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBattlefieldDsbDuelBattleResultItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTmpRank = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTmpALName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTmpServer = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTmpScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTmpScore0 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.textTmpScore1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textTmpScore2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textTmpScore3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.imgIconCup = self.viewSkin:AddComponent(self, UIImage, 9)
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 10)
  self.imgBar0 = self.viewSkin:AddComponent(self, UIImage, 11)
  self.imgBar1 = self.viewSkin:AddComponent(self, UIImage, 12)
  self.imgBar2 = self.viewSkin:AddComponent(self, UIImage, 13)
  self.imgBar3 = self.viewSkin:AddComponent(self, UIImage, 14)
  self.btnClickRect = self.viewSkin:AddComponent(self, UIButton, 15)
  self.btnClickRect:SetOnClick(function()
    self:OnBtnClickRectClick()
  end)
  self.compRoleNode = self.viewSkin:AddComponent(self, UIBaseComponent, 16)
  self.compEmptyNode = self.viewSkin:AddComponent(self, UIBaseComponent, 17)
  self.textTmpEmptyLabel = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 18)
  self.compEmptyMask = self.viewSkin:AddComponent(self, UIBaseComponent, 19)
end

function UIBattlefieldDsbDuelBattleResultItem:ComponentDestroy()
  self.viewSkin = nil
  self.textTmpRank = nil
  self.textTmpALName = nil
  self.textTmpServer = nil
  self.textTmpScore = nil
  self.textTmpScore0 = nil
  self.textTmpScore1 = nil
  self.textTmpScore2 = nil
  self.textTmpScore3 = nil
  self.imgIconCup = nil
  self.imgBg = nil
  self.imgBar0 = nil
  self.imgBar1 = nil
  self.imgBar2 = nil
  self.imgBar3 = nil
  self.btnClickRect = nil
  self.compRoleNode = nil
  self.compEmptyNode = nil
  self.textTmpEmptyLabel = nil
  self.compEmptyMask = nil
end

function UIBattlefieldDsbDuelBattleResultItem:DataDefine()
end

function UIBattlefieldDsbDuelBattleResultItem:DataDestroy()
end

function UIBattlefieldDsbDuelBattleResultItem:OnAddListener()
  base.OnAddListener(self)
end

function UIBattlefieldDsbDuelBattleResultItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

local minLen = 10
local maxLen = 94
local barHeight = 18.4

function UIBattlefieldDsbDuelBattleResultItem:GetBarLen(cur, max)
  cur = cur or 0
  max = max or 1
  local len = cur / max * maxLen
  return math.max(len, minLen)
end

function UIBattlefieldDsbDuelBattleResultItem:Setup(idx, data)
  if not data then
    return
  end
  self.data = data
  self.textTmpRank:SetText(idx)
  if data.empty then
    self.compEmptyNode:SetActive(true)
    self.compEmptyMask:SetActive(true)
    self.compRoleNode:SetActive(false)
    self.textTmpScore:SetText(0)
    self.textTmpScore0:SetText(0)
    self.textTmpScore1:SetText(0)
    self.textTmpScore2:SetText(0)
    self.textTmpScore3:SetText(0)
    self.imgBar0:SetSizeDeltaXY(0, barHeight)
    self.imgBar1:SetSizeDeltaXY(0, barHeight)
    self.imgBar2:SetSizeDeltaXY(0, barHeight)
    self.imgBar3:SetSizeDeltaXY(0, barHeight)
    self.textTmpEmptyLabel:SetLocalText("dsb_duel_tips_1021")
    UIGray.SetGray(self.imgIconCup.transform, true, true)
  else
    self.compEmptyNode:SetActive(false)
    self.compEmptyMask:SetActive(false)
    self.compRoleNode:SetActive(true)
    UIGray.SetGray(self.imgIconCup.transform, false, true)
    self.textTmpALName:SetText(BattlefieldDsbDuelUtils.GetAllianceAbbr(data.allianceAbbr))
    self.textTmpServer:SetText(data.serverId)
    self.textTmpScore:SetText(string.GetFormattedStr(data.battleResultScore or 0))
    self.textTmpScore0:SetText(string.GetFormattedStr(data.score or 0))
    self.textTmpScore1:SetText(string.GetFormattedStr(data.occupiedScore or 0))
    self.textTmpScore2:SetText(string.GetFormattedStr(data.resourceScore or 0))
    self.textTmpScore3:SetText(string.GetFormattedStr(data.plunderScore or 0))
    local max = data.max
    self.imgBar0:SetSizeDeltaXY(self:GetBarLen(data.score, max and max.score), barHeight)
    self.imgBar1:SetSizeDeltaXY(self:GetBarLen(data.occupiedScore, max and max.occupiedScore), barHeight)
    self.imgBar2:SetSizeDeltaXY(self:GetBarLen(data.resourceScore, max and max.resourceScore), barHeight)
    self.imgBar3:SetSizeDeltaXY(self:GetBarLen(data.plunderScore, max and max.plunderScore), barHeight)
    local color = BattlefieldDsbDuelUtils.GetColorByRoleType(data.role, true)
    if color then
      self.textTmpServer:SetColor(color.colorLabel)
      self.textTmpALName:SetColor(color.colorLabel)
      self.imgBg:LoadSpriteAsync(string.format(LoadPath.LWBattleFieldDsbDuelWorldPath, color.rankBg))
    end
  end
end

function UIBattlefieldDsbDuelBattleResultItem:OnBtnClickRectClick()
  if self.data then
    if self.data.empty then
      UIUtil.ShowTipsId("dsb_duel_tips_1022")
      return
    end
    BattlefieldDsbDuelUtils.ShowWinningTipsParams(self.btnClickRect:GetPosition(), {
      name0 = Localization:GetString("dsb_duel_tips_1007"),
      name1 = Localization:GetString("801140", self.data.rank),
      point0 = self.data.winAddExtraScore,
      point1 = self.data.rankScore,
      vertical = BattlefieldTipsVertical.Down
    })
  end
end

return UIBattlefieldDsbDuelBattleResultItem
