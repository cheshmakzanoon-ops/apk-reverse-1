local FactoryDesItem = require("UI.UIFactory.Component.FactoryDesItem")
local FactoryItem = require("UI.UIFactory.Component.FactoryItem")
local FactoryGatherResItem = require("UI.UIFactory.Component.FactoryGatherResItem")
local FactoryBoxTrigger = require("UI.UIFactory.Component.FactoryBoxTrigger")
local UIFactoryModel = require("UI.UIFactory.Component.UIFactoryModel")
local FactoryStateItem = require("UI.UIFactory.Component.FactoryStateItem")
local UIProductLevelState = require("UI.UIFactory.Component.UIProductLevelState")
local UIFactoryView = BaseClass("UIFactoryView", UIBaseView)
local base = UIBaseView
local return_btn_path = "panel"
local search_obj_path = "Search"
local tab_img_path = "Tab/tab_img"
local tab_content_path = "Tab/content"
local drag_item_img_path = "dragImg"
local bg_path = "RawImage"
local rawImg1_path = "RawImage1"
local working_obj_path = "workingObj"
local title_text_path = "titleText"
local level_text_path = "workingObj/levelObj/lvTxt"
local Localization = CS.GameEntry.Localization
local state_big_path = "workingObj/FactoryStateBig"
local state_small_1_path = "workingObj/FactoryStateSmall_1"
local state_small_2_path = "workingObj/FactoryStateSmall_2"
local gather_list_path = "workingObj/gatherList"
local box_trigger_path = "workingObj/boxList"
local box0_pos_obj_path = "workingObj/box0"
local box1_pos_obj_path = "workingObj/boxList/box1"
local box2_pos_obj_path = "workingObj/boxList/box2"
local box3_pos_obj_path = "workingObj/boxList/box3"
local box4_pos_obj_path = "workingObj/boxList/box4"
local box5_pos_obj_path = "workingObj/boxList/box5"
local cancel1_path = "workingObj/cancelList/cancel1"
local cancel2_path = "workingObj/cancelList/cancel2"
local cancel3_path = "workingObj/cancelList/cancel3"
local cancel4_path = "workingObj/cancelList/cancel4"
local cancel5_path = "workingObj/cancelList/cancel5"
local box_item_anim = "BoxItem"
local add_box_item_btn_path = "BoxItem/AddBoxItem"
local add_box_res_icon_path = "BoxItem/AddBoxItem/needResIcon"
local add_box_res_num_path = "BoxItem/AddBoxItem/needNum"
local add_box_res_anim_path = "BoxItem/AddBoxItem/UIFactory_img_box_gray"
local guide_box_path = "workingObj/GuideBox"
local productLevelState_path = "Tab/tab_img/UIProductLevelState"
local light_path = "Light"
local upgrade_btn_path = "upgrade_btn"
local ResourceManager = CS.GameEntry.Resource
local WorkObjPosSmall = Vector3.New(-319, -15.75, 0)
local AddBoxBtnPosSmall = Vector3.New(302, -9, 0)
local WorkObjPosLarge = Vector3.New(-403, -15.75, 0)
local AddBoxBtnPosLarge = Vector3.New(372, -9, 0)
local ModelType = {
  None,
  Large,
  Small
}
local EventType = {
  GetFactoryData = 1,
  GatherFactoryItem = 2,
  AddFactoryBox = 3,
  AddFactoryProduct = 4,
  UpdateResource = 5,
  SpeedUp = 6,
  CancelItem = 7
}
local left_btn_path = "left"
local right_btn_path = "right"
local close_btn_path = "close_btn"

local function OnCreate(self)
  base.OnCreate(self)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    if not DataCenter.GuideManager:IsDragGuide() then
      self:OnCloseArrow()
      self.ctrl:CloseSelf()
    end
  end)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    if not DataCenter.GuideManager:IsDragGuide() then
      self:OnCloseArrow()
      self.ctrl:CloseSelf()
    end
  end)
  self.upgrade_btn = self:AddComponent(UIButton, upgrade_btn_path)
  self.upgrade_btn:SetOnClick(function()
    if CS.SceneManager.IsInPVE() then
      self:OnUpgradeClick()
    end
  end)
  self.upgrade_btn:SetActive(false)
  self.working_obj = self:AddComponent(UIBaseContainer, working_obj_path)
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.level_text = self:AddComponent(UIText, level_text_path)
  self.gather_list = self:AddComponent(UIBaseContainer, gather_list_path)
  self.gather_list_anim = self:AddComponent(UIAnimator, gather_list_path)
  self.box_trigger = self:AddComponent(FactoryBoxTrigger, box_trigger_path)
  self.add_box_item_btn = self:AddComponent(UIButton, add_box_item_btn_path)
  self.add_box_item_anim = self:AddComponent(UIAnimator, box_item_anim)
  self.add_box_res_icon = self:AddComponent(UIImage, add_box_res_icon_path)
  self.add_box_res_anim = self:AddComponent(UIAnimator, add_box_res_anim_path)
  self.add_box_res_img = self:AddComponent(UIImage, add_box_res_anim_path)
  self.box1_pos = self:AddComponent(UIBaseContainer, box1_pos_obj_path)
  self.box2_pos = self:AddComponent(UIBaseContainer, box2_pos_obj_path)
  self.box3_pos = self:AddComponent(UIBaseContainer, box3_pos_obj_path)
  self.box4_pos = self:AddComponent(UIBaseContainer, box4_pos_obj_path)
  self.box5_pos = self:AddComponent(UIBaseContainer, box5_pos_obj_path)
  self.box0_pos = self:AddComponent(UIBaseContainer, box0_pos_obj_path)
  self.guide_box = self:AddComponent(UIBaseContainer, guide_box_path)
  self.box_pos_list = {}
  table.insert(self.box_pos_list, self.box1_pos)
  table.insert(self.box_pos_list, self.box2_pos)
  table.insert(self.box_pos_list, self.box3_pos)
  table.insert(self.box_pos_list, self.box4_pos)
  table.insert(self.box_pos_list, self.box5_pos)
  self.add_box_res_num = self:AddComponent(UIText, add_box_res_num_path)
  self.light_image = self:AddComponent(UIImage, light_path)
  self.light = self.light_image:GetMaterial()
  self.add_box_item_btn:SetOnClick(function()
    if not DataCenter.GuideManager:IsDragGuide() then
      DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
      self:OnAddBoxClick()
    end
  end)
  self.cancel1 = self:AddComponent(UIButton, cancel1_path)
  self.cancel2 = self:AddComponent(UIButton, cancel2_path)
  self.cancel3 = self:AddComponent(UIButton, cancel3_path)
  self.cancel4 = self:AddComponent(UIButton, cancel4_path)
  self.cancel5 = self:AddComponent(UIButton, cancel5_path)
  self.cancel1:SetOnClick(function()
  end)
  self.cancel2:SetOnClick(function()
    self:OnCancelClick(1)
  end)
  self.cancel3:SetOnClick(function()
    self:OnCancelClick(2)
  end)
  self.cancel4:SetOnClick(function()
    self:OnCancelClick(3)
  end)
  self.cancel5:SetOnClick(function()
    self:OnCancelClick(4)
  end)
  self.search_obj = self:AddComponent(FactoryDesItem, search_obj_path)
  self.tab_content = self:AddComponent(UIBaseContainer, tab_content_path)
  self.tab_img = self:AddComponent(UIImage, tab_img_path)
  self.content_anim = self:AddComponent(UIAnimator, tab_content_path)
  self.drag_item_img = self:AddComponent(UIImage, drag_item_img_path)
  self.animator = self:AddComponent(UIAnimator, drag_item_img_path)
  self.gatherTrigger = self:AddComponent(UIEventTrigger, gather_list_path)
  self.gatherTrigger:OnPointerDown(function(eventData)
    self:OnPointerEnter(eventData)
  end)
  self.gatherTrigger:OnPointerUp(function(eventData)
    self:OnPointerExit(eventData)
  end)
  self.bg:SetActive(false)
  self.showDrag = false
  self.showDes = false
  self.animatorIndex = 1
  self.modelCount = 0
  self.cellList = {}
  self.gatherCells = {}
  self.gatherDic = {}
  self.gatherModelCount = 0
  self.showAnimator = false
  self.animatorTime = 0
  self.startTime = 0
  self.bgModel = nil
  self.isCreatingModel = false
  self.startGather = false
  self.gatherAnimatorIndex = 1
  self.gatherAnimatorTime = 0
  self.showGatherAnimator = false
  self.gatherStartTime = 0
  self.rawImg1 = self:AddComponent(UIBaseContainer, rawImg1_path)
  self.rawImg1:SetActive(false)
  self.firstConfirm = false
  self.sendMessage = false
  self.costNum = 0
  self.left_btn = self:AddComponent(UIButton, left_btn_path)
  self.right_btn = self:AddComponent(UIButton, right_btn_path)
  self.right_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnCloseArrow()
    self:OnRightClick()
  end)
  self.left_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnCloseArrow()
    self:OnLeftClick()
  end)
  self.productId = 0
  self.isBox = false
  self.stateBig = self:AddComponent(FactoryStateItem, state_big_path)
  self.stateSmall_1 = self:AddComponent(FactoryStateItem, state_small_1_path)
  self.stateSmall_2 = self:AddComponent(FactoryStateItem, state_small_2_path)
  self.stateBig:SetActive(false)
  self.stateSmall_1:SetActive(false)
  self.stateSmall_2:SetActive(false)
  self.onCreateInstance = nil
  self.guideFreeSpeed = false
  self.currentItemIndex = -1
  self.productLevelState = self:AddComponent(UIProductLevelState, productLevelState_path)
end

local function OnDestroy(self)
  self:HideDes()
  self.guideFreeSpeed = false
  self:RemoveUnlockItemTimer()
  if DataCenter.GuideManager:InGuide() then
    local template = DataCenter.GuideManager:GetCurTemplate()
    if template ~= nil and template.type == GuideType.Factory and template.forcetype == GuideForceType.Soft then
      DataCenter.GuideManager:SetCurGuideId(GuideEndId)
      DataCenter.GuideManager:DoGuide()
    end
  end
  if self.bgModel ~= nil then
    self.bgModel:DestroySelf()
  end
  if self.onCreateInstance ~= nil then
    self.onCreateInstance:Destroy()
    self.onCreateInstance = nil
  end
  if self.cancelDelayTimer ~= nil then
    self.cancelDelayTimer:Stop()
    self.cancelDelayTimer = nil
  end
  self.search_obj = nil
  self.working_obj = nil
  self.bg = nil
  self.title_text = nil
  self.level_text = nil
  self.gather_list = nil
  self.gather_list_anim = nil
  self.box_trigger = nil
  self.add_box_item_btn = nil
  self.add_box_item_anim = nil
  self.add_box_res_anim = nil
  self.add_box_res_img = nil
  self.add_box_res_icon = nil
  self.add_box_res_num = nil
  self.tab_img = nil
  self.tab_content = nil
  self.content_anim = nil
  self.drag_item_img = nil
  self.animator = nil
  self.animatorIndex = nil
  self.modelCount = nil
  self.cellList = nil
  self.gatherCells = nil
  self.gatherDic = nil
  self.gatherModelCount = nil
  self.showAnimator = nil
  self.animatorTime = nil
  self.startTime = nil
  self.bgModel = nil
  self.left_btn = nil
  self.right_btn = nil
  self.guide_box = nil
  self.productId = nil
  self.isBox = nil
  self.light_image = nil
  self.light = nil
  self.close_btn = nil
  EventManager:GetInstance():Broadcast(EventId.HideMainUIExtraResource, UIWindowNames.UIFactory)
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:UpdateView(self:GetUserData())
  if not CS.SceneManager.IsInPVE() then
    local UIMain = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
    UIMain.View.anim:Play("ShowPlayer", 0, 0)
  end
end

local function AddUnlockItemTimer(self)
  self:RemoveUnlockItemTimer()
  local result = DataCenter.BuildManager:CheckAndShowFactoryUnlockItem(self.buildId, true)
  if result then
    self.showUnlockItemTimer = TimerManager:GetInstance():DelayInvoke(function()
      DataCenter.BuildManager:CheckAndShowFactoryUnlockItem(self.buildId)
      self:RemoveUnlockItemTimer()
    end, 0.5)
  end
end

local function RemoveUnlockItemTimer(self)
  if self.showUnlockItemTimer ~= nil then
    self.showUnlockItemTimer:Stop()
    self.showUnlockItemTimer = nil
  end
end

local function UpdateView(self, data, productId, isBox)
  local resetProductLevel = false
  if self.factoryUid ~= tonumber(data) then
    resetProductLevel = true
  end
  self.factoryUid = tonumber(data)
  Logger.Log("factory init ", self.factoryUid)
  self.productId = productId or nil
  self.isBox = isBox
  if self.productId == nil then
    local param = WorldArrowManager:GetInstance():GetArrowParam()
    if param then
      if param.uuid == self.factoryUid then
        self.productId = param.productId
        self.isBox = param.isBox
      end
      WorldArrowManager:GetInstance():SetArrowParam(nil)
    end
  end
  SFSNetwork.SendMessage(MsgDefines.SynFoodFactory, self.factoryUid)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.factoryUid)
  self.needRefreshWhenDataBack = true
  if buildData ~= nil then
    Logger.Log("factory buildData ", self.factoryUid)
    self.buildId = buildData.itemId
    self:AddUnlockItemTimer()
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildData.itemId)
    if buildTemplate ~= nil then
      self.title_text:SetLocalText(buildTemplate.name)
    end
    self.level_text:SetLocalText(GameDialogDefine.LEVEL_NUMBER, buildData.level)
  elseif DataCenter.BattleLevel ~= nil then
    local data = DataCenter.BattleLevel:GetPveTriggerBuildingInfoByUUid(self.factoryUid)
    if data ~= nil then
      self.buildId = data.id
      local triggerData = DataCenter.BattleLevel:GetTriggerByTriggerId(self.buildId)
      if triggerData ~= nil and not string.IsNullOrEmpty(triggerData.config.name) then
        self.title_text:SetLocalText(triggerData.config.name)
      end
    end
  end
  self.ctrl:InitData(self.factoryUid, self.buildId)
  self:SetData()
  self:GetFoodBuildStr()
  if resetProductLevel then
    self.currentItemIndex = -1
    self:RefreshProductLevel()
  end
  if self.buildId ~= nil then
    DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.OpenSpecialPanel, tostring(self.buildId))
  end
  if not CS.SceneManager.IsInPVE() then
    local resourceItemSignal = {}
    table.insert(resourceItemSignal, ResourceItem.Wood)
    table.insert(resourceItemSignal, ResourceItem.Stone)
    local param = {}
    param.uiName = UIWindowNames.UIFactory
    param.resourceItemList = resourceItemSignal
    EventManager:GetInstance():Broadcast(EventId.HideMainUIExtraResource, UIWindowNames.UIFactory)
    EventManager:GetInstance():Broadcast(EventId.ShowMainUIExtraResource, param)
  else
    self:RefreshPveUpgradeBtn()
  end
  if buildData ~= nil then
    self:OnFactoryDataCallBack()
  end
end

local function OnFactoryDataCallBack(self, eventType)
  self.needRefreshWhenDataBack = false
  local data = self.ctrl:GetProductData()
  self.sendMessage = false
  self.firstConfirm = false
  self.rawImg1:SetActive(data.isLargeModel)
  if self.bgModel == nil then
    if self.isCreatingModel == false then
      self.isCreatingModel = true
      local prefabName = ""
      if data.isLargeModel then
        prefabName = UIAssets.UIFactoryModelLarge
        self.curModelType = ModelType.Large
        self.working_obj.gameObject.transform.localPosition = WorkObjPosLarge
        self.add_box_item_anim.gameObject.transform.localPosition = AddBoxBtnPosLarge
      else
        prefabName = UIAssets.UIFactoryModelSmall
        self.curModelType = ModelType.Small
        self.working_obj.gameObject.transform.localPosition = WorkObjPosSmall
        self.add_box_item_anim.gameObject.transform.localPosition = AddBoxBtnPosSmall
      end
      if self.onCreateInstance ~= nil then
        self.onCreateInstance:Destroy()
      end
      local request = ResourceManager:InstantiateAsync(prefabName)
      self.onCreateInstance = request
      request:completed("+", function()
        self.onCreateInstance = nil
        if request.isError then
          return
        end
        if self.bg:GetActive() == false then
          self.bg:SetActive(true)
        end
        request.gameObject:SetActive(true)
        request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        self.bgModel = UIFactoryModel.New()
        self.bgModel:OnCreate(request, self.ctrl)
        self.bgModel:InitData()
        self:SetBoxCamera()
        self.isCreatingModel = false
      end)
    end
  elseif self.bgModel ~= nil and self.param ~= nil and self.param.isLargeModel == false and data.isLargeModel then
    self.bgModel:DestroySelf()
    self.bgModel = nil
    self.isCreatingModel = true
    local prefabName = ""
    Logger.Log("change model")
    if data.isLargeModel then
      prefabName = UIAssets.UIFactoryModelLarge
      self.curModelType = ModelType.Large
      self.working_obj.gameObject.transform.localPosition = WorkObjPosLarge
      self.add_box_item_anim.gameObject.transform.localPosition = AddBoxBtnPosLarge
    else
      prefabName = UIAssets.UIFactoryModelSmall
      self.curModelType = ModelType.Small
      self.working_obj.gameObject.transform.localPosition = WorkObjPosSmall
      self.add_box_item_anim.gameObject.transform.localPosition = AddBoxBtnPosSmall
    end
    if self.onCreateInstance ~= nil then
      self.onCreateInstance:Destroy()
    end
    local request = ResourceManager:InstantiateAsync(prefabName)
    self.onCreateInstance = request
    request:completed("+", function()
      self.onCreateInstance = nil
      if request.isError then
        return
      end
      if self.bg:GetActive() == false then
        self.bg:SetActive(true)
      end
      request.gameObject:SetActive(true)
      request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      self.bgModel = UIFactoryModel.New()
      self.bgModel:OnCreate(request, self.ctrl)
      self.bgModel:InitData()
      self:SetBoxCamera()
      self.isCreatingModel = false
    end)
  elseif self.bgModel ~= nil and self.param ~= nil then
    if self.param.state == FactoryWorkState.Free then
      if data.state == FactoryWorkState.Free then
        if #data.boxDataList > #self.param.boxDataList then
          self.bgModel:AddBox(false)
          self:SetBoxCamera()
        end
      elseif #data.boxDataList > 0 then
        local pos = self.box_pos_list[1].gameObject.transform.position
        DataCenter.DropResourceEffectManager:DropMultiResourceItemEffect(pos, data.boxDataList[1].needGoodIconList)
        self.bgModel:AddResToBox(1, data.boxDataList[1], true)
      end
    elseif self.param.state == FactoryWorkState.Full then
      if data.state == FactoryWorkState.Full then
        if #data.boxDataList > #self.param.boxDataList then
          self.bgModel:AddBox(false)
          self:SetBoxCamera()
        else
          local checkChange = false
          table.walk(self.param.boxDataList, function(k, v)
            if checkChange == false and v.itemId == nil and data.boxDataList[k].itemId ~= nil then
              if k == 1 then
                local pos = self.box0_pos.gameObject.transform.position
                DataCenter.DropResourceEffectManager:DropMultiResourceItemEffect(pos, data.boxDataList[k].needGoodIconList)
                self.bgModel:AddResToBox(k, data.boxDataList[k], false)
                checkChange = true
              else
                local pos = self.box_pos_list[k - 1].gameObject.transform.position
                DataCenter.DropResourceEffectManager:DropMultiResourceItemEffect(pos, data.boxDataList[k].needGoodIconList)
                self.bgModel:AddResToBox(k, data.boxDataList[k], false)
                checkChange = true
              end
            end
          end)
        end
      elseif data.state == FactoryWorkState.Work then
        self.bgModel:StartWork()
      end
    elseif self.param.state == FactoryWorkState.Work then
      local function findChangeIndex(workingList1, workingList2)
        if workingList2 == nil or workingList1 == nil then
          return nil
        end
        local index = 1
        local total = table.count(workingList1)
        while index <= total do
          local preData = workingList1[index]
          local curData = workingList2[index]
          if curData == nil then
            return index
          end
          if preData.product ~= curData.product then
            return index
          end
          if curData.endTime > preData.endTime and curData.stopTime == 0 then
            return index
          end
          index = index + 1
        end
        return nil
      end
      
      if data.state == FactoryWorkState.Work then
        if #data.gatherList > #self.param.gatherList or eventType == EventType.SpeedUp then
          local index = findChangeIndex(self.param.workingList, data.workingList)
          if index ~= nil then
            self.bgModel:GetProduct(index)
          end
        elseif #data.boxDataList > #self.param.boxDataList then
          self.bgModel:AddBox(false)
          self:SetBoxCamera()
        else
          local checkChange = false
          table.walk(self.param.boxDataList, function(k, v)
            if checkChange == false and v.itemId == nil and data.boxDataList[k].itemId ~= nil then
              if k == 1 then
                local pos = self.box0_pos.gameObject.transform.position
                DataCenter.DropResourceEffectManager:DropMultiResourceItemEffect(pos, data.boxDataList[k].needGoodIconList)
                self.bgModel:AddResToBox(k, data.boxDataList[k], false)
                checkChange = true
              else
                local pos = self.box_pos_list[k - 1].gameObject.transform.position
                DataCenter.DropResourceEffectManager:DropMultiResourceItemEffect(pos, data.boxDataList[k].needGoodIconList)
                self.bgModel:AddResToBox(k, data.boxDataList[k], false)
                checkChange = true
              end
            end
          end)
        end
      elseif #data.gatherList > #self.param.gatherList or eventType == EventType.SpeedUp then
        local index = findChangeIndex(self.param.workingList, data.workingList)
        if index ~= nil then
          self.bgModel:GetProduct(index)
        end
      end
    end
  end
  if data.showAddBox then
    self.add_box_item_anim:SetActive(true)
    self.add_box_res_num:SetText(data.needGoldNum)
    self.add_box_res_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(data.type))
    if not DataCenter.GuideManager:InGuide() then
      local k1 = LuaEntry.DataConfig:TryGetNum("buy_show", "k1")
      if k1 >= DataCenter.BuildManager.MainLv then
        local num = LuaEntry.Resource:GetCntByResType(data.type)
        if num >= data.needGoldNum then
          self.add_box_item_anim:Play(RecommendShowAnimName[RecommendShowAnimType.Show], 0, 0)
          self.add_box_res_img:SetMaterial(self.light)
          if self.add_box_res_hdr == nil then
            self.add_box_res_hdr = self:AddComponent(GetHDRIntensity, add_box_res_anim_path)
          end
          self.add_box_res_hdr:Init(self.light)
          self.add_box_res_anim:Play(RecommendShowImgAnimName[RecommendShowAnimType.Show], 0, 0)
        end
      end
    end
  else
    self.add_box_item_anim:SetActive(false)
  end
  self:SetGatherData(data.gatherList)
  self:RefreshFactoryItem()
  if self.isBox then
    local param = {}
    param.position = self.add_box_item_btn.transform.position
    param.arrowType = ArrowType.Factory
    param.positionType = PositionType.Screen
    DataCenter.ArrowManager:ShowArrow(param)
    self.isBox = false
  end
  self.param = data
  self:CheckGuideClickTime()
  self:UpdateAddSpeedBtns()
  self:ResetCancelBtnState()
end

local function OnAddBoxClick(self)
  self:OnCloseArrow()
  self.add_box_item_anim:Play(RecommendShowAnimName[RecommendShowAnimType.Default], 0, 0)
  self.add_box_res_img:SetMaterial(nil)
  self.add_box_res_anim:Play(RecommendShowImgAnimName[RecommendShowAnimType.Default], 0, 0)
  local needGoldNum = self.param.needGoldNum
  local type = self.param.type
  self.ctrl:SendAddBoxMessage(type, needGoldNum)
end

local function OnGetFactoryDataBack(self)
  self:OnFactoryDataCallBack()
end

local function OnGatherItemCallBack(self)
  self:OnFactoryDataCallBack(EventType.GatherFactoryItem)
end

local function OnAddBoxCallBack(self)
  self:OnFactoryDataCallBack(EventType.AddFactoryBox)
end

local function OnAddProductCallBack(self)
  self:OnFactoryDataCallBack(EventType.AddFactoryProduct)
end

local function OnResourceDataBack(self)
  self:OnFactoryDataCallBack(EventType.UpdateResource)
end

local function OnFactoryDataAddSpeed(self)
  self:OnFactoryDataCallBack(EventType.SpeedUp)
end

local function OnCancelBack(self)
  if self.bgModel ~= nil then
    self.bgModel:DestroySelf()
    self.bgModel = nil
  end
  self:UpdateView(self.factoryUid)
end

local function OnCloseArrow(self)
  if not DataCenter.GuideManager:InGuide() and self.productId then
    for k, v in pairs(self.cellList) do
      if v.data.productId == self.productId then
        v:DeleteTimer()
        break
      end
    end
    EventManager:GetInstance():Broadcast(EventId.CloseGuideMoveArrow)
  end
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function SetAllCellDestroy(self)
  self.tab_content:RemoveComponents(FactoryItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.cellList = {}
  self.modelCount = 0
  self.animatorIndex = 1
end

local function SetAllItemDestroy(self)
  self.gather_list:RemoveComponents(FactoryGatherResItem)
  if self.gatherModel ~= nil then
    for k, v in pairs(self.gatherModel) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.gatherCells = {}
end

local function OnPointerEnter(self, eventData)
end

local function OnPointerExit(self, eventData)
end

local function OnFingerIn(self, name, order)
  self.gatherDic[name] = order
end

local function OnGatherItems(self)
  self.ctrl:SendGatherMessage(self.gatherDic)
  self.gatherDic = {}
end

local function SetGatherData(self, list)
  self:SetAllItemDestroy()
  self.gatherModel = {}
  if list ~= nil then
    local order = -1
    table.walk(list, function(k, v)
      self.gatherModelCount = self.gatherModelCount + 1
      self.gatherModel[self.gatherModelCount] = self:GameObjectInstantiateAsync(UIAssets.FactoryGatherResItem, function(request)
        if request.isError then
          return
        end
        order = order + 1
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.gather_list.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(order)
        go.name = nameStr
        local cell = self.gather_list:AddComponent(FactoryGatherResItem, nameStr)
        cell:RefreshData(v)
        cell:SetOrder(order)
        cell:SetPrefabName(order)
        table.insert(self.gatherCells, cell)
      end)
    end)
    self.gatherAnimatorIndex = 1
    local gatherTime = self.gather_list_anim:GetFloat("DuringTime")
    self.gatherAnimatorTime = gatherTime / 10
    self.showGatherAnimator = true
    self.gatherStartTime = 0
  end
end

local function SetData(self)
  if not self.view.ctrl:CheckHasFreeQueue(self.view.buildUuid) then
    self.productId = 0
  end
  local list = self.ctrl:GetItemList(self.currentItemIndex)
  self:SetAllCellDestroy()
  self.model = {}
  if list ~= nil then
    self.modelCount = 0
    table.walk(list, function(k, v)
      self.modelCount = self.modelCount + 1
      self.model[self.modelCount] = self:GameObjectInstantiateAsync(UIAssets.FactoryItem, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.tab_content.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        local nameStr = tostring(NameCount)
        go.name = nameStr
        NameCount = NameCount + 1
        local cell = self.tab_content:AddComponent(FactoryItem, nameStr)
        cell:RefreshData(v, self.productId)
        table.insert(self.cellList, cell)
        self:CheckGuide()
      end)
    end)
    self.animatorIndex = 1
    local time = self.content_anim:GetFloat("DuringTime")
    self.animatorTime = time / 10
    self.showAnimator = true
    self.startTime = 0
  end
  local layout = self.tab_content.transform:GetComponent(typeof(CS.UnityEngine.UI.GridLayoutGroup))
  local total = #list
  local s = self.tab_content.transform.localScale.x
  local _width = layout.cellSize.x * total + layout.spacing.x * (total - 1) + layout.padding.left + layout.padding.right
  self.tab_img.rectTransform.sizeDelta = Vector2.New(_width * s, self.tab_img.rectTransform.rect.height)
  self.search_obj:SetActive(self.showDes)
  self.drag_item_img:SetActive(self.showDrag)
end

local function RefreshFactoryItem(self)
  local list = self.ctrl:GetItemList(self.currentItemIndex)
  if list ~= nil then
    for i, v in ipairs(list) do
      if self.cellList[i] ~= nil then
        self.cellList[i]:RefreshData(v)
      end
      if DataCenter.FactoryDataManager:IsUnlockProductByProductId(v.productId) then
        DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.FactoryCanUnlock, tostring(v.productId))
      end
    end
  end
end

local function OnProductLevelClick(self, currentIndex)
  self.currentItemIndex = currentIndex
  self:RefreshFactoryItem()
  self:HideDes()
end

local function RefreshProductLevel(self)
  local productLevels = self.ctrl:GetProductLevels()
  self.productLevelState:ReInit(productLevels, BindCallback(self, self.OnProductLevelClick))
  self.productLevelState:SetActive(table.count(productLevels) > 1)
end

local function ShowTabEnterAnimator(self)
  local cellCount = #self.cellList
  if self.modelCount == cellCount and 0 < cellCount then
    if cellCount >= self.animatorIndex then
      self.cellList[self.animatorIndex]:DoEnterAnim()
      self.animatorIndex = self.animatorIndex + 1
    else
      self.showAnimator = false
    end
  end
end

local function ShowGatherEnterAnimator(self)
  if self.gatherCells == nil then
    return
  end
  local cellCount = #self.gatherCells
  if 0 < cellCount then
    if cellCount >= self.gatherAnimatorIndex then
      self.gatherCells[self.gatherAnimatorIndex]:DoEnterAnim()
      self.gatherAnimatorIndex = self.gatherAnimatorIndex + 1
    else
      self.showGatherAnimator = false
    end
  end
end

local function Update(self)
  if self.showAnimator then
    self.startTime = self.startTime + Time.deltaTime
    if self.startTime >= self.animatorTime then
      self:ShowTabEnterAnimator()
      self.startTime = 0
    end
  end
  if self.showGatherAnimator then
    self.gatherStartTime = self.gatherStartTime + Time.deltaTime
    if self.gatherStartTime >= self.gatherAnimatorTime then
      self:ShowGatherEnterAnimator()
      self.gatherStartTime = 0
    end
  end
  if self.bgModel ~= nil then
    self.bgModel:Update()
  end
end

local function OnDragItem(self, eventData, itemData)
  if self.drag_item_img:GetActive() then
    local curPos = eventData.position
    local posV3 = Vector3.New(curPos.x, curPos.y, 0)
    self.drag_item_img.transform.position = posV3
    if self.showDes then
      self.search_obj:SetPosition(curPos.x, curPos.y)
    end
    self:OnFactoryAddIconToBox(itemData)
  end
end

local function OnBeginDragItem(self, eventData, itemData)
  if itemData ~= nil then
    self.drag_item_img:LoadSprite(itemData.icon)
    if itemData.sizeX ~= nil and itemData.sizeY ~= nil then
      self.drag_item_img.rectTransform:Set_sizeDelta(itemData.sizeX, itemData.sizeY)
    end
    self.showDrag = true
    self.drag_item_img:SetActive(self.showDrag)
  end
end

local function OnFactoryAddIconToBox(self, itemData)
  local data = self.ctrl:GetProductData()
  if itemData ~= nil and self.bgModel ~= nil and self.param ~= nil then
    local checkChange = false
    table.walk(self.param.boxDataList, function(k, v)
      if checkChange == false and v.itemId == nil and data.boxDataList[k].itemId == nil then
        self.bgModel:AddIconToBox(k, itemData, false)
        checkChange = true
      end
    end)
  end
end

local function OnFactoryRemoveIconToBox(self, itemData)
  local data = self.ctrl:GetProductData()
  if self.bgModel ~= nil and self.param ~= nil then
    local checkChange = false
    table.walk(self.param.boxDataList, function(k, v)
      if checkChange == false and v.itemId == nil and data.boxDataList[k].itemId == nil then
        self.bgModel:RemoveIconToBox(k, itemData, false)
        checkChange = true
      end
    end)
  end
end

local function AddItemToBox(self)
  self.isEnterBox = true
end

local function RemoveItemFromBox(self)
  self.isEnterBox = false
end

local function DragBox(self, diff)
  local ratio = 100
  local moveDiff = diff / ratio
  self.bgModel:DragBox(moveDiff, true)
end

local function MoveToFirstBox(self)
  self.bgModel:MoveToFirstBox()
end

local function MoveToLastBox(self)
  self.bgModel:MoveToLastBox()
end

local function OnEndDragItem(self, eventData, itemData)
  self.showDrag = false
  if self.showDes then
    self.showDes = false
    self.search_obj:SetShowState(self.showDes)
  end
  if self.drag_item_img ~= nil and self.drag_item_img:GetActive() then
    self.drag_item_img:SetActive(self.showDrag)
    self:OnFactoryRemoveIconToBox(itemData)
    if self.isEnterBox then
      self.ctrl:OnDragFinish(itemData, self.factoryUid)
      self.isEnterBox = false
    end
  end
  self.isEnterBox = false
end

local function OnHoldItem(self, itemData, posX, posY, checkState)
  if itemData.hasDes then
    self.showDes = true
    if self.search_obj:GetActive() == false then
      self.search_obj:SetActive(true)
    end
    self.search_obj:RefreshData(itemData, posX, posY)
    self.search_obj:SetShowState(true)
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Click_Formula, false)
    if checkState == true then
      self.drag_item_img:LoadSprite(itemData.icon)
      if itemData.sizeX ~= nil and itemData.sizeY ~= nil then
        self.drag_item_img.rectTransform:Set_sizeDelta(itemData.sizeX, itemData.sizeY)
      end
      self.drag_item_img.transform:Set_position(posX, posY, 0)
      self.drag_item_img:SetActive(true)
    end
  end
end

local function OnCancelItem(self)
  if self.showDrag == false then
    self.drag_item_img:SetActive(false)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetFactoryData, self.OnGetFactoryDataBack)
  self:AddUIListener(EventId.GatherFactoryItem, self.OnGatherItemCallBack)
  self:AddUIListener(EventId.AddFactoryBox, self.OnAddBoxCallBack)
  self:AddUIListener(EventId.AddFactoryProduct, self.OnAddProductCallBack)
  self:AddUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
  self:AddUIListener(EventId.ResourceUpdated, self.OnResourceDataBack)
  self:AddUIListener(EventId.FactoryTransportAnimationEnd, self.OnFactoryTransportAnimationEnd)
  self:AddUIListener(EventId.FactoryTransportAnimationStart, self.OnFactoryTransportAnimationStart)
  self:AddUIListener(EventId.FactoryDataAddSpeed, self.OnFactoryDataAddSpeed)
  self:AddUIListener(EventId.FactoryDataCancel, self.OnCancelBack)
  self:AddUIListener(EventId.END_SEARCH, self.OnSearchCallBack)
  self:AddUIListener(EventId.PVEBuildingUpgradeBack, self.OnPveBuildingUpgrade)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.PVEBuildingUpgradeBack, self.OnPveBuildingUpgrade)
  self:RemoveUIListener(EventId.FactoryDataCancel, self.OnCancelBack)
  self:RemoveUIListener(EventId.FactoryTransportAnimationEnd, self.OnFactoryTransportAnimationEnd)
  self:RemoveUIListener(EventId.FactoryTransportAnimationStart, self.OnFactoryTransportAnimationStart)
  self:RemoveUIListener(EventId.GetFactoryData, self.OnGetFactoryDataBack)
  self:RemoveUIListener(EventId.GatherFactoryItem, self.OnGatherItemCallBack)
  self:RemoveUIListener(EventId.AddFactoryBox, self.OnAddBoxCallBack)
  self:RemoveUIListener(EventId.AddFactoryProduct, self.OnAddProductCallBack)
  self:RemoveUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
  self:RemoveUIListener(EventId.ResourceUpdated, self.OnResourceDataBack)
  self:RemoveUIListener(EventId.FactoryDataAddSpeed, self.OnFactoryDataAddSpeed)
  self:RemoveUIListener(EventId.END_SEARCH, self.OnSearchCallBack)
end

local function OnSearchCallBack(self, param)
  if param ~= nil then
    self.ctrl:OnSearchEnd(param.pointId, param.uuid)
  end
end

local function OnRightClick(self)
  local index
  self.curIndex = self.curIndex + 1
  if self.curIndex > table.count(self.factoryArr) then
    self.curIndex = 1
  end
  self:HideDes()
  for i, v in pairs(self.factoryArr) do
    if Mathf.Floor(self.curIndex) == Mathf.Floor(v.index) then
      local buildData = DataCenter.BuildManager:GetFunbuildByItemID(v.factory)
      if buildData ~= nil and DataCenter.FactoryDataManager:HasUnlockItemByBuildId(v.factory) then
        local data = DataCenter.BuildManager:GetBuildingDataByUuid(buildData.uuid)
        if data ~= nil and data.state ~= BuildingStateType.FoldUp then
          if self.bgModel ~= nil then
            self.bgModel:DestroySelf()
            self.bgModel = nil
          end
          self:UpdateView(buildData.uuid)
          index = self.curIndex
        end
      end
    end
  end
  if index == nil then
    self:OnRightClick()
  end
end

local function OnLeftClick(self)
  local index
  self.curIndex = self.curIndex - 1
  if self.curIndex <= 0 then
    self.curIndex = table.count(self.factoryArr)
  end
  self:HideDes()
  for i, v in pairs(self.factoryArr) do
    if Mathf.Floor(self.curIndex) == Mathf.Floor(v.index) then
      local buildData = DataCenter.BuildManager:GetFunbuildByItemID(v.factory)
      if buildData ~= nil and DataCenter.FactoryDataManager:HasUnlockItemByBuildId(v.factory) then
        local data = DataCenter.BuildManager:GetBuildingDataByUuid(buildData.uuid)
        if data ~= nil and data.state ~= BuildingStateType.FoldUp then
          if self.bgModel ~= nil then
            self.bgModel:DestroySelf()
            self.bgModel = nil
          end
          self:UpdateView(buildData.uuid)
          index = self.curIndex
        end
      end
    end
  end
  if index == nil then
    self:OnLeftClick()
  end
end

local function GetFoodBuildStr(self)
  local str = "1;711000|2;707000|3;717000|4;718000|5;723000|6;708000"
  self.factoryArr = {}
  self.left = false
  self.right = false
  self.nextIndex = 2
  local vec = string.split(str, "|")
  table.walk(vec, function(k, v)
    local vec1 = string.split(v, ";")
    local param = {}
    param.index = vec1[1]
    param.factory = tonumber(vec1[2])
    if param.factory == self.buildId then
      self.curIndex = Mathf.Floor(param.index)
    end
    table.insert(self.factoryArr, param)
  end)
  if table.count(self.factoryArr) > 0 then
    for i, v in pairs(self.factoryArr) do
      local buildData = DataCenter.BuildManager:GetFunbuildByItemID(v.factory)
      if buildData ~= nil then
        local data = DataCenter.BuildManager:GetBuildingDataByUuid(buildData.uuid)
        if data ~= nil and data.state ~= BuildingStateType.FoldUp and self.curIndex ~= nil then
          if self.curIndex > Mathf.Floor(v.index) then
            self.left = true
          elseif self.curIndex < Mathf.Floor(v.index) then
            self.right = true
          end
        end
      end
    end
  end
  if self.left == true or self.right == true then
    self.left_btn.gameObject:SetActive(true)
    self.right_btn.gameObject:SetActive(true)
  else
    self.left_btn.gameObject:SetActive(false)
    self.right_btn.gameObject:SetActive(false)
  end
end

local function CheckGuide(self)
  if DataCenter.GuideManager:InGuide() then
    local template = DataCenter.GuideManager:GetCurTemplate()
    if template ~= nil then
      if template.type == GuideType.PlayMovie and template.para1 ~= nil and tonumber(template.para1) == GuidePlayMovieType.FactoryShowFreeBtn then
        if DataCenter.GuideManager:IsFactoryFirstFreeSpeed() then
          self.guideFreeSpeed = true
          self.stateBig:Update()
        end
      elseif template.type == GuideType.Factory then
        local buildId = tonumber(template.para2)
        if buildId == self.buildId then
          local productId = tonumber(template.para1)
          local obj = self:GetFactoryItemGuideObj(productId)
          if obj ~= nil then
            local param = {}
            param.pointList = {}
            local startParam = {}
            startParam.pointType = PositionType.Screen
            startParam.pointObj = obj
            table.insert(param.pointList, startParam)
            local endParam = {}
            endParam.pointType = PositionType.Screen
            endParam.pointObj = self.guide_box.gameObject
            table.insert(param.pointList, endParam)
            param.arrowtype = tonumber(template.arrowtype)
            param.arrowdirection = tonumber(template.arrowdirection)
            local image = self:GetGuideIcon(productId)
            if image ~= nil then
              param.sprite = image:GetImage()
              param.spriteSize = image:GetSizeDelta()
            end
            DataCenter.GuideManager:SetCompleteNeedParam(param)
          end
        end
      end
    end
  end
end

local function GetFactoryItemGuideObj(self, id)
  for k, v in pairs(self.cellList) do
    if v.data.productId == id then
      return v:GetGuideObj()
    end
  end
end

local function GetGuideIcon(self, id)
  for k, v in pairs(self.cellList) do
    if v.data.productId == id then
      return v:GetGuideIcon()
    end
  end
end

local function RefreshGuideSignal(self)
  self:CheckGuide()
end

local function OnFactoryTransportAnimationEnd(self)
  self:SetSpeedUpVisible()
  self:ResetCancelBtnState()
end

local function OnFactoryTransportAnimationStart(self)
  self:ResetCancelBtnState()
end

local function SetSpeedUpVisible(self)
end

local function CheckGuideClickTime(self)
  if DataCenter.GuideManager:InGuide() then
    local template = DataCenter.GuideManager:GetCurTemplate()
    if template ~= nil and template.jumptype == GuideJumpType.FactorySpeed then
      local state = DataCenter.GuideManager:GetCanDoGuideState(template.id)
      if state == GuideCanDoType.No then
        DataCenter.GuideManager:DoJump()
      end
    end
  end
end

local function GetGuideBox(self)
  return self.guide_box.gameObject
end

local function UpdateAddSpeedBtns(self)
  local workingList = self.param.workingList
  self.stateBig:SetActive(false)
  self.stateSmall_1:SetActive(false)
  self.stateSmall_2:SetActive(false)
  if workingList == nil then
    return
  end
  
  local function SetStateCell(cell, data)
    if cell ~= nil then
      if data == nil then
        cell:SetActive(false)
      else
        cell:SetActive(true)
        cell:SetData(data)
      end
    end
  end
  
  if self.param.multiQueue then
    SetStateCell(self.stateSmall_1, workingList[1])
    SetStateCell(self.stateSmall_2, workingList[2])
  else
    SetStateCell(self.stateBig, workingList[1])
  end
end

local function OnCancelClick(self, index)
  if DataCenter.ResourceItemDataManager:CheckIsStorageFull(0) then
    UIUtil.ShowTipsId(131012)
    return
  end
  if index <= 0 then
    return
  end
  UIUtil.ShowMessage(Localization:GetString("131011"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
    DataCenter.FactoryDataManager:SendCancelFactoryPanel(self.factoryUid, index)
  end, function()
  end)
end

local function ResetCancelBtnState(self)
end

local function CheckGuideFree(self)
  return self.guideFreeSpeed
end

local function ShowDes(self, pos, itemData)
end

local function HideDes(self)
  self.showDes = false
  self.search_obj:SetShowState(false)
  self.search_obj:SetActive(false)
end

local function OnUpgradeClick(self)
  if CS.SceneManager.IsInPVE() then
    local triggerData = DataCenter.BattleLevel:GetTriggerByTriggerId(self.buildId)
    if triggerData ~= nil then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEFactoryUpgrade, {anim = true}, triggerData)
    end
  end
end

local function RefreshPveUpgradeBtn(self)
  local triggerData = DataCenter.BattleLevel:GetTriggerByTriggerId(self.buildId)
  if triggerData ~= nil then
    local upgradeCondition = triggerData:GetPVEFactoryUpgradeCondition()
    self.upgrade_btn:SetActive(upgradeCondition ~= nil)
  end
end

local function OnPveBuildingUpgrade(self)
  if self.bgModel ~= nil then
    self.bgModel:DestroySelf()
    self.bgModel = nil
  end
  self:UpdateView(self.factoryUid)
end

local function SetBoxCamera(self)
  if self.bgModel then
    local data = self.ctrl:GetProductData()
    local pos = self.rawImg1.transform.localPosition
    local s = 0.3
    if data.showAddBox then
      pos.x = 25
    else
      pos.x = 80
      s = 0.36
    end
    self.rawImg1.transform.localPosition = pos
    self.rawImg1.transform.localScale = Vector3.New(s, s, 1)
    self.bgModel:SetBoxCamera(data.showAddBox)
  end
end

local function OnPointerClick(self, eventData)
  if self.bgModel and eventData then
    self.bgModel:OnPointerClick(Vector3.New(eventData.position.x, eventData.position.y, 0))
  end
end

UIFactoryView.SetBoxCamera = SetBoxCamera
UIFactoryView.OnCreate = OnCreate
UIFactoryView.OnDestroy = OnDestroy
UIFactoryView.OnEnable = OnEnable
UIFactoryView.OnDisable = OnDisable
UIFactoryView.SetData = SetData
UIFactoryView.OnDragItem = OnDragItem
UIFactoryView.OnBeginDragItem = OnBeginDragItem
UIFactoryView.OnEndDragItem = OnEndDragItem
UIFactoryView.OnHoldItem = OnHoldItem
UIFactoryView.OnCancelItem = OnCancelItem
UIFactoryView.SetAllCellDestroy = SetAllCellDestroy
UIFactoryView.UpdateView = UpdateView
UIFactoryView.ShowTabEnterAnimator = ShowTabEnterAnimator
UIFactoryView.SetAllItemDestroy = SetAllItemDestroy
UIFactoryView.OnFingerIn = OnFingerIn
UIFactoryView.OnPointerEnter = OnPointerEnter
UIFactoryView.OnPointerExit = OnPointerExit
UIFactoryView.OnGatherItems = OnGatherItems
UIFactoryView.SetGatherData = SetGatherData
UIFactoryView.Update = Update
UIFactoryView.AddItemToBox = AddItemToBox
UIFactoryView.RemoveItemFromBox = RemoveItemFromBox
UIFactoryView.OnFactoryDataCallBack = OnFactoryDataCallBack
UIFactoryView.OnResourceDataBack = OnResourceDataBack
UIFactoryView.OnAddListener = OnAddListener
UIFactoryView.OnRemoveListener = OnRemoveListener
UIFactoryView.OnGatherItemCallBack = OnGatherItemCallBack
UIFactoryView.OnAddBoxCallBack = OnAddBoxCallBack
UIFactoryView.OnAddProductCallBack = OnAddProductCallBack
UIFactoryView.OnAddBoxClick = OnAddBoxClick
UIFactoryView.ShowGatherEnterAnimator = ShowGatherEnterAnimator
UIFactoryView.OnFactoryAddIconToBox = OnFactoryAddIconToBox
UIFactoryView.OnFactoryRemoveIconToBox = OnFactoryRemoveIconToBox
UIFactoryView.RefreshFactoryItem = RefreshFactoryItem
UIFactoryView.OnRightClick = OnRightClick
UIFactoryView.OnLeftClick = OnLeftClick
UIFactoryView.GetFoodBuildStr = GetFoodBuildStr
UIFactoryView.CheckGuide = CheckGuide
UIFactoryView.GetFactoryItemGuideObj = GetFactoryItemGuideObj
UIFactoryView.RefreshGuideSignal = RefreshGuideSignal
UIFactoryView.CheckGuideClickTime = CheckGuideClickTime
UIFactoryView.GetGuideIcon = GetGuideIcon
UIFactoryView.SetSpeedUpVisible = SetSpeedUpVisible
UIFactoryView.OnFactoryTransportAnimationEnd = OnFactoryTransportAnimationEnd
UIFactoryView.GetGuideBox = GetGuideBox
UIFactoryView.OnCloseArrow = OnCloseArrow
UIFactoryView.OnFactoryDataAddSpeed = OnFactoryDataAddSpeed
UIFactoryView.OnGetFactoryDataBack = OnGetFactoryDataBack
UIFactoryView.AddUnlockItemTimer = AddUnlockItemTimer
UIFactoryView.RemoveUnlockItemTimer = RemoveUnlockItemTimer
UIFactoryView.UpdateAddSpeedBtns = UpdateAddSpeedBtns
UIFactoryView.OnCancelClick = OnCancelClick
UIFactoryView.OnCancelBack = OnCancelBack
UIFactoryView.ResetCancelBtnState = ResetCancelBtnState
UIFactoryView.CheckGuideFree = CheckGuideFree
UIFactoryView.ShowDes = ShowDes
UIFactoryView.HideDes = HideDes
UIFactoryView.OnSearchCallBack = OnSearchCallBack
UIFactoryView.OnProductLevelClick = OnProductLevelClick
UIFactoryView.RefreshProductLevel = RefreshProductLevel
UIFactoryView.OnUpgradeClick = OnUpgradeClick
UIFactoryView.RefreshPveUpgradeBtn = RefreshPveUpgradeBtn
UIFactoryView.OnPveBuildingUpgrade = OnPveBuildingUpgrade
UIFactoryView.OnFactoryTransportAnimationStart = OnFactoryTransportAnimationStart
UIFactoryView.DragBox = DragBox
UIFactoryView.MoveToFirstBox = MoveToFirstBox
UIFactoryView.MoveToLastBox = MoveToLastBox
UIFactoryView.OnPointerClick = OnPointerClick
return UIFactoryView
