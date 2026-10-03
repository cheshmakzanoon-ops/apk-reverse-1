local LWUIZombieRushContent = BaseClass("LWUIZombieRushContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local zombie_rush_point_content_path = "ZombieRushPointContent"
local slider_path = "ZombieRushPointContent/Slider"
local progress_text_path = "ZombieRushPointContent/Slider/ProgressText"
local enter_activity_btn_path = "ZombieRushPointContent/EnterActivityBtn"
local center_container_path = "CenterContainer"
local tips_text_path = "CenterContainer/TipsText"
local point_icon_path = "ZombieRushPointContent/PointIcon"
local icon_path = "CenterContainer/Icon"
local bubble_point_path = "ZombieRushPointContent/BubblePoint"
local black_bg_path = "BlackBg"

function LWUIZombieRushContent:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function LWUIZombieRushContent:OnDestroy()
  base.OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
end

function LWUIZombieRushContent:ComponentDefine()
  self.zombie_rush_point_content = self:AddComponent(UIBaseContainer, zombie_rush_point_content_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.progress_text = self:AddComponent(UITextMeshProUGUIEx, progress_text_path)
  self.enter_activity_btn = self:AddComponent(UIButton, enter_activity_btn_path)
  self.enter_activity_btn:SetOnClick(function()
    self:OnEnterActivityBtnClick()
  end)
  self.center_container = self:AddComponent(UIBaseContainer, center_container_path)
  self.tips_text = self:AddComponent(UITextMeshProUGUIEx, tips_text_path)
  self.tips_text:SetText(Localization:GetString("zombieRush_tips_01"))
  self.point_icon = self:AddComponent(UIImage, point_icon_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.bubble_point = self:AddComponent(UIBaseContainer, bubble_point_path)
  self.black_bg = self:AddComponent(UIImage, black_bg_path)
end

function LWUIZombieRushContent:ComponentDestroy()
  self.zombie_rush_point_content = nil
  self.slider = nil
  self.progress_text = nil
  self.enter_activity_btn = nil
  self.center_container = nil
  self.tips_text = nil
  self.point_icon = nil
  self.icon = nil
  self.bubble_point = nil
  self.black_bg = nil
end

function LWUIZombieRushContent:DataDefine()
  self.plotId = 0
  self.maxValue = 0
  self.sequence = nil
  self.hasZombieRushPointRewardId = 0
end

function LWUIZombieRushContent:DataDestroy()
  self.plotId = nil
  self.maxValue = nil
  self.sequence = nil
  self.hasZombieRushPointRewardId = nil
end

function LWUIZombieRushContent:OnAddListener()
  self:AddUIListener(EventId.GF_plot_group_done, self.OnPlotDone)
  self:AddUIListener(EventId.LWDetectEventRewardReceive, self.OnGetDetectEventReward)
end

function LWUIZombieRushContent:OnRemoveListener()
  self:RemoveUIListener(EventId.GF_plot_group_done, self.OnPlotDone)
  self:RemoveUIListener(EventId.LWDetectEventRewardReceive, self.OnGetDetectEventReward)
end

function LWUIZombieRushContent:RefreshView(fromPos)
  self.plotId = LuaEntry.DataConfig:TryGetNum("zombieRush_config", "k6", 0)
  self.maxValue = LuaEntry.DataConfig:TryGetNum("zombieRush_config", "k2", 0)
  self.fromPos = fromPos
  local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.ZombieRush.Type)
  local isUnlock = 0 < table.count(dataList)
  local hasAlliance = LuaEntry.Player:IsInAlliance()
  self.isShow = isUnlock and hasAlliance
  self:SetActive(self.isShow)
  if self.isShow then
    local value = DataCenter.LWUserGuideManager:GetValue(UserGuideType.ZombieRush)
    if not string.IsNullOrEmpty(value) and tonumber(value) == 1 then
      self:SetPointContentActive(true)
      self:SetCenterContentActive(false)
    else
      self:SetPointContentActive(false)
      self:SetCenterContentActive(false)
      self.tips_text:SetActive(true)
      self.center_container:SetLocalPositionXYZ(0, 0, 0)
      self.icon:SetLocalScaleXYZ(1, 1, 1)
      DataCenter.LWUserGuideManager:SendMsg(UserGuideType.ZombieRush, "1")
      EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
        plotGroupId = self.plotId,
        hideMainUI = false
      })
    end
    self:RefreshProgress()
  end
end

function LWUIZombieRushContent:RefreshProgress()
  local curValue = 0
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if allianceData ~= nil then
    curValue = allianceData.zombieRushPoint
  end
  local progress = self.maxValue == 0 and 0 or curValue / self.maxValue
  progress = math.min(1, progress)
  self.slider:SetValue(progress)
  local percentStr = string.format("%.2f", progress * 100)
  percentStr = percentStr:gsub("%.?0+$", "")
  self.progress_text:SetText(percentStr .. "%")
end

function LWUIZombieRushContent:OnPlotDone(plotId)
  if plotId == self.plotId then
    if self.sequence ~= nil then
      self.sequence:Kill()
      self.sequence = nil
    end
    self:SetCenterContentActive(true)
    self.sequence = CS.DG.Tweening.DOTween.Sequence()
    self.sequence:AppendInterval(1)
    self.sequence:AppendCallback(function()
      self.tips_text:SetActive(false)
    end)
    self.sequence:Append(self.center_container.transform:DOMove(self.point_icon.transform.position + Vector3.New(0, -42, 0), 1))
    self.sequence:Join(self.icon.transform:DOScale(Vector3.New(0.45, 0.45, 0.45), 1))
    self.sequence:AppendCallback(function()
      self:SetPointContentActive(true)
      self:SetCenterContentActive(false)
      EventManager:GetInstance():Broadcast(EventId.OnRewardGetPanelClose)
    end)
  end
end

function LWUIZombieRushContent:SetPointContentActive(active)
  self.zombie_rush_point_content:SetActive(active)
end

function LWUIZombieRushContent:SetCenterContentActive(active)
  self.black_bg:SetActive(active)
  self.center_container:SetActive(active)
end

function LWUIZombieRushContent:OnGetDetectEventReward(paramData)
  self.hasZombieRushPointRewardId = 0
  if self.isShow then
    local list = DataCenter.RewardManager:ReturnRewardParamForMessage(paramData.reward) or {}
    for i, v in pairs(list) do
      if v.rewardType == RewardType.GOODS then
        local template = DataCenter.ItemTemplateManager:GetItemTemplate(tonumber(v.itemId))
        if template ~= nil and template.type == GOODS_TYPE.GOODS_TYPE_144 then
          self.hasZombieRushPointRewardId = tonumber(v.itemId)
          self:TryFlyReward()
          break
        end
      end
    end
  end
end

function LWUIZombieRushContent:TryFlyReward()
  if self.hasZombieRushPointRewardId > 0 then
    UIUtil.DoFly(RewardType.GOODS, 3, DataCenter.ItemTemplateManager:GetIconPath(self.hasZombieRushPointRewardId), self.fromPos, self.point_icon.transform.position)
    self:RefreshProgress()
  end
end

function LWUIZombieRushContent:OnEnterActivityBtnClick()
  local curValue = 0
  local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if allianceData ~= nil then
    curValue = allianceData.zombieRushPoint
  end
  if curValue >= self.maxValue then
    local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.ZombieRush.Type)
    if 0 < table.count(dataList) then
      local actId = tonumber(dataList[1].id)
      GoToUtil.GoActWindow({
        tonumber(actId)
      }, false)
    end
  else
    local des = Localization:GetString("zombieRush_tips_01")
    UIUtil.ShowBubbleTipsAuto(des, self.point_icon.transform.position, 0, -20, 0, nil, nil)
    if self.view and self.view.HideBuffDetail then
      self.view:HideBuffDetail()
    end
  end
end

return LWUIZombieRushContent
