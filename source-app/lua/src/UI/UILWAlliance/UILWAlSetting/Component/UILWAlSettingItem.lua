local UILWAlSettingItem = BaseClass("UILWAlSettingItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local icon_path = "clickBtn/Icon"
local bg_path = "clickBtn/Bg"
local txt_path = "clickBtn/Text"
local click_btn_path = "clickBtn"

function UILWAlSettingItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlSettingItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlSettingItem:ComponentDefine()
  self.icon = self:AddComponent(UIImage, icon_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.text = self:AddComponent(UIText, txt_path)
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.greyClickBtn = self:AddComponent(UIButton, "greyClickBtn")
  self.greyClickBtn:SetOnClick(function()
    self:OnGreyClick()
  end)
  self.clickBtn:SetOnClick(function()
    self:OnClick()
  end)
end

function UILWAlSettingItem:OnGreyClick()
  self.greyClicCall(self.type)
end

function UILWAlSettingItem:ComponentDestroy()
  self.icon = nil
  self.bg = nil
  self.text = nil
  self.clickBtn = nil
end

function UILWAlSettingItem:DataDefine()
  self.type = 0
  self.clickCall = nil
end

function UILWAlSettingItem:DataDestroy()
  self.type = nil
  self.clickCall = nil
end

function UILWAlSettingItem:OnEnable()
  base.OnEnable(self)
end

function UILWAlSettingItem:OnDisable()
  base.OnDisable(self)
end

function UILWAlSettingItem:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlSettingItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlSettingItem:SetData(params)
  self.type = params.type
  self.clickCall = params.clickCall
  self.greyClicCall = params.greyClicCall
  if self.type == LWAlSettingBtnType.Al_Apply then
    self.joinSetting = DataCenter.AllianceBaseDataManager:GetAllianceBaseData().recruitTotal
    self:OnUpdateApplyBtn()
  else
    local infos = LWAlSettingBtnParam[self.type]
    if infos then
      self.icon:LoadSprite(infos.Icon)
      self.text:SetLocalText(infos.Text)
      self.bg:LoadSprite(infos.Bg or "Assets/Main/Sprites/UI/UILWMail/cfm_lianmeng_anniu_1.png")
    end
  end
  if self.type == LWAlSettingBtnType.Al_Mail then
    local level = LuaEntry.DataConfig:TryGetNum("alliance_mail_config", "k1", 0)
    local giftLevel = DataCenter.AllianceGiftDataManager:GetCurLevel()
    if level <= giftLevel then
      UIGray.SetGray(self.clickBtn.transform, false, true)
      self.greyClickBtn:SetActive(false)
    else
      UIGray.SetGray(self.clickBtn.transform, true, false)
      self.greyClickBtn:SetActive(true)
    end
  end
end

function UILWAlSettingItem:OnUpdateApplyBtn()
  if self.type == LWAlSettingBtnType.Al_Apply then
    local infos
    if self.joinSetting == 0 then
      infos = {
        Text = 455007,
        Icon = "Assets/Main/Sprites/UI/UILWAlliance/zyf_zhuye_zidongrumeng.png"
      }
    else
      infos = LWAlSettingBtnParam[self.type]
    end
    if infos then
      self.icon:LoadSprite(infos.Icon)
      self.text:SetLocalText(infos.Text)
      self.bg:LoadSprite("Assets/Main/Sprites/UI/UILWMail/cfm_lianmeng_anniu_1.png")
    end
  end
end

function UILWAlSettingItem:OnClick()
  if self.clickCall then
    self.clickCall(self.type)
    if self.type == LWAlSettingBtnType.Al_Apply then
      if self.joinSetting == 0 then
        self.joinSetting = 1
      else
        self.joinSetting = 0
      end
      SFSNetwork.SendMessage(MsgDefines.AllianceChangeAttributes, "", "", self.joinSetting)
      self:OnUpdateApplyBtn()
    end
  end
end

return UILWAlSettingItem
