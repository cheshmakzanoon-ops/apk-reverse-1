local WorldAlMinePanel_Collect = BaseClass("WorldAlMinePanel_Collect", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local mineName_path = "layout/mineName"
local mineIcon_path = "layout/icon"
local resCount_path = "layout/resNum"
local remaintime_path = "layout/remainTime"
local memberCount_path = "layout/memberNum"
local prog_path = "layout/prog"
local selfInfo_path = "selfInfo"
local selfHead_path = "selfInfo/playerHead/UIPlayerHead/HeadIcon"
local selfName_path = "selfInfo/name"
local selfResIcon_path = "selfInfo/collected/resIcon"
local selfResCount_path = "selfInfo/collected/resCount"
local selfTime_path = "selfInfo/collected/collectTime"
local recoverInfo_path = "recoverInfo"
local recover_txt_path = "recoverInfo/recoverText"
local des_path = "layout/desc"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DelCollectTime()
  self:DelAITime()
  self:DelCountDownTimer()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  self:DelCollectTime()
  self:DelAITime()
  self:DelCountDownTimer()
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.mineNameN = self:AddComponent(UIText, mineName_path)
  self.mineIconN = self:AddComponent(UIImage, mineIcon_path)
  self.resCountN = self:AddComponent(UIText, resCount_path)
  self.remainTimeN = self:AddComponent(UIText, remaintime_path)
  self.memberCountN = self:AddComponent(UIText, memberCount_path)
  self.progN = self:AddComponent(UISlider, prog_path)
  self.selfInfoN = self:AddComponent(UIBaseContainer, selfInfo_path)
  self.selfHeadN = self:AddComponent(UIPlayerHead, selfHead_path)
  self.selfNameN = self:AddComponent(UIText, selfName_path)
  self.selfResIconN = self:AddComponent(UIImage, selfResIcon_path)
  self.selfResCountN = self:AddComponent(UIText, selfResCount_path)
  self.selfTimeN = self:AddComponent(UIText, selfTime_path)
  self.des = self:AddComponent(UIText, des_path)
  self.recoverInfo = self:AddComponent(UIBaseContainer, recoverInfo_path)
  self.recover_txt = self:AddComponent(UIText, recover_txt_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.pointId = nil
  self.mineInfo = nil
  self.mineTemplate = nil
  self.recoverEndTime = 0
  
  function self.timer_action(temp)
    self:RefreshAITime()
  end
  
  function self.timer_action_collect(temp)
    self:RefreshCollectTime()
  end
  
  function self.CountDownTimerAction()
    self:RefreshRemainTime()
  end
end

local function DataDestroy(self)
  self.pointId = nil
  self.mineInfo = nil
  self.mineTemplate = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, pointId)
  self.pointId = pointId
  self:RefreshPanel()
end

local function RefreshPanel(self)
  local detail
  local pointInfo = CS.SceneManager.World:GetPointInfo(self.pointId)
  if pointInfo then
    detail = DataCenter.WorldPointDetailManager:GetDetailByPointId(pointInfo.mainIndex)
  end
  if not detail then
    return
  end
  self.mineInfo = detail.alBuilding
  if not self.mineInfo then
    return
  end
  self.curNum = self.mineInfo.remainNum
  self.recoverEndTime = 0
  self.mineTemplate = DataCenter.AllianceMineManager:GetAllianceMineTemplate(self.mineInfo.buildId)
  if WorldAllianceBuildUtil.IsAllianceActMineGroup(self.mineInfo.buildId) == true then
    if self.mineTemplate then
      self.mineIconN:LoadSprite(self.mineTemplate:GetIconPath())
      self.mineNameN:SetText(Localization:GetString("100042") .. ": ")
      self.memberCountN:SetActive(false)
      self.remainTimeN:SetActive(false)
      self.selfInfoN:SetActive(false)
      self.des:SetActive(true)
      if self.curNum > 0 then
        self.des:SetLocalText(374021)
        if 0 < self.mineInfo.battleStartTime then
          self.recoverEndTime = self.mineTemplate.army_recover_time * 1000 + self.mineInfo.battleStartTime
        end
      else
        self.recoverEndTime = 0
        self.des:SetLocalText(374028)
      end
      if self.recoverEndTime > 0 then
        self.recoverInfo:SetActive(true)
      else
        self.recoverInfo:SetActive(false)
      end
      self.resCountN:SetLocalText(150033, string.GetFormattedStr(self.mineInfo.remainNum), string.GetFormattedStr(self.mineInfo.initNum))
      self:AddCountDownTimer()
      self:RefreshRemainTime()
      self.march = self:GetInActCollectMarch()
      if not string.IsNullOrEmpty(LuaEntry.Player.allianceId) and LuaEntry.Player.allianceId == self.mineInfo.allianceId then
        if self.march ~= nil then
          local resourceType = self.mineTemplate.collectType
          local itemId = self.mineTemplate.param
          if tonumber(resourceType) >= ResourceType.ResourceItem then
            self.selfResIconN:LoadSprite(DataCenter.ResourceItemDataManager:GetIconPath(tonumber(itemId)))
          else
            self.selfResIconN:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(tonumber(resourceType)))
          end
          self:AddCollectTime()
          self:RefreshCollectTime()
          self.selfInfoN:SetActive(true)
          local uid = LuaEntry.Player:GetUid()
          local pic = LuaEntry.Player:GetPic()
          local picVer = LuaEntry.Player.picVer
          self.selfHeadN:SetData(uid, pic, picVer)
          self.selfNameN:SetText(LuaEntry.Player.name)
        else
          self.selfInfoN:SetActive(false)
        end
      else
        self.selfInfoN:SetActive(false)
      end
    end
  else
    self:AddCountDownTimer()
    self:RefreshRemainTime()
    self:AddAlTime()
    self:RefreshAITime()
    self.memberCountN:SetActive(false)
    self.remainTimeN:SetActive(true)
    self.des:SetActive(false)
    if self.mineTemplate and self.mineInfo.status == AllianceMineStatus.Normal then
      self.mineIconN:LoadSprite(self.mineTemplate:GetIconPath())
      self.mineNameN:SetText(Localization:GetString("100042") .. ": ")
      self.march = self:GetInCollectMarch()
      if not string.IsNullOrEmpty(LuaEntry.Player.allianceId) and LuaEntry.Player.allianceId == self.mineInfo.allianceId then
        if self.march ~= nil then
          local resourceType = self.mineTemplate.collectType
          local itemId = self.mineTemplate.param
          if tonumber(resourceType) >= ResourceType.ResourceItem then
            self.selfResIconN:LoadSprite(DataCenter.ResourceItemDataManager:GetIconPath(tonumber(itemId)))
          else
            self.selfResIconN:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(tonumber(resourceType)))
          end
          self:AddCollectTime()
          self:RefreshCollectTime()
          self.selfInfoN:SetActive(true)
          local uid = LuaEntry.Player:GetUid()
          local pic = LuaEntry.Player:GetPic()
          local picVer = LuaEntry.Player.picVer
          self.selfHeadN:SetData(uid, pic, picVer)
          self.selfNameN:SetText(LuaEntry.Player.name)
        else
          self.selfInfoN:SetActive(false)
        end
      else
        self.selfInfoN:SetActive(false)
      end
      self.resCountN:SetLocalText(150033, string.GetFormattedStr(self.mineInfo.remainNum), string.GetFormattedStr(self.mineInfo.initNum))
    end
  end
end

local function AddCountDownTimer(self)
  if self.countDownTimer == nil then
    self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.CountDownTimerAction, self, false, false, false)
  end
  self.countDownTimer:Start()
end

local function RefreshRemainTime(self)
  self.curNum = self.curNum - self.mineInfo.collectSpeed
  if self.curNum <= 0 then
    self.progN:SetValue(0)
    self.resCountN:SetLocalText(150033, 0, string.GetFormattedStr(self.mineInfo.initNum))
    self.recover_txt:SetText("")
    self:DelCountDownTimer()
    return
  end
  local tempProg = self.curNum / self.mineInfo.initNum
  self.progN:SetValue(tempProg)
  self.resCountN:SetLocalText(150033, string.GetFormattedStr(self.curNum), string.GetFormattedStr(self.mineInfo.initNum))
  if 0 < self.recoverEndTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = self.recoverEndTime - curTime
    if 0 < deltaTime then
      local str = Localization:GetString("374027") .. ": " .. UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      self.recover_txt:SetText(str)
    else
      self.recover_txt:SetText("")
    end
  else
    self.recover_txt:SetText("")
  end
end

local function DelCountDownTimer(self)
  if self.countDownTimer ~= nil then
    self.countDownTimer:Stop()
    self.countDownTimer = nil
  end
end

local function AddAlTime(self)
  if self.aiTimer == nil then
    self.aiTimer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.aiTimer:Start()
end

local function RefreshAITime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.mineInfo.expireTime - curTime
  if 0 < remainTime then
    self.remainTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
  else
    self:DelAITime()
    self.remainTimeN:SetText("00:00:00")
  end
end

local function DelAITime(self)
  if self.aiTimer ~= nil then
    self.aiTimer:Stop()
    self.aiTimer = nil
  end
end

local function AddCollectTime(self)
  if self.collectTimer == nil then
    self.collectTimer = TimerManager:GetInstance():GetTimer(1, self.timer_action_collect, self, false, false, false)
  end
  self.collectTimer:Start()
end

local function RefreshCollectTime(self)
  if self.march ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.march.endTime - curTime
    local totalTime = self.march.endTime - self.march.startTime
    local curNum = (totalTime - remainTime) * self.march.collectSpd * 0.001
    local totalNum = totalTime * self.march.collectSpd * 0.001
    if 0 < remainTime then
      self.selfResCountN:SetLocalText(150033, string.GetFormattedStr(math.floor(curNum)), string.GetFormattedStr(math.floor(totalNum)))
      self.selfTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.selfResCountN:SetLocalText(150033, string.GetFormattedStr(math.floor(totalNum)), string.GetFormattedStr(math.floor(totalNum)))
      self:DelCollectTime()
      self.selfTimeN:SetText("00:00:00")
    end
  end
end

local function DelCollectTime(self)
  if self.collectTimer ~= nil then
    self.collectTimer:Stop()
    self.collectTimer = nil
  end
end

local function GetInCollectMarch()
  local list
  local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
  for _, march in pairs(selfMarch) do
    if march:GetMarchStatus() == MarchStatus.COLLECTING and march:GetMarchTargetType() == MarchTargetType.COLLECT_ALLIANCE_BUILD_RESOURCE then
      list = march
    end
  end
  return list
end

local function GetInActCollectMarch()
  local list
  local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
  for _, march in pairs(selfMarch) do
    if march:GetMarchStatus() == MarchStatus.COLLECTING_ASSISTANCE and march:GetMarchTargetType() == MarchTargetType.ASSISTANCE_COLLECT_ACT_ALLIANCE_MINE then
      list = march
    end
  end
  return list
end

WorldAlMinePanel_Collect.OnCreate = OnCreate
WorldAlMinePanel_Collect.OnDestroy = OnDestroy
WorldAlMinePanel_Collect.OnEnable = OnEnable
WorldAlMinePanel_Collect.OnDisable = OnDisable
WorldAlMinePanel_Collect.ComponentDefine = ComponentDefine
WorldAlMinePanel_Collect.ComponentDestroy = ComponentDestroy
WorldAlMinePanel_Collect.DataDefine = DataDefine
WorldAlMinePanel_Collect.DataDestroy = DataDestroy
WorldAlMinePanel_Collect.OnAddListener = OnAddListener
WorldAlMinePanel_Collect.OnRemoveListener = OnRemoveListener
WorldAlMinePanel_Collect.SetData = SetData
WorldAlMinePanel_Collect.RefreshPanel = RefreshPanel
WorldAlMinePanel_Collect.AddCountDownTimer = AddCountDownTimer
WorldAlMinePanel_Collect.RefreshRemainTime = RefreshRemainTime
WorldAlMinePanel_Collect.DelCountDownTimer = DelCountDownTimer
WorldAlMinePanel_Collect.GetInCollectMarch = GetInCollectMarch
WorldAlMinePanel_Collect.AddAlTime = AddAlTime
WorldAlMinePanel_Collect.RefreshAITime = RefreshAITime
WorldAlMinePanel_Collect.DelAITime = DelAITime
WorldAlMinePanel_Collect.GetInActCollectMarch = GetInActCollectMarch
WorldAlMinePanel_Collect.AddCollectTime = AddCollectTime
WorldAlMinePanel_Collect.RefreshCollectTime = RefreshCollectTime
WorldAlMinePanel_Collect.DelCollectTime = DelCollectTime
return WorldAlMinePanel_Collect
