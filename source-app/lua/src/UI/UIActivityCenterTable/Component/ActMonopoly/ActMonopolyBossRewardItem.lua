local ActMonopolyBossRewardItem = BaseClass("ActMonopolyBossRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIPersonalArmsRewardTipView = require("UI.UIActivityPersonalArms.UIPersonalArmsRewardTip.View.UIPersonalArmsRewardTipView")
local root_path = ""
local reward_btn_path = "rewardBtn"
local icon_path = "rewardBtn/icon"
local num_path = "rewardBtn/num"
local red_point_path = "rewardBtn/redPoint"
local red_point_num_path = "rewardBtn/redPoint/redPointNum"
local canOpenEffect_path = "rewardBtn/canOpenEffect"
local canOpenEffect2_path = "rewardBtn/canOpenEffect2"
local rewardTipDeltaxX = -80

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.reward_btn = self:AddComponent(UIButton, reward_btn_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.num = self:AddComponent(UIText, num_path)
  self.red_point = self:AddComponent(UIImage, red_point_path)
  self.red_point_num = self:AddComponent(UIText, red_point_num_path)
  self.canOpenEffect = self:AddComponent(UIBaseContainer, canOpenEffect_path)
  self.canOpenEffect2 = self:AddComponent(UIBaseContainer, canOpenEffect2_path)
  self.reward_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
end

local function ComponentDestroy(self)
  self.reward_btn = nil
  self.icon = nil
  self.num = nil
  self.red_point = nil
  self.red_point_num = nil
  self.canOpenEffect = nil
  self.canOpenEffect2 = nil
end

local function DataDefine(self)
  self.activityId = nil
  self.actDetailData = nil
  self.bossTemp = nil
  self.itemData = nil
end

local function DataDestroy(self)
  self.activityId = nil
  self.actDetailData = nil
  self.bossTemp = nil
  self.itemData = nil
end

local function SetData(self, activityId, actDetailData, bossTemp, itemData)
  self.activityId = activityId
  self.actDetailData = actDetailData
  self.bossTemp = bossTemp
  self.itemData = itemData
  self:RefreshView()
end

local function RefreshView(self)
  if self.itemData.state == ActMonopolyBossState.Normal then
    self.red_point:SetActive(false)
    local totalHp = self.bossTemp.bullet_boss_hp_total
    self.num:SetText(totalHp - self.itemData.needHp)
    local curHp = self.actDetailData.bossBlood
    if curHp <= self.itemData.needHp then
      local serverIndex = self.itemData.index - 1
      local isHaveGet = self.actDetailData.bossReceive[serverIndex] ~= nil
      if isHaveGet then
        self.icon:SetColorRGBA(0.6, 0.6, 0.6, 1)
        self.canOpenEffect:SetActive(false)
        self.canOpenEffect2:SetActive(false)
      else
        self.icon:SetColorRGBA(1, 1, 1, 1)
        self.canOpenEffect:SetActive(true)
        self.canOpenEffect2:SetActive(true)
      end
    else
      self.icon:SetColorRGBA(1, 1, 1, 1)
      self.canOpenEffect:SetActive(false)
      self.canOpenEffect2:SetActive(false)
    end
  elseif self.itemData.state == ActMonopolyBossState.Weak then
    self.icon:SetColorRGBA(1, 1, 1, 1)
    local totalHp = self.bullet_boss_hp_weak
    self.num:SetText(totalHp)
    self.canOpenEffect:SetActive(false)
    self.canOpenEffect2:SetActive(false)
    local totalFightHp = self.actDetailData.bossWeakHp
    local canGetNum = math.floor(totalFightHp / self.bossTemp.bullet_boss_hp_weak)
    local canGetNumMax = self.bossTemp.bullet_boss_reward_limit_num
    if canGetNum > canGetNumMax then
      canGetNum = canGetNumMax
    end
    local haveGetNum = self.actDetailData.bossWeakReceiveTimes
    local redNum = canGetNum - haveGetNum
    self.red_point:SetActive(0 < redNum)
    self.red_point_num:SetText(redNum)
  end
end

local function RefreshViewBydata(self, level, exp)
end

local function OnBtnClick(self)
  if self.itemData.state == ActMonopolyBossState.Normal then
    local curHp = self.actDetailData.bossBlood
    if curHp <= self.itemData.needHp then
      local serverIndex = self.itemData.index - 1
      local isHaveGet = self.actDetailData.bossReceive[serverIndex] ~= nil
      if not isHaveGet then
        SFSNetwork.SendMessage(MsgDefines.RichManBossStageReward, self.activityId, serverIndex)
      else
        local param = UIPersonalArmsRewardTipView.ParamDataClass.New()
        param.position = self.reward_btn.transform.position
        param.deltaX = rewardTipDeltaxX
        param.dir = UIPersonalArmsRewardTipView.Direction.RIGHT
        local rewardList = self.actDetailData.boosReward[self.itemData.index]
        local showList = {}
        if rewardList and rewardList.reward then
          for _, v in ipairs(rewardList.reward) do
            table.insert(showList, v)
          end
        end
        if LuaEntry.Player:IsInAlliance() then
          local giftId = self.bossTemp.alliance_boss_gift_list[self.itemData.index]
          if giftId and 0 < giftId then
            local data = {
              rewardType = RewardType.ALLIANCE_GIFT,
              itemId = giftId,
              count = 1
            }
            table.insert(showList, data)
          end
        end
        param.rewardList = showList
        param.titleStr = Localization:GetString("richman_boss_desc3")
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIPersonalArmsRewardTip, {anim = false}, param)
      end
    else
      local param = UIPersonalArmsRewardTipView.ParamDataClass.New()
      param.position = self.reward_btn.transform.position
      param.deltaX = rewardTipDeltaxX
      param.dir = UIPersonalArmsRewardTipView.Direction.RIGHT
      local rewardList = self.actDetailData.boosReward[self.itemData.index]
      local showList = {}
      if rewardList and rewardList.reward then
        for _, v in ipairs(rewardList.reward) do
          table.insert(showList, v)
        end
      end
      if LuaEntry.Player:IsInAlliance() then
        local giftId = self.bossTemp.alliance_boss_gift_list[self.itemData.index]
        if giftId and 0 < giftId then
          local data = {
            rewardType = RewardType.ALLIANCE_GIFT,
            itemId = giftId,
            count = 1
          }
          table.insert(showList, data)
        end
      end
      param.rewardList = showList
      param.titleStr = Localization:GetString("richman_boss_desc2")
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPersonalArmsRewardTip, {anim = false}, param)
    end
  elseif self.itemData.state == ActMonopolyBossState.Weak then
    local totalFightHp = self.actDetailData.bossWeakHp
    local canGetNum = math.floor(totalFightHp / self.bossTemp.bullet_boss_hp_weak)
    local canGetNumMax = self.bossTemp.bullet_boss_reward_limit_num
    if canGetNum > canGetNumMax then
      canGetNum = canGetNumMax
    end
    local haveGetNum = self.actDetailData.bossWeakReceiveTimes
    local redNum = canGetNum - haveGetNum
    if 0 < redNum then
      SFSNetwork.SendMessage(MsgDefines.RichManBossWeakReward, self.activityId)
    else
      local param = UIPersonalArmsRewardTipView.ParamDataClass.New()
      param.position = self.reward_btn.transform.position
      param.deltaX = rewardTipDeltaxX
      param.dir = UIPersonalArmsRewardTipView.Direction.RIGHT
      local rewardList = self.actDetailData.weakReward
      local showList = {}
      if rewardList then
        showList = rewardList
      end
      param.rewardList = showList
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPersonalArmsRewardTip, {anim = false}, param)
    end
  end
end

ActMonopolyBossRewardItem.OnCreate = OnCreate
ActMonopolyBossRewardItem.OnDestroy = OnDestroy
ActMonopolyBossRewardItem.ComponentDefine = ComponentDefine
ActMonopolyBossRewardItem.ComponentDestroy = ComponentDestroy
ActMonopolyBossRewardItem.DataDefine = DataDefine
ActMonopolyBossRewardItem.DataDestroy = DataDestroy
ActMonopolyBossRewardItem.SetData = SetData
ActMonopolyBossRewardItem.RefreshView = RefreshView
ActMonopolyBossRewardItem.RefreshViewBydata = RefreshViewBydata
ActMonopolyBossRewardItem.OnBtnClick = OnBtnClick
return ActMonopolyBossRewardItem
