local base = require("UI.UIActivityCenterTable.Component.ActivityContentBase")
local ResourceManager = CS.GameEntry.Resource
local UIActHeroLevelAndStarReplace = BaseClass("UIActHeroLevelAndStarReplace", base)
local SelectHeroSlotItem = require("UI.UIActivityCenterTable.Component.UIHeroLevelAndStarReplace.SelectHeroItemComponent")
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local txt_act_name_path = "Root/rect/ActivityTopGo/Txt_ActName"
local txt_times_path = "Root/rect/ActivityTopGo/TimeContent/Txt_Times"
local select_hero_item_left_path = "Root/rect/HeroSelectContent/layout/LeftSlot/SelectHeroItem_Left"
local select_hero_item_right_path = "Root/rect/HeroSelectContent/layout/RightSlot/SelectHeroItem_Right"
local do_btn_path = "Root/rect/bottomContent/DoBtn"
local img_cost_item1_path = "Root/rect/bottomContent/DoBtn/layout/ImgCostItem1"
local text_cost1_path = "Root/rect/bottomContent/DoBtn/layout/TextCost1"
local replace_text_path = "Root/rect/ReplaceTipArea/ReplaceText"
local intro_btn_path = "Root/rect/IntroBtn"
local layout_path = "Root/rect/HeroSelectContent/layout"
local click_block_obj_path = "Root/rect/ClickBlockObj"
local merge_circle_in_eff_point_path = "Root/rect/HeroSelectContent/layout/MergeCircleInEffPoint"
local merge_circle_out_eff_point_path = "Root/rect/HeroSelectContent/layout/MergeCircleOutEffPoint"
local merge_combine_eff_point_path = "Root/rect/HeroSelectContent/layout/MergeCombineEffPoint"
local CIRCLE_IN_EFF_PATH = "Assets/_Art_LastWar/Effect/Prefab/UI/2025/Eff_UI_ActHeroLevelAndStarReplace/Eff_UIActHeroLevelAndStarReplace_Light_BG1.prefab"
local CIRCLE_OUT_EFF_PATH = "Assets/_Art_LastWar/Effect/Prefab/UI/2025/Eff_UI_ActHeroLevelAndStarReplace/Eff_UIActHeroLevelAndStarReplace_Light02_BG1.prefab"
local MERGE_COMBINE_EFF_PATH = "Assets/_Art_LastWar/Effect/Prefab/UI/2025/Eff_UI_ActHeroLevelAndStarReplace/Eff_UIActHeroLevelAndStarReplace_Change03_layout.prefab"

function UIActHeroLevelAndStarReplace:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIActHeroLevelAndStarReplace:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActHeroLevelAndStarReplace:OnEnable()
  base.OnEnable(self)
end

function UIActHeroLevelAndStarReplace:OnDisable()
  base.OnDisable(self)
end

function UIActHeroLevelAndStarReplace:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWHeroLevelChangeSelectHero, self.SelectHero)
  self:AddUIListener(EventId.ExchangeHeroSuccess, self.OnExchangeSuccess)
  self:AddUIListener(EventId.RefreshItems, self.RefreshBottomBtn)
end

function UIActHeroLevelAndStarReplace:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.LWHeroLevelChangeSelectHero, self.SelectHero)
  self:RemoveUIListener(EventId.ExchangeHeroSuccess, self.OnExchangeSuccess)
  self:RemoveUIListener(EventId.RefreshItems, self.RefreshBottomBtn)
end

function UIActHeroLevelAndStarReplace:ComponentDefine()
  self.txt_act_name = self:AddComponent(UIText, txt_act_name_path)
  self.txt_times = self:AddComponent(UIText, txt_times_path)
  self.leftSelectSlot = self:AddComponent(SelectHeroSlotItem, select_hero_item_left_path)
  self.leftSelectSlot:Init(HeroReplaceSlotSide.Left)
  self.rightSelectSlot = self:AddComponent(SelectHeroSlotItem, select_hero_item_right_path)
  self.rightSelectSlot:Init(HeroReplaceSlotSide.Right)
  self.replaceBtn = self:AddComponent(UIButton, do_btn_path)
  self.replaceBtn:SetOnClick(function()
    self:OpenExchangeConfirmPanel()
  end)
  self.img_cost_item1 = self:AddComponent(UIImage, img_cost_item1_path)
  self.text_cost1 = self:AddComponent(UIText, text_cost1_path)
  self.replaceTipText = self:AddComponent(UIText, replace_text_path)
  self.infoBtn = self:AddComponent(UIButton, intro_btn_path)
  self.infoBtn:SetOnClick(function()
    self:ShowHeroExchangeGuide()
  end)
  self.simpleAni = self:AddComponent(UISimpleAnimation, layout_path)
  self.circleInEffPointObj = self:AddComponent(UIBaseContainer, merge_circle_in_eff_point_path)
  self.circleInEff = self:AddComponent(UIVfx, merge_circle_in_eff_point_path, CIRCLE_IN_EFF_PATH, {
    lifeType = UIVfxLifeType.Stay
  })
  self.circleOutEff = self:AddComponent(UIVfx, merge_circle_out_eff_point_path, CIRCLE_OUT_EFF_PATH, {
    lifeType = UIVfxLifeType.HideAfterOnce
  })
  self.mergeEff = self:AddComponent(UIVfx, merge_combine_eff_point_path, MERGE_COMBINE_EFF_PATH, {
    lifeType = UIVfxLifeType.HideAfterOnce
  })
  self.clickBlockObj = self:AddComponent(UIBaseContainer, click_block_obj_path)
  self.heroAwakenTipsText = self:AddComponent(UIText, "Root/rect/ReplaceTip3Text")
end

function UIActHeroLevelAndStarReplace:ComponentDestroy()
  self:StopAllTimer()
  self.heroAwakenTipsText = nil
end

function UIActHeroLevelAndStarReplace:SetData(activityId)
  base.SetData(self, activityId)
  self:StopAllTimer()
  self.activityId = tonumber(activityId)
  if not self.activityId then
    return
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self:ParseData()
  self.txt_act_name:SetLocalText(self.activityInfo.name)
  self:Update1000MS()
  self.leftHeroUuid = nil
  self.rightHeroUuid = nil
  self.leftSelectSlot:SetEmptyState()
  self.rightSelectSlot:SetEmptyState()
  self:RefreshBottomBtn()
  self:RefreshTipText()
  self:CheckIsNeedShowGuide()
  self.simpleAni:Play("Idle")
  self.clickBlockObj:SetActive(false)
  UIGray.SetGray(self.replaceBtn.transform, false, true)
end

function UIActHeroLevelAndStarReplace:ParseData()
  local allCanExchangeHeroInfo = self.activityInfo.para_2
  if not allCanExchangeHeroInfo then
    Logger.LogError("exchange hero config error")
    return
  end
  self.allCanExchangeHeroIdList = {}
  local info = string.split(allCanExchangeHeroInfo, "|")
  for _, v in ipairs(info) do
    local heroId = toInt(v)
    self.allCanExchangeHeroIdList[heroId] = true
  end
end

function UIActHeroLevelAndStarReplace:Update1000MS()
  if not self.activityId then
    return
  end
  if self.activityInfo == nil then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local leftTime = self.activityInfo.endTime - curTime
  if leftTime < 0 then
    leftTime = 0
  end
  local countDownTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.txt_times:SetText(countDownTimeStr)
end

function UIActHeroLevelAndStarReplace:OpenExchangeConfirmPanel()
  if self.leftHeroUuid == nil or self.rightHeroUuid == nil then
    UIUtil.ShowTipsId("season_tips171")
    return
  end
  if self.leftHeroUuid ~= self.rightHeroUuid then
    if self:IsLeftOrRightHeroAwakened() then
      local strTips = Localization:GetString("hero_awaken_tips_21")
      UIUtil.ShowTips(strTips)
      return
    end
    local heroDataL = DataCenter.HeroDataManager:GetHeroByUuid(self.leftHeroUuid)
    local heroDataR = DataCenter.HeroDataManager:GetHeroByUuid(self.rightHeroUuid)
    if heroDataL.level == heroDataR.level and heroDataL.rank == heroDataR.rank then
      local strTips = Localization:GetString("activity_hero_change_same_level_tips")
      UIUtil.ShowTips(strTips)
      return
    end
    if self:CheckIsLackCostItem() then
      LWResourceLackUtil:GotoGoodsItemLack(self.costItemId, self.costCount)
      return
    end
    local param = {}
    param.leftUuid = self.leftHeroUuid
    param.rightUuid = self.rightHeroUuid
    
    function param.doExchangeFunc(leftHeroUuid, rightHeroUuid)
      self:DoExchangeFunc(leftHeroUuid, rightHeroUuid)
    end
    
    UIManager:GetInstance():OpenWindow(UIWindowNames.HeroExchangePreview, {anim = true}, param)
  else
    Logger.LogError("DoReplace: leftHeroUuid is equal to  rightHeroUuid")
  end
end

function UIActHeroLevelAndStarReplace:CheckIsLackCostItem()
  if not self.costItemId or not self.costCount then
    return false
  end
  local haveNum = DataCenter.ItemData:GetItemCount(self.costItemId)
  return toInt(haveNum) < toInt(self.costCount)
end

function UIActHeroLevelAndStarReplace:DoExchangeFunc(leftHeroUuid, rightHeroUuid)
  SFSNetwork.SendMessage(MsgDefines.LwSeasonHeroSwitch, leftHeroUuid, rightHeroUuid)
end

function UIActHeroLevelAndStarReplace:SelectHero(param)
  if param.side == HeroReplaceSlotSide.Left then
    self.leftHeroUuid = param.heroUuid
    self.leftSelectSlot:ShowHeroData(self.leftHeroUuid)
    self.simpleAni:Play("LeftSelect")
  elseif param.side == HeroReplaceSlotSide.Right then
    self.rightHeroUuid = param.heroUuid
    self.rightSelectSlot:ShowHeroData(self.rightHeroUuid)
    self.simpleAni:Play("RightSelect")
  end
  if self.leftHeroUuid and self.rightHeroUuid then
    self:ShowAllHeroSelectEff()
  else
    self.circleInEffPointObj:SetActive(false)
  end
  self:RefreshTipText()
end

function UIActHeroLevelAndStarReplace:ShowAllHeroSelectEff()
  if self.showAllHeroSelectEffTimer then
    self.showAllHeroSelectEffTimer:Stop()
    self.showAllHeroSelectEffTimer = nil
  end
  self.showAllHeroSelectEffTimer = TimerManager:GetInstance():DelayInvoke(function()
    self.circleInEffPointObj:SetActive(true)
    self.circleInEff:Replay()
  end, 0.5)
end

function UIActHeroLevelAndStarReplace:CancelSelectHero(side)
  if side == HeroReplaceSlotSide.Left then
    self.leftHeroUuid = nil
    self.leftSelectSlot:SetEmptyState()
  elseif side == HeroReplaceSlotSide.Right then
    self.rightHeroUuid = nil
    self.rightSelectSlot:SetEmptyState()
  end
  self.circleInEffPointObj:SetActive(false)
  self:RefreshTipText()
end

function UIActHeroLevelAndStarReplace:RefreshTipText()
  local tipKeyStr = "activity_hero_change_select_tips_1"
  if self.leftHeroUuid and self.rightHeroUuid then
    tipKeyStr = "activity_hero_change_select_tips_2"
  end
  self.replaceTipText:SetLocalText(tipKeyStr)
  local showAwakenTips = self:IsLeftOrRightHeroAwakened()
  self.heroAwakenTipsText:SetActive(showAwakenTips)
  if showAwakenTips then
    self.heroAwakenTipsText:SetLocalText("hero_awaken_desc_20")
  end
end

function UIActHeroLevelAndStarReplace:GetAllNeedExcludeHero()
  local result = {}
  if self.leftHeroUuid then
    table.insert(result, self.leftHeroUuid)
  end
  if self.rightHeroUuid then
    table.insert(result, self.rightHeroUuid)
  end
  local allHeroList = DataCenter.HeroDataManager:GetAllHeroIdList(result)
  for _, v in ipairs(allHeroList) do
    local heroId = toInt(v)
    local isCanExchange = self.allCanExchangeHeroIdList[heroId]
    local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(heroId)
    if isCanExchange and heroData and not self:CheckHeroIsInCity(heroData.uuid) then
      isCanExchange = false
    end
    if isCanExchange and heroData and heroData:IsHeroAwakened() then
      isCanExchange = false
    end
    if not isCanExchange then
      local heroUuid = DataCenter.HeroDataManager:GetHeroUuidByHeroId(heroId)
      if heroUuid then
        table.insert(result, heroUuid)
      end
    end
  end
  return result
end

function UIActHeroLevelAndStarReplace:CheckHeroIsInCity(heroUuid)
  local heroSquadInfo = DataCenter.ArmyFormationDataManager:GetHeroFormationInfoBySquadIndex(heroUuid)
  if not heroSquadInfo then
    return true
  end
  return heroSquadInfo.state == ArmyFormationState.Free
end

function UIActHeroLevelAndStarReplace:OnExchangeSuccess(param)
  self.clickBlockObj:SetActive(true)
  UIGray.SetGray(self.replaceBtn.transform, true, false)
  self.exchangeSuccessAniDelayTimer = TimerManager:GetInstance():DelayInvoke(function()
    self:DoExchangeSuccessAni(param)
  end, 0.2)
end

function UIActHeroLevelAndStarReplace:DoExchangeSuccessAni(param)
  self.circleOutEff:Replay()
  self.mergeEff:Replay()
  self:OnStartChange()
  local ret, time = self.simpleAni:PlayAnimationReturnTime("Convert")
  
  local function exchangeSuccessFunc()
    self.leftHeroUuid = nil
    self.rightHeroUuid = nil
    self.leftSelectSlot:SetEmptyState()
    self.rightSelectSlot:SetEmptyState()
    self:RefreshTipText()
    UIManager:GetInstance():OpenWindow(UIWindowNames.ExchangeHeroSuccess, {anim = false}, param)
    self.clickBlockObj:SetActive(false)
    UIGray.SetGray(self.replaceBtn.transform, false, true)
  end
  
  local function playHeroDisplayAniFunc()
    self.leftSelectSlot:ShowHeroAfterChange()
    self.rightSelectSlot:ShowHeroAfterChange()
    self.heroDisplayTimer = TimerManager:GetInstance():DelayInvoke(function()
      exchangeSuccessFunc()
    end, 1.5)
  end
  
  if ret then
    self.exchangeSuccessTimer = TimerManager:GetInstance():DelayInvoke(function()
      playHeroDisplayAniFunc()
    end, time)
  else
    exchangeSuccessFunc()
  end
end

function UIActHeroLevelAndStarReplace:OnStartChange()
  self.circleInEffPointObj:SetActive(false)
  self.leftSelectSlot:OnStartExchange()
  self.rightSelectSlot:OnStartExchange()
end

function UIActHeroLevelAndStarReplace:RefreshBottomBtn()
  if not self.activityInfo or string.IsNullOrEmpty(self.activityInfo.para) then
    return
  end
  local costItemInfo = self.activityInfo.para
  if not string.IsNullOrEmpty(costItemInfo) then
    local items = string.split(costItemInfo, "|")
    if items then
      local itemId = items[1]
      local count = items[2]
      if itemId and count then
        self.costItemId = itemId
        self.costCount = count
        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
        local item = DataCenter.ItemData:GetItemById(itemId)
        Logger.Log("itemId : " .. tostring(itemId))
        self.img_cost_item1:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
        if item then
          self.text_cost1:SetText(tostring(item.count) .. "/" .. tostring(count))
          if item.count >= tonumber(count) then
            self.canExchange = true
          else
            self.canExchange = false
          end
        else
          self.text_cost1:SetText(tostring(0) .. "/" .. tostring(count))
          self.canExchange = false
        end
      end
    end
  end
end

function UIActHeroLevelAndStarReplace:ShowHeroExchangeGuide()
  local param = {}
  param.activityId = self.activityId
  UIManager:GetInstance():OpenWindow(UIWindowNames.HeroExchangeGuide, {anim = true}, param)
end

function UIActHeroLevelAndStarReplace:CheckIsNeedShowGuide()
  local isReceivedReward = DataCenter.ActExchangeHeroDataManager:GetReceiveRewardState(self.activityId)
  if not isReceivedReward then
    self:ShowHeroExchangeGuide()
  end
end

function UIActHeroLevelAndStarReplace:StopAllTimer()
  if self.exchangeSuccessTimer then
    self.exchangeSuccessTimer:Stop()
    self.exchangeSuccessTimer = nil
  end
  if self.heroDisplayTimer then
    self.heroDisplayTimer:Stop()
    self.heroDisplayTimer = nil
  end
  if self.exchangeSuccessAniDelayTimer then
    self.exchangeSuccessAniDelayTimer:Stop()
    self.exchangeSuccessAniDelayTimer = nil
  end
  if self.showAllHeroSelectEffTimer then
    self.showAllHeroSelectEffTimer:Stop()
    self.showAllHeroSelectEffTimer = nil
  end
end

function UIActHeroLevelAndStarReplace:IsLeftOrRightHeroAwakened()
  if self.leftHeroUuid then
    local heroDataL = DataCenter.HeroDataManager:GetHeroByUuid(self.leftHeroUuid)
    if heroDataL and heroDataL:IsHeroAwakened() then
      return true
    end
  end
  if self.rightHeroUuid then
    local heroDataR = DataCenter.HeroDataManager:GetHeroByUuid(self.rightHeroUuid)
    if heroDataR and heroDataR:IsHeroAwakened() then
      return true
    end
  end
  return false
end

return UIActHeroLevelAndStarReplace
