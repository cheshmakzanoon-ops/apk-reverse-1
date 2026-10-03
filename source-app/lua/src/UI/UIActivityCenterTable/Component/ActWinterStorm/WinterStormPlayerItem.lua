local WinterStormPlayerItem = BaseClass("WinterStormPlayerItem", UIBaseContainer)
local base = UIBaseContainer
local text_name_path = "NameText"
local icon_path = "Head/UIPlayerHead/HeadIcon"
local btn_path = "Head/Btn"
local text_lv_path = "LvText"

function WinterStormPlayerItem:OnCreate()
  base.OnCreate(self)
  self.playerUid = 0
  self.textName = self:AddComponent(UIText, text_name_path)
  self.icon = self:AddComponent(UIPlayerHead, icon_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
  self.textLv = self:AddComponent(UIText, text_lv_path)
end

function WinterStormPlayerItem:OnDestroy()
  self.playerUid = 0
  self.textName = nil
  self.icon = nil
  self.btn = nil
  self.textLv = nil
  base.OnDestroy(self)
end

function WinterStormPlayerItem:OnClickInfoBtn()
  if self.playerUid ~= nil and self.playerUid ~= 0 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = false}, self.playerUid)
  end
end

function WinterStormPlayerItem:SetPlayer(teamArr)
  self.playerUid = teamArr.uid
  local name = UIUtil.FormatAllianceAndName(teamArr.allianceName, teamArr.name)
  self.textName:SetText(name)
  self.icon:SetData(teamArr.uid, teamArr.head, teamArr.frame)
  self.textLv:SetLocalText(140002, teamArr.lv)
end

return WinterStormPlayerItem
