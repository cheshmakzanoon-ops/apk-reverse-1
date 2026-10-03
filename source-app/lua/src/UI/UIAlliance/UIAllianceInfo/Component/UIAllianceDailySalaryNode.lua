local base = UIBaseContainer
local UIAllianceDailySalaryNode = BaseClass("UIAllianceDailySalaryNode", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIAllianceDailySalaryNode:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIAllianceDailySalaryNode:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllianceDailySalaryNode:ComponentDefine()
  self.progressObj = self:AddComponent(UIBaseContainer, "progressObj")
  self.imgProgress = self:AddComponent(UIImage, "progressObj/imgProgress")
  self.textProgress = self:AddComponent(UITextMeshProUGUIEx, "progressObj/textProgress")
  self.textCountDownBegin = self:AddComponent(UITextMeshProUGUIEx, "textCountDownBegin")
  self.timeGoEndObj = self:AddComponent(UIBaseContainer, "timeGoEnd")
  self.textCountDownEnd = self:AddComponent(UITextMeshProUGUIEx, "timeGoEnd/countDownTxt")
  self.infoBtn = self:AddComponent(UIButton, "InfoBtn")
  self.infoBtn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, {
      howToPlayList = {101011}
    })
  end)
  self.effect = self:AddComponent(UIBaseContainer, "progressObj/VFX_ui_zhoukabaoxiang_xiao")
end

function UIAllianceDailySalaryNode:ComponentDestroy()
  self.imgProgress = nil
end

function UIAllianceDailySalaryNode:DataDefine()
end

function UIAllianceDailySalaryNode:DataDestroy()
end

function UIAllianceDailySalaryNode:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnDailySalaryChange, self.SetData)
end

function UIAllianceDailySalaryNode:OnRemoveListener()
  self:RemoveUIListener(EventId.OnDailySalaryChange, self.SetData)
  base.OnRemoveListener(self)
end

function UIAllianceDailySalaryNode:SetData()
  local curScore = DataCenter.AllianceMilitaryPayDataManager:GetCurDailySalaryScore()
  local maxScore = DataCenter.AllianceMilitaryPayDataManager:GetMaxDailySalaryScore()
  local progress = math.min(curScore / maxScore, 1)
  self.imgProgress:SetFillAmount(progress)
  if curScore < maxScore then
    self.textProgress:SetText(string.format("<color=#FA7070>%d</color>/%d", curScore, maxScore))
    self.effect:SetActive(false)
  else
    self.effect:SetActive(true)
    self.textProgress:SetText(string.format("<color=#7BFF00>%d</color>/%d", curScore, maxScore))
  end
  self:Update1000MS()
end

function UIAllianceDailySalaryNode:Update1000MS()
  local state = DataCenter.AllianceMilitaryPayDataManager:GetActivityState()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if state == SalaryActivityState.NotOpen then
    local leftTime = math.max(DataCenter.AllianceMilitaryPayDataManager:GetActivityStartTime() - curTime, 0)
    if leftTime <= 0 then
      DataCenter.AllianceMilitaryPayDataManager:SetActivityState(SalaryActivityState.Open)
    end
    local leftTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    self.textCountDownBegin:SetActive(true)
    self.timeGoEndObj:SetActive(false)
    self.textCountDownBegin:SetText(Localization:GetString("alliance_pay_unlockCD", leftTimeStr))
    self.infoBtn:SetActive(true)
    self.progressObj:SetActive(false)
  else
    local leftTime = math.max(DataCenter.AllianceMilitaryPayDataManager:GetActivityEndTime() - curTime, 0)
    local leftTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    self.textCountDownBegin:SetActive(false)
    self.timeGoEndObj:SetActive(true)
    self.textCountDownEnd:SetText(leftTimeStr)
    self.infoBtn:SetActive(false)
    local hasGot = DataCenter.AllianceMilitaryPayDataManager:HasGotDailySalary()
    self.progressObj:SetActive(not hasGot)
  end
end

return UIAllianceDailySalaryNode
