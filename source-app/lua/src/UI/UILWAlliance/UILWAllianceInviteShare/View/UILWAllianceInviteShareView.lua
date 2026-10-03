local ShareItem = require("UI.UILWAlliance.UILWAllianceInviteShare.Component.UILWAllianceInviteShareItem")
local UILWAllianceInviteShare = BaseClass("UILWAllianceInviteShare", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local return_btn_path = "UICommonPopUpTitle/panel"
local scroll_path = "ImgBg/ScrollView"

local function OnCreate(self)
  base.OnCreate(self)
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.txt_title:SetLocalText(110073)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.ScrollView = self:AddComponent(UIScrollView, scroll_path)
  self.ScrollView:SetTotalCount(0)
  self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.list = {}
end

local function OnDestroy(self)
  self.chat_data_param = nil
  self.txt_title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.ScrollView = nil
  self.list = nil
  base.OnDestroy(self)
end

local function RefreshList(self)
  self:ClearScroll(self)
  local totalChatList = self.ctrl:GetChatList()
  self.list = totalChatList
  if #self.list > 0 then
    self.ScrollView:SetTotalCount(#self.list)
    self.ScrollView:RefillCells()
  end
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshList()
end

local function OnDisable(self)
  self:ClearScroll(self)
  base.OnDisable(self)
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.ScrollView:AddComponent(ShareItem, itemObj)
  cellItem:SetItemShow(self.list[index])
end

local function OnItemMoveOut(self, itemObj, index)
  self.ScrollView:RemoveComponent(itemObj.name, ShareItem)
end

local function ClearScroll(self)
  self.ScrollView:ClearCells()
  self.ScrollView:RemoveComponents(ShareItem)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.CHAT_REFRESH_CHANNEL, self.RefreshList)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.CHAT_REFRESH_CHANNEL, self.RefreshList)
end

local function OnItemClick(self, channel)
  if CoppaUtil.IsCoppaLimitWithTips() then
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceInviteShareConfirm, {anim = true}, channel)
end

UILWAllianceInviteShare.OnCreate = OnCreate
UILWAllianceInviteShare.OnDestroy = OnDestroy
UILWAllianceInviteShare.RefreshList = RefreshList
UILWAllianceInviteShare.OnEnable = OnEnable
UILWAllianceInviteShare.OnDisable = OnDisable
UILWAllianceInviteShare.OnItemMoveIn = OnItemMoveIn
UILWAllianceInviteShare.OnItemMoveOut = OnItemMoveOut
UILWAllianceInviteShare.ClearScroll = ClearScroll
UILWAllianceInviteShare.OnAddListener = OnAddListener
UILWAllianceInviteShare.OnRemoveListener = OnRemoveListener
UILWAllianceInviteShare.OnItemClick = OnItemClick
return UILWAllianceInviteShare
