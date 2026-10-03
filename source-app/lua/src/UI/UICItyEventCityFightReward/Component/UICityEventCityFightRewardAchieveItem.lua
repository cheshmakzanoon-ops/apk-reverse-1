local UICityEventCityFightRewardAchieveItem = BaseClass("UICityEventCityFightRewardAchieveItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local GO_BUTTON_TXT = "110003"
local RECEIVE_BUTTON_TXT = "170004"
local ALREADY_RECEIVE = "170003"
local compBook = {
  {
    path = "txtTitle1",
    name = "txtTitle1",
    type = UITextMeshProUGUIEx,
    textKey = "500266"
  },
  {
    path = "btnReceive",
    name = "btnReceive",
    type = UIButton,
    onClick = function(self)
      self:OnClick()
    end
  },
  {
    path = "btnReceive/txtReceive",
    name = "txtReceive",
    type = UITextMeshProUGUIEx
  },
  {
    path = "btnReceive/imgReceived",
    name = "imgReceived",
    type = nil
  },
  {
    path = "btnReceive/imgGo",
    name = "imgGo",
    type = nil
  },
  {
    path = "scrollRewards",
    name = "scroll",
    type = UIScrollRect
  },
  {
    path = "scrollRewards/Viewport/Content",
    name = "scrollContent",
    type = nil
  },
  {
    path = "scrollRewards/rewardTemplate",
    name = "rewardTemplate",
    type = nil,
    active = false
  }
}

function UICityEventCityFightRewardAchieveItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UICityEventCityFightRewardAchieveItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICityEventCityFightRewardAchieveItem:ComponentDefine()
  self.rewardComps = {}
  self:DefineCompsByBook(compBook)
end

function UICityEventCityFightRewardAchieveItem:ComponentDestroy()
  for _, rewardComp in ipairs(self.rewardComps) do
    if rewardComp then
      local go = rewardComp.gameObject
      self:RemoveComponent(rewardComp)
      if not IsNull(go) then
        CS.UnityEngine.GameObject.Destroy(go)
      end
    end
  end
  self.data = nil
  self.cityEventId = nil
  self.rewardComps = nil
  self:ClearCompsByBook(compBook)
end

function UICityEventCityFightRewardAchieveItem:OnAddListener()
  base.OnAddListener(self)
end

function UICityEventCityFightRewardAchieveItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UICityEventCityFightRewardAchieveItem:Refresh(data, cityEventId)
  self.data = data
  self.cityEventId = cityEventId
  local taskId = self.data.taskId
  self.questTemplate = DataCenter.QuestTemplateManager:GetQuestTemplate(taskId)
  if not self.questTemplate then
    return
  end
  local taskDesc = self.questTemplate:GetDesc()
  if data.state ~= 2 then
    local curNum = self.data.num and self.data.num or 0
    local targetNum = self.questTemplate.para2
    if curNum >= targetNum then
      curNum = targetNum
    end
    curNum = string.GetFormattedSeperatorNum(curNum)
    targetNum = string.GetFormattedSeperatorNum(targetNum)
    local process = string.format("(%d/%d)", curNum, targetNum)
    taskDesc = taskDesc .. process
  end
  self.txtTitle1:SetText(taskDesc)
  self.imgReceived:SetActive(data.state == TaskState.Received)
  self.imgGo:SetActive(data.state == TaskState.NoComplete)
  if data.state == TaskState.Received then
    self.txtReceive:SetLocalText(ALREADY_RECEIVE)
  elseif data.state == TaskState.CanReceive then
    self.txtReceive:SetLocalText(RECEIVE_BUTTON_TXT)
  elseif data.state == TaskState.NoComplete then
    self.txtReceive:SetLocalText(GO_BUTTON_TXT)
  end
  if data.rewards == nil then
    data.rewards = DataCenter.RewardManager:ReturnRewardParamForMessage(data.reward)
  end
  local idx = 1
  for _, reward in ipairs(data.rewards) do
    local rewardComp = self.rewardComps[idx]
    if not rewardComp then
      local rewardObj = CS.UnityEngine.GameObject.Instantiate(self.rewardTemplate, self.scrollContent.transform)
      rewardObj.name = "reward_" .. idx
      rewardComp = self:AddComponent(UICommonResItem, rewardObj)
      self.rewardComps[idx] = rewardComp
    end
    rewardComp:SetActive(true)
    rewardComp:ReInit(reward)
    idx = idx + 1
  end
  for i = idx, #self.rewardComps do
    self.rewardComps[i]:SetActive(false)
  end
end

function UICityEventCityFightRewardAchieveItem:OnClick()
  if not self.data then
    return
  end
  if self.data.state == TaskState.CanReceive then
    if self.cityEventId then
      SFSNetwork.SendMessage(MsgDefines.LWBeginnerCityEventTaskReward, self.cityEventId, self.data.taskId)
    end
  elseif self.data.state == TaskState.NoComplete then
    GoToUtil.CloseAllWindows()
    GoToUtil.GoToByQuestId(self.questTemplate)
  end
end

return UICityEventCityFightRewardAchieveItem
