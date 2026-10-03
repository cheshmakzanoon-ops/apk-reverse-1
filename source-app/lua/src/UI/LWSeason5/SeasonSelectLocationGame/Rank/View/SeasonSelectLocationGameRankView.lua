local base = UIBaseView
local Localization = CS.GameEntry.Localization
local TCCommonDropDown = require("UI/LWUITC/Component/TCCommonDropDownComponent")
local SeasonSelectLocationGameRankItemCell = require("UI.LWSeason5.SeasonSelectLocationGame.Rank.Comp.SeasonSelectLocationGameRankItemCell")
local SeasonSelectLocationGameRankView = BaseClass("SeasonSelectLocationGameRankView", UIBaseView)

function SeasonSelectLocationGameRankView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.btnClose = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.textHint = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.compRankTab = self.viewSkin:AddComponent(self, TCCommonDropDown, 5)
  self.textTitleRank = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.textTitleName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textTitleScore = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.compScroll = self.viewSkin:AddComponent(self, UIScrollView, 9)
  self.goEmpty = self.viewSkin:AddComponent(self, UIBaseComponent, 10)
  self.compPCur = self.viewSkin:AddComponent(self, SeasonSelectLocationGameRankItemCell, 11)
  self.compScroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnRankItemMoveIn(itemObj, index)
  end)
  self.compScroll:SetOnItemMoveOut(function(itemObj, index)
    self:OnRankItemMoveOut(itemObj, index)
  end)
end

function SeasonSelectLocationGameRankView:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.btnInfo = nil
  self.btnClose = nil
  self.textHint = nil
  self.compRankTab = nil
  self.textTitleRank = nil
  self.textTitleName = nil
  self.textTitleScore = nil
  self.compScroll = nil
  self.goEmpty = nil
  self.compPCur = nil
end

function SeasonSelectLocationGameRankView:DataDefine()
  self.Keys = {}
  self.Tab = -1
  self.CurRankData = nil
  local rankTypeEnum = DataCenter.SeasonSelectLocationGameManager.RankType
  self.LocKeys = {
    [rankTypeEnum.Total] = {
      rankTitle = "zone_selection_location_UI_27",
      nameTitle = "zone_selection_location_UI_28",
      scoreTitle = "zone_selection_location_UI_29"
    },
    [rankTypeEnum.Server] = {
      rankTitle = "zone_selection_location_UI_27",
      nameTitle = "zone_selection_location_UI_30",
      scoreTitle = "zone_selection_location_UI_31"
    },
    [rankTypeEnum.SingleServer] = {
      rankTitle = "zone_selection_location_UI_27",
      nameTitle = "zone_selection_location_UI_28",
      scoreTitle = "zone_selection_location_UI_29"
    }
  }
end

function SeasonSelectLocationGameRankView:DataDestroy()
  self.Data = nil
end

function SeasonSelectLocationGameRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit(self:GetUserData())
end

function SeasonSelectLocationGameRankView:OnDestroy()
  DataCenter.SeasonSelectLocationGameManager:ClearCacheRankData("1_0")
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonSelectLocationGameRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonSelectLocationGameRankUpdate, self.OnGetRankCallback)
end

function SeasonSelectLocationGameRankView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonSelectLocationGameRankUpdate, self.OnGetRankCallback)
  base.OnRemoveListener(self)
end

function SeasonSelectLocationGameRankView:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
  end
end

function SeasonSelectLocationGameRankView:InitData(data)
  if data ~= nil then
    self.Data = data
    self.ServerRankData = DataCenter.SeasonSelectLocationGameManager:GetRankData(1, 0)
    return self.ServerRankData ~= nil
  end
  return false
end

function SeasonSelectLocationGameRankView:InitUi()
  self.textTitle:SetLocalText("zone_selection_location_UI_32")
  self:ClearScroll()
  self:InitDropDown()
end

function SeasonSelectLocationGameRankView:InitDropDown()
  local tabs = {}
  self.Keys = {}
  table.insert(tabs, CS.GameEntry.Localization:GetString("zone_selection_location_game_name_UI_7"))
  table.insert(self.Keys, {RankType = 0, ServerId = 0})
  local servers = self.ServerRankData.servers
  for _, sid in ipairs(servers) do
    table.insert(tabs, CS.GameEntry.Localization:GetString("zone_selection_location_game_name_UI_8", sid))
    table.insert(self.Keys, {RankType = 2, ServerId = sid})
  end
  for _, tab in pairs(tabs) do
    self.compRankTab:Add(tab)
  end
  self.compRankTab:BindIndexChangeEvent(function(index)
    self:OnToggle(index)
  end)
  local defaultIndex = Mathf.Clamp(checknumber(self.Data.DefaultTab), 1, #tabs)
  self.compRankTab:OnSelectIndexChange(defaultIndex)
end

function SeasonSelectLocationGameRankView:OnToggle(index)
  if self.Tab == index then
    return
  end
  self:ClearScroll()
  self.Tab = index
  if self:UpdateData() then
    self:UpdateUi()
  else
    local key = self.Keys[self.Tab]
    DataCenter.SeasonSelectLocationGameManager:SendGetRank(key.RankType, key.ServerId)
  end
  self:UpdateTitle()
end

function SeasonSelectLocationGameRankView:UpdateTitle()
  local rankType = self.Keys[self.Tab].RankType
  local keys = self.LocKeys[rankType]
  if keys ~= nil then
    self.textTitleRank:SetLocalText(keys.rankTitle)
    self.textTitleName:SetLocalText(keys.nameTitle)
    self.textTitleScore:SetLocalText(keys.scoreTitle)
  end
end

function SeasonSelectLocationGameRankView:UpdateData()
  local key = self.Keys[self.Tab]
  self.CurRankData = DataCenter.SeasonSelectLocationGameManager:GetRankData(key.RankType, key.ServerId)
  self.RankList = self.ctrl:ParseRankData(self.CurRankData)
  return self.RankList ~= nil
end

function SeasonSelectLocationGameRankView:UpdateUi()
  self:ClearScroll()
  local empty = #self.RankList <= 0
  if not empty then
    self.compScroll:SetTotalCount(#self.RankList)
    self.compScroll:RefillCells()
    local curData
    for k, rank in pairs(self.RankList) do
      if rank.type == DataCenter.SeasonSelectLocationGameManager.RankType.Server then
        if rank.serverId == LuaEntry.Player.serverId then
          curData = rank
          break
        end
      elseif rank.uid == LuaEntry.Player.uid then
        curData = rank
        break
      end
    end
    if curData == nil then
      curData = self.ctrl:GetSelfData(self.CurRankData)
    end
    if curData ~= nil then
      self.compPCur:SetData(curData, true)
    end
  end
  self.goEmpty:SetActive(empty)
  local key = self.Keys ~= nil and self.Keys[self.Tab] or nil
  local showSelf = key ~= nil and (key.RankType == 0 or key.ServerId == LuaEntry.Player.serverId)
  self.compPCur:SetActive(showSelf and not empty)
end

function SeasonSelectLocationGameRankView:ClearScroll()
  self.compScroll:ClearCells()
  self.compScroll:RemoveComponents(SeasonSelectLocationGameRankItemCell)
end

function SeasonSelectLocationGameRankView:OnRankItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.compScroll:AddComponent(SeasonSelectLocationGameRankItemCell, itemObj)
  if cellItem ~= nil then
    cellItem:SetData(self.RankList[index], false)
  end
end

function SeasonSelectLocationGameRankView:OnRankItemMoveOut(itemObj, index)
  self.compScroll:RemoveComponent(itemObj.name, SeasonSelectLocationGameRankItemCell)
end

function SeasonSelectLocationGameRankView:OnBtnInfoClick()
  local actData = DataCenter.SeasonTetrisManager:GetActData()
  if actData ~= nil then
    local param = {}
    param.activityRulesStr = CS.GameEntry.Localization:GetString("zone_selection_location_help_2", checknumber(actData.para_3))
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end
end

function SeasonSelectLocationGameRankView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function SeasonSelectLocationGameRankView:OnGetRankCallback(evt)
  local key = evt
  local curKeyPair = self.Keys[self.Tab]
  if curKeyPair ~= nil then
    local curKey = DataCenter.SeasonSelectLocationGameManager:GetRankCacheKey(curKeyPair.RankType, curKeyPair.ServerId)
    if curKey == key and self:UpdateData() then
      self:UpdateUi()
    end
  end
end

return SeasonSelectLocationGameRankView
