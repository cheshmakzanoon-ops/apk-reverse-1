local UICityEventZombieSeaFirstAchieveItem = BaseClass("UICityEventZombieSeaFirstAchieveItem", UIBaseContainer)
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
  }
}
local GO_BUTTON_TXT = "110003"
local ALREADY_COMPLETE_TXT = "170008"
local ALREADY_RECEIVE = "170003"

function UICityEventZombieSeaFirstAchieveItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UICityEventZombieSeaFirstAchieveItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UICityEventZombieSeaFirstAchieveItem:ComponentDefine()
  self.rewardComps = {}
  self:DefineCompsByBook(compBook)
end

function UICityEventZombieSeaFirstAchieveItem:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UICityEventZombieSeaFirstAchieveItem:OnAddListener()
  base.OnAddListener(self)
end

function UICityEventZombieSeaFirstAchieveItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UICityEventZombieSeaFirstAchieveItem:Refresh(data)
  self.data = data
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
  self.imgReceived:SetActive(data.state ~= TaskState.NoComplete)
  self.imgGo:SetActive(data.state == TaskState.NoComplete)
  if data.state == TaskState.Received then
    self.txtReceive:SetLocalText(ALREADY_RECEIVE)
  elseif data.state == TaskState.CanReceive then
    self.txtReceive:SetLocalText(ALREADY_COMPLETE_TXT)
  elseif data.state == TaskState.NoComplete then
    self.txtReceive:SetLocalText(GO_BUTTON_TXT)
  end
end

function UICityEventZombieSeaFirstAchieveItem:OnClick()
  if not self.data then
    return
  end
  if self.data.state == TaskState.NoComplete then
    GoToUtil.CloseAllWindows()
    GoToUtil.GoToByQuestId(self.questTemplate)
  end
end

return UICityEventZombieSeaFirstAchieveItem
