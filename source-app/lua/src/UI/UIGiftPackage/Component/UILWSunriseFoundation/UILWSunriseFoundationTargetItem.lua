local UILWSunriseFoundationTargetItem = BaseClass("UILWSunriseFoundationTargetItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UILWSunriseFoundationItemCell = require("UI.UIGiftPackage.Component.UILWSunriseFoundation.UILWSunriseFoundationItemCell")
local line_bg_path = "lineBg"
local progress_content_path = "progressContent"
local progress_bg_path = "progressContent/progressBg"
local progress_bg_val_path = "progressContent/progressBgVal"
local icon_path = "progressContent/Icon"
local num_val_path = "progressContent/NumVal"
local cell_top_path = "CellTop"
local cell_bottom1_path = "CellBottom1"
local cell_bottom2_path = "CellBottom2"

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
  self.line_bg = self:AddComponent(UIImage, line_bg_path)
  self.progress_content = self:AddComponent(UIBaseContainer, progress_content_path)
  self.progress_bg = self:AddComponent(UIImage, progress_bg_path)
  self.progress_bg_val = self:AddComponent(UIImage, progress_bg_val_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.num_val = self:AddComponent(UITextMeshProUGUIEx, num_val_path)
  self.cell_top = self:AddComponent(UILWSunriseFoundationItemCell, cell_top_path)
  self.cell_bottom1 = self:AddComponent(UILWSunriseFoundationItemCell, cell_bottom1_path)
  self.cell_bottom2 = self:AddComponent(UILWSunriseFoundationItemCell, cell_bottom2_path)
end

local function ComponentDestroy(self)
  self.line_bg = nil
  self.progress_content = nil
  self.progress_bg = nil
  self.progress_bg_val = nil
  self.icon = nil
  self.num_val = nil
  self.cell_top = nil
  self.cell_bottom1 = nil
  self.cell_bottom2 = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetItem(self, data, curNum, maxNum, curLv, targets, buyState, actId)
  self.data = data
  self.maxNum = maxNum
  self.curNum = curNum
  self.curLv = curLv
  self.targets = targets
  self.buyState = buyState
  self.actId = actId
  self:RefreshAll()
end

local function RefreshAll(self)
  self:RefreshProgressContent()
  self:RefreshRewardContent()
end

local function RefreshProgressContent(self)
  local index = self.curNum
  local itemLv = self.data.level
  local bgSizeData = self.progress_content:GetSizeDelta()
  self.num_val:SetText(itemLv)
  local bgImgPath = ""
  if index == self.maxNum then
    bgImgPath = string.format(LoadPath.UIGrowFoundation, "Sunrise/lyt_shuguangjijin_jindutiaodi2")
    self.line_bg:SetActive(false)
  else
    bgImgPath = string.format(LoadPath.UIGrowFoundation, "Sunrise/lyt_shuguangjijin_jindutiaodi")
    self.line_bg:SetActive(true)
  end
  self.progress_bg:LoadSprite(bgImgPath)
  self.progress_bg:SetNativeSize()
  self.icon:SetActive(itemLv <= self.curLv)
  local curItemData = self.data
  local preItemData, nextItemData
  if index - 1 > 0 then
    preItemData = self.targets[index - 1]
  end
  if index + 1 <= self.maxNum then
    nextItemData = self.targets[index + 1]
  end
  local preLv = preItemData and preItemData.level or 0
  local nextLv = nextItemData and nextItemData.level or curItemData.level
  local progressRate = 0
  if itemLv > self.curLv then
    local rate = 0
    if itemLv == preLv then
      rate = 0
    else
      rate = (self.curLv - preLv) / (itemLv - preLv)
    end
    progressRate = rate - 0.5
  else
    local rate = 0
    if itemLv == nextLv then
      rate = 0
    else
      rate = (self.curLv - itemLv) / (nextLv - itemLv)
    end
    progressRate = rate + 0.5
  end
  if progressRate < 0 then
    progressRate = 0
  elseif 1 < progressRate then
    progressRate = 1
  end
  self.progress_bg_val:SetSizeDeltaY(bgSizeData.y * progressRate)
end

local function RefreshRewardContent(self)
  local data = self.data
  
  local function CreateCommonItemData()
    local data = {
      buyState = self.buyState,
      actId = self.actId,
      curLv = self.curLv,
      itemLv = self.data.level
    }
    return data
  end
  
  local normalReward = DataCenter.RewardManager:ReturnRewardParamForView(data.reward)
  if normalReward and normalReward[1] then
    local dataTop = CreateCommonItemData()
    dataTop.reward = normalReward[1]
    dataTop.state = data.rewardFlag
    dataTop.isFree = true
    dataTop.locked = self.data.level > self.curLv
    self.cell_top:SetActive(true)
    self.cell_top:SetData(dataTop, function(param)
      self:OnClckRewardItem(param)
    end)
  else
    self.cell_top:SetActive(false)
  end
  local specialReward = DataCenter.RewardManager:ReturnRewardParamForView(data.specialReward)
  if specialReward and specialReward[1] then
    local dataBottom1 = CreateCommonItemData()
    dataBottom1.reward = specialReward[1]
    dataBottom1.state = data.specialRewardFlag
    dataBottom1.isFree = false
    dataBottom1.locked = self.data.level > self.curLv or self.buyState == false
    self.cell_bottom1:SetActive(true)
    self.cell_bottom1:SetData(dataBottom1, function(param)
      self:OnClckRewardItem(param)
    end)
  else
    self.cell_bottom1:SetActive(false)
  end
  if specialReward and specialReward[2] then
    local dataBottom2 = CreateCommonItemData()
    dataBottom2.reward = specialReward[2]
    dataBottom2.state = data.specialRewardFlag
    dataBottom2.isFree = false
    dataBottom2.locked = self.data.level > self.curLv or self.buyState == false
    self.cell_bottom2:SetActive(true)
    self.cell_bottom2:SetData(dataBottom2, function(param)
      self:OnClckRewardItem(param)
    end)
  else
    self.cell_bottom2:SetActive(false)
  end
end

local function OnClckRewardItem(self, param)
  if self.data == nil then
    return
  end
  local locked = self.data.level > self.curLv
  if locked then
    return
  end
  if param.isFree and self.data.normalState == 1 or not param.isFree and self.data.specialState == 1 then
    return
  end
  local needBuy = false
  if not param.isFree and self.data.specialState ~= 1 and self.buyState == false then
    needBuy = true
  end
  if needBuy then
    local windowName = UIWindowNames.UISunriseFoundationPopUpPanel
    UIManager:GetInstance():OpenWindow(windowName, {anim = true}, self.actId)
  else
    SFSNetwork.SendMessage(MsgDefines.SunriseReceiveReward, self.actId)
  end
end

UILWSunriseFoundationTargetItem.OnCreate = OnCreate
UILWSunriseFoundationTargetItem.OnDestroy = OnDestroy
UILWSunriseFoundationTargetItem.ComponentDefine = ComponentDefine
UILWSunriseFoundationTargetItem.ComponentDestroy = ComponentDestroy
UILWSunriseFoundationTargetItem.DataDefine = DataDefine
UILWSunriseFoundationTargetItem.DataDestroy = DataDestroy
UILWSunriseFoundationTargetItem.OnAddListener = OnAddListener
UILWSunriseFoundationTargetItem.OnRemoveListener = OnRemoveListener
UILWSunriseFoundationTargetItem.SetItem = SetItem
UILWSunriseFoundationTargetItem.RefreshAll = RefreshAll
UILWSunriseFoundationTargetItem.OnClckRewardItem = OnClckRewardItem
UILWSunriseFoundationTargetItem.RefreshProgressContent = RefreshProgressContent
UILWSunriseFoundationTargetItem.RefreshRewardContent = RefreshRewardContent
return UILWSunriseFoundationTargetItem
