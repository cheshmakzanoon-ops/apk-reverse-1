local UIBattlePassNewYearRewardItem = BaseClass("UIBattlePassNewYearRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIBattlePassItemCell = require("UI.UIActivityCenterTable.Component.UIBattlePassNewYear.UIBattlePassNewYearItemCell")
local root_path = "Root"
local cell_top_path = "Root/CellTop"
local cell_bottom_1_path = "Root/CellBottom1"
local cell_bottom_2_path = "Root/CellBottom2"
local desc_path = "Root/Desc"
local icon_path = "Root/Icon"
local highReward1_path = "Root/CellHighPayReward1"
local highReward2_path = "Root/CellHighPayReward2"
local bg1_path = "Root/Bg1"
local bg2_path = "Root/Bg2"
local bg3_path = "Root/Bg3"
local greed = Color.New(0.18, 1, 0, 1)

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

function UIBattlePassNewYearRewardItem:SendMessage(specialState)
  if self.data.type == EnumActivity.BattlePass_new.Type then
    SFSNetwork.SendMessage(MsgDefines.NewReceiveBPStageReward, self.data.actId, self.data.level, specialState)
  else
    SFSNetwork.SendMessage(MsgDefines.ReceiveBattlePassStageReward, self.data.actId, self.data.level, specialState)
  end
end

local function OnClckRewardItem(self, param)
  if self.data == nil then
    return
  end
  local locked = self.data.curLv < self.data.level
  if locked then
    return
  end
  if self.data.normalState == 1 and self.data.specialState == 1 and self.data.hightRewardState == 1 then
    return
  end
  if param.isFree and self.data.normalState == 1 or param.isPay and self.data.specialState == 1 or param.isHighPay and self.data.hightRewardState == 1 then
    return
  end
  local windowName = self:GetPackagePopUpWindowName()
  if param.isHighPay and self.data.high_unlock == 0 then
    UIManager:GetInstance():OpenWindow(windowName, {anim = true}, self.data.actId, true)
    return
  elseif param.isPay and self.data.unlock == 0 then
    UIManager:GetInstance():OpenWindow(windowName, {anim = true}, self.data.actId, false)
    return
  end
  self:SendMessage(3)
end

local function ComponentDefine(self)
  self.bg1 = self:AddComponent(UIImage, bg1_path)
  self.bg2 = self:AddComponent(UIImage, bg2_path)
  self.bg3 = self:AddComponent(UIImage, bg3_path)
  self.root_go = self:AddComponent(UIBaseContainer, root_path)
  self.cell_top = self:AddComponent(UIBattlePassItemCell, cell_top_path)
  self.cell_bottom_1 = self:AddComponent(UIBattlePassItemCell, cell_bottom_1_path)
  self.cell_bottom_2 = self:AddComponent(UIBattlePassItemCell, cell_bottom_2_path)
  self.desc_text = self:AddComponent(UIText, desc_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.highReward1 = self:AddComponent(UIBattlePassItemCell, highReward1_path)
  self.highReward2 = self:AddComponent(UIBattlePassItemCell, highReward2_path)
end

local function ComponentDestroy(self)
  self.bg1 = nil
  self.bg2 = nil
  self.bg3 = nil
  self.root_go = nil
  self.cell_top = nil
  self.cell_bottom_1 = nil
  self.cell_bottom_2 = nil
  self.desc_text = nil
  self.icon = nil
  self.highReward1 = nil
  self.highReward2 = nil
end

local function DataDefine(self)
  self.view = nil
  self.data = nil
  self.onClick = nil
end

local function DataDestroy(self)
  self.view = nil
  self.data = nil
  self.onClick = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetData(self, data, view, scoreItemId)
  self.view = view
  self.data = data
  if data.forSeason and data.seasonType == SeasonMapType.NineNation then
    if data.seasonSubdivisionType == SeasonMapType.NineNation then
      self.bg1:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/CommonS5/bp/lrb_s5_zhanling_ditiao1.png")
      self.bg2:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/CommonS5/bp/lrb_s5_zhanling_ditiao2.png")
      self.bg3:LoadSprite("Assets/Main/SeasonRes/S5/Sprites/CommonS5/bp/lrb_s5_zhanling_ditiao3.png")
    elseif data.seasonSubdivisionType == SeasonMapType.NineNationRainforest then
      self.bg1:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/CommonS6/bp/mjc_s6_zhanling_ditiao1.png")
      self.bg2:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/CommonS6/bp/mjc_s6_zhanling_ditiao2.png")
      self.bg3:LoadSprite("Assets/Main/SeasonRes/S6/Sprites/CommonS6/bp/mjc_s6_zhanling_ditiao3.png")
    end
  else
    self.bg1:LoadSprite("Assets/Main/Sprites/UI/UINewYearBP/zyf_xinnianbp_ditiao1.png")
    self.bg2:LoadSprite("Assets/Main/Sprites/UI/UINewYearBP/zyf_xinnianbp_ditiao2.png")
    self.bg3:LoadSprite("Assets/Main/Sprites/UI/UINewYearBP/zyf_xinnianbp_ditiao3.png")
  end
  local itemId = GetTableData(TableName.Activity, data.actId, "para_5")
  if itemId and not scoreItemId then
    scoreItemId = itemId
  end
  if not string.IsNullOrEmpty(scoreItemId) then
    local iconPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, tonumber(scoreItemId))
    self.icon:LoadSprite(iconPath)
  else
    self.icon:LoadSprite(string.format(LoadPath.ItemPath, "zyf_battlepass_icon2"))
  end
  self.root_go:SetActive(true)
  local needAccuExp = DataCenter.ActBattlePassTemplateManager:GetLevelNeedAccuExp(data.actId, data.level, data.type)
  self.desc_text:SetText(math.floor(needAccuExp))
  local locked, checked, canGet
  locked = data.curLv < data.level
  checked = data.normalState == 1
  local specialChecked = data.specialState == 1
  canGet = not locked and not checked
  
  local function CreateCommonItemData()
    local data = {
      locked = locked,
      unlock = data.unlock,
      high_unlock = data.high_unlock,
      actId = data.actId,
      lv = data.level
    }
    return data
  end
  
  if data.normalReward[1] then
    local dataTop = CreateCommonItemData()
    dataTop.reward = data.normalReward[1]
    dataTop.state = data.normalState
    dataTop.isFree = true
    self.cell_top:SetActive(true)
    self.cell_top:SetData(dataTop)
  else
    self.cell_top:SetActive(false)
  end
  self.desc_text:SetColor(WhiteColor)
  if locked then
  elseif checked and not specialChecked then
    self.desc_text:SetColor(greed)
  elseif not checked then
    self.desc_text:SetColor(greed)
  else
    self.desc_text:SetColor(greed)
  end
  checked = data.specialState == 1
  canGet = not locked and not checked
  if data.specialReward[1] then
    local dataBottom1 = CreateCommonItemData()
    dataBottom1.reward = data.specialReward[1]
    dataBottom1.state = data.specialState
    dataBottom1.isPay = true
    self.cell_bottom_1:SetActive(true)
    self.cell_bottom_1:SetData(dataBottom1)
  else
    self.cell_bottom_1:SetActive(false)
  end
  if data.specialReward[2] then
    local dataBottom2 = CreateCommonItemData()
    dataBottom2.reward = data.specialReward[2]
    dataBottom2.state = data.specialState
    dataBottom2.isPay = true
    self.cell_bottom_2:SetActive(true)
    self.cell_bottom_2:SetData(dataBottom2)
  else
    self.cell_bottom_2:SetActive(false)
  end
  if data.highReward[1] then
    local dataHighReward1 = CreateCommonItemData()
    dataHighReward1.reward = data.highReward[1]
    dataHighReward1.state = data.hightRewardState
    dataHighReward1.isHighPay = true
    self.highReward1:SetActive(true)
    self.highReward1:SetData(dataHighReward1)
  else
    self.highReward1:SetActive(false)
  end
  if data.highReward[2] then
    local dataHighReward2 = CreateCommonItemData()
    dataHighReward2.reward = data.highReward[2]
    dataHighReward2.state = data.hightRewardState
    dataHighReward2.isHighPay = true
    self.highReward2:SetActive(true)
    self.highReward2:SetData(dataHighReward2)
  else
    self.highReward2:SetActive(false)
  end
end

local function SetBlank(self)
  self.root_go:SetActive(false)
end

local function GetPackagePopUpWindowName(self)
  local actId = self.data.actId
  local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
  local viewName = UIWindowNames.UIBattlePassNewYearGiftPackagePopUp
  if activityData then
    if activityData.subViewType == BattlePassType.NewYear then
      viewName = UIWindowNames.UIBattlePassNewYearGiftPackagePopUp
    elseif activityData.subViewType == BattlePassType.Valentine then
      viewName = UIWindowNames.UIBattlePassValentineGiftPackagePopUp
    elseif activityData.subViewType == BattlePassType.Easter then
      viewName = UIWindowNames.UIBattlePassEasterGiftPackagePopUp
    elseif activityData.subViewType == BattlePassType.NewYear_Common then
      viewName = UIWindowNames.UIBattlePassNewYearGiftPackagePopUp_Common
    end
  end
  return viewName
end

UIBattlePassNewYearRewardItem.OnCreate = OnCreate
UIBattlePassNewYearRewardItem.OnDestroy = OnDestroy
UIBattlePassNewYearRewardItem.OnEnable = OnEnable
UIBattlePassNewYearRewardItem.OnDisable = OnDisable
UIBattlePassNewYearRewardItem.ComponentDefine = ComponentDefine
UIBattlePassNewYearRewardItem.ComponentDestroy = ComponentDestroy
UIBattlePassNewYearRewardItem.DataDefine = DataDefine
UIBattlePassNewYearRewardItem.DataDestroy = DataDestroy
UIBattlePassNewYearRewardItem.OnAddListener = OnAddListener
UIBattlePassNewYearRewardItem.OnRemoveListener = OnRemoveListener
UIBattlePassNewYearRewardItem.SetData = SetData
UIBattlePassNewYearRewardItem.SetBlank = SetBlank
UIBattlePassNewYearRewardItem.OnClckRewardItem = OnClckRewardItem
UIBattlePassNewYearRewardItem.GetPackagePopUpWindowName = GetPackagePopUpWindowName
return UIBattlePassNewYearRewardItem
