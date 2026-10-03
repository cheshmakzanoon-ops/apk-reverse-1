local LWUISupplementAllView = BaseClass("LWUISupplementAllView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local LWNeedResourceItemRender = require("UI.LWSupplementAll.Component.LWNeedResourceItemRender")
local title_path = "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/Common_bg_orange/CloseBtn"
local cancel_btn_path = "Root/CancelBtn"
local confirm_btn_path = "Root/ConfirmBtn"
local black_mask_path = "UICommonPopUpTitle/panel"
local needResource_item_path = "Root/NeedResourceItemRender"
local needResource_item_content_path = "Root/Panel/NeedResourceContent"
local scrollView_path = "Root/Panel/ScrollView"
local scrollView_content_path = "Root/Panel/ScrollView/Viewport/Content"
local common_bg_orange_path = "UICommonPopUpTitle/Common_bg_orange"
local root_path = "Root"
local panel_path = "Root/Panel"
local panelWidth = 700
local panelHeight = 532
local resCellHeight = 61

function LWUISupplementAllView:OnCreate()
  base.OnCreate(self)
  self.data, self.selectResourceData = self:GetUserData()
  self:DataDefine()
  self:ComponentDefine()
  self:ReInit()
end

function LWUISupplementAllView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWUISupplementAllView:DataDefine()
  self.listGo = {}
end

function LWUISupplementAllView:DataDestroy()
  self.listGo = nil
  self.scrollDataList = nil
end

function LWUISupplementAllView:OnInitScroll(go, index)
  local item = self.scrollView:AddComponent(UICommonResItem, go)
  self.listGo[go] = item
end

function LWUISupplementAllView:OnUpdateScroll(go, index)
  local cellItem = self.listGo[go]
  if cellItem then
    local itemIndex = index + 1
    go.name = tostring(itemIndex)
    cellItem:ReInit(self.scrollDataList[itemIndex])
  end
end

function LWUISupplementAllView:OnDestroyScrollItem()
end

function LWUISupplementAllView:ComponentDefine()
  self.title_text = self:AddComponent(UIText, title_path)
  self.title_text:SetText(Localization:GetString("450015"))
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.maskBtn = self:AddComponent(UIButton, black_mask_path)
  self.maskBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.cancel_btn = self:AddComponent(UIButton, cancel_btn_path)
  self.cancel_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
  self.confirm_btn:SetOnClick(function()
    self:ConfirmBtnClick()
  end)
  self.needResource_content = self:AddComponent(UIBaseContainer, needResource_item_content_path)
  self.needResource_item_obj = self.transform:Find(needResource_item_path).gameObject
  self.needResource_item_obj:GameObjectCreatePool()
  self.scrollView = self:AddComponent(UIScrollRect, scrollView_path)
  self.scrollView_grid = self:AddComponent(GridInfinityScrollView, scrollView_content_path)
  self.common_bg_orange = self:AddComponent(UIButton, common_bg_orange_path)
  self.root = self:AddComponent(UIBaseContainer, root_path)
  self.panel = self:AddComponent(UIBaseContainer, panel_path)
end

function LWUISupplementAllView:ComponentDestroy()
  self.title_text = nil
  self.close_btn = nil
  self.cancel_btn = nil
  self.confirm_btn = nil
  self.needResource_content:RemoveComponents(LWNeedResourceItemRender)
  self.needResource_item_obj:GameObjectRecycleAll()
  self.needResource_content = nil
  self.scrollView:RemoveComponents(UICommonResItem)
  self.scrollView_grid:DestroyChildNode()
  self.scrollView = nil
  self.scrollView_grid = nil
  self.common_bg_orange = nil
  self.root = nil
end

function LWUISupplementAllView:GetItemCount(itemId)
  if not self.itemsCount then
    self.itemsCount = {}
  end
  local numItemId = tonumber(itemId)
  if not self.itemsCount[numItemId] then
    local items = DataCenter.ItemData:GetItemById(numItemId)
    local itemCount = items and items.count or 0
    self.itemsCount[numItemId] = itemCount
  end
  return self.itemsCount[numItemId]
end

function LWUISupplementAllView:SetItemCount(itemId, count)
  if not self.itemsCount then
    self.itemsCount = {}
  end
  if count < 0 then
    count = 0
  end
  self.itemsCount[tonumber(itemId)] = count
end

function LWUISupplementAllView:ReInit()
  self.scrollDataList = {}
  for i = 1, #self.data do
    local resType = self.data[i].resType
    local needRes = self.data[i].need
    local haveRes = LuaEntry.Resource:GetCntByResType(resType)
    local deficiencyRes = 0
    if self.selectResourceData.resType == resType then
      needRes = self.selectResourceData.needResCount
      deficiencyRes = needRes
    else
      deficiencyRes = needRes - haveRes
    end
    local goItemList = self:GetResourceByUseItemWay(resType)
    if goItemList ~= nil then
      table.sort(goItemList, function(a, b)
        return a.quality < b.quality
      end)
      for k, v in pairs(goItemList) do
        if deficiencyRes <= 0 then
          break
        end
        local give = v.give
        local haveNum = v.haveNum
        if 0 < give then
          local useNum = Mathf.Min(Mathf.Ceil(deficiencyRes / give), haveNum)
          local totalGive = useNum * give
          deficiencyRes = deficiencyRes - totalGive
          haveRes = haveRes + totalGive
          local tempParam = {}
          tempParam.rewardType = RewardType.GOODS
          tempParam.itemId = v.itemId
          tempParam.count = useNum
          tempParam.quality = v.quality
          if v.chooseItemIndex then
            tempParam.chooseItemIndex = v.chooseItemIndex
          end
          self:SetItemCount(v.itemId, self:GetItemCount(v.itemId) - useNum)
          table.insert(self.scrollDataList, tempParam)
        end
      end
      table.sort(self.scrollDataList, function(a, b)
        return a.quality > b.quality
      end)
    end
    local itemObj = self.needResource_item_obj:GameObjectSpawn(self.needResource_content.transform)
    itemObj.name = "item" .. i
    itemObj:SetActive(true)
    local needResourceItemRender = self.needResource_content:AddComponent(LWNeedResourceItemRender, itemObj.name)
    needResourceItemRender:ReInit(resType, haveRes, self.data[i].need)
  end
  local cellNum = math.ceil(#self.data / 2)
  local resHeight = cellNum * resCellHeight
  self.needResource_content:SetSizeDeltaXY(panelWidth, resHeight)
  self.scrollView:SetSizeDeltaXY(panelWidth, panelHeight - resHeight - 10)
  local bindFunc1 = BindCallback(self, self.OnInitScroll)
  local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
  local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
  self.scrollView_grid:Init(bindFunc1, bindFunc2, bindFunc3)
  self.scrollView_grid:SetItemCount(#self.scrollDataList)
end

function LWUISupplementAllView:GetResourceByUseItemWay(resType)
  local goItemList = {}
  local templates = DataCenter.LWResourceLackManager:GetResourceWay(resType)
  if not templates or #templates == 0 then
    return nil
  end
  for k, v in pairs(templates) do
    if v.tips == LWResourceLackGetWay.UseItem then
      local items = DataCenter.ItemData:GetItemById(v.para1)
      local itemCount = self:GetItemCount(v.para1)
      if 0 < itemCount then
        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(items.itemId)
        local type = tonumber(goods.type)
        if type == GOODS_TYPE.GOODS_TYPE_3 then
          local give = tonumber(items.para2) or 0
          table.insert(goItemList, {
            itemId = tonumber(items.itemId),
            give = give,
            haveNum = itemCount,
            quality = goods.color
          })
        elseif type == GOODS_TYPE.GOODS_TYPE_109 then
          local returnItem = DataCenter.AdaptiveBoxTemplateManager:GetReturnItem(tonumber(goods.para1), DataCenter.BuildManager.MainLv, tonumber(goods.para2))
          local give = returnItem.count * tonumber(goods.para3)
          table.insert(goItemList, {
            itemId = tonumber(items.itemId),
            give = give,
            haveNum = itemCount,
            quality = goods.color
          })
        elseif goods:IsSelectBox() and not goods:IsGuarantBox() then
          local List = string.split(items.para1, "|")
          local options = {}
          local optionsIndices = {}
          for i = 1, #List do
            local item = string.split(List[i], ",")
            options[tonumber(item[1])] = tonumber(item[2])
            optionsIndices[tonumber(item[1])] = i
          end
          local templates = {}
          templates = DataCenter.LWResourceLackManager:GetResourceWay(resType)
          if templates then
            for i = 1, #templates do
              local lackTemplate = templates[i]
              local para1Num = tonumber(lackTemplate.para1)
              if para1Num and lackTemplate.tips == LWResourceLackGetWay.UseItem and options[para1Num] then
                local goodsTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(para1Num)
                local perGainItemCount = GoodsUtil.GetGoodsReturnItemCount(goodsTemplate.id, resType)
                table.insert(goItemList, {
                  itemId = tonumber(items.itemId),
                  give = perGainItemCount,
                  haveNum = itemCount,
                  quality = goods.color,
                  chooseItemIndex = optionsIndices[para1Num]
                })
                break
              end
            end
          end
        end
      end
    end
  end
  return goItemList
end

function LWUISupplementAllView:ConfirmBtnClick()
  for k, v in pairs(self.scrollDataList) do
    local items = DataCenter.ItemData:GetItemById(v.itemId)
    if items ~= nil then
      local itemCount = items.count
      local goods = DataCenter.ItemTemplateManager:GetItemTemplate(items.itemId)
      local goodType = tonumber(goods.type)
      if goodType == GOODS_TYPE.GOODS_TYPE_3 then
        local give = tonumber(goods.para2) or 0
        SFSNetwork.SendMessage(MsgDefines.ItemUse, {
          uuid = items.uuid,
          give = give,
          haveNum = itemCount,
          num = v.count
        })
      elseif goodType == GOODS_TYPE.GOODS_TYPE_109 then
        local returnItem = DataCenter.AdaptiveBoxTemplateManager:GetReturnItem(tonumber(goods.para1), DataCenter.BuildManager.MainLv, tonumber(goods.para2))
        local give = returnItem.count * tonumber(goods.para3)
        SFSNetwork.SendMessage(MsgDefines.ItemUse, {
          uuid = items.uuid,
          give = give,
          haveNum = itemCount,
          num = v.count
        })
      end
      if goods:IsSelectBox() and not goods:IsGuarantBox() and v.chooseItemIndex then
        SFSNetwork.SendMessage(MsgDefines.ItemUse, {
          uuid = items.uuid,
          para1 = tostring(v.chooseItemIndex),
          num = v.count,
          continueUse = true
        })
      end
    end
  end
  self.ctrl:CloseSelf()
end

return LWUISupplementAllView
