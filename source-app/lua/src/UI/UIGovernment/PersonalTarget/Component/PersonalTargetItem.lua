local PersonalTargetItem = BaseClass("PersonalTargetItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local RewardUtil = require("Util.RewardUtil")
local name_text_path = "NameText"
local reward_content_path = "ScrollView/Viewport/RewardContent"
local go_btn_path = "GoBtn"
local btn_text_path = "GoBtn/BtnText"

function PersonalTargetItem:OnCreate()
  base.OnCreate(self)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.go_btn = self:AddComponent(UIButton, go_btn_path)
  self.btn_text = self:AddComponent(UIText, btn_text_path)
  self.go_btn:SetOnClick(function()
    self:OnBtnClick()
  end)
end

function PersonalTargetItem:OnDestroy()
  if self.showList ~= nil then
    for _, item in ipairs(self.showList) do
      if item then
        item.iconImg = nil
      end
    end
  end
  self.content:RemoveComponents(UICommonResItem)
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  base.OnDestroy(self)
end

function PersonalTargetItem:OnEnable()
  base.OnEnable(self)
  self:AddUIListener(EventId.MainTaskSuccess, self.TryShowClaimEff)
end

function PersonalTargetItem:OnDisable()
  self:RemoveUIListener(EventId.MainTaskSuccess, self.TryShowClaimEff)
  base.OnDisable(self)
end

function PersonalTargetItem:TryShowClaimEff(taskId)
  if self.taskId and self.taskValue and self.taskId == taskId and self.showList ~= nil then
    local tempType = {}
    EventManager:GetInstance():Broadcast(EventId.RefreshTopResByPickUp, tempType)
    for i, v in ipairs(self.taskValue.rewardList) do
      local rewardType = v.rewardType
      local itemId = v.itemId
      local pic = RewardUtil.GetPic(v.rewardType, itemId)
      local img = self.showList[i].iconImg
      if pic ~= "" and not IsNull(img) then
        UIUtil.DoFly(tonumber(rewardType), 3, pic, img.transform.position, Vector3.New(0, 0, 0))
      end
    end
    EventManager:GetInstance():Broadcast(EventId.OnClaimRewardEffFinish)
    self.btn_text:SetLocalText("457011")
    UIGray.SetGray(self.go_btn.transform, true, false)
  end
end

function PersonalTargetItem:ReInit(cell_index, template, taskId)
  self.index = cell_index
  self.theItemCache = template
  self.taskId = taskId
  self.taskInfo = DataCenter.QuestTemplateManager:GetQuestTemplate(taskId)
  if not self.taskInfo then
    return
  end
  self.taskValue = DataCenter.TaskManager:FindTaskInfo(taskId)
  if not self.taskValue then
    return
  end
  if self.taskValue.rewardList ~= nil then
    local extraRewards = self.taskValue.rewardList
    local goItem, theItem
    self.content:RemoveComponents(UICommonResItem)
    if extraRewards ~= nil then
      for i, item in ipairs(extraRewards) do
        local levelName = "item_" .. i
        goItem = template:GameObjectSpawn(self.content.transform)
        goItem.name = levelName
        goItem:SetActive(true)
        theItem = self.content:AddComponent(UICommonResItem, levelName)
        theItem:ParseInfo(item)
        item.iconImg = goItem.transform:Find("clickBtn/ItemIcon")
      end
      self.showList = extraRewards
    end
  end
  local taskNameStr = self.taskInfo:GetDesc(true)
  local progNum = self.taskValue.num
  local targetNum = self.taskInfo.para2
  progNum = math.min(progNum, targetNum)
  progNum = string.GetFormattedStr(progNum)
  targetNum = string.GetFormattedStr(targetNum)
  taskNameStr = string.format("%s (%s/%s)", taskNameStr, progNum, targetNum)
  self.name_text:SetText(taskNameStr)
  local taskState = self.taskValue.state
  if taskState == TaskState.Received then
    self.btn_text:SetLocalText("457011")
    UIGray.SetGray(self.go_btn.transform, true, false)
  elseif taskState == TaskState.CanReceive then
    self.btn_text:SetLocalText("457010")
    UIGray.SetGray(self.go_btn.transform, false, true)
  else
    self.btn_text:SetLocalText("457010")
    UIGray.SetGray(self.go_btn.transform, true, false)
  end
end

function PersonalTargetItem:OnBtnClick()
  SFSNetwork.SendMessage(MsgDefines.TaskRewardGet, {
    id = self.taskId
  })
end

return PersonalTargetItem
