local PastureDesTip = require("UI.UIPasture.Component.PastureDesTip")
local UIPastureView = BaseClass("UIPastureView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local gather_obj_path = "tips"
local drag_item_img_path = "dragImg"
local drag_item_num_path = "dragImg/drag_num_bg"
local drag_item_num_text_path = "dragImg/drag_num_bg/drag_num_txt"
local des_obj_path = "Search"
local tips_bg_path = "tips/Image"
local tips_bg5_path = "tips/Image_5"
local animal_trigger_path = "tips/animalObj"
local gather_trigger_path = "tips/gatherObj"
local feed_trigger_path = "tips/feedObj"
local irrigate_trigger_path = "tips/irrigateObj"
local irrigateIcon_path = "tips/irrigateObj/irrigateIcon"
local irrigateTime_path = "tips/irrigateObj/irrigateIcon/recoverTime"
local irrigateNumBg_path = "tips/irrigateObj/irrigateIcon/irriNumBg"
local irrigateNum_path = "tips/irrigateObj/irrigateIcon/irriNumBg/irriNum"
local animal_icon_path = "tips/animalObj/animalIcon"
local gather_icon_path = "tips/gatherObj/gatherIcon"
local feed_icon_path = "tips/feedObj/feedIcon"
local feed_num_path = "tips/feedObj/feedIcon/num_bg/num_txt"
local gray_path = "Gray"
local light_path = "Light"
local add_img_path = "tips/animalObj/add_img"
local max_img_path = "tips/animalObj/max_img"
local max_num_path = "tips/animalObj/max_img/max_num"
local robot_btn_path = "tips/robotBtn"
local BTNTYPE = {
  FEED = 1,
  GATHER = 2,
  ANIMAL = 3
}
local UIPastureResourceItemPositions = {
  {
    Vector3.New(-280, 70, 0),
    Vector3.New(-176, 190, 0)
  },
  {
    Vector3.New(-290, 38, 0),
    Vector3.New(-222.5, 158, 0),
    Vector3.New(-76, 253, 0)
  },
  {
    Vector3.New(-317, -10, 0),
    Vector3.New(-315, 135, 0),
    Vector3.New(-234.5, 243, 0),
    Vector3.New(-82, 304.5, 0)
  },
  {
    Vector3.New(-351, 149, 0),
    Vector3.New(-286, 252, 0),
    Vector3.New(-169, 345, 0),
    Vector3.New(-232, 95, 0),
    Vector3.New(-121, 227, 0)
  }
}

local function OnCreate(self)
  base.OnCreate(self)
  self.tips_obj_ani = self:AddComponent(UIAnimator, gather_obj_path)
  self.drag_item_img = self:AddComponent(UIImage, drag_item_img_path)
  self.drag_item_num_text = self:AddComponent(UIText, drag_item_num_text_path)
  self.drag_item_num = self:AddComponent(UIBaseContainer, drag_item_num_path)
  self.add_img = self:AddComponent(UIImage, add_img_path)
  self.animator = self:AddComponent(UIAnimator, drag_item_img_path)
  self.search_obj = self:AddComponent(PastureDesTip, des_obj_path)
  self.animal_icon = self:AddComponent(UIImage, animal_icon_path)
  self.animal_iconAnim = self:AddComponent(UIAnimator, animal_icon_path)
  self.gather_icon = self:AddComponent(UIImage, gather_icon_path)
  self.gather_iconAnim = self:AddComponent(UIAnimator, gather_icon_path)
  self.tips_bg = self:AddComponent(UIImage, tips_bg_path)
  self.tips_bg5 = self:AddComponent(UIImage, tips_bg5_path)
  self.robot_img = self:AddComponent(UIImage, robot_btn_path)
  self.robot_btn = self:AddComponent(UIButton, robot_btn_path)
  self.robot_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  self.feed_icon = self:AddComponent(UIImage, feed_icon_path)
  self.feed_iconAnim = self:AddComponent(UIAnimator, feed_icon_path)
  self.feed_num = self:AddComponent(UIText, feed_num_path)
  self.gray_image = self:AddComponent(UIImage, gray_path)
  self.light_image = self:AddComponent(UIImage, light_path)
  self.max_img = self:AddComponent(UIBaseContainer, max_img_path)
  self.max_num = self:AddComponent(UIText, max_num_path)
  self.gray = self.gray_image:GetMaterial()
  self.light = self.light_image:GetMaterial()
  self.animal_anim = self:AddComponent(UIAnimator, animal_trigger_path)
  self.animal_trigger = self:AddComponent(UIEventTrigger, animal_trigger_path)
  self.animal_trigger:OnBeginDrag(function(eventData)
    self:OnAnimalBeginDrag(eventData)
  end)
  self.animal_trigger:OnDrag(function(eventData)
    self:OnAnimalOnDrag(eventData)
  end)
  self.animal_trigger:OnEndDrag(function(eventData)
    self:OnAnimalOnEndDrag(eventData)
  end)
  self.animal_trigger:OnPointerDown(function(eventData)
    self:OnAnimalOnPointerDown(eventData)
  end)
  self.animal_trigger:OnPointerUp(function(eventData)
    self:OnAnimalOnPointerUp(eventData)
  end)
  self.feed_anim = self:AddComponent(UIAnimator, feed_trigger_path)
  self.feed_trigger = self:AddComponent(UIEventTrigger, feed_trigger_path)
  self.feed_trigger:OnBeginDrag(function(eventData)
    self:OnFeedBeginDrag(eventData)
  end)
  self.feed_trigger:OnDrag(function(eventData)
    self:OnFeedOnDrag(eventData)
  end)
  self.feed_trigger:OnEndDrag(function(eventData)
    self:OnFeedOnEndDrag(eventData)
  end)
  self.feed_trigger:OnPointerDown(function(eventData)
    self:OnFeedOnPointerDown(eventData)
  end)
  self.feed_trigger:OnPointerUp(function(eventData)
    self:OnFeedOnPointerUp(eventData)
  end)
  self.irrigateIcon = self:AddComponent(UIImage, irrigateIcon_path)
  self.irrigateTime = self:AddComponent(UIText, irrigateTime_path)
  self.irrigateNum = self:AddComponent(UIText, irrigateNum_path)
  self.irrigateNumBg = self:AddComponent(UIBaseContainer, irrigateNumBg_path)
  self.irrigateAnim = self:AddComponent(UIAnimator, irrigate_trigger_path)
  self.irrigateTrigger = self:AddComponent(UIEventTrigger, irrigate_trigger_path)
  self.irrigateTrigger:OnBeginDrag(function(eventData)
    self:OnBeginDragIrrigate(eventData)
  end)
  self.irrigateTrigger:OnDrag(function(eventData)
    self:OnDragIrrigate(eventData)
  end)
  self.irrigateTrigger:OnEndDrag(function(eventData)
    self:OnEndDragIrrigate(eventData)
  end)
  self.irrigateIcon:SetActive(true)
  self.irrigateTrigger:OnPointerDown(function(eventData)
    self:OnPointerDownIrrigate(eventData)
  end)
  self.irrigateTrigger:OnPointerUp(function(eventData)
    self:OnPointerUpIrrigate(eventData)
  end)
  self.gather_anim = self:AddComponent(UIAnimator, gather_trigger_path)
  self.gather_trigger = self:AddComponent(UIEventTrigger, gather_trigger_path)
  self.drag_item_img:SetActive(false)
  self.gather_icon.gameObject:SetActive(true)
  self.gather_trigger:OnBeginDrag(function(eventData)
    self:OnGatherBeginDrag(eventData)
  end)
  self.gather_trigger:OnDrag(function(eventData)
    self:OnGatherOnDrag(eventData)
  end)
  self.gather_trigger:OnEndDrag(function(eventData)
    self:OnGatherOnEndDrag(eventData)
  end)
  self.showDrag = false
  self.showTip = true
  self.showDes = false
  self.curSelectState = FarmStateType.None
  self.search_obj:SetActive(false)
  self.needResetOpen = nil
  self.isBuy = false
end

local function OnDestroy(self)
  DataCenter.RecommendShowManager:ResetState()
  EventManager:GetInstance():Broadcast(EventId.CloseGuideMoveArrow)
  if self.needResetOpen then
    EventManager:GetInstance():Broadcast(EventId.GuideNoOpenUI, false)
  end
  self.gather_obj = nil
  self.drag_item_img = nil
  self.drag_item_num = nil
  self.animator = nil
  self.showDrag = nil
  self.showTip = nil
  self.isBuy = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.ctrl:InitData(self:GetUserData())
  self:UpdateView()
  EventManager:GetInstance():Broadcast(EventId.PasturePanelStateChange, self.buildUuid)
end

local function UpdateView(self)
  self.buildUuid = self.ctrl:GetBUuid()
  local open = LuaEntry.Effect:GetGameEffect(EffectDefine.ROBOT_IN_PASTURE)
  local showBuy = self.ctrl:CanShowBuy()
  local showRobot = 0 < open
  local showList = {}
  local canIrrigate = DataCenter.PlayerCareerManager:CheckIfIrrigateAvailable(IrrigationType.Pasture)
  if canIrrigate then
    table.insert(showList, self.irrigateTrigger)
  else
    self.irrigateTrigger:SetActive(false)
  end
  if showRobot then
    table.insert(showList, self.robot_btn)
    local queue = DataCenter.BuildQueueManager:GetQueueDataByBuildUuid(self.buildUuid, false, false)
    if queue ~= nil then
      local iconStr = GetTableData(TableName.Robot, queue.robotId, "icon2")
      self.robot_img:LoadSprite("Assets/Main/Sprites/UI/UIFarm/" .. iconStr)
    else
      self.robot_img:LoadSprite("Assets/Main/Sprites/UI/UIFarm/UIPasture_icon_robot_add.png")
    end
  else
    self.robot_btn:SetActive(false)
  end
  if showBuy then
    table.insert(showList, self.animal_trigger)
  else
    self.animal_trigger:SetActive(false)
  end
  table.insert(showList, self.gather_trigger)
  table.insert(showList, self.feed_trigger)
  local totalNum = #showList
  if totalNum == 5 then
    self.tips_bg:SetActive(false)
    self.tips_bg5:SetActive(true)
  else
    self.tips_bg:SetActive(true)
    self.tips_bg5:SetActive(false)
    local bg_path = "Assets/Main/Sprites/UI/UIFarm/UIFarm_bg_4_cell.png"
    local pos = self.tips_bg.transform.localPosition
    self.tips_bg.transform:Set_localPosition(0, pos.y, pos.z)
    if totalNum == 2 then
      bg_path = "Assets/Main/Sprites/UI/UIFarm/UIFarm_bg_2_cell.png"
      self.tips_bg.transform:Set_localPosition(-100, pos.y, pos.z)
    elseif totalNum == 3 then
      bg_path = "Assets/Main/Sprites/UI/UIFarm/UIFarm_bg_3_cell.png"
    end
    self.tips_bg:LoadSprite(bg_path)
    self.tips_bg:SetNativeSize()
  end
  local posVec = UIPastureResourceItemPositions[totalNum - 1]
  if posVec == nil then
    return
  end
  for i = 1, totalNum do
    showList[i].transform.anchoredPosition = posVec[i]
    showList[i]:SetActive(true)
  end
  self.tips_obj_ani:Play("UIPasture_movein", 0, 0)
  local info = DataCenter.BuildManager:GetBuildingDataByUuid(self.buildUuid)
  if info ~= nil then
    local pointId = info.pointId
    local worldPos = SceneUtils.TileIndexToWorld(pointId)
    local pos = CS.SceneManager.World:WorldToScreenPoint(worldPos)
    self.tips_obj_ani.transform.position = pos
  end
  self.feed_icon:SetActive(true)
  self:InitInfo()
  EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildShowEffect, tostring(self.buildUuid))
  self.ctrl:RemoveBusyQueueItemAndResource()
  self:SetData()
  self:CheckGuide()
  self:CheckRecommend()
end

local function OnDisable(self)
  EventManager:GetInstance():Broadcast(EventId.ClickFarmBuildHide)
  self.ctrl:ResetUsingItemAndResource()
  base.OnDisable(self)
  EventManager:GetInstance():Broadcast(EventId.PasturePanelStateChange, self.buildUuid)
end

local function InitInfo(self)
  self.showDrag = false
  self.drag_item_img:SetActive(self.showDrag)
  self.animal_icon.gameObject:SetActive(true)
  self.drag_item_num:SetActive(true)
  self.curSelectState = FarmStateType.None
end

local function SetData(self)
  self.animalData = self.ctrl:GetAnimalData()
  if self.animalData ~= nil then
    self.animal_icon:LoadSprite(self.animalData.icon)
    if self.animalData.unlock == false then
      self.animal_icon:SetMaterial(self.gray)
      self.add_img:SetActive(false)
    else
      self.animal_icon:SetMaterial(nil)
      self.add_img:SetActive(true)
    end
  end
  if self.ctrl:IsMax() then
    self.max_img:SetActive(true)
    self.max_num:SetLocalText(GameDialogDefine.MAX)
  else
    self.max_img:SetActive(false)
  end
  self.feedData = self.ctrl:GetFeedData()
  if self.feedData ~= nil then
    self.feed_icon:LoadSprite(self.feedData.icon)
    if self.feedData.unlock == false then
      self.feed_icon:SetMaterial(self.gray)
    else
      self.feed_icon:SetMaterial(nil)
    end
    self.feed_num:SetText(self.feedData.needGoodsCurNum)
    self.drag_item_num_text:SetText(self.feedData.needGoodsCurNum)
  end
  self.gatherData = self.ctrl:GetGatherData()
  if self.gatherData ~= nil then
    self.gather_icon:LoadSprite(self.gatherData.icon)
    if self.gatherData.unlock == false then
      self.gather_icon:SetMaterial(self.gray)
    else
      self.gather_icon:SetMaterial(nil)
    end
  end
  self.irrigateData = self.ctrl:GetIrrigateData()
  if self.irrigateData.irrigateInfo.remainTimes > 0 then
    self.irrigateNumBg:SetActive(true)
    self.irrigateNum:SetText(self.irrigateData.irrigateInfo.remainTimes)
    self.irrigateTime:SetActive(false)
  else
    self.irrigateNumBg:SetActive(false)
    self.irrigateTime:SetActive(true)
    local serverT = UITimeManager:GetInstance():GetServerTime()
    local nextRecoverT = self.irrigateData.irrigateInfo.lastRecoverTime + self.irrigateData.irrigateInfo.recoverTimeS * 1000 - serverT
    self.irrigateTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtStringSpecial(nextRecoverT))
  end
  if self.ctrl:GetBtnType() ~= nil then
    if self.ctrl:GetBtnType() == BTNTYPE.FEED then
      self.feed_anim:Play(RecommendShowAnimName[RecommendShowAnimType.Show], 0, 0)
      self.feed_icon:SetMaterial(self.light)
      self.feed_hdr = self.transform:Find(feed_icon_path):GetComponent(typeof(CS.GetHDRIntensity))
      self.feed_hdr:Init(self.light)
      self.feed_iconAnim:Play(RecommendShowImgAnimName[RecommendShowAnimType.Show], 0, 0)
      return
    elseif self.ctrl:GetBtnType() == BTNTYPE.GATHER then
      self.gather_anim:Play(RecommendShowAnimName[RecommendShowAnimType.Show], 0, 0)
      self.gather_icon:SetMaterial(self.light)
      self.gather_hdr = self.transform:Find(gather_icon_path):GetComponent(typeof(CS.GetHDRIntensity))
      self.gather_hdr:Init(self.light)
      self.gather_iconAnim:Play(RecommendShowImgAnimName[RecommendShowAnimType.Show], 0, 0)
      return
    elseif self.ctrl:GetBtnType() == BTNTYPE.ANIMAL then
      self.animal_anim:Play(RecommendShowAnimName[RecommendShowAnimType.Show], 0, 0)
      self.animal_icon:SetMaterial(self.light)
      self.animal_hdr = self.transform:Find(animal_icon_path):GetComponent(typeof(CS.GetHDRIntensity))
      self.animal_hdr:Init(self.light)
      self.animal_iconAnim:Play(RecommendShowImgAnimName[RecommendShowAnimType.Show], 0, 0)
      return
    end
  end
  if not DataCenter.GuideManager:InGuide() then
    local k1 = LuaEntry.DataConfig:TryGetNum("buy_show", "k1")
    if k1 >= DataCenter.BuildManager.MainLv and not self.ctrl:IsMax() then
      local num = LuaEntry.Resource:GetCntByResType(self.animalData.needResourceType)
      if num >= self.animalData.needResourceNum then
        self.isBuy = true
        self.animal_anim:Play(RecommendShowAnimName[RecommendShowAnimType.Show], 0, 0)
        self.animal_icon:SetMaterial(self.light)
        self.animal_hdr = self:AddComponent(GetHDRIntensity, animal_icon_path)
        self.animal_hdr:Init(self.light)
        self.animal_iconAnim:Play(RecommendShowImgAnimName[RecommendShowAnimType.Show], 0, 0)
      end
    end
  end
end

local function OnAnimalBeginDrag(self, eventData)
  if self.animalData ~= nil and self.animalData.unlock then
    self.curSelectState = FarmStateType.Plant
    PastureAnimalManager:GetInstance():SetSelectBuildState(FarmStateType.Plant)
    PastureAnimalManager:GetInstance():SetSelectBUuid(self.buildUuid)
    self.animal_icon.gameObject:SetActive(false)
    self.drag_item_img:LoadSprite(self.animalData.icon)
    if self.animalData.sizeX ~= nil and self.animalData.sizeY ~= nil then
      self.drag_item_img.rectTransform:Set_sizeDelta(self.animalData.sizeX, self.animalData.sizeY)
    end
    self.showDrag = true
    self.drag_item_img:SetActive(self.showDrag)
    self.drag_item_num:SetActive(false)
  end
  if self.ctrl:GetBtnType() ~= nil then
    self.animal_anim:Play(RecommendShowAnimName[RecommendShowAnimType.Default], 0, 0)
    self.animal_icon:SetMaterial(nil)
    self.animal_iconAnim:Play(RecommendShowImgAnimName[RecommendShowAnimType.Default], 0, 0)
  elseif self.isBuy then
    self.isBuy = false
    self.animal_anim:Play(RecommendShowAnimName[RecommendShowAnimType.Default], 0, 0)
    self.animal_icon:SetMaterial(nil)
    self.animal_iconAnim:Play(RecommendShowImgAnimName[RecommendShowAnimType.Default], 0, 0)
  end
end

local function OnAnimalOnDrag(self, eventData)
  if self.drag_item_img:GetActive() then
    local curPos = eventData.position
    local posV3 = Vector3.New(curPos.x, curPos.y, 0)
    self.drag_item_img.transform.position = posV3
    if self.animalData.modelName ~= nil then
      self.animator:Play(self.animalData.modelName .. "_shake", 0, 0)
    end
    if self.showDes then
      self.search_obj:SetPosition(curPos.x, curPos.y)
    end
  end
end

local function OnAnimalOnEndDrag(self, eventData)
  local curPos = eventData.position
  local posV3 = Vector3.New(curPos.x, curPos.y, 0)
  self.drag_item_img.transform.position = posV3
  local tilePos = CS.SceneManager.World:GetTouchPoint(posV3)
  local v2Pos = SceneUtils.WorldToTile(tilePos)
  local pointId = SceneUtils.TilePosToIndex(v2Pos)
  local buildData = DataCenter.BuildManager:GetBuildingDataByPointId(pointId)
  if self.animalData.modelName ~= nil then
    self.animator:Play(self.animalData.modelName .. "_shake", 0, 0)
  end
  if self.showDes then
    self.search_obj:SetPosition(curPos.x, curPos.y)
  end
  self.showDrag = false
  self.drag_item_img:SetActive(self.showDrag)
  self.animal_icon.gameObject:SetActive(true)
  self.drag_item_num:SetActive(true)
  self.curSelectState = FarmStateType.None
  if buildData ~= nil and buildData.uuid ~= nil and self.ctrl:GetPlantState() == false then
    local bUuid = buildData.uuid
    if bUuid == self.buildUuid then
      local getUuid = 0
      local queueList = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(self.buildUuid)
      if queueList ~= nil then
        table.walksort(queueList, function(leftKey, rightKey)
          return queueList[leftKey].qid < queueList[rightKey].qid
        end, function(k, v)
          if v:GetParaState() == QueueProductState.DEFAULT and v:GetQueueState() == NewQueueState.Free and getUuid == 0 then
            getUuid = v.uuid
          end
        end)
      end
      if getUuid ~= 0 then
        if self.showDes then
          self.showDes = false
          self.search_obj:SetShowState(self.showDes)
        end
        do
          local queueData = DataCenter.QueueDataManager:GetQueueByUuid(getUuid)
          self.ctrl:OnPlant(tilePos, self.animalData, queueData)
        end
      end
    end
  end
end

local function OnAnimalOnPointerDown(self, eventData)
  if self.animalData ~= nil then
    local posX = self.animal_icon.transform.position.x
    local posY = self.animal_icon.transform.position.y
    self.showDes = true
    if self.search_obj:GetActive() == false then
      self.search_obj:SetActive(true)
    end
    self.search_obj:SetShowState(self.showDes)
    self.search_obj:RefreshData(self.animalData, posX, posY, false)
  end
end

local function OnAnimalOnPointerUp(self, eventData)
  if self.showDes then
    self.showDes = false
    self.search_obj:SetShowState(self.showDes)
  end
end

local function OnFeedBeginDrag(self, eventData)
  if self.feedData ~= nil and self.feedData.unlock and self.feedData.unlock then
    self.curSelectState = FarmStateType.Feed
    PastureAnimalManager:GetInstance():SetSelectBuildState(FarmStateType.Feed)
    PastureAnimalManager:GetInstance():SetSelectBUuid(self.buildUuid)
    self.feed_icon:SetActive(false)
    self.drag_item_img:LoadSprite(self.feedData.icon)
    if self.feedData.sizeX ~= nil and self.feedData.sizeY ~= nil then
      self.drag_item_img.rectTransform:Set_sizeDelta(self.feedData.sizeX, self.feedData.sizeY)
    end
    self.showDrag = true
    self.drag_item_img:SetActive(self.showDrag)
    self.drag_item_num:SetActive(false)
  else
  end
  if self.ctrl:GetBtnType() ~= nil then
    self.feed_anim:Play(RecommendShowAnimName[RecommendShowAnimType.Default], 0, 0)
    self.feed_icon:SetMaterial(nil)
    self.feed_iconAnim:Play(RecommendShowImgAnimName[RecommendShowAnimType.Default], 0, 0)
  end
end

local function OnFeedOnDrag(self, eventData)
  if self.drag_item_img:GetActive() then
    local curPos = eventData.position
    local posV3 = Vector3.New(curPos.x, curPos.y, 0)
    self.drag_item_img.transform.position = posV3
    if self.showDes then
      self.search_obj:SetPosition(curPos.x, curPos.y)
    end
  end
end

local function OnFeedOnEndDrag(self, eventData)
  self.showDrag = false
  self.drag_item_img:SetActive(self.showDrag)
  self.feed_icon:SetActive(true)
  self.curSelectState = FarmStateType.None
  if DataCenter.GuideManager:InGuide() then
    self.ctrl:OnDragFinish()
  else
    self.ctrl:OnDragFinish(true)
  end
end

local function OnFeedOnPointerDown(self, eventData)
  if self.feedData ~= nil then
    local posX = self.feed_icon.transform.position.x
    local posY = self.feed_icon.transform.position.y
    self.showDes = true
    if self.search_obj:GetActive() == false then
      self.search_obj:SetActive(true)
    end
    self.search_obj:SetShowState(self.showDes)
    self.search_obj:RefreshData(self.feedData, posX, posY, true)
    if self.feedData.unlock then
      local curPos = eventData.position
      local posV3 = Vector3.New(curPos.x, curPos.y, 0)
      self.drag_item_img.transform.position = posV3
      self.feed_icon:SetActive(false)
      self.drag_item_img:LoadSprite(self.feedData.icon)
      if self.feedData.sizeX ~= nil and self.feedData.sizeY ~= nil then
        self.drag_item_img.rectTransform:Set_sizeDelta(self.feedData.sizeX, self.feedData.sizeY)
      end
      self.drag_item_img:SetActive(true)
      self.drag_item_num:SetActive(false)
    end
  end
end

local function OnFeedOnPointerUp(self, eventData)
  if self.showDes then
    self.showDes = false
    self.search_obj:SetShowState(self.showDes)
  end
  if self.showDrag == false then
    self.drag_item_img:SetActive(self.showDrag)
    self.feed_icon:SetActive(true)
    self.curSelectState = FarmStateType.None
  end
end

local function OnBeginDragIrrigate(self, eventData)
  if self.irrigateData.irrigateInfo and self.irrigateData.irrigateInfo.remainTimes > 0 then
    self.curSelectState = FarmStateType.Irrigate
    PastureAnimalManager:GetInstance():SetSelectBuildState(FarmStateType.Irrigate)
    PastureAnimalManager:GetInstance():SetSelectBUuid(self.buildUuid)
    self.irrigateIcon:SetActive(false)
    self.drag_item_img:LoadSprite(self.irrigateData.icon)
    self.showDrag = true
    self.drag_item_img:SetActive(self.showDrag)
    self.drag_item_num:SetActive(false)
  end
end

local function OnDragIrrigate(self, eventData)
  if self.drag_item_img:GetActive() then
    local curPos = eventData.position
    local posV3 = Vector3.New(curPos.x, curPos.y, 0)
    self.drag_item_img.transform.position = posV3
    if self.showDes then
      self.search_obj:SetPosition(curPos.x, curPos.y)
    end
  end
end

local function OnEndDragIrrigate(self, eventData)
  self.showDrag = false
  self.drag_item_img:SetActive(self.showDrag)
  self.irrigateIcon:SetActive(true)
  self.curSelectState = FarmStateType.None
  self.ctrl:OnDragFinish(true)
end

local function OnPointerDownIrrigate(self, eventData)
  if self.irrigateData ~= nil then
    local posX = self.irrigateIcon.transform.position.x
    local posY = self.irrigateIcon.transform.position.y
    self.showDes = true
    if self.search_obj:GetActive() == false then
      self.search_obj:SetActive(true)
    end
    self.search_obj:SetShowState(self.showDes)
    self.search_obj:RefreshData(self.irrigateData, posX, posY)
    if self.irrigateData.canIrrigate then
      local curPos = eventData.position
      local posV3 = Vector3.New(curPos.x, curPos.y, 0)
      self.drag_item_img.transform.position = posV3
      self.irrigateIcon:SetActive(false)
      self.drag_item_img:LoadSprite(self.irrigateData.icon)
      if self.irrigateData.sizeX ~= nil and self.irrigateData.sizeY ~= nil then
        self.drag_item_img.rectTransform:Set_sizeDelta(self.irrigateData.sizeX, self.irrigateData.sizeY)
      end
      self.drag_item_img:SetActive(true)
      self.drag_item_num:SetActive(false)
    end
  end
end

local function OnPointerUpIrrigate(self, eventData)
  if self.showDes then
    self.showDes = false
    self.search_obj:SetShowState(self.showDes)
  end
  if self.showDrag == false then
    self.drag_item_img:SetActive(self.showDrag)
    self.irrigateIcon:SetActive(true)
    self.curSelectState = FarmStateType.None
  end
end

local function OnGatherBeginDrag(self, eventData)
  if self.gatherData ~= nil and self.gatherData.unlock then
    self.curSelectState = FarmStateType.HarvestSecond
    PastureAnimalManager:GetInstance():SetSelectBuildState(FarmStateType.HarvestSecond)
    PastureAnimalManager:GetInstance():SetSelectBUuid(self.buildUuid)
    self.gather_icon.gameObject:SetActive(false)
    self.drag_item_img:LoadSprite(self.gatherData.icon)
    if self.feedData.sizeX ~= nil and self.feedData.sizeY ~= nil then
      self.drag_item_img.rectTransform:Set_sizeDelta(self.gatherData.sizeX, self.gatherData.sizeY)
    end
    if self.showDes then
      self.showDes = false
      self.search_obj:SetShowState(self.showDes)
    end
    self.showDrag = true
    self.drag_item_img:SetActive(self.showDrag)
    self.drag_item_num:SetActive(false)
  end
  if self.ctrl:GetBtnType() ~= nil then
    self.gather_anim:Play(RecommendShowAnimName[RecommendShowAnimType.Default], 0, 0)
    self.gather_icon:SetMaterial(nil)
    self.gather_iconAnim:Play(RecommendShowImgAnimName[RecommendShowAnimType.Default], 0, 0)
  end
end

local function OnGatherOnDrag(self, eventData)
  if self.drag_item_img:GetActive() then
    local curPos = eventData.position
    local posV3 = Vector3.New(curPos.x, curPos.y, 0)
    self.drag_item_img.transform.position = posV3
  end
end

local function OnGatherOnEndDrag(self, eventData)
  self.showDrag = false
  self.drag_item_img:SetActive(self.showDrag)
  self.gather_icon.gameObject:SetActive(true)
  self.curSelectState = FarmStateType.None
  self.ctrl:OnDragFinish()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshPastureUI, self.UpdateView)
  self:AddUIListener(EventId.TouchPastureAnimal, self.OnTouchAnimalCallBack)
  self:AddUIListener(EventId.SetNewAnimal, self.OnCreateAnimalCallBack)
  self:AddUIListener(EventId.AddSpeedSuccess, self.OnSpeedCallBack)
  self:AddUIListener(EventId.RefreshResourceItem, self.UpdateResource)
  self:AddUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
  self:AddUIListener(EventId.QUEUE_TIME_END, self.QueueTimeEndSignal)
  self:AddUIListener(EventId.GatherResourceItemFinish, self.OnSpeedCallBack)
  self:AddUIListener(EventId.RefreshRecommendShow, self.RefreshRecommendShowSignal)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshResourceItem, self.UpdateResource)
  self:RemoveUIListener(EventId.RefreshPastureUI, self.UpdateView)
  self:RemoveUIListener(EventId.GatherResourceItemFinish, self.OnSpeedCallBack)
  self:RemoveUIListener(EventId.TouchPastureAnimal, self.OnTouchAnimalCallBack)
  self:RemoveUIListener(EventId.SetNewAnimal, self.OnCreateAnimalCallBack)
  self:RemoveUIListener(EventId.AddSpeedSuccess, self.OnSpeedCallBack)
  self:RemoveUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
  self:RemoveUIListener(EventId.QUEUE_TIME_END, self.QueueTimeEndSignal)
  self:RemoveUIListener(EventId.RefreshRecommendShow, self.RefreshRecommendShowSignal)
end

local function UpdateResource(self)
  self:SetData()
end

local function OnSpeedCallBack(self)
  self:SetData()
end

local function OnCreateAnimalCallBack(self)
  self.ctrl:SetPlantState(false)
  self:SetData()
end

local function OnTouchAnimalCallBack(self, data)
  local qUuid = 0
  if data:ContainsKey("queueUuid") then
    qUuid = data:GetLong("queueUuid")
  end
  local posX = 0
  local posY = 0
  local posZ = 0
  if data:ContainsKey("posX") then
    posX = data:GetInt("posX")
  end
  if data:ContainsKey("posY") then
    posY = data:GetInt("posY")
  end
  if data:ContainsKey("posZ") then
    posZ = data:GetInt("posZ")
  end
  local pos = Vector3.New(posX, posY, posZ)
  if self.curSelectState == FarmStateType.Feed then
    local queueData = DataCenter.QueueDataManager:GetQueueByUuid(qUuid)
    if queueData ~= nil and queueData.funcUuid == self.buildUuid and (queueData.type == NewQueueType.SandWormBarn or queueData.type == NewQueueType.CattleBarn or queueData.type == NewQueueType.OstrichBarn) and (queueData:GetParaState() == QueueProductState.DEFAULT and queueData:GetQueueState() == NewQueueState.Finish or queueData:GetParaState() == QueueProductState.PASTURE_MATURE and queueData:GetQueueState() == NewQueueState.Free) then
      local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.buildUuid)
      if buildData ~= nil then
        self:OnFeedOnPointerUp()
        self.ctrl:OnFeedAnimal(pos, self.feedData, queueData)
      end
    end
  elseif self.curSelectState == FarmStateType.Irrigate then
    local queueData = DataCenter.QueueDataManager:GetQueueByUuid(qUuid)
    if queueData ~= nil and queueData.funcUuid == self.buildUuid and (queueData.type == NewQueueType.SandWormBarn or queueData.type == NewQueueType.CattleBarn or queueData.type == NewQueueType.OstrichBarn) and not queueData:CheckIfIrrigated() and queueData:GetQueueState() == NewQueueState.Work then
      local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.buildUuid)
      if buildData ~= nil then
        self:OnPointerUpIrrigate()
        self.ctrl:OnIrrigateAnimal(pos, self.irrigateData, queueData)
      end
    end
  elseif self.curSelectState == FarmStateType.HarvestSecond then
    local queueData = DataCenter.QueueDataManager:GetQueueByUuid(qUuid)
    if queueData ~= nil and queueData.funcUuid == self.buildUuid and (queueData.type == NewQueueType.SandWormBarn or queueData.type == NewQueueType.CattleBarn or queueData.type == NewQueueType.OstrichBarn) and queueData:GetParaState() == QueueProductState.PASTURE_MATURE and queueData:GetQueueState() == NewQueueState.Finish then
      local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.buildUuid)
      if buildData ~= nil then
        self.ctrl:OnGatherProduct(pos, self.gatherData, queueData)
      end
    end
  end
end

local function CheckGuide(self)
  local guideType = DataCenter.GuideManager:GetGuideType()
  if guideType == GuideType.PlantAnimal then
    local para2 = DataCenter.GuideManager:GetGuideTemplateParam("para2")
    if para2 ~= nil and para2 ~= "" then
      local param = {}
      param.pointList = {}
      local startParam = {}
      startParam.pointType = PositionType.Screen
      startParam.pointPosition = self:GetGuidePosition(tonumber(para2))
      table.insert(param.pointList, startParam)
      local endParam = {}
      endParam.pointType = PositionType.Screen
      endParam.pointPosition = self:GetGuideEndPosition(tonumber(para2))
      table.insert(param.pointList, endParam)
      param.arrowtype = tonumber(DataCenter.GuideManager:GetGuideTemplateParam("arrowtype"))
      param.arrowdirection = tonumber(DataCenter.GuideManager:GetGuideTemplateParam("arrowdirection"))
      param.notUseEndFlag = true
      local image = self:GetGuideIcon(tonumber(para2))
      if image ~= nil then
        param.sprite = image:GetImage()
        param.spriteSize = image:GetSizeDelta()
      end
      if startParam.pointPosition ~= nil and endParam.pointPosition ~= nil then
        DataCenter.GuideManager:SetCompleteNeedParam(param)
      end
    end
    EventManager:GetInstance():Broadcast(EventId.GuideNoOpenUI, true)
    self.needResetOpen = true
  end
end

local function GetGuidePosition(self, stateType)
  if stateType == FarmStateType.Plant then
    return self.animal_icon.transform.position
  elseif stateType == FarmStateType.Feed then
    return self.feed_icon.transform.position
  elseif stateType == FarmStateType.HarvestSecond then
    return self.gather_icon.transform.position
  end
end

local function GetGuideIcon(self, stateType)
  if stateType == FarmStateType.Plant then
    return self.animal_icon
  elseif stateType == FarmStateType.Feed then
    return self.feed_icon
  elseif stateType == FarmStateType.HarvestSecond then
    return self.gather_icon
  end
end

local function RefreshGuideSignal(self)
  self:CheckGuide()
end

local function GetGuideEndPosition(self, stateType)
  local queueList = DataCenter.QueueDataManager:GetQueueListByBuildUuidForPasture(self.ctrl.buildUuid)
  if queueList ~= nil then
    if stateType == FarmStateType.Plant then
      return self.tips_obj_ani.transform.position
    elseif stateType == FarmStateType.Feed then
      for k, v in pairs(queueList) do
        if v:GetParaState() == QueueProductState.DEFAULT and v:GetQueueState() == NewQueueState.Finish or v:GetParaState() == QueueProductState.PASTURE_MATURE and v:GetQueueState() == NewQueueState.Free then
          return CS.SceneManager.World:WorldToScreenPoint(PastureAnimalManager:GetInstance():GetAnimPos(v.uuid))
        end
      end
    elseif stateType == FarmStateType.HarvestSecond then
      for k, v in pairs(queueList) do
        if v:GetParaState() == QueueProductState.PASTURE_MATURE and v:GetQueueState() == NewQueueState.Finish then
          return CS.SceneManager.World:WorldToScreenPoint(PastureAnimalManager:GetInstance():GetAnimPos(v.uuid))
        end
      end
    end
  end
end

local function CheckRecommend(self)
  if DataCenter.RecommendShowManager:GetPanelShowPara(RecommendShowType.FeedOstrich) ~= nil then
    local waitAnimType = UIGuideMoveArrowNeedWaitType.No
    local recommendParam = DataCenter.RecommendShowManager:GetRecommendShowParam(RecommendShowType.FeedOstrich)
    if recommendParam ~= nil then
      waitAnimType = recommendParam.waitAnimType
      recommendParam.waitAnimType = UIGuideMoveArrowNeedWaitType.No
    end
    local param = {}
    param.pointList = {}
    local startParam = {}
    startParam.pointType = PositionType.Screen
    startParam.pointPosition = self:GetGuidePosition(FarmStateType.Feed)
    table.insert(param.pointList, startParam)
    local endParam = {}
    endParam.pointType = PositionType.Screen
    endParam.pointPosition = self:GetGuideEndPosition(FarmStateType.Feed)
    table.insert(param.pointList, endParam)
    param.arrowtype = GuideArrowStyle.Finger
    param.arrowdirection = GuideArrowDirection.LeftDown
    param.notUseEndFlag = true
    local image = self:GetGuideIcon(FarmStateType.Feed)
    if image ~= nil then
      param.sprite = image:GetImage()
      param.spriteSize = image:GetSizeDelta()
    end
    param.waitAnimType = waitAnimType
    param.isRecommend = true
    if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideMoveArrow) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideMoveArrow, {anim = false, playEffect = false}, param)
    else
      EventManager:GetInstance():Broadcast(EventId.RefreshGuideAnim, param)
    end
  end
end

local function OnBtnClick(self)
end

local function QueueTimeEndSignal(self, queueType)
  if queueType == NewQueueType.OstrichBarn or queueType == NewQueueType.CattleBarn or queueType == NewQueueType.SandWormBarn then
    self:SetData()
    self.ctrl:ShowFeedQueueTime()
  end
end

local function RefreshRecommendShowSignal(self)
  local info = DataCenter.BuildManager:GetBuildingDataByUuid(self.buildUuid)
  if info ~= nil then
    local pointId = info.pointId
    local worldPos = SceneUtils.TileIndexToWorld(pointId)
    local pos = CS.SceneManager.World:WorldToScreenPoint(worldPos)
    self.tips_obj_ani.transform.position = pos
  end
  self:CheckRecommend()
end

UIPastureView.OnCreate = OnCreate
UIPastureView.OnDestroy = OnDestroy
UIPastureView.OnEnable = OnEnable
UIPastureView.OnDisable = OnDisable
UIPastureView.InitInfo = InitInfo
UIPastureView.SetData = SetData
UIPastureView.UpdateView = UpdateView
UIPastureView.OnAddListener = OnAddListener
UIPastureView.OnRemoveListener = OnRemoveListener
UIPastureView.OnGatherOnEndDrag = OnGatherOnEndDrag
UIPastureView.OnGatherOnDrag = OnGatherOnDrag
UIPastureView.OnGatherBeginDrag = OnGatherBeginDrag
UIPastureView.OnAnimalOnPointerUp = OnAnimalOnPointerUp
UIPastureView.OnAnimalOnPointerDown = OnAnimalOnPointerDown
UIPastureView.OnAnimalBeginDrag = OnAnimalBeginDrag
UIPastureView.OnAnimalOnDrag = OnAnimalOnDrag
UIPastureView.OnAnimalOnEndDrag = OnAnimalOnEndDrag
UIPastureView.OnFeedOnPointerDown = OnFeedOnPointerDown
UIPastureView.OnFeedOnPointerUp = OnFeedOnPointerUp
UIPastureView.OnFeedBeginDrag = OnFeedBeginDrag
UIPastureView.OnFeedOnEndDrag = OnFeedOnEndDrag
UIPastureView.OnFeedOnDrag = OnFeedOnDrag
UIPastureView.OnTouchAnimalCallBack = OnTouchAnimalCallBack
UIPastureView.OnCreateAnimalCallBack = OnCreateAnimalCallBack
UIPastureView.OnSpeedCallBack = OnSpeedCallBack
UIPastureView.UpdateResource = UpdateResource
UIPastureView.CheckGuide = CheckGuide
UIPastureView.GetGuidePosition = GetGuidePosition
UIPastureView.RefreshGuideSignal = RefreshGuideSignal
UIPastureView.GetGuideEndPosition = GetGuideEndPosition
UIPastureView.CheckRecommend = CheckRecommend
UIPastureView.OnBtnClick = OnBtnClick
UIPastureView.QueueTimeEndSignal = QueueTimeEndSignal
UIPastureView.GetGuideIcon = GetGuideIcon
UIPastureView.OnBeginDragIrrigate = OnBeginDragIrrigate
UIPastureView.OnDragIrrigate = OnDragIrrigate
UIPastureView.OnEndDragIrrigate = OnEndDragIrrigate
UIPastureView.OnPointerDownIrrigate = OnPointerDownIrrigate
UIPastureView.OnPointerUpIrrigate = OnPointerUpIrrigate
UIPastureView.RefreshRecommendShowSignal = RefreshRecommendShowSignal
return UIPastureView
