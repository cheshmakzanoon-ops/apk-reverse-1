local base = UIBaseView
local UILWGuarantBoxView = BaseClass("UILWGuarantBoxView", base)
local SelectBoxItem = require("UI.UILWGuarantBox.Component.SelectBoxItem")
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local panel_btn_path = "UICommonPopUpTitle/panel"
local close_btn_path = "UICommonPopUpTitle/CloseBtn"
local score_slider_path = "ContentArea/ScoreArea/ScoreProgress"
local score_text_path = "ContentArea/ScoreArea/ScoreProgress/ProgressText"
local scoreDesc_text_path = "ContentArea/ScoreArea/ScoreDescText"
local selectedItemName_text_path = "ContentArea/SelectedItemArea/SelectedItemNameText"
local selectedItem_icon_path = "ContentArea/SelectedItemArea/SelectedItemIcon"
local selectedItem_btn_path = "ContentArea/SelectedItemArea/SelectedItemIcon"
local selectedItemNum_text_path = "ContentArea/SelectedItemArea/SelectedItemIcon/SelectedItemNumText"
local getMore_btn_path = "ContentArea/SelectedItemArea/GetMoreBtn"
local willGetScore_text_path = "ContentArea/SelectedItemArea/WillGetScore"
local selectedUse_area_path = "ContentArea/SelectedItemArea/SelectedUseArea"
local selectedUse_btn_path = "ContentArea/SelectedItemArea/SelectedUseArea/UseBtn"
local selectedUse_slider_path = "ContentArea/SelectedItemArea/SelectedUseArea/InfoInput/Slider"
local selectedUseDec_btn_path = "ContentArea/SelectedItemArea/SelectedUseArea/InfoInput/DecBtn"
local selectedUseAdd_btn_path = "ContentArea/SelectedItemArea/SelectedUseArea/InfoInput/AddBtn"
local selectedNum_text_path = "ContentArea/SelectedItemArea/SelectedUseArea/InfoInput/TextBg/CountText"
local itemList_path = "ContentArea/ItemListArea/ItemList"
local itemListContainer_path = "ContentArea/ItemListArea/ItemList/Viewport/Content"
local guarantItem_btn_path = "ContentArea/ScoreArea/Icon"
local guarantItem_icon_path = "ContentArea/ScoreArea/Icon"
local guarantItem_effect_path = "ContentArea/ScoreArea/Eff_ui_hero_shengji_jineng_xz_liuguang"
local score_icon_path = "ContentArea/ScoreArea/ScoreIcon"
local itemTemplate_path = "ContentArea/ItemListArea/BoxItem"
local animScore_icon_path = "ContentArea/ScoreArea/AnimScoreIcon"
local animMask_path = "AnimMask"
local guarantItemCount_text_path = "ContentArea/ScoreArea/ItemCountText"
local title_text_path = "UICommonPopUpTitle/Common_img_title/titleText"
local emptyTip_text_path = "ContentArea/SelectedItemArea/EmptyTipText"

local function FallbackChoose(self)
  local index, goodsId
  local goodsCount = 0
  for i, v in pairs(self.showItems) do
    local itemData = DataCenter.ItemData:GetItemById(v.id)
    if itemData and 0 < itemData.count and (not goodsId or goodsCount < itemData.count) then
      goodsId = v.id
      goodsCount = itemData.count
    end
  end
  if goodsId then
    self:SelectGoodsId(goodsId)
    for i, v in pairs(self.showItems) do
      if v.id == goodsId then
        index = i
        break
      end
    end
  end
  if not goodsId then
    goodsId = self.showItems[1].id
    self:SelectGoodsId(goodsId)
    index = 1
  end
  return index
end

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local guarantId, gotoGoodsId = self:GetUserData()
  gotoGoodsId = gotoGoodsId and tonumber(gotoGoodsId)
  self.guarantId = guarantId
  if not self.guarantId then
    self.ctrl:CloseSelf()
  end
  self.template = DataCenter.GuaranteedBoxTemplateManager:GetTemplate(self.guarantId)
  if not self.template then
    self.ctrl:CloseSelf()
  end
  self.guarantGroupItems = self.template.list_goods or {}
  self.guarantScoreGoodsId = self.template.point_goods or 0
  self.guarantGroupCount = self.template.target_point or 0
  local rewardInfo = self.template:GetFirstRewardInfo()
  if rewardInfo then
    self.guarantGroupRewardGoodsId = rewardInfo.id
    self.guarantGroupRewardCount = rewardInfo.count
  else
    self.guarantGroupRewardGoodsId = 0
    self.guarantGroupRewardCount = 0
  end
  self.title_text:SetLocalText(self.template.name)
  self.guarantItem_icon:LoadSprite(DataCenter.RewardManager:GetPicByType(RewardType.GOODS, self.guarantGroupRewardGoodsId))
  self.guarantItemCount_text:SetText(string.format("x%d", self.guarantGroupRewardCount))
  local scoreIconPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, self.guarantScoreGoodsId)
  self.score_icon:LoadSprite(scoreIconPath)
  local scoreGoodsName = ""
  if self.guarantScoreGoodsId > 0 then
    local scoreGoodsTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.guarantScoreGoodsId)
    if scoreGoodsTemplate then
      scoreGoodsName = Localization:GetString(scoreGoodsTemplate.name)
    end
  end
  local guarantGoodsName = ""
  if 0 < self.guarantGroupRewardGoodsId then
    local guarantGoodsTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(self.guarantGroupRewardGoodsId)
    if guarantGoodsTemplate then
      guarantGoodsName = Localization:GetString(guarantGoodsTemplate.name)
    end
  end
  self.scoreGoodsName = scoreGoodsName
  self.scoreDesc_text:SetLocalText("pointChest_desc_1", scoreGoodsName, guarantGoodsName)
  self.showItems = self.ctrl.FilterDataByShowType(self.showItems, self.guarantGroupItems)
  local index
  if gotoGoodsId then
    for i, v in pairs(self.showItems) do
      if v.id == gotoGoodsId then
        index = i
        break
      end
    end
    if index then
      self:SelectGoodsId(gotoGoodsId)
    end
  end
  if not self.selectedGoodsId then
    index = FallbackChoose(self)
  end
  self:OnOpen(index)
end

local function ClearScroll(self)
  self.itemListContainer:RemoveComponents(SelectBoxItem)
  self.itemList:ClearAllItems()
  self.selectedItem = nil
end

local function KillScoreAnim(self)
  if self.scoreAnimSeq then
    self.scoreAnimSeq:Kill()
    self.scoreAnimSeq = nil
  end
  self.animScore_icon:SetActive(false)
  self.animMask:SetActive(false)
end

local function OnDestroy(self)
  ClearScroll(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:OnOpen()
end

local function OnDisable(self)
  base.OnDisable(self)
  KillScoreAnim(self)
end

local function GetItemNameSequence(self)
  NameCount = NameCount + 1
  return tostring(NameCount)
end

local function OnGetItemByIndex(self, loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.showItems then
    return nil
  end
  local goods = self.showItems[index]
  local goodsId = goods.id
  local item = loopScroll:NewListViewItem("BoxItem")
  local script = self.itemListContainer:GetComponent(item.gameObject.name, SelectBoxItem)
  if script == nil then
    local objectName = GetItemNameSequence(self)
    item.gameObject.name = objectName
    script = self.itemListContainer:AddComponent(SelectBoxItem, objectName)
  end
  script:SetActive(true)
  if not self.clickItemCallback then
    self.clickItemCallback = BindCallback(self, self.SelectItem)
  end
  script:SetData(goodsId, self.clickItemCallback)
  script:SetSelected(self.selectedGoodsId == goodsId)
  if self.selectedGoodsId == goodsId then
    self.selectedItem = script
  end
  return item
end

local function PreviewItemReward(self, goodsId)
  local goodsTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(tonumber(goodsId))
  if not goodsTemplate then
    return
  end
  if goodsTemplate.type == GOODS_TYPE.GOODS_TYPE_5 then
    local dropInfoDetail = goodsTemplate.drop_info_para
    if 0 < dropInfoDetail then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIProbabilityNotice, {anim = true}, dropInfoDetail)
    end
  elseif goodsTemplate:IsSelectBox() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityBoxSelect, {anim = true}, nil, 1, goodsTemplate, false, true)
  end
end

local function ComponentDefine(self)
  self.panel_btn = self:AddComponent(UIButton, panel_btn_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.score_slider = self:AddComponent(UISlider, score_slider_path)
  self.score_text = self:AddComponent(UIText, score_text_path)
  self.scoreDesc_text = self:AddComponent(UIText, scoreDesc_text_path)
  self.selectedItemName_text = self:AddComponent(UIText, selectedItemName_text_path)
  self.selectedItem_icon = self:AddComponent(UIImage, selectedItem_icon_path)
  self.selectedItem_btn = self:AddComponent(UIButton, selectedItem_btn_path)
  self.selectedItemNum_text = self:AddComponent(UIText, selectedItemNum_text_path)
  self.getMore_btn = self:AddComponent(UIButton, getMore_btn_path)
  self.willGetScore_text = self:AddComponent(UIText, willGetScore_text_path)
  self.selectedUse_area = self:AddComponent(UIBaseContainer, selectedUse_area_path)
  self.selectedUse_btn = self:AddComponent(UIButton, selectedUse_btn_path)
  self.selectedUse_slider = self:AddComponent(UISlider, selectedUse_slider_path)
  self.selectedUseDec_btn = self:AddComponent(UIButton, selectedUseDec_btn_path)
  self.selectedUseAdd_btn = self:AddComponent(UIButton, selectedUseAdd_btn_path)
  self.selectedNum_text = self:AddComponent(UIText, selectedNum_text_path)
  self.itemList = self:AddComponent(UILoopListView2, itemList_path)
  self.itemListContainer = self:AddComponent(UIBaseContainer, itemListContainer_path)
  self.guarantItem_btn = self:AddComponent(UIButton, guarantItem_btn_path)
  self.guarantItem_icon = self:AddComponent(UIImage, guarantItem_icon_path)
  self.guarantItem_effect = self:AddComponent(UIBaseContainer, guarantItem_effect_path)
  self.score_icon = self:AddComponent(UIImage, score_icon_path)
  self.itemTemplate = self:AddComponent(SelectBoxItem, itemTemplate_path)
  self.animScore_icon = self:AddComponent(UIImage, animScore_icon_path)
  self.animMask = self:AddComponent(UIButton, animMask_path)
  self.guarantItemCount_text = self:AddComponent(UIText, guarantItemCount_text_path)
  self.title_text = self:AddComponent(UIText, title_text_path)
  self.emptyTip_text = self:AddComponent(UIText, emptyTip_text_path)
  self.panel_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.getMore_btn:SetOnClick(function()
    if not self.selectedGoodsId then
      return
    end
    LWResourceLackUtil:GotoGoodsItemLack(self.selectedGoodsId, 1)
  end)
  self.guarantItem_btn:SetOnClick(function()
    if not self.guarantScoreGoodsId or self.guarantScoreGoodsId <= 0 then
      return
    end
    local curScore = DataCenter.ItemData:GetItemCount(self.guarantScoreGoodsId)
    local needScore = self.guarantGroupCount
    if curScore >= needScore then
      local receiveCount = math.floor(curScore / needScore)
      SFSNetwork.SendMessage(MsgDefines.ReceiveGuarantBoxReward, self.guarantId, receiveCount)
    else
      PreviewItemReward(self, self.guarantGroupRewardGoodsId)
    end
  end)
  self.itemList:InitListView(0, function(loopView, index)
    return OnGetItemByIndex(self, loopView, index)
  end)
  self.selectedUse_slider:SetOnValueChanged(function(value)
    if self.notChangeData then
      return
    end
    local maxCount = self.selectedItemData.count or 0
    local count = math.floor(maxCount * value)
    self:SetSelectCount(count, true)
  end)
  self.selectedUseDec_btn:SetOnClick(function()
    local count = self.selectCount - 1
    self:SetSelectCount(count)
  end)
  self.selectedUseAdd_btn:SetOnClick(function()
    local count = self.selectCount + 1
    self:SetSelectCount(count)
  end)
  self.selectedUse_btn:SetOnClick(function()
    if not self.selectedGoodsId then
      return
    end
    local count = self.selectCount or 1
    self.ctrl:UseItem(self.selectedGoodsId, count)
  end)
  self.selectedItem_btn:SetOnClick(function()
    if not self.selectedGoodsId then
      return
    end
    PreviewItemReward(self, self.selectedGoodsId)
  end)
  self.guarantItem_effect:SetActive(false)
  self.animScore_icon:SetActive(false)
  self.animMask:SetOnClick(function()
    KillScoreAnim(self)
    self:RefreshScoreProgress()
  end)
  self.animMask:SetActive(false)
  self.title_text:SetText("")
  self.detailBtn = self:AddComponent(UIButton, "ContentArea/detailBtn")
  self.detailBtn:SetOnClick(function()
    if not self.selectedGoodsId then
      return
    end
    PreviewItemReward(self, self.selectedGoodsId)
  end)
  self.boxIconVfxNode = self:AddComponent(UIVfx, "ContentArea/SelectedItemArea/boxIconVfxNode")
  self.chipItemNode = self:AddComponent(UIBaseContainer, "ContentArea/SelectedItemArea/chipItemNode")
  self.propsItemNode = self:AddComponent(UIBaseContainer, "ContentArea/SelectedItemArea/propsItemNode")
end

local function ComponentDestroy(self)
  self.chipItemNode:RemoveComponents(UICommonResItem)
  self.propsItemNode:RemoveComponents(UICommonResItem)
  self.chipItemNode = nil
  self.propsItemNode = nil
  self.panel_btn = nil
  self.close_btn = nil
  self.score_slider = nil
  self.score_text = nil
  self.scoreDesc_text = nil
  self.selectedItemName_text = nil
  self.selectedItem_icon = nil
  self.selectedItem_btn = nil
  self.selectedItemNum_text = nil
  self.getMore_btn = nil
  self.willGetScore_text = nil
  self.selectedUse_area = nil
  self.selectedUse_btn = nil
  self.selectedUse_slider = nil
  self.selectedUseDec_btn = nil
  self.selectedUseAdd_btn = nil
  self.selectedNum_text = nil
  self.itemList = nil
  self.itemListContainer = nil
  self.guarantItem_btn = nil
  self.guarantItem_icon = nil
  self.guarantItem_effect = nil
  self.score_icon = nil
  self.itemTemplate = nil
  self.animScore_icon = nil
  self.animMask = nil
  self.guarantItemCount_text = nil
  self.title_text = nil
  self.emptyTip_text = nil
  self.boxIconVfxNode = nil
end

local function DataDefine(self)
  self.scoreAnimSeq = nil
end

local function DataDestroy(self)
end

local function RefreshScoreProgress(self)
  self.curScore = DataCenter.ItemData:GetItemCount(self.guarantScoreGoodsId)
  local maxScore = self.guarantGroupCount
  if maxScore <= 0 then
    self.score_slider:SetValue(0)
  else
    self.score_slider:SetValue(self.curScore / maxScore <= 1 and self.curScore / maxScore or 1)
  end
  self.score_text:SetText(string.format("%d/%d", self.curScore, maxScore))
  self.guarantItem_effect:SetActive(maxScore <= self.curScore)
end

local function RefreshItemList(self)
  if not table.IsNullOrEmpty(self.showItems) then
    self.itemList:SetActive(true)
    self.itemList:SetListItemCount(#self.showItems, false, false)
    self.itemList:RefreshAllShownItem()
  else
    self.itemList:SetActive(false)
  end
end

local function RefreshSelectedItemInfo(self)
  if not self.selectedGoodsId then
    return
  end
  local itemName = DataCenter.RewardManager:GetNameByType(RewardType.GOODS, self.selectedGoodsId)
  local itemQuality = DataCenter.RewardManager:GetRewardQuality(RewardType.GOODS, self.selectedGoodsId)
  if itemQuality == ItemColor.GREEN then
    itemName = string.format("<color=#67E198>%s</color>", itemName)
  elseif itemQuality == ItemColor.BLUE then
    itemName = string.format("<color=#5DCAEA>%s</color>", itemName)
  elseif itemQuality == ItemColor.PURPLE then
    itemName = string.format("<color=#DA82FF>%s</color>", itemName)
  elseif itemQuality == ItemColor.ORANGE then
    itemName = string.format("<color=#FDA946>%s</color>", itemName)
  end
  self.selectedItemName_text:SetText(itemName)
  local itemIconPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, self.selectedGoodsId)
  self.selectedItem_icon:LoadSprite(itemIconPath)
  local vfxName = string.format(VfxAssets.TacticalChipPropsBoxQualityPath, itemQuality)
  self.boxIconVfxNode:PlayByStay(vfxName)
  self.emptyTip_text:SetActive(false)
  if not self.selectedItemData or self.selectedItemData.count <= 0 then
    self.selectedUse_area:SetActive(false)
    self.getMore_btn:SetActive(true)
    self.selectedItemNum_text:SetText("")
    self:RefreshNumDesc()
    self.selectCount = 0
  else
    self.selectedUse_area:SetActive(true)
    self.getMore_btn:SetActive(false)
    self.selectedItemNum_text:SetText(string.format("x%d", self.selectedItemData.count))
    self.selectCount = 1
    self:RefreshSelectCount()
  end
end

function UILWGuarantBoxView:RefreshNumDesc()
  if not self.selectedGoodsId then
    return
  end
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.selectedGoodsId)
  local perScore = 0
  if template then
    local para3 = template.para3 or ""
    local paras = string.split(para3, ";")
    perScore = tonumber(paras[3]) or 0
  end
  self.willGetScore_text:SetLocalText("battlesystem_open_box_desc1", perScore, self.scoreGoodsName)
end

local function RefreshSelectCount(self, exceptSldier)
  if not self.selectedGoodsId or not self.selectedItemData then
    return
  end
  local selectCount = self.selectCount or 0
  local para3 = self.selectedItemData.goods.para3 or ""
  local paras = string.split(para3, ";")
  local goodsId = tonumber(paras[2]) or 0
  local perScore = tonumber(paras[3]) or 0
  local willGetScore = selectCount * perScore
  self.willGetScore_text:SetLocalText("battlesystem_open_box_desc1", willGetScore, self.scoreGoodsName)
  self.selectedNum_text:SetText(tostring(selectCount))
  self.notChangeData = true
  if not exceptSldier then
    self.selectedUse_slider:SetValue(selectCount / self.selectedItemData.count <= 1 and selectCount / self.selectedItemData.count or 1)
  end
  self.notChangeData = false
  UIGray.SetGray(self.selectedUseDec_btn.transform, selectCount <= 1, true)
  UIGray.SetGray(self.selectedUseAdd_btn.transform, selectCount >= self.selectedItemData.count, true)
end

function UILWGuarantBoxView:RefreshRewardItems()
  local selectCount = self.selectCount or 0
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.selectedGoodsId)
  local para3 = template.para3 or ""
  local paras = string.split(para3, ";")
  local scoreItemId = tonumber(paras[2]) or 0
  local perScore = tonumber(paras[3]) or 0
  local willGetScore = selectCount * perScore
  local para4 = template.para4 or ""
  local para4List = string.split(para4, ";")
  local goodsItemId = tonumber(para4List[2]) or 0
  local goodsPerNum = tonumber(para4List[3]) or 0
  local goodsNum = selectCount * goodsPerNum
  local chipParam = {}
  chipParam.itemId = goodsItemId
  chipParam.count = goodsNum
  chipParam.type = RewardType.GOODS
  if self.previewChipRewardItemReq and self.previewChipRewardItemReq.isDone then
    self.previewChipRewardItem:ReInit(chipParam)
  else
    if self.previewChipRewardItemReq then
      self.previewChipRewardItemReq:Destroy()
    end
    self.previewChipRewardItemReq = self:LoadRewardPreviewItem("chipReward", self.chipItemNode, function(cell)
      self.previewChipRewardItem = cell
      self.previewChipRewardItem:ReInit(chipParam)
    end)
  end
  local propsParam = {}
  propsParam.itemId = scoreItemId
  propsParam.count = willGetScore
  propsParam.type = RewardType.GOODS
  if self.previewPropsItemReq and self.previewPropsItemReq.isDone then
    self.previewPropsItem:ReInit(propsParam)
  else
    if self.previewPropsItemReq then
      self.previewPropsItemReq:Destroy()
    end
    self.previewPropsItemReq = self:LoadRewardPreviewItem("propsParam", self.chipItemNode, function(cell)
      self.previewPropsItem = cell
      self.previewPropsItem:ReInit(propsParam)
    end)
  end
end

local function SelectGoodsId(self, goodsId)
  if not goodsId then
    return
  end
  if self.selectedGoodsId == goodsId then
    return
  end
  self.selectedItemData = DataCenter.ItemData:GetItemById(goodsId)
  self.selectedGoodsId = goodsId
  self.perScore = nil
end

local function SelectItem(self, item, goodsId)
  if not goodsId then
    return
  end
  if self.selectedGoodsId == goodsId then
    return
  end
  self:SelectGoodsId(goodsId)
  if self.selectedItem then
    self.selectedItem:SetSelected(false)
  end
  item:SetSelected(true)
  self.selectedItem = item
  self:RefreshSelectedItemInfo()
end

local function OnOpen(self, index)
  KillScoreAnim(self)
  self:RefreshScoreProgress()
  self:RefreshItemList()
  self:RefreshSelectedItemInfo()
  if index then
    self.itemList:MovePanelToItemIndex(index - 1)
  end
end

local function SetSelectCount(self, count)
  if not self.selectedGoodsId or not self.selectedItemData then
    return
  end
  local maxCount = self.selectedItemData.count or 0
  if count > maxCount then
    count = maxCount
  end
  if count < 1 then
    count = 1
  end
  self.selectCount = count
  self:RefreshSelectCount()
end

local function OnItemsRefresh(self)
  if self.selectedGoodsId then
    self.selectedItemData = DataCenter.ItemData:GetItemById(self.selectedGoodsId)
  end
  self.showItems = self.ctrl.FilterDataByShowType(self.showItems, self.guarantGroupItems)
  self:RefreshItemList()
  self:RefreshSelectedItemInfo()
  if not self.guarantScoreGoodsId then
    return
  end
  local newScoreCount = DataCenter.ItemData:GetItemCount(self.guarantScoreGoodsId)
  if self.curScore and newScoreCount <= self.curScore then
    self:RefreshScoreProgress()
  elseif self.scoreAnimSeq then
    KillScoreAnim(self)
    self:RefreshScoreProgress()
  end
end

local function OnGiftRewardGetClose(self)
  if not self.curScore or not self.guarantGroupCount then
    KillScoreAnim(self)
    self:RefreshScoreProgress()
    return
  end
  if self.scoreAnimSeq then
    KillScoreAnim(self)
    self:RefreshScoreProgress()
    return
  end
  local newScoreCount = DataCenter.ItemData:GetItemCount(self.guarantScoreGoodsId)
  if newScoreCount <= self.curScore then
    KillScoreAnim(self)
    self:RefreshScoreProgress()
    return
  end
  self.scoreAnimSeq = DOTween.Sequence()
  local scoreIconPath = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, self.guarantScoreGoodsId)
  self.animScore_icon:LoadSprite(scoreIconPath)
  self.animScore_icon:SetPosition(self.selectedItem_icon:GetPosition())
  self.animScore_icon:SetActive(true)
  local dstPos = self.score_icon:GetPosition()
  local time = 0
  self.scoreAnimSeq:Append(self.animScore_icon.transform:DOMove(dstPos, 0.15))
  time = time + 0.6
  local prevProgress = self.curScore / self.guarantGroupCount
  local newProgress = newScoreCount / self.guarantGroupCount
  if 1 <= prevProgress then
    newProgress = 1
  elseif prevProgress < 1 and prevProgress < newProgress then
    self.scoreAnimSeq:Append(self.score_slider:DOValue(newProgress, 0.08))
    self.scoreAnimSeq:Append(DOTween.To(function(x)
      self.score_text:SetText(string.format("%d/%d", math.floor(x), self.guarantGroupCount))
    end, self.curScore, newScoreCount, 0.15))
  end
  self.scoreAnimSeq:AppendCallback(function()
    self.scoreAnimSeq = nil
    self:RefreshScoreProgress()
  end)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.OnItemsRefresh)
  self:AddUIListener(EventId.OnRewardGetPanelClose, self.OnGiftRewardGetClose)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshItems, self.OnItemsRefresh)
  self:RemoveUIListener(EventId.OnRewardGetPanelClose, self.OnGiftRewardGetClose)
  base.OnRemoveListener(self)
end

function UILWGuarantBoxView:LoadRewardPreviewItem(name, parent, callback)
  return self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
    local go = request.gameObject
    if IsNull(go) then
      return
    end
    go.gameObject:SetActive(true)
    go.transform:SetParent(parent.transform)
    go.transform:Set_localScale(0.9, 0.9, 0.9)
    go.transform:Set_localPosition(1, 1, 1)
    go.name = name
    local cell = parent:AddComponent(UICommonResItem, name)
    if callback then
      callback(cell)
    end
  end)
end

UILWGuarantBoxView.OnCreate = OnCreate
UILWGuarantBoxView.OnDestroy = OnDestroy
UILWGuarantBoxView.OnEnable = OnEnable
UILWGuarantBoxView.OnDisable = OnDisable
UILWGuarantBoxView.ComponentDefine = ComponentDefine
UILWGuarantBoxView.ComponentDestroy = ComponentDestroy
UILWGuarantBoxView.DataDefine = DataDefine
UILWGuarantBoxView.DataDestroy = DataDestroy
UILWGuarantBoxView.RefreshScoreProgress = RefreshScoreProgress
UILWGuarantBoxView.RefreshItemList = RefreshItemList
UILWGuarantBoxView.RefreshSelectedItemInfo = RefreshSelectedItemInfo
UILWGuarantBoxView.RefreshSelectCount = RefreshSelectCount
UILWGuarantBoxView.SelectItem = SelectItem
UILWGuarantBoxView.OnOpen = OnOpen
UILWGuarantBoxView.SetSelectCount = SetSelectCount
UILWGuarantBoxView.SelectGoodsId = SelectGoodsId
UILWGuarantBoxView.OnItemsRefresh = OnItemsRefresh
UILWGuarantBoxView.OnAddListener = OnAddListener
UILWGuarantBoxView.OnRemoveListener = OnRemoveListener
UILWGuarantBoxView.OnGiftRewardGetClose = OnGiftRewardGetClose
return UILWGuarantBoxView
