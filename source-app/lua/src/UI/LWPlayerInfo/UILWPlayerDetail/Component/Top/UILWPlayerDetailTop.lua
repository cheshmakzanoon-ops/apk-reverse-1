local UILWPlayerDetailTop = BaseClass("UILWPlayerDetailTop", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local womenIconPath = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/lrb_gerenxinxi_xingbie00.png"
local manIconPath = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/lrb_gerenxinxi_xingbie01.png"
local settingIconPath = "Assets/Main/Sprites/UI/LWPlayerInfo/Sprite/New/zyf_beizhugongneng_xiangqing_icon.png"
local editIconPath = "Assets/Main/Sprites/UI/UILWPlayerInfo/icon_info_edit.png"
local edit_button_red_dot_path = "nameInfo/BtnEdit/EditButton/EditButtonRedDot"

function UILWPlayerDetailTop:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit()
end

function UILWPlayerDetailTop:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.BirthdaySetDataSuccess, self.OnBirthdaySetDataSuccess)
  self:AddUIListener(EventId.BirthdaySetRewardGet, self.OnBirthdaySetRewardGet)
end

function UILWPlayerDetailTop:OnRemoveListener()
  self:RemoveUIListener(EventId.BirthdaySetDataSuccess, self.OnBirthdaySetDataSuccess)
  self:RemoveUIListener(EventId.BirthdaySetRewardGet, self.OnBirthdaySetRewardGet)
  base.OnRemoveListener(self)
end

function UILWPlayerDetailTop:ComponentDefine()
  self.gerenIcon = self:AddComponent(UIImage, "nameInfo/nameNode/name/geren")
  self.nameText = self:AddComponent(UITextMeshProUGUIEx, "nameInfo/nameNode/name")
  self.countryIcon = self:AddComponent(UIImage, "nameInfo/country")
  self.editBtn = self:AddComponent(UIButton, "nameInfo/BtnEdit")
  self.editBtnIcon = self:AddComponent(UIImage, "nameInfo/BtnEdit/EditButton")
  self.titleText = self:AddComponent(UITextMeshProUGUIEx, "title")
  self.edit_button_red_dot = self:AddComponent(UIImage, edit_button_red_dot_path)
  self.closeBtn = self:AddComponent(UIButton, "CloseBtn")
  self.closeBtn:SetOnClick(function()
    self.view.ctrl:CloseSelf()
  end)
  self.editBtn:SetOnClick(function()
    self:OnEditBtnClick()
  end)
end

function UILWPlayerDetailTop:OnEditBtnClick()
  if CoppaUtil.IsCoppaLimitWithTips() then
    return
  end
  if self.data.isSelf then
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWPlayerEdit, {anim = true, hideTop = true})
  elseif self.data and self.data.name then
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWChangeRemarkName, {anim = true}, self.data.uid, self.data.name)
  end
end

function UILWPlayerDetailTop:ReInit(data)
  if not data then
    return
  end
  self.data = data
  self.uid = data.uid
  self:RefreshCountry(data)
  self:RefreshPlayerInfo(data)
end

function UILWPlayerDetailTop:RefreshPlayerInfo(data)
  if data.isSelf then
    self.editBtnIcon:LoadSprite(editIconPath)
    self.titleText:SetLocalText("avatar_UI_title")
  else
    self.titleText:SetLocalText("avatar_UI_title02")
    self.editBtnIcon:LoadSprite(settingIconPath)
  end
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.uid, data.name)
  self.nameText:SetText(Localization:GetString("140002", data.level) .. " " .. UIUtil.FormatAllianceAndName(data.alAbbr, showName))
  if data.gender == 1 then
    self.gerenIcon:SetActive(true)
    self.gerenIcon:LoadSprite(manIconPath)
  elseif data.gender == 2 then
    self.gerenIcon:SetActive(true)
    self.gerenIcon:LoadSprite(womenIconPath)
  else
    self.gerenIcon:SetActive(false)
  end
  self:RefreshEditBtnRed()
end

function UILWPlayerDetailTop:RefreshEditBtnRed()
  local isShow = false
  if self.data and self.data.isSelf and DataCenter.BirthdayDataManager:FirstSetRewardHaveGetRedDot() and not DataCenter.BirthdayDataManager:CheckDisplayTypeNotOnlySelf() then
    isShow = true
  end
  self.edit_button_red_dot:SetActive(isShow)
end

function UILWPlayerDetailTop:OnBirthdaySetDataSuccess()
  self:RefreshEditBtnRed()
end

function UILWPlayerDetailTop:OnBirthdaySetRewardGet()
  self:RefreshEditBtnRed()
end

function UILWPlayerDetailTop:RefreshCountry(data)
  if data.nation == nil or data.nation == 0 or data.nation == "" or LuaEntry.GlobalData:IsChina() or LuaEntry.Player:IsFromBIGCHINAorUsingLangZH() then
    self.countryIcon:SetActive(false)
  else
    local nationTemplate = DataCenter.NationTemplateManager:GetNationTemplate(data.nation)
    if nationTemplate then
      self.countryIcon:SetActive(true)
      self.countryIcon:LoadSprite(nationTemplate:GetNationFlagPath())
    else
      self.countryIcon:SetActive(false)
    end
  end
end

function UILWPlayerDetailTop:ComponentDestroy()
  self.gerenIcon = nil
  self.nameText = nil
  self.countryIcon = nil
  self.editBtn = nil
  self.editBtnIcon = nil
  self.titleText = nil
  self.closeBtn = nil
  self.edit_button_red_dot = nil
end

function UILWPlayerDetailTop:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWPlayerDetailTop:DataDestroy()
end

return UILWPlayerDetailTop
