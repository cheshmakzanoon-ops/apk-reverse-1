local CityShieldPage = BaseClass("CityShieldPage", UIBaseContainer)
local base = UIBaseContainer
local CityShieldItemCell = require("UI.UILWCityShield.Component.CityShieldItemCell")
local Localization = CS.GameEntry.Localization

function CityShieldPage:DebugLog(index)
  if CommonUtil.IsDebug() or CommonUtil.IsGrayServer(1500, 2500) then
    local bagItemList = DataCenter.ItemData:GetItemList(4, 1)
    bagItemList = bagItemList or {}
    local idCount = {
      string.format("ItemGetCountsMessage.%s:", index)
    }
    for _, itemInfo in ipairs(bagItemList) do
      table.insert(idCount, string.format("id:%s,count:%s;", itemInfo.itemId, itemInfo.count))
    end
    Logger.LogInfo(table.concat(idCount, ""))
  end
end

function CityShieldPage:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:Refresh()
end

function CityShieldPage:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function CityShieldPage:ComponentDefine()
  self.scroll_view = self:AddComponent(UIScrollView, "")
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.itemList = {}
  self.cells = {}
end

function CityShieldPage:ComponentDestroy()
  self.itemList = nil
  self.cells = nil
  self.scroll_view = nil
  self.allItemList = nil
  self.haveOrBuy = nil
end

function CityShieldPage:Refresh()
  self.allItemList = {}
  self.haveOrBuy = {}
  local bagItemList = DataCenter.ItemData:GetItemList(4, 1)
  local goodsList = DataCenter.ItemTemplateManager:GetTypeListByTypes(4, 1)
  table.sort(goodsList, function(a, b)
    return a.price < b.price
  end)
  for i, itemTemplate in ipairs(goodsList) do
    local isExist = false
    for _, itemInfo in pairs(bagItemList) do
      if itemTemplate.id == itemInfo.itemId then
        isExist = true
        table.insert(self.allItemList, itemInfo)
        table.insert(self.haveOrBuy, 0)
        break
      end
    end
    if isExist == false and 0 < itemTemplate.price then
      table.insert(self.allItemList, itemTemplate)
      table.insert(self.haveOrBuy, 1)
    end
  end
  self:InitScroll()
end

function CityShieldPage:InitScroll()
  self:ClearScroll()
  local count = #self.allItemList
  self.needRefresh = {}
  for i = 1, count do
    table.insert(self.needRefresh, i)
  end
  if 0 < count then
    self.scroll_view:SetTotalCount(count)
    self.scroll_view:RefillCells()
  end
  if 0 < table.count(self.needRefresh) then
    Logger.LogError(string.format("CityShieldPage self.needRefresh.table.count:%s", table.count(self.needRefresh)))
  end
end

function CityShieldPage:ClearScroll()
  self.cells = {}
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(CityShieldItemCell)
end

function CityShieldPage:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  self.cells[index] = self.scroll_view:AddComponent(CityShieldItemCell, itemObj)
  local param = {}
  local item = self.allItemList[index]
  if self.haveOrBuy[index] == 0 then
    local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(item.itemId)
    param.name = DataCenter.ItemTemplateManager:GetName(itemTemplate.id)
    param.description = itemTemplate.description
    param.icon = itemTemplate.icon
    param.count = item.count
    param.uuid = item.uuid
  else
    param.name = DataCenter.ItemTemplateManager:GetName(item.id)
    param.description = item.description
    param.price = item.price
    param.icon = item.icon
    param.count = 0
  end
  
  function param.callBack(para)
    self:CellsCallBack(para)
  end
  
  param.index = index
  self.cells[index]:ReInit(param)
  self.needRefresh[index] = nil
end

function CityShieldPage:OnItemMoveOut(itemObj, index)
  self.cells[index] = nil
  self.scroll_view:RemoveComponent(itemObj.name, CityShieldItemCell)
end

function CityShieldPage:CellsCallBack(param)
  local index = param.index
  if DataCenter.StatusManager:IsUseShieldCD() then
    return
  end
  local WarFeverStatus = DataCenter.StatusManager:WarFeverStatu()
  if WarFeverStatus ~= nil then
    UIUtil.ShowMessage(Localization:GetString(GameDialogDefine.WAR_FEVER_NO_SHIELD_TIP), 1, GameDialogDefine.CONFIRM)
  else
    if SeasonUtil.IsInSeason() then
      local loginServerId = LuaEntry.Player:GetSelfServerId()
      local curIndex = LuaEntry.Player:GetMainWorldPos()
      if DataCenter.BirthPointTemplateManager:IsInAllianceCityField(curIndex, loginServerId) then
        UIUtil.ShowTipsId("season_tips107")
        return
      end
      local overTime, blackMode = DataCenter.AllianceSkillManager:GetBlackAreaOverTime(curIndex)
      if 1000 < overTime then
        if blackMode == AlAlertType.MissileFactory then
          UIUtil.ShowTipsId("season_s2_government_skill_tips19")
        else
          UIUtil.ShowTipsId("season_s2_government_skill_tips19")
        end
        return
      end
    end
    local protectEndTime = DataCenter.DefenceWallDataManager:GetDefenceWallData().protectEndTime
    local leftTime = protectEndTime - UITimeManager:GetInstance():GetServerTime()
    if 0 < leftTime then
      local item = self.allItemList[index]
      local statusMeta = LocalController:instance():getLine(TableName.StatusTab, item.para1)
      if leftTime > statusMeta.time * 1000 then
        UIUtil.ShowTipsId(120400)
        return
      end
      UIUtil.ShowMessage(Localization:GetString("120399", statusMeta.time / 3600), 2, "", "", function()
        self:BuyOrUse(index)
      end, function()
      end)
    else
      self:BuyOrUse(index)
    end
  end
end

function CityShieldPage:BuyOrUse(index)
  local item = self.allItemList[index]
  if self.haveOrBuy[index] == 0 then
    if DataCenter.ActMeteoriteBattleManager:NeedNoticeShield() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMeteoriteDropNoticeNotice, {anim = true}, {
        ok = function()
          self:ConfirmUse(item)
        end,
        notice = "yuntieBattle_interface_1050",
        ignoreKey = SettingKeys.NO_METEORITE_DROP_PROMPT
      })
    else
      self:ConfirmUse(item)
    end
  elseif LuaEntry.Player.gold >= item.price then
    UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.BuyUseDialog, Localization:GetString(GameDialogDefine.SPEND_SOMETHING_BUY_SOMETHING, string.GetFormattedSeperatorNum(item.price), Localization:GetString(GameDialogDefine.DIAMOND), DataCenter.ItemTemplateManager:GetName(item.id)), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      if DataCenter.ActMeteoriteBattleManager:NeedNoticeShield() then
        UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMeteoriteDropNoticeNotice, {anim = true}, {
          ok = function()
            self:ConfirmBuy(item)
          end,
          notice = "yuntieBattle_interface_1050",
          ignoreKey = SettingKeys.NO_METEORITE_DROP_PROMPT
        })
      else
        self:ConfirmBuy(item)
      end
    end)
  else
    GoToUtil.GotoPayTips(item.price)
  end
end

function CityShieldPage:ConfirmUse(item)
  DataCenter.StatusManager:SetUseShieldCD()
  SFSNetwork.SendMessage(MsgDefines.ItemUse, {
    uuid = item.uuid,
    num = 1
  })
  self.view.ctrl:CloseSelf()
end

function CityShieldPage:ConfirmBuy(template)
  DataCenter.StatusManager:SetUseShieldCD()
  SFSNetwork.SendMessage(MsgDefines.ItemBuyAndUse, {
    itemId = template.id,
    num = 1
  })
  self.view.ctrl:CloseSelf()
end

function CityShieldPage:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.ItemCountRefresh, self.OnItemCountRefresh)
end

function CityShieldPage:OnRemoveListener()
  self:RemoveUIListener(EventId.ItemCountRefresh, self.OnItemCountRefresh)
  base.OnRemoveListener(self)
end

function CityShieldPage:OnItemCountRefresh()
  self:DebugLog(3)
  self:Refresh()
end

return CityShieldPage
