local UIActivityTaskCommonItem = BaseClass("UIActivityTaskCommonItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local desc_txt_path = "DescIcon/Desc"
local go_btn_path = "GoBtn"
local receive_btn_path = "ReceiveBtn"
local reward_content_path = "RewardScroll/Viewport/Content"
local completedIconPath = "CompletedIcon"
local received_text_path = "ReceivedText"
local go_btn_text_path = "GoBtn/GoBtnText"
local receive_btn_text_path = "ReceiveBtn/ReceiveBtnText"

function UIActivityTaskCommonItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActivityTaskCommonItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActivityTaskCommonItem:ComponentDefine()
  self.descText = self:AddComponent(UIText, desc_txt_path)
  self.goBtn = self:AddComponent(UIButton, go_btn_path)
  self.goBtn:SetOnClick(function()
    self:OnGoClick()
  end)
  self.receiveBtn = self:AddComponent(UIButton, receive_btn_path)
  self.receiveBtn:SetOnClick(function()
    self:OnReceiveClick()
  end)
  self.rewardContent = self:AddComponent(UIBaseContainer, reward_content_path)
  self.completedIcon = self:AddComponent(UIImage, completedIconPath)
  self.go_btn_text = self:AddComponent(UITextMeshProUGUIEx, go_btn_text_path)
  self.receive_btn_text = self:AddComponent(UITextMeshProUGUIEx, receive_btn_text_path)
  self.go_btn_text:SetLocalText("110003")
  self.receive_btn_text:SetLocalText("170004")
  self.dailyFlag = self:TryAddComponent(UIBaseContainer, "dailyFlag")
  self.dailyFlagDesc = self:TryAddComponent(UIText, "dailyFlag/dailyFlagDesc")
  self.rewardScroll = self:AddComponent(UILoopListView2, "RewardScroll")
  self.rewardScroll:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
end

function UIActivityTaskCommonItem:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.rewardList then
    return nil
  end
  self.itemIndex = self.itemIndex or 0
  local data = self.rewardList[index]
  local item = loopScroll:NewListViewItem("UICommonResItem")
  local cell = self.rewardContent:GetComponent(item.gameObject.name, UICommonResItem)
  if cell == nil then
    item.name = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    cell = self.rewardContent:AddComponent(UICommonResItem, item.name)
  end
  cell:SetLocalScaleXYZ(0.75, 0.8, 1)
  cell:SetSizeDelta(Vector2.New(118, 118))
  cell:SetActive(true)
  cell:ReInit(data)
  return item
end

function UIActivityTaskCommonItem:ComponentDestroy()
  self.rewardContent:RemoveComponents(UICommonResItem)
  self.rewardScroll:ClearAllItems()
  self.rewardScroll = nil
  self.dailyFlag = nil
  self.descText = nil
  self.goBtn = nil
  self.receiveBtn = nil
  self.rewardContent = nil
  self.completedIcon = nil
end

function UIActivityTaskCommonItem:DataDefine()
  self.itemIndex = 1
  self.rewardList = nil
  self.infos = {}
  self.itemReqs = {}
  self.itemList = {}
  self.showRewardId = nil
end

function UIActivityTaskCommonItem:DataDestroy()
  self:ClearContent()
  self.itemIndex = nil
  self.isRefreshReward = nil
  self.infos = nil
  self.itemReqs = nil
  self.itemList = nil
  self.onRewardAnimBack = nil
  self.showRewardId = nil
end

function UIActivityTaskCommonItem:ClearContent()
end

function UIActivityTaskCommonItem:RefreshReward(rewardList)
  self.rewardList = rewardList
  self.rewardScroll:SetListItemCount(#self.rewardList, false, false)
  self.rewardScroll:RefreshAllShownItem()
end

function UIActivityTaskCommonItem:SpawnRewardItem(i, data)
  return self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
    if req == nil or IsNull(req.gameObject) then
      return
    end
    local item = req.gameObject
    item.name = "reward_item" .. i
    item:SetActive(true)
    item.transform:SetParent(self.rewardContent.transform)
    item.transform:Set_localScale(0.75, 0.8, 1)
    item.transform:Set_sizeDelta(118, 118)
    item.transform:Set_pivot(0.5, 0.5)
    local cell = self.rewardContent:AddComponent(UICommonResItem, item.name)
    cell:ReInit(data)
  end)
end

function UIActivityTaskCommonItem:SetData(taskData, callback)
  self.clickHandler = callback
  self.taskData = taskData
  self.taskTemplate = DataCenter.ActivityTaskTemplateManager:GetActTaskTemplate(self.taskData.id)
  local taskDesc = Localization:GetString(self.taskTemplate.desc, self.taskTemplate.para2)
  local process = ""
  local curNum = self.taskData.num and self.taskData.num or 0
  local targetNum = self.taskTemplate.para2
  if 0 <= curNum - targetNum then
    curNum = targetNum
  end
  curNum = string.GetFormattedSeperatorNum(curNum)
  targetNum = string.GetFormattedSeperatorNum(targetNum)
  process = " (" .. curNum .. "/" .. targetNum .. ")"
  self.descText:SetText(taskDesc .. process)
  local showList = DataCenter.RewardManager:ReturnRewardParamForView(self.taskData.reward)
  self:RefreshReward(showList)
  local state = self.taskData.state
  if state == TaskState.Received then
    self.completedIcon:SetActive(true)
    self.receiveBtn:SetActive(false)
    self.goBtn:SetActive(false)
  elseif state == TaskState.CanReceive then
    self.completedIcon:SetActive(false)
    self.receiveBtn:SetActive(true)
    self.goBtn:SetActive(false)
  else
    self.completedIcon:SetActive(false)
    self.receiveBtn:SetActive(false)
    self.goBtn:SetActive(true)
  end
  if self.dailyFlag then
    self.dailyFlag:SetActive(tonumber(self.taskTemplate.group) == 1)
  end
end

function UIActivityTaskCommonItem:OnGoClick()
  if self.taskTemplate then
    GoToUtil.GoToByQuestId(self.taskTemplate)
  end
end

function UIActivityTaskCommonItem:OnReceiveClick()
  if self.clickHandler then
    self.clickHandler(self.taskData)
  end
end

return UIActivityTaskCommonItem
