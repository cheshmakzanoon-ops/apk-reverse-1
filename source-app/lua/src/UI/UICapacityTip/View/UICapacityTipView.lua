local UICapacityTipView = BaseClass("UICapacityTipView", UIBaseView)
local base = UIBaseView
local title_tips_txt_path = "tips/title_tips"
local input_path = "tips/InputField"
local add_money_txt_path = "tips/addMoneyTxt"
local add_money_img_path = "tips/addMoneyTxt/money"
local return_btn_path = "panel"
local btn_path = "tips/Button"
local btn_txt_path = "tips/Button/btnTxt"
local tips_obj_path = "tips"
local des_txt_path = "tips/desTxt"
local icon_path = "tips/Icon"
local dec_btn_path = "tips/InputField/DecBtn"
local add_btn_path = "tips/InputField/AddBtn"
local arrow_img_left_path = "tips/arrow_img_left"
local arrow_img_right_path = "tips/arrow_img_right"
local drop_btn_path = "tips/Rect_BtnList/Drop_Button"
local drop_btn_txt_path = "tips/Rect_BtnList/Drop_Button/Drop_btnTxt"
local use_btn_path = "tips/Rect_BtnList/Btn_Use"
local use_txt_path = "tips/Rect_BtnList/Btn_Use/Txt_Use"
local Screen = CS.UnityEngine.Screen

local function OnCreate(self)
  base.OnCreate(self)
  local arrowMinY, arrowMaxY, isLineEnd, tabType, posX, posY, cellW, resourceTypeOrItemId, uuid = self:GetUserData()
  self.arrowMinY = arrowMinY
  self.arrowMaxY = arrowMaxY
  self.isLineEnd = isLineEnd
  self.tabType = tabType
  self.posX = posX
  self.posY = posY
  self.cellW = cellW
  self.resourceTypeOrItemId = resourceTypeOrItemId
  self.uuid = tonumber(uuid)
  self:ComponentDefine()
end

local function ComponentDefine(self)
  self:ComponentCommonDefine()
  if self.uuid ~= nil then
    self:ComponentSellDefine()
  else
    self:ComponentNotSellDefine()
  end
end

local function ComponentCommonDefine(self)
  self.tips_obj = self:AddComponent(UIBaseContainer, tips_obj_path)
  self.input = self:AddComponent(UIInput, input_path)
  self.input:SetText("")
  self.input:SetOnEndEdit(function(value)
    self:IptOnValueChange(value)
  end)
  self.add_money_txt = self:AddComponent(UIText, add_money_txt_path)
  self.add_money_img = self:AddComponent(UIImage, add_money_img_path)
  self.title_tips_txt = self:AddComponent(UIText, title_tips_txt_path)
  self.arrow_img_left = self:AddComponent(UIImage, arrow_img_left_path)
  self.arrow_img_right = self:AddComponent(UIImage, arrow_img_right_path)
  self.des_txt = self:AddComponent(UIText, des_txt_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.btn = self:AddComponent(UIButton, btn_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnSoldClick()
  end)
  self.btn_txt = self:AddComponent(UIText, btn_txt_path)
  self.btn_txt:SetLocalText(110081)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.dec_btn = self:AddComponent(UIButton, dec_btn_path)
  self.dec_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_ChangeNum, false)
    self:OnDecClick()
  end)
  self.add_btn = self:AddComponent(UIButton, add_btn_path)
  self.add_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Common_ChangeNum, false)
    self:OnAddClick()
  end)
  self.drop_btn = self:AddComponent(UIButton, drop_btn_path)
  self.drop_btn_text = self:AddComponent(UIText, drop_btn_txt_path)
  self.drop_btn_text:SetLocalText(110166)
  self.drop_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnSoldClick()
  end)
  self.use_btn = self:AddComponent(UIButton, use_btn_path)
  self.use_txt = self:AddComponent(UIText, use_txt_path)
  self.use_btn:SetOnClick(function()
    self:OnUseClick()
  end)
end

local function ComponentSellDefine(self)
  self.dec_btn:SetActive(true)
  self.add_btn:SetActive(true)
  self.add_money_img:SetActive(true)
  self.add_money_txt:SetActive(true)
  self.input:SetActive(false)
  self.input:SetEnable(false)
  self.drop_btn_text:SetLocalText(110166)
end

local function ComponentNotSellDefine(self)
  self.dec_btn:SetActive(false)
  self.add_btn:SetActive(false)
  self.add_money_img:SetActive(false)
  self.add_money_txt:SetActive(false)
  self.input:SetEnable(false)
  if self.tabType == UICapacityTableTab.Resource then
    self.drop_btn_text:SetLocalText(100547)
    local curNum = LuaEntry.Resource:GetCntByResType(self.resourceTypeOrItemId)
    self.input:SetText(string.GetFormattedSeperatorNum(curNum))
    if curNum == 0 then
      self.input:SetActive(false)
    else
      self.input:SetActive(true)
    end
  end
end

local function OnDestroy(self)
  self.uuid = nil
  self.posX = nil
  self.posY = nil
  self.tips_obj = nil
  self.input = nil
  self.slider = nil
  self.add_money_txt = nil
  self.sold_txt = nil
  self.title_tips_txt = nil
  self.btn_txt = nil
  self.return_btn = nil
  self.add_money_img = nil
  self.arrow_img_left = nil
  self.arrow_img_right = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshData()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshData(self)
  local v3 = self.tips_obj.transform.position
  v3.x = self.posX
  v3.y = self.posY
  self.tips_obj.transform.position = v3
  local rectPos = self.tips_obj.rectTransform.anchoredPosition
  local rect = self.tips_obj.rectTransform.rect
  local scale = Screen.height / 750
  local screenWidth = Screen.width / scale
  local halfScreenHeight = 375.0
  halfScreenHeight = halfScreenHeight - 30
  local width = rect.width
  local halfHeight = rect.height / 2
  local x = rectPos.x + self.cellW / 2
  local y = rectPos.y
  if self.isLineEnd then
    x = rectPos.x - self.cellW / 2 - width - self.arrow_img_right.transform.rect.width
  end
  if halfScreenHeight < y + halfHeight then
    y = halfScreenHeight - halfHeight
  end
  if y - halfHeight < -halfScreenHeight then
    y = halfHeight - halfScreenHeight
  end
  local tempAnchoredPosition = Vector2.New(x, y)
  self.tips_obj.rectTransform.anchoredPosition = tempAnchoredPosition
  self.arrow_img_left:SetActive(false)
  self.arrow_img_right:SetActive(false)
  local arrowY = self.posY
  arrowY = math.max(arrowY, self.arrowMinY + self.arrow_img_right.transform.rect.height / 2)
  arrowY = math.min(arrowY, self.arrowMaxY - self.arrow_img_right.transform.rect.height / 2)
  if self.isLineEnd then
    self.arrow_img_right:SetActive(true)
    local tempV = self.arrow_img_right.transform.position
    tempV.y = arrowY
    self.arrow_img_right.transform.position = tempV
  else
    self.arrow_img_left:SetActive(true)
    local tempV = self.arrow_img_left.transform.position
    tempV.y = arrowY
    self.arrow_img_left.transform.position = tempV
  end
  local iconAndDesc = self.ctrl:GetIconAndDesc(self.tabType, self.resourceTypeOrItemId)
  self.title_tips_txt:SetText(iconAndDesc.itemName)
  self.des_txt:SetText(iconAndDesc.desc)
  if self.tabType == UICapacityTableTab.Resource then
    self.icon:LoadSprite(iconAndDesc.pic)
  else
    self.icon:LoadSprite(string.format(LoadPath.ItemPath, iconAndDesc.pic))
  end
  if self.uuid ~= nil then
    self.data = self.ctrl:GetResourceItemData(self.uuid)
    self.maxNum = self.data.maxNum
    self.price = self.data.price
    self.curNum = 1
    self.add_money_txt:SetText(self.data.price)
  end
  self:SetDropOrSellShow()
end

local function IptOnValueChange(self, value)
  local cnt = tonumber(value)
  cnt = self.view.ctrl:CheckMax(cnt, self.maxNum)
  cnt = math.floor(cnt + 0.5)
  self.input:SetText(cnt)
  self.curNum = cnt
end

local function OnSoldClick(self)
  if self.tabType == UICapacityTableTab.Resource then
    self:DoResourceClick()
  elseif self.uuid ~= nil then
    self:DoSellItem()
  else
    self:DoGetItem()
  end
end

local function DoSellItem(self)
  if self.ctrl:IsSell() == true then
    local pos = self.btn.gameObject.transform.position
    local rewardType = RewardType.FOOD
    local pic = DataCenter.RewardManager:GetPicByType(rewardType)
    local flyPos = Vector3:New(0, 0, 0)
    UIUtil.DoFly(tonumber(rewardType), 5, pic, pos, flyPos)
  end
  if self.data.activity_discard ~= "" then
    local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(self.data.activity_discard)
    if actListData then
      local isOpen = DataCenter.ActivityListDataManager:CheckIsSend(actListData)
      if isOpen then
        UIUtil.ShowTipsId(400093)
        return
      end
    end
  end
  self.ctrl:OnSoldClick(self.uuid, self.curNum, self.resourceTypeOrItemId)
end

local function DoGetItem(self)
  self.ctrl:DoGetItem(self.resourceTypeOrItemId)
end

local function DoResourceClick(self)
  self.ctrl:DoResourceClick(self.resourceTypeOrItemId)
end

local function OnAddClick(self)
  local changeNum = self.view.ctrl:CheckMax(self.curNum + 1, self.maxNum)
  self:IptOnValueChange(changeNum)
end

local function OnDecClick(self)
  local changeNum = self.view.ctrl:CheckMax(self.curNum - 1, self.maxNum)
  self:IptOnValueChange(changeNum)
end

local function SetDropOrSellShow(self)
  self.btn:SetActive(self.ctrl:IsSell() == true)
  self.btn_txt:SetActive(self.ctrl:IsSell() == true)
  self.add_money_txt:SetActive(self.ctrl:IsSell() == true)
  if self.data then
    self.use_btn:SetActive(self.data.use_type and self.data.use_type ~= "")
    self.use_txt:SetLocalText(110046)
    local str = ""
    if self.data.discard then
      str = string.split(self.data.discard, ";")
    end
    if str[1] == "1" then
      if str[2] then
        if tonumber(str[2]) < DataCenter.BuildManager.MainLv then
          self.drop_btn:SetActive(self.ctrl:IsSell() ~= true)
          self.drop_btn_text:SetActive(self.ctrl:IsSell() ~= true)
        else
          self.drop_btn:SetActive(false)
          self.drop_btn_text:SetActive(false)
        end
      else
        self.drop_btn:SetActive(false)
        self.drop_btn_text:SetActive(false)
      end
      return
    elseif str[1] == "" then
      local condition = string.split(self.data.condition_discard, ";")
      if condition[1] == "" then
        self.drop_btn:SetActive(true)
        self.drop_btn_text:SetActive(true)
      elseif condition[1] == "1" then
        self.drop_btn:SetActive(false)
        self.drop_btn_text:SetActive(false)
      elseif condition[1] == "2" then
        local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(tonumber(condition[2]))
        if list ~= nil and table.count(list) > 0 then
          self.drop_btn:SetActive(true)
          self.drop_btn_text:SetActive(true)
        else
          self.drop_btn:SetActive(false)
          self.drop_btn_text:SetActive(false)
        end
      elseif condition[1] == "3" then
        self.drop_btn:SetActive(true)
        self.drop_btn_text:SetActive(true)
      elseif condition[1] == "4" then
        self.drop_btn:SetActive(true)
        self.drop_btn_text:SetActive(true)
        local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(condition[2])
        if actListData then
          local isOpen = DataCenter.ActivityListDataManager:CheckIsSend(actListData)
          if isOpen then
            self.drop_btn:SetActive(false)
            self.drop_btn_text:SetActive(false)
          end
        end
      end
      return
    end
  end
  self.drop_btn:SetActive(self.ctrl:IsSell() ~= true)
  self.drop_btn_text:SetActive(self.ctrl:IsSell() ~= true)
end

local function OnDropClick(self)
end

local function OnUseClick(self)
  if self.data.use_type == "1" then
    self:CheckResidentOrder(1)
  elseif self.data.use_type == "2" then
    if self.data.itemId == 10002 then
      self:CheckDaBen()
    else
      self:CheckOtherBuild()
    end
  elseif self.data.use_type == "3" then
    self:CheckEnergy(3)
  end
end

local function CheckResidentOrder(self, type)
  local list = DataCenter.ResidentOrderDataManager:GetOrderList()
  for i, v in pairs(list) do
    if v.id > 0 then
      local info = DataCenter.ResidentOrderDataManager:GetResidentOrderByUuid(v.uuid)
      if info then
        local template = DataCenter.OrderTemplateManager:GetOrderTemplate(info.orderId)
        local items = template:GetNeedResourceItem()
        if items ~= nil then
          for j = 1, table.count(items) do
            if items[j].needId == self.data.itemId then
              self:JumpToBusiness(v.id)
              return
            end
          end
        end
      end
    end
  end
  DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ClickResItemUse, tostring(type))
end

local function JumpToBusiness(self, isArrow)
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_BUSINESS_CENTER)
  if buildList ~= nil and table.count(buildList) > 0 and buildList[1] ~= nil then
    local posEnd = buildList[1].pointId
    if CS.SceneManager.IsInPVE() then
      self.ctrl:CloseSelf()
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UICapacityTable) then
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UICapacityTable)
      end
      DataCenter.BattleLevel:Exit(function()
        GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(posEnd, ForceChangeScene.City), nil, nil, function()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIBusinessCenter, {
            anim = true,
            UIMainAnim = UIMainAnimType.AllHide
          }, isArrow)
        end)
      end)
    else
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(posEnd, ForceChangeScene.City), nil, nil, function()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBusinessCenter, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        }, isArrow)
      end)
    end
  elseif CS.SceneManager.IsInPVE() then
    self.ctrl:CloseSelf()
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UICapacityTable) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UICapacityTable)
    end
    DataCenter.BattleLevel:Exit(function()
      GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_BUSINESS_CENTER)
    end)
  else
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_BUSINESS_CENTER)
  end
end

local function CheckDaBen(self)
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_MAIN)
  if buildList ~= nil and table.count(buildList) > 0 and buildList[1] ~= nil then
    local isOpen = true
    if buildList[1]:IsUpgradeFinish() or buildList[1]:IsUpgrading() then
      isOpen = false
    end
    local ret = DataCenter.BuildManager:CheckBuildUpgradeResAndItem(buildList[1].uuid)
    for _, v in ipairs(ret.needResItem) do
      if v.itemId == self.data.itemId then
        if CS.SceneManager.IsInPVE() then
          self.ctrl:CloseSelf()
          if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UICapacityTable) then
            UIManager:GetInstance():DestroyWindow(UIWindowNames.UICapacityTable)
          end
          DataCenter.BattleLevel:Exit(function()
            GoToUtil.GotoCityPos(SceneUtils.TileToWorld(DataCenter.BuildManager.main_city_pos, ForceChangeScene.City), nil, nil, function()
              if isOpen then
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, {
                  anim = true,
                  UIMainAnim = UIMainAnimType.AllHide
                }, buildList[1].uuid, v.itemId)
              end
            end)
          end)
        else
          GoToUtil.CloseAllWindows()
          GoToUtil.GotoCityPos(SceneUtils.TileToWorld(DataCenter.BuildManager.main_city_pos, ForceChangeScene.City), nil, nil, function()
            if isOpen then
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, {
                anim = true,
                UIMainAnim = UIMainAnimType.AllHide
              }, buildList[1].uuid, v.itemId)
            end
          end)
        end
        return
      end
    end
  end
end

local function CheckOtherBuild(self)
  local buildIdList = DataCenter.BuildManager:GetAllBuildUuid()
  local list = table.againObtain(buildIdList)
  local uuid, itemId
  for i, v in pairs(list) do
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(v)
    local ret = DataCenter.BuildManager:CheckBuildUpgradeResAndItem(v)
    local needResItem = ret.needResItem
    if needResItem then
      for j = 1, table.count(needResItem) do
        if needResItem[j].itemId == self.data.itemId then
          local has = DataCenter.ResourceItemDataManager:GetCountByItemId(needResItem[j].itemId)
          local stockInfo = DataCenter.BuildUpgradeStockManager:GetUpgradeStockById(v)
          local hasSubmitCount = 0
          if stockInfo == nil then
            hasSubmitCount = 0
          else
            hasSubmitCount = stockInfo:GetSubmitCountByResourceItem(needResItem[j].itemId)
          end
          local count = needResItem[j].count - hasSubmitCount
          if not buildData:IsUpgradeFinish() and not buildData:IsUpgrading() and not buildData:IsInFix() then
            if has >= count and count ~= 0 then
              self:JumpToBuild(v, needResItem[j].itemId)
              return
            else
              uuid = v
              itemId = needResItem[j].itemId
            end
          end
        end
      end
    end
  end
  if uuid and itemId then
    self:JumpToBuild(uuid, itemId)
  else
    DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.ClickResItemUse, "2")
  end
end

local function JumpToBuild(self, uuid, itemId)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(uuid)
  if CS.SceneManager.IsInPVE() then
    self.ctrl:CloseSelf()
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UICapacityTable) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UICapacityTable)
    end
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UICapacityTable) then
      UIManager:GetInstance():DestroyWindow(UIWindowNames.UICapacityTable)
    end
    DataCenter.BattleLevel:Exit(function()
      GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(buildData.pointId, ForceChangeScene.City), nil, nil, function()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        }, buildData.uuid, itemId)
      end)
    end)
  else
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(buildData.pointId, ForceChangeScene.City), nil, nil, function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildUpgrade, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, buildData.uuid, itemId)
    end)
  end
end

local function CheckEnergy(self, type)
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.APS_BUILD_FARM)
  if buildList ~= nil and table.count(buildList) > 0 and buildList[1] ~= nil then
    local show = DataCenter.EnergyOrderManager:GetShowBubbleByBuildUuid(buildList[1].uuid)
    if 0 < show then
      local index = DataCenter.EnergyOrderManager:GetIndexByBuildUuid(buildList[1].uuid)
      local data = DataCenter.EnergyOrderManager:GetOrderData(index)
      local needList = DataCenter.EnergyOrderManager:GetOrderNeedList(data.orderId)
      for i = 1, table.count(needList) do
        if needList[i].itemId == self.data.itemId then
          if CS.SceneManager.IsInPVE() then
            self.ctrl:CloseSelf()
            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UICapacityTable) then
              UIManager:GetInstance():DestroyWindow(UIWindowNames.UICapacityTable)
            end
            DataCenter.BattleLevel:Exit(function()
              GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(buildList[1].pointId, ForceChangeScene.City), nil, nil, function()
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIEnergyOrder, {
                  anim = true,
                  UIMainAnim = UIMainAnimType.AllHide
                }, buildList[1].uuid)
              end)
            end)
          else
            GoToUtil.CloseAllWindows()
            GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(buildList[1].pointId, ForceChangeScene.City), nil, nil, function()
              UIManager:GetInstance():OpenWindow(UIWindowNames.UIEnergyOrder, {
                anim = true,
                UIMainAnim = UIMainAnimType.AllHide
              }, buildList[1].uuid)
            end)
          end
          return
        end
      end
    end
  end
  self:CheckResidentOrder(type)
end

UICapacityTipView.OnCreate = OnCreate
UICapacityTipView.OnDestroy = OnDestroy
UICapacityTipView.RefreshData = RefreshData
UICapacityTipView.OnEnable = OnEnable
UICapacityTipView.OnDisable = OnDisable
UICapacityTipView.IptOnValueChange = IptOnValueChange
UICapacityTipView.OnSoldClick = OnSoldClick
UICapacityTipView.DoGetItem = DoGetItem
UICapacityTipView.DoResourceClick = DoResourceClick
UICapacityTipView.DoSellItem = DoSellItem
UICapacityTipView.OnAddClick = OnAddClick
UICapacityTipView.OnDecClick = OnDecClick
UICapacityTipView.ComponentDefine = ComponentDefine
UICapacityTipView.ComponentCommonDefine = ComponentCommonDefine
UICapacityTipView.ComponentSellDefine = ComponentSellDefine
UICapacityTipView.ComponentNotSellDefine = ComponentNotSellDefine
UICapacityTipView.SetDropOrSellShow = SetDropOrSellShow
UICapacityTipView.OnDropClick = OnDropClick
UICapacityTipView.OnUseClick = OnUseClick
UICapacityTipView.CheckResidentOrder = CheckResidentOrder
UICapacityTipView.JumpToBusiness = JumpToBusiness
UICapacityTipView.CheckDaBen = CheckDaBen
UICapacityTipView.CheckOtherBuild = CheckOtherBuild
UICapacityTipView.JumpToBuild = JumpToBuild
UICapacityTipView.CheckEnergy = CheckEnergy
return UICapacityTipView
