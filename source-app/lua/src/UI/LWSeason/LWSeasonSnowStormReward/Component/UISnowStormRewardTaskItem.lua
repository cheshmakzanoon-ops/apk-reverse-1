local UISnowStormRewardTaskItem = BaseClass("UISnowStormRewardTaskItem", UIBaseContainer)
local base = UIBaseContainer
local RewardUtil = require("Util.RewardUtil")
local UIGray = CS.UIGray
local name_text_path = "NameText"
local reward_content_path = "ScrollView/Viewport/RewardContent"
local go_btn_path = "GoBtn"
local btn_text_path = "GoBtn/BtnText"
local finish_path = "finish"
local end_time_path = "endTime"
local red_point_path = "GoBtn/RedPoint"

function UISnowStormRewardTaskItem:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function UISnowStormRewardTaskItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UISnowStormRewardTaskItem:ComponentDefine()
  self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
  self.content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.go_btn = self:AddComponent(UIButton, go_btn_path)
  self.btn_text = self:AddComponent(UITextMeshProUGUIEx, btn_text_path)
  self.btn_text:SetLocalText("457010")
  self.finish = self:AddComponent(UIImage, finish_path)
  self.red_point = self:AddComponent(UIBaseContainer, red_point_path)
  self.red_point:SetActive(false)
  self.end_time = self:AddComponent(UITextMeshProUGUIEx, end_time_path)
  self.go_btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.end_time:SetText("")
  self.itemReqs = {}
  self.itemComps = {}
end

function UISnowStormRewardTaskItem:ComponentDestroy()
  self:RemoveRewards()
end

function UISnowStormRewardTaskItem:DataDefine()
  self.oldState = nil
  self.data = nil
end

function UISnowStormRewardTaskItem:DataDestroy()
  self.oldState = nil
  self.data = nil
end

function UISnowStormRewardTaskItem:OnEnable()
  base.OnEnable(self)
end

function UISnowStormRewardTaskItem:OnDisable()
  base.OnDisable(self)
end

function UISnowStormRewardTaskItem:RemoveRewards()
  self.content:RemoveComponents(UICommonResItem)
  self.itemComps = {}
  if self.itemReqs then
    for _, req in ipairs(self.itemReqs) do
      req:Destroy()
    end
  end
  self.itemReqs = {}
end

function UISnowStormRewardTaskItem:Refresh()
  local taskState = self.data.state
  if taskState == TaskState.Received then
    self.go_btn:SetActive(false)
    self.finish:SetActive(true)
    self.red_point:SetActive(false)
  elseif taskState == TaskState.CanReceive then
    self.go_btn:SetActive(true)
    self.finish:SetActive(false)
    UIGray.SetGray(self.go_btn.transform, false, true)
    self.btn_text:SetLocalText("457010")
    self.red_point:SetActive(true)
  else
    self.red_point:SetActive(false)
    if self.data.reason == 1 then
      self.btn_text:SetLocalText("2000226")
    else
      self.btn_text:SetLocalText("457010")
    end
    self.go_btn:SetActive(true)
    self.finish:SetActive(false)
    UIGray.SetGray(self.go_btn.transform, true, false)
  end
  self.oldState = taskState
end

function UISnowStormRewardTaskItem:ReInit(taskData, panelType, tabType)
  if taskData == nil then
    return
  end
  self.panelType = panelType
  self.tabType = tabType
  self.data = taskData
  self.name_text:SetText(self.data.title)
  self:Refresh()
  if self.data.endTime then
    self.end_time:SetText(UITimeManager:GetInstance():TimeStampToTimeForLocal(self.data.endTime))
  else
    self.end_time:SetText("")
  end
  local rewardList = taskData.rewardShow or {}
  if #self.itemComps == #rewardList then
    for i = 1, #rewardList do
      local data = rewardList[i]
      self.itemComps[i]:ReInit(data)
    end
    return
  end
  self:RemoveRewards()
  if #rewardList == 0 then
    return
  end
  for i = 1, #rewardList do
    self.itemReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
      if IsNull(req.gameObject) then
        return
      end
      local go = req.gameObject
      local transform = go.transform
      go:SetActive(true)
      transform:SetParent(self.content.transform)
      transform:Set_localScale(0.7, 0.7, 1)
      transform:Set_sizeDelta(150, 150)
      transform:Set_pivot(0, 1)
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      local cell = self.content:AddComponent(UICommonResItem, nameStr)
      local data = rewardList[i]
      cell:ReInit(data)
      self.itemComps[i] = cell
    end)
  end
end

function UISnowStormRewardTaskItem:OnBtnClick()
  local taskState = self.data.state
  if taskState == TaskState.NoComplete then
  elseif taskState == TaskState.CanReceive and (DataCenter.SeasonSnowStormDataManager.curActivity or self.panelType == UIActSnowStormRewardPanelType.NuclearBuilding) then
    self.view.ctrl:SendGetRewardMessage(self.panelType, self.tabType, self.data.configId)
  end
end

return UISnowStormRewardTaskItem
