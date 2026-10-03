local AllianceGiftItem = BaseClass("LWAllianceGiftItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local RewardUtil = require("Util.RewardUtil")
local name_txt_path = "animatorObj/giftName"
local time_txt_path = "animatorObj/time"
local giftFrom_path = "animatorObj/from"
local boxIcon_path = "animatorObj/boxIcon"
local get_btn_path = "animatorObj/getBtn"
local getBtnTxt_path = "animatorObj/getBtn/getTxt"
local del_btn_path = "animatorObj/delBtn"
local scoreNode_path = "animatorObj/score"
local scoreNum_path = "animatorObj/score/scoreNum"
local btn_user_path = "animatorObj/btnUser"
local animObj_path = "animatorObj"
local bg_path = "animatorObj/bg"
local item_path = "animatorObj/Item"
local BG = {
  "Assets/Main/Sprites/UI/UILWQuest/cfm_renwu_tiao_2.png",
  "Assets/Main/Sprites/UI/UILWAlliance/zyf_lianmengjijie_chengsetiao.png",
  "Assets/Main/Sprites/UI/UILWAlliance/lyp_lianmengjijie_huisetiao.png"
}

local function OnCreate(self)
  base.OnCreate(self)
  self.giftName = self:AddComponent(UIText, name_txt_path)
  self.giftTime = self:AddComponent(UIText, time_txt_path)
  self.giftFrom = self:AddComponent(UIText, giftFrom_path)
  self.boxIcon = self:AddComponent(UIImage, boxIcon_path)
  self.boxBtn = self:AddComponent(UIButton, boxIcon_path)
  self.boxBtn:SetOnClick(function()
    self:OnBoxClick()
  end)
  self.itemNode = self:AddComponent(UICommonResItem, item_path)
  self.getBtn = self:AddComponent(UIButton, get_btn_path)
  self.getBtn:SetOnClick(function()
    self:OnGetClick()
  end)
  self.btnUser = self:AddComponent(UIButton, btn_user_path)
  self.btnUser:SetOnClick(function()
    self:OnUserClick()
  end)
  self.getBtnTxt = self:AddComponent(UIText, getBtnTxt_path)
  self.scoreNode = self:AddComponent(UIBaseContainer, scoreNode_path)
  self.scoreNum = self:AddComponent(UIText, scoreNum_path)
  self.animatorObj = self:AddComponent(UIBaseContainer, animObj_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.isUpdate = false
end

local function OnDestroy(self)
  self.giftName = nil
  self.giftTime = nil
  self.giftFrom = nil
  self.boxIcon = nil
  self.boxBtn = nil
  self.getBtn = nil
  self.getBtnTxt = nil
  self.scoreNode = nil
  self.scoreNum = nil
  base.OnDestroy(self)
end

function AllianceGiftItem:OnUserClick()
  local userName = self.data.userName
  if userName ~= nil and userName ~= "" then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlMember, {anim = true, hideTop = true})
  end
end

local function RefreshData(self, data)
  self.lastChangeTextDeltaTime = 0
  self.isUpdate = false
  self.data = data
  self.boxIcon:LoadSprite(string.format(LoadPath.UIAllianceGift, self.data.icon))
  self.giftName:SetText(self.data.name)
  local fromPackage = self.data.fromPackage
  local fromTxt = self.data.fromTxt
  if fromPackage then
    local userName = self.data.userName
    if userName == nil or userName == "" then
      userName = Localization:GetString("455106")
    else
      userName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.data.fromUid, self.data.userName)
    end
    self.giftFrom:SetText(Localization:GetString("455104", userName, Localization:GetString(fromPackage, "")))
  elseif fromTxt then
    self.giftFrom:SetText(fromTxt)
  else
    local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.data.fromUid, self.data.userName)
    if self.data.monsterName ~= nil and self.data.monsterName ~= "" then
      self.giftFrom:SetText(Localization:GetString("alliance_regularGift_tips", showName, self.data.monsterName))
    else
      self.giftFrom:SetText(Localization:GetString("391074", showName))
    end
  end
  if self.data.receiveState == 1 then
    self.giftTime:SetActive(false)
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UILWAlliance/lyp_lianmengjijie_huisetiao.png")
    self.getBtnTxt:SetLocalText(170003)
    UIGray.SetGray(self.getBtn.transform, true, false)
    UIGray.SetGray(self.boxIcon.transform, true, false)
    local reward = self.data.reward[1]
    if reward ~= nil then
      local newReward = {}
      newReward.rewardType = reward.type
      if type(reward.value) == "table" then
        newReward.itemId = reward.value.id
        newReward.count = reward.value.num
      else
        newReward.count = reward.value
      end
      self.itemNode:ReInit(newReward)
      self.itemNode:SetActive(true)
      self.boxIcon:SetActive(false)
    else
      self.itemNode:SetActive(false)
      self.boxIcon:SetActive(true)
    end
  else
    self.giftTime:SetActive(true)
    self.bg:LoadSprite("Assets/Main/Sprites/UI/UILWAlliance/zyf_lianmengjijie_chengsetiao.png")
    self.getBtnTxt:SetLocalText(170004)
    UIGray.SetGray(self.getBtn.transform, false, true)
    UIGray.SetGray(self.boxIcon.transform, false, true)
    self.itemNode:SetActive(false)
    self.boxIcon:SetActive(true)
  end
  local eachExpNum = self.data.eachExp and self.data.eachExp or 0
  local keyExpNum = self.data.keyExp and self.data.keyExp or 0
  self.scoreNum:SetText("+" .. eachExpNum + keyExpNum)
  self:UpdateTime(self)
end

local function UpdateTime(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local deltaTime = 0
  if curTime < self.data.endTime and self.data.receiveState ~= 1 then
    self.isUpdate = true
    deltaTime = self.data.endTime - curTime
  else
    self.isUpdate = false
  end
  if self.isUpdate then
    self.giftTime:SetActive(true)
    if TimeBarUtil.CheckIsNeedChangeText(deltaTime, self.lastChangeTextDeltaTime) then
      self.lastChangeTextDeltaTime = deltaTime
      self.giftTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    end
  else
    self.giftTime:SetActive(false)
    self.lastChangeTextDeltaTime = 0
    if self.data.receiveState == 1 then
    else
      self.view:OnRefresh()
    end
  end
end

local function Update(self)
  if self.isUpdate then
    self:UpdateTime(self)
  end
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnBgClick(self)
  self.view.ctrl:OnOpenClick(self.data.uuid, self.data.rewardType)
end

local function InnerGetFlyTargetByType(type)
  local view = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
  if type == RewardType.METAL or type == RewardType.FOOD or type == RewardType.WOOD then
    return view.View:GetResourcePos(RewardToResType[type])
  elseif type == RewardType.WORKER then
    return view.View:GetSavePos(UIMainSavePosType.VisitorBtn)
  elseif type == RewardType.GOLD then
    return view.View:GetSavePos(UIMainSavePosType.Gold)
  elseif type == RewardType.HERO then
    return view.View:GetSavePos(UIMainSavePosType.HeroBtn)
  elseif type == RewardType.VISITOR then
    return view.View:GetSavePos(UIMainSavePosType.VisitorBtn)
  end
  return view.View:GetSavePos(UIMainSavePosType.BagBtn)
end

local function OnGetClick(self)
  if self.view:OnGetClick(self.data.uuid) then
    if self.data.reward and #self.data.reward > 0 then
      local tempType = self.data.reward[1].type
      local tempId = self.data.reward[1].value.id
      local pic = RewardUtil.GetPic(tempType, tempId)
      UIUtil.DoFly(tonumber(tempType), 5, pic, self.scoreNum.transform.position, InnerGetFlyTargetByType(tempType))
      local targetPos = self.view.scoreFlyTarget.transform.position
      local scorePic = "Assets/Main/Sprites/UI/UIAllianceGift/UIAllianceGift_iconBox_exp.png"
      UIUtil.DoFly(tonumber(tempType), 5, scorePic, self.scoreNode.transform.position, targetPos, 40, 40)
      self.data.receiveState = 1
    end
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_GetReward, false)
  end
end

local function OnBoxClick(self)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_GetReward, false)
  local groupId = tonumber(self.data.groupId)
  local curLevel = DataCenter.AllianceGiftDataManager:GetCurLevel()
  local allianceGiftId = groupId + curLevel
  local dropInfoId = GetTableData(TableName.AllianceGift, allianceGiftId, "drop_info_para")
  if dropInfoId then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIProbabilityNotice, {anim = true}, dropInfoId)
  end
end

AllianceGiftItem.OnCreate = OnCreate
AllianceGiftItem.OnDestroy = OnDestroy
AllianceGiftItem.OnEnable = OnEnable
AllianceGiftItem.OnDisable = OnDisable
AllianceGiftItem.RefreshData = RefreshData
AllianceGiftItem.UpdateTime = UpdateTime
AllianceGiftItem.Update = Update
AllianceGiftItem.OnBgClick = OnBgClick
AllianceGiftItem.OnGetClick = OnGetClick
AllianceGiftItem.OnBoxClick = OnBoxClick
return AllianceGiftItem
