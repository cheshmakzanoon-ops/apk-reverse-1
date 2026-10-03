local UIWS_BattleScoreCell = BaseClass("UIWS_BattleScoreCell", UIBaseContainer)
local base = UIBaseContainer

function UIWS_BattleScoreCell:OnCreate()
  base.OnCreate(self)
  self.bg = self:AddComponent(UIImage, "Bg")
  self.text_rank = self:AddComponent(UIText, "RankText")
  self.icon = self:AddComponent(UIPlayerHead, "Head/UIPlayerHead/HeadIcon")
  self.btn = self:AddComponent(UIButton, "Head/UIPlayerHead")
  self.btn:SetOnClick(BindCallback(self, self.OnClickInfoBtn))
  self.text_name = self:AddComponent(UIText, "NameText")
  self.text_lv = self:AddComponent(UIText, "LvText")
  self.text_kill = self:AddComponent(UIText, "KillText")
  self.text_occupy = self:AddComponent(UIText, "OccupyText")
  self.text_rrop = self:AddComponent(UIText, "RropText")
end

function UIWS_BattleScoreCell:OnDestroy()
  self.bg = nil
  self.text_rank = nil
  self.icon = nil
  self.btn = nil
  self.text_name = nil
  self.text_lv = nil
  self.text_kill = nil
  self.text_occupy = nil
  self.text_rrop = nil
  base.OnDestroy(self)
end

function UIWS_BattleScoreCell:OnClickInfoBtn()
  if self.playerUid ~= nil and self.playerUid ~= 0 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = false}, self.playerUid)
  end
end

function UIWS_BattleScoreCell:ReInit(teamArr, index)
  self.playerUid = teamArr.uid
  if self.playerUid == LuaEntry.Player:GetUid() then
    self.bg:SetColorRGBA255(188, 247, 151, 255)
  else
    self.bg:SetColorRGBA255(255, 255, 255, 255)
  end
  self.text_rank:SetText(index)
  self.icon:SetData(teamArr.uid, teamArr.head, teamArr.frame)
  local name = UIUtil.FormatAllianceAndName(teamArr.allianceName, teamArr.name)
  self.text_name:SetText(name)
  self.text_lv:SetLocalText(140002, teamArr.lv)
  self.text_kill:SetText(string.GetFormattedStr(math.floor(teamArr.killScore)))
  self.text_occupy:SetText(string.GetFormattedStr0(math.floor(teamArr.occupyScore)))
  self.text_rrop:SetText(string.GetFormattedStr0(math.floor(teamArr.winPointScore)))
end

return UIWS_BattleScoreCell
