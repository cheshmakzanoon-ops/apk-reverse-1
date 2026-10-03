local WorldTreasureDetect = BaseClass("WorldTreasureDetect", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local RewardItem = require("UI.UIWorldPoint.Component.WorldPointRewardItem")
local UIWorldPlayerHead = require("UI.UIWorldPoint.Component.UIWorldPlayerHead")
local timeLabel_path = "time/bg/timeIcon/timeLabel"
local unStartContent_path = "unStartContent"
local descTxt_path = "unStartContent/descBg/descTxt"
local startContent_path = "startContent"
local scrollContent_path = "startContent/ScrollView/Viewport/scrollContent"
local progress_path = "startContent/infoContent/progress"
local progressAmount_path = "startContent/infoContent/progress/progressAmount"
local progressNum_path = "startContent/infoContent/progress/progressNum"
local speedTip_path = "startContent/infoContent/speedTip"
local memberTip_path = "startContent/infoContent/membeNumInfo/memberTip"
local memberNum_path = "startContent/infoContent/membeNumInfo/memberNum"
local owner_txt_path = "OwnerContent/OwnerTxt"
local thumbs_up_path = "Like"
local content2_path = "rewardContent/ScrollView2/Viewport/Content2"
local time_tip_content_path = "timeTipContent"
local time_tip_txt_path = "timeTipContent/timeTipTxt"
local NameCount = 0

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:SetAllCellDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  self:AddTimer()
  base.OnEnable(self)
end

local function OnDisable(self)
  self:DeleteTimer()
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.timeLabel = self:AddComponent(UIText, timeLabel_path)
  self.unStartContent = self:AddComponent(UIBaseContainer, unStartContent_path)
  self.startContent = self:AddComponent(UIBaseContainer, startContent_path)
  self.descTxt = self:AddComponent(UIText, descTxt_path)
  self.scrollContent = self:AddComponent(UIBaseContainer, scrollContent_path)
  self.progress = self:AddComponent(UIBaseContainer, progress_path)
  self.progressAmount = self:AddComponent(UIBaseContainer, progressAmount_path)
  self.progressNum = self:AddComponent(UIText, progressNum_path)
  self.speedTip = self:AddComponent(UIText, speedTip_path)
  self.memberTip = self:AddComponent(UIText, memberTip_path)
  self.memberNum = self:AddComponent(UIText, memberNum_path)
  self.owner_txt = self:AddComponent(UITextMeshProUGUIEx, owner_txt_path)
  self.content2 = self:AddComponent(UIBaseContainer, content2_path)
  self.thumbsUpRoot = self:AddComponent(UIButton, thumbs_up_path)
  self.thumbsUpRoot:SetOnClick(function()
    self:OnClickThumbsUp()
  end)
  self.time_tip_content = self:AddComponent(UIBaseContainer, time_tip_content_path)
  self.time_tip_txt = self:AddComponent(UITextMeshProUGUIEx, time_tip_txt_path)
end

local function ComponentDestroy(self)
  self.timeLabel = nil
  self.unStartContent = nil
  self.startContent = nil
  self.descTxt = nil
  self.scrollContent = nil
  self.progress = nil
  self.progressAmount = nil
  self.progressNum = nil
  self.speedTip = nil
  self.memberTip = nil
  self.memberNum = nil
  self.time_tip_content = nil
  self.time_tip_txt = nil
end

local function DataDefine(self)
  self.data = nil
  self.model = {}
  self.rewardItem = {}
  self.temp = nil
end

local function DataDestroy(self)
  self.data = nil
  self.model = nil
  self.rewardItem = nil
  self.temp = nil
end

local function SetAllCellDestroy(self)
  self.scrollContent:RemoveComponents(UIWorldPlayerHead)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
  self.content2:RemoveComponents(RewardItem)
  if self.rewardItem ~= nil then
    for k, v in pairs(self.rewardItem) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.rewardItem = {}
end

local function RefreshData(self, param)
  self.data = param
  self:RefreshStartContent(self.data.pointData)
  local detectEventTemplate = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(self.data.pointData.eventId)
  self.temp = detectEventTemplate
  self.show_reward_list = {}
  local showRewardStr = detectEventTemplate.show_reward
  local showRewardDataList = string.string2array_i(showRewardStr, ";", "|")
  for i = 1, #showRewardDataList do
    if #showRewardDataList[i] == 3 then
      local itemData = {}
      itemData.rewardType = showRewardDataList[i][1]
      itemData.itemId = showRewardDataList[i][2]
      itemData.count = showRewardDataList[i][3]
      table.insert(self.show_reward_list, itemData)
    end
  end
  self:AddRewardToContainer(self.show_reward_list, self.content2)
  local ownerTxt = self.data.pointData.ownerName
  if self.data.pointData.allianceAbbr and self.data.pointData.allianceAbbr ~= "" then
    ownerTxt = "[" .. self.data.pointData.allianceAbbr .. "]" .. self.data.pointData.ownerName
  end
  self.owner_txt:SetText(ownerTxt)
  self:SyncPointDataFromCSharp()
  self:RefreshTime()
end

local function AddHeadToContainer(self, list, container)
  if list ~= nil and container then
    local num = 0
    for i = 1, table.length(list) do
      num = num + 1
      self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UIWorldPlayerHead, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(container.transform)
        go.transform:Set_localScale(0.6, 0.6, 0.6)
        go.transform:Set_sizeDelta(216, 216)
        go.transform:Set_pivot(0, 1)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = container:AddComponent(UIWorldPlayerHead, nameStr)
        local data = list[i]
        cell:SetHead(data.uid, data.pic, data.picVer)
      end)
    end
  end
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
  if self.syncTimer ~= nil then
    self.syncTimer:Stop()
    self.syncTimer = nil
  end
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.RefreshTime, self, false, true, false)
  end
  self.timer:Start()
  if self.syncTimer == nil then
    self.syncTimer = TimerManager:GetInstance():GetTimer(1, self.SyncPointDataFromCSharp, self, false, false, false)
  end
  self.syncTimer:Start()
end

local function RefreshStartContent(self, info)
  if info == nil then
    return
  end
  if info.startTime <= 0 then
    self.unStartContent:SetActive(false)
    self.startContent:SetActive(false)
    return
  end
  self.unStartContent:SetActive(false)
  self.startContent:SetActive(true)
  local speed = toInt(info.speed * 100)
  local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(info.eventId)
  if template and template:JudgeIsDroneTreasure() then
    self.memberTip:SetLocalText("radar_tips_12")
    self.speedTip:SetLocalText("radar_tips_13", speed)
  else
    self.memberTip:SetLocalText("activity_wajueji_27000_tips2")
    self.speedTip:SetLocalText("activity_wajueji_27000_tips3", speed)
  end
  local list = info.diggingUserList or {}
  local showList = {}
  for _, v in pairs(list) do
    local showData = {}
    showData.uid = v.Uid
    showData.pic = v.Pic
    showData.picVer = v.PicVer
    table.insert(showList, showData)
  end
  self.memberNum:SetText(string.format("(%d)", #showList))
  self.scrollContent:RemoveComponents(UIWorldPlayerHead)
  if self.model ~= nil then
    for _, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
  self:AddHeadToContainer(showList, self.scrollContent)
end

local function SyncPointDataFromCSharp(self)
  if self.data == nil or self.data.pointData == nil or self.data.pointData.uuid == nil then
    return
  end
  local info = CS.SceneManager.World:GetPointInfoByUuid(self.data.pointData.uuid)
  if info == nil then
    return
  end
  if info.startTime ~= self.data.pointData.startTime or info.completionTime ~= self.data.pointData.completionTime or info.expireTime ~= self.data.pointData.expireTime then
    self.data.pointData = info
    if info.startTime > 0 then
      self.data.refreshTime = info.completionTime
    else
      self.data.refreshTime = info.expireTime
    end
    self:RefreshStartContent(info)
  end
end

local function RefreshTime(self)
  if self.data == nil or self.data.refreshTime == nil then
    self.timeLabel:SetText("")
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = self.data.refreshTime - curTime
  if 0 < deltaTime then
    self.timeLabel:SetText(UITimeManager:GetInstance():MilliSecondToFmtStringFloor(deltaTime))
  else
    self.timeLabel:SetText("")
  end
  if 0 < self.data.pointData.startTime then
    local startTime = self.data.pointData.startTime
    local completionTime = self.data.pointData.completionTime
    local totalTime = completionTime - startTime
    local goTime = curTime - startTime
    local percent = 0 < totalTime and 1.0 * goTime / totalTime or 1
    if 1 < percent then
      percent = 1
    end
    local percentShow = toInt(percent * 100)
    self.progressNum:SetText(percentShow .. "%")
    local fillSize = self.progress:GetSizeDelta()
    self.progressAmount:SetSizeDelta(Vector2(percent * fillSize.x, fillSize.y))
    if deltaTime < 0 then
      self.view.ctrl:CloseSelf()
    end
  end
  if self.temp and 0 < self.temp.share_para and 0 < self.data.pointData.createTime then
    self.time_tip_content:SetActive(true)
    local shareTime = self.data.pointData.createTime + self.temp.share_para * 1000
    if curTime > shareTime then
      self.time_tip_txt:SetLocalText("activity_wajueji_27001_tips2")
    else
      local deltaTime = shareTime - curTime
      local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      self.time_tip_txt:SetLocalText("activity_wajueji_27001_tips1", timeStr)
    end
  else
    self.time_tip_content:SetActive(false)
  end
end

local function OnClickThumbsUp(self)
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local eventId = self.data.pointData.eventId
  InteractiveUtil.TryThumbsUp(self.data.pointData.ownerUid, InteractiveUtil.ThumbsUpType.ActRadarTreasure, tostring(eventId), function()
    UIUtil.ShowTipsId("activity_sports_uitips_021")
  end, tostring(self.data.pointData.uuid))
  self.view.ctrl:CloseSelf()
end

local function AddRewardToContainer(self, list, container)
  if list ~= nil and container then
    container:RemoveComponents(RewardItem)
    if self.rewardItem[container] then
      for _, v in pairs(self.rewardItem[container]) do
        if v ~= nil then
          v:Destroy()
        end
      end
    end
    self.rewardItem = {}
    self.rewardItem[container] = {}
    local num = 0
    for i = 1, table.length(list) do
      num = num + 1
      self.rewardItem[container][i] = self:GameObjectInstantiateAsync(UIAssets.WorldPointRewardItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(container.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:Set_sizeDelta(150, 150)
        go.transform:Set_pivot(0, 1)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = container:AddComponent(RewardItem, nameStr)
        cell:RefreshData(list[i], self.view.ctrl.type)
      end)
    end
    if self.data.exp ~= nil and self.data.exp > 0 then
      self.rewardItem[container][num + 1] = self:GameObjectInstantiateAsync(UIAssets.WorldPointRewardItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(container.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local oneData = {}
        oneData.count = self.data.exp
        oneData.itemColor = "Assets/Main/Sprites/ItemIcons/Common_img_quality_green"
        oneData.iconName = "Assets/Main/Sprites/ItemIcons/item230001.png"
        oneData.itemFlag = ""
        oneData.rewardType = RewardType.EXP
        oneData.itemName = Localization:GetString("100083")
        oneData.itemDesc = Localization:GetString("302010", string.GetFormattedSeperatorNum(self.data.exp))
        oneData.isLocal = true
        local cell = container:AddComponent(RewardItem, nameStr)
        cell:RefreshData(oneData)
      end)
    end
  end
end

WorldTreasureDetect.OnCreate = OnCreate
WorldTreasureDetect.OnDestroy = OnDestroy
WorldTreasureDetect.OnEnable = OnEnable
WorldTreasureDetect.OnDisable = OnDisable
WorldTreasureDetect.ComponentDefine = ComponentDefine
WorldTreasureDetect.ComponentDestroy = ComponentDestroy
WorldTreasureDetect.DataDefine = DataDefine
WorldTreasureDetect.DataDestroy = DataDestroy
WorldTreasureDetect.AddTimer = AddTimer
WorldTreasureDetect.DeleteTimer = DeleteTimer
WorldTreasureDetect.SyncPointDataFromCSharp = SyncPointDataFromCSharp
WorldTreasureDetect.RefreshTime = RefreshTime
WorldTreasureDetect.RefreshData = RefreshData
WorldTreasureDetect.RefreshStartContent = RefreshStartContent
WorldTreasureDetect.SetAllCellDestroy = SetAllCellDestroy
WorldTreasureDetect.AddHeadToContainer = AddHeadToContainer
WorldTreasureDetect.OnClickThumbsUp = OnClickThumbsUp
WorldTreasureDetect.AddRewardToContainer = AddRewardToContainer
return WorldTreasureDetect
