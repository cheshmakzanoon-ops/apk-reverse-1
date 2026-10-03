local base = UIBaseContainer
local UISeasonBattlePassRewardItem = BaseClass("UISeasonBattlePassRewardItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIBattlePassItemCell = require("UI.UIActivityCenterTable.Component.UIBattlePassNewYear.UIBattlePassNewYearItemCell")
local desc_path = "Root/Desc"
local greed = Color.New(0.18, 1, 0, 1)

function UISeasonBattlePassRewardItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UISeasonBattlePassRewardItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISeasonBattlePassRewardItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.root_go = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.cell_top = self.viewSkin:AddComponent(self, UIBattlePassItemCell, 2)
  self.cell_bottom_1 = self.viewSkin:AddComponent(self, UIBattlePassItemCell, 3)
  self.cell_bottom_2 = self.viewSkin:AddComponent(self, UIBattlePassItemCell, 4)
  self.icon = self.viewSkin:AddComponent(self, UIImage, 5)
  self.highReward1 = self.viewSkin:AddComponent(self, UIBattlePassItemCell, 6)
  self.highReward2 = self.viewSkin:AddComponent(self, UIBattlePassItemCell, 7)
  self.bg1 = self.viewSkin:AddComponent(self, UIImage, 8)
  self.bg2 = self.viewSkin:AddComponent(self, UIImage, 9)
  self.bg3 = self.viewSkin:AddComponent(self, UIImage, 10)
  self.desc_text = self:AddComponent(UIText, desc_path)
end

function UISeasonBattlePassRewardItem:ComponentDestroy()
  self.viewSkin = nil
  self.root_go = nil
  self.cell_top = nil
  self.cell_bottom_1 = nil
  self.cell_bottom_2 = nil
  self.icon = nil
  self.highReward1 = nil
  self.highReward2 = nil
  self.bg1 = nil
  self.bg2 = nil
  self.bg3 = nil
  self.desc_text = nil
end

function UISeasonBattlePassRewardItem:DataDefine()
  self.view = nil
  self.data = nil
  self.onClick = nil
end

function UISeasonBattlePassRewardItem:DataDestroy()
  self.view = nil
  self.data = nil
  self.onClick = nil
end

function UISeasonBattlePassRewardItem:OnAddListener()
  base.OnAddListener(self)
end

function UISeasonBattlePassRewardItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UISeasonBattlePassRewardItem:SendMessage(specialState)
  if self.data.type == EnumActivity.BattlePass_new.Type then
    SFSNetwork.SendMessage(MsgDefines.NewReceiveBPStageReward, self.data.actId, self.data.level, specialState)
  else
    SFSNetwork.SendMessage(MsgDefines.ReceiveBattlePassStageReward, self.data.actId, self.data.level, specialState)
  end
end

function UISeasonBattlePassRewardItem:OnClckRewardItem(param)
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

function UISeasonBattlePassRewardItem:SetData(data, view, scoreItemId)
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

function UISeasonBattlePassRewardItem:SetBlank()
  self.root_go:SetActive(false)
end

function UISeasonBattlePassRewardItem:GetPackagePopUpWindowName()
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

return UISeasonBattlePassRewardItem
