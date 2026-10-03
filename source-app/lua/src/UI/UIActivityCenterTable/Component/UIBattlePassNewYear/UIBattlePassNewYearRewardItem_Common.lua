local UIBattlePassNewYearRewardItem_Common = BaseClass("UIBattlePassNewYearRewardItem_Common", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIBattlePassItemCell = require("UI.UIActivityCenterTable.Component.UIBattlePassNewYear.UIBattlePassNewYearItemCell_Common")
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

function UIBattlePassNewYearRewardItem_Common:SendMessage(specialState)
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
  self.root_go = self:AddComponent(UIBaseContainer, root_path)
  self.cell_top = self:AddComponent(UIBattlePassItemCell, cell_top_path)
  self.cell_bottom_1 = self:AddComponent(UIBattlePassItemCell, cell_bottom_1_path)
  self.cell_bottom_2 = self:AddComponent(UIBattlePassItemCell, cell_bottom_2_path)
  self.desc_text = self:AddComponent(UIText, desc_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.highReward1 = self:AddComponent(UIBattlePassItemCell, highReward1_path)
  self.highReward2 = self:AddComponent(UIBattlePassItemCell, highReward2_path)
  self.bg1 = self:AddComponent(UIImage, bg1_path)
  self.bg2 = self:AddComponent(UIImage, bg2_path)
  self.bg3 = self:AddComponent(UIImage, bg3_path)
end

local function ComponentDestroy(self)
  self.root_go = nil
  self.cell_top = nil
  self.cell_bottom_1 = nil
  self.cell_bottom_2 = nil
  self.desc_text = nil
  self.icon = nil
  self.highReward1 = nil
  self.highReward2 = nil
  self.bg1 = nil
  self.bg2 = nil
  self.bg3 = nil
end

local function DataDefine(self)
  self.view = nil
  self.data = nil
  self.onClick = nil
  self.bgDefaultPath1 = "Assets/Main/Sprites/UI/UINewYearBP/zyf_xinnianbp_ditiao1.png"
  self.bgDefaultPath2 = "Assets/Main/Sprites/UI/UINewYearBP/zyf_xinnianbp_ditiao2.png"
  self.bgDefaultPath3 = "Assets/Main/Sprites/UI/UINewYearBP/zyf_xinnianbp_ditiao3.png"
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
  local itemId = GetTableData(TableName.Activity, data.actId, "para_5")
  if itemId and not scoreItemId then
    scoreItemId = itemId
  end
  if not string.IsNullOrEmpty(scoreItemId) then
    local iconPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, tonumber(scoreItemId))
    self.icon:LoadSprite(iconPath)
  else
    self.icon:LoadSprite(DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.ItemPath, "zyf_battlepass_icon2"))
  end
  self.root_go:SetActive(true)
  local needAccuExp = DataCenter.ActBattlePassTemplateManager:GetLevelNeedAccuExp(data.actId, data.level, data.type)
  self.desc_text:SetText(math.floor(needAccuExp))
  local temp = DataCenter.ActBattlePassTemplateManager:GetTemplateById(data.actId, data.level, data.type)
  local locked, checked, canGet, effectShow
  locked = data.curLv < data.level
  checked = data.normalState == 1
  local specialChecked = data.specialState == 1
  canGet = not locked and not checked
  if temp then
    effectShow = temp.effect_show > 0
  end
  
  local function CreateCommonItemData()
    local data = {
      locked = locked,
      unlock = data.unlock,
      high_unlock = data.high_unlock,
      actId = data.actId,
      lv = data.level,
      effectShow = effectShow
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
  local actId = self.data.actId
  local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
  local showTemp
  if activityData then
    showTemp = activityData:GetShowConfigTemp()
  end
  if showTemp and not string.IsNullOrEmpty(showTemp.pic_spec4 or showTemp.pic_spec2) then
    local picNameList = string.split(showTemp.pic_spec4 or showTemp.pic_spec2, "|")
    for i = 1, 3 do
      if not string.IsNullOrEmpty(picNameList[i]) then
        local picPath = DataCenter.ActivityListDataManager:GetActivityModLoadPath(LoadPath.BPNewYear, picNameList[i])
        local nodeName = "bg" .. i
        self[nodeName]:LoadSprite(picPath)
      end
    end
  else
    for i = 1, 3 do
      local picPath = "bgDefaultPath" .. i
      local nodeName = "bg" .. i
      self[nodeName]:LoadSprite(self[picPath])
    end
  end
  if showTemp then
    local picScale = showTemp.bp_pic_scale
    self.icon:SetLocalScaleXYZ(picScale, picScale, picScale)
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
      local showTemp = activityData:GetShowConfigTemp()
      if showTemp and string.IsNullOrEmpty(showTemp.pic_spec3) then
        viewName = UIWindowNames.UIBattlePassNewYearGiftPackagePopUp
      else
        viewName = UIWindowNames.UIBattlePassNewYearGiftPackagePopUp_Common
      end
    end
  end
  return viewName
end

UIBattlePassNewYearRewardItem_Common.OnCreate = OnCreate
UIBattlePassNewYearRewardItem_Common.OnDestroy = OnDestroy
UIBattlePassNewYearRewardItem_Common.OnEnable = OnEnable
UIBattlePassNewYearRewardItem_Common.OnDisable = OnDisable
UIBattlePassNewYearRewardItem_Common.ComponentDefine = ComponentDefine
UIBattlePassNewYearRewardItem_Common.ComponentDestroy = ComponentDestroy
UIBattlePassNewYearRewardItem_Common.DataDefine = DataDefine
UIBattlePassNewYearRewardItem_Common.DataDestroy = DataDestroy
UIBattlePassNewYearRewardItem_Common.OnAddListener = OnAddListener
UIBattlePassNewYearRewardItem_Common.OnRemoveListener = OnRemoveListener
UIBattlePassNewYearRewardItem_Common.SetData = SetData
UIBattlePassNewYearRewardItem_Common.SetBlank = SetBlank
UIBattlePassNewYearRewardItem_Common.OnClckRewardItem = OnClckRewardItem
UIBattlePassNewYearRewardItem_Common.GetPackagePopUpWindowName = GetPackagePopUpWindowName
return UIBattlePassNewYearRewardItem_Common
