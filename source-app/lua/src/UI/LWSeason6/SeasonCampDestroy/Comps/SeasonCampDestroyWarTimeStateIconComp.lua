local p_btn_tips_path = "p_btn_tips"
local p_icon_state_path = "p_btn_tips/p_icon_state"
local base = UIBaseContainer
local SeasonCampDestroyWarTimeStateIconComp = BaseClass("SeasonCampDestroyWarTimeStateIconComp", UIBaseContainer)

function SeasonCampDestroyWarTimeStateIconComp:ComponentDefine()
  self.p_btn_tips = self:AddComponent(UIButton, p_btn_tips_path)
  self.p_btn_tips:SetOnClick(BindCallback(self, self.OnTipsClicked))
  self.p_icon_state = self:AddComponent(UIImage, p_icon_state_path)
end

function SeasonCampDestroyWarTimeStateIconComp:ComponentDestroy()
  self.p_btn_tips = nil
  self.p_icon_state = nil
end

function SeasonCampDestroyWarTimeStateIconComp:DataDefine()
end

function SeasonCampDestroyWarTimeStateIconComp:DataDestroy()
end

function SeasonCampDestroyWarTimeStateIconComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.p_btn_tips:SetActive(false)
end

function SeasonCampDestroyWarTimeStateIconComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCampDestroyWarTimeStateIconComp:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonCampDestroyWarTimeGetInfoUpdate, self.OnGetInfoCallback)
end

function SeasonCampDestroyWarTimeStateIconComp:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonCampDestroyWarTimeGetInfoUpdate, self.OnGetInfoCallback)
  base.OnRemoveListener(self)
end

function SeasonCampDestroyWarTimeStateIconComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData(data) then
      self:UpdateUi()
    else
      DataCenter.SeasonCampDestroyManager:SendGetWarTimeInfo(self.Data.AllianceId)
    end
  end
end

function SeasonCampDestroyWarTimeStateIconComp:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function SeasonCampDestroyWarTimeStateIconComp:InitUi()
  self.p_btn_tips:SetActive(false)
end

function SeasonCampDestroyWarTimeStateIconComp:UpdateData(data)
  if self.Data.AllianceId == LuaEntry.Player.allianceId then
    self.WarTimeData = DataCenter.SeasonCampDestroyManager:GetMyAllianceWarTimeData()
  else
    self.WarTimeData = data
  end
  if self.WarTimeData ~= nil and self.WarTimeData.TimeIndex ~= nil then
    local realIndex = self:GetRealIndex()
    return 0 <= realIndex and realIndex <= 2
  end
  return false
end

function SeasonCampDestroyWarTimeStateIconComp:UpdateUi()
  local realIndex = self:GetRealIndex()
  if 0 <= realIndex and realIndex <= 2 then
    self.p_btn_tips:SetActive(true)
    self.p_icon_state:LoadSpriteAsync(DataCenter.SeasonCampDestroyManager:GetIconPath(realIndex))
  end
end

function SeasonCampDestroyWarTimeStateIconComp:GetRealIndex()
  if self.WarTimeData == nil then
    return -1
  end
  return DataCenter.SeasonCampDestroyManager:GetRealTimeIndex(self.WarTimeData.TimeIndex, self.WarTimeData.SetTime)
end

function SeasonCampDestroyWarTimeStateIconComp:OnGetInfoCallback(evtData)
  if evtData == nil then
    return
  end
  if evtData.AllianceId == self.Data.AllianceId and self:UpdateData(evtData) then
    self:UpdateUi()
  end
end

function SeasonCampDestroyWarTimeStateIconComp:OnTipsClicked()
  if self.WarTimeData ~= nil then
    local param = {}
    param.alignObject = self.p_btn_tips.transform
    param.yPosFix = -20
    param.showArrow = true
    param.preferTop = true
    param.TimeIndex = self.WarTimeData.TimeIndex
    UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonAllianceWarTimeStateTipsView, {anim = true}, param)
  end
end

return SeasonCampDestroyWarTimeStateIconComp
