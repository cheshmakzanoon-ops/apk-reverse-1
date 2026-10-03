local UILWActPeriodicCard = BaseClass("UILWActPeriodicCard", UIBaseView)
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local LWBtnBuyRefundRemind = require("UI.LWBtnBuyRefundRemind.LWBtnBuyRefundRemind")
local Resource = CS.GameEntry.Resource
local base = UIBaseView
local UnityTextMeshProEx = typeof(CS.TextMeshProUGUIEx)
local Localization = CS.GameEntry.Localization
local reward_path = "content/nowReward/ScrollView/Viewport/Content/reward"
local daily_reward_path = "content/dailyReward/DailyScrollView/Viewport/Content/dailyReward"
local privilege_item_path = "content/privilegeItem"
local privilege_list_path = "content/privilegeList"
local day_text_path = "content/Time/layout/DayText"
local warnning_des_path = "content/warnningDes"
local buy_button_path = "content/BuyButton"
local claim_btn_path = "content/claimBtn"
local price_text_path = "content/BuyButton/PriceText"
local free_reward_path = "content/dailyFree/freeReward"
local v_f_x_ui_zhoukabaoxiang_xiao_path = "content/dailyFree/freeReward/VFX_ui_zhoukabaoxiang_xiao"
local unopen_path = "content/dailyFree/freeReward/unopen"
local opened_path = "content/dailyFree/freeReward/opened"
local v_f_x_ui_zhoukabaoxiang_xiao_open_path = "content/dailyFree/freeReward/VFX_ui_zhoukabaoxiang_xiaoOpen"
local claim_btn_txt_path = "content/claimBtn/claimBtnTxt"
local title_path = "content/title"
local daily_reward_des_path = "content/dailyReward/dailyRewardDes"
local discount_text_path = "content/DiscountInfo/Bg/DiscountText"
local diamond_count_path = "content/nowReward/diamond/diamondCount"
local content_path = "content"
local ui_gift_package_point_path = "content/BuyButton/UIGiftPackagePoint"
local claim_red_dot_path = "content/claimBtn/RedDot"

function UILWActPeriodicCard:OnCreate()
  base.OnCreate(self)
  self.refreshStatic = false
  self:ComponentDefine()
end

function UILWActPeriodicCard:OnDestroy()
  self:ComponentDestroy()
  self.refreshStatic = nil
  base.OnDestroy(self)
end

function UILWActPeriodicCard:OnEnable()
  base.OnEnable(self)
end

function UILWActPeriodicCard:OnDisable()
  base.OnDisable(self)
end

function UILWActPeriodicCard:ComponentDefine()
  self.privilege_item = self.transform:Find(privilege_item_path).gameObject
  self.privilege_item:GameObjectCreatePool()
  self.privilege_list = self:AddComponent(UIBaseContainer, privilege_list_path)
  self.day_text = self:AddComponent(UITextMeshProUGUIEx, day_text_path)
  self.warnning_des = self:AddComponent(UITextMeshProUGUIEx, warnning_des_path)
  self.discount_text = self:AddComponent(UITextMeshProUGUIEx, discount_text_path)
  self.diamond_count = self:AddComponent(UITextMeshProUGUIEx, diamond_count_path)
  self.claim_btn_txt = self:AddComponent(UITextMeshProUGUIEx, claim_btn_txt_path)
  self.claim_red_dot = self:AddComponent(UIBaseContainer, claim_red_dot_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.daily_reward_des = self:AddComponent(UITextMeshProUGUIEx, daily_reward_des_path)
  self.rewardsTb = {}
  for i = 1, 6 do
    local newReward = self:AddComponent(UICommonResItem, reward_path .. i)
    table.insert(self.rewardsTb, newReward)
  end
  self.dailyRewardsTb = {}
  for i = 1, 7 do
    local newReward = self:AddComponent(UICommonResItem, daily_reward_path .. i)
    table.insert(self.dailyRewardsTb, newReward)
  end
  self.buy_button = self:AddComponent(LWBtnBuyRefundRemind, buy_button_path)
  self.buy_button:SetBuyClickAction(function()
    self:OnBuyBtnClick()
  end)
  self.claim_btn = self:AddComponent(UIButton, claim_btn_path)
  self.claim_btn:SetSafeClickMode(true)
  self.claim_btn:SetOnClick(function()
    self:OnTodayClaimBtnClick()
  end)
  self.free_reward = self:AddComponent(UIButton, free_reward_path)
  self.free_reward_ani = self:AddComponent(UIAnimator, free_reward_path)
  self.free_reward:SetSafeClickMode(true)
  self.free_reward:SetOnClick(function()
    self:FreeBtnClick()
  end)
  self.v_f_x_ui_zhoukabaoxiang_xiao = self:AddComponent(UIBaseContainer, v_f_x_ui_zhoukabaoxiang_xiao_path)
  self.unopen = self:AddComponent(UIImage, unopen_path)
  self.opened = self:AddComponent(UIImage, opened_path)
  self.v_f_x_ui_zhoukabaoxiang_xiao_open = self:AddComponent(UIBaseContainer, v_f_x_ui_zhoukabaoxiang_xiao_open_path)
  self.ani_in = self:TryAddComponent(UIAnimator, "")
  if self.ani_in then
    if CommonUtil.IsArabicAutoMirrorOpen() then
      self.ani_in:Play("An_UIActSeasonPeriodicCardIce_in_a", 0, 0)
    else
      self.ani_in:Play("An_UIActSeasonPeriodicCardIce_in", 0, 0)
    end
  end
end

function UILWActPeriodicCard:ComponentDestroy()
  self.privilege_item:GameObjectRecycleAll()
  self.privilege_item = nil
  self.rewardsTb = nil
  self.dailyRewardsTb = nil
  self.privilege_list = nil
  self.day_text = nil
  self.warnning_des = nil
  self.buy_button = nil
  self.claim_btn = nil
  self.free_reward = nil
  self.v_f_x_ui_zhoukabaoxiang_xiao = nil
  self.unopen = nil
  self.opened = nil
  self.v_f_x_ui_zhoukabaoxiang_xiao_open = nil
  self.claim_btn_txt = nil
  self.title = nil
  self.daily_reward_des = nil
  self.discount_text = nil
  self.diamond_count = nil
  self.content = nil
  self.claim_red_dot = nil
end

function UILWActPeriodicCard:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.LWSeasonWeekCardInfo, self.WeekDataUpdate)
  self:AddUIListener(EventId.LWSeasonWeekCardInfoUpdate, self.WeekDataUpdate)
  self:AddUIListener(EventId.LWSeasonWeekCardFreeRewardUpdate, self.FreeRewardUpdate)
  if CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    self:AddUIListener(EventId.LWSeasonWeekCardDailyRewardUpdate, self.DailyRewardUpdate)
  end
end

function UILWActPeriodicCard:OnRemoveListener()
  self:RemoveUIListener(EventId.LWSeasonWeekCardInfo, self.WeekDataUpdate)
  self:RemoveUIListener(EventId.LWSeasonWeekCardInfoUpdate, self.WeekDataUpdate)
  self:RemoveUIListener(EventId.LWSeasonWeekCardFreeRewardUpdate, self.FreeRewardUpdate)
  if CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
    self:RemoveUIListener(EventId.LWSeasonWeekCardDailyRewardUpdate, self.DailyRewardUpdate)
  end
  base.OnRemoveListener(self)
end

function UILWActPeriodicCard:RefreshRewards()
  for i, v in ipairs(self.rewardsTb) do
    if i <= #self.rewardsList then
      v:SetActive(true)
      v:ReInit(self.rewardsList[i])
    else
      v:SetActive(false)
    end
  end
  for i, v in ipairs(self.dailyRewardsTb) do
    if i <= #self.dailyRewardsList then
      v:SetActive(true)
      v:ReInit(self.dailyRewardsList[i])
    else
      v:SetActive(false)
    end
  end
end

function UILWActPeriodicCard:RefreshPrivilege()
  self.privilege_item:GameObjectRecycleAll()
  if self.PrivilegeData then
    for i, v in ipairs(self.PrivilegeData) do
      local effectItem = self.privilege_item:GameObjectSpawn()
      effectItem:SetActive(true)
      effectItem.transform:SetParent(self.privilege_list.transform)
      effectItem.transform:Set_localScale(1, 1, 1)
      local textTrans = effectItem.transform:Find("Des")
      local unity_text = textTrans.gameObject:GetComponent(UnityTextMeshProEx)
      unity_text.text = v
    end
  end
end

function UILWActPeriodicCard:SetData(activityId, activityInfo)
  self.activityInfo = activityInfo
  self.cardId = tonumber(activityInfo.para)
  self.cardData = DataCenter.SeasonPeriodicCardManager:GetCardData(self.cardId)
  if self.cardData then
    self:RefreshPanel()
  else
    self.content:SetActive(false)
    SFSNetwork.SendMessage(MsgDefines.LWSeasonWeekCardInfo, self.cardId)
  end
end

function UILWActPeriodicCard:RefreshPanel()
  self.content:SetActive(true)
  local weekConfig = LocalController:instance():getLine(TableName.Season_Week_Card, self.cardData.cardId)
  if not self.refreshStatic then
    if weekConfig then
      self.rewardsList = {}
      local strRewards = weekConfig.reward_show_now or ""
      self.rewardsList = DataCenter.RewardManager:ParseRewardsStr(strRewards)
      local specialReward = weekConfig.special_goods_show
      if not string.IsNullOrEmpty(weekConfig.special_goods_show) then
        local rewards = string.split(weekConfig.special_goods_show, "|")
        if 0 < #rewards then
          for key, value in pairs(rewards) do
            local itemId = toInt(value)
            for key1, value1 in pairs(self.rewardsList) do
              if value1.itemId == itemId then
                value1.hideHaveCountShow = true
              end
            end
          end
        end
      end
      self.dailyRewardsList = {}
      strRewards = weekConfig.reward_show_daily or ""
      self.dailyRewardsList = DataCenter.RewardManager:ParseRewardsStr(strRewards)
      self.PrivilegeData = {}
      local rightDes = weekConfig.right_des
      if weekConfig.right_des then
        for index, value in ipairs(weekConfig.right_des) do
          self.PrivilegeData[index] = Localization:GetString(value)
        end
      end
    end
    self:RefreshRewards()
    self:RefreshPrivilege()
  end
  self.title:SetText(Localization:GetString(weekConfig.name))
  self:RefreshBtns()
  self:RefreshDailyBox()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local settleTime = DataCenter.SeasonDataManager:GetSeasonSettleTime()
  local remainTime = settleTime - curTime
  local days = math.ceil(remainTime / (OneDayTime * 1000))
  local timeInt = tonumber(weekConfig.time)
  if days < timeInt and 0 < days then
    self.warnning_des:SetText(Localization:GetString("season_week_card_008", days))
    self.warnning_des:SetActive(true)
  else
    self.warnning_des:SetActive(false)
  end
  local packageData = self.cardData:GetPackageData()
  if packageData then
    self.discount_text:SetText(toInt(packageData:getPercent()))
    self.diamond_count:SetText(string.format("%s+", packageData:getDiamond()))
  else
    self.discount_text:SetText("")
    self.diamond_count:SetText("")
  end
end

function UILWActPeriodicCard:RefreshBtns()
  if self.cardData then
    local weekConfig = LocalController:instance():getLine(TableName.Season_Week_Card, self.cardData.cardId)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.cardData:IsBought() then
      local remainTime = self.cardData.endTime - curTime
      local days = math.ceil(remainTime / (OneDayTime * 1000))
      self.day_text:SetText(days)
      self.buy_button:SetActive(false)
      self.claim_btn:SetActive(true)
      if CS.ClientSwitch.IsOn(CS.ClientSwitch.DISABLE_RED_POINT_TREE) then
        if self.cardData:IsTodayClaimed() then
          self.claim_btn_txt:SetLocalText("2000411")
          CS.UIGray.SetGray(self.claim_btn.transform, true, false)
          self.claim_red_dot:SetActive(false)
        else
          self.claim_btn_txt:SetLocalText("2000157")
          self.claim_red_dot:SetActive(true)
          CS.UIGray.SetGray(self.claim_btn.transform, false, true)
        end
      else
        self:BindRedPoint(self.OnRPDailyGift, {
          RedDef.Season,
          tostring(self.activityInfo.activityId),
          RedDef.SeasonWeekDailyGift
        })
      end
    else
      self.buy_button:SetActive(true)
      self.claim_btn:SetActive(false)
      self.day_text:SetText(weekConfig.time)
      local packageData = self.cardData:GetPackageData()
      if packageData then
        self.buy_button:Init(packageData)
      else
        self.buy_button:SetPriceText("")
      end
      self.buy_button:RefreshPoint()
    end
  end
end

function UILWActPeriodicCard:RefreshDailyBox()
  if self.cardData then
    if self.cardData:IsTodayClaimedFree() then
      self.canGet = false
      self.free_reward_ani:Play("V_ui_zhoukabaoxiang_01_opened", 0, 0)
      self.opened:SetActive(true)
      self.unopen:SetActive(false)
    else
      self.canGet = true
      self.free_reward_ani:Play("V_ui_zhoukabaoxiang_01_idle", 0, 0)
      self.opened:SetActive(false)
      self.unopen:SetActive(true)
    end
  else
    self.canGet = false
  end
end

function UILWActPeriodicCard:OnRPDailyBox(count)
  if count <= 0 then
    self.canGet = false
    self.free_reward_ani:Play("V_ui_zhoukabaoxiang_01_opened", 0, 0)
    self.opened:SetActive(true)
    self.unopen:SetActive(false)
  else
    self.canGet = true
    self.free_reward_ani:Play("V_ui_zhoukabaoxiang_01_idle", 0, 0)
    self.opened:SetActive(false)
    self.unopen:SetActive(true)
  end
end

function UILWActPeriodicCard:OnRPDailyGift(count)
  if count <= 0 then
    self.claim_btn_txt:SetLocalText("2000411")
    CS.UIGray.SetGray(self.claim_btn.transform, true, false)
    self.claim_red_dot:SetActive(false)
  else
    self.claim_btn_txt:SetLocalText("2000157")
    self.claim_red_dot:SetActive(true)
    CS.UIGray.SetGray(self.claim_btn.transform, false, true)
  end
end

function UILWActPeriodicCard:WeekDataUpdate(cardId)
  if self.cardId == cardId then
    self.cardData = DataCenter.SeasonPeriodicCardManager:GetCardData(self.cardId)
    if self.cardData then
      self:RefreshPanel()
    end
  end
end

function UILWActPeriodicCard:OnBuyBtnClick()
  local flag = true
  local now = UITimeManager:GetInstance():GetServerTime()
  local time = self.activityInfo.endTime - now
  if 0 < time then
    local day = time / (OneDayTime * 1000)
    if day < 7 then
      flag = false
    end
  else
    flag = false
  end
  
  local function buyCall()
    local now = UITimeManager:GetInstance():GetServerTime()
    local time = self.activityInfo.endTime - now
    if time < 0 then
      return
    end
    local cardData = DataCenter.SeasonPeriodicCardManager:GetCardData(self.cardId)
    if cardData then
      local packageData = cardData:GetPackageData()
      if packageData then
        DataCenter.PayManager:CallPayment(packageData, "ActPeriodicCardView", "")
      end
    end
  end
  
  if not flag then
    local delayParam = {
      delayTime = 10,
      des1 = "season_alliance_reward_tips_1",
      des2 = "season_alliance_reward_tips_2"
    }
    UIUtil.ShowSecondMessage(Localization:GetString("season_s2_weekcard_04"), Localization:GetString("season_s2_weekcard_05"), 2, "", "", function()
      buyCall()
    end, nil, nil, nil, nil, nil, nil, nil, nil, false, nil, delayParam)
  else
    buyCall()
  end
end

function UILWActPeriodicCard:OnTodayClaimBtnClick()
  SFSNetwork.SendMessage(MsgDefines.LWSeasonWeekCardDailyReward, self.cardId)
end

function UILWActPeriodicCard:FreeBtnClick()
  if not self.canGet then
    return
  end
  self.free_reward_ani:Play("V_ui_zhoukabaoxiang_01_open", 0, 0)
  SFSNetwork.SendMessage(MsgDefines.LWSeasonWeekCardFreeReward, self.cardId, false)
end

function UILWActPeriodicCard:DailyRewardUpdate()
  self:RefreshBtns()
end

function UILWActPeriodicCard:FreeRewardUpdate()
  self:RefreshDailyBox()
end

return UILWActPeriodicCard
