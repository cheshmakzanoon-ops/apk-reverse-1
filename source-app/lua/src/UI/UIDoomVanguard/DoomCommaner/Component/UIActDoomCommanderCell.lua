local base = UIBaseContainer
local UIActDoomCommanderCell = BaseClass("UIActDoomCommanderCell", base)
local IconPath = "Assets/Main/Sprites/UI/UIDoomVanguard/UIActDoomCommaner/"
local IconImg_path = "IconImg"
local DesText_path = "DesText"
local RevicedImg_path = "RevicedImg"
local GotoBtn_path = "GotoBtn"
local GetBtn_path = "GetBtn"
local GotoBtnText_path = "GotoBtn/GotoBtnText"
local GetBtnText_path = "GetBtn/GetBtnText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.IconImg = self:AddComponent(UIImage, IconImg_path)
  self.DesText = self:AddComponent(UITextMeshProUGUIEx, DesText_path)
  self.RevicedImg = self:AddComponent(UIImage, RevicedImg_path)
  self.GotoBtn = self:AddComponent(UIButton, GotoBtn_path)
  self.GetBtn = self:AddComponent(UIButton, GetBtn_path)
  self.GotoBtnText = self:AddComponent(UITextMeshProUGUIEx, GotoBtnText_path)
  self.GetBtnText = self:AddComponent(UITextMeshProUGUIEx, GetBtnText_path)
  self.GotoBtn:SetOnClick(function()
    self:Jump()
  end)
end

local function ComponentDestroy(self)
  self.IconImg = nil
  self.DesText = nil
  self.RevicedImg = nil
  self.GotoBtn = nil
  self.GetBtn = nil
  self.GotoBtnText = nil
  self.GetBtnText = nil
end

local function DataDefine(self)
  self.timer = nil
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
end

local function DataDestroy(self)
  self.index = nil
  self.actListData = nil
  self.jumpId = nil
  self.acId = nil
  self.openTime = nil
  self.waitStrId = nil
  self.timer_action = nil
  self:DeleteTimer()
end

local function SetItem(self, index, actListData)
  self.index = index
  self.actListData = actListData
  local acId = 0
  local iconName = ""
  local jumpStrId = ""
  local finshedStrId = ""
  local waitStrId = ""
  local jumpId = 0
  local sign = 0
  local openTime = -1
  local tab = {}
  if index == DoomCommanderTaskType.Monopoly then
    tab = DataCenter.ActDoomCommanderDataManager:GetNormalDataByCfg(self.actListData.para_1)
    sign = DataCenter.ActDoomCommanderDataManager.monopolyFinish
  elseif index == DoomCommanderTaskType.Detect then
    tab = DataCenter.ActDoomCommanderDataManager:GetNormalDataByCfg(self.actListData.para_2)
    sign = DataCenter.ActDoomCommanderDataManager.detectFinish
  elseif index == DoomCommanderTaskType.AllStage then
    acId, tab = DataCenter.ActDoomCommanderDataManager:GetActDataByCfg(self.actListData.para_3)
    sign = DataCenter.ActDoomCommanderDataManager.allStageReward
  elseif index == DoomCommanderTaskType.ArenaV2 then
    acId, tab = DataCenter.ActDoomCommanderDataManager:GetActDataByCfg(self.actListData.para_4)
    sign = DataCenter.ActDoomCommanderDataManager.arenaV2Open
  elseif index == DoomCommanderTaskType.LockHart then
    acId, tab = DataCenter.ActDoomCommanderDataManager:GetActDataByCfg(self.actListData.para_5)
    sign = DataCenter.ActDoomCommanderDataManager.lockHartIsOpen
    openTime = DataCenter.ActDoomCommanderDataManager.lockHartOpenTime
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if openTime and 0 < openTime and openTime < curTime then
      sign = 2
    end
  end
  iconName = tab[1]
  jumpStrId = tab[2]
  finshedStrId = tab[3]
  if acId ~= 0 then
    waitStrId = tab[4]
    jumpId = tab[5]
  else
    jumpId = tab[4]
  end
  self.GetBtn:SetActive(false)
  if index <= 4 then
    if sign == 0 then
      self.DesText:SetLocalText(jumpStrId)
      self.GotoBtn:SetActive(true)
      self.RevicedImg:SetActive(false)
    elseif sign == 1 then
      self.DesText:SetLocalText(finshedStrId)
      self.GotoBtn:SetActive(false)
      self.RevicedImg:SetActive(true)
    end
  elseif sign == 0 then
    if openTime then
      self.DesText:SetLocalText(waitStrId, UITimeManager:GetInstance():MilliSecondToFmtString(tonumber(openTime) - UITimeManager:GetInstance():GetServerTime()))
    else
      self.DesText:SetLocalText(waitStrId)
    end
    self.GotoBtn:SetActive(false)
    self.RevicedImg:SetActive(false)
  elseif sign == 1 then
    self.DesText:SetLocalText(jumpStrId)
    self.GotoBtn:SetActive(true)
    self.RevicedImg:SetActive(false)
  elseif sign == 2 then
    self.DesText:SetLocalText(finshedStrId)
    self.GotoBtn:SetActive(false)
    self.RevicedImg:SetActive(true)
  end
  self.IconImg:LoadSprite(IconPath .. iconName)
  self.IconImg:SetNativeSize()
  self.GotoBtnText:SetLocalText(110003)
  self.jumpId = tonumber(jumpId)
  self.acId = acId
  self.openTime = tonumber(openTime)
  self.waitStrId = waitStrId
  if sign == 0 and self.openTime and 0 < self.openTime then
    self:AddTimer()
  end
end

local function Jump(self)
  if self.jumpId == 1 then
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoDabenPos()
  elseif self.jumpId == 2 then
    GoToUtil.CloseAllWindows()
    GoToUtil.GoToByTypeAndParam(QuestGoType.GoMonopolyPlaceality, {
      DataCenter.MonopolyManager.player.curId
    })
  elseif self.jumpId == 3 then
    GoToUtil.CloseAllWindows()
    GoToUtil.GoRadarProbe(30001, 15)
  elseif self.jumpId == 4 then
    GoToUtil.GoActWindow({
      tonumber(self.acId)
    }, false)
  elseif self.jumpId == 5 then
    GoToUtil.GotoCityByBuildId(BuildingTypes.LW_BUILD_PVP_ARENA, WorldTileBtnType.PVPArena)
  elseif self.jumpId == 6 then
    GoToUtil.GoActWindow({
      tonumber(self.acId)
    }, true)
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
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function RefreshTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime > self.openTime then
    self:DeleteTimer()
    SFSNetwork.SendMessage(MsgDefines.GetSevenDayActTaskInfoMessage)
  else
    self.DesText:SetLocalText(self.waitStrId, UITimeManager:GetInstance():MilliSecondToFmtString(self.openTime - curTime))
  end
end

UIActDoomCommanderCell.OnCreate = OnCreate
UIActDoomCommanderCell.OnDestroy = OnDestroy
UIActDoomCommanderCell.OnEnable = OnEnable
UIActDoomCommanderCell.OnDisable = OnDisable
UIActDoomCommanderCell.ComponentDefine = ComponentDefine
UIActDoomCommanderCell.ComponentDestroy = ComponentDestroy
UIActDoomCommanderCell.DataDefine = DataDefine
UIActDoomCommanderCell.DataDestroy = DataDestroy
UIActDoomCommanderCell.SetItem = SetItem
UIActDoomCommanderCell.Jump = Jump
UIActDoomCommanderCell.DeleteTimer = DeleteTimer
UIActDoomCommanderCell.AddTimer = AddTimer
UIActDoomCommanderCell.RefreshTime = RefreshTime
return UIActDoomCommanderCell
