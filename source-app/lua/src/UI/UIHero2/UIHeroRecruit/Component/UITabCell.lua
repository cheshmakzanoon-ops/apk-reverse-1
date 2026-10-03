local UITabCell = BaseClass("UITabCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local refreshWorkerRedPointTime = 0

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
  self:AddComponent(UIButton, ""):SetOnClick(BindCallback(self, self.OnBtnClick))
  self.imgIcon = self:AddComponent(UIImage, "")
  self.textName = self:AddComponent(UIText, "TextName")
  self.nodeTime = self:AddComponent(UIText, "ImgTimeBg")
  self.textTime = self:AddComponent(UIText, "ImgTimeBg/TextTime")
  self.imgGray = self:AddComponent(UIText, "ImgGray")
  self.imgSelect = self:AddComponent(UIImage, "ImgSelect")
  self.redPoint = self:AddComponent(UIBaseContainer, "RedPoint")
  self.arrowPoint = self:AddComponent(UIBaseContainer, "Rect_ArrowPoint")
  self.tabImgIcon = self:AddComponent(UIImage, "ImgIcon")
  self.nodeTime:SetActive(false)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.lotteryId = nil
  self.lotteryData = nil
  self.idx = -1
  self.callBack = nil
end

local function DataDestroy(self)
  self.lotteryId = nil
  self.lotteryData = nil
  self.callBack = nil
  self.idx = nil
end

local function SetData_bk(self, idx, lotteryData, callBack)
  self.idx = idx
  self.lotteryData = lotteryData
  self.callBack = callBack
  self.textName:SetLocalText(self.lotteryData.name)
  self:UpdateRedPoint()
  self:UpdateSelect()
end

local function SetData(self, idx, lotteryData, callBack)
  self.imgGray:SetActive(false)
  if lotteryData.type == OfficerRecruitType.WorkerRecruit then
    self:SetWorkerData(idx, lotteryData, callBack)
  else
    self:SetHeroData(idx, lotteryData, callBack)
  end
end

local function SetWorkerData(self, idx, lotteryData, callBack)
  self.idx = idx
  self.lotteryId = lotteryData.id
  self.lotteryData = lotteryData
  self.callBack = callBack
  self.tabImgIcon:LoadSpriteAsyncWithCallback(lotteryData:GetIconName(), function()
    if self.tabImgIcon then
      self.tabImgIcon:SetNativeSize()
    end
  end)
  self.imgSelect:LoadSprite(lotteryData:GetTabBgName())
  self.textName:SetLocalText(151137)
  self:UpdateSelect()
  self:UpdateWorkerRedPoint()
  local unlock, lockTips = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.Worker_Lottery)
  self.imgGray:SetActive(not unlock)
end

local function SetHeroData(self, idx, lotteryData, callBack)
  self.idx = idx
  self.lotteryId = lotteryData.id
  self.lotteryData = lotteryData
  self.callBack = callBack
  self.IsOpen = false
  if self.lotteryData ~= nil then
    self.IsOpen = self.lotteryData:IsOpen()
  end
  self.tabImgIcon:LoadSprite(lotteryData:GetIconName())
  self.tabImgIcon:SetNativeSize()
  self.imgSelect:LoadSprite(lotteryData:GetTabBgName())
  self.textName:SetLocalText(lotteryData.name or GetTableData(TableName.HeroRecruit, self.lotteryId, "name"))
  self:UpdateRedPoint()
  self:UpdateSelect()
  local gray = self.lotteryData.startTime > UITimeManager:GetInstance():GetServerTime()
  UIGray.SetGray(self.transform, gray, true)
end

local function OnBtnClick(self)
  if self.lotteryData.type == OfficerRecruitType.WorkerRecruit then
    local unlock, lockTips = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.Worker_Lottery)
    if not unlock then
      UIUtil.ShowTipsId(lockTips)
      return
    end
  end
  if self.callBack ~= nil then
    self.callBack(self.idx)
  end
end

local function UpdateSelect(self)
  self.imgSelect:SetActive(self.idx == self.view.currentTabIdx)
end

local function UpdateRedPoint(self)
  if self.lotteryId == nil then
    return
  end
  self.lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(self.lotteryId)
  if self.lotteryData == nil then
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if not (self.lotteryData ~= nil and self.lotteryData:IsOpen()) or now < self.lotteryData.startTime and now < self.lotteryData.endTime then
    self.redPoint:SetActive(false)
    return
  end
  local supportFreeRecruit = self.lotteryData:IsSupportFreeRecruit()
  local canFreeRecruit = self.lotteryData:CanFreeRecruit()
  if supportFreeRecruit and canFreeRecruit then
    self.redPoint:SetActive(true)
    return
  end
  if self.lotteryData:IsCanClaimWish() then
    self.redPoint:SetActive(true)
    return
  end
  local costItems = self.lotteryData:GetCostItems()
  local costResources = self.lotteryData:GetCostResources()
  if costResources ~= nil and table.count(costResources) > 0 then
    local resId = costResources[1]
    local resCount = costResources[1].num * self.lotteryData.dailyTimes
    local resEnough = CommonUtil.CheckIsResourceEnough(resId, resCount)
    self.redPoint:SetActive(resEnough)
  elseif table.count(costItems) > 1 then
    local itemId = costItems[1].itemId
    local itemNum = costItems[1].itemNum
    local item = DataCenter.ItemData:GetItemById(itemId)
    local have = item and item.count or 0
    local visible = itemNum <= have
    self.redPoint:SetActive(visible)
  end
end

local function UpdateWorkerRedPoint(self)
  local isHave = DataCenter.WorkerLotteryDataManager:IsHaveWorkerLotteryData()
  local unlock, lockTips = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.Worker_Lottery)
  local workerLotteryInfo = DataCenter.WorkerLotteryDataManager:GetWorkerLotteryData()
  local canFreeRecruit = workerLotteryInfo:CanFreeRecruit()
  self.redPoint:SetActive(isHave and unlock and canFreeRecruit)
end

local function Update(self)
  if self.lotteryData ~= nil then
    if self.lotteryData.type == OfficerRecruitType.HeroRecruit then
      local tmp = self.lotteryData:IsOpen()
      if self.IsOpen ~= tmp then
        self.IsOpen = tmp
        self.view.ctrl:GetDataFromServer()
      end
    else
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if curTime > refreshWorkerRedPointTime + 2000 then
        refreshWorkerRedPointTime = curTime
        self:UpdateWorkerRedPoint()
      end
    end
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.HeroicRecruitmentData, self.UpdateRedPoint)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.HeroicRecruitmentData, self.UpdateRedPoint)
  base.OnRemoveListener(self)
end

local function GetPosition(self)
  return self.arrowPoint.transform.position
end

UITabCell.OnCreate = OnCreate
UITabCell.OnDestroy = OnDestroy
UITabCell.OnEnable = OnEnable
UITabCell.OnDisable = OnDisable
UITabCell.ComponentDefine = ComponentDefine
UITabCell.ComponentDestroy = ComponentDestroy
UITabCell.DataDefine = DataDefine
UITabCell.DataDestroy = DataDestroy
UITabCell.SetData = SetData
UITabCell.SetHeroData = SetHeroData
UITabCell.SetWorkerData = SetWorkerData
UITabCell.Update = Update
UITabCell.OnBtnClick = OnBtnClick
UITabCell.UpdateSelect = UpdateSelect
UITabCell.UpdateRedPoint = UpdateRedPoint
UITabCell.UpdateWorkerRedPoint = UpdateWorkerRedPoint
UITabCell.OnAddListener = OnAddListener
UITabCell.OnRemoveListener = OnRemoveListener
UITabCell.GetPosition = GetPosition
return UITabCell
