local UIDeleteAccountListPopView = BaseClass("UIDeleteAccountListPopView", UIBaseView)
local MemberListItem = require("UI.UIAccount2.UIDeleteAccountListPop.Component.UIPlayerInfoItemComponent")
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitData()
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
  self.btnClose = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.textTitle = self:AddComponent(UIText, "UICommonPopUpTitle/Common_img_title/titleText")
  self.textDesc = self:AddComponent(UIText, "ImgBg/descText")
  self.serverDesc = self:AddComponent(UIText, "ImgBg/select/serverDesc")
  self.nameDesc = self:AddComponent(UIText, "ImgBg/select/nameDesc")
  self.btnConfirm = self:AddComponent(UIButton, "LW_Btn_Common_New")
  self.btnConfirm:SetOnClick(BindCallback(self, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, "ImgBg/ScrollView/Viewport/Content")
  self.scrollView = self:AddComponent(UILoopListView2, "ImgBg/ScrollView")
  self.scrollView:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.btnClose = nil
  self.textTitle = nil
  self.textDesc = nil
  self.serverDesc = nil
  self.nameDesc = nil
  self.btnConfirm = nil
  self.content = nil
  self.scrollView = nil
end

local function DataDefine(self)
  self.memberList = {}
  self.leaderNum = DataCenter.AccountAllianceLeaderListManager:GetLeaderNum()
  self.itemIndex = 0
end

local function DataDestroy(self)
  self.memberList = nil
  self.itemIndex = nil
  self.leaderNum = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function UIDeleteAccountListPopView:InitData()
  self.memberList = DataCenter.AccountAllianceLeaderListManager:GetLeaderList()
  self.textDesc:SetLocalText("delete_account_content_20", self.leaderNum)
  self:RefreshRankList()
end

function UIDeleteAccountListPopView:RefreshRankList()
  self:ClearScroll()
  if #self.memberList > 0 then
    self.scrollView:SetActive(true)
    self.scrollView:SetListItemCount(#self.memberList, false, false)
    self.scrollView:RefreshAllShownItem()
  end
end

function UIDeleteAccountListPopView:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.memberList then
    return nil
  end
  local ShowInfo = self.memberList[index]
  local item = loopScroll:NewListViewItem("UIPlayerInfoItem")
  local script = self.content:GetComponent(item.gameObject.name, MemberListItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.content:AddComponent(MemberListItem, objectName)
  end
  script:SetActive(true)
  script:SetData(ShowInfo)
  return item
end

function UIDeleteAccountListPopView:ClearScroll()
  self.content:RemoveComponents(MemberListItem)
  self.scrollView:ClearAllItems()
end

UIDeleteAccountListPopView.OnCreate = OnCreate
UIDeleteAccountListPopView.OnDestroy = OnDestroy
UIDeleteAccountListPopView.OnEnable = OnEnable
UIDeleteAccountListPopView.OnDisable = OnDisable
UIDeleteAccountListPopView.ComponentDefine = ComponentDefine
UIDeleteAccountListPopView.ComponentDestroy = ComponentDestroy
UIDeleteAccountListPopView.DataDefine = DataDefine
UIDeleteAccountListPopView.DataDestroy = DataDestroy
UIDeleteAccountListPopView.OnAddListener = OnAddListener
UIDeleteAccountListPopView.OnRemoveListener = OnRemoveListener
return UIDeleteAccountListPopView
