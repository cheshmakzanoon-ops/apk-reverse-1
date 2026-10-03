local base = UIBaseContainer
local UIActSevenDayV2RewardItem = BaseClass("UIActSevenDayV2RewardItem", base)
local Localization = CS.GameEntry.Localization
local LeftLockImg_path = "LeftItem/LeftLockImg"
local LeftRecivedImg_path = "LeftItem/LeftRecivedImg"
local LeftSelectEffect_path = "LeftItem/LeftSelectEffect"
local RightLockImg_path = "RightItem/RightLockImg"
local RightRecivedImg_path = "RightItem/RightRecivedImg"
local RightSelectEffect_path = "RightItem/RightSelectEffect"
local FinshedImg_path = "UnfinshImg/FinshedImg"
local NumText_path = "UnfinshImg/NumText"
local UnfinshImg_path = "UnfinshImg"

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

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.LeftLockImg = self:AddComponent(UIBaseContainer, LeftLockImg_path)
  self.LeftRecivedImg = self:AddComponent(UIBaseContainer, LeftRecivedImg_path)
  self.LeftSelectEffect = self:AddComponent(UIBaseContainer, LeftSelectEffect_path)
  self.RightLockImg = self:AddComponent(UIBaseContainer, RightLockImg_path)
  self.RightRecivedImg = self:AddComponent(UIBaseContainer, RightRecivedImg_path)
  self.RightSelectEffect = self:AddComponent(UIBaseContainer, RightSelectEffect_path)
  self.FinshedImg = self:AddComponent(UIBaseContainer, FinshedImg_path)
  self.NumText = self:AddComponent(UITextMeshProUGUIEx, NumText_path)
  self.LeftResItem = self:AddComponent(UICommonResItem, "LeftItem/LeftResItem")
  self.RightResItem = self:AddComponent(UICommonResItem, "RightItem/RightResItem")
  self.LeftBtn = self:AddComponent(UIButton, "LeftItem")
  self.RightBtn = self:AddComponent(UIButton, "RightItem")
  self.RightVIPText = self:AddComponent(UITextMeshProUGUIEx, "RightItem/RightVIPText")
  self.finishIcon = self:AddComponent(UIImage, FinshedImg_path)
  self.unFinishIcon = self:AddComponent(UIImage, UnfinshImg_path)
  self.LeftBtn:SetOnClick(function()
    self:OnClickLeft()
  end)
  self.RightBtn:SetOnClick(function()
    self:OnClickRight()
  end)
end

local function ComponentDestroy(self)
  self.LeftLockImg = nil
  self.LeftRecivedImg = nil
  self.LeftSelectEffect = nil
  self.RightLockImg = nil
  self.RightRecivedImg = nil
  self.RightSelectEffect = nil
  self.FinshedImg = nil
  self.NumText = nil
  self.LeftResItem = nil
  self.RightResItem = nil
  self.LeftBtn = nil
  self.RightBtn = nil
  self.finishIcon = nil
  self.unFinishIcon = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.acId = nil
  self.data = nil
  self.dayInfo = nil
end

local function ReInit(self, data, dayInfo, acId)
  self.acId = acId
  self.data = data
  self.dayInfo = dayInfo
  self.NumText:SetText(data.needScore)
  self.RightVIPText:SetLocalText(2000268, data.needVipLevel)
  self.FinshedImg:SetActive(false)
  data.reward[1].clickCallBack = function()
    self:OnClickLeft()
  end
  self.LeftResItem:ReInit(data.reward[1])
  self.LeftResItem:SetGray(false, false)
  data.vipReward[1].clickCallBack = function()
    self:OnClickRight()
  end
  self.RightResItem:ReInit(data.vipReward[1])
  self.RightResItem:SetGray(false, false)
  self.LeftRecivedImg:SetActive(false)
  self.LeftSelectEffect:SetActive(false)
  self.RightRecivedImg:SetActive(false)
  self.RightSelectEffect:SetActive(false)
  self.RightLockImg:SetActive(false)
  local vipInfo = DataCenter.VIPManager:GetVipData()
  if data.vipRewardFlag == 0 and vipInfo.level < data.needVipLevel then
    self.RightLockImg:SetActive(true)
  end
  if dayInfo.score >= data.needScore then
    self.FinshedImg:SetActive(true)
    if data.rewardFlag == 0 then
      self.LeftSelectEffect:SetActive(true)
    else
      self.LeftRecivedImg:SetActive(true)
      self.LeftResItem:SetGray(true, false)
    end
    if data.vipRewardFlag == 0 then
      self.RightSelectEffect:SetActive(true)
    else
      self.RightRecivedImg:SetActive(true)
      self.RightResItem:SetGray(true, false)
    end
  else
    self.FinshedImg:SetActive(false)
  end
  local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(self.acId))
  if actListData and not string.IsNullOrEmpty(actListData.para_4) then
    local paths = string.split(actListData.para_4, "|")
    if paths[1] then
      self.unFinishIcon:LoadSpriteAsyncWithCallback(paths[1], function()
        if self.unFinishIcon then
          self.unFinishIcon:SetNativeSize()
        end
      end)
    end
    if paths[2] then
      self.finishIcon:LoadSpriteAsyncWithCallback(paths[2], function()
        if self.finishIcon then
          self.finishIcon:SetNativeSize()
        end
      end)
    end
  end
end

local function OnItemIntroClick(self, commonItem, data)
  local param = {}
  param.itemName = DataCenter.RewardManager:GetNameByType(data.rewardType, data.itemId)
  param.itemDesc = DataCenter.RewardManager:GetDescByType(data.rewardType, data.itemId)
  param.alignObject = commonItem.item_icon
  param.itemId = data.itemId
  param.isLocal = true
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
end

local function OnClickLeft(self)
  if self.dayInfo.score >= self.data.needScore then
    if self.data.rewardFlag == 0 then
      self.view.ctrl:SendGetAllReward(self.acId)
    else
      self:OnItemIntroClick(self.LeftResItem, self.data.reward[1])
    end
  else
    self:OnItemIntroClick(self.LeftResItem, self.data.reward[1])
  end
end

local function OnClickRight(self)
  if self.dayInfo.score >= self.data.needScore then
    if self.data.vipRewardFlag == 0 then
      local vipInfo = DataCenter.VIPManager:GetVipData()
      if vipInfo.level < self.data.needVipLevel then
        UIUtil.ShowTips(Localization:GetString("sevenday_event_des37", self.data.needVipLevel))
      else
        self.view.ctrl:SendGetAllReward(self.acId)
      end
    else
      self:OnItemIntroClick(self.RightResItem, self.data.vipReward[1])
    end
  else
    self:OnItemIntroClick(self.RightResItem, self.data.vipReward[1])
  end
end

UIActSevenDayV2RewardItem.OnCreate = OnCreate
UIActSevenDayV2RewardItem.OnDestroy = OnDestroy
UIActSevenDayV2RewardItem.OnEnable = OnEnable
UIActSevenDayV2RewardItem.OnDisable = OnDisable
UIActSevenDayV2RewardItem.ComponentDefine = ComponentDefine
UIActSevenDayV2RewardItem.ComponentDestroy = ComponentDestroy
UIActSevenDayV2RewardItem.DataDefine = DataDefine
UIActSevenDayV2RewardItem.DataDestroy = DataDestroy
UIActSevenDayV2RewardItem.ReInit = ReInit
UIActSevenDayV2RewardItem.OnClickLeft = OnClickLeft
UIActSevenDayV2RewardItem.OnClickRight = OnClickRight
UIActSevenDayV2RewardItem.OnItemIntroClick = OnItemIntroClick
return UIActSevenDayV2RewardItem
