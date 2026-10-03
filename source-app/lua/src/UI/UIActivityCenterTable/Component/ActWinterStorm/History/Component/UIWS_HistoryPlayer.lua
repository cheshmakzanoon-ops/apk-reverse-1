local UIWS_HistoryPlayer = BaseClass("UIWS_HistoryPlayer", UIBaseContainer)
local base = UIBaseContainer
local icon_path = "Head/UIPlayerHead/HeadIcon"
local btn_path = "Head/UIPlayerHead"
local text_name_path = "NameText"
local text_lv_path = "LvText"

function UIWS_HistoryPlayer:OnCreate()
  base.OnCreate(self)
  self.icon = self:AddComponent(UIPlayerHead, icon_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
  self.textName = self:AddComponent(UIText, text_name_path)
  self.textLv = self:AddComponent(UIText, text_lv_path)
end

function UIWS_HistoryPlayer:OnDestroy()
  self.icon = nil
  self.btn = nil
  self.textName = nil
  self.textLv = nil
  base.OnDestroy(self)
end

function UIWS_HistoryPlayer:OnClickInfoBtn()
  if self.playerUid ~= nil and self.playerUid ~= 0 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true, hideTop = false}, self.playerUid)
  end
end

function UIWS_HistoryPlayer:ReInit(teamArr)
  self.playerUid = teamArr.uid
  self.icon:SetData(teamArr.uid, teamArr.head, teamArr.frame)
  local name = UIUtil.FormatAllianceAndName(teamArr.allianceName, teamArr.name, teamArr.uid)
  self.textName:SetText(name)
  self.textLv:SetLocalText(140002, teamArr.lv)
end

return UIWS_HistoryPlayer
