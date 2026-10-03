local PveTriggerPointBubble = BaseClass("PveTriggerPointBubble")
local Resource = CS.GameEntry.Resource
local PveTriggerPointBubbleNeedCell = require("Scene.PVEBattleLevel.PveTriggerPointBubbleNeedCell")
local Localization = CS.GameEntry.Localization
local Const = require("Scene.PVEBattleLevel.Const")
local touch_collider_path = "BubbleAnim/BubbleRotation/BubbleTrigger"
local cd_touch_collider_path = "BubbleAnim/BubbleRotation/CDObj/CDCost/BubbleTriggerCD"
local bubble_anim_path = "BubbleAnim"
local progress_path = "CollectGarbageUI"
local cost_text_path = "BubbleAnim/BubbleRotation/CostDes"
local cost_bg_path = "BubbleAnim/BubbleRotation/CostBg"
local cost_icon_path = "BubbleAnim/BubbleRotation/CostIcon"
local cost_icon_1_path = "BubbleAnim/BubbleRotation/CostIcon1"
local bubble_rotation_path = "BubbleAnim/BubbleRotation"
local need_go_path = "BubbleAnim/BubbleRotation/NeedGo"
local cd_path = "BubbleAnim/BubbleRotation/CDObj"
local cd_cost_path = "CDCost"
local cd_cost_icon_path = "CDCostIcon"
local cd_cost_num_path = "CDCostText"
local cd_time_path = "CDTime"
local cd_time_title_path = "CDTitle"
local AnimName = {
  Enter = "EnterBubble",
  Hide = "HideBubble",
  Normal = "NormalBubble",
  Default = "Default",
  ClickBubble = "ClickBubble",
  Stop = "StopBubble",
  Interact = "InteractBubble"
}

function PveTriggerPointBubble:__init(param)
  self:DataDefine()
  self.param = param
  self:OnPlayerMoveSignal(DataCenter.BattleLevel:GetPosition())
end

function PveTriggerPointBubble:Destroy()
  self:ComponentDestroy()
  self:DataDestroy()
  self.transform = nil
  self.gameObject = nil
end

function PveTriggerPointBubble:OnCreate()
  if self.req == nil then
    local prefabPath = string.format(UIAssets.PveTriggerPointBubble, table.count(self.param.need))
    if self.param.triggerData:ISCollectRewardMoreThanOneTime() then
      prefabPath = string.format(UIAssets.PveTriggerPointBubble, 2000)
    end
    self.req = Resource:InstantiateAsync(prefabPath)
    self.req:completed("+", function()
      self.gameObject = self.req.gameObject
      self.transform = self.req.gameObject.transform
      self:ComponentDefine()
      self:RefreshCameraRotation(self.param.rotation)
      self:ReInit()
    end)
  elseif self.gameObject ~= nil then
    self.gameObject:SetActive(true)
    if self.enterEnableBubble ~= true then
      self.enterEnableBubble = true
      self:RefreshCameraRotation(self.param.rotation)
      if self.param.isBubbleSubmit then
        self:PlayAnim(AnimName.Enter)
        self:AddTouchTrigger()
        self.touchBubble.gameObject:SetActive(true)
      end
    end
  end
end

function PveTriggerPointBubble:ComponentDefine()
  self.bubble_anim = self.transform:Find(bubble_anim_path):GetComponent(typeof(CS.SimpleAnimation))
  self.progress = self.transform:Find(progress_path)
  if self.progress ~= nil then
    self.icon_Circle = self.progress.transform:GetComponent(typeof(CS.ChangeSceneCircleSlider))
    self.time_text = self.progress.transform:Find("PosGo/TimeText"):GetComponent(typeof(CS.SuperTextMesh))
    self.progress.gameObject:SetActive(false)
  end
  local costBg = self.transform:Find(cost_bg_path)
  if costBg ~= nil then
    self.cost_bg = costBg:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    self.cost_bg:LoadSprite("Assets/Main/Sprites/Guide/UIlevel_Stamina_blue")
  end
  local costIcon = self.transform:Find(cost_icon_path)
  if costIcon then
    self.cost_icon = costIcon:GetComponent(typeof(CS.SpriteMeshRenderer))
  end
  local costIcon1 = self.transform:Find(cost_icon_1_path)
  if costIcon1 then
    self.cost_icon1 = costIcon1:GetComponent(typeof(CS.SpriteMeshRenderer))
    self.cost_icon1.gameObject:SetActive(false)
  end
  local costGo = self.transform:Find(cost_text_path)
  if costGo ~= nil then
    self.cost_text = costGo:GetComponent(typeof(CS.SuperTextMesh))
  end
  local cdGo = self.transform:Find(cd_path)
  if cdGo ~= nil then
    self.cd = cdGo.gameObject
    self.cd:SetActive(false)
    self.cd_cost = self.cd.transform:Find(cd_cost_path).gameObject
    self.cd_cost_icon = self.cd_cost.transform:Find(cd_cost_icon_path):GetComponent(typeof(CS.SpriteMeshRenderer))
    self.cd_cost_num = self.cd_cost.transform:Find(cd_cost_num_path):GetComponent(typeof(CS.SuperTextMesh))
    self.cd_time = self.cd.transform:Find(cd_time_path):GetComponent(typeof(CS.SuperTextMesh))
    self.cd_time_title = self.cd.transform:Find(cd_time_title_path):GetComponent(typeof(CS.SuperTextMesh))
    self.cd_time_title.text = Localization:GetString("134016")
  end
  self.bubble_rotation = self.transform:Find(bubble_rotation_path)
  self.need_go = self.transform:Find(need_go_path)
  self.cell = {}
  if self.need_go ~= nil then
    local childCnt = self.need_go.childCount
    for i = 0, childCnt - 1 do
      local child = self.need_go:GetChild(i)
      local cell = PveTriggerPointBubbleNeedCell.New()
      cell:OnCreate(child)
      self.cell[i + 1] = cell
    end
  end
  
  function self.time_action()
    self:TimerAction()
  end
end

function PveTriggerPointBubble:ComponentDestroy()
  self.cell = {}
  self.bubble_anim = nil
  self.cost_text = nil
  self.cost_bg = nil
  self:RemoveTouchTrigger()
  self.gameObject = nil
  self.transform = nil
  self.time_action = nil
  self:DeleteRefreshTimer()
end

function PveTriggerPointBubble:DataDefine()
  self.req = nil
  self.gameObject = nil
  self.transform = nil
  self.param = nil
  self.enough = nil
  self.cell = {}
  self.enterEnableBubble = nil
  self.viewVisible = false
  
  function self.hide_timer_callback()
    self:HideTimerCallBack()
  end
  
  function self.hide_anim_timer_callback()
    self:HideAnimTimerCallBack()
  end
end

function PveTriggerPointBubble:DataDestroy()
  self:RemoveHideTimer()
  self:RemoveHideAnimTimer()
  self.viewVisible = false
  self.enterEnableBubble = nil
  if self.req ~= nil then
    self.req:Destroy()
    self.req = nil
  end
  self.param = nil
  self.enough = nil
  self.hide_timer_callback = nil
  self.hide_anim_timer_callback = nil
end

function PveTriggerPointBubble:ReInit()
  self.transform.position = self.param.pos
  if self.cost_text ~= nil then
    if self.param.needStaminaCount > 0 then
      self.cost_text.text = self.param.needStaminaCount
    else
      self.cost_text.text = ""
    end
  end
  self:PlayAnim(AnimName.Default)
  self.enterEnableBubble = false
  self:StopCollectAnimation()
  self:RefreshStamina()
  if self.param.triggerData:IsTypeShowModel() then
    self:RefreshType1000Trigger()
    self:DeleteRefreshTimer()
  elseif self.param.triggerData:ISCollectRewardMoreThanOneTime() then
    self:AddRefreshTimer()
    self:RefreshType2000Trigger(true)
  elseif self.param.triggerData:IsTypeGainBuff() then
    self:RefreshTypeGainBuffTrigger()
    self:DeleteRefreshTimer()
  else
    self:DeleteRefreshTimer()
  end
  for k, v in ipairs(self.param.need) do
    if self.cell[k] ~= nil then
      local param = {}
      param.needType = v.needType
      param.needId = v.needId
      param.needCount = v.needCount
      param.triggerId = self.param.triggerData.triggerId
      param.level = DataCenter.BattleLevel.levelId
      param.index = k
      param.needShowNum = not self.param.triggerData:NeedOpenTriggerItemBuyPanel()
      self.cell[k]:ReInit(param)
    end
  end
  self:CheckVisible()
end

function PveTriggerPointBubble:RemoveTouchTrigger()
  if self.touchBubble ~= nil then
    self.touchBubble.onPointerClick = nil
    self.touchBubble = nil
  end
  if self.cdTouchBubble ~= nil then
    self.cdTouchBubble.onPointerClick = nil
    self.cdTouchBubble = nil
  end
end

function PveTriggerPointBubble:AddTouchTrigger()
  if self.touchBubble == nil then
    self.touchBubble = self.transform:Find(touch_collider_path):GetComponent(typeof(CS.UIEventTrigger))
    if self.touchBubble ~= nil then
      function self.touchBubble.onPointerClick()
        self:OnTouchBubbleClick()
      end
    end
  end
  if self.cdTouchBubble == nil then
    local cdTouch = self.transform:Find(cd_touch_collider_path)
    if cdTouch ~= nil then
      self.cdTouchBubble = cdTouch:GetComponent(typeof(CS.UIEventTrigger))
      if self.cdTouchBubble ~= nil then
        function self.cdTouchBubble.onPointerClick()
          self:OnTouchBubbleClick()
        end
      end
    end
  end
end

function PveTriggerPointBubble:ShowCollectAnimation()
  if self.progress == nil or self.isOnInteract then
    return
  end
  self.isOnInteract = true
  self.bubble_anim.gameObject:SetActive(false)
  self.progress.gameObject:SetActive(true)
  self.startTime = math.floor(UITimeManager:GetInstance():GetServerTime())
  local gapTime = self.param.triggerData.config.animationTime or Const.Interact_time
  self.endTime = self.startTime + gapTime
  if self.param.needStaminaCount > 1 then
    self.endTime = self.endTime - 200
  end
  self.icon_Circle:Init(self.startTime, self.endTime)
  self:AddHideTimer(gapTime / 1000)
end

function PveTriggerPointBubble:StopCollectAnimation()
  if self.progress == nil then
    return
  end
  self.isOnInteract = false
  self.bubble_anim.gameObject:SetActive(true)
  self.progress.gameObject:SetActive(false)
end

function PveTriggerPointBubble:DoTouchBubbleClick()
  self:PlayAnim(AnimName.ClickBubble)
  if self.param.triggerData:NeedOpenTriggerItemBuyPanel() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPveTriggerItemBuy, {anim = true}, self.param.triggerData)
  elseif self.param.triggerData:ISPVEFactory() then
    local battle = DataCenter.BattleLevel
    local data = battle:GetPveTriggerBuildingInfo(self.param.triggerData.triggerId)
    if data == nil then
      local param = {}
      param.trigger = self.param.triggerData.triggerId
      param.level = battle.levelId
      SFSNetwork.SendMessage(MsgDefines.UpgradeTriggerBuilding, param)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIFactory, data.uuid)
    end
  elseif self.enough then
    if self.param.isBubbleSubmit then
      self.param.triggerData:SetCanSubmit(true)
    end
    if self.param.triggerData:ISCollectRewardMoreThanOneTime() then
      self:DoClickType2000Bubble()
      return
    end
    if self.param.triggerData:IsTypeHealArmy() and not DataCenter.BattleLevel:CanHealArmy() then
      UIUtil.ShowSingleTip(Localization:GetString("339002"))
      return
    end
    if self.param.triggerData:IsTypeBubbleSubmit() then
      if self.param.triggerData:IsBubbleNeedFull() then
        local battle = DataCenter.BattleLevel
        if battle then
          local reward = battle:GetTriggerReward(self.param.triggerData.triggerId)
          local resourceItemNum = 0
          if reward ~= nil then
            table.walk(reward, function(_, v)
              if v.type == RewardType.RESOURCE_ITEM then
                resourceItemNum = resourceItemNum + v.value.num
              end
            end)
          end
          if 0 < resourceItemNum and DataCenter.ResourceItemDataManager:CheckIsStorageFull(resourceItemNum) then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityFull)
            self.param.triggerData:SetCanSubmit(false)
            return
          end
          local result = battle:DoTriggerAnimation(self.param.triggerData, 1)
          if result > Const.PlayerInteractCode.InteractCode_Fail then
            if result == Const.PlayerInteractCode.InteractCode_OK then
              self:ShowHighlightItem()
            end
            self:ShowCollectAnimation()
            return
          end
          DataCenter.BattleLevel:DoTrigger(self.param.triggerData)
        end
      else
        UIUtil.ShowTipsId(tonumber(GameDialogDefine.NO_ITEM))
      end
    end
  else
    UIUtil.ShowTipsId(GameDialogDefine.LACK_PVE_STAMINA)
  end
end

function PveTriggerPointBubble:OnTouchBubbleClick()
  local battleLevel = DataCenter.BattleLevel
  if battleLevel ~= nil then
    if battleLevel:HasBuffByType(PveBuffType.AttackAnim) then
      UIUtil.ShowTipsId(372361)
      return
    end
    if battleLevel:HasBuffByType(PveBuffType.Stun) then
      UIUtil.ShowTipsId(338000)
      return
    end
    battleLevel:DisableJoystick()
    battleLevel:EnableJoystick()
  end
  if self.param.triggerData:ISPVEFactory() then
    self:DoTouchBubbleClick()
  elseif not self.isOnInteract and battleLevel ~= nil then
    if battleLevel:GetTriggerReward(self.param.triggerData.triggerId) then
      self:DoTouchBubbleClick()
    else
      local param = {}
      param.trigger = self.param.triggerData.triggerId
      param.level = battleLevel.levelId
      SFSNetwork.SendMessage(MsgDefines.GetTriggerReward, param)
    end
  end
  local needParam = {}
  needParam.click = true
  DataCenter.GuideManager:SetCompleteNeedParam(needParam)
  DataCenter.GuideManager:CheckGuideComplete()
end

function PveTriggerPointBubble:ShowHighlightItem()
  self.param.triggerData:ShowHighlightItem()
end

function PveTriggerPointBubble:HideHighlightItem()
  self.param.triggerData:HideHighlightItem()
end

function PveTriggerPointBubble:SetVisible(visible)
  if self.param.visible ~= visible then
    self.param.visible = visible
    self:CheckVisible()
  end
end

function PveTriggerPointBubble:RefreshCameraRotation(rotation)
  self.param.rotation = rotation
  if self:GetTrueVisible() and self.transform ~= nil then
    self.bubble_rotation.transform.rotation = rotation
  end
end

function PveTriggerPointBubble:RefreshStamina()
  if self.param.needStaminaCount > 0 and self.cost_bg ~= nil then
    local enough = DataCenter.BattleLevel:IsPveStaminaEnough(self.param.needStaminaCount)
    if self.cost_icon ~= nil then
      self.cost_icon.gameObject:SetActive(true)
      self.cost_icon:LoadSprite(Const.EnenryIconPath)
    end
    if self.cost_icon1 ~= nil then
      self.cost_icon1.gameObject:SetActive(false)
    end
    if self.enough ~= enough then
      self.enough = enough
      if enough then
        self.cost_bg:LoadSprite("Assets/Main/Sprites/Guide/UIlevel_Stamina_blue")
      else
        self.cost_bg:LoadSprite("Assets/Main/Sprites/Guide/UIlevel_Stamina_red")
      end
    end
  else
    self.enough = true
  end
end

function PveTriggerPointBubble:RefreshType1000Trigger()
  if self.param.needStaminaCount == 0 and self.cost_icon ~= nil and self.cost_icon1 ~= nil then
    local para1 = self.param.triggerData.config.bubbleIcon
    local para2 = self.param.triggerData.config.bubbleItemIcon
    local str = ""
    if not string.IsNullOrEmpty(para2) then
      if string.contains(para2, "/", true) then
        str = para2
      else
        str = string.format(LoadPath.ItemPath, para2)
      end
    elseif not string.IsNullOrEmpty(para1) then
      if string.contains(para1, "/", true) then
        str = para1
      else
        str = string.format(LoadPath.ItemPath, para1)
      end
    else
      str = string.format(LoadPath.CommonNewPath, "Common_icon_giftbag")
    end
    self.cost_icon1:LoadSprite(str)
    self.cost_icon.gameObject:SetActive(false)
    self.cost_icon1.gameObject:SetActive(true)
  end
end

function PveTriggerPointBubble:Click2000Trigger()
  if self.param.triggerData:ISCollectRewardMoreThanOneTime() then
    local distance = Vector3.Distance(DataCenter.BattleLevel:GetPosition(), self.param.pos)
    if distance <= self.param.bubbleShowRange then
      local battleLevel = DataCenter.BattleLevel
      if battleLevel ~= nil then
        battleLevel:DisableJoystick()
        battleLevel:EnableJoystick()
      end
    end
  end
end

function PveTriggerPointBubble:GetSpeedUpTypeAndCost()
  if self.param.triggerData:ISCollectRewardMoreThanOneTime() then
    local time = self.param.triggerData:GetCollectRewardMoreThanOneTimeCollCollectTime()
    local now = UITimeManager:GetInstance():GetServerTime()
    local leftTime = time - now
    local cost = 0
    if 0 < leftTime then
      if self.param.triggerData.config.speedUpCostType == Const.TriggerClearCDType.TriggerClearCDType_Diamond then
        cost = CommonUtil.GetTimeDiamondCost(leftTime / 1000)
      elseif self.param.triggerData.config.speedUpCostType == Const.TriggerClearCDType.TriggerClearCDType_Energy then
        local total = self.param.triggerData.config.collectTimeGap * 1000
        cost = math.ceil(self.param.triggerData.config.speedUpCostValue * leftTime / total)
        cost = math.min(cost, self.param.triggerData.config.speedUpCostValue)
      end
      cost = math.max(cost, 1)
    end
    return self.param.triggerData.config.speedUpCostType, cost
  end
  return nil
end

function PveTriggerPointBubble:DoClickType2000Bubble()
  if not self.param.triggerData:ISCollectRewardMoreThanOneTime() then
    return
  end
  if self.param.triggerData:ISCollectRewardMoreThanOneTimeAllComplete() then
    DataCenter.BattleLevel:DoTrigger(self.param.triggerData)
    return
  end
  local time = self.param.triggerData:GetCollectRewardMoreThanOneTimeCollCollectTime()
  local now = UITimeManager:GetInstance():GetServerTime()
  local costStamina = time > now
  if not self.param.triggerData:Is2000TypeCanSpeedUp() and costStamina then
    return
  end
  if costStamina then
    local function DoClear()
      local param = {}
      
      local battle = DataCenter.BattleLevel
      param.trigger = self.param.triggerData.triggerId
      param.level = battle.levelId
      SFSNetwork.SendMessage(MsgDefines.ClearPVETriggerRewardCD, param)
    end
    
    local type, cost = self:GetSpeedUpTypeAndCost()
    if type == Const.TriggerClearCDType.TriggerClearCDType_Diamond then
      if cost > LuaEntry.Player.gold then
        GoToUtil.GotoPayTips(cost)
      else
        UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.BuyUseDialog, Localization:GetString(GameDialogDefine.USE_GOLF_TIP_DES), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          DoClear()
        end, function()
        end)
      end
    elseif type == Const.TriggerClearCDType.TriggerClearCDType_Energy then
      do
        local curNum = LuaEntry.Player:GetCurPveStamina()
        if cost > curNum then
          UIUtil.ShowTipsId(GameDialogDefine.LACK_PVE_STAMINA)
        else
          UIUtil.ShowMessage(Localization:GetString("134017"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, DoClear)
        end
      end
    end
  else
    local battle = DataCenter.BattleLevel
    local reward = battle:GetTriggerReward(self.param.triggerData.triggerId)
    local resourceItemNum = 0
    if reward ~= nil then
      table.walk(reward, function(_, v)
        if v.type == RewardType.RESOURCE_ITEM then
          resourceItemNum = resourceItemNum + v.value.num
        end
      end)
    end
    if 0 < resourceItemNum and DataCenter.ResourceItemDataManager:CheckIsStorageFull(resourceItemNum) then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityFull)
      self.param.triggerData:SetCanSubmit(false)
      return
    end
    local result = DataCenter.BattleLevel:DoTriggerAnimation(self.param.triggerData, 1)
    if result > Const.PlayerInteractCode.InteractCode_Fail then
      if result == Const.PlayerInteractCode.InteractCode_OK then
        self:ShowHighlightItem()
      end
      self:ShowCollectAnimation()
      return
    end
    DataCenter.BattleLevel:DoReceivePVETriggerReward(self.param.triggerData)
  end
end

function PveTriggerPointBubble:RefreshType2000Trigger(setPic)
  if not self.param.triggerData:ISCollectRewardMoreThanOneTime() then
    return
  end
  if self.param.triggerData:ISCollectRewardMoreThanOneTimeAllComplete() then
    DataCenter.BattleLevel:DoTrigger(self.param.triggerData)
    self:DeleteRefreshTimer()
    return
  end
  if self.cost_icon ~= nil and self.cost_icon ~= nil then
    local para1 = self.param.triggerData.config.bubbleIcon
    local str = Const.EnenryIconPath
    if self.param.triggerData:GetNeedPveStamina() <= 0 then
      if string.IsNullOrEmpty(para1) then
        str = "Assets/Main/Sprites/Guide/UIpuzzle_img_box1"
      else
        str = para1
        local tmpVec = string.split(para1, "/")
        if table.count(tmpVec) == 1 then
          str = string.format(LoadPath.ItemPath, para1)
        end
      end
    end
    if setPic then
      if self.param.triggerData:GetNeedPveStamina() <= 0 then
        self.cost_icon1:LoadSprite(str)
      else
        self.cost_icon:LoadSprite(str)
      end
    end
    local time = self.param.triggerData:GetCollectRewardMoreThanOneTimeCollCollectTime()
    local now = UITimeManager:GetInstance():GetServerTime()
    local diffTime = time - now
    local type, cost = self:GetSpeedUpTypeAndCost()
    if type ~= nil then
      if 0 < diffTime then
        self:StopCollectAnimation()
        self.cd:SetActive(true)
        self.cd_cost:SetActive(false)
        self.cost_icon1.gameObject:SetActive(false)
        self.cost_bg.gameObject:SetActive(false)
        self.cost_icon.gameObject:SetActive(false)
        self.cd_time.text = UITimeManager:GetInstance():MilliSecondToFmtString(diffTime)
        self.cd_cost_num.text = string.GetFormattedSeperatorNum(cost)
        if type == Const.TriggerClearCDType.TriggerClearCDType_Diamond then
          self.cd_cost:SetActive(true)
          self.cd_cost_icon:LoadSprite(DataCenter.RewardManager:GetPicByType(RewardType.GOLD))
        elseif type == Const.TriggerClearCDType.TriggerClearCDType_Energy then
          self.cd_cost:SetActive(true)
          self.cd_cost_icon:LoadSprite(Const.EnenryIconPath)
        end
        self.cost_text.text = ""
      else
        if self.cd.activeSelf then
          self.param.triggerData:RefreshRewardState()
        end
        self.cd:SetActive(false)
        self.cost_bg.gameObject:SetActive(true)
        if self.param.triggerData:GetNeedPveStamina() <= 0 then
          self.cost_icon1.gameObject:SetActive(true)
          self.cost_icon.gameObject:SetActive(false)
          self.cost_text.text = ""
        else
          self.cost_icon1.gameObject:SetActive(false)
          self.cost_icon.gameObject:SetActive(true)
          self.cost_text.text = self.param.needStaminaCount
        end
      end
    end
  end
end

function PveTriggerPointBubble:RefreshTypeGainBuffTrigger()
  local battleBuffId = self.param.triggerData.config.battleBuffId
  local icon = GetTableData(TableName.BattleBuff, battleBuffId, "icon")
  self.cost_icon.gameObject:SetActive(false)
  self.cost_icon1.gameObject:SetActive(true)
  self.cost_icon1:LoadSprite(string.format(LoadPath.UIPveBattleBuff, icon))
  self.cost_text.gameObject:SetActive(false)
end

function PveTriggerPointBubble:PlayAnim(animName)
  self:RemoveHideAnimTimer()
  if animName ~= AnimName.Interact then
    self:StopCollectAnimation()
  end
  self.isOnInteract = animName == AnimName.Interact
  if self.bubble_anim:IsPlaying(animName) then
    self.bubble_anim:Rewind(animName)
  else
    self.bubble_anim:Play(animName)
  end
  if animName == AnimName.Hide then
    local time = self.bubble_anim:GetClipLength(AnimName.Hide)
    self:AddHideAnimTimer(time)
  end
end

function PveTriggerPointBubble:RefreshResourceItem()
  for k, v in ipairs(self.cell) do
    v:RefreshResourceItem()
  end
end

function PveTriggerPointBubble:RefreshGoods()
  for k, v in ipairs(self.cell) do
    v:RefreshGoods()
  end
end

function PveTriggerPointBubble:RefreshResource()
  for k, v in ipairs(self.cell) do
    v:RefreshResource()
  end
end

function PveTriggerPointBubble:RefreshComplete()
  for k, v in ipairs(self.cell) do
    v:RefreshComplete()
  end
end

function PveTriggerPointBubble:DoHideAnim()
  if self.gameObject ~= nil and self.enterEnableBubble ~= false then
    self.enterEnableBubble = false
    if self.param.isBubbleSubmit then
      self:PlayAnim(AnimName.Hide)
      if self.touchBubble ~= nil then
        self.touchBubble.gameObject:SetActive(false)
      end
      self.param.triggerData:SetCanSubmit(false)
    end
  end
end

function PveTriggerPointBubble:OnPlayerMoveSignal(pos)
  if self.param.visible then
    local distance = Vector3.Distance(pos, self.param.pos)
    if DataCenter.BattleLevel.selectionMgr:Enabled() then
      if distance <= self.param.bubbleShowRange then
        DataCenter.BattleLevel.selectionMgr:Add(PveSelectionType.Trigger, self.param.triggerData.triggerId)
      else
        DataCenter.BattleLevel.selectionMgr:Remove(PveSelectionType.Trigger, self.param.triggerData.triggerId)
        self:Show(false)
      end
    else
      self:Show(distance <= self.param.bubbleShowRange)
    end
  end
end

function PveTriggerPointBubble:Show(show)
  self:SetViewVisible(show)
end

function PveTriggerPointBubble:GetGuideTrigger()
  return self.touchBubble
end

function PveTriggerPointBubble:AddRefreshTimer(timeDelay)
  self:DeleteRefreshTimer()
  timeDelay = timeDelay or 1
  self.refreshTimer = TimerManager:GetInstance():GetTimer(timeDelay, self.time_action, self, false, false, false)
  self.refreshTimer:Start()
end

function PveTriggerPointBubble:TimerAction()
  self:RefreshType2000Trigger()
end

function PveTriggerPointBubble:DeleteRefreshTimer()
  if self.refreshTimer ~= nil then
    self.refreshTimer:Stop()
    self.refreshTimer = nil
  end
end

function PveTriggerPointBubble:AddHideTimer(timeDelay)
  self:RemoveHideTimer()
  if self.hideTimer == nil then
    self.hideTimer = TimerManager:GetInstance():GetTimer(timeDelay, self.hide_timer_callback, self, true, false, false)
  end
  self.hideTimer:Start()
end

function PveTriggerPointBubble:HideTimerCallBack()
  self:RemoveHideTimer()
  self:SetVisible(false)
end

function PveTriggerPointBubble:RemoveHideTimer()
  if self.hideTimer ~= nil then
    self.hideTimer:Stop()
    self.hideTimer = nil
  end
end

function PveTriggerPointBubble:SetViewVisible(visible)
  if self.viewVisible ~= visible then
    self.viewVisible = visible
    self:CheckVisible()
  end
end

function PveTriggerPointBubble:CheckVisible()
  local visible = self:GetTrueVisible()
  if visible then
    self:OnCreate()
  else
    self:DoHideAnim()
  end
end

function PveTriggerPointBubble:AddHideAnimTimer(timeDelay)
  self:RemoveHideTimer()
  if self.hideAnimTimer == nil then
    self.hideAnimTimer = TimerManager:GetInstance():GetTimer(timeDelay, self.hide_anim_timer_callback, self, true, false, false)
  end
  self.hideAnimTimer:Start()
end

function PveTriggerPointBubble:HideAnimTimerCallBack()
  self:RemoveHideAnimTimer()
  self:SetViewVisible(false)
end

function PveTriggerPointBubble:RemoveHideAnimTimer()
  if self.hideAnimTimer ~= nil then
    self.hideAnimTimer:Stop()
    self.hideAnimTimer = nil
  end
end

function PveTriggerPointBubble:GetTrueVisible()
  return self.param.visible and self.viewVisible
end

return PveTriggerPointBubble
