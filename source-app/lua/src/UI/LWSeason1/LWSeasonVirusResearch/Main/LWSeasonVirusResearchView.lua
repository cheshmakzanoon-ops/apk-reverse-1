local base = UIBaseContainer
local LWSeasonVirusResearchView = BaseClass("LWSeasonVirusResearchView", base)
local Localization = CS.GameEntry.Localization
local RewardUtil = require("Util.RewardUtil")
local UIGray = CS.UIGray
local TacticalWeaponCriticalItem = require("UI.UILWTacticalWeapon.Component.TacticalWeaponCriticalItem")
local img_item_icon_path = "Content/Detail/Top/ItemPanel/img_item_icon"
local txt_item_count_path = "Content/Detail/Top/ItemPanel/txt_item_count"
local txt_remainTime_path = "Content/Detail/ContentTime/TimeTextBg/remainTime"
local txt_level_path = "Content/Bottom/InfoPanel/LevelPanel/txt_level"
local txt_TxtMax_path = "Content/Bottom/InfoPanel/LevelPanel/TxtMax"
local sli_slider_progress_path = "Content/Bottom/InfoPanel/SliderPanel/slider_progress"
local img_icon_path = "Content/Bottom/InfoPanel/SliderPanel/img_icon"
local txt_progress_path = "Content/Bottom/InfoPanel/SliderPanel/txt_progress"
local btn_reward_box_path = "Content/Bottom/InfoPanel/SliderPanel/btn_reward_box"
local img_cost_icon1_path = "Content/Bottom/InfoPanel/CostPanel/img_root/img_cost_icon1"
local txt_cost_count1_path = "Content/Bottom/InfoPanel/CostPanel/txt_cost_count1"
local img_cost_icon2_path = "Content/Bottom/InfoPanel/CostPanel/img_root/img_cost_icon2"
local txt_cost_count2_path = "Content/Bottom/InfoPanel/CostPanel/txt_cost_count2"
local btn_Research_path = "Content/Bottom/btn_Research"
local img_RedDot_path = "Content/Bottom/btn_Research/RedDot"
local btn_Max_path = "Content/Bottom/btn_Max"
local txt_cost_path = "Content/Bottom/btn_Research/txt_cost"
local txt_title_path = "Content/Detail/txt_title"
local txt_ContentDes_path = "Content/Detail/ContentDes"
local txt_resistance_path = "Content/Bottom/InfoPanel/Resistance/txt_resistance"
local txt_next_resistance_path = "Content/Bottom/InfoPanel/Resistance/txt_next_resistance"
local img_go_next_reistance_path = "Content/Bottom/InfoPanel/Resistance/go_next_reistance"
local img_btn_cost_icon_path = "Content/Bottom/btn_Research/txt_cost/img_btn_cost_icon"
local btn_IntroBtn_path = "Content/Detail/IntroBtn"
local go_HitItemContainer_path = "Content/Bottom/InfoPanel/HitItemContainer"
local go_HitItem_path = "Content/Bottom/InfoPanel/HitItem"
local go_tran_flyPos_path = "Content/Bottom/InfoPanel/CostPanel/tran_flyPos"
local go_CostPanel_path = "Content/Bottom/InfoPanel/CostPanel"
local img_img_reward_box_path = "Content/Bottom/InfoPanel/SliderPanel/btn_reward_box/img _reward_box"
local go_img_root_path = "Content/Bottom/InfoPanel/CostPanel/img_root"
local btn_cost_path = "Content/Bottom/InfoPanel/CostPanel/img_root/img_cost_icon2/btn_cost"
local anim_Content_path = "Content"
local go_Eff_LWSeasonVirusResearch_Box_Open_path = "Content/Bottom/InfoPanel/SliderPanel/Eff_LWSeasonVirusResearch_Box_Open"
local anim_Root_path = "Content/Bottom/InfoPanel/SliderPanel/Eff_LWSeasonVirusResearch_Box_Open/Root"
local go_Eff_LWSeasonVirusResearch_Bg_Flash_path = "Content/Bg/Mask/BgTop/Eff_LWSeasonVirusResearch_Bg _Flash"
local go_Mask_path = "Content/Bg/Mask"
local go_banner_01_path = "Content/Bg/banner_01"
local cg_Detail_path = "Content/Detail"
local cg_Bottom_path = "Content/Bottom"
local go_BgTop_path = "Content/Bg/Mask/BgTop"
local go_Eff_LWSeasonVirusResearch_Bg_path = "Content/Bg/Mask/BgTop/Eff_LWSeasonVirusResearch_Bg"

function LWSeasonVirusResearchView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWSeasonVirusResearchView:OnDestroy()
  self:ClearHitItems()
  if self.animTimer ~= nil then
    self.animTimer:Stop()
    self.animTimer = nil
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWSeasonVirusResearchView:ComponentDefine()
  self.img_item_icon = self:AddComponent(UIImage, img_item_icon_path)
  self.txt_item_count = self:AddComponent(UIText, txt_item_count_path)
  self.txt_remainTime = self:AddComponent(UIText, txt_remainTime_path)
  self.txt_level = self:AddComponent(UIText, txt_level_path)
  self.txt_TxtMax = self:AddComponent(UIText, txt_TxtMax_path)
  self.sli_slider_progress = self:AddComponent(UISlider, sli_slider_progress_path)
  self.img_icon = self:AddComponent(UIImage, img_icon_path)
  self.txt_progress = self:AddComponent(UIText, txt_progress_path)
  self.btn_reward_box = self:AddComponent(UIButton, btn_reward_box_path)
  self.img_cost_icon1 = self:AddComponent(UIImage, img_cost_icon1_path)
  self.txt_cost_count1 = self:AddComponent(UITextMeshProUGUI, txt_cost_count1_path)
  self.img_cost_icon2 = self:AddComponent(UIImage, img_cost_icon2_path)
  self.txt_cost_count2 = self:AddComponent(UITextMeshProUGUI, txt_cost_count2_path)
  self.btn_Research = self:AddComponent(UIButton, btn_Research_path)
  self.img_RedDot = self:AddComponent(UIImage, img_RedDot_path)
  self.btn_Max = self:AddComponent(UIButton, btn_Max_path)
  self.txt_cost = self:AddComponent(UIText, txt_cost_path)
  self.txt_title = self:AddComponent(UIText, txt_title_path)
  self.txt_ContentDes = self:AddComponent(UIText, txt_ContentDes_path)
  self.txt_resistance = self:AddComponent(UIText, txt_resistance_path)
  self.txt_next_resistance = self:AddComponent(UIText, txt_next_resistance_path)
  self.img_go_next_reistance = self:AddComponent(UIImage, img_go_next_reistance_path)
  self.img_btn_cost_icon = self:AddComponent(UIImage, img_btn_cost_icon_path)
  self.btn_IntroBtn = self:AddComponent(UIButton, btn_IntroBtn_path)
  self.go_HitItemContainer = self:AddComponent(UIBaseContainer, go_HitItemContainer_path)
  self.go_HitItem = self:AddComponent(UIBaseContainer, go_HitItem_path)
  self.go_tran_flyPos = self:AddComponent(UIBaseContainer, go_tran_flyPos_path)
  self.go_CostPanel = self:AddComponent(UIBaseContainer, go_CostPanel_path)
  self.img_img_reward_box = self:AddComponent(UIImage, img_img_reward_box_path)
  self.go_img_root = self:AddComponent(UIBaseContainer, go_img_root_path)
  self.btn_cost = self:AddComponent(UIButton, btn_cost_path)
  self.anim_Content = self:AddComponent(UISimpleAnimation, anim_Content_path)
  self.go_Eff_LWSeasonVirusResearch_Box_Open = self:AddComponent(UIBaseContainer, go_Eff_LWSeasonVirusResearch_Box_Open_path)
  self.anim_Root = self:AddComponent(UISimpleAnimation, anim_Root_path)
  self.go_Eff_LWSeasonVirusResearch_Bg_Flash = self:AddComponent(UIBaseContainer, go_Eff_LWSeasonVirusResearch_Bg_Flash_path)
  self.go_Mask = self:AddComponent(UIBaseContainer, go_Mask_path)
  self.go_banner_01 = self:AddComponent(UIBaseContainer, go_banner_01_path)
  self.cg_Detail = self:AddComponent(UICanvasGroup, cg_Detail_path)
  self.cg_Bottom = self:AddComponent(UICanvasGroup, cg_Bottom_path)
  self.go_BgTop = self:AddComponent(UIBaseContainer, go_BgTop_path)
  self.go_Eff_LWSeasonVirusResearch_Bg = self:AddComponent(UIBaseContainer, go_Eff_LWSeasonVirusResearch_Bg_path)
  self.btn_reward_box:SetOnClick(BindCallback(self, self.ClickRewardBox))
  self.btn_Research:SetOnClick(BindCallback(self, self.ClickResearch))
  self.btn_Max:SetOnClick(BindCallback(self, self.ClickMax))
  self.btn_IntroBtn:SetOnClick(BindCallback(self, self.ClickInfo))
  self.go_HitItem:SetActive(false)
  self.hitItemObj = self.go_HitItem.gameObject
  self.hitItemObj.gameObject:GameObjectCreatePool()
  self.btn_cost:SetOnClick(BindCallback(self, self.ClickCost))
  
  function self.timer_action(temp)
    self:RefreshTime(temp)
  end
  
  self.critItemFinshCallback = BindCallback(self, self.OnCriticalItemFinish)
  self.go_banner_01:SetActive(true)
  self.rectMask = self.go_Mask.transform:GetComponent(typeof(CS.UnityEngine.UI.RectMask2D))
  self:OnSetMaskPadding(false)
  self.go_Eff_LWSeasonVirusResearch_Box_Open:SetActive(false)
  self.go_Eff_LWSeasonVirusResearch_Bg:SetActive(true)
  self.btn_reward_box:SetActive(true)
  self.cg_Detail:SetAlpha(1)
  self.cg_Bottom:SetAlpha(1)
end

function LWSeasonVirusResearchView:ComponentDestroy()
  self.img_item_icon = nil
  self.txt_item_count = nil
  self.txt_remainTime = nil
  self.txt_level = nil
  self.txt_TxtMax = nil
  self.sli_slider_progress = nil
  self.img_icon = nil
  self.txt_progress = nil
  self.btn_reward_box = nil
  self.img_cost_icon1 = nil
  self.txt_cost_count1 = nil
  self.img_cost_icon2 = nil
  self.txt_cost_count2 = nil
  self.btn_Research = nil
  self.img_RedDot = nil
  self.btn_Max = nil
  self.txt_cost = nil
  self.txt_title = nil
  self.txt_ContentDes = nil
  self.txt_resistance = nil
  self.txt_next_resistance = nil
  self.img_go_next_reistance = nil
  self.img_btn_cost_icon = nil
  self.btn_IntroBtn = nil
  self.go_HitItemContainer = nil
  self.go_HitItem = nil
  self.go_tran_flyPos = nil
  self.go_CostPanel = nil
  self.img_img_reward_box = nil
  self.go_img_root = nil
  self.btn_cost = nil
  self.anim_Content = nil
  self.go_Eff_LWSeasonVirusResearch_Box_Open = nil
  self.anim_Root = nil
  self.go_Eff_LWSeasonVirusResearch_Bg_Flash = nil
  self.go_Mask = nil
  self.go_banner_01 = nil
  self.cg_Detail = nil
  self.cg_Bottom = nil
  self.go_BgTop = nil
  self.go_Eff_LWSeasonVirusResearch_Bg = nil
  if self.sliderTween then
    self.sliderTween:Kill()
    self.sliderTween = nil
  end
  self.critItemFinshCallback = nil
  self.activityId = nil
  self.data = nil
  self:DeleteTimer()
end

function LWSeasonVirusResearchView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonPreSpreadResearchInfo, self.HandleSeasonPreSpreadResearchInfo)
  self:AddUIListener(EventId.SeasonPreSpreadResearchExpChange, self.HandleSeasonPreSpreadResearchExpChange)
  self:AddUIListener(EventId.SeasonResearchLevelUpClose, self.SeasonResearchLevelUpCloseHandle)
end

function LWSeasonVirusResearchView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonPreSpreadResearchInfo, self.HandleSeasonPreSpreadResearchInfo)
  self:RemoveUIListener(EventId.SeasonPreSpreadResearchExpChange, self.HandleSeasonPreSpreadResearchExpChange)
  self:RemoveUIListener(EventId.SeasonResearchLevelUpClose, self.SeasonResearchLevelUpCloseHandle)
  base.OnRemoveListener(self)
end

function LWSeasonVirusResearchView:HandleSeasonPreSpreadResearchInfo()
  self:RefreshView()
end

function LWSeasonVirusResearchView:OnSetMaskPadding(open)
  local currentPadding = self.rectMask.padding
  if open then
    currentPadding.x = -10
    currentPadding.y = -400
    currentPadding.z = -10
    currentPadding.w = -100
  else
    currentPadding.z = 0
    currentPadding.w = 0
    currentPadding.x = 0
    currentPadding.y = 0
  end
  self.rectMask.padding = currentPadding
end

function LWSeasonVirusResearchView:SeasonResearchLevelUpCloseHandle()
  self.go_Eff_LWSeasonVirusResearch_Box_Open:SetActive(false)
  self.go_Eff_LWSeasonVirusResearch_Bg_Flash:SetActive(false)
  self.go_Eff_LWSeasonVirusResearch_Bg:SetActive(true)
  self.btn_reward_box:SetActive(true)
  self.go_banner_01:SetActive(true)
  self:OnSetMaskPadding(false)
  self.anim_Content:Play("out")
end

function LWSeasonVirusResearchView:HandleSeasonPreSpreadResearchExpChange(msg)
  self:RefreshView(true, msg.levelUp)
  if msg.levelUp then
    self.go_Eff_LWSeasonVirusResearch_Box_Open:SetActive(true)
    self.btn_reward_box:SetActive(false)
    local ok, _ = self.anim_Root:PlayAnimationReturnTime("Default")
    DataCenter.LWSoundManager:PlaySound(1000107, false)
    if ok then
      self.animTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.animTimer = nil
        self.anim_Content:Play("in")
        self.go_Eff_LWSeasonVirusResearch_Bg:SetActive(false)
        self.go_Eff_LWSeasonVirusResearch_Bg_Flash:SetActive(false)
        self.go_Eff_LWSeasonVirusResearch_Bg_Flash:SetActive(true)
        self:OnSetMaskPadding(true)
        self.go_banner_01:SetActive(false)
        DataCenter.LWSoundManager:PlaySound(1000108, false)
        UIManager:GetInstance():OpenWindow(UIWindowNames.LWSeasonVirusResearchLevelUp, {anim = true}, self)
      end, 1)
    end
  end
  DataCenter.LWSoundManager:PlaySound(1000104, false)
  local isMax = DataCenter.LWSpreadResearchDataManager:IsMax()
  if not isMax then
    local icon = "Assets/Main/SeasonRes/S1/Sprites/S1_Pre_Activity/fx_bingduyanjiu_yanjiujingyanzhi_icon.png"
    UIUtil.DoFly(RewardType.GOODS, 2, icon, self.go_CostPanel.transform.position, self.txt_progress.transform.position, nil, nil, function()
      DataCenter.LWSoundManager:PlaySound(1000105, false)
    end, nil, nil, nil, nil)
  end
  local currentConfig = DataCenter.LWSpreadResearchDataManager:GetCurrentLevelConfig()
  local rewardList = RewardUtil.GetRewardItem(currentConfig.research_reward)
  if 0 < #rewardList then
    local icon = DataCenter.ItemTemplateManager:GetIconPath(rewardList[1].itemId)
    UIUtil.DoFly(RewardType.GOODS, 2, icon, self.go_CostPanel.transform.position, self.go_tran_flyPos.transform.position, nil, nil, function()
      DataCenter.LWSoundManager:PlaySound(1000105, false)
    end, nil, nil, nil, nil)
  end
  if 1 < msg.critMul then
    DataCenter.LWSoundManager:PlaySound(1000106, false)
    self:ShowHitItem(msg.critMul)
  end
  if not isMax then
    self:FlyContent(msg.changeExp)
  end
end

function LWSeasonVirusResearchView:ClickRewardBox()
  local currentConfig = DataCenter.LWSpreadResearchDataManager:GetCurrentLevelConfig()
  if currentConfig.level_up_reward ~= nil then
    local rewardList = RewardUtil.GetRewardItem(currentConfig.level_up_reward)
    if rewardList and 0 < #rewardList then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIRewardContentTip, {anim = true}, self.btn_reward_box, rewardList, 0, 22, true)
    end
  end
end

function LWSeasonVirusResearchView:ClickResearch()
  if self.animTimer ~= nil then
    return
  end
  if DataCenter.LWSpreadResearchDataManager:IsEnd() then
    UIUtil.ShowTipsId(370100)
    return
  end
  local currentConfig = DataCenter.LWSpreadResearchDataManager:GetCurrentLevelConfig()
  local itemId = currentConfig.research_cost.itemId
  local needCount = currentConfig.research_cost.count
  local hasCount = DataCenter.ItemData:GetItemCount(itemId)
  if needCount > hasCount then
    LWResourceLackUtil:GotoGoodsItemLack(itemId, needCount - hasCount)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.SeasonVirusResearchLevelUp)
end

function LWSeasonVirusResearchView:ClickInfo()
  local param = {}
  param.activityId = self.activityId
  param.activityRulesStr = Localization:GetString("activity_s1pre_virus_study_desc")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function LWSeasonVirusResearchView:ClickCost()
  local currentConfig = DataCenter.LWSpreadResearchDataManager:GetCurrentLevelConfig()
  local research_reward = currentConfig.research_reward
  local rewardList = RewardUtil.GetRewardItem(research_reward)
  local param = rewardList[1]
  param.itemId = param.itemId
  param.alignObject = self.btn_cost
  param.hideHaveCountShow = param.hideHaveCountShow
  param.showUse = param.showUse
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

function LWSeasonVirusResearchView:ClickMax()
end

function LWSeasonVirusResearchView:SetData(activityId)
  self.activityId = activityId
  if not self.activityId then
    return
  end
  self.data = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.data == nil then
    return
  end
  if self.data then
    local name = Localization:GetString(self.data.name)
    self.txt_title:SetText(name)
    self.txt_ContentDes:SetLocalText(self.data.bannerTittle)
    self:AddTimer(self.data)
  end
  self.startTime = self.data.startTime
  self.endTime = self.data.endTime
  self:RefreshView()
  self:RefreshTime()
  SFSNetwork.SendMessage(MsgDefines.GetSeasonVirusResearchInfo)
end

function LWSeasonVirusResearchView:RefreshView(anim, isLevelUp)
  if not DataCenter.LWSpreadResearchDataManager:IsVail() then
    return
  end
  local currentConfig = DataCenter.LWSpreadResearchDataManager:GetCurrentLevelConfig()
  local nextConfig = DataCenter.LWSpreadResearchDataManager:GetNextLevelConfig()
  local itemId = currentConfig.research_cost.itemId
  local icon = DataCenter.ItemTemplateManager:GetIconPath(itemId)
  self.img_item_icon:LoadSprite(icon)
  local itemCount = DataCenter.ItemData:GetItemCount(itemId)
  self.txt_item_count:SetText(tostring(itemCount))
  self.txt_cost:SetText(tostring(currentConfig.research_cost.count))
  if itemCount >= currentConfig.research_cost.count then
    self.txt_cost:SetColorHex("#FFFFFF")
  else
    self.txt_cost:SetColorHex("#F97077")
  end
  self.img_btn_cost_icon:LoadSprite(icon)
  local isMax = DataCenter.LWSpreadResearchDataManager:IsMax()
  local currentLevel = DataCenter.LWSpreadResearchDataManager:GetCurrentLevel()
  self.txt_level:SetLocalText("treasure_lvup_showmax", tostring(currentLevel))
  self.img_go_next_reistance:SetActive(not isMax)
  self.txt_next_resistance:SetActive(not isMax)
  self.txt_resistance:SetText(currentConfig.resistance)
  if not isMax then
    self.txt_next_resistance:SetText(nextConfig.resistance)
  end
  if self.sliderTween then
    self.sliderTween:Kill()
    self.sliderTween = nil
  end
  local currentExp = DataCenter.LWSpreadResearchDataManager:GetExp()
  if isMax then
    if anim then
      self.sliderTween = self.sli_slider_progress:DOValue(1, 0.2, function()
        self.sliderTween = nil
      end)
    else
      self.sli_slider_progress:SetValue(1)
    end
    self.txt_progress:SetLocalText("activity_s1pre_virus_study_maxlevel")
  else
    local nextValue = isLevelUp and 1 or currentExp / currentConfig.level_up_exp
    if anim then
      self.sliderTween = self.sli_slider_progress:DOValue(nextValue, 0.2, function()
        self.sli_slider_progress:SetValue(currentExp / currentConfig.level_up_exp)
        self.sliderTween = nil
      end)
    else
      self.sli_slider_progress:SetValue(currentExp / currentConfig.level_up_exp)
    end
    self.txt_progress:SetLocalText("135225", string.GetFormattedSeparatorNum(currentExp), string.GetFormattedSeparatorNum(currentConfig.level_up_exp))
  end
  local research_reward = currentConfig.research_reward
  local rewardList = RewardUtil.GetRewardItem(research_reward)
  local addExp = currentConfig.research_add_exp
  self.txt_cost_count1:SetText(tostring(addExp))
  local hasReward = 0 < #rewardList
  if hasReward then
    local icon = DataCenter.ItemTemplateManager:GetIconPath(rewardList[1].itemId)
    self.img_cost_icon2:LoadSprite(icon)
    self.txt_cost_count2:SetText(rewardList[1].count)
  end
  self.img_cost_icon2:SetActive(hasReward)
  self.txt_cost_count2:SetActive(hasReward)
  self.img_cost_icon1:SetActive(not isMax)
  self.go_img_root:SetActive(not isMax)
  self.txt_cost_count1:SetActive(not isMax)
  self.txt_TxtMax:SetActive(isMax)
  if isMax then
    self.img_img_reward_box:LoadSprite("Assets/Main/Sprites/UI/UIDailyPack/UI_dispatch_rewarda.png")
  else
    self.img_img_reward_box:LoadSprite("Assets/Main/Sprites/UI/UIDailyPack/UI_dispatch_reward.png")
  end
  self.img_RedDot:SetActive(itemCount >= tonumber(currentConfig.research_cost.count))
end

function LWSeasonVirusResearchView:RefreshTime()
  local data = self.data
  if data then
    local deltaTime = 0
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < self.startTime then
      deltaTime = self.startTime - curTime
    elseif curTime < self.endTime then
      deltaTime = self.endTime - curTime
    end
    if 0 < deltaTime then
      local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      self.txt_remainTime:SetText(showTime)
    else
      self.txt_remainTime:SetText("00:00:00")
      self:DeleteTimer()
    end
  else
    self:DeleteTimer()
  end
end

function LWSeasonVirusResearchView:AddTimer(actListData)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, actListData, false, false, false)
  end
  self.timer:Start()
end

function LWSeasonVirusResearchView:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function LWSeasonVirusResearchView:RefreshTime()
  local data = self.data
  if data then
    local deltaTime = 0
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < self.startTime then
      deltaTime = self.startTime - curTime
    elseif curTime < self.endTime then
      deltaTime = self.endTime - curTime
    end
    if 0 < deltaTime then
      local showTime = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      self.txt_remainTime:SetText(showTime)
    else
      self.txt_remainTime:SetText("00:00:00")
      self:DeleteTimer()
    end
  else
    self:DeleteTimer()
  end
end

function LWSeasonVirusResearchView:GetIndex()
  if self.itemIndex == nil then
    self.itemIndex = 0
  else
    self.itemIndex = self.itemIndex + 1
  end
  return self.itemIndex
end

function LWSeasonVirusResearchView:GetHitItem()
  if self.cachedItems and #self.cachedItems > 0 then
    local item = self.cachedItems[1]
    table.remove(self.cachedItems, 1)
    return item
  end
  local item = self.hitItemObj:GameObjectSpawn(self.go_HitItemContainer.transform)
  item.name = "item_gold_hit" .. self:GetIndex(self)
  local hit = self.go_HitItemContainer:AddComponent(TacticalWeaponCriticalItem, item.name)
  return hit
end

function LWSeasonVirusResearchView:FlyContent(addExp)
  local position = self.sli_slider_progress.transform.position
  local srcPos = Vector3.New(position.x, position.y, position.z)
  local uiScale = UIManager:GetInstance():GetScaleFactor()
  local endPos = Vector3.New(position.x, position.y + 40 * uiScale, position.z)
  local context = FlyTextContext.New()
  context:SetText(string.format("<color=#5fef87>+%s</color>", addExp))
  context:SetSrcPos(srcPos)
  context:SetDstPos(endPos)
  context:SetSrcScale(1.2)
  context:SetDstScale(1.2)
  context:SetFontSize(32)
  context:SetMoveTime(1.6)
  context:SetStartDelayTime(0.1)
  context:SetIconIsLeft(true)
  UIUtil.DoFlyText(context)
end

function LWSeasonVirusResearchView:ShowHitItem(critMul)
  local item = self:GetHitItem(self)
  item.hitText2:SetText(tostring(critMul))
  if item and not IsNull(item.transform) then
    item.transform:SetAsLastSibling()
  end
  item:Show(-1, self.critItemFinshCallback)
end

function LWSeasonVirusResearchView:ClearHitItems()
  self.go_HitItemContainer:RemoveComponents(TacticalWeaponCriticalItem)
  if not IsNull(self.hitItemObj) then
    self.hitItemObj.gameObject:GameObjectRecycleAll()
  end
  self.cachedItems = {}
end

function LWSeasonVirusResearchView:OnCriticalItemFinish(item)
  if self.cachedItems == nil then
    self.cachedItems = {}
  end
  table.insert(self.cachedItems, item)
end

return LWSeasonVirusResearchView
