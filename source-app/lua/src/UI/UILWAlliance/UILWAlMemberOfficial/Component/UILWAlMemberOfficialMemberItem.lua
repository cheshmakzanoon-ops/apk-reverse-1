local UILWAlMemberOfficialMemberItem = BaseClass("UILWAlMemberOfficialMemberItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local player_icon_path = "PlayerBtn/UIPlayerHead"
local gender_icon_path = "GenderIcon"
local name_txt_path = "NameText"
local power_txt_path = "PowerText"
local lv_text_path = "LvText"
local online_txt_path = "OnLineText"
local in_active_icon_path = "InActiveIcon"
local MALE_ICON_PATH = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_nan.png"
local FEMALE_ICON_PATH = "Assets/Main/Sprites/UI/UILWAlliance/cfm_lianmeng_tubiao_nv.png"

function UILWAlMemberOfficialMemberItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlMemberOfficialMemberItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlMemberOfficialMemberItem:ComponentDefine()
  self.playerIcon = self:AddComponent(UICommonHead, player_icon_path)
  self.genderIcon = self:AddComponent(UIImage, gender_icon_path)
  self.nameText = self:AddComponent(UIText, name_txt_path)
  self.powerText = self:AddComponent(UIText, power_txt_path)
  self.lv_text = self:AddComponent(UIText, lv_text_path)
  self.onLineText = self:AddComponent(UIText, online_txt_path)
  self.in_active_icon = self:AddComponent(UIBaseContainer, in_active_icon_path)
  self.selectImg = self:AddComponent(UIBaseComponent, "SelectImg")
  self.selectImg:SetActive(false)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self.view:SetSelectInfo(self.data, true)
  end)
  self.playerIcon:SetEnableClickShowInfo(true, true)
end

function UILWAlMemberOfficialMemberItem:ComponentDestroy()
  self.playerIcon = nil
  self.genderIcon = nil
  self.nameText = nil
  self.powerText = nil
  self.lv_text = nil
  self.onLineText = nil
end

function UILWAlMemberOfficialMemberItem:DataDefine()
  self.data = {}
  self.uid = nil
end

function UILWAlMemberOfficialMemberItem:DataDestroy()
  self.data = nil
  self.uid = nil
end

function UILWAlMemberOfficialMemberItem:OnEnable()
  base.OnEnable(self)
end

function UILWAlMemberOfficialMemberItem:OnDisable()
  base.OnDisable(self)
end

function UILWAlMemberOfficialMemberItem:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlMemberOfficialMemberItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlMemberOfficialMemberItem:SetData(data, parent)
  self.data = data
  self.parent = parent
  local userId = data.uid
  local userPic = data.pic
  local userPicVer = data.picVer
  self.playerIcon:SetData(userId, userPic, userPicVer, true, data.headBg)
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.data.uid, self.data.name)
  self.nameText:SetText(showName)
  if self.data.uid == LuaEntry.Player.uid then
    self.nameText:SetColor(BlueColor)
  else
    self.nameText:SetColor(description1_color)
  end
  self.genderIcon:SetActive(false)
  if self.data.gender and self.data.gender > 0 and self.data.gender < 3 then
    self.genderIcon:SetActive(self.data.gender == 1 or self.data.gender == 2)
    if self.data.gender == 1 then
      self.genderIcon:LoadSprite(MALE_ICON_PATH)
    elseif self.data.gender == 2 then
      self.genderIcon:LoadSprite(FEMALE_ICON_PATH)
    end
  end
  self.powerText:SetText(Localization:GetString("100253") .. " " .. string.GetFormattedSpecial(self.data.power))
  self.lv_text:SetLocalText(320439, self.data.mainCityLv)
  self.in_active_icon:SetActive(false)
  if self.data.isSelfAlliance then
    self.onLineText:SetActive(true)
    self.onLineText:SetText(self.data.online_time)
    if self.data.isOnline then
      self.onLineText:SetColor(Color.New(0.03529411764705882, 0.9372549019607843, 0.5294117647058824, 1))
    else
      self.onLineText:SetColor(Color.New(0.8, 0.7843137254901961, 0.7764705882352941, 1))
    end
  else
    self.onLineText:SetActive(false)
  end
  self:RefreshSelectImg()
end

function UILWAlMemberOfficialMemberItem:RefreshSelectImg()
  local selectInfo = self.view:GetSelectInfo()
  if selectInfo and self.data and self.data.uid and self.data.uid == selectInfo.uid then
    self.selectImg:SetActive(true)
  else
    self.selectImg:SetActive(false)
  end
end

return UILWAlMemberOfficialMemberItem
