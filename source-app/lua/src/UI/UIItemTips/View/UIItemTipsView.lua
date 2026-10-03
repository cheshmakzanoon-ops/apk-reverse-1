local UIItemTipsView = BaseClass("UIItemTipsView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Pivot_Max = 1.1
local Pivot_Min = -0.1
local Pivot_Mid = 0.5
local AllianceGiftMap = {
  [1] = 106040001,
  [2] = 106040002,
  [3] = 106040003,
  [4] = 106040004,
  [5] = 106040005,
  [6] = 106040006
}
local _cp_txtName = "root/TxtName"
local _cp_item_intro = "root/TxtName/Intro"
local _cp_txtDesc = "root/TxtDesc"
local _cp_btnBg = "Panel"
local _cp_root = "root"
local _cp_imgArrow = "root/imgArrow"
local rate_btn_content_path = "root/rateBtnContent"
local rate_btn_path = "root/rateBtnContent/rateBtn"
local txt_have_count_path = "root/TxtHaveCount"
local tip_btn_content_path = "root/tipBtnContent"
local tip_btn_path = "root/tipBtnContent/tipBtn"
local use_btn_path = "root/TxtName/UseBtn"

function UIItemTipsView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIItemTipsView:OnEnable()
  self:Init()
end

function UIItemTipsView:Init()
  local param = self:GetUserData()
  self._txtName:SetActive(true)
  self._cp_intro:SetActive(false)
  self.rate_btn_content:SetActive(false)
  self.tip_btn_content:SetActive(false)
  self:HideUseBtn()
  assert(param.alignObject ~= nil)
  if param.alignObject.gameObject == nil or not param.alignObject.gameObject.activeInHierarchy then
    Logger.Log("UIItemTipsView init aborted because its alignObject has been destroyed.")
    self.ctrl:CloseSelf()
    return
  end
  self._param = param
  if param.type and param.type == "desc" then
    self:ShowDes(param)
    self._txtName:SetActive(false)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self._root.transform)
    self:CheckAlign()
    return
  elseif param.type and param.type == "nameDesc" then
    self:ShowDes(param)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self._root.transform)
    self:CheckAlign()
    return
  end
  local rewardType = param.rewardType or RewardType.GOODS
  if rewardType == RewardType.GOODS then
    self:ShowGoods(param)
  elseif rewardType == RewardType.RESOURCE_ITEM then
    self:ShowRes(param)
  elseif rewardType == RewardType.HERO then
    self:ShowHero(param)
  elseif rewardType == RewardType.Building then
    self:ShowBuilding(param)
  elseif rewardType == RewardType.GOLD then
    self:ShowGold(param)
  elseif rewardType == RewardType.ALLIANCE_GIFT then
    self:ShowAllianceGift(param)
  elseif rewardType == RewardType.DragonWorldPoint then
    self:ShowDragonPoint(param)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self._root.transform)
  self:CheckAlign()
end

function UIItemTipsView:ShowHero(param)
  local heroId = param.itemId
  local line = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroId)
  local name = tonumber(line:getValue("name"))
  local desc = tonumber(line:getValue("desc"))
  self._txtName:SetActive(true)
  self._txtName:SetLocalText(name)
  self._txtDesc:SetLocalText(desc)
end

function UIItemTipsView:ShowBuilding(param)
  local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.Building), param.itemId)
  local name = tonumber(line:getValue("name"))
  local desc = tonumber(line:getValue("description"))
  self._txtName:SetActive(true)
  self._txtName:SetLocalText(name)
  self._txtDesc:SetLocalText(desc)
end

function UIItemTipsView:ShowRes(param)
  local itemId = param.itemId
  local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(itemId)
  local haveCount = param.hasCount or DataCenter.ResourceItemDataManager:GetCountByItemId(tonumber(itemId))
  if itemId == 11012 then
    self.txt_have_count:SetActive(false)
  else
    self.txt_have_count:SetActive(true)
    self.txt_have_count:SetText(Localization:GetString("drop_info_desc1") .. " " .. string.GetFormattedStr(haveCount))
  end
  local haveCount = DataCenter.ResourceItemDataManager:GetCountByItemId(tonumber(itemId))
  self.txt_have_count:SetActive(true)
  self.txt_have_count:SetText(Localization:GetString("drop_info_desc1") .. " " .. string.GetFormattedStr(haveCount))
  self._txtName:SetActive(true)
  if param.itemName then
    if param.isLocal then
      self._txtName:SetText(param.itemName)
    else
      self._txtName:SetLocalText(param.itemName)
    end
  else
    self._txtName:SetLocalText(template.name)
  end
  if param.fetchMummyDesc and param.theSoldierType == SoldierType.Player then
    self._txtDesc:SetLocalText("season_s3_Mummy_ui_info010")
  else
    self._txtDesc:SetLocalText(template.desc)
  end
end

function UIItemTipsView:ShowGold(param)
  local haveCount = LuaEntry.Player.gold
  self.txt_have_count:SetActive(true)
  self.txt_have_count:SetText(Localization:GetString("drop_info_desc1") .. " " .. string.GetFormattedStr(haveCount))
  self._txtName:SetActive(true)
  self._txtName:SetText(param.itemName)
  self._txtDesc:SetText(param.itemDesc)
end

function UIItemTipsView:ShowDragonPoint(param)
  local haveCount = LuaEntry.Resource:GetHonorScore()
  self.txt_have_count:SetActive(true)
  self.txt_have_count:SetText(Localization:GetString("drop_info_desc1") .. " " .. string.GetFormattedStr(haveCount))
  self._txtName:SetActive(true)
  self._txtName:SetText(DataCenter.ResourceManager:GetResourceNameByType(param.itemId))
  self._txtDesc:SetText(DataCenter.ResourceManager:GetResourceDescByType(param.itemId))
end

function UIItemTipsView:ShowAllianceGift(param)
  self._txtName:SetActive(true)
  self._txtName:SetText(param.itemName)
  self._txtDesc:SetText(param.itemDesc)
  self.rate_btn_content:SetActive(true)
end

function UIItemTipsView:ShowGoods(param)
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
      if goods.type == GOODS_TYPE.GOODS_TYPE_113 then
        haveCount = DataCenter.ItemData:GetItemCount(itemId)
        haveCountDes = Localization:GetString("drop_info_desc1") .. " " .. string.GetFormattedStr(haveCount)
        if goods.linked_item_type == ItemLinkType.DECORATION then
          local decorationData = DataCenter.DecorationDataManager:GetSkinDataById(goods.linked_item_id)
          if decorationData ~= nil then
            if decorationData.expireTime == 0 then
              haveCountDes = Localization:GetString("drop_info_desc4")
            else
              local now = UITimeManager:GetInstance():GetServerTime()
              local surplusTime = decorationData.expireTime - now
              local timeTips = Localization:GetString("drop_info_desc3", UITimeManager:GetInstance():MilliSecondToFmtString(surplusTime))
              haveCountDes = Localization:GetString("drop_info_desc1") .. " " .. string.GetFormattedStr(haveCount) .. "\n" .. timeTips
            end
          end
        end
      elseif goods.type == GOODS_TYPE.GOODS_TYPE_146 then
        haveCount = DataCenter.GoldBrickDataManager:GetGoldBrickCount()
        haveCountDes = Localization:GetString("drop_info_desc1") .. " " .. string.GetFormattedStr2(haveCount)
      else
        if goods.linked_item_type ~= ItemLinkType.None then
          haveCount = self:GetGoodsLinkItemCount(goods.linked_item_type, goods.linked_item_id)
        else
          haveCount = DataCenter.ItemData:GetItemCount(itemId)
        end
        haveCountDes = Localization:GetString("drop_info_desc1") .. " " .. string.GetFormattedStr(haveCount)
      end
      if goods.type == GOODS_TYPE.GOODS_TYPE_134 then
        local useCount = DataCenter.MasteryManager:GetItemUseCount(itemId)
        haveCountDes = haveCountDes .. "\n" .. Localization:GetString("season_mastery_tips_25", " " .. useCount)
      end
      if goods.type == GOODS_TYPE.GOODS_TYPE_144 then
        self.txt_have_count:SetActive(false)
      elseif param.hideHaveCountShow then
        self.txt_have_count:SetActive(false)
      else
        self.txt_have_count:SetText(haveCountDes)
        self.txt_have_count:SetActive(true)
      end
      local isTipContentShow = goods.type == GOODS_TYPE.GOODS_TYPE_137
      self.tip_btn_content:SetActive(isTipContentShow)
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

function UIItemTipsView:ShowDes(param)
  self:CheckModify(param)
  if param.isLocal == true then
    self._txtName:SetActive(true)
    if param.title then
      self._txtName:SetText(param.title)
    end
    self._txtDesc:SetText(param.desc)
  else
    self._txtName:SetActive(param.title ~= nil and param.title ~= "")
    if param.title then
      self._txtName:SetLocalText(param.title)
    end
    self._txtDesc:SetLocalText(param.desc)
  end
end

function UIItemTipsView:CheckModify(param)
  if param.isModify then
    if type(param.isModify) == "table" then
      self._root:SetSizeDelta({
        x = param.isModify.rootWidth or 400,
        y = 1
      })
      self._txtDesc:SetSizeDelta({
        x = param.isModify.txtDescWidth or 350,
        y = 1
      })
    elseif type(param.isModify) == "boolean" then
      self._root:SetSizeDelta({x = 400, y = 1})
      self._txtDesc:SetSizeDelta({x = 350, y = 1})
    end
  else
    self._root:SetSizeDelta({x = 300, y = 1})
    self._txtDesc:SetSizeDelta({x = 255, y = 1})
  end
end

function UIItemTipsView:CheckAlign()
  local _arrowX = 0
  local _arrowY = 0
  local _rotation = 0
  local ScreenSize = CS.UnityEngine.Screen
  local ScreenWidth = ScreenSize.width
  local ScreenHeight = ScreenSize.height
  local scale = ScreenWidth / DefaultScreenWidth
  local hScale = ScreenHeight / DefaultScreenHeight
  local _rect = self._root.rectTransform.rect
  local BgWidth = _rect.width * scale
  local BgHeight = _rect.height * hScale
  local alignObject = self._param.alignObject
  local _screenPos = PosConverse.UIWorldToScreenPos(alignObject.transform.position)
  local objWidth = alignObject.rectTransform.rect.width * scale
  local pivot = Vector2.New(0.5, 0.5)
  if ScreenWidth < _screenPos.x + objWidth * 0.4 + BgWidth then
    pivot.x = Pivot_Max
    _arrowX = BgWidth / scale * 0.5 + 8
  else
    pivot.x = Pivot_Min
    _arrowX = -BgWidth / scale * 0.5 - 8
  end
  if _screenPos.y - BgHeight * 0.5 < 50 then
    pivot.y = Pivot_Min
    _arrowY = -BgHeight / hScale * 0.5 - 2
  elseif _screenPos.y + BgHeight * 0.5 > ScreenHeight - 50 then
    local pY = (_screenPos.y - (ScreenHeight - 50 - BgHeight)) / hScale / _rect.height
    if 1 < pY then
      pivot.y = 1.0
      _arrowY = BgHeight / hScale * 0.5 - self.imgArrowHeight * 0.5
    elseif pY < 0 then
      pivot.y = 0
      _arrowY = -(BgHeight / hScale * 0.5 - self.imgArrowHeight * 0.5)
    else
      pivot.y = pY
      _arrowY = BgHeight / hScale * (pY - 0.5)
      _arrowY = Mathf.Clamp(_arrowY, -(BgHeight / hScale * 0.5 - self.imgArrowHeight * 0.5), BgHeight / hScale * 0.5 - self.imgArrowHeight * 0.5)
    end
  else
    pivot.y = Pivot_Mid
  end
  self._root.rectTransform.pivot = pivot
  self._root.transform.position = alignObject.transform.position
  if pivot.x == Pivot_Max and 0 > pivot.y or pivot.x == Pivot_Max and pivot.y > 1 or pivot.x == Pivot_Min and 0 > pivot.y or pivot.x == Pivot_Min and pivot.y > 1 then
    self._imgArrow:SetActive(false)
    return
  end
  if pivot.x == Pivot_Max then
    _rotation = 180
  elseif pivot.x == Pivot_Min then
    _rotation = 0
  end
  self._imgArrow.transform.localRotation = Quaternion.Euler(0, _rotation + 180, 0)
  self._imgArrow.rectTransform.anchoredPosition = Vector2.New(_arrowX, _arrowY)
  self._imgArrow:SetActive(self._param.showArrow == nil or self._param.showArrow == true)
end

function UIItemTipsView:OnClickItemProbability()
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self._param.itemId)
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

function UIItemTipsView:OnClickRateBtn()
  self.ctrl:CloseSelf()
  local goods
  if self._param.itemId then
    goods = DataCenter.ItemTemplateManager:GetItemTemplate(self._param.itemId)
  end
  local dropInfoId
  if goods and goods.drop_info_para > 0 then
    dropInfoId = goods.drop_info_para
  elseif self._param.rewardType == RewardType.ALLIANCE_GIFT then
    dropInfoId = AllianceGiftMap[self._param.itemColor]
  end
  if dropInfoId then
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIProbabilityNotice)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIProbabilityNotice, {anim = true}, dropInfoId)
  end
end

function UIItemTipsView:OnClickTipBtn()
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self._param.itemId)
  if goods and goods.type == GOODS_TYPE.GOODS_TYPE_137 then
    local workerId = tonumber(goods.para2) or 0
    self.ctrl:CloseSelf()
    UIUtil.OpenWorkerPreviewView(workerId)
  end
end

function UIItemTipsView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIItemTipsView:ComponentDefine()
  self._btn = self:AddComponent(UIButton, _cp_btnBg)
  self._btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self._txtName = self:AddComponent(UIText, _cp_txtName)
  self._cp_intro = self:AddComponent(UIButton, _cp_item_intro)
  self._cp_intro:SetOnClick(function()
    self:OnClickItemProbability()
  end)
  self._txtDesc = self:AddComponent(UIText, _cp_txtDesc)
  self._root = self:AddComponent(UIBaseContainer, _cp_root)
  self._imgArrow = self:AddComponent(UIBaseContainer, _cp_imgArrow)
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
  self.imgArrowHeight = self._imgArrow.rectTransform.rect.height
end

function UIItemTipsView:ComponentDestroy()
  self._btn = nil
  self._txtName = nil
  self._cp_intro = nil
  self._txtDesc = nil
  self.rate_btn = nil
  self.txt_have_count = nil
end

function UIItemTipsView:GetGoodsLinkItemCount(linkItemType, linkItemId)
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

function UIItemTipsView:UpdateUseBtn(param)
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
  self:CheckModify(param)
end

function UIItemTipsView:HideUseBtn()
  self.useBtn:SetActive(false)
end

function UIItemTipsView:OnClickUseBtn()
  local itemData = DataCenter.ItemData:GetItemById(self._param.itemId)
  if not (itemData and itemData.count) or itemData.count <= 0 then
    return
  end
  SFSNetwork.SendMessage(MsgDefines.ItemUse, {
    uuid = itemData.uuid,
    num = 1
  })
end

return UIItemTipsView
