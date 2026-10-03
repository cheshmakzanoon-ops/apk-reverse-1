local UIOffSeason1RecaptureRewardView = BaseClass("UIOffSeason1RecaptureRewardView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UIOffSeason1RecaptureRewardItem = require("UI.LWOffSeason1.RecaptureReward.Component.UIOffSeason1RecaptureRewardItem")
local panel_path = "panel"
local dialog_title_text_path = "PopUpTitle/Common_img_title/titleText"
local close_btn_path = "PopUpTitle/CloseBtn"
local reward_item_path = "PopUpTitle/Common_bg_orange2/RewardItem"
local cell_path = "PopUpTitle/Common_bg_orange2/cell"
local content_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content"

function UIOffSeason1RecaptureRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.activityId = DataCenter.OffSeason1RecaptureManager:GetActivityId()
  self:Refresh()
end

function UIOffSeason1RecaptureRewardView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIOffSeason1RecaptureRewardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.PushOffSeason1ActivityTaskInfoUpdate, self.Refresh)
end

function UIOffSeason1RecaptureRewardView:OnRemoveListener()
  self:RemoveUIListener(EventId.PushOffSeason1ActivityTaskInfoUpdate, self.Refresh)
  base.OnRemoveListener(self)
end

function UIOffSeason1RecaptureRewardView:ComponentDefine()
  self.dialog_title_text = self:AddComponent(UIText, dialog_title_text_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.dialog_title_text:SetLocalText("130065")
  self.close_btn:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.close_btn1 = self:AddComponent(UIButton, panel_path)
  self.close_btn1:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.scrollView = self:AddComponent(UIScrollView, "PopUpTitle/Common_bg_orange2/ScrollView")
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.scrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.btnGetAll = self:AddComponent(UIButton, "PopUpTitle/Common_bg_orange2/GetAllBtn")
  self.textGetAllBtn = self:AddComponent(UIText, "PopUpTitle/Common_bg_orange2/GetAllBtn/LW_Btn_Common_New_Base/GetAllBtnText")
  self.btnGetAll:SetOnClick(function()
    self:OnClickGetAll()
  end)
  self.textGetAllBtn:SetLocalText(2000444)
end

function UIOffSeason1RecaptureRewardView:ComponentDestroy()
  self:ClearScroll()
  self.btn_back = nil
  self.showDatalist = nil
  self.activityId = nil
  self.btnGetAll = nil
  self.textGetAllBtn = nil
end

function UIOffSeason1RecaptureRewardView:Refresh()
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

function UIOffSeason1RecaptureRewardView:OnItemMoveIn(itemObj, index)
  local item = self.scrollCellPool[itemObj.name]
  if not item then
    local name = tostring(self.itemIndex)
    itemObj.name = name
    item = self.scrollView:AddComponent(UIOffSeason1RecaptureRewardItem, itemObj)
    self.scrollCellPool[name] = item
    self.itemIndex = self.itemIndex + 1
  end
  local data = self.showDatalist[index]
  item:ReInit(OffSeason1TaskGroup.OffSeason1Recapture, data.id, data)
end

function UIOffSeason1RecaptureRewardView:OnItemMoveOut(itemObj, index)
end

function UIOffSeason1RecaptureRewardView:ClearScroll()
  self.scrollView:ClearCells()
  self.scrollView:RemoveComponents(UIOffSeason1RecaptureRewardItem)
  self.scrollCellPool = {}
  self.itemIndex = 1
  self.showDatalist = {}
end

function UIOffSeason1RecaptureRewardView:RefreshTaskData()
  local taskList = DataCenter.OffSeason1TaskDataManager:GetActivityTaskList(tonumber(OffSeason1TaskGroup.OffSeason1Recapture))
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

function UIOffSeason1RecaptureRewardView:OnClickGetAll()
  SFSNetwork.SendMessage(MsgDefines.CityBattleActivityGainTaskReward, tonumber(OffSeason1TaskGroup.OffSeason1Recapture), -1)
end

function UIOffSeason1RecaptureRewardView:RefreshGetAllBtn()
  local isGray = true
  if self.showDatalist then
    for i, v in ipairs(self.showDatalist) do
      if v.state == TaskState.CanReceive then
        isGray = false
        break
      end
    end
  end
  UIGray.SetGray(self.btnGetAll.transform, isGray, not isGray)
end

return UIOffSeason1RecaptureRewardView
