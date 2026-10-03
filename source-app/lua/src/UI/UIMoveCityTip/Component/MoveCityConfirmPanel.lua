local MoveCityConfirmPanel = BaseClass("MoveCityConfirmPanel", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local AllianceFlagItem = require("UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem")
local moveDesc_path = "moveDesc"
local moveBtn_path = "moveBtn"
local moveBtnTxt_path = "moveBtn/moveBtnTxt"
local moveCost_path = "moveBtn/cost"
local moveCostFree_path = "moveBtn/cost/costFree"
local moveCostIcon_path = "moveBtn/cost/costItem"
local moveCostNum_path = "moveBtn/cost/costGoldCount"
local itemMoveBtn_path = "itemMoveBtn"
local itemMoveBtnTxt_path = "itemMoveBtn/itemMoveBtnTxt"

local function OnCreate(self)
  base.OnCreate(self)
  self.moveDescN = self:AddComponent(UIText, moveDesc_path)
  self.moveBtnN = self:AddComponent(UIButton, moveBtn_path)
  self.moveBtnN:SetOnClick(function()
    self:OnClickMoveBtn()
  end)
  self.moveBtnTxtN = self:AddComponent(UIText, moveBtnTxt_path)
  self.moveBtnTxtN:SetLocalText(391075)
  self.moveCostN = self:AddComponent(UIBaseContainer, moveCost_path)
  self.moveCostFreeN = self:AddComponent(UIText, moveCostFree_path)
  self.moveCostFreeN:SetLocalText(130126)
  self.moveCostIconN = self:AddComponent(UIImage, moveCostIcon_path)
  self.moveCostNumN = self:AddComponent(UIText, moveCostNum_path)
  self.itemMoveBtnN = self:AddComponent(UIButton, itemMoveBtn_path)
  self.itemMoveBtnN:SetOnClick(function()
    self:OnClickItemMoveBtn()
  end)
  self.itemMoveBtnTxtN = self:AddComponent(UIText, itemMoveBtnTxt_path)
  self.itemMoveBtnTxtN:SetLocalText(391075)
end

local function OnDestroy(self)
  self.moveDescN = nil
  self.moveBtnN = nil
  self.moveBtnTxtN = nil
  self.moveCostN = nil
  self.moveCostFreeN = nil
  self.moveCostIconN = nil
  self.moveCostNumN = nil
  self.itemMoveBtnN = nil
  self.itemMoveBtnTxtN = nil
  base.OnDestroy(self)
end

local function ShowPanel(self, isShow, param)
  if not isShow then
    self:SetActive(false)
    return
  end
  self.costType = 1
  self.paramTb = param
  self:SetActive(true)
  if self.paramTb.strTip then
    self.moveDescN:SetText(self.paramTb.strTip)
  elseif self.paramTb.isInviteMove then
    self.moveDescN:SetLocalText(391080)
  else
    self.moveDescN:SetLocalText(141140)
  end
  if LuaEntry.Player:CheckIfHasFreeAlMove() then
    self.moveCostFreeN:SetActive(true)
    self.moveCostIconN:SetActive(false)
    self.moveCostNumN:SetActive(false)
    self.itemMoveBtnN:SetActive(false)
    self.moveBtnN:SetActive(true)
    self.costType = 1
  else
    self.moveCostFreeN:SetActive(false)
    local item = DataCenter.ItemData:GetItemById(SpecialItemId.LW_ITEM_ALLY_MOVE_CITY)
    self.moveCostIconN:LoadSprite(string.format(LoadPath.ItemPath, DataCenter.ItemTemplateManager:GetItemTemplate(SpecialItemId.LW_ITEM_ALLY_MOVE_CITY).icon))
    local itemCount = item and item.count or 0
    if 0 < itemCount then
      self.itemMoveBtnN:SetActive(true)
      self.moveBtnN:SetActive(false)
      self.costType = 4
    else
      self.itemMoveBtnN:SetActive(false)
      self.moveBtnN:SetActive(true)
      item = DataCenter.ItemData:GetItemById(SpecialItemId.ITEM_ALLIANCE_CITY_MOVE)
      itemCount = item and item.count or 0
      if 0 < itemCount then
        self.moveCostIconN:SetActive(true)
        self.moveCostNumN:SetActive(false)
        self.costType = 2
      else
        self.moveCostIconN:SetActive(false)
        self.moveCostNumN:SetActive(true)
        self.moveCostNumN:SetText("500")
        self.costType = 3
      end
    end
  end
end

local function OnClickMoveBtn(self)
  if not DataCenter.AllianceRallyPointDataManager:CanAllianceMoveCity() then
    UIUtil.ShowTipsId("alliance_AssemblyPoint_tips_06")
    return
  end
  local byInvite = self.paramTb and self.paramTb.isInviteMove or false
  if self.costType == 3 then
    local price = LuaEntry.DataConfig:TryGetNum("union_move", "k3") or 0
    if LuaEntry.Player.gold < tonumber(price) then
      self.view.ctrl:CloseSelf()
      GoToUtil.GotoPayTips(price)
      return
    else
      self.view.ctrl:Close()
      UIUtil.ShowMessage(Localization:GetString("391076", price), 2, "", "", function()
        local costType = self.costType
        MoveCityUtil.AllianceMoveCityToRecommendRallyPoint(costType, byInvite)
      end, function()
      end)
    end
  else
    local costType = self.costType
    MoveCityUtil.AllianceMoveCityToRecommendRallyPoint(costType, byInvite)
  end
end

local function OnClickItemMoveBtn(self)
  if not DataCenter.AllianceRallyPointDataManager:CanAllianceMoveCity() then
    UIUtil.ShowTipsId("alliance_AssemblyPoint_tips_06")
    return
  end
  if self.costType == 4 then
    self.view.ctrl:Close()
    MoveCityUtil.AllianceMoveCityToRecommendRallyPoint(self.costType, false)
  end
end

MoveCityConfirmPanel.OnCreate = OnCreate
MoveCityConfirmPanel.OnDestroy = OnDestroy
MoveCityConfirmPanel.ShowPanel = ShowPanel
MoveCityConfirmPanel.OnClickMoveBtn = OnClickMoveBtn
MoveCityConfirmPanel.OnClickItemMoveBtn = OnClickItemMoveBtn
return MoveCityConfirmPanel
