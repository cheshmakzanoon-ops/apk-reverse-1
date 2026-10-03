local UITorchRelayCheerSelectMemberView = BaseClass("UITorchRelayCheerSelectMemberView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local TorchRelayCheerMemberItem = require("UI/LWTorchRelay/Activity/CheerMemberSelect/Component/TorchRelayCheerMemberItem")
local empty_content_root_path = "Content/EmptyContentRoot"
local empty_content_desc_path = "Content/EmptyContentRoot/EmptyContentDesc"
local member_list_root_path = "Content/MemberListRoot"
local content_path = "Content/MemberListRoot/Viewport/Content"
local enter_value_text_path = "Content/startBtn/Layout/EnterValueText"
local enter_image_path = "Content/startBtn/Layout/EnterImage"

function UITorchRelayCheerSelectMemberView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnReInit()
end

function UITorchRelayCheerSelectMemberView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UITorchRelayCheerSelectMemberView:ComponentDefine()
  self.btnPanel = self:AddComponent(UIButton, "UIWidget/panel")
  self.btnPanel:SetOnClick(function()
    self:OnBtnPanelClick()
  end)
  self.textTitle = self:AddComponent(UIText, "UIWidget/TitleText")
  self.textTitle:SetText(Localization:GetString("activity_torch_relay_title_4"))
  self.btnClose = self:AddComponent(UIButton, "UIWidget/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textContentTitle = self:AddComponent(UIText, "Content/ContentTitleText")
  self.startBtn = self:AddComponent(UIButton, "Content/startBtn")
  self.startBtn:SetOnClick(function()
    self:OnStartBtnClick()
  end)
  self.textBtn = self:AddComponent(UIText, "Content/startBtn/Btn/BtnText")
  self.textBtn:SetText(Localization:GetString("activity_torch_relay_button_6"))
  self.empty_content_root = self:AddComponent(UIBaseContainer, empty_content_root_path)
  self.empty_content_desc = self:AddComponent(UITextMeshProUGUIEx, empty_content_desc_path)
  self.empty_content_desc:SetLocalText("activity_torch_relay_desc_17")
  self.member_list_root = self:AddComponent(UILoopListView2, member_list_root_path)
  self.member_list_root:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.member_list_content = self:AddComponent(UIBaseContainer, content_path)
  self.enter_value_text = self:AddComponent(UITextMeshProUGUIEx, enter_value_text_path)
  self.enter_image = self:AddComponent(UIImage, enter_image_path)
end

function UITorchRelayCheerSelectMemberView:ComponentDestroy()
  self.enter_value_text = nil
  self.member_list_content:RemoveComponents(TorchRelayCheerMemberItem)
  self.member_list_root:ClearAllItems()
  self.member_list_root = nil
  self.member_list_content = nil
  self.btnPanel = nil
  self.textTitle = nil
  self.btnClose = nil
  self.textContentTitle = nil
  self.startBtn = nil
  self.textBtn = nil
end

function UITorchRelayCheerSelectMemberView:DataDefine()
  self.itemIndex = 0
end

function UITorchRelayCheerSelectMemberView:DataDestroy()
  self.memberDataList = nil
  self.itemIndex = nil
end

function UITorchRelayCheerSelectMemberView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActivityTorchRelayActReceiveExtraData, self.OnRefresh)
  self:AddUIListener(EventId.OnPackageInfoUpdated, self.OnPackageInfoUpdated)
end

function UITorchRelayCheerSelectMemberView:OnRemoveListener()
  self:RemoveUIListener(EventId.ActivityTorchRelayActReceiveExtraData, self.OnRefresh)
  self:RemoveUIListener(EventId.OnPackageInfoUpdated, self.OnPackageInfoUpdated)
  base.OnRemoveListener(self)
end

function UITorchRelayCheerSelectMemberView:OnReInit()
  self.activityId = self:GetUserData()
  self:OnRefresh()
end

function UITorchRelayCheerSelectMemberView:OnRefresh()
  self.memberDataList = self.ctrl:GetMemberList(self.activityId)
  local noMember = self.memberDataList == nil or #self.memberDataList == 0
  self.member_list_root.gameObject:SetActive(not noMember)
  self.empty_content_root.gameObject:SetActive(noMember)
  if not noMember then
    self.member_list_root:SetListItemCount(#self.memberDataList, false, false)
    self.member_list_root:RefreshAllShownItem()
  end
  self:RefreshStartCostNum()
  self:RefreshSelectNumDesc()
end

function UITorchRelayCheerSelectMemberView:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.memberDataList then
    return nil
  end
  local memberInfo = self.memberDataList[index]
  local item = loopScroll:NewListViewItem("TorchRelayCheerMemberItem")
  local script = self.member_list_content:GetComponent(item.gameObject.name, TorchRelayCheerMemberItem)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.member_list_content:AddComponent(TorchRelayCheerMemberItem, objectName)
  end
  local param = {}
  param.activityId = self.activityId
  param.data = memberInfo
  param.holder = self
  param.onToggleClickHandler = self.OnMemberSelect
  script:ReInit(param)
  script:SetActive(true)
  return item
end

function UITorchRelayCheerSelectMemberView:OnMemberSelect(item)
  if item == nil then
    return
  end
  local activityData = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
  local memberList = activityData:GetAllCheerPlayersData()
  local cheerList = activityData:GetCheerCurSelectUidList()
  local uid = item.data.uid
  if activityData:IsCheering(uid) then
    activityData:RemoveCheerUid(uid)
    item:SetSelectFlagVisible(false)
  elseif cheerList ~= nil and 2 <= #cheerList then
  else
    activityData:AddCheerUid(uid)
    item:SetSelectFlagVisible(true)
  end
  self:RefreshSelectNumDesc()
end

function UITorchRelayCheerSelectMemberView:RefreshSelectNumDesc()
  local activityData = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
  local cheerList = activityData:GetCheerCurSelectUidList()
  local cheerCount = 0
  if cheerList then
    cheerCount = #cheerList
  end
  self.textContentTitle:SetLocalText("activity_torch_relay_desc_16", cheerCount, 2)
end

function UITorchRelayCheerSelectMemberView:RefreshStartCostNum()
  local data = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
  if data == nil or data.config == nil then
    return
  end
  local costId, costNum = data.config:GetGameCost()
  if costId ~= nil and costNum ~= nil then
    self.enter_value_text:SetText("\195\151" .. tostring(costNum))
    if DataCenter.ActivityTorchRelayManager:IsGameCostItemEnough(self.activityId) then
      self.enter_value_text:SetColor(WhiteColor)
    else
      self.enter_value_text:SetColor(RedColor)
    end
    local iconPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, costId)
    self.enter_image:LoadSprite(iconPath)
  end
end

function UITorchRelayCheerSelectMemberView:OnPackageInfoUpdated()
  self:RefreshStartCostNum()
end

function UITorchRelayCheerSelectMemberView:OnStartBtnClick()
  if not DataCenter.ActivityTorchRelayManager:IsGameCostItemEnough(self.activityId) then
    DataCenter.ActivityTorchRelayManager:OnCostItemLack(self.activityId)
    return false
  end
  local memberCount = 0
  if self.memberDataList then
    memberCount = #self.memberDataList
  end
  local activityData = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
  local cheerList = activityData:GetCheerCurSelectUidList()
  local cheerCount = 0
  if cheerList then
    cheerCount = #cheerList
  end
  if cheerCount == 2 then
    DataCenter.ActivityTorchRelayManager:EnterBattle(self.activityId)
  elseif cheerCount < 2 and memberCount >= cheerCount then
    UIUtil.ShowMessage(Localization:GetString("activity_torch_relay_desc_18"), 2, "activity_torch_relay_button_8", "activity_torch_relay_button_6", function()
      DataCenter.ActivityTorchRelayManager:ShareCheerToChat(self.activityId)
    end, function()
      DataCenter.ActivityTorchRelayManager:EnterBattle(self.activityId)
    end)
  else
    Logger.LogError(" > 2 ??????!!!!!!!!!!!!")
  end
end

function UITorchRelayCheerSelectMemberView:OnBtnPanelClick()
  self.ctrl:CloseSelf()
  if self.activityId then
    local activityData = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
    if activityData then
      local cheerList = activityData:GetCheerCurSelectUidList() or {}
      local memberList = activityData:GetAllCheerPlayersData() or {}
      local curCount = #cheerList
      local totalCount = #memberList
      local isMemberCountEnough = 1 <= totalCount
      if curCount < 2 and isMemberCountEnough and curCount < totalCount then
        DataCenter.ActivityTorchRelayManager:SetAutoCheerOn(false)
        activityData:SetCheerAutoSelectUidList(nil)
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.ActivityTorchRelayCheerMemberSelectEnd)
end

function UITorchRelayCheerSelectMemberView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
  if self.activityId then
    local activityData = DataCenter.ActivityTorchRelayManager:GetActivityData(self.activityId)
    if activityData then
      local cheerList = activityData:GetCheerCurSelectUidList() or {}
      local memberList = activityData:GetAllCheerPlayersData() or {}
      local curCount = #cheerList
      local totalCount = #memberList
      local isMemberCountEnough = 1 <= totalCount
      if curCount < 2 and isMemberCountEnough and curCount < totalCount then
        DataCenter.ActivityTorchRelayManager:SetAutoCheerOn(false)
        activityData:SetCheerAutoSelectUidList(nil)
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.ActivityTorchRelayCheerMemberSelectEnd)
end

return UITorchRelayCheerSelectMemberView
