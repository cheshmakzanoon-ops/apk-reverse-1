local UIGovernmentBtn = BaseClass("UIGovernmentBtn", UIBaseContainer)
local base = UIBaseContainer

function UIGovernmentBtn:RefreshShowState()
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local isBigMapMode, curSameGroup, srcSameGroup, loginSameGroup = SeasonUtil.InSeasonBigMapMode(mySourceServerId)
  if isBigMapMode and srcSameGroup and loginSameGroup or LuaEntry.Player:IsLoginSourceServer() then
    local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.KingActivity.Type)
    if actList and 0 < #actList then
      self.actData = actList[1]
    else
      self.actData = nil
    end
    if self.actData ~= nil and self.actData:IsValid() then
      self:SetActive(true)
      self.redPoint:SetActive(self:hasPersonalTargetFinish())
    else
      self:SetActive(false)
    end
  else
    self:SetActive(false)
  end
end

function UIGovernmentBtn:OnBtnClick()
  if self.actData ~= nil then
    UIUtil.ShowGovernmentActivityMain()
  end
end

function UIGovernmentBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIGovernmentBtn:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIGovernmentBtn:ComponentDefine()
  self.btnText = self:AddComponent(UIText, "BtnText")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.btnText:SetLocalText("457002")
  self.redPoint = self:AddComponent(UIBaseComponent, "RedPoint")
  self.bg = self:AddComponent(UIImage, "Bg")
  if self.bg and SeasonUtil.IsInSeasonSnowMode() then
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UIMain/LWMainUI/Mjc_S2_tianxiadashi_benfuwangzuo.png")
  end
end

function UIGovernmentBtn:ComponentDestroy()
  self.actData = nil
  self.btnText = nil
  self.btn = nil
  self.redPoint = nil
end

function UIGovernmentBtn:hasPersonalTargetFinish()
  local kingStageType = 100
  local data = DataCenter.ActivityStageTemplateManager:GetTemplate(kingStageType)
  if data == nil then
    return false
  end
  local taskList = data:GetQuests()
  for _, taskId in pairs(taskList) do
    local taskInfo = DataCenter.TaskManager:FindTaskInfo(taskId)
    if taskInfo then
      local taskState = taskInfo.state
      if taskState == TaskState.CanReceive then
        return true
      end
    end
  end
  return false
end

return UIGovernmentBtn
