local base = UIBaseContainer
local UIOffSeason1TaskCell = BaseClass("UIOffSeason1TaskCell", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local RewardUtil = require("Util.RewardUtil")
local UIGray = CS.UIGray

function UIOffSeason1TaskCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIOffSeason1TaskCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIOffSeason1TaskCell:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compFinishImg = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compRewardContent = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.btnGo = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnGo:SetOnClick(function()
    self:OnBtnGoClick()
  end)
  self.textBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.btnGo:SetSafeClickMode(true)
end

function UIOffSeason1TaskCell:ComponentDestroy()
  self.viewSkin = nil
  self.compFinishImg = nil
  self.textName = nil
  self.compRewardContent = nil
  self.btnGo = nil
  self.textBtn = nil
end

function UIOffSeason1TaskCell:DataDefine()
  self.itemList = {}
  self.itemReqs = {}
end

function UIOffSeason1TaskCell:DataDestroy()
  self:ClearContent()
  self.itemList = nil
  self.itemReqs = nil
  self.taskInfo = nil
  self.taskId = nil
end

function UIOffSeason1TaskCell:OnAddListener()
  base.OnAddListener(self)
end

function UIOffSeason1TaskCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIOffSeason1TaskCell:OnBtnGoClick()
  if self.taskInfo then
    local taskState = self.taskInfo.hasReward
    if taskState == TaskState.CanReceive then
      SFSNetwork.SendMessage(MsgDefines.CityBattleActivityGainTaskReward, tonumber(self.groupId), tonumber(self.taskId))
      local rewardPos = self.btnGo.transform.position
      local pic = OffSeason1TaskGroupIconPath[self.groupId]
      if not string.IsNullOrEmpty(pic) then
        local dstPos = self.view:GetFlyTargetPos()
        UIUtil.DoFly(nil, 3, pic, rewardPos, dstPos, nil, nil, nil, nil, 1)
      end
    end
  end
end

function UIOffSeason1TaskCell:ClearContent()
  if table.count(self.itemList) > 0 then
    self.compRewardContent:RemoveComponents(UICommonResItem)
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

function UIOffSeason1TaskCell:ReInit(groupId, taskId, taskInfo)
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
    self.compFinishImg:SetActive(true)
  elseif taskState == TaskState.CanReceive then
    self.btnGo:SetActive(true)
    self.compFinishImg:SetActive(false)
    self.textBtn:SetLocalText("457010")
    UIGray.SetGray(self.btnGo.transform, false, true)
  else
    self.btnGo:SetActive(true)
    self.compFinishImg:SetActive(false)
    self.textBtn:SetLocalText("457010")
    UIGray.SetGray(self.btnGo.transform, true, false)
  end
end

function UIOffSeason1TaskCell:RefreshReward(rewardList)
  self.showList = rewardList
  if rewardList == nil then
    for i = 1, #self.itemList do
      local go = self.itemList[i]
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
      item.transform:SetParent(self.compRewardContent.transform)
      item.transform:Set_sizeDelta(84, 87)
      item.transform:Set_localScale(scale, scale, 1)
      local cell = self.compRewardContent:AddComponent(UICommonResItem, item.name)
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

return UIOffSeason1TaskCell
