local UITrainView = BaseClass("UITrainView", UIBaseView)
local base = UIBaseView
local UINeedResCell = require("UI.UITrain.Component.UINeedResCell")
local UISoldierCell = require("UI.UITrain.Component.UISoldierCell")
local UITrainDetailView = require("UI.UITrain.Component.UITrainDetailView")
local UITrainUpgradeView = require("UI.UITrain.Component.UITrainUpgradeView")
local Localization = CS.GameEntry.Localization
local ResetSelectPosition = Vector3.New(0, -2, 0)
local GotoBtnPosition = Vector3.New(332, -304.5, 0)
local TrainBtnPosition = Vector3.New(456, -304.5, 0)
local close_btn_path = "safeArea/CloseBtn"
local title_text_path = "safeArea/title_main_new"
local animator_path = "safeArea"
local left_bg_path = "bg/UISolider_bg1"
local right_bg_path = "bg/UISolider_bg2"
local select_go_path = "UISoldier_img_choose"
local select_path = "safeArea/SelectGo/"
local details_btn_path = "safeArea/SelectGo/DetailsBtn"
local scroll_view_path = "safeArea/SelectGo/IconScrollView"
local type_image_path = "safeArea/SelectGo/TypeImage"
local type_text_path = "safeArea/SelectGo/TypeText"
local des_text_path = "safeArea/SelectGo/DesText"
local need_res_content_path = "safeArea/SelectGo/CountSliderGo/NeedResContent"
local select_slider_path = "safeArea/SelectGo/CountSliderGo/SelectSlider"
local select_input_field_path = "safeArea/SelectGo/CountSliderGo/SelectInputField"
local train_icon_path = "safeArea/SelectGo/TrainingSlider/TrainingIcon"
local train_icon_level_path = "safeArea/SelectGo/TrainingSlider/TrainingIcon/TrainingIconLevelText"
local train_slider_path = "safeArea/SelectGo/TrainingSlider"
local train_slider_left_time_path = "safeArea/SelectGo/TrainingSlider/TrainingLeftTime"
local train_num_path = "safeArea/SelectGo/TrainingSlider/TrainNum"
local no_reason_path = "safeArea/SelectGo/NoReasonText"
local no_upgrade_path = "safeArea/SelectGo/operate_btn_without_upgrade"
local immediately_btn_path = "safeArea/SelectGo/operate_btn_without_upgrade/Common_btn_yellow_big"
local immediately_btn_name_path = "safeArea/SelectGo/operate_btn_without_upgrade/Common_btn_yellow_big/btnTxt_yellow_mid_new/btnTxt_yellow_mid_new_text1"
local immediately_btn_spend_icon_path = "safeArea/SelectGo/operate_btn_without_upgrade/Common_btn_yellow_big/btnTxt_yellow_mid_new/btnTxt_yellow_mid_new_text2/btnTxt_yellow_mid_new_icon"
local immediately_btn_spend_count_path = "safeArea/SelectGo/operate_btn_without_upgrade/Common_btn_yellow_big/btnTxt_yellow_mid_new/btnTxt_yellow_mid_new_text2"
local train_btn_path = "safeArea/SelectGo/operate_btn_without_upgrade/Common_btn_green_big"
local train_btn_name_path = "safeArea/SelectGo/operate_btn_without_upgrade/Common_btn_green_big/btnTxt_green_mid_new/btnTxt_green_mid_new_text1"
local train_btn_spend_time_path = "safeArea/SelectGo/operate_btn_without_upgrade/Common_btn_green_big/btnTxt_green_mid_new/btnTxt_green_mid_new_text2"
local speed_btn_name_path = "safeArea/SelectGo/operate_btn_without_upgrade/Common_btn_green_big/btnTxt_green_big_new"
local has_upgrade_path = "safeArea/SelectGo/operate_btn_with_upgrade"
local immediately_small_btn_path = "safeArea/SelectGo/operate_btn_with_upgrade/Common_btn_yellow_small"
local immediately_small_btn_name_path = "safeArea/SelectGo/operate_btn_with_upgrade/Common_btn_yellow_small/btnTxt_yellow_mid_new_small/btnTxt_yellow_mid_new_small_txt1"
local immediately_small_btn_spend_icon_path = "safeArea/SelectGo/operate_btn_with_upgrade/Common_btn_yellow_small/btnTxt_yellow_mid_new_small/btnTxt_yellow_mid_new_small_txt2/btnTxt_yellow_mid_new_icon_small"
local immediately_small_btn_spend_count_path = "safeArea/SelectGo/operate_btn_with_upgrade/Common_btn_yellow_small/btnTxt_yellow_mid_new_small/btnTxt_yellow_mid_new_small_txt2"
local train_small_btn_path = "safeArea/SelectGo/operate_btn_with_upgrade/Common_btn_green_small1"
local train_small_btn_name_path = "safeArea/SelectGo/operate_btn_with_upgrade/Common_btn_green_small1/btnTxt_green_mid_new_small/btnTxt_green_mid_new_small_txt1"
local train_small_btn_spend_time_path = "safeArea/SelectGo/operate_btn_with_upgrade/Common_btn_green_small1/btnTxt_green_mid_new_small/btnTxt_green_mid_new_small_txt2"
local upgrade_btn_path = "safeArea/SelectGo/operate_btn_with_upgrade/Common_btn_green_small2"
local upgrade_btn_name_path = "safeArea/SelectGo/operate_btn_with_upgrade/Common_btn_green_small2/btnTxt_green_big_new_small"
local gray_img_path = "gray"
local slider_go_path = "safeArea/SelectGo/CountSliderGo"
local detail_go_path = "safeArea/DetailGo"
local back_btn_path = "safeArea/DetailGo/BackBtn"
local upgrade_go_path = "safeArea/UpgradeGo"
local SliderLength = 408
local ScreenCell = 5

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.left_bg = self:AddComponent(UIImage, left_bg_path)
  self.right_bg = self:AddComponent(UIImage, right_bg_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.animator = self:AddComponent(UIAnimator, animator_path)
  self.gray_img = self:AddComponent(UIImage, animator_path)
  self.select_go = self:AddComponent(UIBaseContainer, select_go_path)
  self.select = self:AddComponent(UIBaseContainer, select_path)
  self.details_btn = self:AddComponent(UIButton, details_btn_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.type_image = self:AddComponent(UIImage, type_image_path)
  self.type_text = self:AddComponent(UIText, type_text_path)
  self.des_text = self:AddComponent(UIText, des_text_path)
  self.need_res_content = self:AddComponent(UIBaseContainer, need_res_content_path)
  self.select_slider = self:AddComponent(UISlider, select_slider_path)
  self.select_input_field = self:AddComponent(UIInput, select_input_field_path)
  self.train_icon = self:AddComponent(UIImage, train_icon_path)
  self.train_slider = self:AddComponent(UISlider, train_slider_path)
  self.train_slider_left_time = self:AddComponent(UIText, train_slider_left_time_path)
  self.train_num = self:AddComponent(UIText, train_num_path)
  self.no_reason = self:AddComponent(UIText, no_reason_path)
  self.no_reason_btn = self:AddComponent(UIButton, no_reason_path)
  self.immediately_btn = self:AddComponent(UIButton, immediately_btn_path)
  self.immediately_btn_name = self:AddComponent(UIText, immediately_btn_name_path)
  self.immediately_btn_spend_icon = self:AddComponent(UIImage, immediately_btn_spend_icon_path)
  self.immediately_btn_spend_count = self:AddComponent(UIText, immediately_btn_spend_count_path)
  self.immediately_btn_spend_count_shadow = self:AddComponent(UIShadow, immediately_btn_spend_count_path)
  self.train_btn = self:AddComponent(UIButton, train_btn_path)
  self.train_btn_name = self:AddComponent(UIText, train_btn_name_path)
  self.train_btn_spend_time = self:AddComponent(UIText, train_btn_spend_time_path)
  self.speed_btn_name = self:AddComponent(UIText, speed_btn_name_path)
  self.small_immediately_btn = self:AddComponent(UIButton, immediately_small_btn_path)
  self.small_immediately_btn_name = self:AddComponent(UIText, immediately_small_btn_name_path)
  self.small_immediately_btn_spend_icon = self:AddComponent(UIImage, immediately_small_btn_spend_icon_path)
  self.small_immediately_btn_spend_count = self:AddComponent(UIText, immediately_small_btn_spend_count_path)
  self.small_immediately_btn_spend_count_shadow = self:AddComponent(UIShadow, immediately_small_btn_spend_count_path)
  self.small_train_btn = self:AddComponent(UIButton, train_small_btn_path)
  self.small_train_btn_name = self:AddComponent(UIText, train_small_btn_name_path)
  self.small_train_btn_spend_time = self:AddComponent(UIText, train_small_btn_spend_time_path)
  self.small_upgrade_btn = self:AddComponent(UIButton, upgrade_btn_path)
  self.btn_image = self:AddComponent(UIImage, upgrade_btn_path)
  self.gray_image = self:AddComponent(UIImage, gray_img_path)
  self.gray = self.gray_image:GetMaterial()
  self.small_upgrade_btn_name = self:AddComponent(UIText, upgrade_btn_name_path)
  self.upgrade_shadow = self:AddComponent(UIShadow, upgrade_btn_name_path)
  self.has_upgrade = self:AddComponent(UIBaseContainer, has_upgrade_path)
  self.no_upgrade = self:AddComponent(UIBaseContainer, no_upgrade_path)
  self.slider_go = self:AddComponent(UIBaseContainer, slider_go_path)
  self.detail_go = self:AddComponent(UITrainDetailView, detail_go_path)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.train_icon_level = self:AddComponent(UIText, train_icon_level_path)
  self.upgrade_go = self:AddComponent(UITrainUpgradeView, upgrade_go_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.close_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnCloseClick()
  end)
  self.details_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:DetailsBtnClick()
  end)
  self.back_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:BackBtnClick()
  end)
  self.immediately_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnImmediatelyBtnClick()
  end)
  self.train_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Train_Start1, false)
    self:OnTrainBtnClick()
  end)
  self.small_immediately_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnImmediatelyBtnClick()
  end)
  self.small_train_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Train_Start1, false)
    self:OnTrainBtnClick()
  end)
  self.small_upgrade_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Train_Start1, false)
    self:OnUpgradeBtnClick()
  end)
  self.select_input_field:SetOnEndEdit(function(value)
    self:InputListener(value)
  end)
  self.select_slider:SetOnValueChanged(function(value)
    self:OnValueChange(value)
  end)
end

local function ComponentDestroy(self)
  self.upgrade_go:SetActive(false)
  self.upgrade_go = nil
  self.left_bg = nil
  self.right_bg = nil
  self.close_btn = nil
  self.title_text = nil
  self.animator = nil
  self.select_go = nil
  self.details_btn = nil
  self.scroll_view = nil
  self.type_image = nil
  self.type_text = nil
  self.des_text = nil
  self.need_res_content = nil
  self.select_slider = nil
  self.select_input_field = nil
  self.train_icon = nil
  self.train_slider = nil
  self.train_slider_left_time = nil
  self.train_num = nil
  self.no_reason = nil
  self.no_reason_btn = nil
  self.immediately_btn = nil
  self.immediately_btn_name = nil
  self.immediately_btn_spend_icon = nil
  self.immediately_btn_spend_count = nil
  self.train_btn = nil
  self.train_btn_name = nil
  self.train_btn_spend_time = nil
  self.speed_btn_name = nil
  self.slider_go = nil
  self.detail_go = nil
  self.back_btn = nil
  self.gray_img = nil
  self.immediately_btn_spend_count_shadow = nil
  self.train_icon_level = nil
  self.small_immediately_btn = nil
  self.small_immediately_btn_name = nil
  self.small_immediately_btn_spend_icon = nil
  self.small_immediately_btn_spend_count = nil
  self.small_immediately_btn_spend_count_shadow = nil
  self.small_train_btn = nil
  self.small_train_btn_name = nil
  self.small_train_btn_spend_time = nil
  self.small_upgrade_btn = nil
  self.small_upgrade_btn_name = nil
  self.has_upgrade = nil
  self.no_upgrade = nil
end

local function DataDefine(self)
  self.gray = self.gray_img:GetMaterial()
  self.buildId = nil
  self.queue = nil
  self.idList = {}
  self.curSelectIndex = 1
  self.maxUnlockId = 0
  self.cells = {}
  self.trainSliderGoActive = nil
  self.laseTime = 0
  self.state = UITrainState.Select
  self.perTime = nil
  self.inputCount = nil
  self.spendGold = nil
  self.immediatelyBtnSpendText = nil
  self.immediatelyBtnSpendColor = nil
  self.lastCurTime = 0
  self.maxTrain = 1
  self.minTrain = 1
  self.selectSliderValue = 0
  self.lackResource = {}
  self.needResourceCells = {}
  self.freeNeedResourceCells = {}
  self.hasItem = nil
  self.lackItem = {}
  self.trainSpendTimeText = nil
  self.gotoType = nil
  self.gotoId = nil
  self.noChangeSlider = nil
  self.isLoading = {}
  self.isUpgrading = false
end

local function DataDestroy(self)
  EventManager:GetInstance():Broadcast(EventId.HideMainUIExtraResource, UIWindowNames.UITrain)
  self.gray = nil
  self:SetSelect()
  self.buildId = nil
  self.queue = nil
  self.idList = nil
  self.curSelectIndex = nil
  self.maxUnlockId = nil
  self.cells = nil
  self.trainSliderGoActive = nil
  self.laseTime = nil
  self.state = nil
  self.perTime = nil
  self.inputCount = nil
  self.spendGold = nil
  self.immediatelyBtnSpendText = nil
  self.immediatelyBtnSpendColor = nil
  self.lastCurTime = nil
  self.maxTrain = nil
  self.minTrain = nil
  self.selectSliderValue = nil
  self.lackResource = nil
  self.needResourceCells = nil
  self.freeNeedResourceCells = nil
  self.hasItem = nil
  self.lackItem = nil
  self.trainSpendTimeText = nil
  self.gotoType = nil
  self.gotoId = nil
  self.noChangeSlider = nil
  self.isLoading = nil
  self.isUpgrading = false
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.UpdateItemSignal)
  self:AddUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
  self:AddUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
  self:AddUIListener(EventId.TrainingArmy, self.TrainingArmySignal)
  self:AddUIListener(EventId.TrainingArmyFinish, self.UpdateArmySignal)
  self:AddUIListener(EventId.TrainArmyData, self.UpdateArmySignal)
  self:AddUIListener(EventId.AddSpeedSuccess, self.UpdateArmySignal)
  self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildSignal)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.UpdateItemSignal)
  self:RemoveUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
  self:RemoveUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
  self:RemoveUIListener(EventId.TrainingArmy, self.TrainingArmySignal)
  self:RemoveUIListener(EventId.TrainArmyData, self.UpdateArmySignal)
  self:RemoveUIListener(EventId.TrainingArmyFinish, self.UpdateArmySignal)
  self:RemoveUIListener(EventId.AddSpeedSuccess, self.UpdateArmySignal)
  self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildSignal)
end

local function ReInit(self)
  local temp, showType = self:GetUserData()
  self.buildId = tonumber(temp)
  self.showType = 0
  if showType ~= nil then
    self.showType = tonumber(showType)
  end
  local queueType = DataCenter.ArmyManager:GetArmyQueueTypeByBuildId(self.buildId)
  if queueType == NewQueueType.FootSoldier then
    self.left_bg:LoadSprite("Assets/Main/TextureEx/UISoldier/UISoldier_img_pic01")
    self.right_bg:LoadSprite("Assets/Main/TextureEx/UISoldier/UISoldier_img_pic01-2")
  elseif queueType == NewQueueType.CarSoldier then
    self.left_bg:LoadSprite("Assets/Main/TextureEx/UISoldier/UISoldier_img_pic03")
    self.right_bg:LoadSprite("Assets/Main/TextureEx/UISoldier/UISoldier_img_pic03-2")
  elseif queueType == NewQueueType.BowSoldier then
    self.left_bg:LoadSprite("Assets/Main/TextureEx/UISoldier/UISoldier_img_pic02")
    self.right_bg:LoadSprite("Assets/Main/TextureEx/UISoldier/UISoldier_img_pic02-2")
  end
  self.queue = DataCenter.ArmyManager:GetArmyQueue(queueType)
  self.maxUnlockId = DataCenter.ArmyManager:GetMaxUnLockId(self.buildId)
  self.idList = DataCenter.ArmyManager:GetArmyList(self.buildId)
  self:GetCurSelectId()
  if self.showType > 0 then
    self.curSelectIndex = self.curSelectIndex + 1
  end
  self.title_text:SetLocalText(GameDialogDefine.TRAIN_ARMY)
  self:ShowCells()
  self.immediately_btn_spend_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold))
  self.small_immediately_btn_spend_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold))
  self:RefreshSelect()
  self:ShowUpgradeWhenReInit()
end

local function ShowUpgradeWhenReInit(self)
  local isUpgrading = false
  local tempList
  if self.queue ~= nil then
    tempList = string.split(self.queue.itemId, ";")
    if self.queue:GetQueueState() == NewQueueState.Work and tempList ~= nil and 3 < #tempList then
      isUpgrading = true
    end
  end
  if tempList and isUpgrading then
    self.select_go:SetActive(false)
    self.title_text:SetLocalText(GameDialogDefine.ARMY_UPGRADE_TITLE)
    local param = self.ctrl:GetUpgradData(self.buildId)
    self.upgrade_go:ReInit(param)
    self.animator:Play("ToUpgrade", 0, 0)
    self.isUpgrading = true
  else
    self.select_go:SetActive(true)
    self.title_text:SetLocalText(GameDialogDefine.TRAIN_ARMY)
    self.animator:Play("UpgradeToTrain", 0, 0)
    self.isUpgrading = false
  end
end

local function ClearScroll(self)
  self:SetSelect()
  self.cells = {}
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UISoldierCell)
end

local function RefreshImmediatelyGold(self)
  if self.state == UITrainState.Select then
    if self.perTime ~= nil and self.inputCount ~= nil then
      local x, y = math.modf(self.perTime * self.inputCount)
      self.spendGold = CommonUtil.GetTimeDiamondCost(x)
      if table.count(self.lackResource) > 0 then
        for k, v in pairs(self.lackResource) do
          self.spendGold = self.spendGold + CommonUtil.GetResGoldByType(k, v)
        end
      end
      self:SetImmediatelyBtnSpendText(string.GetFormattedSeperatorNum(self.spendGold))
      self:RefreshGoldColor()
    end
  elseif self.state == UITrainState.Training then
    self:SetImmediatelyBtnSpendText(string.GetFormattedSeperatorNum(self.spendGold))
    self:RefreshGoldColor()
  end
end

local function RefreshGoldColor(self)
  local gold = LuaEntry.Player.gold
  if gold < self.spendGold then
    self:SetImmediatelyBtnSpendColor(RedColor)
  else
    self:SetImmediatelyBtnSpendColor(WhiteColor)
  end
end

local function ShowNeedResource(self)
  self.lackResource = {}
  for k, v in pairs(self.needResourceCells) do
    v:SetActive(false)
    table.insert(self.freeNeedResourceCells, v)
  end
  self.needResourceCells = {}
  local resources = self.curArmyTemplate.needResource
  if resources ~= nil then
    for k1, v1 in ipairs(resources) do
      local param = UINeedResCell.Param.New()
      param.resourceType = v1.resourceType
      param.count = v1.count * self.inputCount
      local own = LuaEntry.Resource:GetCntByResType(param.resourceType)
      if own < param.count then
        self.lackResource[v1.resourceType] = param.count
        param.isRed = true
      else
        param.isRed = false
      end
      param.prefabName = tostring(param.resourceType)
      self:AddOneNeedResourceCells(param)
    end
  end
  self.hasItem = false
  self.lackItem = {}
  local items = self.curArmyTemplate.needItem
  if items ~= nil then
    for k1, v1 in ipairs(items) do
      local param = UINeedResCell.Param.New()
      param.itemId = v1.itemId
      param.count = v1.count * self.inputCount
      local own = 0
      local item = DataCenter.ItemData:GetItemById(param.itemId)
      if item ~= nil then
        own = item.count
      end
      if own < v1.count then
        self.lackItem[v1.itemId] = v1.count
        param.isRed = true
      else
        param.isRed = false
      end
      param.prefabName = param.itemId
      self:AddOneNeedResourceCells(param)
      self.hasItem = true
    end
  end
end

local function AddOneNeedResourceCells(self, param)
  if #self.freeNeedResourceCells > 0 then
    local temp = table.remove(self.freeNeedResourceCells)
    if temp ~= nil then
      temp:SetActive(true)
      temp:ReInit(param)
      temp.transform:SetParent(self.need_res_content.transform)
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
      go.transform:SetParent(self.need_res_content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform:SetAsLastSibling()
      local nameStr = tostring(NameCount)
      go.name = nameStr
      NameCount = NameCount + 1
      self.needResourceCells[param.prefabName] = self.need_res_content:AddComponent(UINeedResCell, nameStr)
      self.needResourceCells[param.prefabName]:ReInit(param)
    end)
  end
end

local function OnCreateCell(self, itemObj, index)
  local armyId = self.idList[index]
  itemObj.name = armyId
  self.cells[index] = self.scroll_view:AddComponent(UISoldierCell, itemObj)
  local param = UISoldierCell.Param.New()
  param.armyId = armyId
  
  function param.callBack(clickIndex)
    self:CellsCallBack(clickIndex)
  end
  
  param.isUnLock = DataCenter.ArmyManager:IsUnLock(armyId)
  param.isToUnLock = DataCenter.ArmyManager:GetArmyUnlock(self.buildId) == armyId
  param.index = index
  param.gray = self.gray
  param.isSelect = index == self.curSelectIndex
  param.buildId = self.buildId
  self.cells[index]:ReInit(param)
  if index == self.curSelectIndex then
    self:SetSelect(index)
  end
end

local function OnDeleteCell(self, itemObj, index)
  self.cells[index] = nil
  if index == self.curSelectIndex then
    self:SetSelect()
  end
  self.scroll_view:RemoveComponent(itemObj.name, UISoldierCell)
end

local function ShowCells(self)
  self:ClearScroll()
  local count = table.count(self.idList)
  if 0 < count then
    self.scroll_view:SetTotalCount(count)
    local min = ScreenCell
    local max = count
    local showIndex = self.curSelectIndex
    if min >= showIndex then
      showIndex = 1
    elseif max < showIndex then
      showIndex = max
    else
      showIndex = showIndex - min + 1
    end
    self.scroll_view:RefillCells(showIndex)
  end
end

local function SetSelect(self, index)
  if index == nil then
    self.select_go.transform:SetParent(self.transform)
    self.select_go:SetActive(false)
  else
    local cell = self.cells[index]
    if cell ~= nil then
      self.select_go:SetActive(true)
      self.select_go.transform:SetParent(cell:GetSelectGo())
      self.select_go.transform:SetAsFirstSibling()
      self.select_go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      self.select_go.transform.localPosition = ResetSelectPosition
    end
  end
end

local function CellsCallBack(self, index)
  if self.curSelectIndex ~= index then
    self:SetCellSelect(self.curSelectIndex, false)
    self.curSelectIndex = index
    self:SetCellSelect(self.curSelectIndex, true)
    self:SetSelect(self.curSelectIndex)
    self:RefreshSelect()
  end
end

local function RefreshSelect(self)
  local id = self.idList[self.curSelectIndex]
  self.curArmyTemplate = DataCenter.ArmyTemplateManager:GetArmyTemplate(id)
  local showUpgrade = DataCenter.ArmyManager:IsCanUpgrade(id, self.buildId)
  if self.curArmyTemplate ~= nil then
    self.type_image:LoadSprite(string.format(LoadPath.UISoldier, self.curArmyTemplate.kind))
    self.type_text:SetLocalText(self.curArmyTemplate.name)
    self.des_text:SetLocalText(self.curArmyTemplate.des)
    local resources = self.curArmyTemplate.needResource
    if resources ~= nil then
      local signal = {}
      for k, v in ipairs(resources) do
        table.insert(signal, v.resourceType)
      end
      local param = {}
      param.list = signal
      param.uiName = UIWindowNames.UITrain
      EventManager:GetInstance():Broadcast(EventId.ShowMainUIExtraResource, param)
    end
    if self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work then
      self.has_upgrade:SetActive(false)
      self.no_upgrade:SetActive(true)
      self.state = UITrainState.Training
      if not self.trainSliderGoActive then
        self.no_reason:SetActive(false)
        self.slider_go:SetActive(false)
        self:SetTrainSliderGoActive(true)
        if DataCenter.BuildManager:IsShowDiamond() then
          self.immediately_btn:SetActive(true)
        else
          self.immediately_btn:SetActive(false)
        end
        self.speed_btn_name:SetActive(true)
        self.train_btn_name:SetActive(false)
        self.train_btn_spend_time:SetActive(false)
        self.speed_btn_name:SetLocalText(GameDialogDefine.ADD_SPEED)
        self.immediately_btn_name:SetLocalText(GameDialogDefine.IMMEDIATELY_ADD_SPEED)
        self.train_btn.transform.localPosition = TrainBtnPosition
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
        self.train_num:SetText(string.GetFormattedSeperatorNum(num))
        local template = DataCenter.ArmyTemplateManager:GetArmyTemplate(armyId)
        if template ~= nil then
          self.train_icon:LoadSprite(string.format(LoadPath.SoldierIcons, template.icon))
          self.train_icon_level:SetText(RomeNum[template.level])
        end
        self:UpdateLeftTime()
      end
    elseif DataCenter.ArmyManager:IsUnLock(id) then
      self.has_upgrade:SetActive(showUpgrade)
      self.no_upgrade:SetActive(not showUpgrade)
      if showUpgrade == true then
        local unlock = DataCenter.ArmyManager:GetCanUnLockUpgrade(self.buildId)
        if unlock == true then
          self.btn_image:SetMaterial(nil)
          self.upgrade_shadow:SetAllColor(GreenBtnShadowLightColor)
        else
          self.btn_image:SetMaterial(self.gray)
          self.upgrade_shadow:SetAllColor(YellowBtnShadowGrayColor)
        end
      end
      self.state = UITrainState.Select
      self.maxTrain = self.curArmyTemplate:GetMaxTrainValue()
      self.minTrain = 1
      self.no_reason:SetActive(false)
      self.slider_go:SetActive(true)
      self:SetTrainSliderGoActive(false)
      self:SetSelectSliderValue(1)
      self:SetInputText(self.maxTrain)
      self.perTime = self.curArmyTemplate:GetTrainTime()
      self:RefreshTrainCount()
      if DataCenter.BuildManager:IsShowDiamond() then
        self.immediately_btn:SetActive(true)
      else
        self.immediately_btn:SetActive(false)
      end
      self.speed_btn_name:SetActive(false)
      self.train_btn_name:SetActive(true)
      self.train_btn_spend_time:SetActive(true)
      self.train_btn_name:SetLocalText(GameDialogDefine.TRAIN)
      self.immediately_btn_name:SetLocalText(GameDialogDefine.IMMEDIATELY_TRAIN)
      self.train_btn.transform.localPosition = TrainBtnPosition
      self.small_train_btn_name:SetLocalText(GameDialogDefine.TRAIN)
      self.small_immediately_btn_name:SetLocalText(GameDialogDefine.IMMEDIATELY_TRAIN)
      self.small_upgrade_btn_name:SetLocalText(GameDialogDefine.ARMY_UPGRADE)
    else
      self.has_upgrade:SetActive(false)
      self.no_upgrade:SetActive(true)
      self.state = UITrainState.NoReason
      self.no_reason:SetActive(true)
      self.slider_go:SetActive(false)
      self:SetTrainSliderGoActive(false)
      self.immediately_btn:SetActive(false)
      self.speed_btn_name:SetActive(true)
      self.train_btn_name:SetActive(false)
      self.train_btn_spend_time:SetActive(false)
      self.speed_btn_name:SetLocalText(GameDialogDefine.GOTO)
      self.train_btn.transform.localPosition = GotoBtnPosition
      local tempId, tempLv = DataCenter.ArmyManager:GetLockTrainBuild(id)
      if tempId ~= nil and tempLv ~= nil then
        local buildTemp = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(tempId)
        if buildTemp ~= nil then
          self.gotoType = GotoType.Build
          self.gotoId = tempId
          self.no_reason:SetText(Localization:GetString(GameDialogDefine.ARMY_UNLOCK_TIP_DES, Localization:GetString(buildTemp.name), tempLv))
        end
      else
        tempId, tempLv = DataCenter.ArmyManager:GetLockTrainScience(id)
        if tempId ~= nil and tempLv ~= nil then
          local buildTemp = DataCenter.ScienceTemplateManager:GetScienceTemplate(tempId, tempLv)
          if buildTemp ~= nil then
            self.gotoType = GotoType.Science
            self.gotoId = tempId
            self.no_reason:SetText(Localization:GetString(GameDialogDefine.ARMY_UNLOCK_TIP_DES, Localization:GetString(buildTemp.name), tempLv))
          end
        end
      end
    end
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.no_upgrade.transform)
end

local function DetailsBtnClick(self)
  self.animator:Play("ClickDetailTab", 0, 0)
  local param = {}
  param.template = self.curArmyTemplate
  self.detail_go:ReInit(param)
end

local function BackBtnClick(self)
  self.animator:Play("BackFromDetail", 0, 0)
end

local function OnImmediatelyBtnClick(self)
  if self.state == UITrainState.Training then
    self:ImmediatelySpeedBtnClick()
  elseif self.state == UITrainState.Select then
    self:ImmediatelyBtnClick()
  end
end

local function OnTrainBtnClick(self)
  if self.state == UITrainState.Training then
    self:SpeedBtnClick()
  elseif self.state == UITrainState.Select then
    self:TrainBtnClick()
  elseif self.state == UITrainState.NoReason then
    self:GoToBtnClick()
  end
end

local function OnUpgradeBtnClick(self)
  local unlock = DataCenter.ArmyManager:GetCanUnLockUpgrade(self.buildId)
  if unlock == false then
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.buildId)
    if buildTemplate ~= nil and buildTemplate.para1 ~= nil and buildTemplate.para1 ~= "" then
      local scienceId = tonumber(buildTemplate.para1)
      local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(scienceId, 1)
      if template ~= nil then
        local message = Localization:GetString("140206", Localization:GetString(template.name))
        UIUtil.ShowMessage(message, 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          GoToUtil.GotoScience(scienceId)
          self.ctrl:CloseSelf()
        end, function()
        end)
      else
        UIUtil.ShowTips("E000001")
      end
    end
  else
    local id = self.idList[self.curSelectIndex]
    local param = self.ctrl:GetUpgradData(self.buildId, id)
    if param == nil then
      return
    end
    self.select_go:SetActive(false)
    self.title_text:SetLocalText(GameDialogDefine.ARMY_UPGRADE_TITLE)
    self.upgrade_go:ReInit(param)
    self.animator:Play("ToUpgrade", 0, 0)
    self.isUpgrading = true
  end
end

local function ImmediatelyBtnClick(self)
  local currentTotalNum = DataCenter.ArmyManager:GetTotalArmyNum()
  local max = DataCenter.ArmyManager:GetArmyNumMax()
  local left = max - currentTotalNum
  if left < self.inputCount then
    self:DoWhenMoreThenLimit()
    return
  end
  if self.lackItem ~= nil and table.count(self.lackItem) > 0 then
    UIUtil.ShowTipsId(GameDialogDefine.NO_ITEM)
  elseif self.immediatelyBtnSpendColor == RedColor then
    GoToUtil.GotoPayTips(self.spendGold)
  else
    UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.UpgradeUseDiamond, Localization:GetString(GameDialogDefine.USE_GOLF_TIP_DES), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.ArmyAdd, {
        id = self.idList[self.curSelectIndex],
        gold = true,
        num = self.inputCount
      })
    end, function()
    end)
  end
end

local function DoWhenMoreThenLimit(self)
  UIUtil.ShowMessage(Localization:GetString("140305"), 1, "110003", GameDialogDefine.CANCEL, function()
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_BARRACKS)
    if buildData ~= nil and buildData.state == BuildingStateType.Normal and buildData.level > 0 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, buildData.uuid)
    else
      GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_BARRACKS)
    end
    self.ctrl.CloseSelf()
  end, function()
  end)
end

local function TrainBtnClick(self)
  local currentTotalNum = DataCenter.ArmyManager:GetTotalArmyNum()
  local max = DataCenter.ArmyManager:GetArmyNumMax()
  local left = max - currentTotalNum
  if left < self.inputCount then
    self:DoWhenMoreThenLimit()
    return
  end
  if self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work then
    UIUtil.ShowTipsId(GameDialogDefine.QUEUE_FULL)
  elseif self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Free then
    if self.lackResource ~= nil and table.count(self.lackResource) > 0 then
      local lackTab = {}
      for i, v in pairs(self.lackResource) do
        local param = {}
        param.type = ResLackType.Res
        param.resType = i
        param.targetNum = v
        table.insert(lackTab, param)
      end
      GoToResLack.GoToItemResLackList(lackTab)
    elseif self.lackItem ~= nil and 0 < table.count(self.lackItem) then
      UIUtil.ShowTipsId(GameDialogDefine.NO_ITEM)
    else
      SFSNetwork.SendMessage(MsgDefines.ArmyAdd, {
        id = self.idList[self.curSelectIndex],
        gold = false,
        num = self.inputCount
      })
    end
  end
end

local function ImmediatelySpeedBtnClick(self)
  if self.immediatelyBtnSpendColor == RedColor then
    GoToUtil.GotoPayTips(self.spendGold)
  elseif self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work then
    UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.UpgradeUseDiamond, Localization:GetString(GameDialogDefine.USE_GOLF_TIP_DES), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      DataCenter.ArmyManager:SendSpeedFinishQueue(self.queue.uuid)
    end, function()
    end)
  end
end

local function SpeedBtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, {anim = true}, ItemSpdMenu.ItemSpdMenu_Soldier, self.queue.uuid)
end

local function SetImmediatelyBtnSpendText(self, value)
  if self.immediatelyBtnSpendText ~= value then
    self.immediatelyBtnSpendText = value
    self.immediately_btn_spend_count:SetText(value)
    self.small_immediately_btn_spend_count:SetText(value)
  end
end

local function SetImmediatelyBtnSpendColor(self, value)
  if self.immediatelyBtnSpendColor ~= value then
    self.immediatelyBtnSpendColor = value
    self.immediately_btn_spend_count:SetColor(value)
    self.small_immediately_btn_spend_count:SetColor(value)
    if value == RedColor then
      self.immediately_btn_spend_count_shadow:AllEnable(false)
      self.small_immediately_btn_spend_count_shadow:AllEnable(false)
    else
      self.immediately_btn_spend_count_shadow:AllEnable(true)
      self.small_immediately_btn_spend_count_shadow:AllEnable(true)
    end
  end
end

local function UpdateResourceSignal(self)
  if self.state == UITrainState.Select then
    self:ShowNeedResource()
  end
end

local function UpdateGoldSignal(self)
  if self.state == UITrainState.Select or self.state == UITrainState.Training then
    self:RefreshGoldColor()
  end
end

local function UpdateItemSignal(self)
  if self.state == UITrainState.Select and self.hasItem then
    self:ShowNeedResource()
  end
end

local function SetSelectSliderValue(self, value)
  if self.selectSliderValue ~= value then
    self.selectSliderValue = value
    self.select_slider:SetValue(value)
  end
end

local function SetTrainSliderGoActive(self, value)
  if self.trainSliderGoActive ~= value then
    self.trainSliderGoActive = value
    self.train_slider:SetActive(value)
  end
end

local function Update(self)
  if self.queue ~= nil then
    if self.isUpgrading then
      self.upgrade_go:UpdateLeftTime()
      return
    end
    if self.queue:GetQueueState() == NewQueueState.Work then
      self:UpdateLeftTime()
    elseif self.queue:GetQueueState() == NewQueueState.Finish then
      self.ctrl:CloseSelf()
    end
  end
end

local function UpdateLeftTime(self)
  if self.isUpgrading then
    return
  end
  if self.state == UITrainState.Training then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local changeTime = self.queue.endTime - curTime
    local maxTime = self.queue.endTime - self.queue.startTime
    if 0 < changeTime then
      local tempTimeSec = math.ceil(changeTime / 1000)
      if tempTimeSec ~= self.laseTime then
        self.laseTime = tempTimeSec
        local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(changeTime)
        self.train_slider_left_time:SetText(tempTimeValue)
        self.spendGold = CommonUtil.GetTimeDiamondCost(math.ceil(tempTimeSec))
        self:RefreshImmediatelyGold()
      end
      if 0 < maxTime then
        local tempValue = 1 - changeTime / maxTime
        if TimeBarUtil.CheckIsNeedChangeBar(changeTime, self.queue.endTime - self.lastCurTime, maxTime, SliderLength) then
          self.lastCurTime = curTime
          self.train_slider:SetValue(tempValue)
        end
      end
    else
      self.laseTime = 0
      self.train_slider:SetValue(0)
      self.train_slider_left_time:SetText("")
      self.ctrl:CloseSelf()
    end
  end
end

local function UpdateArmySignal(self)
  self:ShowCells()
  self:RefreshSelect()
end

local function GetCurSelectId(self)
  local unlockArmy = DataCenter.ArmyManager:GetArmyUnlock(self.buildId)
  if self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work and string.IsNullOrEmpty(unlockArmy) then
    local curSelect = ""
    local tempList = string.split(self.queue.itemId, ";")
    if tempList ~= nil and 3 < #tempList then
      curSelect = tempList[3]
    elseif tempList ~= nil and 1 < #tempList then
      curSelect = tempList[1]
    end
    for k, v in ipairs(self.idList) do
      if v == curSelect then
        self.curSelectIndex = k
        return
      end
    end
  elseif self.maxUnlockId == nil then
    self.curSelectIndex = 1
  else
    self.curSelectIndex = self.maxUnlockId
  end
end

local function SetInputText(self, value)
  if self.inputCount ~= value then
    self.inputCount = value
    self.select_input_field:SetText(string.GetFormattedSeperatorNum(value))
  end
end

local function SetTrainSpendTimeText(self, value)
  if self.trainSpendTimeText ~= value then
    self.trainSpendTimeText = value
    self.train_btn_spend_time:SetText(value)
    self.small_train_btn_spend_time:SetText(value)
  end
end

local function RefreshTrainTime(self)
  if self.perTime ~= nil and self.inputCount ~= nil then
    local x, y = math.modf(self.perTime * self.inputCount)
    self:SetTrainSpendTimeText(UITimeManager:GetInstance():SecondToFmtString(x))
  end
end

local function InputListener(self, value)
  local temp = value
  if temp ~= nil and temp ~= "" then
    local inputCount = tonumber(temp)
    if inputCount < self.minTrain then
      self.inputCount = nil
      self:SetInputText(self.minTrain)
    elseif inputCount > self.maxTrain then
      self.inputCount = nil
      self:SetInputText(self.maxTrain)
    else
      self:SetInputText(inputCount)
    end
    self.noChangeSlider = true
    self:SetSelectSliderValue(self.inputCount / self.maxTrain)
    self:RefreshTrainCount()
  else
    local sub = self.inputCount
    self.inputCount = nil
    self:SetInputText(sub)
  end
end

local function RefreshTrainCount(self)
  self:ShowNeedResource()
  self:RefreshTrainTime()
  self:RefreshImmediatelyGold()
end

local function OnValueChange(self, val)
  if self.noChangeSlider then
    self.noChangeSlider = false
  else
    self.selectSliderValue = val
    local inputCount = math.floor(val * self.maxTrain + 0.5)
    if inputCount < self.minTrain then
      self.inputCount = nil
      self:SetInputText(self.minTrain)
    else
      self:SetInputText(inputCount)
    end
    self:RefreshTrainCount()
  end
end

local function GoToBtnClick(self)
  if self.gotoType == GotoType.Build then
    GoToUtil.GotoCityByBuildId(self.gotoId, WorldTileBtnType.City_Upgrade)
  elseif self.gotoType == GotoType.Science then
    GoToUtil.GotoScience(self.gotoId)
    self.ctrl:CloseSelf()
  end
end

local function SetCellSelect(self, index, isSelect)
  if index ~= nil and self.cells[index] ~= nil then
    self.cells[index]:SetSelect(isSelect)
  end
end

local function UpdateBuildSignal(self)
  self:ShowCells()
  self:RefreshSelect()
end

local function OnCloseClick(self)
  if self.isUpgrading and not self.upgrade_go:IsUpgrading() then
    self:CloseUpgradeView()
    self:RefreshSelect()
  else
    self.ctrl:CloseSelf()
  end
end

local function CloseUpgradeView(self)
  self.select_go:SetActive(true)
  self.title_text:SetLocalText(GameDialogDefine.TRAIN_ARMY)
  self.animator:Play("UpgradeToTrain", 0, 0)
  self.isUpgrading = false
end

local function TrainingArmySignal(self)
  self:UpdateArmySignal()
end

UITrainView.OnCreate = OnCreate
UITrainView.OnDestroy = OnDestroy
UITrainView.OnEnable = OnEnable
UITrainView.OnDisable = OnDisable
UITrainView.ComponentDefine = ComponentDefine
UITrainView.ComponentDestroy = ComponentDestroy
UITrainView.DataDefine = DataDefine
UITrainView.DataDestroy = DataDestroy
UITrainView.OnAddListener = OnAddListener
UITrainView.OnRemoveListener = OnRemoveListener
UITrainView.ReInit = ReInit
UITrainView.OnDeleteCell = OnDeleteCell
UITrainView.ShowCells = ShowCells
UITrainView.OnCreateCell = OnCreateCell
UITrainView.ClearScroll = ClearScroll
UITrainView.DetailsBtnClick = DetailsBtnClick
UITrainView.ImmediatelyBtnClick = ImmediatelyBtnClick
UITrainView.BackBtnClick = BackBtnClick
UITrainView.RefreshImmediatelyGold = RefreshImmediatelyGold
UITrainView.ShowNeedResource = ShowNeedResource
UITrainView.AddOneNeedResourceCells = AddOneNeedResourceCells
UITrainView.SetImmediatelyBtnSpendText = SetImmediatelyBtnSpendText
UITrainView.SetImmediatelyBtnSpendColor = SetImmediatelyBtnSpendColor
UITrainView.UpdateResourceSignal = UpdateResourceSignal
UITrainView.UpdateGoldSignal = UpdateGoldSignal
UITrainView.RefreshGoldColor = RefreshGoldColor
UITrainView.UpdateItemSignal = UpdateItemSignal
UITrainView.SetSelectSliderValue = SetSelectSliderValue
UITrainView.Update = Update
UITrainView.UpdateLeftTime = UpdateLeftTime
UITrainView.UpdateArmySignal = UpdateArmySignal
UITrainView.TrainBtnClick = TrainBtnClick
UITrainView.ImmediatelySpeedBtnClick = ImmediatelySpeedBtnClick
UITrainView.SpeedBtnClick = SpeedBtnClick
UITrainView.GetCurSelectId = GetCurSelectId
UITrainView.CellsCallBack = CellsCallBack
UITrainView.RefreshSelect = RefreshSelect
UITrainView.SetTrainSliderGoActive = SetTrainSliderGoActive
UITrainView.SetInputText = SetInputText
UITrainView.SetTrainSpendTimeText = SetTrainSpendTimeText
UITrainView.RefreshTrainTime = RefreshTrainTime
UITrainView.InputListener = InputListener
UITrainView.RefreshTrainCount = RefreshTrainCount
UITrainView.OnValueChange = OnValueChange
UITrainView.GoToBtnClick = GoToBtnClick
UITrainView.SetSelect = SetSelect
UITrainView.SetCellSelect = SetCellSelect
UITrainView.OnImmediatelyBtnClick = OnImmediatelyBtnClick
UITrainView.OnTrainBtnClick = OnTrainBtnClick
UITrainView.UpdateBuildSignal = UpdateBuildSignal
UITrainView.OnUpgradeBtnClick = OnUpgradeBtnClick
UITrainView.OnCloseClick = OnCloseClick
UITrainView.ShowUpgradeWhenReInit = ShowUpgradeWhenReInit
UITrainView.CloseUpgradeView = CloseUpgradeView
UITrainView.DoWhenMoreThenLimit = DoWhenMoreThenLimit
UITrainView.TrainingArmySignal = TrainingArmySignal
return UITrainView
