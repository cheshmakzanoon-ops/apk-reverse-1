local LWUIZombieRushMemberPopView = BaseClass("LWUIZombieRushMemberPopView", UIBaseView)
local MemberListItem = require("UI.LWUIZombieRushMemberPop.Component.UILWZombieRushMemberItem")
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
  self.titleText = self:AddComponent(UIText, "safeArea/Common_img_title/titleText")
  self.closeBtn = self:AddComponent(UIButton, "safeArea/CloseBtn")
  self.playerText = self:AddComponent(UIText, "safeArea/RectMember/PlayerText")
  self.waveText = self:AddComponent(UIText, "safeArea/RectMember/WaveText")
  self.emptyText = self:AddComponent(UIText, "safeArea/EmptyImage/emptyText")
  self.content = self:AddComponent(UIBaseContainer, "safeArea/RectMember/ScrollView/Viewport/Content")
  self.scrollView = self:AddComponent(UILoopListView2, "safeArea/RectMember/ScrollView")
  self.panelBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.rectMember = self:AddComponent(UIBaseContainer, "safeArea/RectMember")
  self.emptyImage = self:AddComponent(UIImage, "safeArea/EmptyImage")
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.panelBtn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.scrollView:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
end

function LWUIZombieRushMemberPopView:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.rankMemberList then
    return nil
  end
  local ShowInfo = self.rankMemberList[index]
  local item = loopScroll:NewListViewItem("UILWZombieRushMemberItem")
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

local function ComponentDestroy(self)
  self:ClearScroll()
  self.titleText = nil
  self.closeBtn = nil
  self.playerText = nil
  self.waveText = nil
  self.emptyText = nil
  self.content = nil
  self.scrollView = nil
  self.panelBtn = nil
  self.rectMember = nil
  self.emptyImage = nil
end

local function DataDefine(self)
  self.playerList = DataCenter.LWZombieRushPlanInfoManager:GetCanAttendPlayerList()
  self.rankMemberList = {}
  self.itemIndex = 0
end

local function DataDestroy(self)
  for i = 1, #self.rankMemberList do
    self.rankMemberList[i] = nil
  end
  self.rankMemberList = nil
  self.itemIndex = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function InitData(self)
  self.rankMemberList = {}
  if next(self.playerList) then
    self.emptyImage:SetActive(false)
    self.rectMember:SetActive(true)
    local i = 1
    for key, value in pairs(self.playerList) do
      self.rankMemberList[i] = value
      i = i + 1
    end
    self:RefreshRankList()
  else
    self.emptyImage:SetActive(true)
    self.rectMember:SetActive(false)
  end
end

function LWUIZombieRushMemberPopView:RefreshRankList()
  self:ClearScroll()
  if #self.rankMemberList > 0 then
    self.scrollView:SetActive(true)
    self.scrollView:SetListItemCount(#self.rankMemberList, false, false)
    self.scrollView:RefreshAllShownItem()
  end
end

function LWUIZombieRushMemberPopView:ClearScroll()
  self.content:RemoveComponents(MemberListItem)
  self.scrollView:ClearAllItems()
end

LWUIZombieRushMemberPopView.OnCreate = OnCreate
LWUIZombieRushMemberPopView.OnDestroy = OnDestroy
LWUIZombieRushMemberPopView.OnEnable = OnEnable
LWUIZombieRushMemberPopView.OnDisable = OnDisable
LWUIZombieRushMemberPopView.ComponentDefine = ComponentDefine
LWUIZombieRushMemberPopView.ComponentDestroy = ComponentDestroy
LWUIZombieRushMemberPopView.DataDefine = DataDefine
LWUIZombieRushMemberPopView.DataDestroy = DataDestroy
LWUIZombieRushMemberPopView.OnAddListener = OnAddListener
LWUIZombieRushMemberPopView.OnRemoveListener = OnRemoveListener
LWUIZombieRushMemberPopView.InitData = InitData
return LWUIZombieRushMemberPopView
