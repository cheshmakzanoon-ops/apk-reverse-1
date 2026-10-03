local base = UIBaseContainer
local TaskCellComponent = BaseClass("TaskCellComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local RewardUtil = require("Util.RewardUtil")
local UIGray = CS.UIGray

function TaskCellComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function TaskCellComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TaskCellComponent:ComponentDefine()
  self.textName = self:AddComponent(UITextMeshProUGUIEx, "NameText")
  self.imgFinish = self:AddComponent(UIImage, "finish")
  self.rewardContent = self:AddComponent(UIScrollRect, "ScrollView/Viewport/RewardContent")
  self.btnGo = self:AddComponent(UIButton, "GoBtn")
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.textBtn = self:AddComponent(UITextMeshProUGUIEx, "GoBtn/BtnText")
end

function TaskCellComponent:ComponentDestroy()
  self.textName = nil
  self.imgFinish = nil
  self.rewardContent = nil
  self.btnGo = nil
  self.textBtn = nil
end

function TaskCellComponent:DataDefine()
  self.itemList = {}
  self.itemReqs = {}
end

function TaskCellComponent:DataDestroy()
  self:ClearContent()
  self.itemList = nil
  self.itemReqs = nil
  self.taskInfo = nil
  self.taskId = nil
end

function TaskCellComponent:OnAddListener()
  base.OnAddListener(self)
end

function TaskCellComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function TaskCellComponent:OnBtnGoClick()
  SFSNetwork.SendMessage(MsgDefines.CityBattleActivityGainTaskReward, tonumber(self.groupId), tonumber(self.taskId))
end

function TaskCellComponent:ClearContent()
  if table.count(self.itemList) > 0 then
    self.rewardContent:RemoveComponents(UICommonResItem)
    self.itemList = nil
  end
  if 0 < table.count(self.itemReqs) then
    for _, req in pairs(self.itemReqs) do
      if req ~= nil then
        self:GameObjectDestroy(req)
      end
    end
    self.itemReqs = nil
  end
end

function TaskCellComponent:UpdateData(taskId, taskState)
  if self.taskInfo ~= nil and self.taskId == taskId then
    local tempType = {}
    EventManager:GetInstance():Broadcast(EventId.RefreshTopResByPickUp, tempType)
    for i, v in ipairs(self.taskInfo.reward) do
      local rewardType = v.rewardType
      local itemId = v.itemId
      local pic = RewardUtil.GetPic(v.rewardType, itemId)
      local img = self.showList[i].iconImg
      if pic ~= "" and not IsNull(img) then
        UIUtil.DoFly(tonumber(rewardType), 3, pic, img.transform.position, Vector3.New(0, 0, 0))
      end
    end
    self.taskInfo.state = taskState
    EventManager:GetInstance():Broadcast(EventId.OnClaimRewardEffFinish)
    self.btnGo:SetActive(false)
    self.imgFinish:SetActive(true)
  end
end

function TaskCellComponent:ReInit(groupId, taskId, taskInfo)
  self.groupId = groupId
  self.taskId = taskId
  self.taskInfo = taskInfo
  self:RefreshReward(taskInfo.reward)
  local desc = taskInfo.descStr
  if taskInfo.curNum and taskInfo.totalNum then
    desc = string.format("%s (%d/%d)", desc, taskInfo.curNum, taskInfo.totalNum)
  end
  self.textName:SetText(desc)
  local taskState = taskInfo.hasReward
  if taskState == TaskState.Received then
    self.btnGo:SetActive(false)
    self.imgFinish:SetActive(true)
  elseif taskState == TaskState.CanReceive then
    self.btnGo:SetActive(true)
    self.imgFinish:SetActive(false)
    self.textBtn:SetLocalText("457010")
    UIGray.SetGray(self.btnGo.transform, false, true)
  else
    self.btnGo:SetActive(true)
    self.imgFinish:SetActive(false)
    self.textBtn:SetLocalText("457010")
    UIGray.SetGray(self.btnGo.transform, true, false)
  end
end

function TaskCellComponent:RefreshReward(rewardList)
  self.showList = rewardList
  if rewardList == nil then
    for i = 1, #self.itemList do
      local go = self.itemGoList[i]
      if go then
        go:SetActive(false)
      end
    end
    return
  end
  local rewardCount = #rewardList
  local itemCount = #self.itemList
  local itemReqCount = #self.itemReqs
  local count = Mathf.Min(rewardCount, itemCount)
  for i = 1, count do
    local item = self.itemList[i]
    local data = rewardList[i]
    data.rewardType = data.type
    if type(data.value) == "number" then
      data.count = data.value
    else
      data.itemId = data.value.id
      data.count = data.value.num
    end
    item:ReInit(data)
    item.iconImg = item.transform:Find("clickBtn/ItemIcon")
    item:SetActive(true)
  end
  for i = count + 1, itemCount do
    local item = self.itemList[i]
    if item then
      item:SetActive(false)
    end
  end
  for i = itemReqCount + 1, rewardCount do
    self.itemReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
      if req.isError then
        return
      end
      local scale = 0.85
      local item = req.gameObject
      item.name = "item_" .. i
      item.transform:SetParent(self.rewardContent.transform)
      item.transform:Set_sizeDelta(84, 87)
      item.transform:Set_localScale(scale, scale, 1)
      local cell = self.rewardContent:AddComponent(UICommonResItem, item.name)
      self.itemList[i] = cell
      if self.showList == nil or self.showList[i] == nil then
        item:SetActive(false)
        return
      end
      local data = self.showList[i]
      data.rewardType = data.type
      if type(data.value) == "number" then
        data.count = data.value
      else
        data.itemId = data.value.id
        data.count = data.value.num
      end
      cell:SetActive(true)
      cell:ReInit(data)
      cell.iconImg = cell.transform:Find("clickBtn/ItemIcon")
    end)
  end
end

return TaskCellComponent
