local UIActivityMultipleParkourAchieveItem = BaseClass("UIActivityMultipleParkourAchieveItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "txtTitle1",
    name = "txtTitle1",
    type = UITextMeshProUGUIEx,
    textKey = "500266"
  },
  {
    path = "nodeDone",
    name = "nodeDone",
    type = nil
  },
  {
    path = "nodeDone/txtTitle2",
    name = "txtTitle2",
    type = UITextMeshProUGUIEx,
    textKey = "500266"
  },
  {
    path = "btnReceive",
    name = "btnReceive",
    type = UIButton,
    onClick = function(self)
      self:OnClickReceive()
    end
  },
  {
    path = "btnReceive/txtReceive",
    name = "txtReceive",
    type = UITextMeshProUGUIEx,
    textKey = "129054"
  },
  {
    path = "btnReceive/imgGray",
    name = "imgGray",
    type = nil
  },
  {
    path = "btnReceive/imgGray/txtGray",
    name = "txtGray",
    type = UITextMeshProUGUIEx,
    textKey = "129054"
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

function UIActivityMultipleParkourAchieveItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIActivityMultipleParkourAchieveItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActivityMultipleParkourAchieveItem:ComponentDefine()
  self.rewardComps = {}
  self:DefineCompsByBook(compBook)
end

function UIActivityMultipleParkourAchieveItem:ComponentDestroy()
  for _, rewardComp in ipairs(self.rewardComps) do
    if rewardComp then
      local go = rewardComp.gameObject
      self:RemoveComponent(rewardComp)
      if not IsNull(go) then
        CS.UnityEngine.GameObject.Destroy(go)
      end
    end
  end
  self.rewardComps = nil
  self:ClearCompsByBook(compBook)
end

function UIActivityMultipleParkourAchieveItem:OnAddListener()
  base.OnAddListener(self)
end

function UIActivityMultipleParkourAchieveItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActivityMultipleParkourAchieveItem:Refresh(data, activityId)
  self.data = data
  self.activityId = activityId
  local taskId = data.taskId
  local taskInfo = DataCenter.ActivityTaskTemplateManager:GetActTaskTemplate(taskId)
  local taskDesc = taskInfo:GetDesc(true)
  if data.state ~= 2 then
    local curNum = self.data.num and self.data.num or 0
    local targetNum = taskInfo.para2
    if curNum >= targetNum then
      curNum = targetNum
    end
    local color = data.state == 1 and "#099b4a" or "#f53c3d"
    curNum = string.GetFormattedSeperatorNum(curNum)
    targetNum = string.GetFormattedSeperatorNum(targetNum)
    local process = " (" .. "<color=" .. color .. ">" .. curNum .. "</color>" .. "/" .. targetNum .. ")"
    taskDesc = taskDesc .. process
  end
  self.txtTitle1:SetText(taskDesc)
  self.txtTitle2:SetText(taskDesc)
  self.nodeDone:SetActive(data.state == 2)
  self.btnReceive:SetInteractable(data.state == 1)
  self.imgGray:SetActive(data.state == 0)
  self.scroll:SetSizeDeltaXY(self.nodeDone.activeSelf and 648 or 473, self.scroll:GetSizeDelta().y)
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

function UIActivityMultipleParkourAchieveItem:OnClickReceive()
  if not self.data then
    return
  end
  if not self.activityId then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.MultipleParkourTaskReward, self.activityId, self.data.taskId)
end

return UIActivityMultipleParkourAchieveItem
