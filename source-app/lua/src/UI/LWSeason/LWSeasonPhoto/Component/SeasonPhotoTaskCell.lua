local base = UIBaseContainer
local SeasonPhotoTaskCell = BaseClass("SeasonPhotoTaskCell", base)
local UIGray = CS.UIGray
local TextName_path = "NameText"
local Content_path = "ScrollView/Viewport/RewardContent"
local Item_path = "ScrollView/Viewport/RewardContent/UICommonResItem"
local GoBtn_path = "GoBtn"
local BtnText_path = "GoBtn/BtnText"
local RedPoint_path = "GoBtn/RedPoint"
local Finished_path = "finish"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
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
  self.TextName = self:AddComponent(UIText, TextName_path)
  self.Content = self:AddComponent(UIBaseContainer, Content_path)
  self.Item = self:AddComponent(UIBaseContainer, Item_path)
  self.GoBtn = self:AddComponent(UIButton, GoBtn_path)
  self.BtnText = self:AddComponent(UIText, BtnText_path)
  self.RedPoint = self:AddComponent(UIBaseContainer, RedPoint_path)
  self.Finished = self:AddComponent(UIBaseContainer, Finished_path)
  self.canvas = self:AddComponent(UICanvasGroup, "")
  self.GoBtn:SetOnClick(BindCallback(self, self.OnClickGet))
  self.ItemObj = self.Item.gameObject
  self.ItemObj:GameObjectCreatePool()
  self.ItemObj:SetActive(false)
end

local function ComponentDestroy(self)
  self.Content:RemoveComponents(UICommonResItem)
  self.ItemObj:GameObjectRecycleAll()
  self.TextName = nil
  self.Content = nil
  self.Item = nil
  self.GoBtn = nil
  self.BtnText = nil
  self.RedPoint = nil
  self.Finished = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function SeasonPhotoTaskCell:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonPhotoTaskUpdate, self.SeasonPhotoTaskUpdate)
end

function SeasonPhotoTaskCell:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonPhotoTaskUpdate, self.SeasonPhotoTaskUpdate)
  base.OnRemoveListener(self)
end

function SeasonPhotoTaskCell:ReInit(index, data, activityId)
  self.index = index
  self.activityId = activityId
  self.data = data
  if not self.data then
    return
  end
  self:RefreshState(self.data.state)
  self:RefreshReward(self.data.reward)
  local taskConfig = DataCenter.SeasonPhotoTemplateManager:GetConfigDataTask(self.data.taskId)
  if taskConfig then
    self.TextName:SetLocalText(taskConfig.name, taskConfig.needNum)
  end
end

function SeasonPhotoTaskCell:RefreshState(taskState)
  if not self.data then
    return
  end
  if taskState == TaskState.Received then
    self.GoBtn:SetActive(false)
    self.Finished:SetActive(true)
    self.RedPoint:SetActive(false)
  elseif taskState == TaskState.CanReceive then
    self.GoBtn:SetActive(true)
    self.Finished:SetActive(false)
    UIGray.SetGray(self.GoBtn.transform, false, true)
    self.BtnText:SetLocalText("457010")
    self.RedPoint:SetActive(true)
  else
    self.RedPoint:SetActive(false)
    self.BtnText:SetLocalText("2000226")
    self.GoBtn:SetActive(true)
    self.Finished:SetActive(false)
    UIGray.SetGray(self.GoBtn.transform, true, false)
  end
end

function SeasonPhotoTaskCell:RefreshReward(rewardList)
  self.Content:RemoveComponents(UICommonResItem)
  self.ItemObj:GameObjectRecycleAll()
  if not rewardList then
    return
  end
  for i, v in ipairs(rewardList) do
    local theItem = self.ItemObj:GameObjectSpawn(self.Content.transform)
    theItem.name = string.format("Item_%d", i)
    theItem = self.Content:AddComponent(UICommonResItem, theItem.name)
    theItem:ReInit(v)
    theItem:SetActive(true)
  end
end

function SeasonPhotoTaskCell:ShowFadeInEffect()
  self.tweenSeq = UIUtil.ShowListItemAnim(self, self.index, self.canvas)
end

function SeasonPhotoTaskCell:OnClickGet()
  if not self.data then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.SeasonPhotoTaskGetReward, self.activityId, self.data.taskId)
end

function SeasonPhotoTaskCell:SeasonPhotoTaskUpdate(photoTaskInfo)
  if photoTaskInfo and photoTaskInfo.taskId == self.data.taskId then
    self.data = photoTaskInfo
    self:RefreshState(photoTaskInfo.state)
  end
end

SeasonPhotoTaskCell.OnCreate = OnCreate
SeasonPhotoTaskCell.OnDestroy = OnDestroy
SeasonPhotoTaskCell.OnEnable = OnEnable
SeasonPhotoTaskCell.OnDisable = OnDisable
SeasonPhotoTaskCell.ComponentDefine = ComponentDefine
SeasonPhotoTaskCell.ComponentDestroy = ComponentDestroy
SeasonPhotoTaskCell.DataDefine = DataDefine
SeasonPhotoTaskCell.DataDestroy = DataDestroy
return SeasonPhotoTaskCell
