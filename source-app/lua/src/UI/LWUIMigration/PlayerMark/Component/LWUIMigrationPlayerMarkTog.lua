local base = UIBaseContainer
local LWUIMigrationPlayerMarkTog = BaseClass("LWUIMigrationPlayerMarkTog", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local bg_path = "Bg"
local text_path = "Text"
local COLOR_TEXT_OTHER = "8F8E97"
local COLOR_TEXT_SELF = "2A2830"
local ALL_SERVER_ID = 0

function LWUIMigrationPlayerMarkTog:OnCreate()
  base.OnCreate(self)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
  self.bg = self:AddComponent(UIBaseComponent, bg_path)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
end

function LWUIMigrationPlayerMarkTog:OnDestroy()
  self.idx = nil
  self.sId = nil
  self.cb = nil
  self.btn = nil
  self.bg = nil
  self.text = nil
  base.OnDestroy(self)
end

function LWUIMigrationPlayerMarkTog:OnClick()
  if self.cb and self.idx then
    self.cb(self.idx)
  end
end

function LWUIMigrationPlayerMarkTog:SetData(idx, sId, bSelf, cb)
  self.idx = idx
  self.sId = sId
  self.cb = cb
  self.bSelf = bSelf
  local color = bSelf and COLOR_TEXT_SELF or COLOR_TEXT_OTHER
  local str = self.sId == ALL_SERVER_ID and Localization:GetString("151110") or Localization:GetString(208236, self.sId)
  self.text:SetText(string.format("<color=#%s>%s</color>", color, str))
  self.bg:SetActive(bSelf)
end

return LWUIMigrationPlayerMarkTog
