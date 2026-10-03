local UIChampionDuelGroupItem = BaseClass("UIChampionDuelGroupItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bg_path = "Bg"
local text_path = "Text"
local arrow_path = "Arrow"
local COLOR_TEXT_OTHER = "8F8E97"
local COLOR_TEXT_SELF = "2A2830"

function UIChampionDuelGroupItem:OnCreate()
  base.OnCreate(self)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(BindCallback(self, self.OnClickBtn))
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
  self.text = self:AddComponent(UIText, text_path)
  self.arrow = self:AddComponent(UIBaseContainer, arrow_path)
end

function UIChampionDuelGroupItem:OnDestroy()
  self.btn = nil
  self.bg = nil
  self.text = nil
  self.arrow = nil
  base.OnDestroy(self)
end

function UIChampionDuelGroupItem:OnClickBtn()
  if self.cb then
    self.cb(self.group)
  end
end

function UIChampionDuelGroupItem:ReInit(group, curGroup, myGroup, cb)
  self.group = group
  self.cb = cb
  local bSelf = group == myGroup
  local color = bSelf and COLOR_TEXT_SELF or COLOR_TEXT_OTHER
  local groupChar = DataCenter.ChampionDuelManager:GetGroupLetter(group)
  local str = Localization:GetString("champion_duel_tips1022", groupChar)
  self.text:SetText(string.format("<color=#%s>%s</color>", color, str))
  self.bg:SetActive(bSelf)
  self.arrow:SetActive(group == curGroup)
end

return UIChampionDuelGroupItem
