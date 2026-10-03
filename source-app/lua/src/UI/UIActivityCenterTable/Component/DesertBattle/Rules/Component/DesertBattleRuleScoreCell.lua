local base = UIAsyncContainer
local DesertBattleRuleScoreCell = BaseClass("DesertBattleRuleScoreCell", UIAsyncContainer)
local Localization = CS.GameEntry.Localization

function DesertBattleRuleScoreCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function DesertBattleRuleScoreCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function DesertBattleRuleScoreCell:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgIcon = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textScoreAdd = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compRank = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.imgRank = self.viewSkin:AddComponent(self, UIImage, 6)
  self.textRank = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
end

function DesertBattleRuleScoreCell:ComponentDestroy()
  self.viewSkin = nil
  self.imgIcon = nil
  self.textTitle = nil
  self.textDesc = nil
  self.textScoreAdd = nil
  self.compRank = nil
  self.imgRank = nil
  self.textRank = nil
end

function DesertBattleRuleScoreCell:DataDefine()
end

function DesertBattleRuleScoreCell:DataDestroy()
  self.data = nil
end

function DesertBattleRuleScoreCell:OnAddListener()
  base.OnAddListener(self)
end

function DesertBattleRuleScoreCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function DesertBattleRuleScoreCell:UpdateData()
  local info = self.data
  if info == nil then
    return
  end
  local bRank = info.type == BF_RewardPointType.RANK
  self.compRank:SetActive(bRank)
  self.imgIcon:SetActive(not bRank)
  if bRank then
    local rankNum = info.value
    self.textRank:SetText(rankNum)
    local showImg = 0 < rankNum and rankNum <= 3
    self.imgRank:SetActive(showImg)
    if showImg then
      self.imgRank:LoadSpriteAuto(NewRankIconPath[rankNum])
    end
  else
    local showIcon = not string.IsNullOrEmpty(info.icon)
    self.imgIcon:SetActive(showIcon)
    if showIcon then
      self.imgIcon:LoadSpriteAuto(info.icon)
    end
  end
  self.textTitle:SetText(info.name)
  self.textDesc:SetText(info.desc)
  self.textScoreAdd:SetText("+" .. string.GetFormattedStr(info.score or 0))
end

function DesertBattleRuleScoreCell:SetData(data)
  self.data = data
  self:RefreshView()
end

return DesertBattleRuleScoreCell
