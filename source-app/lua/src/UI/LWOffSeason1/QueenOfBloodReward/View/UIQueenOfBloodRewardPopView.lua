local UIQueenOfBloodRewardPopView = BaseClass("UIQueenOfBloodRewardPopView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIOffSeason1QueenOfBloodRewardItem = require("UI.LWOffSeason1.QueenOfBloodReward.Component.TaskCellComponent")

function UIQueenOfBloodRewardPopView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Refresh()
end

function UIQueenOfBloodRewardPopView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIQueenOfBloodRewardPopView:ComponentDefine()
  self.btnClose = self:AddComponent(UIButton, "safeArea/CloseBtn")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnBgClose = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.btnBgClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.scrollView = self:AddComponent(UIScrollView, "safeArea/TaskPage")
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.btnGetAll = self:AddComponent(UIButton, "safeArea/GetAllBtn")
  self.textGetAllBtn = self:AddComponent(UIText, "safeArea/GetAllBtn/LW_Btn_Common_New_Base/GetAllBtnText")
  self.btnGetAll:SetOnClick(function()
    self:OnClickGetAll()
  end)
  self.textGetAllBtn:SetLocalText(2000444)
end

function UIQueenOfBloodRewardPopView:ComponentDestroy()
  self:ClearScroll()
  self.btnClose = nil
  self.scrollView = nil
  self.btnBgClose = nil
  self.btnGetAll = nil
  self.textGetAllBtn = nil
end

function UIQueenOfBloodRewardPopView:DataDefine()
  self.activityId = DataCenter.OffSeason1QueenOfBloodManager:GetQueenOfBloodActId()
end

function UIQueenOfBloodRewardPopView:DataDestroy()
  self.activityId = nil
end

function UIQueenOfBloodRewardPopView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PushOffSeason1QueenOfBloodTaskInfoUpdate, self.Refresh)
end

function UIQueenOfBloodRewardPopView:OnRemoveListener()
  self:RemoveUIListener(EventId.PushOffSeason1QueenOfBloodTaskInfoUpdate, self.Refresh)
  base.OnRemoveListener(self)
end

function UIQueenOfBloodRewardPopView:OnItemMoveIn(itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scrollView:AddComponent(UIOffSeason1QueenOfBloodRewardItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  local data = self.showDatalist[index]
  item:ReInit(OffSeason1TaskGroup.QueenOfBlood, data.id, data)
end

function UIQueenOfBloodRewardPopView:OnItemMoveOut(itemObj, index)
end

function UIQueenOfBloodRewardPopView:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UIOffSeason1QueenOfBloodRewardItem)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.showDatalist = {}
end

function UIQueenOfBloodRewardPopView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UIQueenOfBloodRewardPopView:Refresh()
  self:RefreshTaskData()
  if self.showDatalist and #self.showDatalist > 0 then
    self.scrollView:SetActive(true)
    self.scrollView:SetTotalCount(#self.showDatalist)
    self.scrollView:RefillCells()
  else
    self.scrollView:SetActive(false)
  end
  self:RefreshGetAllBtn()
end

function UIQueenOfBloodRewardPopView:RefreshTaskData()
  local taskList = DataCenter.OffSeason1TaskDataManager:GetActivityTaskList(tonumber(OffSeason1TaskGroup.QueenOfBlood))
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

function UIQueenOfBloodRewardPopView:OnClickGetAll()
  SFSNetwork.SendMessage(MsgDefines.CityBattleActivityGainTaskReward, tonumber(OffSeason1TaskGroup.QueenOfBlood), -1)
end

function UIQueenOfBloodRewardPopView:RefreshGetAllBtn()
  local isGray = true
  if self.showDatalist then
    for i, v in ipairs(self.showDatalist) do
      if v.state == TaskState.CanReceive then
        isGray = false
        break
      end
    end
  end
  CS.UIGray.SetGray(self.btnGetAll.transform, isGray, not isGray)
end

return UIQueenOfBloodRewardPopView
