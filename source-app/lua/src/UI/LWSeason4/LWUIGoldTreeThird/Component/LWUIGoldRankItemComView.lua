local Localization = CS.GameEntry.Localization
local LWUIGoldRankItemComView = BaseClass("LWUIGoldRankItemComView", UIBaseContainer)
local base = UIBaseContainer
local LWUIGoldRankItemComAuto = require("UI.LWSeason4.LWUIGoldTreeThird.Auto.LWUIGoldRankItemComAuto")

function LWUIGoldRankItemComView:OnCreate()
  base.OnCreate(self)
  self.binder = LWUIGoldRankItemComAuto.New()
  self.binder:bind(self)
  self.btn_Info:SetOnClick(BindCallback(self, self.ClickCardHelp))
  self.sv_sv:SetFixedItemSize(100, 100)
  self.sv_sv:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.sv_sv:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
end

function LWUIGoldRankItemComView:OnDestroy()
  self.sv_sv:ClearCells()
  self.sv_sv:RemoveComponents(UICommonHead)
  self.binder:unbind(self)
  self.binder = nil
  self.index = nil
  self.poolData = nil
  self.data = nil
  self.isSelf = nil
  base.OnDestroy(self)
end

function LWUIGoldRankItemComView:SetData(index, data, history)
  self.index = index
  self.poolData = data[index].list
  self.isSelf = data[index].isSelf
  self.history = history
  self.data = data
end

function LWUIGoldRankItemComView:RefreshUI()
  local show = self.index <= self.data.poolCount + 1
  self:SetActive(show)
  if not show then
    return
  end
  local empty = self.index == self.data.poolCount + 1
  self.empty:SetActive(empty)
  self.show:SetActive(not empty and #self.poolData > 0)
  self.notpeople:SetActive(not empty and #self.poolData == 0)
  self.title:SetActive(self.index == 1 or not empty)
  self.btn_Info:SetActive(show and #self.poolData > 0)
  if empty then
    return
  end
  local extraData = self.data[self.index]
  local cardName = "100206"
  if extraData.combinationId ~= nil then
    local cardTemp = DataCenter.SeasonGoldTreeTemplateManager:GetCardCombinationsTemp(extraData.combinationId)
    cardName = cardTemp.name
  end
  if extraData.comName ~= nil then
    self.txt_cardType:SetLocalText("season_golden_tree_phase_third_UI_7", self.index, Localization:GetString(extraData.comName))
  else
    self.txt_cardType:SetLocalText("season_golden_tree_phase_third_UI_7", self.index, Localization:GetString(cardName))
  end
  if show then
    local config = DataCenter.SeasonGoldTreeThirdManager:GetGoldTreeThirdConfig()
    local rewardPre = Localization:GetString("320362", config:GetPrizePool(self.data.poolCount, self.index))
    self.txt_reward:SetText(rewardPre)
    self.img_sign:SetActive(self.isSelf)
  end
  if #self.poolData > 0 then
    local count = #self.poolData
    if 8 <= count then
      self.content:SetAnchorMaxXY(0, 1)
      self.content:SetAnchorMinXY(0, 1)
      self.content:SetPivotXY(0, 1)
    else
      self.content:SetAnchorMaxXY(0.5, 0.5)
      self.content:SetAnchorMinXY(0.5, 0.5)
      self.content:SetPivotXY(0.5, 0.5)
    end
    self.content:SetAnchoredPositionXY(0, 0)
    self.sv_sv:SetTotalCount(#self.poolData)
    self.sv_sv:RefillCells()
  end
end

function LWUIGoldRankItemComView:RefreshHistoryUI()
  local show = #self.poolData > 0
  self:SetActive(show)
  if not show then
    return
  end
  self.empty:SetActive(false)
  self.show:SetActive(true)
  self.notpeople:SetActive(false)
  self.title:SetActive(true)
  self.btn_Info:SetActive(true)
  local extraData = self.data[self.index]
  local cardName = "100206"
  if extraData.combinationId ~= nil then
    local cardTemp = DataCenter.SeasonGoldTreeTemplateManager:GetCardCombinationsTemp(extraData.combinationId)
    cardName = cardTemp.name
  end
  if extraData.comName ~= nil then
    self.txt_cardType:SetLocalText("season_golden_tree_phase_third_UI_7", self.index, Localization:GetString(extraData.comName))
  else
    self.txt_cardType:SetLocalText("season_golden_tree_phase_third_UI_7", self.index, Localization:GetString(cardName))
  end
  if show then
    local config = DataCenter.SeasonGoldTreeThirdManager:GetGoldTreeThirdConfig()
    local rewardPre = Localization:GetString("320362", config:GetPrizePool(self.data.poolCount, self.index))
    self.txt_reward:SetText(rewardPre)
    self.img_sign:SetActive(self.isSelf)
  end
  if #self.poolData > 0 then
    self.sv_sv:SetTotalCount(#self.poolData)
    self.sv_sv:RefillCells()
  end
end

function LWUIGoldRankItemComView:ClickCardHelp()
  if self.view then
    self.view:ClickCardHelp(self.data, self.index)
  end
end

function LWUIGoldRankItemComView:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.sv_sv:AddComponent(UICommonHead, itemObj)
  local playerData = self.poolData[index]
  local oneData = PlayerRankData.New()
  oneData:ParseData(playerData.userInfo)
  if playerData.hide == 0 or self.history then
    cellItem:SetEnableClickShowInfo(true, true)
    cellItem:SetHead(oneData.uid, oneData.pic, oneData.picVer, nil, oneData:GetHeadBgImg())
  else
    cellItem:SetEnableClickShowInfo(false, true)
    cellItem:SetHead(nil, "Assets/Main/Sprites/UI/UIHeadIcon/player_head_3_big.png")
  end
end

function LWUIGoldRankItemComView:OnDeleteCell(itemObj, index)
  self.sv_sv:RemoveComponent(itemObj.name, UICommonHead)
end

return LWUIGoldRankItemComView
