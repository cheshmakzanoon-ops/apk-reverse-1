local base = UIBaseView
local LWUIRollTreasureView = BaseClass("LWUIRollTreasureView", base)
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local LWUIRollRewardItem = require("UI.LWSeason4.Activity.LWUIRollTreasure.Component.LWUIRollRewardItem")
local LWUIRollEntranceItem = require("UI.LWSeason4.Activity.LWUIRollTreasure.Component.LWUIRollEntranceItem")
local Screen = CS.UnityEngine.Screen
local mask_path = "mask"
local tipBtn_path = "safeArea/root/area1/title/txt_title/tipBtn"
local closeBtn_path = "safeArea/closeBtn"
local title_path = "safeArea/root/area1/title/txt_title"
local des_path = "safeArea/root/area1/des"
local loopGridViewItemHolder_path = "safeArea/root/reward/rewardGrid"
local compItemContent_path = "safeArea/root/reward/rewardGrid/Viewport/ItemContent"
local emptyDes_path = "safeArea/root/reward/emptyDes"
local totalDes_path = "safeArea/root/bg/Image/totalDes"
local area1_path = "safeArea/root/area1"
local lostArea_path = "safeArea/root/reward/lost"
local nextBg1_path = "safeArea/caveBg_1"
local nextBg2_path = "safeArea/caveBg_1/caveBg_scale"
local animatorCom_path = ""
local bgAni1_path = "safeArea/caveBg_1/caveBg_scale/treasure_chest (1)"
local item_lucky_path = "safeLucky/item_lucky"
local item_count_path = "safeLucky/item_lucky/bg/item_count"
local tip_luck_btn_path = "safeLucky/item_lucky/tipLuckBtn"
local item_icon_path = "safeLucky/item_lucky/item_icon"
local root_path = "safeArea/root"
local tavern02_path = "safeArea/spine_root/Tavern01Root/Tavern02"
local spine_show_path = "safeArea/spine_root/Tavern01Root/SpineShow"
local tavern01_path = "safeArea/spine_root/Tavern01Root/Tavern01"
local btn_txt_path = "safeArea/open_panel/btn_txt"
local roll_a_btn_path = "safeArea/open_panel/rollABtn"
local win_path = "safeArea/result_panel/window/win"
local lose_path = "safeArea/result_panel/window/lose"
local result_panel_path = "safeArea/result_panel"
local continue_path = "safeArea/result_panel/continue"
local boss_roll_img_path = "safeArea/spine_root/Tavern01Root/spine_bone/roll_imgboss/boss_roll_img"
local self_roll_img_path = "safeArea/spine_root/Tavern01Root/spine_bone/roll_imgself/self_roll_img"
local spine_bone_path = "safeArea/spine_root/Tavern01Root/spine_bone"
local open_panel_path = "safeArea/open_panel"
local reward_item1_path = "safeArea/caveBg_1/caveBg_scale/box_open_s4/slect_chest/reward/reward1/reward_item1"
local reward_item2_path = "safeArea/caveBg_1/caveBg_scale/box_open_s4/slect_chest/reward/reward2/reward_item2"
local reward_item3_path = "safeArea/caveBg_1/caveBg_scale/box_open_s4/slect_chest/reward/reward3/reward_item3"
local eff_ui_s4_roll_select_loop1_path = "safeArea/caveBg_1/caveBg_scale/box_open_s4/Eff_ui_S4_roll_box_kaigai/Eff_ui_box_open1/Eff_ui_s4_roll_select_loop1"
local eff_ui_s4_roll_select_loop2_path = "safeArea/caveBg_1/caveBg_scale/box_open_s4/Eff_ui_S4_roll_box_kaigai/Eff_ui_box_open2/Eff_ui_s4_roll_select_loop2"
local eff_ui_s4_roll_select_loop3_path = "safeArea/caveBg_1/caveBg_scale/box_open_s4/Eff_ui_S4_roll_box_kaigai/Eff_ui_box_open3/Eff_ui_s4_roll_select_loop3"
local box_btn1_path = "safeArea/caveBg_1/caveBg_scale/box_open_s4/Eff_ui_S4_roll_box_kaigai/Eff_ui_box_open1/box_btn1"
local box_btn2_path = "safeArea/caveBg_1/caveBg_scale/box_open_s4/Eff_ui_S4_roll_box_kaigai/Eff_ui_box_open2/box_btn2"
local box_btn3_path = "safeArea/caveBg_1/caveBg_scale/box_open_s4/Eff_ui_S4_roll_box_kaigai/Eff_ui_box_open3/box_btn3"
local confirm_path = "safeArea/caveBg_1/caveBg_scale/box_open_s4/slect_chest/confirm"
local box_mask_path = "safeArea/caveBg_1/caveBg_scale/box_open_s4/box_mask"
local entranceItem_path = {
  "safeArea/root/area1/Entrance/EntranceItem1",
  "safeArea/root/area1/Entrance/EntranceItem2"
}
local anims = {
  FirstEnter = "V_ui_RollTreasureExploration_in",
  Door_To_Bar = "V_ui_RollTreasureExploration_switch",
  Bar_To_Box = "V_ui_RollTreasureExploration_switch_1",
  Box_Fly = "V_ui_RollTreasureExploration_switch_2",
  Box_Open1 = "V_ui_RollTreasureExploration_open_box1",
  Box_Open2 = "V_ui_RollTreasureExploration_open_box2",
  Box_Open3 = "V_ui_RollTreasureExploration_open_box3",
  Bar_Root_In = "V_ui_RollTreasureExploration_root_in",
  Bar_Root_Out = "V_ui_RollTreasureExploration_root_out",
  Box_Open = "V_ui_RollTreasureExploration_box_open"
}
local roll_spire_path = "Assets/Main/SeasonRes/S4/Sprites/UI/RollTreasure/roll_%s.png"
local spineLineTypeState = {
  [CaveExplorationNodeType.Roll] = {
    OnEnter = 1,
    OnEnable = 2,
    OnStart = 3,
    OnLeave = 4
  },
  [CaveExplorationNodeType.Entrance] = {OnEnable = 1},
  [CaveExplorationNodeType.Trap] = {OnEnter = 1, OnEnable = 2},
  [CaveExplorationNodeType.RewardOver] = {OnEnter = 1, OnEnable = 2},
  [CaveExplorationNodeType.Box] = {OnEnter = 1, OnEnable = 2}
}

function LWUIRollTreasureView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWUIRollTreasureView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWUIRollTreasureView:OnEnable()
  base.OnEnable(self)
  self:RefreshView()
  self.spine_bone:SetActive(false)
  self.result_panel:SetShow(false)
  self.open_panel:SetShow(false)
  self.box_mask:SetActive(false)
  self.spine_show:SetActive(true)
  for _, effect in ipairs(self.rewardItemEffects) do
    effect:SetActive(false)
  end
  self.animatorCom:Enable(true)
  local tempData = DataCenter.CaveExplorationManager:GetTempData(self.configId)
  if tempData.lineType == CaveExplorationNodeType.Box then
    self.animatorCom:Play(anims.Bar_To_Box, 0, 0)
  else
    self.animatorCom:Play(anims.FirstEnter, 0, 0)
  end
  self:PlaySpineByState(tempData, "OnEnable", nil, true)
end

function LWUIRollTreasureView:OnDisable()
  if self.rewards or self.pathRewards then
    DataCenter.RewardManager:ShowTwoLinesRewards(self.rewards, self.pathRewards, "128027", self.showTip)
  end
  base.OnDisable(self)
end

function LWUIRollTreasureView:ComponentDefine()
  self.mask = self:AddComponent(UIButton, mask_path)
  self.tipBtn = self:AddComponent(UIButton, tipBtn_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.title = self:AddComponent(UIText, title_path)
  self.des = self:AddComponent(UIText, des_path)
  self.loopGridViewItemHolder = self:AddComponent(UILoopGridView, loopGridViewItemHolder_path)
  self.compItemContent = self:AddComponent(UIBaseContainer, compItemContent_path)
  self.emptyDes = self:AddComponent(UIBaseContainer, emptyDes_path)
  self.totalDes = self:AddComponent(UIText, totalDes_path)
  self.area1 = self:AddComponent(UIBaseContainer, area1_path)
  self.lostArea = self:AddComponent(UIBaseContainer, lostArea_path)
  self.nextBg1 = self:AddComponent(UIRawImage, nextBg1_path)
  self.nextBg2 = self:AddComponent(UIRawImage, nextBg2_path)
  self.animatorCom = self:AddComponent(UIAnimator, animatorCom_path)
  self.bgAni1 = self:AddComponent(UIImage, bgAni1_path)
  self.rootAnim = self:AddComponent(UIAnimator, root_path)
  self.btn_txt = self:AddComponent(UIButton, btn_txt_path)
  self.roll_a_btn = self:AddComponent(UIButton, roll_a_btn_path)
  self.box_mask = self:AddComponent(UIBaseContainer, box_mask_path)
  self.item_lucky = self:AddComponent(UIBaseContainer, item_lucky_path)
  self.item_count = self:AddComponent(UITextMeshProUGUIEx, item_count_path)
  self.tip_luck_btn = self:AddComponent(UIButton, tip_luck_btn_path)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.item_btn = self:AddComponent(UIButton, item_icon_path)
  self.spine_show = self:AddComponent(UISpineLogic, spine_show_path)
  self.tavern02 = self:AddComponent(UISpineLogic, tavern02_path)
  self.tavern01 = self:AddComponent(UISpineLogic, tavern01_path)
  self.result_panel = self:AddComponent(UICanvasGroup, result_panel_path)
  self.resultPanelAnimCom = self.result_panel.gameObject:GetComponent(typeof(CS.SimpleAnimation))
  self.continue_btn = self:AddComponent(UIButton, continue_path)
  self.spine_bone = self:AddComponent(UIBaseContainer, spine_bone_path)
  self.boss_roll_img = self:AddComponent(UIImage, boss_roll_img_path)
  self.self_roll_img = self:AddComponent(UIImage, self_roll_img_path)
  self.open_panel = self:AddComponent(UICanvasGroup, open_panel_path)
  self.confirm = self:AddComponent(UIButton, confirm_path)
  self.win = self:AddComponent(UIBaseContainer, win_path)
  self.lose = self:AddComponent(UIBaseContainer, lose_path)
  self.rewardItems = {
    self:AddComponent(UICommonResItem, reward_item1_path),
    self:AddComponent(UICommonResItem, reward_item2_path),
    self:AddComponent(UICommonResItem, reward_item3_path)
  }
  self.rewardItemEffects = {
    self:AddComponent(UIBaseContainer, eff_ui_s4_roll_select_loop1_path),
    self:AddComponent(UIBaseContainer, eff_ui_s4_roll_select_loop2_path),
    self:AddComponent(UIBaseContainer, eff_ui_s4_roll_select_loop3_path)
  }
  self.boxBtns = {
    self:AddComponent(UIButton, box_btn1_path),
    self:AddComponent(UIButton, box_btn2_path),
    self:AddComponent(UIButton, box_btn3_path)
  }
  self.entranceItem = {
    self:AddComponent(LWUIRollEntranceItem, entranceItem_path[1]),
    self:AddComponent(LWUIRollEntranceItem, entranceItem_path[2])
  }
  for index, v in ipairs(self.boxBtns) do
    v:SetOnClick(function()
      self:ClickBox(index)
    end)
  end
  self.item_lucky:SetActive(true)
  self.confirm:SetOnClick(BindCallback(self, self.ClickSelectReward))
  self.closeBtn:SetOnClick(BindCallback(self, self.ClickCloseBtn))
  self.tipBtn:SetOnClick(BindCallback(self, self.ClickTipBtn))
  self.tip_luck_btn:SetOnClick(BindCallback(self, self.ClickTipLuckBtn))
  self.item_btn:SetOnClick(BindCallback(self, self.ClickItemBtn))
  self.btn_txt:SetOnClick(BindCallback(self, self.ClickOpen))
  self.roll_a_btn:SetOnClick(BindCallback(self, self.ClickOpen))
  self.continue_btn:SetOnClick(BindCallback(self, self.ClickContinue))
  self.loopGridViewItemHolder:InitGridView(0, function(loopScroll, index, item)
    return self:OnGetItemByRowColumn(loopScroll, index)
  end)
end

function LWUIRollTreasureView:ComponentDestroy()
  if self.compItemContent then
    self.compItemContent:RemoveComponents(LWUIRollRewardItem)
  end
  if self.loopGridViewItemHolder then
    self.loopGridViewItemHolder:ClearAllItems()
  end
  if self.refreshTimer then
    self.refreshTimer:Stop()
    self.refreshTimer = nil
  end
  if self.rollTimer then
    self.rollTimer:Stop()
    self.rollTimer = nil
  end
  if self.rollResultTimer then
    self.rollResultTimer:Stop()
    self.rollResultTimer = nil
  end
  if self.finishTimer then
    self.finishTimer:Stop()
    self.finishTimer = nil
  end
  if self.lockTimer then
    self.lockTimer:Stop()
    self.lockTimer = nil
  end
  if self.openRewardTimer then
    self.openRewardTimer:Stop()
    self.openRewardTimer = nil
  end
  if self.lockBoxTimer then
    self.lockBoxTimer:Stop()
    self.lockBoxTimer = nil
  end
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  self.mask = nil
  self.tipBtn = nil
  self.closeBtn = nil
  self.title = nil
  self.des = nil
  self.loopGridViewItemHolder = nil
  self.compItemContent = nil
  self.emptyDes = nil
  self.totalDes = nil
  self.area1 = nil
  self.lostArea = nil
  self.nextBg1 = nil
  self.nextBg2 = nil
  self.animatorCom = nil
  self.bgAni1 = nil
  self.item_lucky = nil
  self.item_count = nil
  self.tip_luck_btn = nil
  self.item_icon = nil
  self.item_btn = nil
  self.spine_show = nil
  self.tavern02 = nil
  self.tavern01 = nil
  self.entranceItem = nil
  self.rootAnim = nil
  self.btn_txt = nil
  self.roll_a_btn = nil
  self.result_panel = nil
  self.continue = nil
  self.boss_roll_img = nil
  self.self_roll_img = nil
  self.spine_bone = nil
  self.openRoll = nil
  self.open_panel = nil
  self.rewardItems = nil
  self.rewardItemEffects = nil
  self.boxBtns = nil
  self.confirm = nil
  self.box_mask = nil
  self.win = nil
  self.lose = nil
  self.resultPanelAnimCom = nil
  self.clickContinue = nil
end

function LWUIRollTreasureView:DataDefine()
  self.uuid, self.worldPos = self:GetUserData()
  self.event = nil
  self.configId = nil
  self.curState = nil
end

function LWUIRollTreasureView:DataDestroy()
  self.uuid = nil
  self.worldPos = nil
  self.event = nil
  self.configId = nil
  self.curState = nil
  self.selectBoxIndex = nil
  if self.tween then
    self.tween:Kill()
    self.tween = nil
  end
  if self.tween1 then
    self.tween1:Kill()
    self.tween1 = nil
  end
  if self.tween2 then
    self.tween2:Kill()
    self.tween2 = nil
  end
  if self.tween3 then
    self.tween3:Kill()
    self.tween3 = nil
  end
end

function LWUIRollTreasureView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DetectCaveExplorationFinish, self.FinishEvent)
  self:AddUIListener(EventId.UIDetectCaveExploreViewRefresh, self.RefreshViewByEvent)
end

function LWUIRollTreasureView:OnRemoveListener()
  self:RemoveUIListener(EventId.DetectCaveExplorationFinish, self.FinishEvent)
  self:RemoveUIListener(EventId.UIDetectCaveExploreViewRefresh, self.RefreshViewByEvent)
  base.OnRemoveListener(self)
end

function LWUIRollTreasureView:FinishEvent(t)
  if self.selectBoxIndex ~= nil then
    self.rewards = t.reward
    self.pathRewards = t.pathReward
    self.showTip = t.showTip
    local flag, dur = self:PlayAnimationReturnTime(anims["Box_Open" .. tostring(self.selectBoxIndex)])
    self.finishEventTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.ctrl:CloseSelf()
      if self.finishEventTimer then
        self.finishEventTimer:Stop()
        self.finishEventTimer = nil
      end
    end, dur)
    UIUtil.CheckEventTrigger(OpMode.ClickBtnS4WinePub2)
  else
    self.ctrl:CloseSelf()
  end
end

function LWUIRollTreasureView:SetupView()
  if not self.configId then
    return
  end
  local tempData = DataCenter.CaveExplorationManager:GetTempData(self.configId)
  self.tempData = tempData
  if tempData then
    self.isReduce = tempData.reward_deduction == -1
    self.lostArea:SetActive(self.isReduce)
    local titleName = Localization:GetString(tempData.name)
    if GMUtils.GetBool(GMConst.DebugDisplayGameID, false) then
      titleName = string.format("%s[%s]", titleName, self.configId)
    end
    self.title:SetText(titleName)
    self.des:SetLocalText(tempData.description)
    local areaPosY = 720
    local itemCount = 0
    if 0 >= tempData.entranceType1 then
      self.entranceItem[1]:SetActive(false)
    else
      self.entranceItem[1]:SetActive(true)
      itemCount = itemCount + 1
      self.entranceItem[1]:SetData(self.configId, 1, self.uuid, self.worldPos, self.event)
    end
    if 0 >= tempData.entranceType2 then
      self.entranceItem[2]:SetActive(false)
    else
      self.entranceItem[2]:SetActive(true)
      itemCount = itemCount + 1
      self.entranceItem[2]:SetData(self.configId, 2, self.uuid, self.worldPos)
    end
    if itemCount == 1 then
      self.area1:SetAnchoredPositionXY(0, 748)
    else
      self.area1:SetAnchoredPositionXY(0, 900)
    end
    local showGoods = tempData:CanShowGoods()
    local showValue = showGoods and 1 or 0
    self.item_lucky:SetLocalScaleXYZ(showValue, showValue, showValue)
    if showGoods then
      local hasCount = DataCenter.ItemData:GetItemCount(tempData.goods_show) or 0
      self.item_count:SetText(hasCount)
      local icon = DataCenter.ItemTemplateManager:GetIconPath(tempData.goods_show)
      self.item_icon:LoadSprite(icon)
      local canUse = tempData:CanUseGoods()
      UIGray.SetGray(self.tip_luck_btn.transform, not canUse, true)
    end
    if tempData.lineType == CaveExplorationNodeType.Box and tempData.entranceType1 == 3 then
      local t = LocalController:instance():getLine(TableName.CaveExplorationBox, tempData.entranceParam1)
      local tempRewardData = string.string2array_i(t.box_reward, ";", "|")
      for index, v in ipairs(self.rewardItems) do
        local indexTempRewardData = tempRewardData[index]
        local rewardData = {
          rewardType = indexTempRewardData[1],
          itemId = indexTempRewardData[2],
          count = indexTempRewardData[3]
        }
        v:ReInit(rewardData)
      end
    end
  else
    Logger.LogError("UIDetectCaveExplorationView.SetupView failed. Missing template " .. self.configId)
    self.ctrl:CloseSelf()
  end
end

function LWUIRollTreasureView:ClickTipBtn()
  local tempData = DataCenter.CaveExplorationManager:GetTempData(self.configId)
  if tempData and not string.IsNullOrEmpty(tempData.help) then
    local param = {}
    param.activityRulesStr = Localization:GetString(tempData.help)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function LWUIRollTreasureView:ClickTipLuckBtn()
  local tempData = DataCenter.CaveExplorationManager:GetTempData(self.configId)
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIRollTreasureShip, {anim = true}, tempData, self.uuid, self.configId)
end

function LWUIRollTreasureView:ClickItemBtn()
  local tempData = DataCenter.CaveExplorationManager:GetTempData(self.configId)
  if tempData and tempData.goods_show ~= nil and tempData.goods_show ~= 0 then
    LWResourceLackUtil:GotoGoodsItemLack(tempData.goods_show, 1)
  end
end

function LWUIRollTreasureView:RefreshViewByConfigId(configId)
  self.configId = configId
  self:SetupView()
  self:RefreshRewardView()
end

function LWUIRollTreasureView:RefreshView()
  if not self.uuid then
    Logger.LogError("Refresh UIDetectCaveExplorationView exception! uuid is null.")
    self.ctrl:CloseSelf()
    return
  end
  self.event = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.uuid)
  if self.event == nil then
    Logger.LogError("Refresh UIDetectCaveExplorationView exception! GetDetectEventInfo from mgr failed.")
    self.ctrl:CloseSelf()
    return
  end
  local path = self.event.cavePath
  if not path or #path <= 0 then
    Logger.LogError("Refresh UIDetectCaveExplorationView exception! Path attr exception!")
    self.ctrl:CloseSelf()
    return
  end
  local currentConfigId = path[#path]
  local rewardsCount = 0
  for k, v in ipairs(path) do
    if v ~= currentConfigId then
      local tempData = DataCenter.CaveExplorationManager:GetTempData(v)
      if tempData and 0 < tempData.level_reward then
        rewardsCount = rewardsCount + 1
      end
    end
  end
  self:RefreshViewByConfigId(currentConfigId)
end

function LWUIRollTreasureView:RefreshViewByEvent(msg)
  if not msg or not msg.uuid then
    return
  end
  if msg.uuid == self.uuid then
    self:RefreshWithAnimation()
  end
end

function LWUIRollTreasureView:Description()
  local sb = StringBuilder.New()
  sb:AppendLine("---\229\164\186\229\174\157\229\165\135\229\133\181\231\149\140\233\157\162\228\191\161\230\129\175---")
  sb:AppendFormatLine("\229\189\147\229\137\141\233\155\183\232\190\190\228\186\139\228\187\182id:%s", self.uuid)
  sb:AppendFormatLine("\229\189\147\229\137\141\233\155\183\232\190\190\228\186\139\228\187\182state:%s", self.event and self.event.state or "NULL")
  sb:AppendFormatLine("\229\189\147\229\137\141\229\129\156\231\149\153\231\154\132\230\173\165\233\170\164:%s(%s)", self.configId, self.tempData and "\226\136\154" or "\195\151")
  if self.tempData then
    if self.tempData.entranceType1 > 0 then
      sb:AppendFormatLine("\231\172\172\228\184\128\228\184\170\233\128\137\233\161\185\239\188\140\231\177\187\229\158\139: %s, param: %s", self.tempData.entranceType1, self.tempData.entranceParam1)
    end
    if 0 < self.tempData.entranceType2 then
      sb:AppendFormatLine("\231\172\172\228\184\128\228\184\170\233\128\137\233\161\185\239\188\140\231\177\187\229\158\139: %s, param: %s", self.tempData.entranceType2, self.tempData.entranceParam2)
    end
  end
  return sb:ToString()
end

function LWUIRollTreasureView:RefreshRewardView()
  self.isShowRewardEffect = false
  if self.isReduce then
    if self.event.caveInfo.losePathRewardArr then
      self.isShowRewardEffect = false
      self.rewardListData = self:MergeForShow(self.event.caveInfo.losePathRewardArr)
    else
      self.rewardListData = {}
    end
  elseif self.event.caveInfo.pathRewardArr then
    self.isShowRewardEffect = true
    self.rewardListData = self:MergeForShow(self.event.caveInfo.pathRewardArr)
  else
    self.rewardListData = {}
  end
  local dataCount = #self.rewardListData
  local flag = 0 < dataCount
  local showTotal = false
  if flag and self.event.caveInfo.levelRewardTotalValue then
    showTotal = true
    self.totalDes:SetLocalText("cave_exploration_UI_9", self.event.caveInfo.levelRewardTotalValue)
  end
  self.totalDes:SetActive(showTotal)
  self.emptyDes:SetActive(false)
  self.loopGridViewItemHolder:SetActive(flag)
  self.loopGridViewItemHolder:SetListItemCount(dataCount)
  self.loopGridViewItemHolder:RefreshAllShownItem()
end

function LWUIRollTreasureView:MergeForShow(data)
  local tmpList = {}
  local dataCount = #data
  if 0 < dataCount then
    for i = 1, dataCount - 1 do
      local commonRewardList = DataCenter.RewardManager:ReturnRewardParamForView(data[i].pathReward)
      if commonRewardList then
        for ii, vv in ipairs(commonRewardList) do
          local key = vv.rewardType .. "_" .. vv.itemId
          local rewardData = tmpList[key]
          if rewardData == nil then
            rewardData = {}
            tmpList[key] = rewardData
            rewardData.rewardType = vv.rewardType
            rewardData.itemId = vv.itemId
            rewardData.count = 0
          end
          rewardData.count = rewardData.count + vv.count
        end
      end
    end
    local commonRewardList = DataCenter.RewardManager:ReturnRewardParamForView(data[dataCount].pathReward)
    if commonRewardList then
      for ii, vv in ipairs(commonRewardList) do
        local key = vv.rewardType .. "_" .. vv.itemId
        local rewardData = tmpList[key]
        if rewardData == nil then
          rewardData = {}
          tmpList[key] = rewardData
          rewardData.rewardType = vv.rewardType
          rewardData.itemId = vv.itemId
          rewardData.count = 0
        end
        rewardData.count = rewardData.count + vv.count
        rewardData.isNew = true
      end
    end
  end
  local result = {}
  local tmpList2 = {}
  for k, v in pairs(tmpList) do
    table.insert(tmpList2, v)
  end
  local tmpCount = #tmpList2
  if tmpCount < 10 and 0 < tmpCount then
    tmpCount = 10
  end
  for i = 1, tmpCount do
    local resultData = {}
    local rewardData = tmpList2[i]
    if rewardData then
      resultData.rewardData = rewardData
    else
      resultData.isEmpty = true
    end
    table.insert(result, resultData)
  end
  return result
end

function LWUIRollTreasureView:OnGetItemByRowColumn(loopScroll, index)
  if self.rewardListData ~= nil then
    local count = #self.rewardListData
    index = index + 1
    if index < 1 or count < index then
      return nil
    end
    local item = loopScroll:NewListViewItem("RollTreasureReward")
    local script = self.compItemContent:GetComponent(item.gameObject.name, LWUIRollRewardItem)
    if script == nil then
      local name = "item_" .. index
      item.gameObject.name = name
      script = self.compItemContent:AddComponent(LWUIRollRewardItem, name)
    end
    script:SetActive(true)
    local data = self.rewardListData[index]
    script:ReInit(data, self.isShowRewardEffect)
    return item
  end
end

function LWUIRollTreasureView:RefreshWithAnimation()
  self.event = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.uuid)
  if self.event == nil then
    Logger.LogError("Refresh UIDetectCaveExplorationView exception! GetDetectEventInfo from mgr failed.")
    self.ctrl:CloseSelf()
    return
  end
  local path = self.event.cavePath
  if not path or #path <= 0 then
    Logger.LogError("Refresh UIDetectCaveExplorationView exception! Path attr exception!")
    self.ctrl:CloseSelf()
    return
  end
  if self.refreshTimer then
    self.refreshTimer:Stop()
    self.refreshTimer = nil
  end
  if self.finishTimer then
    self.finishTimer:Stop()
    self.finishTimer = nil
  end
  local pathCount = #path
  if 1 < pathCount then
    local currentConfigId = path[pathCount]
    local preConfigId = path[pathCount - 1]
    local rewardsCount = 0
    for k, v in ipairs(path) do
      if v ~= currentConfigId then
        local tempData = DataCenter.CaveExplorationManager:GetTempData(v)
        if tempData and 0 < tempData.level_reward then
          rewardsCount = rewardsCount + 1
        end
      end
    end
    local tempData = DataCenter.CaveExplorationManager:GetTempData(currentConfigId)
    if tempData then
    end
    local lastConfig = DataCenter.CaveExplorationManager:GetTempData(preConfigId)
    local luckyL = tempData.lineType == CaveExplorationNodeType.Roll and not tempData:CanUseGoods()
    local normalL = tempData.lineType == CaveExplorationNodeType.Roll and tempData:CanUseGoods()
    if lastConfig.lineType ~= CaveExplorationNodeType.Entrance and normalL or tempData.lineType == CaveExplorationNodeType.Trap or tempData.lineType == CaveExplorationNodeType.Box then
      self:EnterRollSpine(tempData, "OnEnter")
    else
      self:PlaySpineByState(tempData, "OnEnter")
      self:LockAnim(1)
    end
    local ani1
    local lineType = tempData.lineType
    if lastConfig.lineType == CaveExplorationNodeType.Entrance and not luckyL then
      ani1 = anims.Door_To_Bar
    elseif lineType == CaveExplorationNodeType.Box then
      ani1 = nil
    elseif lineType == CaveExplorationNodeType.Trap then
      ani1 = nil
    elseif luckyL then
    elseif lastConfig.lineType ~= CaveExplorationNodeType.Entrance and tempData.lineType == CaveExplorationNodeType.Roll then
      ani1 = nil
    end
    if not self.lockForAnimation then
      self.lockForAnimation = ani1 ~= nil
    end
    if not string.IsNullOrEmpty(tempData.icon1Path) then
      self.bgAni1:LoadSprite(tempData.icon1Path)
    end
    self.refreshTimer = TimerManager:GetInstance():DelayInvoke(function()
      self.configId = currentConfigId
      self:SetupView()
    end, 0.4)
    local flag, duration
    if ani1 ~= nil then
      flag, duration = self:PlayAnimationReturnTime(ani1)
    end
    local finishTime = flag and 1 or 2
    self.finishTimer = TimerManager:GetInstance():DelayInvoke(function()
      self:RefreshRewardView()
      self.lockForAnimation = false
    end, finishTime)
  else
    Logger.LogError("[RefreshWithAnimation] path count error; pathCount : " .. pathCount)
  end
end

function LWUIRollTreasureView:PlaySpineByState(tempData, state, callback, empty)
  if tempData ~= nil then
    local spineInfo = tempData:GetSpineInfo()
    if spineInfo ~= nil and spineLineTypeState[tempData.lineType] ~= nil and spineLineTypeState[tempData.lineType][state] ~= nil then
      local animIndex = spineLineTypeState[tempData.lineType][state]
      self:PlaySpineMap(empty or false, callback, spineInfo[animIndex])
    end
  end
end

function LWUIRollTreasureView:EnterRollSpine(tempData, state)
  if tempData ~= nil then
    local spineInfo = tempData:GetSpineInfo()
    if spineInfo ~= nil and spineLineTypeState[tempData.lineType] ~= nil and spineLineTypeState[tempData.lineType][state] ~= nil then
      local animIndex = spineLineTypeState[tempData.lineType][state]
      self.openRoll = true
      self.rollTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.spine_bone:SetActive(true)
        self.boss_roll_img:LoadSprite(string.format(roll_spire_path, tostring(self.event.caveInfo.npcPoint)))
        self.self_roll_img:LoadSprite(string.format(roll_spire_path, tostring(self.event.caveInfo.myPoint)))
        if self.rollTimer then
          self.rollTimer:Stop()
          self.rollTimer = nil
        end
      end, 0.35)
      spineInfo[animIndex].anims = {
        spineInfo[animIndex].anims[1]
      }
      self.open_panel:SetShow(false)
      self.rollResultTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.animatorCom:Enable(false)
        if self.tween1 then
          self.tween1:Kill()
          self.tween1 = nil
        end
        local time = self.resultPanelAnimCom:GetClipLength("Default")
        self.resultPanelAnimCom:Play("Default")
        self.timer = TimerManager:GetInstance():DelayInvoke(function()
          self.timer = nil
          self.result_panel:SetInteractable(true)
          self.result_panel:SetBlocksRaycasts(true)
        end, time)
        local winner = (self.event.caveInfo.myPoint or 0) >= (self.event.caveInfo.npcPoint or 0)
        self.win:SetActive(winner)
        self.lose:SetActive(not winner)
        if self.rollResultTimer then
          self.rollResultTimer:Stop()
          self.rollResultTimer = nil
        end
      end)
      self:LockAnim(2)
      self:PlaySpineMap(false, nil, spineInfo[animIndex], false)
    end
  end
end

function LWUIRollTreasureView:CheckEnterState()
  local tempData = DataCenter.CaveExplorationManager:GetTempData(self.configId)
  if not self.rollState and tempData.lineType == CaveExplorationNodeType.Roll then
    self:PlaySpineByState(tempData, "OnStart")
    self:PlayAnimationReturnTime(anims.Bar_Root_Out)
    self:LockAnim(1.5)
    if self.tween then
      self.tween:Kill()
      self.tween = nil
    end
    self.tween = self.open_panel:FadeIn(0.5)
    self.item_lucky:SetActive(false)
    self.tween:OnComplete(function()
      self.tween = nil
      self.open_panel:SetShow(true)
    end)
    self.rollState = true
    return true
  end
  return false
end

function LWUIRollTreasureView:ClickCloseBtn()
  if self.lockForAnimation then
    return
  end
  local tempData = DataCenter.CaveExplorationManager:GetTempData(self.configId)
  if tempData ~= nil and tempData.lineType == CaveExplorationNodeType.Roll and self.rollState then
    if self.openRoll then
      self:ClickContinue()
    else
      self:PlaySpineByState(tempData, "OnLeave")
      self.open_panel:SetShow(false)
      self.item_lucky:SetActive(true)
      self:PlayAnimationReturnTime(anims.Bar_Root_In)
      self.rollState = nil
      self:LockAnim(0.8)
    end
  else
    self.ctrl:CloseSelf()
  end
end

function LWUIRollTreasureView:ClickOpen()
  self.entranceItem[1]:ForceItemClick()
end

function LWUIRollTreasureView:ClickContinue()
  self.openRoll = false
  if self.clickContinue then
    return
  end
  self.clickContinue = true
  local tempData = DataCenter.CaveExplorationManager:GetTempData(self.configId)
  if tempData ~= nil and self.rollState then
    local spineInfo = tempData:GetSpineInfo()
    local state = "OnEnter"
    if spineInfo ~= nil and spineLineTypeState[tempData.lineType] ~= nil and spineLineTypeState[tempData.lineType][state] ~= nil then
      local animIndex = spineLineTypeState[tempData.lineType][state]
      table.remove(spineInfo[animIndex].anims, 1)
      self:PlaySpineMap(false, nil, spineInfo[animIndex])
    end
    if self.tween3 then
      self.tween3:Kill()
      self.resultPanelAnimCom:Stop()
      self.result_panel:SetShow(false)
      self.tween3 = nil
      self.clickContinue = nil
    end
    self.resultPanelAnimCom:Stop()
    self.tween3 = self.result_panel:FadeOut(0.5)
    self.item_lucky:SetActive(true)
    self.tween3:OnComplete(function()
      self.result_panel:SetShow(false)
      self.tween3 = nil
      self.clickContinue = nil
    end)
    self.spine_bone:SetActive(false)
    self.rollState = nil
    if tempData.lineType == CaveExplorationNodeType.Box then
      local _, dur = self:PlayAnimationReturnTime(anims.Bar_To_Box)
      self:LockAnim(dur)
      self.lockBoxTimer = TimerManager:GetInstance():DelayInvoke(function()
        if self.lockBoxTimer then
          self.lockBoxTimer:Stop()
          self.lockBoxTimer = nil
        end
      end, dur)
    else
      local _, dur = self:PlayAnimationReturnTime(anims.Bar_Root_In)
      self:LockAnim(dur)
    end
  end
end

function LWUIRollTreasureView:PlayAnimationReturnTime(animName)
  self.animatorCom:Enable(true)
  return self.animatorCom:PlayAnimationReturnTime(animName)
end

function LWUIRollTreasureView:ChooseReward()
  self:PlayAnimationReturnTime(anims.Box_Fly)
  self:PlaySpineMap(false, nil, {
    anims = {
      [1] = {
        animName = "victory_receive"
      }
    }
  }, false)
  self.box_mask:SetActive(true)
end

function LWUIRollTreasureView:ClickBox(index)
  self.selectBoxIndex = index
  for effectIndex, effect in ipairs(self.rewardItemEffects) do
    effect:SetActive(false)
    effect:SetActive(index == effectIndex)
  end
end

function LWUIRollTreasureView:ClickSelectReward()
  if self.selectBoxIndex then
    DataCenter.CaveExplorationManager:TryNextStep(self.uuid, self.configId, 1)
  else
    UIUtil.ShowTipsId("season4_cave_exploration_tips_60")
  end
end

function LWUIRollTreasureView:LockAnim(time)
  if self.lockTimer then
    self.lockTimer:Stop()
    self.lockTimer = nil
  end
  self.lockForAnimation = true
  self.lockTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.lockForAnimation = false
    if self.lockTimer then
      self.lockTimer:Stop()
      self.lockTimer = nil
    end
  end, time)
end

function LWUIRollTreasureView:PlaySpineMap(empty, callback, spineInfo, loop)
  if empty then
    self.spine_show.spine:SetEmptyAnimation(0, 0)
    self.tavern01.spine:SetEmptyAnimation(0, 0)
    self.tavern02.spine:SetEmptyAnimation(0, 0)
  end
  if callback then
    spineInfo.callback = callback
  end
  self.spine_show:SetPlayerMap(spineInfo, self.spine_show.UISpineLogicType.Once, loop)
  spineInfo.callback = nil
  self.tavern01:SetPlayerMap(spineInfo, self.spine_show.UISpineLogicType.Once, loop)
  self.tavern02:SetPlayerMap(spineInfo, self.spine_show.UISpineLogicType.Once, loop)
  local showChara = spineInfo.anims[1].animName == "Table_victory" or spineInfo.anims[1].animName == "victory_receive" or spineInfo.anims[1].animName == "victory_idle"
  self.spine_show:SetActive(not showChara)
end

return LWUIRollTreasureView
