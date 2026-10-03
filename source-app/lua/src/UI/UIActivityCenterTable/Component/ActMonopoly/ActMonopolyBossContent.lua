local ActMonopolyBossContent = BaseClass("ActMonopolyBossContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ActMonopolyBossRewardItem = require("UI.UIActivityCenterTable.Component.ActMonopoly.ActMonopolyBossRewardItem")
local battle_content_path = "CenterMonopolyContent/battleContent"
local battle_raw_img_path = "CenterMonopolyContent/battleContent/battleRawImg"
local damage_reward_pos_path = "CenterMonopolyContent/battleContent/damageRewardPos"
local atk_boss_content2_path = "CenterMonopolyContent/battleContent/atkBossContent2"
local atk_boss_bullet_content_path = "CenterMonopolyContent/battleContent/atkBossContent2/atkBossBulletContent"
local attack_boss_btn_icon2_path = "CenterMonopolyContent/battleContent/atkBossContent2/atkBossBulletContent/attackBossBtnIcon2"
local attack_boss_btn_txt2_path = "CenterMonopolyContent/battleContent/atkBossContent2/atkBossBulletContent/attackBossBtnTxt2"
local touch_boss_btn_path = "CenterMonopolyContent/battleContent/touchBossBtn"
local attack_boss_btn_path = "bottomContent/attackBossBtn"
local attack_boss_btn_icon_path = "bottomContent/attackBossBtn/attackBossBtnBg/attackBossBtnIcon"
local attack_boss_btn_txt_path = "bottomContent/attackBossBtn/attackBossBtnBg/attackBossBtnTxt"
local boss_reward_content_path = "ActivityTopGo/bossRewardContent"
local boss_reward_item_path = "ActivityTopGo/bossRewardContent/bossRewardItem"
local boss_hp_bg_path = "ActivityTopGo/bossRewardContent/bossHpBg"
local boss_reward_item_content_path = "ActivityTopGo/bossRewardContent/bossHpBg/bossRewardItemContent"
local pre_boss_hp_img_path = "ActivityTopGo/bossRewardContent/bossHpBg/preBossHpImg"
local boss_hp_img_path = "ActivityTopGo/bossRewardContent/bossHpBg/bossHpImg"
local boss_hp_val_content_path = "ActivityTopGo/bossRewardContent/bossHpValContent"
local boss_hp_val_txt_path = "ActivityTopGo/bossRewardContent/bossHpValContent/bossHpValTxt"
local weak_state_txt_path = "ActivityTopGo/bossRewardContent/weakStateTxt"
local AtkBossDeltaTime = 300
local AtkBossBulletNum = 64
local AtkBossBulletAddTime = 2000
local AtkBossAniTotalTime = 900
local AtkBossBulletShowMaxNum = 4

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
  self.battle_content = self:AddComponent(UIBaseContainer, battle_content_path)
  self.battle_raw_img = self:AddComponent(UIRawImage, battle_raw_img_path)
  self.damage_reward_pos = self:AddComponent(UIBaseContainer, damage_reward_pos_path)
  self.atk_boss_content2 = self:AddComponent(UIBaseContainer, atk_boss_content2_path)
  self.atk_boss_bullet_content = self:AddComponent(UIImage, atk_boss_bullet_content_path)
  self.attack_boss_btn_icon2 = self:AddComponent(UIImage, attack_boss_btn_icon2_path)
  self.attack_boss_btn_txt2 = self:AddComponent(UIText, attack_boss_btn_txt2_path)
  self.touch_boss_btn = self:AddComponent(UIButton, touch_boss_btn_path)
  self.attack_boss_btn = self:AddComponent(UIBaseContainer, attack_boss_btn_path)
  self.attack_boss_btn_icon = self:AddComponent(UIImage, attack_boss_btn_icon_path)
  self.attack_boss_btn_txt = self:AddComponent(UIText, attack_boss_btn_txt_path)
  self.boss_reward_content = self:AddComponent(UIBaseContainer, boss_reward_content_path)
  self.boss_reward_item = self:AddComponent(UIImage, boss_reward_item_path)
  self.boss_hp_bg = self:AddComponent(UIImage, boss_hp_bg_path)
  self.boss_reward_item_content = self:AddComponent(UIBaseContainer, boss_reward_item_content_path)
  self.pre_boss_hp_img = self:AddComponent(UIBaseContainer, pre_boss_hp_img_path)
  self.boss_hp_img = self:AddComponent(UIImage, boss_hp_img_path)
  self.boss_hp_val_content = self:AddComponent(UIImage, boss_hp_val_content_path)
  self.boss_hp_val_txt = self:AddComponent(UIText, boss_hp_val_txt_path)
  self.weak_state_txt = self:AddComponent(UIText, weak_state_txt_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.isBoss = nil
  self.bossState = nil
  self.bossRewardShowData = nil
  self.bossTemp = nil
  self.bossDamage1 = 0
  self.bossDamage2 = 0
  self.isAtkBossBtnDown = false
  self.atkBossBtnDownTime = 0
  self.sendAtkBossTime = 0
  self.isWaitingAtkBossMsgBack = false
  self.isWaitingAtkBossWeakTip = false
  self.curAtkBossBulletNum = 1
  self.atkBossMsgDealList = {}
  self.atkBossMsgDealIndex = 1
  self.isPlayingBossBloodAfterImgAni = false
  self.bossBloodAfterImgBgH = 0
  self.curBossBloodAfterImgW = 0
  self.curBossBloodAfterImgH = 0
  self.curBossBloodAfterImgHp = 0
  self.curBossBloodAfterImgWeakHp = 0
  self.curBossBloodImgH = 0
  self.curBossBloodAfterImgToH = 0
  self.curBossBloodHp = 0
  self.curBossBloodWeakHp = 0
  self.bossBloodAniForceLoop = false
end

local function DataDestroy(self)
end

local function SetData(self, mainView, activityId, activityInfo, activityDetailData, costData, isBoss)
  self.mainView = mainView
  self.activityId = activityId
  self.activityInfo = activityInfo
  self.activityDetailData = activityDetailData
  self.costData = costData
  self.isBoss = isBoss
  self:RefreshView()
end

local function RefreshView(self)
  if not self.isBoss then
    self.battle_content:SetActive(false)
    self.attack_boss_btn:SetActive(false)
    self.boss_reward_content:SetActive(false)
    return
  end
  self.battle_content:SetActive(true)
  self.attack_boss_btn:SetActive(true)
  self.boss_reward_content:SetActive(true)
end

local function RefreshBossFightBtnView(self)
  if not self.isBoss then
    return
  end
  if self.bossTemp == nil then
    return
  end
  local goodsId = self.bossTemp.atk_goods_id
  local iconPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, goodsId)
  self.attack_boss_btn_icon:LoadSprite(iconPath)
  self.attack_boss_btn_icon2:LoadSprite(iconPath)
  local curNum = DataCenter.ItemData:GetItemCount(goodsId)
  self.attack_boss_btn_txt:SetText(curNum)
  self.attack_boss_btn_txt2:SetText("x" .. curNum)
end

local function RefreshBossDamageRewardView(self)
  if not self.isBoss then
    return
  end
  if self.bossTemp == nil then
    return
  end
  self.reward_boss_btn:SetActive(#self.activityDetailData.damageReward > 0)
end

local function RefreshBossRewardView(self, withoutBloodView)
  if not self.isBoss then
    return
  end
  local bossDamageTemp = self.bossTemp
  if bossDamageTemp == nil then
    return
  end
  local curBossState = self.activityDetailData:GetBossState()
  local totalHp = 0
  local curHp = 0
  if curBossState == ActMonopolyBossState.Normal then
    totalHp = bossDamageTemp.bullet_boss_hp_total
    curHp = self.activityDetailData.bossBlood
  elseif curBossState == ActMonopolyBossState.Weak then
    totalHp = bossDamageTemp.bullet_boss_hp_weak
    local weakTotalHp = self.activityDetailData.bossWeakHp
    curHp = totalHp - weakTotalHp % totalHp
  end
  if curBossState ~= self.bossState then
    self.bossState = curBossState
    self.bossRewardShowData = {}
    if self.bossState == ActMonopolyBossState.Normal then
      local rewardNum = #bossDamageTemp.bullet_boss_hp_list
      for i = 1, rewardNum do
        local data = {
          state = self.bossState,
          index = i,
          needHp = bossDamageTemp.bullet_boss_hp_list[i]
        }
        table.insert(self.bossRewardShowData, data)
      end
    elseif self.bossState == ActMonopolyBossState.Weak then
      local data = {
        state = self.bossState,
        index = 1
      }
      table.insert(self.bossRewardShowData, data)
    end
    self:ClearAllBossRewardItem()
    local contentY = self.boss_reward_item_content.rectTransform.rect.height
    for k, v in ipairs(self.bossRewardShowData) do
      local index = v.index
      local item = self.boss_reward_item.gameObject:GameObjectSpawn(self.boss_reward_item_content.transform)
      item.name = "bossRewardItem" .. index
      local obj = self.boss_reward_item_content:AddComponent(ActMonopolyBossRewardItem, item.name)
      obj:SetActive(true)
      self.bossRewardItemList[index] = obj
      local posY = contentY
      if self.bossState == ActMonopolyBossState.Normal then
        local totalNum = #bossDamageTemp.bullet_boss_hp_list
        posY = contentY / totalNum * index
      end
      obj:SetAnchoredPositionXY(0, posY)
    end
  end
  self.boss_hp_val_txt:SetText(Localization:GetString("110186") .. string.format(" %s/%s", totalHp - curHp, totalHp))
  self.weak_state_txt:SetActive(self.bossState == ActMonopolyBossState.Weak)
  for k, v in ipairs(self.bossRewardItemList) do
    v:SetData(self.activityId, self.activityDetailData, self.bossTemp, self.bossRewardShowData[k])
  end
  if withoutBloodView == nil then
    local hpBgSize = self.boss_hp_bg:GetSizeDelta()
    local hpSize = self.pre_boss_hp_img:GetSizeDelta()
    if self.bossState == ActMonopolyBossState.Normal then
      local ImgH = self:GetNormalBloodH(curHp)
      self.pre_boss_hp_img:SetSizeDeltaXY(hpSize.x, ImgH)
    else
      self.pre_boss_hp_img:SetSizeDeltaXY(hpSize.x, hpBgSize.y * (1 - curHp / totalHp))
    end
  end
end

local function AttackBtnPointDown()
  if self.isWaitingAtkBossWeakTip == true then
    return
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.isAtkBossBtnDown = true
  self:SetAtkBossBtnScale()
  self.atkBossBtnDownTime = curTime
  self.curAtkBossBulletNum = 1
  self:Update100MS()
end

local function AttackBtnPointUp()
  self.isAtkBossBtnDown = false
  self:SetAtkBossBtnScale()
end

local function TrySendAtkBossMsg()
  local isSuccess = false
  if not self.isBoss then
    return isSuccess
  end
  if self.bossTemp == nil then
    return isSuccess
  end
  local goodsId = self.bossTemp.atk_goods_id
  local curNum = DataCenter.ItemData:GetItemCount(goodsId)
  local canUseNum = self.curAtkBossBulletNum
  if curNum <= 0 then
    UIUtil.ShowTipsId("richman_boss_desc4")
    isSuccess = false
  else
    local useNum = math.min(canUseNum, curNum)
    SFSNetwork.SendMessage(MsgDefines.RichManDamage, tonumber(self.activityId), useNum)
    isSuccess = true
  end
  return isSuccess
end

local function Update100MS(self)
end

ActMonopolyBossContent.OnCreate = OnCreate
ActMonopolyBossContent.OnDestroy = OnDestroy
ActMonopolyBossContent.ComponentDefine = ComponentDefine
ActMonopolyBossContent.ComponentDestroy = ComponentDestroy
ActMonopolyBossContent.DataDefine = DataDefine
ActMonopolyBossContent.DataDestroy = DataDestroy
ActMonopolyBossContent.SetData = SetData
ActMonopolyBossContent.RefreshView = RefreshView
ActMonopolyBossContent.RefreshBossFightBtnView = RefreshBossFightBtnView
ActMonopolyBossContent.RefreshBossDamageRewardView = RefreshBossDamageRewardView
ActMonopolyBossContent.RefreshBossRewardView = RefreshBossRewardView
ActMonopolyBossContent.AttackBtnPointDown = AttackBtnPointDown
ActMonopolyBossContent.AttackBtnPointUp = AttackBtnPointUp
ActMonopolyBossContent.TrySendAtkBossMsg = TrySendAtkBossMsg
ActMonopolyBossContent.Update100MS = Update100MS
return ActMonopolyBossContent
