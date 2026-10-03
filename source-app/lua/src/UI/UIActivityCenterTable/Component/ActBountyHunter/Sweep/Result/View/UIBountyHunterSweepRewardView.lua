local UIBountyHunterSweepRewardView = BaseClass("UIBountyHunterSweepRewardView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIBountyHunterSweepRewardItemComponent = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Sweep.Result.Component.UIBountyHunterSweepRewardItemComponent")
local UIBountyHunterSweepRewardEventItemComponent = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Sweep.Result.Component.UIBountyHunterSweepRewardEventItemComponent")
local UIBountyHunterSweepRewardCostTipPanelComponent = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Sweep.Result.Component.UIBountyHunterSweepRewardCostTipPanelComponent")
local UIBountyHunterSweepRewardDetailTipPanelComponent = require("UI.UIActivityCenterTable.Component.ActBountyHunter.Sweep.Result.Component.UIBountyHunterSweepRewardDetailTipPanelComponent")
local UIBountyHunterSweepRewardItem_Path = "Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/BountyHunterSweep/UIBountyHunterSweepRewardItem.prefab"
local UIBountyHunterSweepRewardEventItem_Path = "Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/BountyHunterSweep/UIBountyHunterSweepRewardEventItem.prefab"
local UIBountyHunterSweepRewardCostTipPanel_Path = "Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/BountyHunterSweep/UIBountyHunterSweepRewardCostTipPanel.prefab"
local UIBountyHunterSweepRewardDetailTipPanel_Path = "Assets/Main/Prefabs/UI/ActivityCenter/BountyHunter/BountyHunterSweep/UIBountyHunterSweepRewardDetailTipPanel.prefab"
local SoundId = 92014

function UIBountyHunterSweepRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
  self.bg:SetActive(false)
  self.panelRoot:SetActive(false)
  self.videoPlayer_rawImage:SetActive(false)
  self.btnSkip:SetActive(false)
  if self.bountyHunterData and not self.bountyHunterData:HasShownSecondConfirm(PostEventLog.Defines.c_show_sweep_reward_view) then
    PostEventLog.Track(PostEventLog.Defines.c_show_sweep_reward_view, {
      activity_id = self.data.activityId,
      day_count = self.bountyHunterData:GetCurActivityDayCount()
    })
    self.bountyHunterData:SetHasShownSecondConfirm(PostEventLog.Defines.c_show_sweep_reward_view)
  end
end

function UIBountyHunterSweepRewardView:OnDestroy()
  if self.soundId then
    DataCenter.LWSoundManager:StopSound(self.soundId)
  end
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBountyHunterSweepRewardView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnConfirm = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnConfirm:SetOnClick(function()
    self:OnBtnConfirmClick()
  end)
  self.imgCostItemIcon = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textCostItemNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgPassNormalMonsterIcon = self.viewSkin:AddComponent(self, UIImage, 4)
  self.textPassNormalMonsterNum = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.btnCostInfo = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnCostInfo:SetOnClick(function()
    self:OnBtnCostInfoClick()
  end)
  self.compKillNormalMonsterArea = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.compSpecialEventArea = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.compContent = self.viewSkin:AddComponent(self, UIBaseContainer, 9)
  self.btnRewardInfo = self.viewSkin:AddComponent(self, UIButton, 10)
  self.btnRewardInfo:SetOnClick(function()
    self:OnBtnRewardInfoClick()
  end)
  self.videoPlayer_rawImage = self.viewSkin:AddComponent(self, UIRawImage, 11)
  self.bg = self.viewSkin:AddComponent(self, UIBaseContainer, 12)
  self.panelRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 13)
  self.refreshItemLayout = self.viewSkin:AddComponent(self, UIBaseContainer, 14)
  self.textBossMonsterEmptyTxt = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 15)
  self.btnSkip = self.viewSkin:AddComponent(self, UIButton, 16)
  self.btnSkip:SetOnClick(function()
    self:OnBtnSkipClick()
  end)
  self.btnRawImageVideo = self.viewSkin:AddComponent(self, UIButton, 17)
  self.btnRawImageVideo:SetOnClick(function()
  end)
  self.scrollRect = self.viewSkin:AddComponent(self, UIScrollRect, 18)
  self.animator = self.viewSkin:AddComponent(self, UIAnimator, 19)
  self.rootAnimator = self.viewSkin:AddComponent(self, UIAnimator, 20)
  self.btnSkipCanvasGroup = self.btnSkip:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.videoPlayer_rawImage:SetActive(false)
  self.bg:SetActive(false)
  self.panelRoot:SetActive(false)
end

function UIBountyHunterSweepRewardView:ComponentDestroy()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if self.scrollTimer then
    self.scrollTimer:Stop()
    self.scrollTimer = nil
  end
  if self.btnSkipDisappearTimer then
    self.btnSkipDisappearTimer:Stop()
    self.btnSkipDisappearTimer = nil
  end
  if self.btnSkipAniTween then
    self.btnSkipAniTween:Kill()
    self.btnSkipAniTween = nil
  end
  self.videoPlayerCreater = nil
  self:ClearRewardContent()
  self:GameObjectDestroy(self.rewardsTipPanelReq)
  self.rewardsTipPanelReq = nil
  self.rewardsTipPanel = nil
  self:GameObjectDestroy(self.costTipPanelReq)
  self.costTipPanelReq = nil
  self.costTipPanel = nil
  self.viewSkin = nil
  self.btnConfirm = nil
  self.imgCostItemIcon = nil
  self.textCostItemNum = nil
  self.imgPassNormalMonsterIcon = nil
  self.textPassNormalMonsterNum = nil
  self.btnCostInfo = nil
  self.compKillNormalMonsterArea = nil
  self.compSpecialEventArea = nil
  self.compContent = nil
  self.btnRewardInfo = nil
  self.videoPlayer_rawImage = nil
  self.bg = nil
  self.panelRoot = nil
  self.refreshItemLayout = nil
  self.textBossMonsterEmptyTxt = nil
  self.btnSkip = nil
  self.btnRawImageVideo = nil
  self.scrollRect = nil
  self.animator = nil
  self.rootAnimator = nil
  self.btnSkipCanvasGroup = nil
end

function UIBountyHunterSweepRewardView:DataDefine()
  self.rewardReqsEvent = {}
  self.rewardCells = {}
  self.killReqsEvent = {}
  self.killCells = {}
  self.foundReqsEvent = {}
  self.foundCells = {}
  self.data = self:GetUserData()
  self.bountyHunterData = DataCenter.BountyHunterActDataManager:GetActData(tonumber(self.data.activityId))
  self.scrollingTime = 0
end

function UIBountyHunterSweepRewardView:DataDestroy()
  self.rewardReqsEvent = {}
  self.rewardCells = {}
  self.killReqsEvent = {}
  self.killCells = {}
  self.foundReqsEvent = {}
  self.foundCells = {}
  self.data = {}
  self.bountyHunterData = nil
  self.scrollingTime = 0
end

function UIBountyHunterSweepRewardView:OnAddListener()
  self:AddUIListener(EventId.BountyHunterOnSweepRewardStart, self.OnFullScreenVideoFinish)
  base.OnAddListener(self)
end

function UIBountyHunterSweepRewardView:OnRemoveListener()
  self:RemoveUIListener(EventId.BountyHunterOnSweepRewardStart, self.OnFullScreenVideoFinish)
  base.OnRemoveListener(self)
end

function UIBountyHunterSweepRewardView:RefreshView()
  self:RefreshKillMonsterInfoArea()
  self:RefreshRewardArea()
end

function UIBountyHunterSweepRewardView:RefreshKillMonsterInfoArea()
  self:RefreshCost()
  self:RefreshKill()
  self:RefreshFoundEvent()
end

function UIBountyHunterSweepRewardView:RefreshCost()
  if self.bountyHunterData == nil then
    return
  end
  local info = self.bountyHunterData:GetSuperShootInfo()
  if info == nil then
    return
  end
  local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(info.goodsId)
  if itemTemplate ~= nil then
    self.imgCostItemIcon:LoadSpriteAuto(string.format(LoadPath.ItemPath, itemTemplate.icon))
  end
  self.textCostItemNum:SetText(self.data.costItemNum)
  local refreshItemTemplate
  if self.bountyHunterData.hunterActTmpData and self.bountyHunterData.hunterActTmpData.refresh_item then
    refreshItemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.bountyHunterData.hunterActTmpData.refresh_item)
  end
  if refreshItemTemplate ~= nil then
    self.imgPassNormalMonsterIcon:LoadSpriteAuto(string.format(LoadPath.ItemPath, refreshItemTemplate.icon))
  end
  self.textPassNormalMonsterNum:SetText(self.data.refreshItemNum)
  self.refreshItemLayout:SetActive(self.data.refreshItemNum > 0)
  self.btnCostInfo:SetActive(self.data.refreshItemNum > 0)
end

function UIBountyHunterSweepRewardView:RefreshKill()
  self:ClearKillContent()
  local kills = self.data.killCount or {}
  local event = {}
  for i, v in ipairs(kills) do
    local lineData = LocalController:instance():tryGetLine(TableName.Bounty_Monster, v.id)
    if lineData then
      if not event[lineData.type] then
        event[lineData.type] = {
          id = lineData.id,
          data = lineData,
          count = 0
        }
      end
      event[lineData.type].count = event[lineData.type].count + v.count
    end
  end
  for k, v in pairs(event) do
    self.killReqsEvent[k] = self:GameObjectInstantiateAsync(UIBountyHunterSweepRewardEventItem_Path, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.compKillNormalMonsterArea.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      local nameStr = "kill_item_" .. tostring(k)
      go.name = nameStr
      go.gameObject:SetActive(true)
      local cell = self.compKillNormalMonsterArea:AddComponent(UIBountyHunterSweepRewardEventItemComponent, go.name)
      cell:ReInitKill(v)
      table.insert(self.killCells, cell)
    end)
  end
end

function UIBountyHunterSweepRewardView:ClearKillContent()
  self.compKillNormalMonsterArea:RemoveComponents(UIBountyHunterSweepRewardEventItemComponent)
  for k, v in pairs(self.killReqsEvent) do
    if v ~= nil then
      self:GameObjectDestroy(v)
    end
  end
  self.killReqsEvent = {}
end

function UIBountyHunterSweepRewardView:RefreshFoundEvent()
  self:ClearFoundContent()
  local founds = self.data.triggerEvent or {}
  local event = {}
  for i, v in ipairs(founds) do
    local lineData = LocalController:instance():tryGetLine(TableName.Bounty_Hunter_Event, v)
    if lineData then
      if not event[lineData.event] then
        event[lineData.event] = {
          id = lineData.id,
          data = lineData,
          count = 0
        }
      end
      event[lineData.event].count = event[lineData.event].count + 1
    end
  end
  for k, v in pairs(event) do
    self.foundReqsEvent[k] = self:GameObjectInstantiateAsync(UIBountyHunterSweepRewardEventItem_Path, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.compSpecialEventArea.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      local nameStr = "found_item_" .. tostring(k)
      go.name = nameStr
      go.gameObject:SetActive(true)
      local cell = self.compSpecialEventArea:AddComponent(UIBountyHunterSweepRewardEventItemComponent, go.name)
      cell:ReInitFound(v)
      table.insert(self.foundCells, cell)
    end)
  end
  self.textBossMonsterEmptyTxt:SetActive(table.length(event) == 0)
end

function UIBountyHunterSweepRewardView:ClearFoundContent()
  self.compSpecialEventArea:RemoveComponents(UIBountyHunterSweepRewardEventItemComponent)
  for k, v in pairs(self.foundReqsEvent) do
    if v ~= nil then
      self:GameObjectDestroy(v)
    end
  end
  self.foundReqsEvent = {}
end

function UIBountyHunterSweepRewardView:RefreshRewardArea()
  self:ClearRewardContent()
  local reward = DeepCopy(self.data.monsterReward) or {}
  local chestReward = DeepCopy(self.data.chestReward) or {}
  for _, r1 in pairs(chestReward) do
    local found = false
    for _, r2 in pairs(reward) do
      if r1.type == r2.type and r1.value and r2.value and r1.value.id == r2.value.id then
        r2.value.num = r2.value.num + r1.value.num
        found = true
        break
      end
    end
    if not found then
      table.insert(reward, r1)
    end
  end
  for i = 1, #reward do
    self.rewardReqsEvent[i] = self:GameObjectInstantiateAsync(UIBountyHunterSweepRewardItem_Path, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.compContent.transform)
      go.transform:Set_localScale(0.9, 0.9, 1)
      go.transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
      local nameStr = "item_reward_" .. tostring(i)
      go.name = nameStr
      go.gameObject:SetActive(true)
      local cell = self.compContent:AddComponent(UIBountyHunterSweepRewardItemComponent, go.name)
      cell:ReInit(reward[i])
      table.insert(self.rewardCells, cell)
    end)
  end
end

function UIBountyHunterSweepRewardView:ClearRewardContent()
  self.compContent:RemoveComponents(UIBountyHunterSweepRewardItemComponent)
  for k, v in pairs(self.rewardReqsEvent) do
    if v ~= nil then
      self:GameObjectDestroy(v)
    end
  end
  self.rewardReqsEvent = {}
end

function UIBountyHunterSweepRewardView:OnBtnConfirmClick()
  self.animator:Play("UIBountyHunterSweepReward_moveout")
  self.rootAnimator:Play("UIBountyHunterSweepReward_moveout")
  EventManager:GetInstance():BroadcastDeferred(EventId.BountyHunterOnSuperShootFinish)
  self.ctrl:CloseSelf()
end

function UIBountyHunterSweepRewardView:OnBtnCostInfoClick()
  if self.costTipPanel == nil then
    if self.costTipPanelReq == nil then
      self.costTipPanelReq = self:GameObjectInstantiateAsync(UIBountyHunterSweepRewardCostTipPanel_Path, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.panelRoot.transform)
        go.transform:Set_localScale(1, 1, 1)
        go.transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        local nameStr = "costTipPanel"
        go.name = nameStr
        go.gameObject:SetActive(true)
        local cell = self.panelRoot:AddComponent(UIBountyHunterSweepRewardCostTipPanelComponent, go.name)
        self.costTipPanel = cell
        local pos = self.btnCostInfo:GetPosition()
        pos.y = pos.y + 70
        self.costTipPanel:SetPosition(pos)
        cell:SetData(self.data, self.bountyHunterData)
      end)
    end
  else
    self.costTipPanel:SetActive(true)
    local pos = self.btnCostInfo:GetPosition()
    pos.y = pos.y + 90
    self.costTipPanel:SetPosition(pos)
    self.costTipPanel:SetData(self.data, self.bountyHunterData)
  end
  if self.bountyHunterData and not self.bountyHunterData:HasShownSecondConfirm(PostEventLog.Defines.c_show_sweep_reward_view_cost_tips) then
    PostEventLog.Track(PostEventLog.Defines.c_show_sweep_reward_view_cost_tips, {
      activity_id = self.data.activityId,
      day_count = self.bountyHunterData:GetCurActivityDayCount()
    })
    self.bountyHunterData:SetHasShownSecondConfirm(PostEventLog.Defines.c_show_sweep_reward_view_cost_tips)
  end
end

function UIBountyHunterSweepRewardView:OnBtnRewardInfoClick()
  local now = UITimeManager:GetInstance():GetServerTime()
  if now - self.scrollingTime < 2000 then
    return
  end
  if self.rewardsTipPanel == nil then
    if self.rewardsTipPanelReq == nil then
      self.rewardsTipPanelReq = self:GameObjectInstantiateAsync(UIBountyHunterSweepRewardDetailTipPanel_Path, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.panelRoot.transform)
        go.transform:Set_localScale(1, 1, 1)
        go.transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
        local nameStr = "rewardsTipPanel"
        go.name = nameStr
        go.gameObject:SetActive(true)
        local cell = self.panelRoot:AddComponent(UIBountyHunterSweepRewardDetailTipPanelComponent, go.name)
        self.rewardsTipPanel = cell
        local pos = self.btnRewardInfo:GetPosition()
        pos.y = pos.y + 90
        self.rewardsTipPanel:SetPosition(pos)
        cell:SetData(self.data, self.bountyHunterData, true)
      end)
    end
  else
    self.rewardsTipPanel:SetActive(true)
    local pos = self.btnRewardInfo:GetPosition()
    pos.y = pos.y + 90
    self.rewardsTipPanel:SetPosition(pos)
    self.rewardsTipPanel:SetData(self.data, self.bountyHunterData, true)
  end
  if self.bountyHunterData and not self.bountyHunterData:HasShownSecondConfirm(PostEventLog.Defines.c_show_sweep_reward_view_rewards_tips) then
    PostEventLog.Track(PostEventLog.Defines.c_show_sweep_reward_view_rewards_tips, {
      activity_id = self.data.activityId,
      day_count = self.bountyHunterData:GetCurActivityDayCount()
    })
    self.bountyHunterData:SetHasShownSecondConfirm(PostEventLog.Defines.c_show_sweep_reward_view_rewards_tips)
  end
end

function UIBountyHunterSweepRewardView:OnFullScreenVideoFinish(isSkip)
  if isSkip then
    self:OnBtnSkipClick()
  else
    self:OnNormalFinish()
  end
end

function UIBountyHunterSweepRewardView:OnBtnSkipClick()
  self:OnVideoFinish()
  self.animator:Play("UIBountyHunterSweepReward_idle")
  self.rootAnimator:Play("UIBountyHunterSweepReward_idle")
  self:ShowAnim(0)
  self.soundId = DataCenter.LWSoundManager:PlaySound(SoundId, true)
end

function UIBountyHunterSweepRewardView:OnNormalFinish()
  self:OnVideoFinish()
  self.animator:Play("UIBountyHunterSweepReward_movein")
  self.rootAnimator:Play("UIBountyHunterSweepReward_movein")
  self.soundId = DataCenter.LWSoundManager:PlaySound(SoundId, false)
  self:ShowAnim(0.5)
end

function UIBountyHunterSweepRewardView:ShowAnim(time)
  for i, v in ipairs(self.killCells) do
    v:ShowAnim(time + (i - 1) * 0.05)
  end
  for i, v in ipairs(self.foundCells) do
    v:ShowAnim(time + (#self.killCells + i - 1) * 0.05)
  end
  for i, v in ipairs(self.rewardCells) do
    v:ShowAnim(time + 0.5 + (i - 1) * 0.05)
  end
end

function UIBountyHunterSweepRewardView:OnVideoFinish()
  self.bg:SetActive(true)
  self.panelRoot:SetActive(true)
  self.videoPlayer_rawImage:SetActive(false)
  self.btnSkip:SetActive(false)
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if self.scrollTimer then
    self.scrollTimer:Stop()
    self.scrollTimer = nil
  end
  self.scrollRect:SetVerticalNormalizedPosition(1)
  self.scrollingTime = UITimeManager:GetInstance():GetServerTime()
  self.scrollTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.scrollRect:AnimVerticalNormalizedPos(0, 1)
  end, 1)
end

return UIBountyHunterSweepRewardView
