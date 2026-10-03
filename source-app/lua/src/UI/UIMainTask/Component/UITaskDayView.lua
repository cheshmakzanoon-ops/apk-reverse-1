local UITaskDayView = BaseClass("UITaskDayView", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIDailyCell = require("UI.UIMainTask.Component.UIDailyCell")
local UIBox = require("UI.UIMainTask.Component.UIBox")

function UITaskDayView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:ReInitScroll()
end

function UITaskDayView:OnDestroy()
  self.content:SetAnchoredPosition(Vector2.New(0, 0))
  self.content:Dispose()
  self:SetAllCellsDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UITaskDayView:OnEnable()
  base.OnEnable(self)
end

function UITaskDayView:OnDisable()
  base.OnDisable(self)
  self.define = false
end

function UITaskDayView:ComponentDefine()
  self.slider1 = self:AddComponent(UISlider, "HaveTask/SliderBg/Slider1")
  self.slider2 = self:AddComponent(UISlider, "HaveTask/SliderBg/Slider2")
  self.slider3 = self:AddComponent(UISlider, "HaveTask/SliderBg/Slider3")
  self.slider4 = self:AddComponent(UISlider, "HaveTask/SliderBg/Slider4")
  self.slider5 = self:AddComponent(UISlider, "HaveTask/SliderBg/Slider5")
  self.active_text = self:AddComponent(UIText, "HaveTask/ActiveBg/ActiveText")
  self.active_value = self:AddComponent(UIText, "HaveTask/ActiveBg/ActiveText/ActiveValue")
  self.time_text = self:AddComponent(UIText, "HaveTask/TimeBg/TimeText")
  self.box = {}
  table.insert(self.box, self:AddComponent(UIBox, "HaveTask/SliderBg/BoxGo/Box1"))
  table.insert(self.box, self:AddComponent(UIBox, "HaveTask/SliderBg/BoxGo/Box2"))
  table.insert(self.box, self:AddComponent(UIBox, "HaveTask/SliderBg/BoxGo/Box3"))
  table.insert(self.box, self:AddComponent(UIBox, "HaveTask/SliderBg/BoxGo/Box4"))
  table.insert(self.box, self:AddComponent(UIBox, "HaveTask/SliderBg/BoxGo/Box5"))
  self.scroll_view = self:AddComponent(UIBaseContainer, "HaveTask/ScrollView")
  self.content = self:AddComponent(GridInfinityScrollView, "HaveTask/ScrollView/Content")
  self.gray_material = self:AddComponent(UIImage, "CellGo/GrayImage")
  self.gray = self.gray_material:GetMaterial()
  self.no_task_text = self:AddComponent(UIText, "NoTask/NoTaskTxt")
  self.no_task = self:AddComponent(UIText, "NoTask")
  self.have_task_go = self:AddComponent(UIBaseContainer, "HaveTask")
  self.define = true
end

function UITaskDayView:ComponentDestroy()
  self.slider1 = nil
  self.slider2 = nil
  self.slider3 = nil
  self.slider4 = nil
  self.slider5 = nil
  self.active_text = nil
  self.active_value = nil
  self.time_text = nil
  self.box = nil
  self.scroll_view = nil
  self.gray_material = nil
  self.gray = nil
  self.no_task = nil
  self.no_task_text = nil
  self.have_task_go = nil
  self.define = nil
  self.content = nil
end

function UITaskDayView:DataDefine()
  self.define = false
  self.curActiveValue = 0
  self.deleteIndex = 0
  self.list = {}
  self.timer = nil
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
  
  self.listGO = {}
  self.isTween = false
end

function UITaskDayView:DataDestroy()
  self.define = nil
  self.curActiveValue = nil
  self.deleteIndex = nil
  self.box = nil
  self.list = nil
  self.timer_action = nil
  self.dailyvalue = nil
  self.isTween = nil
  self:DeleteTimer()
end

function UITaskDayView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DailyQuestLs, self.ReInit)
end

function UITaskDayView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.DailyQuestLs, self.ReInit)
end

function UITaskDayView:ReInitScroll()
  self:SetAllCellsDestroy()
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.content:Init(bindFunc1, bindFunc2, bindFunc3)
end

function UITaskDayView:ReInit()
  self.active_text:SetLocalText(100105)
  self:AddTimer()
  self.dailyvalue = {}
  for i = 1, 5 do
    table.insert(self.dailyvalue, DataCenter.DailyTaskManager:GetDailyCurValue(i))
  end
  self:RefreshPanel()
  self:ShowCells()
end

function UITaskDayView:OnInitScroll(go, index)
  local item = self.scroll_view:AddComponent(UIDailyCell, go)
  self.listGO[go] = item
end

function UITaskDayView:OnUpdateScroll(go, index)
  local sub = self.list[index + 1]
  local cellItem = self.listGO[go]
  if sub == nil or cellItem == nil then
    return
  end
  local param = UIDailyCell.Param.New()
  param.id = sub.id
  param.time = math.modf(sub.num / sub.totalNum)
  param.allTime = sub.totalTimes
  param.totalNum = sub.totalNum
  param.state = sub.state
  param.reward = sub.reward
  param.index = index + 1
  param.num = sub.num
  param.flyPos = self.gameObject.transform:Find("HaveTask/ActiveBg/Image")
  
  function param.callBack(tempIndex)
    self:OnClickCallBack(tempIndex)
  end
  
  cellItem:ReInit(param)
  cellItem:SetActive(true)
end

function UITaskDayView:OnDestroyScrollItem(go, index)
end

function UITaskDayView:RefreshActive()
  self.curActiveValue = DataCenter.DailyTaskManager:GetCurValue()
  self.active_value:SetText(self.curActiveValue)
  if self.curActiveValue <= self.dailyvalue[1] then
    self.slider1:SetValue(self.curActiveValue / self.dailyvalue[1])
    self.slider2:SetValue(0)
    self.slider3:SetValue(0)
    self.slider4:SetValue(0)
    self.slider5:SetValue(0)
  elseif self.curActiveValue > self.dailyvalue[1] and self.curActiveValue <= self.dailyvalue[2] then
    self.slider1:SetValue(1)
    self.slider2:SetValue((self.curActiveValue - self.dailyvalue[1]) / (self.dailyvalue[2] - self.dailyvalue[1]))
    self.slider3:SetValue(0)
    self.slider4:SetValue(0)
    self.slider5:SetValue(0)
  elseif self.curActiveValue > self.dailyvalue[2] and self.curActiveValue <= self.dailyvalue[3] then
    self.slider1:SetValue(1)
    self.slider2:SetValue(1)
    self.slider3:SetValue((self.curActiveValue - self.dailyvalue[2]) / (self.dailyvalue[3] - self.dailyvalue[2]))
    self.slider4:SetValue(0)
    self.slider5:SetValue(0)
  elseif self.curActiveValue > self.dailyvalue[3] and self.curActiveValue <= self.dailyvalue[4] then
    self.slider1:SetValue(1)
    self.slider2:SetValue(1)
    self.slider3:SetValue(1)
    self.slider4:SetValue((self.curActiveValue - self.dailyvalue[3]) / (self.dailyvalue[4] - self.dailyvalue[3]))
    self.slider5:SetValue(0)
  elseif self.curActiveValue > self.dailyvalue[4] and self.curActiveValue <= self.dailyvalue[5] then
    self.slider1:SetValue(1)
    self.slider2:SetValue(1)
    self.slider3:SetValue(1)
    self.slider4:SetValue(1)
    self.slider5:SetValue((self.curActiveValue - self.dailyvalue[4]) / (self.dailyvalue[5] - self.dailyvalue[4]))
  elseif self.curActiveValue > self.dailyvalue[5] then
    self.slider1:SetValue(1)
    self.slider2:SetValue(1)
    self.slider3:SetValue(1)
    self.slider4:SetValue(1)
    self.slider5:SetValue(1)
  end
end

function UITaskDayView:RefreshBoxState()
  for k, v in ipairs(self.box) do
    local state = DataCenter.DailyTaskManager:GetBoxState(k, self.curActiveValue)
    v:RefreshState(state)
  end
end

function UITaskDayView:BoxCallBack(index, position, width)
  local x = position.x
  local isLeft
  local y = position.y
  if index < 4 then
    isLeft = true
  elseif index == 4 then
    isLeft = false
  else
    isLeft = false
  end
  local list = DataCenter.DailyTaskManager:GetBoxRewardShow(self.box[index].param.count)
  local state = DataCenter.DailyTaskManager:GetBoxState(index, self.curActiveValue)
  local des
  if state == 2 then
    des = Localization:GetString("129065")
  else
    des = Localization:GetString("120186", self.dailyvalue[index])
  end
  local offset = 146
  if list ~= nil and table.count(list) > 0 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityRewardTip, des, nil, x, y, isLeft, self.box[index].param.count, width, offset)
    return
  end
end

function UITaskDayView:InitBox()
  for k, v in ipairs(self.box) do
    local param = {}
    
    function param.callBack(index, position, width)
      self:BoxCallBack(index, position, width)
    end
    
    param.index = k
    param.state = DataCenter.DailyTaskManager:GetBoxState(k, self.curActiveValue)
    param.count = self.dailyvalue[k]
    v:ReInit(param)
  end
end

function UITaskDayView:SetAllCellsDestroy()
  self.scroll_view:RemoveComponents(UIDailyCell)
  self.content:DestroyChildNode()
end

function UITaskDayView:ShowCells()
  self.list = DataCenter.DailyTaskManager:GetSortDailyTask()
  local tempCount = table.count(self.list)
  if 0 < tempCount then
    self.scroll_view:SetActive(true)
    self.no_task:SetActive(false)
    self.content:SetItemCount(tempCount)
  else
    self.scroll_view:SetActive(false)
    self.no_task:SetActive(true)
    self.no_task_text:SetLocalText(129092)
  end
end

function UITaskDayView:RefreshPanel()
  self:RefreshActive()
  self:InitBox()
  self:RefreshTime()
end

function UITaskDayView:ForceUpdate()
  self.list = DataCenter.DailyTaskManager:GetSortDailyTask()
  if self.list ~= nil and not next(self.list) then
    self.scroll_view:SetActive(false)
    self.no_task:SetActive(true)
    self.no_task_text:SetLocalText(129092)
    return
  end
  self:AddAnimatorTimer()
end

function UITaskDayView:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function UITaskDayView:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

function UITaskDayView:RefreshTime()
  local resTime = UITimeManager:GetInstance():GetResSecondsTo24()
  if resTime == 0 then
    self.view.ctrl:CloseSelf()
  else
    self.time_text:SetText(UITimeManager:GetInstance():SecondToFmtString(resTime))
  end
end

function UITaskDayView:OnClickCallBack(index)
  self.deleteIndex = index
  self.isTween = true
end

function UITaskDayView:AddAnimatorTimer()
  self.content:LaterItemByIndex(self.deleteIndex, 0.3)
end

function UITaskDayView:DoQuestShowAnimation()
  for i, v in pairs(self.listGO) do
    self.listGO[i]:ResetDoTweens()
  end
  self.content:Remark(#self.list)
  self:DeleteMoveTimer()
end

function UITaskDayView:DeleteMoveTimer()
  self.animatorIndex = 1
  self.deleteIndex = 0
  self.isTween = false
end

function UITaskDayView:IsTween()
  return self.isTween
end

return UITaskDayView
