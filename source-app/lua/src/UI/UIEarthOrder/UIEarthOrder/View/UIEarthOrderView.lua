local ResourceItem = require("UI.UICapacityTable.Component.ResourceItem")
local UIEarthOrderBoxSelect = require("UI.UIEarthOrder.UIEarthOrder.Component.UIEarthOrderBoxSelect")
local EarthOrderSceneObj = require("UI.UIEarthOrder.EarthOrderSceneObj.EarthOrderSceneObj")
local EarthOrderBox = require("UI.UIEarthOrder.EarthOrderSceneObj.EarthOrderBox")
local EarthOrderRobot = require("UI.UIEarthOrder.EarthOrderSceneObj.EarthOrderRobot")
local UIEarthOrderView = BaseClass("UIEarthOrderView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local Screen = CS.UnityEngine.Screen
local UILaunchSuccess = require("UI.UIEarthOrder.UILaunchSuccess.View.UILaunchSuccessView")
local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local UIGray = CS.UIGray
local safeArea_path = "SafeArea"
local return_btn_path = "SafeArea/CloseBtn"
local box_select_path = "BoxSelect"
local box_btn_path = "BoxBtn%s"
local bg_btn_path = "RawImage"
local can_submit_effect_go_path = "SafeArea/CanSubmitEffectGo"
local reward_line_end_point_path = "SafeArea/RewardLineEndPoint"
local reward_line_path = "SafeArea/RewardLine"
local launch_line_end_point_path = "SafeArea/LaunchLineEndPoint"
local launch_line_path = "SafeArea/LaunchLine"
local reward_title_path = "SafeArea/RightGo/RewardTitle"
local reward_money_num_path = "SafeArea/RightGo/RewardMoneyNum"
local reward_item_num_path = "SafeArea/RightGo/RewardItemNum"
local reward_item_icon_path = "SafeArea/RightGo/Item_Icons/Item_icon_bg/Item_Image"
local reward_country_num_path = "SafeArea/RightGo/RewardCountryBg/RewardCountryNum"
local time_text_path = "SafeArea/RightGo/TimeText"
local time_value_path = "SafeArea/RightGo/TimeBg/TimeValue"
local launch_btn_path = "SafeArea/RightGo/Launch_btn"
local launch_left_time = "SafeArea/RightGo/launch_left_time"
local occupation_tip_btn_path = "SafeArea/RightGo/launch_left_time/occupation_tip_btn"
local launch_btn_name_path = "SafeArea/RightGo/Launch_btn/Launch_btn_name"
local this_path = ""
local money_path = "UIMainTopResourceCell"
local money_num_path = "UIMainTopResourceCell/root/resourceNum"
local money_icon_path = "UIMainTopResourceCell/root/resourceIcon"
local vip_btn_path = "SafeArea/Btn_Vip"
local vips_btn_path = "SafeArea/Btn_Vips"
local scroll_view_path = "SafeArea/RightGo/CellList"
local hideImg_path = "HideImg"
local tip_btn_path = "SafeArea/RightGo/TipBtn"
local extra_effect_path = "SafeArea/RightGo/UIExtraEffect"
local totalMoneyShowStartTime = 2000.0
local totalMoneyShowTime = 2500.0
local totalMoneyAnimationShowTime = 3.6
local coinNumMin = 5
local coinNumMax = 15
local RobotInitNodeIndex = 2
local QuitFocusPosDelta = Vector3.New(-2, 0, 2)
local EnterFocusPosDelta = Vector3.New(-2, 0, 16)
local AnimName = {
  Exit = "UIEarthOrder_exit",
  Enter = "UIEarthOrder_enter",
  Launch = "UIEarthOrder_launch",
  LineHideQuick = "LineHideQuick",
  LineHide = "LineHide"
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  DataCenter.DailyActivityManager:UpdateActViewHistory(1)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.box_select = self:AddComponent(UIEarthOrderBoxSelect, box_select_path)
  self.bg_btn = self:AddComponent(UIButton, bg_btn_path)
  self.can_submit_effect_go = self:AddComponent(UIBaseContainer, can_submit_effect_go_path)
  self.reward_line = self:AddComponent(UIAnimator, reward_line_path)
  self.launch_line = self:AddComponent(UIAnimator, launch_line_path)
  self.reward_line_end_point = self:AddComponent(UIBaseContainer, reward_line_end_point_path)
  self.launch_line_end_point = self:AddComponent(UIBaseContainer, launch_line_end_point_path)
  self.reward_title = self:AddComponent(UIText, reward_title_path)
  self.occupation_tip_btn = self:AddComponent(UIButton, occupation_tip_btn_path)
  self.reward_money_num = self:AddComponent(UIText, reward_money_num_path)
  self.reward_item_num = self:AddComponent(UIText, reward_item_num_path)
  self.reward_item_icon = self:AddComponent(UIImage, reward_item_icon_path)
  self.reward_item_icon:SetActive(false)
  self.reward_item_num:SetActive(false)
  self.launch_left = self:AddComponent(UIText, launch_left_time)
  self.reward_country_num = self:AddComponent(UIText, reward_country_num_path)
  self.time_text = self:AddComponent(UIText, time_text_path)
  self.time_value = self:AddComponent(UIText, time_value_path)
  self.launch_btn = self:AddComponent(UIButton, launch_btn_path)
  self.launch_btn_name = self:AddComponent(UIText, launch_btn_name_path)
  self.anim = self:AddComponent(UIAnimator, this_path)
  self.hideImg = self:AddComponent(UIBaseContainer, hideImg_path)
  self.safeArea = self:AddComponent(UIBaseContainer, safeArea_path)
  self.money_root = self:AddComponent(UIBaseContainer, money_path)
  self.money_num = self:AddComponent(UIText, money_num_path)
  self.money_icon = self:AddComponent(UIImage, money_icon_path)
  self.money_root:SetActive(false)
  self.occupation_tip_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickOccupationTipBtn()
  end)
  self.bg_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickBg()
  end)
  self.return_btn:SetOnClick(function()
    if self.box_select ~= nil then
      self.box_select:SetActive(false)
    end
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnExitClick()
  end)
  self.launch_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickLaunch()
  end)
  self._vip_btn = self:AddComponent(UIButton, vip_btn_path)
  self._vip_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickVipDesc(1)
  end)
  self._vips_btn = self:AddComponent(UIButton, vips_btn_path)
  self._vips_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClickVipDesc(2)
  end)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.itemList = {}
  self.cells = {}
  self.money = 0
  self.tip_btn = self:AddComponent(UIButton, tip_btn_path)
  self.tip_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:ShowDesc()
  end)
  self.extra_effect = self:AddComponent(UIExtraEffect, extra_effect_path)
end

local function ComponentDestroy(self)
  self.box_select:SetActive(false)
  self.return_btn = nil
  self.box_select = nil
  self.bg_btn = nil
  self.can_submit_effect_go = nil
  self.reward_line = nil
  self.launch_line = nil
  self.reward_title = nil
  self.reward_money_num = nil
  self.reward_country_num = nil
  self.time_text = nil
  self.time_value = nil
  self.launch_btn = nil
  self.launch_btn_name = nil
  self.anim = nil
  self.reward_line_end_point = nil
  self.launch_line_end_point = nil
  self.money_root = nil
  self.money_num = nil
  self.money_icon = nil
  self.safeArea = nil
  self.itemList = nil
  self.cells = nil
  self.scroll_view = nil
  self.money = nil
  self.extra_effect = nil
  self.launch_left = nil
  if self.launchEffect ~= nil then
    self.launchEffect:Destroy()
    self.launchEffect = nil
  end
end

local function DataDefine(self)
  self.sceneObj = {}
  self.orderUuid = nil
  self.endTime = 0
  self.template = nil
  self.needResource = nil
  self.loadingCell = {}
  self.canSubmitEffects = {}
  self.freeCanSubmitEffects = {}
  self.loadingCell = {}
  self.boxBtn = {}
  self.timer = nil
  self.box = {}
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
  
  self.lastTime = nil
  self.robot = {}
  self.freeRobot = {}
  self.isOutPlaySceneAnimTime = false
  self.starTimer = nil
  self.launchTimer = nil
  self.exitTimer = nil
  self.isLaunch = nil
  self.halfLaunchTimer = nil
  self.leftNeedSubmitIndex = {}
  self.quitPos = nil
  self.isSend = true
  self.showMoneyStartTime = nil
end

local function DataDestroy(self)
  self.timer_action = nil
  self:DeleteTimer()
  if self.halfLaunchTimer ~= nil then
    self.halfLaunchTimer:Stop()
    self.halfLaunchTimer = nil
  end
  if self.exitTimer ~= nil then
    self.exitTimer:Stop()
    self.exitTimer = nil
  end
  if self.launchTimer ~= nil then
    self.launchTimer:Stop()
    self.launchTimer = nil
  end
  if self.endCameraTimer ~= nil then
    self.endCameraTimer:Stop()
    self.endCameraTimer = nil
  end
  if self.showMoneyTimer ~= nil then
    self.showMoneyTimer:Stop()
    self.showMoneyTimer = nil
  end
  if self.starTimer ~= nil then
    self.starTimer:Stop()
    self.starTimer = nil
  end
  if self.sceneObj.request ~= nil then
    self.sceneObj.script:OnDestroy()
    self.sceneObj.request:Destroy()
  end
  self.sceneObj = nil
  for k, v in pairs(self.box) do
    v.script:OnDestroy()
    v.request:Destroy()
  end
  self.box = nil
  for k, v in pairs(self.robot) do
    v.script:OnDestroy()
    v.request:Destroy()
  end
  self.robot = nil
  for k, v in pairs(self.freeRobot) do
    v.script:OnDestroy()
    v.request:Destroy()
  end
  self.freeRobot = nil
  self.orderUuid = nil
  self.endTime = nil
  self.template = nil
  self.needResource = nil
  self.loadingCell = nil
  self.canSubmitEffects = nil
  self.freeCanSubmitEffects = nil
  self.loadingCell = nil
  for k, v in pairs(self.boxBtn) do
    v:SetActive(false)
  end
  self.boxBtn = nil
  self.lastTime = nil
  self.isOutPlaySceneAnimTime = nil
  self.isLaunch = nil
  self.leftNeedSubmitIndex = nil
  self.quitPos = nil
  self.isSend = nil
  self.showMoneyStartTime = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_TRADING_CENTER)
  if buildData ~= nil then
    local pos = SceneUtils.TileIndexToWorld(buildData.pointId)
    self.quitPos = pos + QuitFocusPosDelta
    pos = pos + EnterFocusPosDelta
    CS.SceneManager.World:AutoFocus(pos, CS.LookAtFocusState.EarthOrder, self.anim:GetFloat("CameraEnterTime") / 10)
  end
  self.orderUuid = self:GetUserData()
  local info = DataCenter.EarthOrderDataManager:GetEarthOrderByUuid(self.orderUuid)
  if info ~= nil then
    self.endTime = info.expTime
    self.needResource = info:GetNeedItem()
    self.reward_title:SetLocalText(GameDialogDefine.EXTRA_REWARD)
    DataCenter.HeroStationManager:ReCalcSkillAddition()
    local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(BuildingTypes.FUN_BUILD_MAIN, DataCenter.BuildManager.MainLv)
    local money = toInt(buildLevelTemplate.para1)
    money = money + DataCenter.HeroStationManager:GetEffectValue(HeroStationEffectType.TradeCenterMoney)
    money = money * (1 + LuaEntry.Effect:GetGameEffect(EffectDefine.EARTH_ORDER_EXTRA_MONEY_ADD_PERCENT) / 100)
    money = money + LuaEntry.Effect:GetGameEffect(EffectDefine.EARTH_ORDER_EXTRA_MONEY_ADD_VALUE)
    money = money * (1 + DataCenter.HeroStationManager:GetEffectValue(HeroStationEffectType.GlobalMoney) / 100)
    self.money = Mathf.Round(money)
    if self.money > 10000 then
      self.reward_money_num:SetText(string.GetFormattedStr(self.money))
    else
      self.reward_money_num:SetText(string.GetFormattedSeperatorNum(self.money))
    end
    local icon, num = DataCenter.EarthOrderDataManager:GetOrderExtraItemIconAndNumByOrderUuid()
    if icon ~= nil then
      self.reward_item_icon:SetActive(true)
      self.reward_item_num:SetActive(true)
      self.reward_item_num:SetText(string.GetFormattedStr(num))
      self.reward_item_icon:LoadSprite(icon)
    else
      self.reward_item_icon:SetActive(false)
      self.reward_item_num:SetActive(false)
    end
    self.reward_country_num:SetText("0")
    self.time_text:SetLocalText(GameDialogDefine.LEFT_TIME)
    self.launch_btn_name:SetLocalText(self:GetLaunchBtnText())
    self:RefreshTime()
    self:AddTimer()
    self:ShowCanSubmitEffects()
    self:SetLineWidth()
    self:ShowLeftNum()
    self:ClearScroll(self)
    self.itemList = {}
    if #self.itemList > 0 then
      self.scroll_view:SetTotalCount(#self.itemList)
      self.scroll_view:RefillCells()
    end
  end
  self.isOutPlaySceneAnimTime = false
  self.starTimer = TimerManager:GetInstance():GetTimer(LookAtFocusTime, function()
    if self.starTimer ~= nil then
      self.starTimer:Stop()
      self.starTimer = nil
    end
    self.isOutPlaySceneAnimTime = true
    self:CheckPlayStartAnim()
  end, self, true, false, false)
  self.starTimer:Start()
  self:LoadSceneObj()
  self:LoadBox()
  self.launch_btn.gameObject:SetActive(true)
  self:RefreshBtnState(table.count(self.leftNeedSubmitIndex) == 0)
  self._vip_btn:SetActive(0 < LuaEntry.Effect:GetGameEffect(EffectDefine.EARTH_ORDER_VIP))
  self.extra_effect:SetData(HeroStationEffectType.GlobalMoney, self, self.OnExitClick)
end

local function LoadSceneObj(self)
  local request = ResourceManager:InstantiateAsync(UIAssets.EarthOrderSceneObj)
  self.sceneObj.request = request
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local earthOrderSceneObj = EarthOrderSceneObj.New()
    earthOrderSceneObj:OnCreate(request)
    self.sceneObj.script = earthOrderSceneObj
    local param = {}
    param.endTime = self.endTime
    param.lastTime = self.lastTime
    earthOrderSceneObj:ReInit(param)
    self:CheckPlayStartAnim()
    for k, v in pairs(self.box) do
      if v.script ~= nil then
        v.script.transform.position = self.sceneObj.script:GetBoxNodePosition(k)
      end
    end
  end)
end

local function ResetLeftNeedSubmitIndex(self)
  self.leftNeedSubmitIndex = {}
  local info = DataCenter.EarthOrderDataManager:GetEarthOrderByUuid(self.orderUuid)
  if self.needResource ~= nil and info ~= nil then
    local count = table.count(self.needResource)
    for i = 1, count do
      local needId = self.needResource[i].needId
      if info:IsSubmit(needId, i) then
      else
        self.leftNeedSubmitIndex[i] = needId
      end
    end
  end
end

local function LoadBox(self)
  self.leftNeedSubmitIndex = {}
  local info = DataCenter.EarthOrderDataManager:GetEarthOrderByUuid(self.orderUuid)
  if self.needResource ~= nil then
    local count = table.count(self.needResource)
    for i = 1, count do
      local needId = self.needResource[i].needId
      if info:IsSubmit(needId, i) then
        self:LoadOneBox(i, string.format(LoadPath.CommonNewPath, "Common_duihao"))
      else
        self.leftNeedSubmitIndex[i] = needId
        local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(needId)
        if template ~= nil then
          self:LoadOneBox(i, string.format(LoadPath.ItemPath, template.pic))
        end
      end
    end
  end
end

local function LoadOneBox(self, index, iconName)
  local request = ResourceManager:InstantiateAsync(UIAssets.EarthOrderBox)
  self.box[index] = {}
  self.box[index].request = request
  request:completed("+", function()
    if request.isError then
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    local earthOrderBox = EarthOrderBox.New()
    earthOrderBox:OnCreate(request)
    local param = {}
    param.index = index
    param.iconName = iconName
    param.resourceItemId = self.needResource[index].needId
    param.needResourceItemCount = self.needResource[index].count
    earthOrderBox:ReInit(param)
    self.box[index].script = earthOrderBox
    if self.sceneObj.script ~= nil then
      earthOrderBox.transform.position = self.sceneObj.script:GetBoxNodePosition(index)
    end
    if self.isOutPlaySceneAnimTime then
      earthOrderBox:PlayEnterAnim()
    end
  end)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshResourceItem, self.RefreshResourceItemSignal)
  self:AddUIListener(EventId.RefreshEarthOrder, self.RefreshEarthOrderSignal)
  self:AddUIListener(EventId.SoldResourceItem, self.RefreshResourceItemSignal)
  self:AddUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
  self:AddUIListener(EventId.END_SEARCH, self.FindMonsterEnd)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.RefreshResourceItemSignal)
  self:RemoveUIListener(EventId.RefreshEarthOrder, self.RefreshEarthOrderSignal)
  self:RemoveUIListener(EventId.SoldResourceItem, self.RefreshResourceItemSignal)
  self:RemoveUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
  self:RemoveUIListener(EventId.END_SEARCH, self.FindMonsterEnd)
end

local function FindMonsterEnd(self, param)
  local worldPosition = SceneUtils.TileIndexToWorld(param.pointId, ForceChangeScene.World)
  WorldArrowManager:GetInstance():ShowArrowEffect(param.uuid, worldPosition, ArrowType.Monster)
  GoToUtil.GotoWorldPos(worldPosition, CS.SceneManager.World.InitZoom)
end

local function ShowCanSubmitEffects(self)
  for k, v in pairs(self.canSubmitEffects) do
    v:SetActive(false)
    table.insert(self.freeCanSubmitEffects, v)
  end
  self.canSubmitEffects = {}
  local info = DataCenter.EarthOrderDataManager:GetEarthOrderByUuid(self.orderUuid)
  if self.needResource ~= nil then
    local count = table.count(self.needResource)
    for i = 1, count do
      local needId = self.needResource[i].needId
      local needCount = self.needResource[i].count
      if info ~= nil and not info:IsSubmit(needId, i) then
        local own = 0
        local data = DataCenter.ResourceItemDataManager:GetItemDataByItemId(needId)
        if data ~= nil then
          own = data.number
        end
        self:AddOneBoxBtn(i)
        if needCount <= own then
          self:AddOneCanSubmitEffect(i)
        end
      elseif self.boxBtn[i] ~= nil then
        self.boxBtn[i]:SetActive(false)
      end
    end
  end
end

local function AddOneCanSubmitEffect(self, index)
  if #self.freeCanSubmitEffects > 0 then
    local temp = table.remove(self.freeCanSubmitEffects)
    if temp ~= nil then
      temp:SetActive(true)
      temp.transform.position = self.boxBtn[index].transform.position
      self.canSubmitEffects[index] = temp
    end
  elseif self.loadingCell[index] == nil then
    self.loadingCell[index] = true
    self:GameObjectInstantiateAsync(UIAssets.UIEarthOrderBoxCanSubmitEffect, function(request)
      self.loadingCell[index] = nil
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.can_submit_effect_go.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform.position = self.boxBtn[index].transform.position
      self.canSubmitEffects[index] = go
    end)
  end
end

local function AddOneBoxBtn(self, index)
  if self.boxBtn[index] == nil then
    local btn = self:AddComponent(UIButton, string.format(box_btn_path, index))
    if btn ~= nil then
      btn:SetOnClick(function()
        DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
        self:OnClickBox(index)
      end)
      self.boxBtn[index] = btn
      btn:SetActive(true)
    end
  end
end

local function OnClickBox(self, index)
  if self.needResource[index] ~= nil then
    local param = {}
    param.resourceItemId = self.needResource[index].needId
    param.needResourceItemCount = self.needResource[index].count
    local rewards = {}
    if self.needResource[index].rewardList ~= nil and #self.needResource[index].rewardList > 0 then
      rewards = DataCenter.RewardManager:ReturnRewardParamForView(self.needResource[index].rewardList)
      local moneyReward
      for k, v in ipairs(rewards) do
        if v.rewardType == RewardType.FOOD then
          moneyReward = v
          table.remove(rewards, k)
          break
        end
      end
      if moneyReward ~= nil then
        table.insert(rewards, 1, moneyReward)
      end
    else
      local param = {}
      param.rewardType = RewardType.FOOD
      param.count = rewardMoneyCount
      table.insert(rewards, param)
    end
    param.rewardList = rewards
    param.orderUuid = self.orderUuid
    param.pos = self.boxBtn[index].transform.position
    
    function param.callBack()
      self:OnSubmitBox(index)
    end
    
    param.index = index
    self.box_select:ReInit(param)
    if self.box[index] ~= nil then
      self.box[index].script:PlayClickAnim()
    end
  end
end

local function OnClickBg(self)
  if self.box_select:GetActive() then
    self.box_select:PlayExitAnim()
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
  local now = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.endTime - now
  if self.lastTime ~= leftTime then
    self.lastTime = leftTime
    if leftTime <= 0 then
      self.time_value:SetText(UITimeManager:GetInstance():MilliSecondToClock(0))
      local isSend = LuaEntry.Effect:GetGameEffect(EffectDefine.EARTH_ORDER_VIP)
      if self.sceneObj.script ~= nil and self.isSend then
        if isSend <= 0 then
          DataCenter.EarthOrderDataManager:SendEarthOrderEnd(self.orderUuid)
          self.isSend = false
          self:DoLaunchAnim()
        else
          self._vip_btn:SetActive(false)
        end
      end
      if self.isSend then
        if isSend <= 0 then
          self.launch_btn.gameObject:SetActive(false)
          self.hideImg.gameObject:SetActive(true)
          self.can_submit_effect_go.gameObject:SetActive(false)
        else
          self.launch_btn.gameObject:SetActive(true)
          self:RefreshBtnState(true)
          self.hideImg.gameObject:SetActive(false)
          self.can_submit_effect_go.gameObject:SetActive(true)
        end
      end
    else
      self.isSend = true
      self.time_value:SetText(UITimeManager:GetInstance():MilliSecondToClock(leftTime))
      self.hideImg.gameObject:SetActive(false)
    end
  end
end

local function delayTime(self)
  local time = 1000
  while 0 < time do
    time = time - 1
    print(time)
  end
  if time <= 0 then
    self:DoLaunchAnim()
    EventManager:GetInstance():Broadcast(EventId.EndEarthOrder)
  end
end

local function OnClickLaunch(self)
  self:OnClickBg()
  local count = table.count(self.leftNeedSubmitIndex)
  if count == 0 then
    local pos = self.reward_money_num.gameObject.transform.position
    local rewardType = RewardType.FOOD
    local endPos = self.view:GetMoneyPosition()
    self:ShowMoney()
    local icon = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Food)
    local num = self.money / 50
    num = math.min(coinNumMax, math.max(coinNumMin, num))
    UIUtil.DoFly(tonumber(rewardType), num, icon, pos, Vector3.New(endPos.x, endPos.y, endPos.z))
    local icon, _ = DataCenter.EarthOrderDataManager:GetOrderExtraItemIconAndNumByOrderUuid()
    if icon ~= nil then
      local num = 5
      UIUtil.DoFly(RewardType.GOODS, num, icon, pos, Vector3.New(0, 0, 0))
    end
    DataCenter.EarthOrderDataManager:SendEarthOrderEnd(self.orderUuid)
    self:DoLaunchAnim()
  else
    UIUtil.ShowMessage(Localization:GetString(GameDialogDefine.CHECK_LAUNCH_ROCKET), 2, "", "", function()
      DataCenter.EarthOrderDataManager:SendEarthOrderEnd(self.orderUuid)
      self:DoLaunchAnim()
    end, function()
    end)
  end
end

local function SetLineWidth(self)
  local lossyScale = self.safeArea.transform.lossyScale.y
  if lossyScale <= 0 then
    lossyScale = 1
  end
  local sizeDelta1 = self.launch_line.rectTransform.sizeDelta
  sizeDelta1.x = (self.launch_line_end_point.transform.position.x - self.launch_line.transform.position.x) / lossyScale
  self.launch_line.rectTransform.sizeDelta = sizeDelta1
  local sizeDelta2 = self.reward_line.rectTransform.sizeDelta
  sizeDelta2.x = (self.reward_line_end_point.transform.position.x - self.reward_line.transform.position.x) / lossyScale
  self.reward_line.rectTransform.sizeDelta = sizeDelta2
end

local function OnSubmitBox(self, index)
  if self.boxBtn[index] ~= nil then
    self.boxBtn[index]:SetActive(false)
  end
  if self.leftNeedSubmitIndex[index] ~= nil then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Earth_Order_Robot, false)
    self:LoadOneRobot(index)
    self:CheckAllSubmit()
  end
end

local function LoadOneRobot(self, index)
  if self.robot[index] == nil then
    if #self.freeRobot > 0 then
      local temp = table.remove(self.freeRobot)
      if temp ~= nil then
        temp.script.gameObject:SetActive(true)
        temp.script:PlayEnterAnim(index)
        self.robot[index] = temp
      end
    else
      local request = ResourceManager:InstantiateAsync(UIAssets.EarthOrderRobot)
      self.robot[index] = {}
      self.robot[index].request = request
      request:completed("+", function()
        if request.isError then
          return
        end
        request.gameObject:SetActive(true)
        request.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
        request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local earthOrderRobot = EarthOrderRobot.New()
        earthOrderRobot:OnCreate(request)
        local param = {}
        
        function param.boxCallBack(tempIndex)
          self:OnRobotBoxAnimEnd(tempIndex)
        end
        
        function param.robotCallBack(tempIndex)
          self:OnRobotAnimEnd(tempIndex)
        end
        
        earthOrderRobot:ReInit(param)
        earthOrderRobot:PlayEnterAnim(index)
        self.robot[index].script = earthOrderRobot
        earthOrderRobot.transform.position = Vector3.New(0, 0, 0)
      end)
    end
  end
end

local function OnRobotAnimEnd(self, index)
  if self.robot[index] ~= nil then
    self.robot[index].script.gameObject:SetActive(false)
    table.insert(self.freeRobot, self.robot[index])
    self.robot[index] = nil
  end
end

local function OnRobotBoxAnimEnd(self, index)
  if self.box[index] ~= nil then
    self.box[index].script:RefreshIcon(string.format(LoadPath.CommonNewPath, "Common_duihao"))
    self.box[index].script:PlaySubmitAnim()
  end
end

local function CheckPlayStartAnim(self)
  if self.isOutPlaySceneAnimTime then
    if self.sceneObj.script ~= nil then
      self.sceneObj.script:PlayEnterAnim()
    end
    local time = 0
    for k, v in pairs(self.box) do
      if v.script ~= nil then
        local tempTime = v.script:PlayEnterAnim()
        if time < tempTime then
          time = tempTime
        end
      end
    end
    if 0 < time then
      self.endCameraTimer = TimerManager:GetInstance():GetTimer(time, function()
        if self.endCameraTimer ~= nil then
          self.endCameraTimer:Stop()
          self.endCameraTimer = nil
        end
        if self.sceneObj.script ~= nil then
          self.sceneObj.script:EndEnterAnim()
        end
      end, self, true, false, false)
      self.endCameraTimer:Start()
    end
  end
end

local function DoLaunchAnim(self)
  if not self.isLaunch then
    self.isLaunch = true
    self:PlayLineHide(AnimName.LineHide)
    GoToUtil.GotoPos(self.quitPos, CS.SceneManager.World.InitZoom, 0.02)
    self.sceneObj.script:PlayLaunchAnim()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Rocket, false)
    local ret, time = self.anim:PlayAnimationReturnTime(AnimName.Launch)
    if ret then
      self.halfLaunchTimer = TimerManager:GetInstance():GetTimer(time / 2, function()
        if self.halfLaunchTimer ~= nil then
          self.halfLaunchTimer:Stop()
          self.halfLaunchTimer = nil
        end
        EventManager:GetInstance():Broadcast(EventId.ViewEndEarthOrder)
      end, self, true, false, false)
      self.halfLaunchTimer:Start()
      self.launchTimer = TimerManager:GetInstance():GetTimer(time, function()
        if self.launchTimer ~= nil then
          self.launchTimer:Stop()
          self.launchTimer = nil
        end
        if #self.itemList > 0 then
          local count = table.count(self.leftNeedSubmitIndex)
          if count == 0 then
            local param = {}
            param.itemList = self.itemList
            param.money = self.money
            UIManager:GetInstance():OpenWindow(UIWindowNames.UILaunchSuccess, {anim = true}, param)
          end
        end
        if self.box_select ~= nil then
          self.box_select:SetActive(false)
        end
        self.ctrl:CloseSelf()
      end, self, true, false, false)
      self.launchTimer:Start()
    end
  end
  DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ClickRocketLaunch, SaveGuideDoneValue)
end

local function OnExitClick(self)
  local count = table.count(self.leftNeedSubmitIndex)
  if count == 0 then
    UIUtil.ShowMessage(Localization:GetString("130613"))
  else
    GoToUtil.GotoPos(self.quitPos, CS.SceneManager.World.InitZoom, 0.02)
    if not self.isLaunch then
      self.isLaunch = true
      self:PlayLineHide(AnimName.LineHideQuick)
      local ret, time = self.anim:PlayAnimationReturnTime(AnimName.Exit)
      if ret then
        self.exitTimer = TimerManager:GetInstance():GetTimer(time, function()
          if self.exitTimer ~= nil then
            self.exitTimer:Stop()
            self.exitTimer = nil
          end
          self.ctrl:CloseSelf()
        end, self, true, false, false)
        self.exitTimer:Start()
      end
    end
  end
end

local function RefreshResourceItemSignal(self)
  self:ShowCanSubmitEffects()
  if self.box_select:GetActive() then
    self.box_select:RefreshCount()
  end
end

local function CheckAllSubmit(self)
  local count = table.count(self.leftNeedSubmitIndex)
  if count == 0 and self.launchEffect == nil then
    self.launchEffect = ResourceManager:InstantiateAsync(UIAssets.UIEarthOrderLaunchFx)
    self.launchEffect:completed("+", function()
      if self.launchEffect.isError then
        return
      end
      self.launchEffect.gameObject:SetActive(true)
      self.launchEffect.gameObject.transform:SetParent(self.launch_btn.gameObject.transform, false)
      self.launchEffect.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      self.launchEffect.gameObject.transform:Set_localPosition(0, 0, 0)
      self.launch_btn.gameObject:SetActive(true)
      self:RefreshBtnState(true)
    end)
  end
end

local function RefreshEarthOrderSignal(self)
  local info = DataCenter.EarthOrderDataManager:GetEarthOrderByUuid(self.orderUuid)
  if info ~= nil and self.needResource ~= nil then
    local count = table.count(self.needResource)
    for i = 1, count do
      local needId = self.needResource[i].needId
      if info:IsSubmit(needId, i) then
        if self.boxBtn[i] ~= nil then
          self.boxBtn[i]:SetActive(false)
          local param = {}
          param.resourceItemId = self.needResource[i].needId
          param.needResourceItemCount = self.needResource[i].count
          param.hide = true
          self.box[i].script:RefreshCount(param)
        end
      else
        self.leftNeedSubmitIndex[i] = needId
        local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(needId)
        if template ~= nil then
          if self.box[i] ~= nil then
            self.box[i].script:RefreshIcon(string.format(LoadPath.ItemPath, template.pic))
          end
          if self.boxBtn[i] ~= nil then
            self.boxBtn[i]:SetActive(true)
          end
        end
      end
    end
  end
  self:ResetLeftNeedSubmitIndex()
  self:CheckAllSubmit()
end

local function PlayLineHide(self, name)
  self.reward_line:Play(name, 0, 0)
  self.launch_line:Play(name, 0, 0)
end

local function ClearScroll(self)
  self.cells = {}
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(ResourceItem)
end

local function OnItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  self.cells[index] = self.scroll_view:AddComponent(ResourceItem, itemObj)
  self.cells[index]:RefreshData(self.itemList[index])
end

local function OnItemMoveOut(self, itemObj, index)
  self.cells[index] = nil
  self.scroll_view:RemoveComponent(itemObj.name, ResourceItem)
end

local function ShowDesc(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.tip_btn.gameObject.transform.position + Vector3.New(-10, 30, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString(GameDialogDefine.ALL_COMPLETE_GET) .. [[


]] .. Localization:GetString("140056")
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 210
  param.pivot = 0.75
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function OnClickOccupationTipBtn(self)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position = self.occupation_tip_btn.gameObject.transform.position + Vector3.New(-10, 30, 0) * scaleFactor
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString("395176") .. " (" .. Localization:GetString("395102") .. ")" .. [[


]] .. Localization:GetString("395323", LuaEntry.Effect:GetGameEffect(EffectDefine.EFFECT_ROCKET_NUM))
  param.dir = UIHeroTipView.Direction.ABOVE
  param.defWidth = 210
  param.pivot = 0.75
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function OnClickVipDesc(self, index)
  local scaleFactor = UIManager:GetInstance():GetScaleFactor()
  local position
  if index == 1 then
    position = self._vip_btn.gameObject.transform.position + Vector3.New(30, 20, 0) * scaleFactor
  else
    position = self._vips_btn.gameObject.transform.position + Vector3.New(30, 20, 0) * scaleFactor
  end
  local isSend = LuaEntry.Effect:GetGameEffect(EffectDefine.EARTH_ORDER_VIP)
  if index == 2 and not self.isSend and isSend <= 0 then
    return
  end
  local param = UIHeroTipView.Param.New()
  param.content = Localization:GetString("320296")
  param.dir = UIHeroTipView.Direction.RIGHT
  param.defWidth = 210
  param.pivot = 0.75
  param.position = position
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, {anim = false}, param)
end

local function ShowMoney(self)
  if self.showMoneyTimer ~= nil then
    self.showMoneyTimer:Stop()
    self.showMoneyTimer = nil
  end
  local num = LuaEntry.Resource:GetCntByResType(ResourceType.Food)
  self.money_num:SetText(string.GetFormattedSeperatorNum(num))
  self.money_root:SetActive(true)
  self.showMoneyStartTime = UITimeManager:GetInstance():GetServerTime()
  self.moneyStart = num
  self.showMoneyTimer = TimerManager:GetInstance():GetTimer(totalMoneyAnimationShowTime, function()
    self:HideMoney()
  end, self, true, false, false)
end

local function HideMoney(self)
  if self.showMoneyTimer ~= nil then
    self.showMoneyTimer:Stop()
    self.showMoneyTimer = nil
  end
  if self.showMoneyStartTime == nil then
    return
  end
  if UITimeManager:GetInstance():GetServerTime() - self.showMoneyStartTime < totalMoneyShowTime - 200 then
    return
  end
  if self.money_root == nil then
    return
  end
  self.money_root:SetActive(false)
end

local function GetMoneyPosition(self)
  return self.money_icon.transform.position
end

local function UpdateResourceSignal(self)
end

local function Update(self)
  if self.showMoneyStartTime ~= nil then
    local diffTime = self.showMoneyStartTime + totalMoneyShowTime - UITimeManager:GetInstance():GetServerTime()
    if 0 <= diffTime and diffTime <= totalMoneyShowStartTime then
      local num = LuaEntry.Resource:GetCntByResType(ResourceType.Food)
      local currentMoney = math.ceil((num - self.moneyStart) * (1.0 - 1.0 * diffTime / totalMoneyShowStartTime) + self.moneyStart)
      self.money_num:SetText(string.GetFormattedSeperatorNum(currentMoney))
    end
  end
end

local function GetLaunchBtnText(self)
  return GameDialogDefine.LAUNCH
end

local function RefreshBtnState(self, enableFlag)
  UIGray.SetGray(self.launch_btn.transform, not enableFlag, enableFlag)
end

local function ShowLeftNum(self)
  if LuaEntry.Effect:GetGameEffect(EffectDefine.EFFECT_ROCKET_NUM) > 0 then
    local leftTime = DataCenter.EarthOrderDataManager:GetLeftFireTime()
    self.launch_left:SetActive(true)
    self.launch_left:SetLocalText(140403, leftTime)
    local isSend = LuaEntry.Effect:GetGameEffect(EffectDefine.EARTH_ORDER_VIP)
    local now = UITimeManager:GetInstance():GetServerTime()
    local leftTime = self.endTime - now
    if 0 < isSend and leftTime <= 0 then
      self.launch_left:SetActive(false)
    end
  else
    self.launch_left:SetActive(false)
  end
end

UIEarthOrderView.OnCreate = OnCreate
UIEarthOrderView.OnDestroy = OnDestroy
UIEarthOrderView.OnEnable = OnEnable
UIEarthOrderView.OnDisable = OnDisable
UIEarthOrderView.OnAddListener = OnAddListener
UIEarthOrderView.OnRemoveListener = OnRemoveListener
UIEarthOrderView.ComponentDefine = ComponentDefine
UIEarthOrderView.ComponentDestroy = ComponentDestroy
UIEarthOrderView.DataDefine = DataDefine
UIEarthOrderView.DataDestroy = DataDestroy
UIEarthOrderView.ReInit = ReInit
UIEarthOrderView.LoadSceneObj = LoadSceneObj
UIEarthOrderView.ShowCanSubmitEffects = ShowCanSubmitEffects
UIEarthOrderView.AddOneCanSubmitEffect = AddOneCanSubmitEffect
UIEarthOrderView.AddOneBoxBtn = AddOneBoxBtn
UIEarthOrderView.OnClickBox = OnClickBox
UIEarthOrderView.OnClickBg = OnClickBg
UIEarthOrderView.DeleteTimer = DeleteTimer
UIEarthOrderView.AddTimer = AddTimer
UIEarthOrderView.RefreshTime = RefreshTime
UIEarthOrderView.OnClickLaunch = OnClickLaunch
UIEarthOrderView.SetLineWidth = SetLineWidth
UIEarthOrderView.LoadBox = LoadBox
UIEarthOrderView.LoadOneBox = LoadOneBox
UIEarthOrderView.OnSubmitBox = OnSubmitBox
UIEarthOrderView.LoadOneRobot = LoadOneRobot
UIEarthOrderView.OnRobotAnimEnd = OnRobotAnimEnd
UIEarthOrderView.OnRobotBoxAnimEnd = OnRobotBoxAnimEnd
UIEarthOrderView.CheckPlayStartAnim = CheckPlayStartAnim
UIEarthOrderView.DoLaunchAnim = DoLaunchAnim
UIEarthOrderView.OnExitClick = OnExitClick
UIEarthOrderView.RefreshResourceItemSignal = RefreshResourceItemSignal
UIEarthOrderView.CheckAllSubmit = CheckAllSubmit
UIEarthOrderView.RefreshEarthOrderSignal = RefreshEarthOrderSignal
UIEarthOrderView.PlayLineHide = PlayLineHide
UIEarthOrderView.ClearScroll = ClearScroll
UIEarthOrderView.OnItemMoveIn = OnItemMoveIn
UIEarthOrderView.OnItemMoveOut = OnItemMoveOut
UIEarthOrderView.delayTime = delayTime
UIEarthOrderView.ShowDesc = ShowDesc
UIEarthOrderView.ShowMoney = ShowMoney
UIEarthOrderView.HideMoney = HideMoney
UIEarthOrderView.GetMoneyPosition = GetMoneyPosition
UIEarthOrderView.UpdateResourceSignal = UpdateResourceSignal
UIEarthOrderView.Update = Update
UIEarthOrderView.OnClickVipDesc = OnClickVipDesc
UIEarthOrderView.ResetLeftNeedSubmitIndex = ResetLeftNeedSubmitIndex
UIEarthOrderView.GetLaunchBtnText = GetLaunchBtnText
UIEarthOrderView.RefreshBtnState = RefreshBtnState
UIEarthOrderView.ShowLeftNum = ShowLeftNum
UIEarthOrderView.OnClickOccupationTipBtn = OnClickOccupationTipBtn
UIEarthOrderView.FindMonsterEnd = FindMonsterEnd
return UIEarthOrderView
