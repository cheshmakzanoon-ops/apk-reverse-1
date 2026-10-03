local base = UIBaseContainer
local CaveExplorationEntranceItem = BaseClass("CaveExplorationEntranceItem", base)
local Localization = CS.GameEntry.Localization
local icon_path = "Image/icon"
local description_path = "Image/des"
local clickBtn_path = "Image/click"
local nextRewardBtn_path = "nextReward/nextRewardIcon"
local nextRewardFrame_path = "nextReward"
local nextRewardIcon_path = "nextReward/nextRewardIcon"
local bg_path = "Image"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.description = self:AddComponent(UIText, description_path)
  self.clickBtn = self:AddComponent(UIButton, clickBtn_path)
  self.nextRewardBtn = self:AddComponent(UIButton, nextRewardBtn_path)
  self.nextRewardFrame = self:AddComponent(UIImage, nextRewardFrame_path)
  self.nextRewardIcon = self:AddComponent(UIImage, nextRewardIcon_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.clickBtn:SetOnClick(function()
    self:ItemClick()
  end)
  self.nextRewardBtn:SetOnClick(function()
    self:OnNextRewardBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.description = nil
  self.clickBtn = nil
  self.nextRewardBtn = nil
  self.nextRewardFrame = nil
  self.nextRewardIcon = nil
  self.bg = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function CaveExplorationEntranceItem:SetData(configId, index, uuid, pos, eventInfo)
  self.configId = configId
  self.eventUuid = uuid
  self.index = index
  self.worldPos = pos
  self.eventInfo = eventInfo
  self.configData = DataCenter.CaveExplorationManager:GetTempData(self.configId)
  if self.configData then
    self.icon:LoadSprite(self.configData["entranceIcon" .. self.index])
    self.description:SetLocalText(self.configData["entranceDes" .. self.index], self.configData["entranceDesParam" .. self.index])
  end
  if self.eventInfo and self.eventInfo.caveInfo and self.eventInfo.caveInfo.nextLevelRewardInfo and self.configData.nextRewardIcon then
    self.nextRewardFrame:SetActive(true)
    if self.configData.nextRewardQuality == nil then
      self.nextRewardFrame:SetEnable(false)
    else
      self.nextRewardFrame:SetEnable(true)
      self.nextRewardFrame:LoadSprite(UIUtil.GetItemQualityBg(self.configData.nextRewardQuality))
    end
    self.nextRewardIcon:LoadSprite(self.configData.nextRewardIcon)
    self.bg:LoadSprite("Assets/Main/SeasonRes/S3/Sprites/UI/LWUIRadarCaveExplore/ljq_leidaduobao_anniu02.png")
  else
    self.bg:LoadSprite("Assets/Main/SeasonRes/S3/Sprites/UI/LWUIRadarCaveExplore/ljq_leidaduobao_anniu01.png")
    self.nextRewardFrame:SetActive(false)
  end
end

function CaveExplorationEntranceItem:ItemClick()
  if self.view.lockForAnimation then
    Logger.Log("lockForAnimation is true")
    return
  end
  if self.configData then
    local function callback()
      local type = self.configData["entranceType" .. self.index]
      
      local para = self.configData["entranceParam" .. self.index]
      if type == 1 then
        DataCenter.CaveExplorationManager:TryNextStep(self.eventUuid, self.configId, self.index)
      elseif type == 2 then
        if DataCenter.CaveExplorationManager:IsSynchronizing(self.eventUuid) then
          Logger.LogError("Synchronizing Data-----,self.eventUuid----:" .. self.eventUuid)
          return
        end
        local param = {}
        param.type = PVEType.Parkour
        param.levelId = tonumber(para)
        param.backWorldPos = self.worldPos
        param.caveData = {}
        param.caveData.eventUuid = self.eventUuid
        param.caveData.configId = self.configId
        param.caveData.index = self.index
        param.enterType = PVEEnterType.DetectCaveExploreEnter
        DataCenter.LWBattleManager:Enter(param)
        self.view.ctrl:CloseSelf()
      elseif type == 5 then
        if DataCenter.CaveExplorationManager:IsSynchronizing(self.eventUuid) then
          Logger.LogError("Synchronizing Data-----,self.eventUuid----:" .. self.eventUuid)
          return
        end
        local param = {}
        param.type = PVEType.Count
        param.levelId = tonumber(para)
        param.backWorldPos = self.worldPos
        param.caveData = {}
        param.caveData.eventUuid = self.eventUuid
        param.caveData.configId = self.configId
        param.caveData.index = self.index
        param.enterType = PVEEnterType.DetectCaveExploreEnter
        DataCenter.LWBattleManager:Enter(param)
        self.view.ctrl:CloseSelf()
      elseif type == 3 then
        local data = {}
        data.uuid = self.eventUuid
        data.index = self.index
        data.configId = self.configId
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectSlotBoxOpen, para, UIDetectSlotBoxPanelType.DetectCaveExplorePanelType, data)
      elseif type == 4 then
        DataCenter.CaveExplorationManager:TryNextStep(self.eventUuid, self.configId, self.index)
      end
    end
    
    local callFlag = false
    local tip = self.configData.confirmTip
    if tip and self.index == 1 then
      local localDay = CommonUtil.PlayerPrefsGetInt("RADAR_EVENT_CAVE_EXPLORE_TIP_DAILY", -1)
      local today = UITimeManager:GetInstance():GetDayOfYear(UITimeManager:GetInstance():GetServerTime())
      if localDay == -1 or today ~= localDay then
        self.ignoreTip = true
        UIUtil.ShowSecondMessageByParam({
          tipText = tip,
          btnNum = 1,
          showToggle = true,
          text1 = GameDialogDefine.CONFIRM,
          sureAction = function()
            if not self.ignoreTip then
              local day = UITimeManager:GetInstance():GetDayOfYear(UITimeManager:GetInstance():GetServerTime())
              CommonUtil.PlayerPrefsSetInt("RADAR_EVENT_CAVE_EXPLORE_TIP_DAILY", day)
            end
            callback()
          end,
          toggleAction = function(flag)
            self.ignoreTip = flag
          end,
          toggleText = Localization:GetString("blackmarket_desc9")
        })
      else
        callFlag = true
      end
    else
      callFlag = true
    end
    if callFlag then
      callback()
    end
  end
end

function CaveExplorationEntranceItem:OnNextRewardBtnClick()
  if self.eventInfo and self.eventInfo.caveInfo and self.eventInfo.caveInfo.nextLevelRewardInfo then
    local reward = DataCenter.RewardManager:ReturnRewardParamForView(self.eventInfo.caveInfo.nextLevelRewardInfo)
    local diamond = self.eventInfo.caveInfo.nextLevelRewardValue
    local parame = reward
    local x = self.nextRewardBtn.transform.position.x
    local y = self.nextRewardBtn.transform.position.y
    local width = self.nextRewardBtn.rectTransform.rect.width
    local btnAnchor = CommonBoxShowRewardTipAnchor.Right
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWCommonBoxShowRewardTip, Localization:GetString("370101", diamond), x, y, btnAnchor, width, 0, parame)
  end
end

CaveExplorationEntranceItem.OnCreate = OnCreate
CaveExplorationEntranceItem.OnDestroy = OnDestroy
CaveExplorationEntranceItem.OnEnable = OnEnable
CaveExplorationEntranceItem.OnDisable = OnDisable
CaveExplorationEntranceItem.ComponentDefine = ComponentDefine
CaveExplorationEntranceItem.ComponentDestroy = ComponentDestroy
CaveExplorationEntranceItem.DataDefine = DataDefine
CaveExplorationEntranceItem.DataDestroy = DataDestroy
return CaveExplorationEntranceItem
