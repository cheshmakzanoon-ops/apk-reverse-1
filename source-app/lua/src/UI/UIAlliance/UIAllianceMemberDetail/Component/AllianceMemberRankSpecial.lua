local AllianceMemberRankSpecial = BaseClass("AllianceMemberRankSpecial", UIBaseContainer)
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local base = UIBaseContainer
local name_path = "GameObject/NameTxt"
local online_time_path = "GameObject/onlineTime"
local power_path = "power"
local show_btn_path = "showBtn"
local official_btn_path = "official"
local icon_path = "head/UIPlayerHead/HeadIcon"
local headBg_path = "head/UIPlayerHead"
local headFg_path = "head/UIPlayerHead/Foreground"
local offlineBtn_path = "offlineBtn"
local inactive_path = "inactive"
local inactiveTip_path = "inactive/inactiveTip"

local function OnCreate(self)
  base.OnCreate(self)
  self.name = self:AddComponent(UIText, name_path)
  self.power = self:AddComponent(UIText, power_path)
  self.online_time = self:AddComponent(UIText, online_time_path)
  self.icon = self:AddComponent(UIPlayerHead, icon_path)
  self.headBg = self:AddComponent(UIImage, headBg_path)
  self.headFg = self:AddComponent(UIImage, headFg_path)
  self.official_btn = self:AddComponent(UIButton, official_btn_path)
  self.official_btn.gameObject:SetActive(false)
  self.show_btn = self:AddComponent(UIButton, show_btn_path)
  self.show_btn:SetOnClick(function()
    self:OnShowClick()
  end)
  self.inactiveN = self:AddComponent(UIBaseContainer, inactive_path)
  self.inactiveTipN = self:AddComponent(UIText, inactiveTip_path)
  self.inactiveTipN:SetLocalText(141141)
end

local function OnDestroy(self)
  self.name = nil
  self.power = nil
  self.power_des = nil
  self.online_time = nil
  self.official_btn = nil
  self.show_btn = nil
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnKickAllianceMember, self.OnMemberKicked)
end

local function OnMemberKicked(self, playerId)
  if self.data.uid == playerId then
    self.gameObject:SetActive(false)
  end
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnKickAllianceMember, self.OnMemberKicked)
end

local function RefreshData(self, data)
  self.data = data
  local userId = data.uid
  local userPic = data.pic
  local userPicVer = data.picVer
  self.icon:SetData(userId, userPic, userPicVer, true)
  if data.headBg then
    self.headFg:SetActive(true)
    self.headFg:LoadSprite(data.headBg)
  else
    self.headFg:SetActive(false)
  end
  self.name:SetText(self.data.name)
  if self.data.uid == LuaEntry.Player.uid then
    self.name:SetColor(BlueColor)
  else
    self.name:SetColor(description1_color)
  end
  self.power:SetText(string.GetFormattedSeperatorNum(self.data.power))
  local showInactiveTip = self.view.showInactiveTip
  if self.data.isSelfAlliance then
    if showInactiveTip and self.data.isInactive and DataCenter.AllianceBaseDataManager:IsR4orR5() then
      self.inactiveN:SetActive(true)
    else
      self.inactiveN:SetActive(false)
    end
    self.online_time:SetActive(true)
    self.online_time:SetText(self.data.online_time)
    if self.data.isOnline then
      self.online_time:SetColor(Color.New(0.3607843137254902, 0.8156862745098039, 0.6509803921568628, 1))
    else
      self.online_time:SetColor(Color.New(0.49, 0.49, 0.49, 1))
    end
  else
    self.inactiveN:SetActive(false)
    self.online_time:SetActive(false)
  end
end

local function OnClickShowOfflineTime(self)
  local showTip = self.data.isSelfAlliance and DataCenter.AllianceBaseDataManager:IsR4orR5() and not self.data.isOnline
  if not showTip then
    return
  end
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.offlineBtn.transform.position + Vector3.New(5, 30, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = self.data.online_time
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 180
  param.pivot = 0.5
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function OnOfficialClick(self)
  if self.data.uid ~= LuaEntry.Player.uid then
    self.view.ctrl:OnOfficialViewOpen(self.data.officialNum, self.data.uid)
  end
end

local function OnShowClick(self)
  if self.data.uid ~= LuaEntry.Player.uid then
    local x = self.icon.transform.position.x
    local y = self.icon.transform.position.y
    if self.view.OnShowAllianceMemberTips then
      self.view:OnShowAllianceMemberTips(self.data.uid, self.data.rank, x, y, self.data.name)
    end
  end
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

AllianceMemberRankSpecial.OnCreate = OnCreate
AllianceMemberRankSpecial.OnDestroy = OnDestroy
AllianceMemberRankSpecial.OnEnable = OnEnable
AllianceMemberRankSpecial.OnDisable = OnDisable
AllianceMemberRankSpecial.RefreshData = RefreshData
AllianceMemberRankSpecial.OnShowClick = OnShowClick
AllianceMemberRankSpecial.OnOfficialClick = OnOfficialClick
AllianceMemberRankSpecial.OnClickShowOfflineTime = OnClickShowOfflineTime
AllianceMemberRankSpecial.OnAddListener = OnAddListener
AllianceMemberRankSpecial.OnMemberKicked = OnMemberKicked
AllianceMemberRankSpecial.OnRemoveListener = OnRemoveListener
return AllianceMemberRankSpecial
