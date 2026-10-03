local UIOffSeason1RecaptureRewardItem = BaseClass("UIOffSeason1RecaptureRewardItem", UIBaseContainer)
local base = UIBaseContainer
local RewardUtil = require("Util.RewardUtil")
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local name_text_path = "NormalContent/NameText"
local reward_content_path = "NormalContent/ScrollView/Viewport/RewardContent"
local go_btn_path = "NormalContent/GoBtn"
local btn_text_path = "NormalContent/GoBtn/BtnText"
local finish_path = "NormalContent/finish"
local normal_content_path = "NormalContent"
local lock_content_path = "LockContent"
local cut_down_time_text_path = "LockContent/CutDownTimeText"

function UIOffSeason1RecaptureRewardItem:OnCreate()
  base.OnCreate(self)
  self.image = self:AddComponent(UIImage, "")
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.go_btn = self:AddComponent(UIButton, go_btn_path)
  self.btn_text = self:AddComponent(UIText, btn_text_path)
  self.finish = self:AddComponent(UIImage, finish_path)
  self.go_btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.normal_content = self:AddComponent(UIBaseContainer, normal_content_path)
  self.lock_content = self:AddComponent(UIBaseContainer, lock_content_path)
  self.cut_down_time_text = self:AddComponent(UITextMeshProUGUIEx, cut_down_time_text_path)
  self.starImg = self:AddComponent(UIImage, "NormalContent/StarImg")
  self.itemList = {}
  self.itemReqs = {}
end

function UIOffSeason1RecaptureRewardItem:OnDestroy()
  self:ClearContent()
  self.image = nil
  self.normal_content = nil
  self.lock_content = nil
  self.cut_down_time_text = nil
  self.starImg = nil
  base.OnDestroy(self)
end

function UIOffSeason1RecaptureRewardItem:OnEnable()
  base.OnEnable(self)
end

function UIOffSeason1RecaptureRewardItem:OnDisable()
  base.OnDisable(self)
end

function UIOffSeason1RecaptureRewardItem:ClearContent()
  if table.count(self.itemList) > 0 then
    self.content:RemoveComponents(UICommonResItem)
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

function UIOffSeason1RecaptureRewardItem:UpdateData(taskId, taskState)
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
    self.taskInfo.hasReward = taskState
    EventManager:GetInstance():Broadcast(EventId.OnClaimRewardEffFinish)
    self.go_btn:SetActive(false)
    self.finish:SetActive(true)
  end
end

function UIOffSeason1RecaptureRewardItem:ReInit(groupId, taskId, taskInfo)
  self.groupId = groupId
  self.taskId = taskId
  self.taskInfo = taskInfo
  self:RefreshReward(taskInfo.reward)
  local desc = taskInfo.descStr
  if taskInfo.curNum and taskInfo.totalNum then
    desc = string.format("%s (%d/%d)", desc, taskInfo.curNum, taskInfo.totalNum)
  end
  self.name_text:SetText(desc)
  local taskState = taskInfo.hasReward
  if taskState == TaskState.Received then
    self.go_btn:SetActive(false)
    self.finish:SetActive(true)
  elseif taskState == TaskState.CanReceive then
    self.go_btn:SetActive(true)
    self.finish:SetActive(false)
    self.btn_text:SetLocalText("457010")
    UIGray.SetGray(self.go_btn.transform, false, true)
  else
    self.go_btn:SetActive(true)
    self.finish:SetActive(false)
    self.btn_text:SetLocalText("457010")
    UIGray.SetGray(self.go_btn.transform, true, false)
  end
  if self.taskInfo then
    if self.taskInfo.progressSpecial and self.taskInfo.progressSpecial == 0 then
      self.starImg:SetActive(true)
    else
      self.starImg:SetActive(false)
    end
  end
end

function UIOffSeason1RecaptureRewardItem:RefreshReward(rewardList)
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
      item.transform:SetParent(self.content.transform)
      item.transform:Set_sizeDelta(84, 87)
      item.transform:Set_localScale(scale, scale, 1)
      local cell = self.content:AddComponent(UICommonResItem, item.name)
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

function UIOffSeason1RecaptureRewardItem:OnBtnClick()
  SFSNetwork.SendMessage(MsgDefines.CityBattleActivityGainTaskReward, tonumber(self.groupId), tonumber(self.taskId))
end

return UIOffSeason1RecaptureRewardItem
