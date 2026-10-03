local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local TaskActivity = BaseClass("TaskActivity", base)
local Localization = CS.GameEntry.Localization
local TaskActivityItem = require("UI.UIActivityCenterTable.Component.Task.TaskActivityItem")
local intro_btn_path = "rect/ActivityTopGo/IntroBtn"
local txt_act_name_path = "rect/ActivityTopGo/Txt_ActName"
local txt_act_extra_path = "rect/ActivityTopGo/Txt_ActExtra"
local openTime_path = "rect/ActivityTopGo/TimeBg/openTime"
local banner_path = "rect/RawImage"
local scroll_view_path = "rect/CenterGo/Scroll View"
local jumpBtn_path = "rect/ActivityTopGo/jumpBtn"

function TaskActivity:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function TaskActivity:ComponentDefine()
  self.intro_btn = self:AddComponent(UIButton, intro_btn_path)
  self.intro_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ClickTip()
  end)
  self.txt_act_name = self:AddComponent(UIText, txt_act_name_path)
  self.txt_act_extra = self:AddComponent(UIText, txt_act_extra_path)
  self.openTime = self:AddComponent(UIText, openTime_path)
  self.banner = self:AddComponent(UIRawImage, banner_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.jumpBtn = self:AddComponent(UIButton, jumpBtn_path)
  self.jumpBtn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    if self.data and self.data:GetFirstActiveJumpTo() > 0 then
      GoToUtil.GoActWindow({
        self.data:GetFirstActiveJumpTo()
      }, false)
    end
  end)
  self.jumpBtn:SetActive(false)
end

function TaskActivity:ComponentDestroy()
  self.intro_btn = nil
  self.txt_act_name = nil
  self.txt_act_extra = nil
  self.openTime = nil
  self.scroll_view = nil
end

function TaskActivity:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TaskActivity:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshActivityDetailData, self.RefreshView)
  self:AddUIListener(EventId.MainTaskSuccess, self.RefreshView)
  self:AddUIListener(EventId.ReceiveQuestReward, self.OnReceiveQuestReward)
end

function TaskActivity:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshActivityDetailData, self.RefreshView)
  self:RemoveUIListener(EventId.MainTaskSuccess, self.RefreshView)
  self:RemoveUIListener(EventId.ReceiveQuestReward, self.OnReceiveQuestReward)
  base.OnRemoveListener(self)
end

function TaskActivity:SetData(activityId)
  base.SetData(self, activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.data = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.data == nil then
    return
  end
  self:RefreshView()
  local packingParams = {
    activityId = self.activityId,
    isShowItemTopBar = false
  }
  EventManager:GetInstance():Broadcast(EventId.ActivityCommonGroupView_FestivalPackagingModify, packingParams)
end

function TaskActivity:SetBannerImg()
  if not string.IsNullOrEmpty(self.data.activity_pic) then
    self.banner:LoadSprite(string.format(LoadPath.ActivityTaskActivityBannerPath, self.data.activity_pic))
  end
end

function TaskActivity:ClickTip()
  if self.data ~= nil and self.data.story ~= nil then
    local param = {}
    param.activityId = self.activityId
    param.activityRulesStr = Localization:GetString(self.data.story)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function TaskActivity:ClearScroll()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(TaskActivityItem)
  self.showDatalist = {}
end

function TaskActivity:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(TaskActivityItem, itemObj)
  cellItem:SetData(self.showDatalist[index])
end

function TaskActivity:OnItemMoveOut(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, TaskActivityItem)
end

function TaskActivity:OnReceiveQuestReward(message)
  if message then
    DataCenter.RewardManager:ShowCommonReward(message)
  end
end

function TaskActivity:RefreshView()
  if not self.activityId then
    return
  end
  if self.data == nil then
    return
  end
  EventManager:GetInstance():BroadcastDeferred(EventId.RefreshActivityRedDot)
  self.actDetailInfo = DataCenter.ActivityListDataManager:GetActEventInfo(self.activityId)
  self:ClearScroll()
  self.txt_act_name:SetLocalText(self.data.name)
  self.txt_act_extra:SetLocalText(self.data.bannerTittle)
  self.scroll_view:SetActive(true)
  self.showDatalist = self.actDetailInfo:GetStageQuests(1)
  if type(self.showDatalist) == "table" then
    table.sort(self.showDatalist, function(a, b)
      local aTaskState = DataCenter.TaskManager:FindTaskInfo(a).state
      local bTaskState = DataCenter.TaskManager:FindTaskInfo(b).state
      if aTaskState == bTaskState then
        return a < b
      end
      if aTaskState == TaskState.CanReceive or bTaskState == TaskState.CanReceive then
        return aTaskState == TaskState.CanReceive
      elseif aTaskState == TaskState.Received or bTaskState == TaskState.Received then
        return bTaskState == TaskState.Received
      end
    end)
  end
  if #self.showDatalist > 0 then
    self.scroll_view:SetTotalCount(#self.showDatalist)
    self.scroll_view:RefillCells()
  else
    self.scroll_view:SetActive(false)
  end
  self:Update1000MS()
  self:SetBannerImg()
  self.jumpBtn:SetActive(self.data ~= nil and 0 < self.data:GetFirstActiveJumpTo())
end

function TaskActivity:Update1000MS()
  if not self.activityId then
    return
  end
  if self.data == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local endTime = self.data.endTime
  local remainTime = endTime - curTime
  if 0 < remainTime then
    self.openTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self.openTime:SetText("")
  end
end

function TaskActivity.GetEventCanRewardCount(id)
  local num = 0
  local actDetailInfo = DataCenter.ActivityListDataManager:GetActEventInfo(id)
  if actDetailInfo then
    local showDatalist = actDetailInfo:GetStageQuests(1)
    if showDatalist and 0 < #showDatalist then
      for k, v in pairs(showDatalist) do
        local taskId = v
        local taskValue = DataCenter.TaskManager:FindTaskInfo(taskId)
        if taskValue and taskValue.state == TaskState.CanReceive then
          num = num + 1
        end
      end
    end
  end
  return num
end

return TaskActivity
