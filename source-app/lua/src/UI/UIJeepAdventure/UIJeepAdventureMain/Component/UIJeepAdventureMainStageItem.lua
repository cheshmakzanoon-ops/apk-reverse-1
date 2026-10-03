local UIJeepAdventureMainStageItem = BaseClass("UIJeepAdventureMainStageItem", UIBaseContainer)
local UIJeepAdventureMainRewardBubble = require("UI.UIJeepAdventure.UIJeepAdventureMain.Component.UIJeepAdventureMainRewardBubble")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.imgKacheNow = self:AddComponent(UIImage, "KacheNowImg")
  self.imgKacheNowBg = self:AddComponent(UIImage, "KacheNowImg/KacheNowBg")
  self.imgKacheNowIcon = self:AddComponent(UIImage, "KacheNowImg/KacheNowIcon")
  self.imgZhuzaiNow = self:AddComponent(UIImage, "ZhuzaiNowImg")
  self.imgZhuzaiNowBg = self:AddComponent(UIImage, "ZhuzaiNowImg/ZhuzaiNowBg")
  self.textStageNum = self:AddComponent(UIText, "StageNum")
  self.textStageNowNum = self:AddComponent(UIText, "StageNowNum")
  self.imgBoss = self:AddComponent(UIImage, "BossImg")
  self.imgStageBg = self:AddComponent(UIImage, "StageBg")
  self.imgZhuzaiIcon = self:AddComponent(CircleImage, "ZhuzaiNowImg/Mask/ZhuzaiIcon")
  self.rewardBubble = self:AddComponent(UIJeepAdventureMainRewardBubble, "RewardBubble")
end

local function ComponentDestroy(self)
  self.imgKacheNow = nil
  self.imgKacheNowBg = nil
  self.imgKacheNowIcon = nil
  self.imgZhuzaiNow = nil
  self.imgZhuzaiNowBg = nil
  self.textStageNum = nil
  self.textStageNowNum = nil
  self.imgZhuzaiIcon = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.firstReward = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, cfg, pageType, stageType)
  self.pageType = pageType
  self.imgKacheNow:SetActive(false)
  self.imgZhuzaiNow:SetActive(false)
  self.imgStageBg:SetActive(false)
  self.imgBoss:SetActive(false)
  self.textStageNum:SetActive(false)
  self.textStageNowNum:SetActive(false)
  self.rewardBubble:SetActive(false)
  if pageType == JeepAdventurePageType.Domintor then
    if stageType == JeepStageItemType.Center then
      self.imgZhuzaiNow:SetActive(true)
      self.textStageNowNum:SetActive(true)
      self.textStageNowNum:SetText(cfg:GetName())
      self.imgZhuzaiIcon:LoadSprite(DataCenter.DominatorManager:GetCityBuildingShowIconPath())
    elseif cfg.isElite then
      self.imgBoss:SetActive(true)
      if stageType == JeepStageItemType.Finished then
        self.imgStageBg:SetActive(true)
        self.imgStageBg:LoadSprite(string.format(UIAssets.UIJeepAdventureMainSpritePath, "lrb_guaji_zhuzai_guanqiadian_boss"))
      end
    else
      self.textStageNum:SetActive(true)
      self.textStageNum:SetText(cfg:GetName())
      if stageType == JeepStageItemType.Finished then
        self.imgStageBg:SetActive(true)
        self.imgStageBg:LoadSprite(string.format(UIAssets.UIJeepAdventureMainSpritePath, "lrb_guaji_zhuzai_guanqiadian"))
      end
    end
  elseif stageType == JeepStageItemType.Center then
    self.imgKacheNow:SetActive(true)
    self.textStageNowNum:SetActive(true)
    self.textStageNowNum:SetText(cfg:GetName())
  elseif cfg.isElite then
    self.imgBoss:SetActive(true)
    if stageType == JeepStageItemType.Finished then
      self.imgStageBg:SetActive(true)
      self.imgStageBg:LoadSprite(string.format(UIAssets.UIJeepAdventureMainSpritePath, "lrb_guaji_kache_guanqiadian_boss"))
    end
  else
    self.textStageNum:SetActive(true)
    self.textStageNum:SetText(cfg:GetName())
    if stageType == JeepStageItemType.Finished then
      self.imgStageBg:SetActive(true)
      self.imgStageBg:LoadSprite(string.format(UIAssets.UIJeepAdventureMainSpritePath, "lrb_guaji_kache_guanqiadian"))
    end
  end
end

local function GetFirstReward(self)
  if self.pageType == JeepAdventurePageType.Domintor then
    SFSNetwork.SendMessage(MsgDefines.LWReveiveDominatorUpFirstReward)
  elseif self.pageType == JeepAdventurePageType.TowerUp then
    SFSNetwork.SendMessage(MsgDefines.LWReveiveTowerUpFirstReward)
  end
end

UIJeepAdventureMainStageItem.OnCreate = OnCreate
UIJeepAdventureMainStageItem.OnDestroy = OnDestroy
UIJeepAdventureMainStageItem.OnEnable = OnEnable
UIJeepAdventureMainStageItem.OnDisable = OnDisable
UIJeepAdventureMainStageItem.ComponentDefine = ComponentDefine
UIJeepAdventureMainStageItem.ComponentDestroy = ComponentDestroy
UIJeepAdventureMainStageItem.DataDefine = DataDefine
UIJeepAdventureMainStageItem.DataDestroy = DataDestroy
UIJeepAdventureMainStageItem.OnAddListener = OnAddListener
UIJeepAdventureMainStageItem.OnRemoveListener = OnRemoveListener
UIJeepAdventureMainStageItem.SetData = SetData
UIJeepAdventureMainStageItem.GetFirstReward = GetFirstReward
return UIJeepAdventureMainStageItem
