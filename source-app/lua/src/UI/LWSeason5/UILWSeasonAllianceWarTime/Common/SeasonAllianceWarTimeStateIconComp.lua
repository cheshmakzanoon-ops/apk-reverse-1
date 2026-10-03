local p_btn_tips_path = "p_btn_tips"
local p_icon_state_path = "p_btn_tips/p_icon_state"
local base = UIBaseContainer
local SeasonAllianceWarTimeStateIconComp = BaseClass("SeasonAllianceWarTimeStateIconComp", UIBaseContainer)

function SeasonAllianceWarTimeStateIconComp:ComponentDefine()
  self.p_btn_tips = self:AddComponent(UIButton, p_btn_tips_path)
  self.p_btn_tips:SetOnClick(BindCallback(self, self.OnTipsClicked))
  self.p_icon_state = self:AddComponent(UIImage, p_icon_state_path)
end

function SeasonAllianceWarTimeStateIconComp:ComponentDestroy()
  self.p_btn_tips = nil
  self.p_icon_state = nil
end

function SeasonAllianceWarTimeStateIconComp:DataDefine()
end

function SeasonAllianceWarTimeStateIconComp:DataDestroy()
  DataCenter.UILWSeasonAllianceWarTimeManager:ClearWaitingGetInfo()
end

function SeasonAllianceWarTimeStateIconComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.p_btn_tips:SetActive(false)
end

function SeasonAllianceWarTimeStateIconComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonAllianceWarTimeStateIconComp:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonAllianceWarTimeGetInfoUpdate, self.OnGetInfoCallback)
end

function SeasonAllianceWarTimeStateIconComp:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonAllianceWarTimeGetInfoUpdate, self.OnGetInfoCallback)
  base.OnRemoveListener(self)
end

function SeasonAllianceWarTimeStateIconComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData(data) then
      self:UpdateUi()
    else
      DataCenter.UILWSeasonAllianceWarTimeManager:SendGetInfo(self.Data.AllianceId)
    end
  end
end

function SeasonAllianceWarTimeStateIconComp:InitData(data)
  if data ~= nil then
    self.Data = data
    return true
  end
  return false
end

function SeasonAllianceWarTimeStateIconComp:InitUi()
  self.p_btn_tips:SetActive(false)
end

function SeasonAllianceWarTimeStateIconComp:UpdateData(data)
  if self.Data.AllianceId == LuaEntry.Player.allianceId then
    self.WarTimeData = DataCenter.UILWSeasonAllianceWarTimeManager:GetMyAllianceWarTimeData()
  else
    self.WarTimeData = data
  end
  if self.WarTimeData ~= nil and self.WarTimeData.TimeIndex ~= nil then
    local realIndex = self:GetRealIndex()
    return 0 <= realIndex and realIndex <= 2
  end
  return false
end

function SeasonAllianceWarTimeStateIconComp:UpdateUi()
  local realIndex = self:GetRealIndex()
  if 0 <= realIndex and realIndex <= 2 then
    self.p_btn_tips:SetActive(true)
    self.p_icon_state:LoadSpriteAsync(DataCenter.UILWSeasonAllianceWarTimeManager:GetIconPath(realIndex))
  end
end

function SeasonAllianceWarTimeStateIconComp:GetRealIndex()
  if self.WarTimeData == nil then
    return -1
  end
  return DataCenter.UILWSeasonAllianceWarTimeManager:GetRealTimeIndex(self.WarTimeData.TimeIndex, self.WarTimeData.SetTime)
end

function SeasonAllianceWarTimeStateIconComp:OnGetInfoCallback(evtData)
  if evtData == nil then
    return
  end
  if evtData.AllianceId == self.Data.AllianceId and self:UpdateData(evtData) then
    self:UpdateUi()
  end
end

function SeasonAllianceWarTimeStateIconComp:OnTipsClicked()
  if self.WarTimeData ~= nil then
    local param = {}
    param.alignObject = self.p_btn_tips.transform
    param.yPosFix = -20
    param.showArrow = true
    param.preferTop = true
    param.allianceId = self.Data.AllianceId
    param.TimeIndex = self.WarTimeData.TimeIndex
    UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonAllianceWarTimeStateTipsView, {anim = true}, param)
  end
end

return SeasonAllianceWarTimeStateIconComp
