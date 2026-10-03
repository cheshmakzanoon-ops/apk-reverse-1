local WorldTreasureDetect = BaseClass("WorldTreasureDetect", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
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
local timeBg_path = "time/bg"
local noneTip_path = "time/noneTip"
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
  self.timeBg = self:AddComponent(UIBaseContainer, timeBg_path)
  self.noneTip = self:AddComponent(UIText, noneTip_path)
  self.noneTip:SetLocalText("detect_dig_tips_stop")
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
  self.timeBg = nil
  self.noneTip = nil
end

local function DataDefine(self)
  self.data = nil
  self.model = {}
end

local function DataDestroy(self)
  self.data = nil
  self.model = nil
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
end

local function RefreshData(self, param)
  self:SetAllCellDestroy()
  self.data = param
  self:RefreshTime()
  if self.data.pointData.startTime <= 0 then
    self.unStartContent:SetActive(true)
    self.startContent:SetActive(false)
    self.descTxt:SetLocalText(self.data.des)
    self.timeBg:SetActive(false)
    self.noneTip:SetActive(true)
  else
    self.unStartContent:SetActive(false)
    self.startContent:SetActive(true)
    local speed = toInt(self.data.pointData.speed * 100)
    local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(self.data.pointData.eventId)
    if template and template:JudgeIsDroneTreasure() then
      self.memberTip:SetLocalText("radar_tips_12")
      self.speedTip:SetLocalText("radar_tips_13", speed)
    else
      self.memberTip:SetLocalText("801350")
      self.speedTip:SetLocalText("801351", speed)
    end
    local list = self.data.pointData.diggingUserList
    local showList = {}
    for k, v in pairs(list) do
      local showData = {}
      showData.uid = v.Uid
      showData.pic = v.Pic
      showData.picVer = v.PicVer
      table.insert(showList, showData)
    end
    self.memberNum:SetText(string.format("(%d)", #showList))
    self:AddHeadToContainer(showList, self.scrollContent)
    if 0 < #showList then
      self.timeBg:SetActive(true)
      self.noneTip:SetActive(false)
    else
      self.timeBg:SetActive(false)
      self.noneTip:SetActive(true)
    end
  end
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
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(0.5, self.RefreshTime, self, false, false, false)
  end
  self.timer:Start()
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
    local percentShow = toInt(percent * 100)
    self.progressNum:SetText(percentShow .. "%")
    local fillSize = self.progress:GetSizeDelta()
    self.progressAmount:SetSizeDelta(Vector2(percent * fillSize.x, fillSize.y))
    if deltaTime < 0 then
      self.view.ctrl:CloseSelf()
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
WorldTreasureDetect.RefreshTime = RefreshTime
WorldTreasureDetect.RefreshData = RefreshData
WorldTreasureDetect.SetAllCellDestroy = SetAllCellDestroy
WorldTreasureDetect.AddHeadToContainer = AddHeadToContainer
return WorldTreasureDetect
