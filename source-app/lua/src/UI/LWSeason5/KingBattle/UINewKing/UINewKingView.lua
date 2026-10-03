local base = UIBaseView
local UINewKingView = BaseClass("UINewKingView", base)
local close_path = "panel"
local content_path = "PopUpTitle/Content"
local head_path = "PopUpTitle/Content/head/UIPlayerHead"
local name_path = "PopUpTitle/Content/textName"
local title_path = "PopUpTitle/Content/textTitle"
local desc_path = "PopUpTitle/Content/textDesc"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.close = self:AddComponent(UIButton, close_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.head = self:AddComponent(UIBaseContainer, head_path)
  self.name = self:AddComponent(UIText, name_path)
  self.title = self:AddComponent(UIText, title_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.close:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.headCell = self:AddComponent(UICommonHead, head_path)
  self.headCell:SetEnableClickShowInfo(true, true)
end

local function ComponentDestroy(self)
  self.close = nil
  self.content = nil
  self.head = nil
  self.name = nil
  self.title = nil
  self.desc = nil
end

function UINewKingView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.RefreshPlayerHead)
end

function UINewKingView:OnRemoveListener()
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.RefreshPlayerHead)
  base.OnRemoveListener(self)
end

local function DataDefine(self)
  self.data = self:GetUserData()
end

local function DataDestroy(self)
end

function UINewKingView:RefreshView()
  local data = self.data
  if not data or string.IsNullOrEmpty(data.allianceUserId) then
    self.ctrl:CloseSelf()
    return
  end
  UIUtil.GetMonthActiveCount(string.format("%s_%s_%s", "9king_", data.fightEndTime, LuaEntry.Player.uid), true)
  self.desc:SetLocalText("season_s5_activity_1200067_banner_desc", string.format("#%s [%s] ", data.winAllianceServerId, data.allianceAbbr))
  self:RefreshPlayerHead(data.allianceUserId)
end

function UINewKingView:RefreshPlayerHead(uid)
  if not (not string.IsNullOrEmpty(uid) and self.data) or self.data.allianceUserId ~= uid then
    return
  end
  local userData = UIUtil.GetPlayerInfoShowByUid(uid)
  if userData then
    self.name:SetText(string.format("#%s[%s]%s", userData.serverId, userData.alAbbr, userData.name))
    self.headCell:SetHead(userData.uid, userData.pic, userData.picVer, false, userData.headBg)
  end
end

UINewKingView.OnCreate = OnCreate
UINewKingView.OnDestroy = OnDestroy
UINewKingView.OnEnable = OnEnable
UINewKingView.OnDisable = OnDisable
UINewKingView.ComponentDefine = ComponentDefine
UINewKingView.ComponentDestroy = ComponentDestroy
UINewKingView.DataDefine = DataDefine
UINewKingView.DataDestroy = DataDestroy
return UINewKingView
