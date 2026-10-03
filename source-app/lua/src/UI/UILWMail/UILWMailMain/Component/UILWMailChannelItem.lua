local UILWMailChannelItem = BaseClass("UILWMailChannelItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local icon_path = "Icon/Icon"
local title_txt_path = "Name"
local common_red_point_path = "CommonRedPoint"
local click_btn_path = "ClickBtn"

function UILWMailChannelItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailChannelItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailChannelItem:ComponentDefine()
  self.icon = self:AddComponent(UIImage, icon_path)
  self.titleTxt = self:AddComponent(UIText, title_txt_path)
  self.redPoint = self:AddComponent(UICommonRedPoint, common_red_point_path)
  self.redPoint:SetType(CommonRedPointPriority.Level1)
  self.clickBtn = self:AddComponent(UIButton, click_btn_path)
  self.clickBtn:SetOnClick(function()
    self:OnClickChannel()
  end)
  self.gift = self:AddComponent(UIBaseComponent, "Gift")
  self.giftIcon = self:AddComponent(UIImage, "Gift/icon")
end

function UILWMailChannelItem:ComponentDestroy()
  self.icon = nil
  self.titleTxt = nil
  self.redPoint = nil
  self.clickBtn = nil
  self.gift = nil
end

function UILWMailChannelItem:DataDefine()
  self.tab = nil
  self.channelInfos = {}
end

function UILWMailChannelItem:DataDestroy()
  self.tab = nil
  self.channelInfos = nil
end

function UILWMailChannelItem:OnEnable()
  base.OnEnable(self)
end

function UILWMailChannelItem:OnDisable()
  base.OnDisable(self)
end

function UILWMailChannelItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.Mail_DeleteBatchMailDone, self.RefreshRedPoint)
  self:AddUIListener(EventId.MailPush, self.RefreshRedPoint)
end

function UILWMailChannelItem:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.Mail_DeleteBatchMailDone, self.RefreshRedPoint)
  self:RemoveUIListener(EventId.MailPush, self.RefreshRedPoint)
end

function UILWMailChannelItem:SetData(params)
  self.tab = params.tab
  if not self.tab then
    return
  end
  self.channelInfos = MailShowNameGroup[self.tab]
  if not self.channelInfos then
    return
  end
  self.icon:LoadSprite(self.channelInfos.icon_path)
  self.titleTxt:SetLocalText(self.channelInfos.title_txt)
  if self.tab == MailInternalGroup.MAIL_IN_system then
    local isJap = LuaEntry.Player.JPUser and DataCenter.LWSaveGirlManager:IsJPGirlOpen()
    local iconPath = "Assets/Main/Sprites/HeroIconsBig/zyf_youjian_touxiang2.png"
    if isJap then
      iconPath = "Assets/Main/Sprites/HeroIconsBig/zyf_youjian_touxiang1.png"
    end
    local btnType = DataCenter.MailDataManager:GetMailTipBtnType() or 0
    if btnType == 5 then
      iconPath = "Assets/Main/Sprites/UI/UIMain/LWMainUI/zyf_vip_youjianqipao.png"
    end
    self.giftIcon:LoadSpriteAuto(iconPath)
  else
    self.giftIcon:LoadSprite("Assets/Main/Sprites/UI/UILWMail/lt_youjian_jiangli.png")
  end
  self:RefreshRedPoint()
end

function UILWMailChannelItem:RefreshRedPoint()
  local un_read_cnt = self.view.ctrl:GetUnReadMailCountByGroup(self.tab)
  local un_reward_cnt = self.view.ctrl:GetUnRewardMailCountByGroup(self.tab)
  if 0 < un_reward_cnt then
    self.redPoint:SetActive(false)
  else
    self.redPoint:SetDefaultVisible(0 < un_read_cnt)
  end
  self.gift:SetActive(0 < un_reward_cnt)
  if self.tab == MailInternalGroup.MAIL_IN_system then
    self.gift:SetActive(0 < un_reward_cnt + un_read_cnt)
  else
    self.gift:SetActive(0 < un_reward_cnt)
  end
end

function UILWMailChannelItem:OnClickChannel()
  if self.tab == MailInternalGroup.MAIL_IN_daily or self.tab == MailInternalGroup.MAIL_IN_charge then
    DataCenter.MailDataManager:__ReadGroupMail(self.tab)
  end
  self.view.ctrl:SetCurrentView(2)
  self.view.ctrl:SetCurrentTab(self.tab)
  self.view:ContentTrans()
end

return UILWMailChannelItem
