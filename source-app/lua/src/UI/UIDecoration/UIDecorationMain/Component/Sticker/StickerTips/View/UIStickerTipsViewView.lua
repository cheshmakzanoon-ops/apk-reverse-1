local base = require("UI.UILWHero.UIHeroSimpleTip.View.UIArrowTipBase")
local UIStickerTipsViewView = BaseClass("UIStickerTipsViewView", base)
local Localization = CS.GameEntry.Localization
local dynamic_path = "Root/ImgBg/dynamic"
local p_trans_sticker_path = "Root/ImgBg/dynamic/p_trans_sticker"
local root_vertical_path = "Root/ImgBg/root_vertical"
local _cp_txtName = "Root/ImgBg/root_vertical/TxtName"
local _cp_item_intro = "Root/ImgBg/root_vertical/TxtName/Intro"
local _cp_txtDesc = "Root/ImgBg/root_vertical/TxtDesc"
local rate_btn_content_path = "Root/ImgBg/root_vertical/rateBtnContent"
local rate_btn_path = "Root/ImgBg/root_vertical/rateBtnContent/rateBtn"
local txt_have_count_path = "Root/ImgBg/root_vertical/TxtHaveCount"
local tip_btn_content_path = "Root/ImgBg/root_vertical/tipBtnContent"
local tip_btn_path = "Root/ImgBg/root_vertical/tipBtnContent/tipBtn"
local use_btn_path = "Root/ImgBg/root_vertical/TxtName/UseBtn"

function UIStickerTipsViewView:ComponentDefine()
  base.ComponentDefine(self)
  self.dynamic = self:AddComponent(UIBaseContainer, dynamic_path)
  self.p_trans_sticker = self:AddComponent(UIBaseContainer, p_trans_sticker_path)
  self.root_vertical = self:AddComponent(UIBaseContainer, root_vertical_path)
  self._txtName = self:AddComponent(UIText, _cp_txtName)
  self._cp_intro = self:AddComponent(UIButton, _cp_item_intro)
  self._cp_intro:SetOnClick(function()
    self:OnClickItemProbability()
  end)
  self._txtDesc = self:AddComponent(UIText, _cp_txtDesc)
  self.rate_btn_content = self:AddComponent(UIBaseContainer, rate_btn_content_path)
  self.rate_btn = self:AddComponent(UIButton, rate_btn_path)
  self.rate_btn:SetOnClick(function()
    self:OnClickRateBtn()
  end)
  self.txt_have_count = self:AddComponent(UIText, txt_have_count_path)
  self.txt_have_count:SetActive(false)
  self.tip_btn_content = self:AddComponent(UIBaseContainer, tip_btn_content_path)
  self.tip_btn = self:AddComponent(UIButton, tip_btn_path)
  self.tip_btn:SetOnClick(function()
    self:OnClickTipBtn()
  end)
  self.useBtn = self:AddComponent(UIButton, use_btn_path)
  self.useBtn:SetOnClick(function()
    self:OnClickUseBtn()
  end)
end

function UIStickerTipsViewView:ComponentDestroy()
  base.ComponentDestroy(self)
  self.dynamic = nil
  self.p_trans_sticker = nil
  self.root_vertical = nil
  self._txtName = nil
  self._cp_intro = nil
  self._txtDesc = nil
  self.rate_btn = nil
  self.txt_have_count = nil
  self:ClearSticker()
end

function UIStickerTipsViewView:RefreshShow()
  self:Init()
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.root_vertical.transform)
end

function UIStickerTipsViewView:Init()
  self._txtName:SetActive(true)
  self._cp_intro:SetActive(false)
  self.rate_btn_content:SetActive(false)
  self.tip_btn_content:SetActive(false)
  self.dynamic:SetActive(false)
  self:HideUseBtn()
  assert(self.param.alignObject ~= nil)
  if self.param.alignObject.gameObject == nil or not self.param.alignObject.gameObject.activeInHierarchy then
    Logger.Log("UIStickerTipsViewView init aborted because its alignObject has been destroyed.")
    self.ctrl:CloseSelf()
    return
  end
  local rewardType = self.param.rewardType or RewardType.GOODS
  if rewardType == RewardType.GOODS then
    self:ShowGoods(self.param)
  end
end

function UIStickerTipsViewView:ShowGoods(param)
  local itemId = param.itemId
  if itemId ~= nil then
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
    if goods ~= nil then
      local goodSkin = param.goodSkin
      local name = DataCenter.ItemTemplateManager:GetName(goods.id)
      self._txtName:SetActive(true)
      self._cp_intro:SetActive(goods.rate_show ~= "")
      if goodSkin ~= nil and goodSkin.name ~= nil and goodSkin.description ~= nil then
        self._txtName:SetLocalText(goodSkin.name)
        self._txtDesc:SetLocalText(goodSkin.description)
      else
        self._txtName:SetText(name)
        self._txtDesc:SetText(DataCenter.ItemTemplateManager:GetDes(goods.id))
      end
      self.rate_btn_content:SetActive(goods.drop_info_para > 0)
      local haveCount = 0
      local haveCountDes = ""
      if goods.type == GOODS_TYPE.GOODS_TYPE_149 then
        if goods.linked_item_type ~= ItemLinkType.None then
          haveCount = self:GetGoodsLinkItemCount(goods.linked_item_type, goods.linked_item_id)
        else
          haveCount = DataCenter.ItemData:GetItemCount(itemId)
        end
        haveCountDes = Localization:GetString("drop_info_desc1") .. " " .. string.GetFormattedStr(haveCount)
        self:ShowSticker(goods.id)
      end
      if param.hideHaveCountShow then
        self.txt_have_count:SetActive(false)
      else
        self.txt_have_count:SetText(haveCountDes)
        self.txt_have_count:SetActive(true)
      end
    else
      local resName = GetTableData(TableName.Resource, itemId, "name")
      local resDesc = GetTableData(TableName.Resource, itemId, "description")
      self._txtName:SetActive(true)
      self._txtName:SetLocalText(resName)
      self._txtDesc:SetLocalText(resDesc)
    end
  else
    if param.itemName ~= nil then
      if param.isLocal == true then
        self._txtName:SetActive(param.itemName ~= "")
        self._txtName:SetText(param.itemName)
      else
        self._txtName:SetActive(true)
        self._txtName:SetLocalText(param.itemName)
      end
    else
      self._txtName:SetActive(false)
    end
    if param.itemDesc ~= nil then
      if param.isLocal == true then
        self._txtDesc:SetText(param.itemDesc)
      else
        self._txtDesc:SetLocalText(param.itemDesc)
      end
    else
      self._txtDesc:SetText("")
    end
  end
  self:UpdateUseBtn(param)
end

function UIStickerTipsViewView:OnClickItemProbability()
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
  if goods.rate_show ~= "" then
    local str = string.split(goods.rate_show, "|")
    local list = {}
    for i = 1, #str do
      local item = string.split(str[i], ";")
      local param = {}
      param.names = {}
      param.names[1] = DataCenter.ItemTemplateManager:GetName(item[1]) .. "x" .. item[2]
      param.names[2] = item[3] .. "%"
      table.insert(list, param)
    end
    local titleList = {
      [1] = 100080,
      [2] = 320476
    }
    local title = 320475
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonItemProbability, {anim = true}, list, titleList, title)
  end
end

function UIStickerTipsViewView:OnClickRateBtn()
  local goods
  if self.param.itemId then
    goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
  end
  local dropInfoId
  if goods and goods.drop_info_para > 0 then
    dropInfoId = goods.drop_info_para
  end
  if dropInfoId then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIProbabilityNotice)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIProbabilityNotice, {anim = true}, dropInfoId)
  end
  self.ctrl:CloseSelf()
end

function UIStickerTipsViewView:OnClickTipBtn()
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
  if goods and goods.type == GOODS_TYPE.GOODS_TYPE_137 then
    local workerId = tonumber(goods.para2) or 0
    UIUtil.OpenWorkerPreviewView(workerId)
    self.ctrl:CloseSelf()
  end
end

function UIStickerTipsViewView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIStickerTipsViewView:GetGoodsLinkItemCount(linkItemType, linkItemId)
  local haveCount = 0
  if linkItemType == ItemLinkType.RES_ITEM then
    haveCount = DataCenter.ResourceItemDataManager:GetCountByItemId(tonumber(linkItemId))
  elseif linkItemType == ItemLinkType.EQUIP then
    local equipList = DataCenter.EquipDataManager:GetAllEquipListByEquipId(linkItemId)
    haveCount = table.count(equipList)
  elseif linkItemType == ItemLinkType.SQUAD_EQUIP then
    local equipList = DataCenter.CommonEquipDataManager:GetAllEquipsByCfgId(linkItemId)
    haveCount = table.count(equipList)
  end
  return haveCount
end

function UIStickerTipsViewView:UpdateUseBtn(param)
  if not param.showUse then
    return
  end
  local itemData = DataCenter.ItemData:GetItemById(param.itemId)
  if not (itemData and itemData.count) or itemData.count <= 0 then
    return
  end
  self.useBtn:SetActive(true)
  if not param.isModify then
    param.isModify = true
  end
end

function UIStickerTipsViewView:HideUseBtn()
  self.useBtn:SetActive(false)
end

function UIStickerTipsViewView:OnClickUseBtn()
  local itemData = DataCenter.ItemData:GetItemById(self.param.itemId)
  if not (itemData and itemData.count) or itemData.count <= 0 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ItemUse, {
    uuid = itemData.uuid,
    num = 1
  })
end

function UIStickerTipsViewView:ShowSticker(goodsId)
  local stickerCell = DataCenter.StickerWithDecorationLinkManager:GetStickerCellByGoodsId(goodsId)
  if stickerCell == nil then
    return
  end
  self.dynamic:SetActive(true)
  self.stickerKey = string.format("Sticker_ItemTipsView_%s_%s", goodsId, stickerCell.id)
  DataCenter.ChatEmojiTemplateManager:ShowStickerByCfgId(self.p_trans_sticker.transform, self.stickerKey, stickerCell.id, 0.344)
end

function UIStickerTipsViewView:ClearSticker()
  if self.stickerKey then
    DataCenter.ChatEmojiTemplateManager:KillStickerByKey(self.stickerKey)
  end
end

return UIStickerTipsViewView
