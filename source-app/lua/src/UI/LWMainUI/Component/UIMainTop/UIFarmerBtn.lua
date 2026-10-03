local UIFarmerBtn = BaseClass("UIFarmerBtn", UIAsyncContainer)
local base = UIAsyncContainer
local bg_path = "Bg"
local btn_text_path = "BtnText"
local red_point_num_path = "RedPointNum"
local text_path = "RedPointNum/Text"

function UIFarmerBtn:UpdateData()
  self:RefreshShowState()
end

function UIFarmerBtn:RefreshShowState()
  if not self:AsyncLoadDone() then
    return
  end
  if self:CheckShowBtn() then
    self.activityId = DataCenter.SeasonFarmerManager:GetActivityId()
    self:SetActive(true)
    self.btnText:SetLocalText("season_builders_alliance_UI_75")
    self:OnRedPointRefresh()
    return
  end
  self:SetActive(false)
  self.redPoint:SetActive(false)
end

function UIFarmerBtn:CheckShowBtn()
  local mainLv = DataCenter.BuildManager.MainLv
  if mainLv and mainLv >= SEASON_MIN_LEVEL and DataCenter.SeasonFarmerManager:IsOpen() and LuaEntry.Player:IsInAlliance() then
    if DataCenter.SeasonFarmerManager:IsActive() then
      return true
    end
    self:InitCondition()
    if not self.maxAllianceForce and not self.showHour then
      return false
    end
    if self.maxAllianceForce then
      local curForce = DataCenter.SeasonDataManager.allianceForceValue
      if not curForce then
        SFSNetwork.SendMessage(MsgDefines.GetSeasonForceValue, 1)
        return false
      elseif curForce > self.maxAllianceForce then
        return false
      end
    end
    if self.showHour then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local startTime = DataCenter.SeasonFarmerManager:GetStartTime()
      if 0 < startTime and curTime > startTime + self.showHour * 3600000 then
        return false
      end
    end
    return true
  end
  return false
end

function UIFarmerBtn:InitCondition()
  if self.maxAllianceForce or self.showHour then
    return
  end
  local mainCfg = DataCenter.SeasonFarmerTemplateManager:GetMainCfg()
  if mainCfg and mainCfg.condition_2 then
    local condition = string.split(mainCfg.condition_2, "|")
    self.maxAllianceForce = condition[1] and tonumber(condition[1])
    self.showHour = condition[2] and tonumber(condition[2])
  end
end

function UIFarmerBtn:OnBtnClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSingleActivityContainer, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSingleActivityContainer, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllHide
  }, self.activityId))
end

function UIFarmerBtn:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:AddUIListener(EventId.SeasonForceValue, self.RefreshShowState)
  self:AddUIListener(EventId.SeasonFarmerStateChange, self.RefreshShowState)
  self:AddUIListener(EventId.Al_Leave, self.RefreshShowState)
  self:AddUIListener(EventId.Al_Join, self.RefreshShowState)
  self:AddUIListener(EventId.LWSeasonPersonalRewardGetRedPoint, self.RefreshShowState)
  self:AddUIListener(EventId.CityAttachmentOneRewardFinish, self.RefreshShowState)
end

function UIFarmerBtn:OnDestroy()
  self:RemoveUIListener(EventId.SeasonForceValue, self.RefreshShowState)
  self:RemoveUIListener(EventId.SeasonFarmerStateChange, self.RefreshShowState)
  self:RemoveUIListener(EventId.Al_Leave, self.RefreshShowState)
  self:RemoveUIListener(EventId.Al_Join, self.RefreshShowState)
  self:RemoveUIListener(EventId.LWSeasonPersonalRewardGetRedPoint, self.RefreshShowState)
  self:RemoveUIListener(EventId.CityAttachmentOneRewardFinish, self.RefreshShowState)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFarmerBtn:OnRedPointRefresh()
  local count = DataCenter.SeasonFarmerManager:CountOfBuildReward()
  if 1 < count then
    count = 1
  end
  if SeasonUtil.CheckSeasonFarmerAchievement() then
    count = count + 1
  end
  self.redPoint:SetActive(0 < count)
  self.redText:SetActive(0 < count)
  self.redText:SetText(tostring(count))
end

function UIFarmerBtn:ComponentDefine()
  self.bg = self:AddComponent(UIImage, bg_path)
  self.btnText = self:AddComponent(UIText, btn_text_path)
  self.btn = self:AddComponent(UIButton, "")
  self.redPoint = self:AddComponent(UIBaseContainer, red_point_num_path)
  self.redText = self:AddComponent(UIText, text_path)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.redText:SetActive(false)
end

function UIFarmerBtn:ComponentDestroy()
  self.bg = nil
  self.icon = nil
  self.btnText = nil
  self.redPoint = nil
  self.redText = nil
end

return UIFarmerBtn
