local base = UIBaseContainer
local BattlePointFilterItem = BaseClass("BattlePointFilterItem", base)
local Localization = CS.GameEntry.Localization
local bg_path = "Bg"
local text_path = "Text"
local arrow_path = "Arrow"
local COLOR_TEXT_OTHER = "8F8E97"
local COLOR_TEXT_SELF = "2A2830"

function BattlePointFilterItem:OnCreate()
  base.OnCreate(self)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(BindCallback(self, self.OnClickBtn))
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
  self.arrow = self:AddComponent(UIBaseContainer, arrow_path)
end

function BattlePointFilterItem:OnDestroy()
  self.btn = nil
  self.bg = nil
  self.text = nil
  self.arrow = nil
  self.cb = nil
  base.OnDestroy(self)
end

function BattlePointFilterItem:OnClickBtn()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.cb then
    self.cb(self.idx)
  end
end

function BattlePointFilterItem:SetData(idx, cb)
  self.idx = idx
  self.cb = cb
end

function BattlePointFilterItem:ReInit(curIdx, nameKey)
  local bSelf = curIdx == self.filterIdx
  local color = bSelf and COLOR_TEXT_SELF or COLOR_TEXT_OTHER
  self.text:SetText(string.format("<color=#%s>%s</color>", color, Localization:GetString(nameKey)))
  self.bg:SetActive(bSelf)
  self.arrow:SetActive(bSelf)
end

return BattlePointFilterItem
