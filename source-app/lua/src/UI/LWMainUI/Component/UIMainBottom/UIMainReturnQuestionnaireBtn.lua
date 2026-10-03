local UIMainReturnQuestionnaireBtn = BaseClass("UIMainReturnQuestionnaireBtn", UIButton)
local base = UIButton

function UIMainReturnQuestionnaireBtn:OnCreate()
  base.OnCreate(self)
  self.lastShowTime = -1
  self:SetOnClick(function()
    local activityData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.Questionnaire.Type)
    if activityData and activityData:IsValid() then
      GoToUtil.GotoOpenView(UIWindowNames.UIActivityCenterTable, {anim = true}, activityData.id)
    end
  end)
end

function UIMainReturnQuestionnaireBtn:Refresh()
  self.lastShowTime = -1
  local data = DataCenter.LWQuestionnaireManager:HasReturnQuestionnaireNeedPrompt()
  if data ~= nil then
    self.lastShowTime = data.endTime
  end
  self:SetActive(data ~= nil)
end

function UIMainReturnQuestionnaireBtn:Update1000MS()
  if self.lastShowTime > 0 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime >= self.lastShowTime then
      self:Refresh()
    end
  end
end

return UIMainReturnQuestionnaireBtn
