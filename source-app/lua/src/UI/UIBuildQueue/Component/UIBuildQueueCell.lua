local UIBuildQueueCell = BaseClass("UIBuildQueueCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Param = DataClass("Param", ParamData)
local ParamData = {
  uuid,
  index,
  enterParam
}
local SliderLength = 455
local icon_path = "Common_img_construction"
local build_name_text_path = "Layout/BuildNameText"
local des_text_path = "Layout/BuildDesText"
local slider_path = "Layout/TimeSlider_up"
local goto_btn_path = "TimeButton"
local goto_btn_name_path = "TimeButton/btnTxt_green_big_new"
local common_red_point_path = "TimeButton/CommonRedPoint"
local EMPTY_ICON = "Assets/Main/Sprites/UI/UIBuildQueue/cfm_jianzaoduilie_kongxian.png"
local LOCK_ICON = "Assets/Main/Sprites/UI/UIBuildQueue/wxy_jianzao_gongrentou.png"
local GREEN_BTN = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_2.png"
local BLUE_BTN = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_3.png"
local rentQueueCountDown_text_path = "RentQueueCountDown_Text"
local lock_icon_path = "LockIcon"
local unlock_bg_path = "UnlockBg"
local lock_bg_path = "LockBg"
local order_text_path = "OrderImage/OrderText"
local worker_head_mask_path = "WorkerHeadMask"

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
  self.icon = self:AddComponent(UIImage, icon_path)
  self.build_name_text = self:AddComponent(UIText, build_name_text_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
  self.goto_btn_img = self:AddComponent(UIImage, goto_btn_path)
  self.goto_btn_name = self:AddComponent(UIText, goto_btn_name_path)
  self.goto_btn_name_shadow = self:AddComponent(UIShadow, goto_btn_name_path)
  self.des_text = self:AddComponent(UIText, des_text_path)
  self.goto_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  self.rentQueueCountDown_text = self:AddComponent(UIText, rentQueueCountDown_text_path)
  self.lock_icon = self:AddComponent(UIImage, lock_icon_path)
  self.unlockBg = self:AddComponent(UIImage, unlock_bg_path)
  self.lockBg = self:AddComponent(UIImage, lock_bg_path)
  self.orderText = self:AddComponent(UIText, order_text_path)
  self.workerHeadMask = self:AddComponent(UIImage, worker_head_mask_path)
  self.commonRedPoint = self:AddComponent(UICommonRedPoint, common_red_point_path)
  self.commonRedPoint:SetType(CommonRedPointPriority.Level1, CommonRedPointExtraType.Add)
end

local function ComponentDestroy(self)
  self.icon = nil
  self.build_name_text = nil
  self.slider = nil
  self.slider_text = nil
  self.goto_btn = nil
  self.goto_btn_name = nil
  self.des_text = nil
  self.goto_btn_img = nil
  self.goto_btn_name_shadow = nil
  self.rentQueueCountDown_text = nil
  self.lock_icon = nil
  self.unlockBg = nil
  self.lockBg = nil
  self.orderText = nil
  self.workerHeadMask = nil
  self.commonRedPoint = nil
end

local function DataDefine(self)
  self.param = {}
  self.endTime = 0
  self.startTime = 0
  self.laseTime = 0
  self.lastCurTime = 0
  self.state = nil
  self.refreshRentCountDown = false
end

local function DataDestroy(self)
  self.param = nil
  self.endTime = nil
  self.startTime = nil
  self.laseTime = nil
  self.lastCurTime = nil
  self.state = nil
  self.refreshRentCountDown = nil
end

local function GetCurState(self)
  if self.queueInfo then
    if self.queueInfo:IsViewLocked() then
      return UIBuildQueueState.Locked
    elseif self.queueInfo:IsFreeQueueToUse() then
      return UIBuildQueueState.Free
    else
      return UIBuildQueueState.Work
    end
  else
    return UIBuildQueueState.Locked
  end
end

local function ReInit(self, param)
  self.param = param
  if param.uuid then
    self.queueInfo = DataCenter.BuildQueueManager:GetQueueByUuid(param.uuid)
    self.state = GetCurState(self)
  else
    return
  end
  if self.queueInfo and self.queueInfo.order then
    self.orderText:SetText(self.queueInfo.order)
  else
    self.orderText:SetText("")
  end
  self:RefreshState()
  self:RefreshSlider(UITimeManager:GetInstance():GetServerTime())
end

local function OnBtnClick(self)
  if self.state == UIBuildQueueState.Free then
    if self.param.enterParam ~= nil then
      if self.param.enterParam.enterType == UIBuildQueueEnterType.Build then
        local state = DataCenter.BuildManager:GetBuildState(self.param.enterParam.buildId)
        if state == BuildState.BUILD_LIST_RECEIVED or state == BuildState.BUILD_LIST_STATE_OK then
          if self.param.enterParam.point == nil then
            self.param.enterParam.point = BuildingUtils.GetPointByBuildCanPut(self.param.enterParam.buildId, SceneUtils.WorldToTileIndex(CS.SceneManager.World.CurTarget))
          end
          local uuid = self.param.enterParam.uuid
          local buildId = self.param.enterParam.buildId
          local point = self.param.enterParam.point
          GoToUtil.CloseAllWindows()
          if uuid ~= 0 then
            BuildingUtils.ShowPutBuild(buildId, PlaceBuildType.Replace, uuid, point)
          else
            BuildingUtils.ShowPutBuild(buildId, PlaceBuildType.Build, 0, point)
          end
          return
        end
      elseif self.param.enterParam.enterType == UIBuildQueueEnterType.Upgrade and DataCenter.BuildManager:GetBuildCanUpgrade(self.param.enterParam.uuid) then
        SFSNetwork.SendMessage(MsgDefines.FreeBuildingUpNew, self.param.enterParam.messageParam)
        GoToUtil.CloseAllWindows()
        return
      end
    end
    local list = DataCenter.BuildManager:GetCanUpgradeBuildUuidListFilterd(true)
    if 0 < table.count(list) then
      table.sort(list, function(a, b)
        local retA = DataCenter.BuildManager:CheckBuildUpgradeResAndItem(a)
        local retB = DataCenter.BuildManager:CheckBuildUpgradeResAndItem(b)
        if retA.enough ~= retB.enough then
          return retA.enough and true or false
        end
        local buildDataA = DataCenter.BuildManager:GetBuildingDataByUuid(a)
        local buildDataB = DataCenter.BuildManager:GetBuildingDataByUuid(b)
        return buildDataA.level < buildDataB.level
      end)
      local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(list[1])
      GoToUtil.GotoCityByBuildUuid(buildData.uuid, WorldTileBtnType.City_Upgrade)
    else
      UIUtil.ShowTipsId("build_queue_tips_1")
    end
  elseif self.state == UIBuildQueueState.Work then
    if self.queueInfo ~= nil then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, {anim = true}, ItemSpdMenu.ItemSpdMenu_City, self.queueInfo.occupyUuid)
    end
  elseif self.state == UIBuildQueueState.Locked and self.queueInfo then
    local allPreUnlock, unlockOrder = DataCenter.BuildQueueManager:IsAllPreQueueUnlock(self.queueInfo.order)
    if allPreUnlock then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWWorkerQueue, self.queueInfo.id)
    else
      local hasInExpireRentQueue, notExpireRentQueueId = DataCenter.BuildQueueManager:HasNotExpireRentQueue()
      if hasInExpireRentQueue then
        local hasLockAndNotRentQueue, order = DataCenter.BuildQueueManager:HasLockAndNotRentQueue(self.queueInfo.order)
        if hasLockAndNotRentQueue then
          UIUtil.ShowTips(Localization:GetString("building_queue_unlock_tips01", order))
        else
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWWorkerQueue, notExpireRentQueueId)
        end
      else
        UIUtil.ShowTips(Localization:GetString("building_queue_unlock_tips01", unlockOrder))
      end
    end
  end
end

local function RefreshSlider(self, curTime)
  if self.state == UIBuildQueueState.Work then
    local changeTime = self.endTime - curTime
    local maxTime = self.endTime - self.startTime
    if 0 < changeTime then
      local tempTimeSec = math.ceil(changeTime / 1000)
      if tempTimeSec ~= self.laseTime then
        self.laseTime = tempTimeSec
        local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(changeTime)
        self.des_text:SetText(Localization:GetString(100238) .. " " .. tempTimeValue)
      end
      if 0 < maxTime then
        local tempValue = 1 - changeTime / maxTime
        if TimeBarUtil.CheckIsNeedChangeBar(changeTime, self.endTime - self.lastCurTime, maxTime, SliderLength) then
          self.lastCurTime = curTime
          self.slider:SetValue(tempValue)
        end
      end
    else
      local state = GetCurState(self)
      self:ChangeState(state)
    end
  end
  if self.refreshRentCountDown and self.queueInfo then
    local countDown = self.queueInfo.expireTime - curTime
    if 0 < countDown then
      self.rentQueueCountDown_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(countDown))
    else
      self.refreshRentCountDown = false
      self.rentQueueCountDown_text:SetText("")
      self:RefreshState()
    end
  end
end

local function RefreshState(self)
  if not self.queueInfo then
    return
  end
  if self.state == UIBuildQueueState.Free then
    self.icon:LoadSprite(EMPTY_ICON)
    self.icon:SetNativeSize()
    self.icon.transform.localScale = UIBuildQueueImageTypeScale.Unlock
    self.des_text.gameObject:SetActive(false)
    self.build_name_text:SetLocalText(130077)
    self.slider:SetValue(0)
    self.slider.gameObject:SetActive(false)
    self.goto_btn:SetActive(true)
    self.goto_btn_img:LoadSprite(BLUE_BTN)
    if self.param.enterParam ~= nil then
      if self.param.enterParam.enterType == UIBuildQueueEnterType.Build then
        self.goto_btn_name:SetLocalText(GameDialogDefine.BUILD)
      elseif self.param.enterParam.enterType == UIBuildQueueEnterType.Upgrade then
        self.goto_btn_name:SetLocalText(GameDialogDefine.UPGRADE)
      end
    else
      self.goto_btn_name:SetLocalText(110015)
    end
    if self.queueInfo:IsRentQueue() then
      self.rentQueueCountDown_text:SetActive(true)
      self.rentQueueCountDown_text:SetText("")
      self.refreshRentCountDown = true
    else
      self.rentQueueCountDown_text:SetActive(false)
      self.refreshRentCountDown = false
    end
    CS.UIGray.SetGray(self.goto_btn.transform, false, true)
    CS.UIGray.SetGray(self.icon.transform, false, true)
    self.lock_icon:SetActive(false)
    self.unlockBg:SetActive(true)
    self.lockBg:SetActive(false)
    self.workerHeadMask:SetActive(false)
  elseif self.state == UIBuildQueueState.Work then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.queueInfo.occupyUuid)
    if buildData ~= nil then
      self.des_text.gameObject:SetActive(true)
      self.slider.gameObject:SetActive(true)
      self.endTime = buildData.updateTime
      local cur = UITimeManager:GetInstance():GetServerTime()
      self.startTime = buildData.startTime
      if cur < self.startTime then
        self.startTime = cur
      end
      self.icon:LoadSpriteAsyncWithCallback(DataCenter.BuildManager:GetBuildIconPath(buildData.itemId, buildData.level), function()
        if self and self.icon then
          self.icon:SetNativeSize()
        end
      end)
      self.icon.transform.localScale = UIBuildQueueImageTypeScale.Build
      local template = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildData.itemId)
      if template ~= nil then
        if buildData.level == 0 then
          self.build_name_text:SetLocalText(130084, Localization:GetString(template.name))
        else
          self.build_name_text:SetLocalText(135214, tostring(buildData.level), Localization:GetString(template.name))
        end
      end
      if 0 < buildData.level or buildData.isWorldBuild then
        self.goto_btn:SetActive(true)
        self.goto_btn_img:LoadSprite(BLUE_BTN)
        self.goto_btn_name:SetLocalText(GameDialogDefine.ADD_SPEED)
      else
        self.goto_btn:SetActive(false)
      end
    end
    if self.queueInfo:IsRentQueue() then
      self.rentQueueCountDown_text:SetActive(true)
      self.rentQueueCountDown_text:SetText("")
      self.refreshRentCountDown = true
    else
      self.rentQueueCountDown_text:SetActive(false)
      self.refreshRentCountDown = false
    end
    CS.UIGray.SetGray(self.goto_btn.transform, false, true)
    CS.UIGray.SetGray(self.icon.transform, false, true)
    self.lock_icon:SetActive(false)
    self.unlockBg:SetActive(true)
    self.lockBg:SetActive(false)
    self.workerHeadMask:SetActive(false)
    if buildData == nil and not LuaEntry.Player:AtHomeNow() then
      self.goto_btn:SetActive(false)
      self.des_text:SetActive(true)
      self.slider:SetActive(false)
      self.build_name_text:SetLocalText("season_tips153")
      self.des_text:SetLocalText("season_tips154")
      self.icon:LoadSprite("Assets/Main/Sprites/UI/UIChatNew3/NeXT_common_city_lianmengld2.png")
      self.icon:SetNativeSize()
      self.icon.transform.localScale = UIBuildQueueImageTypeScale.Unlock
    end
  elseif self.state == UIBuildQueueState.Locked then
    self.icon:LoadSprite(LOCK_ICON)
    self.icon:SetNativeSize()
    self.icon.transform.localScale = UIBuildQueueImageTypeScale.Unlock
    self.des_text.gameObject:SetActive(false)
    self.slider:SetValue(0)
    self.slider.gameObject:SetActive(false)
    self.rentQueueCountDown_text:SetActive(false)
    self.refreshRentCountDown = false
    self.goto_btn:SetActive(true)
    local allPreQueueUnlock, order = DataCenter.BuildQueueManager:IsAllPreQueueUnlock(self.queueInfo.order)
    if allPreQueueUnlock then
      self.build_name_text:SetLocalText(2000418)
      self.goto_btn_name:SetLocalText("build_queue_tips_2")
      self.goto_btn_img:LoadSprite(UIAssets.YELLOW_BTN)
      CS.UIGray.SetGray(self.icon.transform, false, true)
      self.lock_icon:SetActive(false)
      self.unlockBg:SetActive(true)
      self.lockBg:SetActive(false)
      self.workerHeadMask:SetActive(false)
    else
      self.build_name_text:SetLocalText(2000419, order)
      self.goto_btn_name:SetLocalText(2000421)
      self.workerHeadMask:SetActive(true)
      self.goto_btn_img:LoadSprite(UIAssets.GREY_BTN)
      self.lock_icon:SetActive(true)
      self.unlockBg:SetActive(false)
      self.lockBg:SetActive(true)
    end
  end
  self.commonRedPoint:SetDefaultVisible(self.state == UIBuildQueueState.Free)
end

local function ChangeState(self, state)
  if self.state ~= nil then
    self.state = state
    self:RefreshState()
  end
end

local function ChangeEndTime(self, endTime)
  self.endTime = endTime
end

UIBuildQueueCell.OnCreate = OnCreate
UIBuildQueueCell.OnDestroy = OnDestroy
UIBuildQueueCell.Param = Param
UIBuildQueueCell.OnEnable = OnEnable
UIBuildQueueCell.OnDisable = OnDisable
UIBuildQueueCell.ComponentDefine = ComponentDefine
UIBuildQueueCell.ComponentDestroy = ComponentDestroy
UIBuildQueueCell.DataDefine = DataDefine
UIBuildQueueCell.DataDestroy = DataDestroy
UIBuildQueueCell.ReInit = ReInit
UIBuildQueueCell.OnBtnClick = OnBtnClick
UIBuildQueueCell.RefreshSlider = RefreshSlider
UIBuildQueueCell.RefreshState = RefreshState
UIBuildQueueCell.ChangeState = ChangeState
UIBuildQueueCell.ChangeEndTime = ChangeEndTime
return UIBuildQueueCell
