local base = UIBaseView
local UICommonShopView = BaseClass("UICommonShopView", base)
local Localization = CS.GameEntry.Localization
local UnityRectTransform = typeof(CS.UnityEngine.RectTransform)
local UICommonShopTabItem = require("UI.UICommonShop.Component.UICommonShopTabItem")
local title_path = "content/TopBar/TextTitle"
local closeBtn_path = "content/CloseBtn"
local panelContainer_path = "content/ImgBg/Container"
local topRes_path = "content/TopBar/res"
local topResIcon_path = "content/TopBar/res/root/resIcon"
local topResCount_path = "content/TopBar/res/root/resNum"
local topResSpe_path = "content/TopBar/resSpe"
local spe_res_num_path = "content/TopBar/resSpe/root/resNum1"
local spe_res_icon_path = "content/TopBar/resSpe/root/resIcon1"
local spe_res_add_path = "content/TopBar/resSpe/root/add1"
local topResSpeCanAdd_path = "content/TopBar/resSpe"
local toggle_template_path = "content/ImgBg/ToggleTemplate"
local content_path = "content/ImgBg/Scroll/Viewport/Content"
local refresh_time_path = "content/TimeContent"
local refresh_title_path = "content/TimeContent/refresh"
local refresh_time_txt_path = "content/TimeContent/time/remainTime"
local tip_root_path = "content/TopBar/resSpe/TipRoot"
local tip_box_path = "content/TopBar/resSpe/TipRoot/TipBox"
local tip_desc_text_path = "content/TopBar/resSpe/TipRoot/TipBox/DescText"
local tip_root_icon_path = "content/TopBar/resSpe/TipRoot/TipRoot"
local ShopPanelConfig = {
  {
    ShopType = CommonShopType.Goods,
    AssetPath = "Assets/Main/Prefabs/UI/UICommonShop/CommonGoodsShopPanel.prefab",
    ComponentPath = "UI.UICommonShop.Component.CommonShopGoods.CommonGoodsShopPanel",
    Title = "store_name_7"
  },
  {
    ShopType = CommonShopType.Vip,
    AssetPath = "Assets/Main/Prefabs/UI/UICommonShop/CommonVipShopPanel.prefab",
    ComponentPath = "UI.UICommonShop.Component.CommonShopVip.CommonVipShopPanel",
    Title = "store_name_6"
  },
  {
    ShopType = CommonShopType.AllianceShop,
    AssetPath = "Assets/Main/Prefabs/UI/UICommonShop/CommonShopAlliancePanel.prefab",
    Title = "store_name_1",
    ResIconDesc = 391084,
    ResIcon = ResourceTypeIconName[ResourceType.AlliancePoint],
    ComponentPath = "UI.UILWAlliance.UILWAllianceShop.View.UILWAllianceShopView",
    ResCount = DataCenter.CommonShopManager.GetAllianceShopScore,
    CanShow = DataCenter.CommonShopManager.CanShowAllianceShop
  },
  {
    ShopType = CommonShopType.HonorShop,
    AssetPath = "Assets/Main/Prefabs/UI/UICommonShop/CommonShopDragonPanel.prefab",
    Title = "store_name_2",
    ResIconDesc = 458286,
    ResIcon = ResourceTypeIconName[ResourceType.DragonPoint],
    ComponentPath = "UI.UICommonShop.Component.CommonShopDragon.CommonShopDragonPanel",
    ResCount = LuaEntry.Resource.GetHonorScore
  },
  {
    ShopType = CommonShopType.TrailTowerShop,
    AssetPath = "Assets/Main/Prefabs/UI/UICommonShop/CommonShopTrailTowerPanel.prefab",
    Title = "store_name_3",
    ResIconDesc = "trialtower_010",
    ResIcon = "Assets/Main/Sprites/ItemIcons/trialtowerpoint_icon",
    ComponentPath = "UI.LWTrailTower.TrailTowerShop.View.LWUITrailTowerShopView"
  },
  {
    ShopType = CommonShopType.SeasonShop,
    AssetPath = "Assets/Main/Prefabs/UI/UICommonShop/CommonShopSeasonPanel.prefab",
    Title = "store_name_4",
    ResIconDesc = "goods_desc_season_shop",
    ResIcon = "Assets/Main/Sprites/ItemIcons/item640025",
    ComponentPath = "UI.UICommonShop.Component.CommonShopSeason.CommonShopSeasonPanel",
    ResCount = SeasonUtil.GetSeasonShopResCount,
    CanShow = SeasonUtil.CanShowSeasonShop
  },
  {
    ShopType = CommonShopType.DecorationShop,
    AssetPath = "Assets/Main/Prefabs/UI/UICommonShop/CommonDecorationShopPanel.prefab",
    Title = DataCenter.CommonShopManager:GetDecorationShopName(CommonShopType.DecorationShop),
    ResIcon = "Assets/Main/Sprites/ItemIcons/lrb_pifudaoju_icon.png",
    ComponentPath = "UI.UICommonShop.Component.CommonShopDecoration.CommonDecorationShopPanel",
    ResCount = DataCenter.CommonShopManager.GetDecorationShopItemNum,
    CanShow = DataCenter.CommonShopManager.CanShowDecorationShop,
    CanAddSpecialItem = true
  },
  {
    ShopType = CommonShopType.GiftVoucher,
    AssetPath = "Assets/Main/Prefabs/UI/UICommonShop/CommonGiftVoucherShopPanel.prefab",
    Title = "gift_coupon_shop_name",
    ResIcon = "Assets/Main/Sprites/ItemIcons/lrb_daojv_liwuduihuan.png",
    ComponentPath = "UI.UICommonShop.Component.CommonShopGiftVoucher.CommonGiftVoucherShopPanel",
    ResCount = DataCenter.CommonShopManager.GetGiftVoucherShopItemNum,
    CanAddSpecialItem = false,
    ResIconDesc = "gift_coupon_desc"
  }
}

function UICommonShopView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitUI()
  self:SendGetShopGoodsNumMsg()
  self:PostEventLog()
end

function UICommonShopView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UICommonShopView:ComponentDefine()
  self.titleN = self:AddComponent(UIText, title_path)
  self.titleN:SetLocalText(129006)
  self.topResSpe = self:AddComponent(UIButton, topResSpe_path)
  self.spe_res_num = self:AddComponent(UIText, spe_res_num_path)
  self.spe_res_icon = self:AddComponent(UIImage, spe_res_icon_path)
  self.spe_res_add = self:AddComponent(UIImage, spe_res_add_path)
  self.topResSpe:SetOnClick(function()
    self:OnClickResSpecial()
  end)
  self.topResN = self:AddComponent(UIButton, topRes_path)
  self.topResIconN = self:AddComponent(UIImage, topResIcon_path)
  self.tipRootIcon = self:AddComponent(UIImage, tip_root_icon_path)
  self.topResCountN = self:AddComponent(UIText, topResCount_path)
  self.topResIconN:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold))
  self.topResN:SetOnClick(function()
    GoToUtil.GotoPay()
  end)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self:OnClickCloseBtn()
  end)
  self.refresh_time_root = self:AddComponent(UIImage, refresh_time_path)
  self.refresh_time_title = self:AddComponent(UIText, refresh_title_path)
  self.refresh_time_txt = self:AddComponent(UIText, refresh_time_txt_path)
  self.tip_root = self:AddComponent(UICanvasGroup, tip_root_path)
  self.tip_box = self:AddComponent(UIButton, tip_box_path)
  self.tip_desc_text = self:AddComponent(UIText, tip_desc_text_path)
  self.tip_root:SetAlpha(0)
  self.tip_root:SetLocalScaleXYZ(1, 0, 1)
  self.tip_box:SetOnClick(function()
    self:CloseResTips()
  end)
  self.panelContainerN = self:AddComponent(UIBaseContainer, panelContainer_path)
  self.toggle_template = self:AddComponent(UIImage, toggle_template_path)
  self.content = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, content_path)
  self.theTabItem = self.toggle_template.gameObject
  self.theTabItem:GameObjectCreatePool()
  self.refresh_time_root:SetActive(false)
  self.topResSpe:SetActive(false)
  self.topResN:SetActive(true)
end

function UICommonShopView:ComponentDestroy()
  self:CloseResTips()
  self.content:RemoveComponents(UICommonShopTabItem)
  self.theTabItem:GameObjectRecycleAll()
  if self.reqList ~= nil then
    for k, v in pairs(self.reqList) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.titleN = nil
  self.closeBtnN = nil
  self.togglesTb = nil
  self.panelContainerN = nil
  self.tipRootIcon = nil
end

function UICommonShopView:DataDefine()
  self.panelList = {}
  self.reqList = {}
  self.shopInitList = {}
  self.shopTabTypeList = {}
end

function UICommonShopView:DataDestroy()
  self.panelList = nil
  self.reqList = nil
  self.shopInitList = nil
  self.shopTabTypeList = nil
  self.curShopType = nil
end

function UICommonShopView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnCommonShopRedChange, self.RefreshToggleRed)
  self:AddUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
  self:AddUIListener(EventId.GetShopNumsInfoMsg, self.GetShopNumsInfoMsgFunc)
  self:AddUIListener(EventId.OnPassDay, self.OnPassDay)
end

function UICommonShopView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnCommonShopRedChange, self.RefreshToggleRed)
  self:RemoveUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
  self:RemoveUIListener(EventId.GetShopNumsInfoMsg, self.GetShopNumsInfoMsgFunc)
  self:RemoveUIListener(EventId.OnPassDay, self.OnPassDay)
  base.OnRemoveListener(self)
end

function UICommonShopView:OnEnable()
  base.OnEnable(self)
  self:UpdateGoldSignal()
  self:RefreshOnShowPanel()
end

function UICommonShopView:OnDisable()
  base.OnDisable(self)
end

function UICommonShopView:InitTabBar()
  local goItem
  local dataConfig = {}
  local togglesTb = {}
  local tabCount = 0
  self.shopTabTypeList = {}
  for index, v in ipairs(ShopPanelConfig) do
    local canShowItNow = true
    if v.CanShow ~= nil and type(v.CanShow) == "function" then
      local ok, res = pcall(v.CanShow)
      if ok then
        canShowItNow = res
      end
    end
    local shopGoodsNum = DataCenter.CommonShopManager:GetShopGoodsNum(v.ShopType)
    if 0 < shopGoodsNum and canShowItNow == true then
      local shopType = v.ShopType
      local theName = "tab_" .. index .. "_" .. v.ShopType
      goItem = self.theTabItem:GameObjectSpawn(self.content.transform)
      goItem.name = theName
      goItem:SetActive(true)
      local tabNode = self.content:AddComponent(UICommonShopTabItem, theName)
      tabNode:ReInit(v)
      tabNode:SetOnValueChanged(function(tf)
        if tf then
          if not tabNode.selecting then
            DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_UI_General_Click_2nd, false)
          end
          self:ChangeShowType(shopType)
        end
        tabNode:ChangeTextTitleColor(tf)
        tabNode.selecting = false
      end)
      togglesTb[shopType] = tabNode
      dataConfig[shopType] = v
      tabCount = tabCount + 1
      table.insert(self.shopTabTypeList, shopType)
    end
  end
  self.togglesTb = togglesTb
  self.dataConfig = dataConfig
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.transform)
  self.content:SetAnchoredPositionXY(0, 0)
end

function UICommonShopView:InitUI()
  self.initFinish = false
  self.defaultShopType, self.focusShopId = self:GetUserData()
  if self.defaultShopType == nil then
    self.defaultShopType = CommonShopType.Goods
  end
  self.jumpShopType = self.defaultShopType
  self:InitTabBar()
  local tabNode = self.togglesTb[self.defaultShopType]
  if tabNode == nil then
    self.defaultShopType = CommonShopType.Goods
    tabNode = self.togglesTb[CommonShopType.Goods]
  end
  self.initFinish = true
  if tabNode then
    tabNode:SetIsOn(true)
    local tabSizeDelta = tabNode:GetSizeDelta()
    local posX = -tabNode:GetAnchoredPositionX() + tabSizeDelta.x / 2 + self.content:GetPadding().left
    self.content:SetAnchoredPositionXY(posX, self.content:GetAnchoredPositionY())
  end
  if self.reqList[self.defaultShopType] == nil then
    self:ChangeShowType(self.defaultShopType)
  end
  if CommonUtil.IsArabicAutoMirrorOpen() then
    self.tip_box.gameObject:GetComponent(UnityRectTransform):Set_anchoredPosition(Vector3(76, -32, 0))
  end
end

function UICommonShopView:SendGetShopGoodsNumMsg()
  local shopTypesStr = ""
  local shopTypesData = {}
  for index, v in ipairs(ShopPanelConfig) do
    shopTypesData[index] = v.ShopType
  end
  shopTypesStr = table.concat(shopTypesData, ",")
  SFSNetwork.SendMessage(MsgDefines.UserGetShopNumsInfo, shopTypesStr)
end

function UICommonShopView:ChangeShowType(theShopType)
  if self.initFinish ~= true then
    return
  end
  if self.curShopType == theShopType then
    if self.panelList[theShopType] ~= nil then
      self:RefreshOnShowPanel()
    end
    return
  end
  local theConfig = self.dataConfig[theShopType]
  if theConfig == nil then
    return
  end
  if theConfig.ResIcon ~= nil then
    self.topResSpe:SetActive(true)
    self.topResN:SetActive(false)
    self.spe_res_icon:LoadSprite(theConfig.ResIcon)
    self.spe_res_add:SetActive(theConfig.CanAddSpecialItem)
    self.spe_res_num:SetText("")
    if theConfig.ResCount ~= nil and type(theConfig.ResCount) == "function" then
      local ok, res = pcall(theConfig.ResCount)
      if ok then
        self.spe_res_num:SetText(string.GetFormattedGoldNum(res or 0))
      end
    end
  else
    self.topResSpe:SetActive(false)
    self.topResN:SetActive(true)
  end
  if self.reqList[theShopType] == nil then
    local theAssetPath = theConfig.AssetPath
    local theComponentPath = theConfig.ComponentPath
    self.reqList[theShopType] = self:GameObjectInstantiateAsync(theAssetPath, function(request)
      if request.isError then
        return
      end
      if self.curShopType and self.panelList[self.curShopType] then
        self.panelList[self.curShopType]:SetActive(false)
      end
      self.curShopType = theShopType
      local go = request.gameObject
      go.transform:SetParent(self.panelContainerN.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local v3 = go.transform.position
      v3.x = 0
      v3.y = 0
      go.transform.position = v3
      local cell = self.panelContainerN:AddComponent(require(theComponentPath), go)
      cell:SetActive(true)
      self.panelList[theShopType] = cell
      if cell.SetNodeList ~= nil and type(cell.SetNodeList) == "function" then
        cell:SetNodeList(self.refresh_time_root, self.refresh_time_title, self.refresh_time_txt, self.spe_res_num)
      end
      for i, v in pairs(self.panelList) do
        if v ~= nil then
          v:SetActive(i == self.curShopType)
        end
      end
      self:RefreshOnShowPanel()
    end)
  else
    if self.curShopType and self.panelList[self.curShopType] then
      self.panelList[self.curShopType]:SetActive(false)
    end
    self.curShopType = theShopType
    if self.panelList[theShopType] then
      self.panelList[theShopType]:SetActive(true)
      self:RefreshOnShowPanel()
    end
  end
  if theShopType == CommonShopType.Vip then
    EventManager:GetInstance():Broadcast(EventId.OnEnterVipShopPanel)
  end
end

function UICommonShopView:RefreshToggleRed()
  if self.togglesTb then
    for _, v in pairs(self.togglesTb) do
      v:RefreshToggleRed()
    end
  end
end

function UICommonShopView:UpdateGoldSignal()
  self.topResCountN:SetText(string.GetFormattedGoldNum(LuaEntry.Player.gold or 0))
end

function UICommonShopView:RefreshOnShowPanel()
  local shopType = self.curShopType
  local theConfig = self.dataConfig[shopType]
  if theConfig ~= nil then
    if self.shopInitList[shopType] == nil then
      SFSNetwork.SendMessage(MsgDefines.GetCommonShopInfo, shopType)
      self.shopInitList[shopType] = true
    end
    if shopType == CommonShopType.DecorationShop then
      DataCenter.CommonShopManager:RequestDecorationShopInfo()
    end
    self.refresh_time_root:SetActive(false)
    self.panelList[shopType]:ShowPanel(shopType, self.focusShopId)
    self.focusShopId = nil
    self:CloseResTips()
    if theConfig.ResIconDesc ~= nil then
      self.tip_desc_text:SetLocalText(theConfig.ResIconDesc)
    end
  end
  self:RefreshToggleRed()
end

function UICommonShopView:CloseResTips()
  if self.sequenceResTip ~= nil then
    self.sequenceResTip:Pause()
    self.sequenceResTip:Kill()
    self.sequenceResTip = nil
  end
  self.tip_root:SetAlpha(0)
  self.tip_root:SetLocalScaleXYZ(1, 0, 1)
end

function UICommonShopView:OnClickResSpecial()
  if self.curShopType == CommonShopType.DecorationShop then
    DataCenter.CommonShopManager:OpenDirectPurchaseView(self.curShopType)
  end
  self:ShowResTips()
end

function UICommonShopView:ShowResTips()
  local shopType = self.curShopType
  local theConfig = self.dataConfig[shopType]
  self:CloseResTips()
  if theConfig ~= nil and theConfig.ResIconDesc ~= nil then
    local sequence = CS.DG.Tweening.DOTween.Sequence()
    sequence:Join(self.tip_root:FadeIn(0.2))
    sequence:Join(self.tip_root.transform:DOScale(Vector3.New(1, 1, 1), 0.2))
    sequence:AppendInterval(3.6)
    sequence:Append(self.tip_root:FadeOut(0.2))
    sequence:Append(self.tip_root.transform:DOScale(Vector3.New(1, 0, 1), 0.2))
    sequence:OnComplete(function()
      self.tip_root:SetAlpha(0)
      self.tip_root:SetLocalScaleXYZ(1, 0, 1)
      self.sequenceResTip = nil
    end)
    self.sequenceResTip = sequence
  end
end

function UICommonShopView:OnClickCloseBtn()
  self.ctrl:CloseSelf()
end

function UICommonShopView:GetShopNumsInfoMsgFunc()
  local newShopTabTypeList = {}
  for index, v in ipairs(ShopPanelConfig) do
    local canShowItNow = true
    if v.CanShow ~= nil and type(v.CanShow) == "function" then
      local ok, res = pcall(v.CanShow)
      if ok then
        canShowItNow = res
      end
    end
    local shopGoodsNum = DataCenter.CommonShopManager:GetShopGoodsNum(v.ShopType)
    if 0 < shopGoodsNum and canShowItNow == true then
      local shopType = v.ShopType
      table.insert(newShopTabTypeList, shopType)
    end
  end
  local isAllSame = true
  if #newShopTabTypeList == #self.shopTabTypeList then
    for i = 1, #newShopTabTypeList do
      if newShopTabTypeList[i] ~= self.shopTabTypeList[i] then
        isAllSame = false
        break
      end
    end
  else
    isAllSame = false
  end
  if isAllSame == true then
    return
  end
  self.content:RemoveComponents(UICommonShopTabItem)
  self.theTabItem:GameObjectRecycleAll()
  for _, v in ipairs(self.content.transform) do
    if v ~= nil then
      CS.UnityEngine.GameObject.Destroy(v.gameObject)
    end
  end
  self:InitTabBar()
  self.defaultShopType = self.jumpShopType
  local tabNode = self.togglesTb[self.defaultShopType]
  if tabNode == nil then
    self.defaultShopType = CommonShopType.Goods
    tabNode = self.togglesTb[CommonShopType.Goods]
  end
  if tabNode then
    tabNode:SetIsOn(true)
    local tabSizeDelta = tabNode:GetSizeDelta()
    local posX = -tabNode:GetAnchoredPositionX() + tabSizeDelta.x / 2 + self.content:GetPadding().left
    self.content:SetAnchoredPositionXY(posX, self.content:GetAnchoredPositionY())
  end
  if self.reqList[self.defaultShopType] == nil then
    self:ChangeShowType(self.defaultShopType)
  end
end

function UICommonShopView:PostEventLog()
  local id = self.defaultShopType ~= nil and self.defaultShopType or 0
  local playerLevel = LuaEntry.Player.level or 0
  PostEventLog.Track(PostEventLog.Defines.CommonShopOpenView, {shopId = id, playerLevel = playerLevel})
end

function UICommonShopView:OnPassDay()
  self.shopInitList = {}
  local shopType = self.curShopType == nil and self.defaultShopType or self.curShopType
  self:ChangeShowType(shopType)
end

return UICommonShopView
