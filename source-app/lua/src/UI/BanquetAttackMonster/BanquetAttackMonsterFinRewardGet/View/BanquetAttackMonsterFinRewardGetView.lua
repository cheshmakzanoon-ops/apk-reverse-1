local BanquetAttackMonsterFinRewardGetView = BaseClass("BanquetAttackMonsterFinRewardGetView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "UICommonRewardPopUp/Panel"
local banner_path = "UICommonRewardPopUp/Panel/Banner"
local img_title_bg_path = "UICommonRewardPopUp/Panel/ImgTitleBg"
local title_name_path = "UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle"
local layout_path = "layoutContent"
local scroll_view_path = "layoutContent/CellShowList"
local special_bg_path = "SpecialBg"
local other_title_text_path = "SpecialBg/OtherTitleBg/OtherTitleText"
local back_btn_path = "layoutContent/BackBtn"
local tip_txt2_path = "layoutContent/tipTxt2"
local CloseWaitTime = 800

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layout.rectTransform)
  self:ReInit()
end

local function OnDestroy(self)
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, panel_path)
  self.banner = self:AddComponent(UIBaseContainer, banner_path)
  self.img_title_bg = self:AddComponent(UIImage, img_title_bg_path)
  self.title_name = self:AddComponent(UIText, title_name_path)
  self.layout = self:AddComponent(UIBaseContainer, layout_path)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.btn:SetOnClick(function()
    self:ViewCloseFuinc()
  end)
  self.back_btn:SetOnClick(function()
    self:ViewCloseFuinc()
  end)
  if self.transform:Find(special_bg_path) ~= nil then
    self.special_bg = self:AddComponent(UIBaseContainer, special_bg_path)
    self.special_bg:SetActive(true)
  end
  if self.transform:Find(other_title_text_path) ~= nil then
    self.other_title_text = self:AddComponent(UITextMeshProUGUIEx, other_title_text_path)
  end
  self.tip_txt2 = self:AddComponent(UITextMeshProUGUIEx, tip_txt2_path)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.banner = nil
  self.img_title_bg = nil
  self.title_name = nil
  self.scroll_view = nil
  self.special_bg = nil
  self.other_title_text = nil
  self.tip_txt2 = nil
end

local function DataDefine(self)
  self.param = nil
  self.msg = nil
  self.nameText = nil
  self.closeTime = 0
end

local function DataDestroy(self)
  self.param = nil
  self.msg = nil
  self.nameText = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  local param, msg = self:GetUserData()
  self.param = param
  self.msg = msg
  self.banner:SetActive(true)
  self.img_title_bg:SetActive(true)
  if self.special_bg then
    self.special_bg:SetActive(true)
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.closeTime = curTime + CloseWaitTime
  self:ShowCells()
  self:SetTipTxtShow()
end

local function SetTipTxtShow(self)
  local tipStrKey = "activity_newparty_desc13"
  local rewardType = RewardType.GOODS
  local tipItemId = 0
  local tipItemNum = 0
  local tipItemName = ""
  if 0 < #self.param.rewardList then
    local targetReward = self.param.rewardList[1]
    if targetReward.rewardType == RewardType.GOODS then
      rewardType = targetReward.rewardType
      tipItemId = targetReward.itemId
      tipItemNum = targetReward.count
      tipItemName = DataCenter.RewardManager:GetNameByType(targetReward.rewardType, tipItemId)
    end
  end
  local actBanquetTemplate = DataCenter.ActBanquetV2Data.actBanquetTemplate
  local curMonsterIndex = self.msg.oldIndex or 0
  local curMonsterId = actBanquetTemplate.monster_order[curMonsterIndex + 1]
  local curMonsterTemp = DataCenter.ActivityPartyMonsterTemplateManager:GetTemplate(curMonsterId)
  for i, v in ipairs(curMonsterTemp.show_reward_text) do
    if v[1] == rewardType and v[2] == toInt(tipItemId) and v[3] == tipItemNum then
      tipStrKey = v[4]
      break
    end
  end
  self.tip_txt2:SetLocalText(tipStrKey, tipItemNum, tipItemName)
end

local function ClearScroll(self)
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UICommonResItem)
end

local function OnCreateCell(self, itemObj, index)
  itemObj.name = tostring(index)
  local cellItem
  cellItem = self.scroll_view:AddComponent(UICommonResItem, itemObj)
  local rewardParam = self.param.rewardList[index]
  cellItem:ReInit(rewardParam)
end

local function OnDeleteCell(self, itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UICommonResItem)
end

local function ShowCells(self)
  self:ClearScroll()
  self.scroll_view:SetTotalCount(#self.param.rewardList)
  self.scroll_view:RefillCells()
end

local function ViewCloseFuinc(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime >= self.closeTime then
    EventManager:GetInstance():Broadcast(EventId.ActBanquetAttackMonsterFinBoxConfirmClose, self.param)
    self.ctrl:CloseSelf()
  end
end

BanquetAttackMonsterFinRewardGetView.OnCreate = OnCreate
BanquetAttackMonsterFinRewardGetView.OnDestroy = OnDestroy
BanquetAttackMonsterFinRewardGetView.OnEnable = OnEnable
BanquetAttackMonsterFinRewardGetView.OnDisable = OnDisable
BanquetAttackMonsterFinRewardGetView.ComponentDefine = ComponentDefine
BanquetAttackMonsterFinRewardGetView.ComponentDestroy = ComponentDestroy
BanquetAttackMonsterFinRewardGetView.DataDefine = DataDefine
BanquetAttackMonsterFinRewardGetView.DataDestroy = DataDestroy
BanquetAttackMonsterFinRewardGetView.OnAddListener = OnAddListener
BanquetAttackMonsterFinRewardGetView.OnRemoveListener = OnRemoveListener
BanquetAttackMonsterFinRewardGetView.ViewCloseFuinc = ViewCloseFuinc
BanquetAttackMonsterFinRewardGetView.ReInit = ReInit
BanquetAttackMonsterFinRewardGetView.OnDeleteCell = OnDeleteCell
BanquetAttackMonsterFinRewardGetView.ShowCells = ShowCells
BanquetAttackMonsterFinRewardGetView.OnCreateCell = OnCreateCell
BanquetAttackMonsterFinRewardGetView.ClearScroll = ClearScroll
BanquetAttackMonsterFinRewardGetView.SetTipTxtShow = SetTipTxtShow
return BanquetAttackMonsterFinRewardGetView
