local UIMomentPlayerList = require("UI.UILWFriendsCircleFollowee.Component.LWMomentPlayerList")
local UILWFriendsCircleFolloweeView = BaseClass("UILWFriendsCircleFolloweeView", UIBaseView)
local base = UIBaseView
local txt_title_path = "UICommonPopUpTitle/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local goback_btn_path = "UICommonPopUpTitle/Btn_GoBack"
local return_btn_path = "UICommonPopUpTitle/panel"
local layout_path = "layout"
local scroll_view_path = "layout/Monment_Scroll_View"
local des_txt_path = "layout/desText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.txt_title:SetLocalText("profile_follow_title")
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.goback_btn = self:AddComponent(UIButton, goback_btn_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.des_txt = self:AddComponent(UIText, des_txt_path)
  self.layout = self:AddComponent(UIBaseContainer, layout_path)
  self.scroll_view = self:AddComponent(UIMomentPlayerList, scroll_view_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.goback_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

local function ComponentDestroy(self)
  self.txt_title = nil
  self.close_btn = nil
  self.return_btn = nil
  self.scroll_view = nil
end

local function DataDefine(self)
  self.list = {}
  ChatInterface.getMoment():ClearMomentList()
  ChatManager2:GetInstance().Net:SendMessage(ChatMsgDefines.MomentFollowList, 0)
end

local function DataDestroy(self)
  ChatInterface.getMoment():ClearMomentList()
  self.list = nil
  self.cells = nil
  self.selectIndex = nil
  self.dragTime = nil
  self.maxNum = nil
  self.maxStr = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.CHAT_MOMENT_FOLLW_LIST, self.ShowCells)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.CHAT_MOMENT_FOLLW_LIST, self.ShowCells)
end

local function SetAllCellsDestroy(self)
  self:ClearScroll()
end

local function ShowCells(self)
  local list = ChatInterface.getMoment():GetMomentFollowList()
  self.list = list
  local tempCount = #list
  if 0 < tempCount then
    self.scroll_view:SetActive(true)
    self.des_txt:SetActive(false)
    self.scroll_view:RefreshRoomData()
  else
    self.scroll_view:SetActive(false)
    self.des_txt:SetActive(true)
    self.des_txt:SetLocalText("follow_list_default")
  end
end

UILWFriendsCircleFolloweeView.OnCreate = OnCreate
UILWFriendsCircleFolloweeView.OnDestroy = OnDestroy
UILWFriendsCircleFolloweeView.OnEnable = OnEnable
UILWFriendsCircleFolloweeView.OnDisable = OnDisable
UILWFriendsCircleFolloweeView.OnAddListener = OnAddListener
UILWFriendsCircleFolloweeView.OnRemoveListener = OnRemoveListener
UILWFriendsCircleFolloweeView.ComponentDefine = ComponentDefine
UILWFriendsCircleFolloweeView.ComponentDestroy = ComponentDestroy
UILWFriendsCircleFolloweeView.DataDefine = DataDefine
UILWFriendsCircleFolloweeView.DataDestroy = DataDestroy
UILWFriendsCircleFolloweeView.SetAllCellsDestroy = SetAllCellsDestroy
UILWFriendsCircleFolloweeView.ShowCells = ShowCells
return UILWFriendsCircleFolloweeView
