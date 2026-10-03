local UIOffSeason1TaskView = BaseClass("UIOffSeason1TaskView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIOffSeason1TaskScorePanel = require("UI.LWOffSeason1.Task.Component.UIOffSeason1TaskScorePanel")
local UIOffSeason1TaskCell = require("UI.LWOffSeason1.Task.Component.UIOffSeason1TaskCell")

function UIOffSeason1TaskView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIOffSeason1TaskView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIOffSeason1TaskView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnClosePanel = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnClosePanel:SetOnClick(function()
    self:OnBtnClosePanelClick()
  end)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.compScorePanel = self.viewSkin:AddComponent(self, UIOffSeason1TaskScorePanel, 4)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 5)
  self.btnGetAll = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnGetAll:SetOnClick(function()
    self:OnBtnGetAllClick()
  end)
  self.textGetAllBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.scrollView = self.viewSkin:AddComponent(self, UIScrollView, 8)
  self.imgBg = self.viewSkin:AddComponent(self, UIImage, 9)
  self.compBannerImg1 = self.viewSkin:AddComponent(self, UIBaseComponent, 10)
  self.compBannerImg2 = self.viewSkin:AddComponent(self, UIBaseComponent, 11)
  self.textGetAllBtn:SetLocalText(2000444)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.btnGetAll:SetSafeClickMode(true)
end

function UIOffSeason1TaskView:ComponentDestroy()
  self:ClearScroll()
  self.viewSkin = nil
  self.btnClosePanel = nil
  self.textTitle = nil
  self.btnClose = nil
  self.compScorePanel = nil
  self.compContent = nil
  self.btnGetAll = nil
  self.textGetAllBtn = nil
  self.scrollView = nil
  self.imgBg = nil
  self.compBannerImg1 = nil
  self.compBannerImg2 = nil
end

function UIOffSeason1TaskView:DataDefine()
  self.groupId = self:GetUserData()
  self:RefreshBanner()
  self:Refresh()
end

function UIOffSeason1TaskView:DataDestroy()
  self.groupId = nil
end

function UIOffSeason1TaskView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PushOffSeason1ActivityTaskInfoUpdate, self.OnPushOffSeason1ActivityTaskInfoUpdate)
  self:AddUIListener(EventId.PushOffSeason1QueenOfBloodTaskInfoUpdate, self.OnPushOffSeason1QueenOfBloodTaskInfoUpdate)
end

function UIOffSeason1TaskView:OnRemoveListener()
  self:RemoveUIListener(EventId.PushOffSeason1ActivityTaskInfoUpdate, self.OnPushOffSeason1ActivityTaskInfoUpdate)
  self:RemoveUIListener(EventId.PushOffSeason1QueenOfBloodTaskInfoUpdate, self.OnPushOffSeason1QueenOfBloodTaskInfoUpdate)
  base.OnRemoveListener(self)
end

function UIOffSeason1TaskView:OnBtnClosePanelClick()
  self.ctrl:CloseSelf()
end

function UIOffSeason1TaskView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIOffSeason1TaskView:OnBtnGetAllClick()
  SFSNetwork.SendMessage(MsgDefines.CityBattleActivityGainTaskReward, self.groupId, -1)
  local rewardPos = self.btnGetAll.transform.position
  local pic = OffSeason1TaskGroupIconPath[self.groupId]
  if not string.IsNullOrEmpty(pic) then
    local dstPos = self:GetFlyTargetPos()
    UIUtil.DoFly(nil, 3, pic, rewardPos, dstPos, nil, nil, nil, nil, 1)
  end
end

function UIOffSeason1TaskView:Refresh()
  self:RefreshTaskData()
  if self.showDatalist and #self.showDatalist > 0 then
    self.scrollView:SetActive(true)
    self.scrollView:SetTotalCount(#self.showDatalist)
    self.scrollView:RefillCells()
  else
    self.scrollView:SetActive(false)
  end
  local taskList = DataCenter.OffSeason1TaskDataManager:GetGoalTaskListByGroup(self.groupId)
  local score = DataCenter.OffSeason1TaskDataManager:GetScoreByTaskGroup(self.groupId)
  self.compScorePanel:SetData(self.groupId, taskList, score)
  self:RefreshGetAllBtn()
end

function UIOffSeason1TaskView:RefreshBanner()
  if self.groupId == OffSeason1TaskGroup.OffSeason1Recapture then
    self.imgBg:SetColorRGBA255(153, 144, 250, 255)
    self.compBannerImg1:SetActive(true)
    self.compBannerImg2:SetActive(false)
  elseif self.groupId == OffSeason1TaskGroup.QueenOfBlood then
    self.imgBg:SetColorRGBA255(255, 163, 88, 255)
    self.compBannerImg1:SetActive(false)
    self.compBannerImg2:SetActive(true)
  end
end

function UIOffSeason1TaskView:RefreshTaskData()
  local taskList = DataCenter.OffSeason1TaskDataManager:GetActivityTaskList(self.groupId)
  if taskList == nil then
    return
  end
  local order = {
    [TaskState.CanReceive] = 1,
    [TaskState.NoComplete] = 2,
    [TaskState.Received] = 3
  }
  table.sort(taskList, function(a, b)
    if a.state ~= b.state then
      return order[a.state] < order[b.state]
    else
      return a.id < b.id
    end
  end)
  self.showDatalist = taskList
end

function UIOffSeason1TaskView:OnItemMoveIn(itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scrollView:AddComponent(UIOffSeason1TaskCell, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  local data = self.showDatalist[index]
  item:ReInit(self.groupId, data.id, data)
end

function UIOffSeason1TaskView:OnItemMoveOut(itemObj, index)
end

function UIOffSeason1TaskView:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UIOffSeason1TaskCell)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.showDatalist = {}
end

function UIOffSeason1TaskView:RefreshGetAllBtn()
  local isShow = false
  if self.showDatalist then
    for i, v in ipairs(self.showDatalist) do
      if v.state == TaskState.CanReceive then
        isShow = true
        break
      end
    end
  end
  self.btnGetAll:SetActive(isShow)
end

function UIOffSeason1TaskView:OnPushOffSeason1ActivityTaskInfoUpdate()
  if self.groupId == OffSeason1TaskGroup.OffSeason1Recapture then
    self:Refresh()
  end
end

function UIOffSeason1TaskView:OnPushOffSeason1QueenOfBloodTaskInfoUpdate()
  if self.groupId == OffSeason1TaskGroup.QueenOfBlood then
    self:Refresh()
  end
end

function UIOffSeason1TaskView:GetFlyTargetPos()
  return self.compScorePanel:GetFlyTargetPos()
end

return UIOffSeason1TaskView
