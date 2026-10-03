local FactoryStateItem = BaseClass("FactoryStateItem", UIBaseContainer)
local base = UIBaseContainer
local this_path = ""
local Localization = CS.GameEntry.Localization
local working_path = "AddSpeedBtn"
local slider_img_path = "AddSpeedBtn/Slider"
local slider_des_path = "AddSpeedBtn/cost_time_text"
local item_num_text_path = "AddSpeedBtn/goldIcon/costTxt"
local item_free_text_path = "AddSpeedBtn/freeTxt"
local gold_icon_path = "AddSpeedBtn/goldIcon"
local speed_btn_path = "AddSpeedBtn/IconSprite"
local free_path = "freeObj"
local free_text_path = "freeObj/DesTxt"
local full_path = "pauseObj"
local no_space_path = "pauseObj/noSpaceObj"
local no_space_text_path = "pauseObj/noSpaceObj/noSpaceTxt"
local SliderLength = 300

local function OnCreate(self)
  base.OnCreate(self)
  self.working = self:AddComponent(UIBaseContainer, working_path)
  self.slider_img = self:AddComponent(UISlider, slider_img_path)
  self.slider_des = self:AddComponent(UIText, slider_des_path)
  self.item_num_text = self:AddComponent(UIText, item_num_text_path)
  self.item_free_text = self:AddComponent(UIText, item_free_text_path)
  self.speed_btn = self:AddComponent(UIButton, speed_btn_path)
  self.gold_icon = self:AddComponent(UIImage, gold_icon_path)
  self.speed_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnSpeedUpClick()
  end)
  self.free = self:AddComponent(UIBaseContainer, free_path)
  self.free_text = self:AddComponent(UIText, free_text_path)
  self.free_text:SetLocalText(GameDialogDefine.QUEUE_FREE)
  self.full = self:AddComponent(UIBaseContainer, full_path)
  self.no_space = self:AddComponent(UIBaseContainer, no_space_path)
  self.no_space_text = self:AddComponent(UIText, no_space_text_path)
  self.no_space_text:SetLocalText(128013)
  self.lastCurTime = 0
  self.sliderUpdate = false
end

local function OnDestroy(self)
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnSpeedUpClick(self)
  local functionTemplate = DataCenter.FactoryDataManager:GetFactoryTemplate(self.data.product)
  if functionTemplate then
    if self.view:CheckGuideFree() then
      DataCenter.GuideManager:SendSaveGuideMessage(FactoryFirstFreeSpeed, "")
      SFSNetwork.SendMessage(MsgDefines.FactoryAddSpeed, {
        qUUID = self.data.factoryUid,
        isGold = IsGold.UseGold,
        index = self.data.index,
        isFree = true
      })
    else
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local leftTime = math.ceil(self.data.endTime - curTime) / 1000.0
      local gold = LuaEntry.Player.gold
      local cost = CommonUtil.GetTimeDiamondCost(leftTime, true)
      if gold < cost then
        GoToUtil.GotoPayTips(cost)
      else
        UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.BuyUseDialog, Localization:GetString(GameDialogDefine.USE_GOLF_TIP_DES), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          SFSNetwork.SendMessage(MsgDefines.FactoryAddSpeed, {
            qUUID = self.data.factoryUid,
            isGold = IsGold.UseGold,
            index = self.data.index,
            isFree = false
          })
          local products = functionTemplate.productList
          if CS.SceneManager.IsInPVE() then
            local battleLevel = DataCenter.BattleLevel
            local srcPos = self.transform.position
            table.walk(products, function(_, v)
              local rewardType = DataCenter.FactoryDataManager:FactoryProductTypeToRewardType(v.type, v.itemId)
              local targetPos = battleLevel:GetRewardFlyPos(rewardType)
              local pic = DataCenter.FactoryDataManager:GetProductShowIcon(v)
              local tmp = DataCenter.RewardManager:GetRewardNumsInPveScene(v.num)
              UIUtil.DoJumpFly(pic, tmp, srcPos, targetPos)
            end)
          else
            table.walk(products, function(_, v)
              local rewardType = DataCenter.FactoryDataManager:FactoryProductTypeToRewardType(v.type, v.itemId)
              local pic = DataCenter.FactoryDataManager:GetProductShowIcon(v)
              local str = tostring(self.order) .. ";" .. tostring(v.itemId)
              UIUtil.DoFly(tonumber(rewardType), v.num, pic, self.transform.position, Vector3.New(0, 0, 0), nil, nil, nil, true)
              EventManager:GetInstance():Broadcast(EventId.ShowCapacity, str)
            end)
          end
        end, function()
        end)
      end
    end
  end
end

local function SetData(self, param)
  self.data = param
  self.sliderUpdate = false
  self.free:SetActive(false)
  self.full:SetActive(false)
  self.working:SetActive(false)
  if self.data.state == FactoryWorkState.Free then
    if self.data.index == 0 then
      self.free:SetActive(true)
    end
  elseif self.data.state == FactoryWorkState.Full then
    if 0 < self.data.product then
      self.full:SetActive(true)
    elseif self.data.index == 0 then
      self.free:SetActive(true)
    end
  else
    self.working:SetActive(true)
    self.sliderUpdate = true
  end
  self:Update()
end

local function Update(self)
  if self.sliderUpdate then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local changeTime = self.data.endTime - curTime
    if 0 < changeTime and 0 < self.data.startTime then
      local totalTime = self.data.endTime - self.data.startTime
      local tempTimeSec = math.ceil(changeTime / 1000)
      if tempTimeSec ~= self.lastTime then
        self.lastTime = tempTimeSec
        local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(changeTime)
        self.slider_des:SetText(tempTimeValue)
        if self.view:CheckGuideFree() then
          self.item_free_text:SetLocalText(GameDialogDefine.FREE)
          self.item_free_text:SetActive(true)
          self.gold_icon:SetActive(false)
        else
          local cost = CommonUtil.GetTimeDiamondCost(tempTimeSec, true)
          self.item_num_text:SetText(cost)
          self.item_free_text:SetActive(false)
          self.gold_icon:SetActive(true)
        end
      end
      local tempValue = 1 - changeTime / totalTime
      if TimeBarUtil.CheckIsNeedChangeBar(changeTime, self.data.endTime - self.lastCurTime, totalTime, SliderLength) then
        self.lastCurTime = curTime
        self.slider_img:SetValue(tempValue)
      end
    elseif changeTime <= 0 then
      self.sliderUpdate = false
    end
  end
end

FactoryStateItem.OnDestroy = OnDestroy
FactoryStateItem.OnCreate = OnCreate
FactoryStateItem.OnEnable = OnEnable
FactoryStateItem.OnDisable = OnDisable
FactoryStateItem.OnSpeedUpClick = OnSpeedUpClick
FactoryStateItem.SetData = SetData
FactoryStateItem.Update = Update
return FactoryStateItem
