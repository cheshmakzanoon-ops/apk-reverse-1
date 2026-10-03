local UILWInActivityMemberItem = BaseClass("UILWInActivityMemberItem", UIBaseContainer)
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

function UILWInActivityMemberItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWInActivityMemberItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWInActivityMemberItem:ComponentDefine()
  self.playerIcon = self:AddComponent(UICommonHead, player_icon_path)
  self.genderIcon = self:AddComponent(UIImage, gender_icon_path)
  self.nameText = self:AddComponent(UIText, name_txt_path)
  self.powerText = self:AddComponent(UIText, power_txt_path)
  self.lv_text = self:AddComponent(UIText, lv_text_path)
  self.onLineText = self:AddComponent(UIText, online_txt_path)
  self.in_active_icon = self:AddComponent(UIBaseContainer, in_active_icon_path)
  self.playerIcon:SetEnableClickShowInfo(true, true)
end

function UILWInActivityMemberItem:ComponentDestroy()
  self.playerIcon = nil
  self.genderIcon = nil
  self.nameText = nil
  self.powerText = nil
  self.lv_text = nil
  self.onLineText = nil
end

function UILWInActivityMemberItem:DataDefine()
  self.data = {}
end

function UILWInActivityMemberItem:DataDestroy()
  self.data = nil
end

function UILWInActivityMemberItem:OnEnable()
  base.OnEnable(self)
end

function UILWInActivityMemberItem:OnDisable()
  base.OnDisable(self)
end

function UILWInActivityMemberItem:OnAddListener()
  base.OnAddListener(self)
end

function UILWInActivityMemberItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWInActivityMemberItem:SetData(data)
  self.data = data
  self.playerIcon:ParseHeadInfo(data)
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(data.uid, self.data.name)
  self.nameText:SetText(showName)
  self.genderIcon:SetActive(false)
  if self.data.gender and self.data.gender > 0 and self.data.gender < 3 then
    if self.data.gender == 1 then
      self.genderIcon:SetActive(true)
      self.genderIcon:LoadSprite(MALE_ICON_PATH)
    elseif self.data.gender == 2 then
      self.genderIcon:LoadSprite(FEMALE_ICON_PATH)
    end
  end
  self.powerText:SetText(Localization:GetString("100253") .. string.GetFormattedSpecial(self.data.power))
  self.lv_text:SetLocalText(320439, self.data.level)
  local offline_str
  local deltaTime = UITimeManager:GetInstance():GetServerTime() - self.data.offLineTime
  if 86400000 < deltaTime then
    local day = math.floor(deltaTime / 86400000)
    offline_str = Localization:GetString("390506", day)
  elseif 3600000 < deltaTime then
    local hour = math.floor(deltaTime / 3600000)
    offline_str = Localization:GetString("390505", hour)
  elseif 60000 < deltaTime then
    local minute = math.floor(deltaTime / 60000)
    offline_str = Localization:GetString("390504", minute)
  else
    offline_str = Localization:GetString("390504", 1)
  end
  self.onLineText:SetText(offline_str)
end

return UILWInActivityMemberItem
