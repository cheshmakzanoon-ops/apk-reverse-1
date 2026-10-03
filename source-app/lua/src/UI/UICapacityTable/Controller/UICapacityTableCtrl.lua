local UICapacityTableCtrl = BaseClass("UICapacityTableCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UICapacityTable)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Background)
end

local function InitData(self)
end

local function GetItemListByType(self, tabType, itemType, selectId)
  local result = {}
  if tabType == UICapacityTableTab.Resource then
    for k, v in ipairs(UICapacityTableResourceType) do
      local param = {}
      param.resourceType = v
      param.tabType = tabType
      param.quality_name = "Common_img_quality_blue"
      param.icon_name = DataCenter.ResourceManager:GetResourceIconByType(v)
      table.insert(result, param)
    end
  elseif tabType == UICapacityTableTab.Farming then
    local itemList = DataCenter.ResourceItemDataManager:GetResourceItemListByTypeFromTemplate(tabType)
    if itemList ~= nil then
      table.sort(itemList, function(a, b)
        if selectId == tostring(a) then
          return true
        end
        if selectId == tostring(b) then
          return false
        end
        local task1 = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(a)
        local task2 = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(b)
        return task1 ~= nil and task2 ~= nil and task2.order > task1.order
      end)
      for k, v in ipairs(itemList) do
        local itemData = DataCenter.ResourceItemDataManager:GetItemDataByItemId(v)
        if itemData ~= nil and itemData.number > 0 then
          local param = {}
          param.itemId = v
          param.tabType = tabType
          local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(v)
          if template ~= nil and template.show == 1 then
            param.icon_name = template.pic
            param.name = template.name
            param.quality_name = "Common_img_quality_green"
            param.itemType = template.itemType
            table.insert(result, param)
          end
        end
      end
    end
  elseif tabType == UICapacityTableTab.Item then
    local goodsIsChangeState = false
    local itemInfo = DataCenter.ItemData.ItemInfos
    for k, v in pairs(itemInfo) do
      local goods = DataCenter.ItemTemplateManager:GetItemTemplate(v.itemId)
      if goods ~= nil and 0 < v.count and 0 <= goods.page then
        local param = {}
        param.itemId = goods.id
        param.tabType = tabType
        param.icon_name = goods.icon
        param.pages = goods.page
        param.order = goods.order
        param.redState = v.redState
        param.template = goods
        param.data = v
        local join_method = -1
        local icon_join
        if goods.join_method ~= nil and 0 < goods.join_method and goods.icon_join ~= nil and goods.icon_join ~= "" then
          join_method = goods.join_method
          icon_join = goods.icon_join
        end
        if 0 < join_method and icon_join ~= nil and icon_join ~= "" then
          local tempJoin = string.split(icon_join, ";")
          if 1 < #tempJoin then
            param.quality_name = tempJoin[2]
          end
          if 2 < #tempJoin then
            param.quality_name = tempJoin[3]
          end
        else
          param.quality_name = DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
        end
        local item = DataCenter.ItemData:GetItemById(param.itemId)
        if item ~= nil then
          param.num = string.GetFormattedSeperatorNum(item.count)
        end
        param.flagtxt = ""
        if goods.type == 2 then
          if goods.para1 ~= nil and goods.para1 ~= "" then
            local para1 = goods.para1
            local temp = string.split(para1, ";")
            if temp ~= nil and 1 < #temp then
              param.flagtxt = temp[1] .. temp[2]
            end
          end
        elseif goods.type == 3 or goods.type == GOODS_TYPE.GOODS_TYPE_91 then
          local type2 = goods.type2
          if type2 ~= 999 and goods.para ~= nil and goods.para ~= "" then
            local res_num = tonumber(goods.para)
            param.flagtxt = string.GetFormattedStr(res_num)
          end
        elseif goods.type == 5 and goods.para3 ~= nil and goods.para3 ~= "" then
          local res_num = tonumber(goods.para3)
          param.flagtxt = string.GetFormattedStr(res_num)
        end
        if param.pages == itemType then
          table.insert(result, param)
        elseif itemType == 0 then
          if not v.redState then
            goodsIsChangeState = false
            if goods.important == 2 then
              if goods.needCount and goods.needCount > v.count then
                goodsIsChangeState = false
                param.redState = false
              end
            else
              v.redState = true
            end
          end
          table.insert(result, param)
        end
      end
    end
    table.sort(result, function(a, b)
      if selectId == a.itemId then
        return true
      end
      if selectId == b.itemId then
        return false
      end
      local orderA = a.order
      local orderB = b.order
      if orderA < orderB then
        return true
      else
        return false
      end
    end)
    if itemType == 0 and not goodsIsChangeState then
      EventManager:GetInstance():Broadcast(EventId.OnGoodsRedState, false)
    end
  end
  return result
end

local function GetItemTypeName(self, type)
  if type == UIBagBtnType.Hot then
    return Localization:GetString("150118")
  elseif type == UIBagBtnType.War then
    return Localization:GetString("100158")
  elseif type == UIBagBtnType.Buff then
    return Localization:GetString("100159")
  elseif type == UIBagBtnType.Resource then
    return Localization:GetString("100024")
  elseif type == UIBagBtnType.Other then
    return Localization:GetString("100374")
  end
end

local function GetItemDataByItemId(self, itemId)
  local data = {}
  data.itemId = itemId
  local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(itemId)
  if template ~= nil then
    data.icon_name = template.pic
    data.name = template.name
    data.quality_name = "Common_img_quality_green"
    data.itemType = template.itemType
  end
  return data
end

local function GetTabRedState(self, tabType)
  local redNum = 0
  if tabType == UICapacityTableTab.Item then
    local itemInfo = DataCenter.ItemData.ItemInfos
    if itemInfo ~= nil then
      for k, v in pairs(itemInfo) do
        if v.redState == false then
          redNum = redNum + 1
        end
      end
    end
  end
  return redNum
end

local function OnItemUse(self, item, count)
  local template = DataCenter.ItemTemplateManager:GetItemTemplate(item.itemId)
  if DataCenter.ItemTemplateManager:IsNewVersionGoods(template.version) then
    return
  end
  if template.type == GOODS_TYPE.GOODS_TYPE_5 and template.type2 == GOODS_TYPE2.ResourceItem then
    local oneItemContainResourceItemNum = 1
    if not string.IsNullOrEmpty(template.para1) then
      oneItemContainResourceItemNum = toInt(template.para1)
    end
    if DataCenter.ResourceItemDataManager:CheckIsStorageFull(count * oneItemContainResourceItemNum) then
      GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
      return
    end
  end
  if false then
    local type_num = template.go_to
    if type_num == 1 or type_num == 4 then
      self:Close()
      UI:OpenUIForm(CS.UIAssets.UITokenShop, UILayer.Normal.Name)
      return
    end
    if type_num == 3 then
      self:Close()
      local para = CS.UIPartsMaterialInfo.Param()
      para.OpenShop = true
      para.EnableMain = false
      UI:OpenUIForm(CS.UIAssets.UIPartsMaterialInfo, UILayer.Normal.Name, para)
      return
    end
    if type_num == 7 then
      return
    elseif 0 < type_num then
      if UI:IsLoadingUIForm(CS.UIAssets.UIMultipleShop) or UI:HasUIForm(CS.UIAssets.UIMultipleShop) then
        return
      end
      UI.OpenUIForm(CS.UIAssets.UIMultipleShop, UILayer.Normal.Name, false)
    end
  end
  local type = template.type
  if type == GOODS_TYPE.GOODS_TYPE_98 then
    local jigsawCost = HeroUtils.GetJigsawCost(item.itemId)
    if count >= jigsawCost then
      local exchangeCount = count // jigsawCost
      SFSNetwork.SendMessage(MsgDefines.LotteryHeroCard, item.para1, 0, 0, tostring(item.itemId), exchangeCount)
    else
      UIUtil.ShowTipsId(GameDialogDefine.GOODNE)
    end
    return
  end
  if type == GOODS_TYPE.GOODS_TYPE_99 then
    local exchangeCount = count // HeroUtils.GetJigsawCost(item.itemId)
    if 0 < exchangeCount then
      SFSNetwork.SendMessage(MsgDefines.HeroExchange, item.itemId, exchangeCount)
    else
      UIUtil.ShowTipsId(GameDialogDefine.GOODNE)
    end
    return
  end
  if type == GOODS_TYPE.GOODS_TYPE_59 or type == GOODS_TYPE.GOODS_TYPE_102 or type == GOODS_TYPE.GOODS_TYPE_107 then
    if type == GOODS_TYPE.GOODS_TYPE_107 then
      local List = string.split(template.para1, "|")
      local str = string.split(List[1], ",")
      if DataCenter.ResourceItemDataManager:CheckIsStorageFull(count * tonumber(str[2])) then
        GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
        return
      end
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityBoxSelect, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, item.uuid, count, template)
    return
  end
  if item.itemId == SpecialItemId.ITEM_ALLIANCE_CITY_MOVE then
    if not LuaEntry.Player:IsInAlliance() then
      UIUtil.ShowTipsId(390536)
    else
      local myAlId = LuaEntry.Player.allianceId
      local hasAlCity = DataCenter.WorldAllianceCityDataManager:CheckIfHasAlCity(myAlId)
      if DataCenter.AllianceBaseDataManager:IsSelfLeader() and not hasAlCity then
        UIUtil.ShowTipsId(390848)
        return
      end
      local selfMarchCount = UIUtil.GetSelfMarchCountExceptGolloes()
      if 0 < selfMarchCount then
        UIUtil.ShowMessage(CS.GameEntry.Localization:GetString(GameDialogDefine.PLEASE_BACK_MARCH), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        end, function()
        end)
        self:CloseSelf()
      else
        SFSNetwork.SendMessage(MsgDefines.WorldAlMove, 0)
        self:CloseSelf()
      end
      return
    end
    return
  elseif item.itemId == "200070" then
    if CS.ActivityController.Instance:IsBetweenActByType(52) then
      local para = CS.UIWelfareCenter.Param()
      para.currentTab = 27
      CS.UIPreAdd.OpenUIWelfareCenter(para)
    else
      UIUtil.ShowTipsId(360215)
    end
    return
  elseif item.itemId == "200002" then
    local selfMarchCount = UIUtil.GetSelfMarchCountExceptGolloes()
    if 0 < selfMarchCount then
      UIUtil.ShowMessage(CS.GameEntry.Localization:GetString(GameDialogDefine.PLEASE_BACK_MARCH), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      end, function()
      end)
      self:CloseSelf()
    else
      local mySourceServerId = LuaEntry.Player:GetSourceServerId()
      MoveCityUtil.TryShowMoveCityModel(PlaceBuildType.MoveCity_Cmn, mySourceServerId, CS.SceneManager.World.curIndex)
      self:CloseSelf()
    end
    return
  elseif item.itemId == "200021" then
    if CoppaUtil.IsCoppaLimitWithTips() then
      return
    end
    self:CloseSelf()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChangeName, {anim = true})
    return
  elseif item.itemId == "230007" then
    local configOpenState = LuaEntry.DataConfig:CheckSwitch("hero_postershop")
    if configOpenState then
      self:CloseSelf()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroResetShop)
    else
      UIUtil.ShowTipsId(390310)
    end
    return
  end
  local useItemFromType = 0
  if template.type == 3 and (template.type2 == ResourceType.Metal or template.type2 == ResourceType.Water or template.type2 == ResourceType.Electricity or template.type2 == ResourceType.Food) then
    useItemFromType = 1
  end
  SFSNetwork.SendMessage(MsgDefines.ItemUse, {
    uuid = item.uuid,
    num = count,
    useItemFromType = useItemFromType
  })
end

local function OnSearchEnd(self, pointId, uuid)
  local worldPosition = SceneUtils.TileIndexToWorld(pointId)
  WorldArrowManager:GetInstance():ShowArrowEffect(uuid, worldPosition, ArrowType.Monster)
  GoToUtil.GotoPos(worldPosition, CS.SceneManager.World.InitZoom)
  self:CloseSelf()
end

local function VipUpdate(self, param)
  if param == 1 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIVIPUpgradePopUp, {anim = true})
  end
end

UICapacityTableCtrl.CloseSelf = CloseSelf
UICapacityTableCtrl.Close = Close
UICapacityTableCtrl.InitData = InitData
UICapacityTableCtrl.GetItemListByType = GetItemListByType
UICapacityTableCtrl.GetItemDataByItemId = GetItemDataByItemId
UICapacityTableCtrl.GetItemTypeName = GetItemTypeName
UICapacityTableCtrl.OnItemUse = OnItemUse
UICapacityTableCtrl.GetTabRedState = GetTabRedState
UICapacityTableCtrl.OnSearchEnd = OnSearchEnd
UICapacityTableCtrl.VipUpdate = VipUpdate
return UICapacityTableCtrl
