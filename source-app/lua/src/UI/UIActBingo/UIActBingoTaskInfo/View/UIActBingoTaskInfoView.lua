local UIActBingoTaskInfoView = BaseClass("UIActBingoTaskInfoView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "panel"
local close_btn_path = "panel/bg/CloseBtn"
local tip_text_path = "panel/bg/TipText"
local content_path = "panel/bg/rewardContent/ScrollView/Viewport/Content"
local go_btn_path = "panel/bg/GoBtn"
local receive_btn_path = "panel/bg/ReceiveBtn"
local num_text_path = "panel/bg/TipText/NumText"
local goto_tip_path = "panel/bg/gotoTip"

local function OnCreate(self)
  base.OnCreate(self)
  self.param = self:GetUserData()
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

local function OnDestroy(self)
  self:ClearContent()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.ActBingoTaskDataUpdate, self.RefreshView)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.ActBingoTaskDataUpdate, self.RefreshView)
end

local function ComponentDefine(self)
  self.panel = self:AddComponent(UIButton, panel_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.tip_text = self:AddComponent(UITextMeshProUGUIEx, tip_text_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.go_btn = self:AddComponent(UIButton, go_btn_path)
  self.receive_btn = self:AddComponent(UIButton, receive_btn_path)
  self.num_text = self:AddComponent(UITextMeshProUGUIEx, num_text_path)
  self.goto_tip = self:AddComponent(UITextMeshProUGUIEx, goto_tip_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.go_btn:SetOnClick(function()
    self:OnGoClick()
  end)
  self.receive_btn:SetOnClick(function()
    self:OnReceiveClick()
  end)
  self.itemReqs = {}
  self.itemList = {}
end

local function ComponentDestroy(self)
  self.panel = nil
  self.close_btn = nil
  self.tip_text = nil
  self.content = nil
  self.go_btn = nil
  self.receive_btn = nil
  self.num_text = nil
  self.goto_tip = nil
  self.itemReqs = nil
  self.itemList = nil
end

local function DataDefine(self)
  self.activityId = self.param.activityId
  self.taskData = self.param.taskData
  local taskId = self.taskData.taskId
  self.taskInfo = DataCenter.ActivityTaskTemplateManager:GetActTaskTemplate(taskId)
  self.index = self.param.index
  self.activityDetailData = self.param.activityDetailData
end

local function DataDestroy(self)
  self.param = nil
  self.activityId = nil
  self.taskData = nil
  self.taskInfo = nil
  self.index = nil
  self.activityDetailData = nil
end

local function ClearContent(self)
  if table.count(self.itemList) > 0 then
    self.content:RemoveComponents(UICommonResItem)
    self.itemList = {}
  end
  if table.count(self.itemReqs) then
    for _, req in pairs(self.itemReqs) do
      req:Destroy()
    end
    self.itemReqs = {}
  end
end

local function RefreshView(self)
  local taskDesc = self.taskInfo:GetDesc(true)
  local process = ""
  local curNum = self.taskData.num and self.taskData.num or 0
  local targetNum = self.taskInfo.para2
  if 0 <= curNum - targetNum then
    curNum = targetNum
  end
  curNum = string.GetFormattedSeperatorNum(curNum)
  targetNum = string.GetFormattedSeperatorNum(targetNum)
  process = curNum .. "/" .. targetNum
  self.tip_text:SetText(taskDesc)
  self.num_text:SetText(process)
  local showList = DataCenter.RewardManager:ReturnRewardParamForView(self.taskData.reward)
  self:RefreshReward(showList)
  local state = self.taskData.state
  if state == TaskState.Received then
    self.goto_tip:SetActive(false)
    self.go_btn:SetActive(false)
    self.receive_btn:SetActive(false)
    self.ctrl:CloseSelf()
  elseif state == TaskState.CanReceive then
    self.goto_tip:SetActive(false)
    self.go_btn:SetActive(false)
    self.receive_btn:SetActive(true)
  elseif state == TaskState.NoComplete then
    local goType = tonumber(self.taskInfo.gotype2)
    if goType then
      self.goto_tip:SetActive(false)
      self.go_btn:SetActive(true)
    else
      self.goto_tip:SetActive(true)
      self.go_btn:SetActive(false)
    end
    self.receive_btn:SetActive(false)
  end
end

local function RefreshReward(self, rewardList)
  self:ClearContent()
  if not table.IsNullOrEmpty(rewardList) then
    for i, data in pairs(rewardList) do
      local req = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
        if req == nil or IsNull(req.gameObject) then
          return
        end
        local item = req.gameObject
        item.name = "reward_item" .. i
        item:SetActive(true)
        item.transform:SetParent(self.content.transform)
        item.transform:Set_localScale(1, 1, 1)
        item.transform:Set_sizeDelta(118, 118)
        item.transform:Set_pivot(0.5, 0.5)
        local cell = self.content:AddComponent(UICommonResItem, item.name)
        cell:ReInit(data)
        table.insert(self.itemList, cell)
      end)
      table.insert(self.itemReqs, req)
    end
  end
end

local function OnGoClick(self)
  if self.taskInfo then
    GoToUtil.GoToByQuestId(self.taskInfo)
  end
end

local function OnReceiveClick(self)
  SFSNetwork.SendMessage(MsgDefines.BingoTaskReward, tonumber(self.activityId), tostring(self.taskData.taskId))
end

UIActBingoTaskInfoView.OnCreate = OnCreate
UIActBingoTaskInfoView.OnDestroy = OnDestroy
UIActBingoTaskInfoView.OnAddListener = OnAddListener
UIActBingoTaskInfoView.OnRemoveListener = OnRemoveListener
UIActBingoTaskInfoView.ComponentDefine = ComponentDefine
UIActBingoTaskInfoView.ComponentDestroy = ComponentDestroy
UIActBingoTaskInfoView.DataDefine = DataDefine
UIActBingoTaskInfoView.DataDestroy = DataDestroy
UIActBingoTaskInfoView.ClearContent = ClearContent
UIActBingoTaskInfoView.RefreshView = RefreshView
UIActBingoTaskInfoView.OnGoClick = OnGoClick
UIActBingoTaskInfoView.OnReceiveClick = OnReceiveClick
UIActBingoTaskInfoView.RefreshReward = RefreshReward
return UIActBingoTaskInfoView
