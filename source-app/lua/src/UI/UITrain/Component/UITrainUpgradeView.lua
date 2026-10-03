local UITrainUpgradeView = BaseClass("UITrainUpgradeView", UIBaseContainer)
local base = UIBaseContainer
local UINeedResCell = require("UI.UITrain.Component.UINeedResCell")
local Localization = CS.GameEntry.Localization
local UpgradingSliderLength = 408
local Param = DataClass("Param", ParamData)
local ParamData = {
  armyId,
  armyMaxId,
  maxTrain,
  minTrain,
  extra,
  goldImage,
  need_res_cell
}
local icon_go_path = "IconGo"
local left_icon_path = "IconGo/LeftIcon"
local left_lv_path = "IconGo/LeftLv"
local right_icon_path = "IconGo/RightIcon"
local right_lv_path = "IconGo/RightLv"
local upgrade_text_path = "IconGo/UpgradeText"
local upgrade_slider_path = "BgGo/UpgradeSlider"
local upgrade_input_path = "BgGo/UpgradeInputField"
local upgrade_res_content_path = "BgGo/UpgradeNeedResContent"
local bg_go_path = "BgGo"
local upgrade_extra_go_path = "UpgradeExtraGo"
local upgrade_extra_text_path = "UpgradeExtraGo/UpgradeExtraText"
local upgrade_extra_num_path = "UpgradeExtraGo/UpgradeExtraNum"
local upgrade_extra_time_text_path = "UpgradeExtraGo/UpgradeExtraTimeText"
local upgrade_extra_time_count_path = "UpgradeExtraGo/UpgradeExtraTimeCount"
local upgrade_immediately_btn_path = "UpgradeBtnGo/UpgradeImmediatelyBtn"
local upgrade_immediately_btn_name_path = "UpgradeBtnGo/UpgradeImmediatelyBtn/UpgradeImmediatelyBtn_text/UpgradeImmediatelyBtnName"
local upgrade_immediately_btn_spend_icon_path = "UpgradeBtnGo/UpgradeImmediatelyBtn/UpgradeImmediatelyBtn_text/UpgradeSpendCount/UpgradeSpendIcon"
local upgrade_immediately_btn_spend_count_path = "UpgradeBtnGo/UpgradeImmediatelyBtn/UpgradeImmediatelyBtn_text/UpgradeSpendCount"
local upgrade_upgrade_btn_path = "UpgradeBtnGo/UpgradeBtn"
local upgrade_upgrade_btn_name_path = "UpgradeBtnGo/UpgradeBtn/UpgradeBtn_text/UpgradeBtnName"
local upgrade_upgrade_btn_spend_time_path = "UpgradeBtnGo/UpgradeBtn/UpgradeBtn_text/UpgradeSpendTime"
local upgrade_speed_btn_name_path = "UpgradeBtnGo/UpgradeBtn/SpeedupBtn_text1"
local upgrading_icon_path = "UpgradingSlider/UpgradingIcon"
local upgrading_icon_level_path = "UpgradingSlider/UpgradingIcon/UpgradingIconLevelText"
local upgrading_slider_path = "UpgradingSlider"
local upgrading_slider_left_time_path = "UpgradingSlider/UpgradingLeftTime"
local upgrading_num_path = "UpgradingSlider/UpgradingNum"
local back_btn_path = "BackBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:OnAddListener()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  self:OnRemoveListener()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  if not self.upgradeDefine then
    self.icon_go = self:AddComponent(UIBaseContainer, icon_go_path)
    self.left_icon = self:AddComponent(UIImage, left_icon_path)
    self.left_lv = self:AddComponent(UIText, left_lv_path)
    self.right_icon = self:AddComponent(UIImage, right_icon_path)
    self.right_lv = self:AddComponent(UIText, right_lv_path)
    self.upgrade_text = self:AddComponent(UIText, upgrade_text_path)
    self.upgrade_slider = self:AddComponent(UISlider, upgrade_slider_path)
    self.upgrade_input = self:AddComponent(UIInput, upgrade_input_path)
    self.upgrade_res_content = self:AddComponent(UIBaseContainer, upgrade_res_content_path)
    self.upgrade_extra_go = self:AddComponent(UIBaseContainer, upgrade_extra_go_path)
    self.upgrade_extra_text = self:AddComponent(UIText, upgrade_extra_text_path)
    self.upgrade_extra_num = self:AddComponent(UIText, upgrade_extra_num_path)
    self.upgrade_extra_time_text = self:AddComponent(UIText, upgrade_extra_time_text_path)
    self.upgrade_extra_time_count = self:AddComponent(UIText, upgrade_extra_time_count_path)
    self.upgrade_immediately_btn = self:AddComponent(UIButton, upgrade_immediately_btn_path)
    self.upgrade_immediately_btn_name = self:AddComponent(UIText, upgrade_immediately_btn_name_path)
    self.upgrade_immediately_btn_spend_icon = self:AddComponent(UIImage, upgrade_immediately_btn_spend_icon_path)
    self.upgrade_immediately_btn_spend_count = self:AddComponent(UIText, upgrade_immediately_btn_spend_count_path)
    self.upgrade_upgrade_btn = self:AddComponent(UIButton, upgrade_upgrade_btn_path)
    self.upgrade_upgrade_btn_name = self:AddComponent(UIText, upgrade_upgrade_btn_name_path)
    self.upgrade_upgrade_btn_spend_time = self:AddComponent(UIText, upgrade_upgrade_btn_spend_time_path)
    self.speed_up_btn_text = self:AddComponent(UIText, upgrade_speed_btn_name_path)
    self.bg_go = self:AddComponent(UIBaseContainer, bg_go_path)
    self.upgrading_icon = self:AddComponent(UIImage, upgrading_icon_path)
    self.upgrading_slider = self:AddComponent(UISlider, upgrading_slider_path)
    self.upgrading_slider_left_time = self:AddComponent(UIText, upgrading_slider_left_time_path)
    self.upgrading_num = self:AddComponent(UIText, upgrading_num_path)
    self.upgrading_icon_level = self:AddComponent(UIText, upgrading_icon_level_path)
    self.upgrade_immediately_btn:SetOnClick(function()
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      self:UpgradeImmediatelyBtnClick()
    end)
    self.upgrade_upgrade_btn:SetOnClick(function()
      DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Train_Start1, false)
      self:UpgradeTrainBtnClick()
    end)
    self.upgrade_input:SetOnEndEdit(function(value)
      self:InputListener(value)
    end)
    self.upgrade_slider:SetOnValueChanged(function(value)
      self:OnValueChange(value)
    end)
    self.upgradeDefine = true
  end
end

local function ComponentDestroy(self)
  if self.upgradeDefine then
    self.icon_go = nil
    self.left_icon = nil
    self.left_name = nil
    self.right_icon = nil
    self.right_name = nil
    self.upgrade_text = nil
    self.upgrade_slider = nil
    self.upgrade_input = nil
    self.upgrade_res_content = nil
    self.upgrade_extra_go = nil
    self.upgrade_extra_text = nil
    self.upgrade_extra_num = nil
    self.upgrade_extra_time_text = nil
    self.upgrade_extra_time_count = nil
    self.upgrade_immediately_btn = nil
    self.upgrade_immediately_btn_name = nil
    self.upgrade_immediately_btn_spend_icon = nil
    self.upgrade_immediately_btn_spend_count = nil
    self.upgrade_upgrade_btn = nil
    self.upgrade_upgrade_btn_name = nil
    self.upgrade_upgrade_btn_spend_time = nil
    self.back_btn = nil
    self.upgrading_icon = nil
    self.upgrading_slider = nil
    self.upgrading_slider_left_time = nil
    self.upgrading_num = nil
    self.upgrading_icon_level = nil
    self.speed_up_btn_text = nil
  end
end

local function DataDefine(self)
  self.param = {}
  self.maxTrain = nil
  self.minTrain = nil
  self.extra = nil
  self.need_res_cell = nil
  self.freeNeedResourceCells = {}
  self.needResourceCells = {}
  self.realMaxTrain = nil
  self.isLoading = {}
  self.lastCurTime = 0
  self.queue = nil
end

local function DataDestroy(self)
  self.param = nil
  self.maxTrain = nil
  self.minTrain = nil
  self.extra = nil
  self.need_res_cell = nil
  self.freeNeedResourceCells = nil
  self.needResourceCells = nil
  self.upgradeFlagActive = nil
  self.realMaxTrain = nil
  self.isLoading = nil
  self.lastCurTime = nil
end

local function ReInit(self, param)
  self.param = param
  self:ComponentDefine()
  self.maxTrain = param.maxTrain
  self.minTrain = param.minTrain
  self.extra = param.extra
  self.need_res_cell = param.need_res_cell
  local queueType = DataCenter.ArmyManager:GetArmyQueueTypeByBuildId(param.buildId)
  self.queue = DataCenter.ArmyManager:GetArmyQueue(queueType)
  if param.armyId ~= nil then
    self.template = DataCenter.ArmyTemplateManager:GetArmyTemplate(self.param.armyId)
    if self.template ~= nil then
      self:SetLeftIconImage(self.template.icon)
      self:SetLeftNameText(Localization:GetString(self.template.name))
      self.left_lv:SetText(RomeNum[self.template.level])
      self:SetUpgradeText(Localization:GetString(self.template.des))
    end
  end
  if param.armyMaxId ~= nil then
    self.maxTemplate = DataCenter.ArmyTemplateManager:GetArmyTemplate(self.param.armyMaxId)
    if self.maxTemplate ~= nil then
      self:SetRightIconImage(self.maxTemplate.icon)
      self:SetRightNameText(Localization:GetString(self.maxTemplate.name))
      self.right_lv:SetText(RomeNum[self.maxTemplate.level])
    end
  end
  self:SetUpgradeImmediatelyBtnIconImage(param.goldImage)
  if self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work then
    self.upgrading_slider:SetActive(true)
    self.upgrade_slider:SetActive(false)
    self.bg_go:SetActive(false)
    self:SetUpgradeImmediatelyBtnText(Localization:GetString(GameDialogDefine.IMMEDIATELY_ADD_SPEED))
    self:SetUpgradeBtnText(Localization:GetString(GameDialogDefine.ADD_SPEED))
    self:SetUpgradeSpendTimeText("")
    local num = 0
    local armyId = ""
    local tempList = string.split(self.queue.itemId, ";")
    if tempList ~= nil and 3 < #tempList then
      num = tempList[4]
      armyId = tempList[3]
    elseif tempList ~= nil and 1 < #tempList then
      armyId = tempList[1]
      num = tempList[2]
    end
    self.upgrading_num:SetText(string.GetFormattedSeperatorNum(num))
    local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyId)
    if template ~= nil then
      self.upgrading_icon:LoadSprite(string.format(LoadPath.SoldierIcons, template.icon))
      self.upgrading_icon_level:SetText(RomeNum[template.level])
    end
    self:UpdateLeftTime()
  else
    self.upgrading_slider:SetActive(false)
    self.upgrade_slider:SetActive(true)
    self.upgrade_upgrade_btn:SetActive(true)
    self.bg_go:SetActive(true)
    self:SetUpgradeImmediatelyBtnText(Localization:GetString("110013"))
    self:SetUpgradeBtnText(Localization:GetString(GameDialogDefine.ARMY_UPGRADE))
    if self.extra == nil then
      self:SetExtraActive(false)
    else
      self:SetExtraActive(true)
      self:SetExtraTextText(Localization:GetString("200001"))
      self:SetExtraTimeTextText(Localization:GetString("120121"))
      self:SetExtraNumText(string.GetFormattedSeperatorNum(self.extra.num))
      self:SetExtraTimeCountText(self.extra.time)
    end
    if param.armyId ~= nil then
      local army = DataCenter.ArmyManager:FindArmy(self.param.armyId)
      if army == nil then
        self.realMaxTrain = 0
      elseif army.free < self.maxTrain then
        self.realMaxTrain = army.free
      else
        self.realMaxTrain = self.maxTrain
      end
    end
    if self.maxTemplate ~= nil and self.template ~= nil then
      self.perTime = self.maxTemplate:GetTrainTime() - self.template:GetTrainTime()
    end
    self:SetUpgradeSliderValue(1)
    self:SetInputText(self.realMaxTrain)
    self:RefreshUpgradeCount()
  end
end

local function SetInputText(self, value)
  if self.inputCount ~= value then
    self.inputCount = value
    self.upgrade_input:SetText(string.GetFormattedSeperatorNum(value))
  end
end

local function SetExtraActive(self, value)
  if self.extraActive ~= value then
    self.extraActive = value
    self.upgrade_extra_go.gameObject:SetActive(value)
  end
end

local function SetExtraTextText(self, value)
  if self.extraText ~= value then
    self.extraText = value
    self.upgrade_extra_text:SetText(value)
  end
end

local function SetExtraNumText(self, value)
  if self.extraNum ~= value then
    self.extraNum = value
    self.upgrade_extra_num:SetText(value)
  end
end

local function SetExtraTimeTextText(self, value)
  if self.extraTimeText ~= value then
    self.extraTimeText = value
    self.upgrade_extra_time_text:SetText(value)
  end
end

local function SetExtraTimeCountText(self, value)
  if self.extraTimeCount ~= value then
    self.extraTimeCount = value
    self.upgrade_extra_time_count:SetText(value)
  end
end

local function SetUpgradeSpendTimeText(self, value)
  if self.trainSpendTimeText ~= value then
    self.trainSpendTimeText = value
    self.upgrade_upgrade_btn_spend_time:SetText(value)
  end
end

local function RefreshUpgradeTime(self)
  local x, y = math.modf(self.perTime * self.inputCount)
  self:SetUpgradeSpendTimeText(UITimeManager:GetInstance():SecondToFmtString(x))
end

local function InputListener(self, value)
  local temp = value
  if temp ~= nil and temp ~= "" then
    local inputCount = tonumber(temp)
    if inputCount < self.minTrain then
      self.inputCount = nil
      self:SetInputText(self.minTrain)
    elseif inputCount > self.realMaxTrain then
      self.inputCount = nil
      self:SetInputText(self.realMaxTrain)
    else
      self:SetInputText(inputCount)
    end
    self.noChangeSlider = true
    self:SetUpgradeSliderValue(self.inputCount / self.realMaxTrain)
    self:RefreshUpgradeTime()
  else
    local sub = self.inputCount
    self.inputCount = nil
    self:SetInputText(sub)
  end
end

local function RefreshUpgradeCount(self)
  self:ShowNeedResource()
  self:RefreshUpgradeTime()
  self:RefreshImmediatelyGold()
end

local function OnValueChange(self, val)
  if self.noChangeSlider then
    self.noChangeSlider = false
  else
    self.selectSliderValue = val
    local inputCount = math.floor(val * self.realMaxTrain + 0.5)
    if inputCount < self.minTrain then
      self.inputCount = nil
      self:SetInputText(self.minTrain)
    else
      self:SetInputText(inputCount)
    end
    self:RefreshUpgradeCount()
  end
end

local function SetLeftIconImage(self, imageName)
  self.left_icon:LoadSprite(string.format(LoadPath.SoldierIcons, imageName))
end

local function SetRightIconImage(self, imageName)
  self.right_icon:LoadSprite(string.format(LoadPath.SoldierIcons, imageName))
end

local function SetLeftNameText(self, value)
end

local function SetRightNameText(self, value)
end

local function SetUpgradeText(self, value)
  if self.upgradeText ~= value then
    self.upgradeText = value
    self.upgrade_text:SetText(value)
  end
end

local function SetUpgradeImmediatelyBtnText(self, value)
  if self.immediatelyBtnText ~= value then
    self.immediatelyBtnText = value
    self.upgrade_immediately_btn_name:SetText(value)
  end
end

local function SetUpgradeImmediatelyBtnSpendText(self, value)
  if self.immediatelyBtnSpendText ~= value then
    self.immediatelyBtnSpendText = value
    self.upgrade_immediately_btn_spend_count:SetText(value)
  end
end

local function SetUpgradeImmediatelyBtnSpendColor(self, value)
  if self.immediatelySpeedBtnSpendColor ~= value then
    self.immediatelySpeedBtnSpendColor = value
    self.upgrade_immediately_btn_spend_count:SetColor(value)
  end
end

local function SetUpgradeImmediatelyBtnIconImage(self, imageName)
  self.upgrade_immediately_btn_spend_icon:LoadSprite(imageName)
end

local function SetUpgradeBtnText(self, value)
  if self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work then
    self.speed_up_btn_text:SetText(value)
    self.upgrade_upgrade_btn_name:SetText("")
    self.upgradeBtnText = ""
  else
    self.speed_up_btn_text:SetText("")
    if self.upgradeBtnText ~= value then
      self.upgradeBtnText = value
      self.upgrade_upgrade_btn_name:SetText(value)
    end
  end
end

local function RefreshImmediatelyGold(self)
  if self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work then
    self:SetUpgradeImmediatelyBtnSpendText(string.GetFormattedSeperatorNum(self.spendGold))
  else
    local x, y = math.modf(self.perTime * self.inputCount)
    self.spendGold = CommonUtil.GetTimeDiamondCost(x)
    self:SetUpgradeImmediatelyBtnSpendText(string.GetFormattedSeperatorNum(self.spendGold))
  end
  self:RefreshGoldColor()
end

local function RefreshGoldColor(self)
  local gold = LuaEntry.Player.gold
  if gold < self.spendGold then
    self:SetUpgradeImmediatelyBtnSpendColor(RedColor)
  else
    self:SetUpgradeImmediatelyBtnSpendColor(WhiteColor)
  end
end

local function ShowNeedResource(self)
  if self.param.isUpgrading then
    return
  end
  self.lackResource = {}
  for k, v in pairs(self.needResourceCells) do
    v.gameObject:SetActive(false)
    table.insert(self.freeNeedResourceCells, v)
  end
  self.needResourceCells = {}
  local curResources = self.template.needResource
  local resources = self.maxTemplate.needResource
  local needShowRes = {}
  if resources ~= nil then
    for i = 1, table.count(resources) do
      local k1 = resources[i].resourceType
      local v1 = resources[i].count
      local alreadyCost = 0
      table.walk(curResources, function(k, v)
        if v ~= nil and v.resourceType == k1 then
          alreadyCost = v.count
        end
      end)
      if v1 > alreadyCost then
        do
          local param = UINeedResCell.Param.New()
          param.resourceType = k1
          param.count = (v1 - alreadyCost) * self.inputCount
          local own = LuaEntry.Resource:GetCntByResType(k1)
          if own < param.count then
            self.lackResource[k1] = param.count
            param.isRed = true
          else
            param.isRed = false
          end
          param.prefabName = tostring(param.resourceType)
          table.insert(needShowRes, k1)
          self:AddOneNeedResourceCells(param)
        end
      end
    end
  end
  if 0 < table.count(needShowRes) then
    local param = {}
    param.list = needShowRes
    param.uiName = UIWindowNames.UITrain
    EventManager:GetInstance():Broadcast(EventId.ShowMainUIExtraResource, param)
  end
  self.hasItem = false
  local lastItems = self.template.needItem
  local items = self.maxTemplate.needItem
  if items ~= nil then
    for i = 1, table.count(items) do
      local k1 = items[i].itemId
      local v1 = items[i].count
      local lastCount = 0
      local lastRe = lastItems[i]
      if lastRe ~= nil then
        lastCount = lastRe.count
      end
      if v1 ~= lastCount then
        local param = UINeedResCell.Param.New()
        param.itemId = k1
        param.count = (v1 - lastCount) * self.inputCount
        local own = 0
        local item = DataCenter.ItemData:GetItemById(param.itemId)
        if item ~= nil then
          own = item.count
        end
        if v1 > own then
          self.lackItem[k1] = v1
          param.isRed = true
        else
          param.isRed = false
        end
        self:AddOneNeedResourceCells(param)
        self.hasItem = true
      end
    end
  end
end

local function AddOneNeedResourceCells(self, param)
  if #self.freeNeedResourceCells > 0 then
    local temp = table.remove(self.freeNeedResourceCells)
    if temp ~= nil then
      temp.gameObject:SetActive(true)
      temp:ReInit(param)
      temp.transform:SetParent(self.upgrade_res_content.transform)
      temp.transform:SetAsLastSibling()
      self.needResourceCells[param.prefabName] = temp
    end
  elseif self.isLoading[param.prefabName] == nil and self.needResourceCells[param.prefabName] == nil then
    self.isLoading[param.prefabName] = true
    self:GameObjectInstantiateAsync(UIAssets.UITrainNeedResCell, function(request)
      self.isLoading[param.prefabName] = false
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.upgrade_res_content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:SetAsLastSibling()
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      self.needResourceCells[param.prefabName] = self.upgrade_res_content:AddComponent(UINeedResCell, nameStr)
      self.needResourceCells[param.prefabName]:ReInit(param)
    end)
  end
end

local function SetUpgradeSliderValue(self, value)
  if self.selectSliderValue ~= value then
    self.selectSliderValue = value
    self.upgrade_slider:SetValue(value)
  end
end

local function UpgradeImmediatelyBtnClick(self)
  if self.immediatelySpeedBtnSpendColor == RedColor then
    GoToUtil.GotoPayTips()
  elseif self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work then
    UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.UpgradeUseDiamond, Localization:GetString(GameDialogDefine.USE_GOLF_TIP_DES), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      DataCenter.ArmyManager:SendSpeedFinishQueue(self.queue.uuid)
    end, function()
    end)
  elseif self.lackResource ~= nil and table.count(self.lackResource) > 0 then
    local lackTab = {}
    for k, v in pairs(self.lackResource) do
      local param = {}
      param.type = ResLackType.Res
      param.resType = k
      param.targetNum = v
      table.insert(lackTab, param)
    end
    GoToResLack.GoToItemResLackList(lackTab)
  else
    SFSNetwork.SendMessage(MsgDefines.SoldierUp, {
      curArmyId = self.param.armyId,
      num = self.inputCount,
      isGold = true
    })
  end
end

local function UpgradeTrainBtnClick(self)
  if self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, {anim = true}, ItemSpdMenu.ItemSpdMenu_Soldier, self.queue.uuid)
  elseif self.lackResource ~= nil and table.count(self.lackResource) > 0 then
    local lackTab = {}
    for k, v in pairs(self.lackResource) do
      local param = {}
      param.type = ResLackType.Res
      param.resType = k
      param.targetNum = v
      table.insert(lackTab, param)
    end
    GoToResLack.GoToItemResLackList(lackTab)
  else
    SFSNetwork.SendMessage(MsgDefines.SoldierUp, {
      curArmyId = self.param.armyId,
      num = self.inputCount,
      isGold = false
    })
  end
end

local function UpdateLeftTime(self)
  if self.queue ~= nil then
    if self.queue:GetQueueState() == NewQueueState.Finish then
      self.view.ctrl:CloseSelf()
      return
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local changeTime = self.queue.endTime - curTime
    local maxTime = self.queue.endTime - self.queue.startTime
    if changeTime < maxTime and 0 < changeTime then
      local tempTimeSec = math.ceil(changeTime / 1000)
      if tempTimeSec ~= self.laseTime then
        self.laseTime = tempTimeSec
        local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(changeTime)
        self.upgrading_slider_left_time:SetText(tempTimeValue)
        self.spendGold = CommonUtil.GetTimeDiamondCost(math.ceil(tempTimeSec))
        self:RefreshImmediatelyGold()
      end
      if 0 < maxTime then
        local tempValue = 1 - changeTime / maxTime
        if TimeBarUtil.CheckIsNeedChangeBar(changeTime, self.queue.endTime - self.lastCurTime, maxTime, UpgradingSliderLength) then
          self.lastCurTime = curTime
          self.upgrading_slider:SetValue(tempValue)
        end
      end
    else
      self.laseTime = 0
      self.upgrading_slider:SetValue(0)
      self.upgrading_slider_left_time:SetText("")
    end
  end
end

local function IsUpgrading(self)
  if self.param == nil or table.IsEmpty(self.param) then
    return false
  end
  return self.param.isUpgrading
end

local function UpdateArmySignal(self)
  if self.param == nil or table.IsEmpty(self.param) then
    return
  end
  local param = self.view.ctrl:GetUpgradData(self.param.buildId, self.param.armyId)
  if param ~= nil and (param.free > 0 or param.isUpgrading) then
    self:ReInit(param)
    return true
  end
  self.view:CloseUpgradeView()
  return false
end

local function UpdateResourceSignal(self)
  if self.param == nil or table.IsEmpty(self.param) then
    return
  end
  self:ShowNeedResource()
end

local function UpdateGoldSignal(self)
  if self.param == nil or table.IsEmpty(self.param) then
    return
  end
  self:RefreshGoldColor()
end

local function UpdateItemSignal(self)
  if self.param == nil or table.IsEmpty(self.param) then
    return
  end
  self:ShowNeedResource()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.UpdateItemSignal)
  self:AddUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
  self:AddUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
  self:AddUIListener(EventId.TrainingArmy, self.UpdateArmySignal)
  self:AddUIListener(EventId.TrainingArmyFinish, self.UpdateArmySignal)
  self:AddUIListener(EventId.TrainArmyData, self.UpdateArmySignal)
  self:AddUIListener(EventId.AddSpeedSuccess, self.UpdateArmySignal)
  self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateArmySignal)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.UpdateItemSignal)
  self:RemoveUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
  self:RemoveUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
  self:RemoveUIListener(EventId.TrainingArmy, self.UpdateArmySignal)
  self:RemoveUIListener(EventId.TrainArmyData, self.UpdateArmySignal)
  self:RemoveUIListener(EventId.TrainingArmyFinish, self.UpdateArmySignal)
  self:RemoveUIListener(EventId.AddSpeedSuccess, self.UpdateArmySignal)
  self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateArmySignal)
end

UITrainUpgradeView.OnCreate = OnCreate
UITrainUpgradeView.OnDestroy = OnDestroy
UITrainUpgradeView.Param = Param
UITrainUpgradeView.OnEnable = OnEnable
UITrainUpgradeView.OnDisable = OnDisable
UITrainUpgradeView.ComponentDefine = ComponentDefine
UITrainUpgradeView.ComponentDestroy = ComponentDestroy
UITrainUpgradeView.DataDefine = DataDefine
UITrainUpgradeView.DataDestroy = DataDestroy
UITrainUpgradeView.ReInit = ReInit
UITrainUpgradeView.OnValueChange = OnValueChange
UITrainUpgradeView.RefreshUpgradeCount = RefreshUpgradeCount
UITrainUpgradeView.InputListener = InputListener
UITrainUpgradeView.RefreshUpgradeTime = RefreshUpgradeTime
UITrainUpgradeView.SetUpgradeSpendTimeText = SetUpgradeSpendTimeText
UITrainUpgradeView.SetExtraTimeCountText = SetExtraTimeCountText
UITrainUpgradeView.SetExtraTimeTextText = SetExtraTimeTextText
UITrainUpgradeView.SetExtraNumText = SetExtraNumText
UITrainUpgradeView.SetExtraTextText = SetExtraTextText
UITrainUpgradeView.SetExtraActive = SetExtraActive
UITrainUpgradeView.SetInputText = SetInputText
UITrainUpgradeView.SetLeftIconImage = SetLeftIconImage
UITrainUpgradeView.SetRightIconImage = SetRightIconImage
UITrainUpgradeView.SetLeftNameText = SetLeftNameText
UITrainUpgradeView.SetRightNameText = SetRightNameText
UITrainUpgradeView.SetUpgradeText = SetUpgradeText
UITrainUpgradeView.SetUpgradeImmediatelyBtnText = SetUpgradeImmediatelyBtnText
UITrainUpgradeView.SetUpgradeImmediatelyBtnSpendText = SetUpgradeImmediatelyBtnSpendText
UITrainUpgradeView.SetUpgradeImmediatelyBtnSpendColor = SetUpgradeImmediatelyBtnSpendColor
UITrainUpgradeView.SetUpgradeImmediatelyBtnIconImage = SetUpgradeImmediatelyBtnIconImage
UITrainUpgradeView.SetUpgradeBtnText = SetUpgradeBtnText
UITrainUpgradeView.RefreshImmediatelyGold = RefreshImmediatelyGold
UITrainUpgradeView.RefreshGoldColor = RefreshGoldColor
UITrainUpgradeView.ShowNeedResource = ShowNeedResource
UITrainUpgradeView.AddOneNeedResourceCells = AddOneNeedResourceCells
UITrainUpgradeView.SetUpgradeSliderValue = SetUpgradeSliderValue
UITrainUpgradeView.UpgradeImmediatelyBtnClick = UpgradeImmediatelyBtnClick
UITrainUpgradeView.UpgradeTrainBtnClick = UpgradeTrainBtnClick
UITrainUpgradeView.UpdateLeftTime = UpdateLeftTime
UITrainUpgradeView.IsUpgrading = IsUpgrading
UITrainUpgradeView.UpdateArmySignal = UpdateArmySignal
UITrainUpgradeView.OnAddListener = OnAddListener
UITrainUpgradeView.OnRemoveListener = OnRemoveListener
UITrainUpgradeView.UpdateResourceSignal = UpdateResourceSignal
UITrainUpgradeView.UpdateGoldSignal = UpdateGoldSignal
UITrainUpgradeView.UpdateItemSignal = UpdateItemSignal
return UITrainUpgradeView
