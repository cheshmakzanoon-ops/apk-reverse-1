local WorldDispatchTask = BaseClass("WorldDispatchTask", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local reward_item_path = "ScrollView/Viewport/RewardItem"
local reward_content_path = "ScrollView/Viewport/RewardContent"
local desc_path = "desc"
local time_label_path = "timeLabel"
local scroll_view_path = "ScrollView"
local protect_tip_path = "protectTip"
local marked_label_path = "markedLabel"

function WorldDispatchTask:OnCreate()
  base.OnCreate(self)
  self.requestWorldDetail = nil
  self.content = self:AddComponent(UIBaseContainer, reward_content_path)
  self.desc = self:AddComponent(UIText, desc_path)
  self.time_label = self:AddComponent(UIText, time_label_path)
  self.theItem = self.transform:Find(reward_item_path).gameObject
  self.theItem:GameObjectCreatePool()
  self.scroll_view = self:AddComponent(UIBaseContainer, scroll_view_path)
  self.protect_tip = self:AddComponent(UITextMeshProUGUIEx, protect_tip_path)
  self.protect_tip:SetText(Localization:GetString("dispatch_des018"))
  self.marked_label = self:AddComponent(UITextMeshProUGUIEx, marked_label_path)
  self.protect_tip:SetActive(false)
  self.scroll_view:SetActive(true)
  self.isClickSelf = false
end

function WorldDispatchTask:OnDestroy()
  self.content:RemoveComponents(UICommonResItem)
  self.theItem:GameObjectRecycleAll()
  self.scroll_view = nil
  self.protect_tip = nil
  self.requestWorldDetail = nil
  self.marked_label = nil
  self.isClickSelf = nil
  base.OnDestroy(self)
end

function WorldDispatchTask:OnEnable()
  base.OnEnable(self)
end

function WorldDispatchTask:OnDisable()
  base.OnDisable(self)
end

function WorldDispatchTask:RefreshData(pointData, pointId, info)
  if info.clickByAlliance then
    self.isClickSelf = false
    self.desc:SetLocalText(456289)
  elseif info.clickByOther then
    self.isClickSelf = false
    self.desc:SetLocalText(456290)
  elseif info.clickBySelf then
    self.isClickSelf = true
    self.desc:SetLocalText(456214)
  end
  self.protectStatus = info.clickByOther and info.protectDispatchTask
  self.marked = DataCenter.ActDispatchTaskDataManager:HasMarked(pointData.uuid)
  self.marked_label:SetActive(false)
  self.time_label:SetActive(not self.protectStatus)
  self.protect_tip:SetActive(self.protectStatus)
  self.scroll_view:SetActive(not self.protectStatus)
  self.desc:SetActive(not self.protectStatus)
  self.pointId = pointId
  self.pointData = pointData
  self.completionTime = pointData.completionTime
  self:UpdateInfo()
  self:Update100MS()
end

function WorldDispatchTask:UpdateInfo()
  local detail = DataCenter.WorldPointDetailManager:GetDetailByPointId(self.pointId)
  if detail == nil or detail.uuid == nil or self.pointData == nil or self.pointData.uuid == nil or detail.uuid ~= self.pointData.uuid then
    if self.pointId and self.requestWorldDetail ~= true then
      SFSNetwork.SendMessage(MsgDefines.WorldGetDetail, self.pointId, self.view.ctrl.serverId, 0)
      self.requestWorldDetail = true
    end
  else
    local extraRewards = detail.reward
    local goItem, theItem
    self.content:RemoveComponents(UICommonResItem)
    self.theItem:GameObjectRecycleAll()
    if extraRewards ~= nil then
      for i, data in ipairs(extraRewards) do
        local theName = "item_" .. i
        goItem = self.theItem:GameObjectSpawn(self.content.transform)
        goItem.name = theName
        goItem:SetActive(true)
        theItem = self.content:AddComponent(UICommonResItem, theName)
        if data.rewardType or param.itemId then
          local buildAddNum, itemId = DataCenter.ActDispatchTaskDataManager:GetBuildAddRewardInfo()
          if self.isClickSelf and 0 < buildAddNum and tonumber(data.itemId) == itemId then
            data.isShowArrow = true
          end
          theItem:ReInit(data)
        else
          local param = {}
          param.rewardType = data.type
          if type(data.value) == "table" then
            param.itemId = data.value.id
            param.count = data.value.num
          else
            param.itemId = data.type
            param.count = data.value
          end
          param.rewardType = data.type
          param.heroUuid = data.heroUuid
          param.isHeroBox = data.isHeroBox
          local buildAddNum, itemId = DataCenter.ActDispatchTaskDataManager:GetBuildAddRewardInfo()
          if self.isClickSelf and 0 < buildAddNum and tonumber(param.itemId) == itemId then
            param.isShowArrow = true
          end
          theItem:ReInit(param)
        end
      end
    else
      Logger.LogError("WorldDispatchTask.UpdateInfo  pointId : " .. self.pointId .. " reward invalid ! ")
    end
  end
end

function WorldDispatchTask:Update100MS()
  if self.completionTime and not self.protectStatus then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.completionTime - curTime
    if 0 < remainTime then
      self.time_label:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
      self.marked_label:SetActive(false)
    else
      self.completionTime = nil
      self.time_label:SetActive(false)
      EventManager:GetInstance():Broadcast(EventId.DispatchTaskUpdateSingle)
      self.marked_label:SetActive(self.marked)
    end
  end
end

return WorldDispatchTask
