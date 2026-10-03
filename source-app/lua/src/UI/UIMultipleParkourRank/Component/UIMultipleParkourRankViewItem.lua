local UIMultipleParkourRankViewItem = BaseClass("UIMultipleParkourRankViewItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bg_self_path = "bgSelf"
local bg_path = "bg"
local txt_rank_path = "txtRank"
local txt_last_rank_path = "txtLastRank"
local head_path = "head"
local txt_name_path = "txtName"
local level_path = "level"
local btn_head_path = "btnHead"

function UIMultipleParkourRankViewItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIMultipleParkourRankViewItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMultipleParkourRankViewItem:ComponentDefine()
  self.bg_self = self:AddComponent(UIImage, bg_self_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.txt_rank = self:AddComponent(UITextMeshProUGUIEx, txt_rank_path)
  self.txt_last_rank = self:AddComponent(UITextMeshProUGUIEx, txt_last_rank_path)
  self.head = self:AddComponent(UICommonHead, head_path)
  self.txt_name = self:AddComponent(UITextMeshProUGUIEx, txt_name_path)
  self.level = self:AddComponent(UITextMeshProUGUIEx, level_path)
  self.btn_head = self:AddComponent(UIButton, btn_head_path)
  self.btn_head:SetOnClick(function()
    if self.data and self.data.uid then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerDetail, {anim = true}, self.data.uid)
    end
  end)
end

function UIMultipleParkourRankViewItem:ComponentDestroy()
  self.bg_self = nil
  self.bg = nil
  self.txt_rank = nil
  self.txt_last_rank = nil
  self.head = nil
  self.txt_name = nil
  self.level = nil
  self.btn_head = nil
end

function UIMultipleParkourRankViewItem:Refresh(data, tab)
  self.data = data
  self.head:SetData(data.uid, data.playerInfo.pic, data.playerInfo.picver)
  local name = data.playerInfo.name
  if tab == 2 then
    name = UIUtil.FormatAllianceAndName(data.playerInfo.abbr, data.playerInfo.name, data.uid)
  end
  self.txt_name:SetText(name)
  local rank = data.rank or 0
  if 0 < rank then
    self.txt_rank:SetText(rank)
  else
    self.txt_rank:SetText(Localization:GetString("361054"))
  end
  local key = Localization:GetString("multiply_door_tips_001")
  local level = data.level or 1
  self.level:SetText(key .. " " .. level)
end

function UIMultipleParkourRankViewItem:RefreshSelfUnlisted(selfRank, selfLevel, tab)
  self.data = {}
  self.data.uid = LuaEntry.Player.uid
  self.head:SetData(LuaEntry.Player.uid, LuaEntry.Player.pic, LuaEntry.Player.picVer)
  local name = LuaEntry.Player.name
  if tab == 2 then
    name = LuaEntry.Player:GetFullAllianceName()
  end
  self.txt_name:SetText(name)
  local rank = selfRank
  if 0 < rank then
    self.txt_rank:SetText(rank)
  else
    self.txt_rank:SetText(Localization:GetString("361054"))
  end
  local key = Localization:GetString("multiply_door_tips_001")
  local level = selfLevel
  self.level:SetText(key .. " " .. level)
end

return UIMultipleParkourRankViewItem
