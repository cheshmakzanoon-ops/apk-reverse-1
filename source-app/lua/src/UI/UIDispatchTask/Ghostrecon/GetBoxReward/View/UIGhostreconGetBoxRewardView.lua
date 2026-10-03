local base = UIBaseView
local UIGhostreconGetBoxRewardView = BaseClass("UIGhostreconGetBoxRewardView", base)
local ActDispatchTreasureRewardItemTemplate = require("DataCenter.ActivityListData.ActDispatchTreasureRewardItemTemplate")
local titleText_path = "PopUpTitle/Common_img_title/titleText"
local bg_path = "PopUpTitle/Common_bg_orange2/Bg"
local boxImg_path = "PopUpTitle/Common_bg_orange2/InfoPanel/BoxImg"
local nameText_path = "PopUpTitle/Common_bg_orange2/InfoPanel/NameText"
local content_path = "PopUpTitle/Common_bg_orange2/ScrollView/Viewport/Content"
local closePanel_path = "panel"
local closeBtn_path = "PopUpTitle/CloseBtn"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.boxImg = self:AddComponent(UIImage, boxImg_path)
  self.nameText = self:AddComponent(UIText, nameText_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.closePanel = self:AddComponent(UIButton, closePanel_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.titleText:SetLocalText("ghostrecon_058")
  self.nameText:SetLocalText("ghostrecon_001")
  self.closeBtn:SetOnClick(Bind(self, self.ctrl.CloseSelf))
  self.closePanel:SetOnClick(Bind(self, self.ctrl.CloseSelf))
end

local function ComponentDestroy(self)
  self:SetAllCellDestroy()
  self.titleText = nil
  self.bg = nil
  self.boxImg = nil
  self.nameText = nil
  self.content = nil
  self.closePanel = nil
  self.closeBtn = nil
end

local function DataDefine(self)
  self.cfg = self:GetUserData()
end

local function DataDestroy(self)
  self.cfg = nil
end

local function ReInit(self)
  self.boxImg:LoadSprite(UIAssets.UIGhostreconCommonPath .. self.cfg.supreRewardIcon)
  local tab = string.string2array_i(self.cfg.supreRewardDetail, ";", "|")
  local listReward = {}
  for index, value in ipairs(tab) do
    local reward = ActDispatchTreasureRewardItemTemplate.New()
    reward:InitData(value[3], value[1], value[2])
    table.insert(listReward, reward)
  end
  self:RefreshRewardItemPanel(listReward)
end

local function RefreshRewardItemPanel(self, listReward)
  self.modelItem = {}
  self.cells = {}
  self.fontSizeCache = nil
  if listReward then
    for i = 1, table.count(listReward) do
      self.modelItem[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
        if self.content == nil then
          return
        end
        local go = request.gameObject
        go.gameObject:SetActive(true)
        go.transform:SetParent(self.content.transform)
        go.transform:Set_localScale(0.9, 0.9, 0.9)
        go.name = "item_reward_" .. i
        local cell = self.content:AddComponent(UICommonResItem, go.name)
        cell:ReInit(listReward[i].rewardParam)
        if listReward[i].prop then
          cell.name_text:SetActive(true)
          if self.fontSizeCache == nil then
            self.fontSizeCache = cell.name_text:GetFontSize()
          end
          cell:SetNameText(string.formatDecimal(listReward[i].prop / 100, 2) .. "%", 16, 28)
          cell.name_text:SetFontSize(30)
        end
        self.cells[i] = cell
      end)
    end
  end
end

local function SetAllCellDestroy(self)
  if self.cells then
    for key, value in pairs(self.cells) do
      if value and value.name_text then
        if self.fontSizeCache then
          value.name_text:SetFontSize(self.fontSizeCache)
        end
        value.name_text:SetActive(false)
      end
    end
    self.fontSizeCache = nil
    self.cells = nil
  end
  self.content:RemoveComponents(UICommonResItem)
  if self.modelItem ~= nil then
    for k, v in pairs(self.modelItem) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
    self.modelItem = nil
  end
end

UIGhostreconGetBoxRewardView.OnCreate = OnCreate
UIGhostreconGetBoxRewardView.OnDestroy = OnDestroy
UIGhostreconGetBoxRewardView.OnEnable = OnEnable
UIGhostreconGetBoxRewardView.OnDisable = OnDisable
UIGhostreconGetBoxRewardView.ComponentDefine = ComponentDefine
UIGhostreconGetBoxRewardView.ComponentDestroy = ComponentDestroy
UIGhostreconGetBoxRewardView.DataDefine = DataDefine
UIGhostreconGetBoxRewardView.DataDestroy = DataDestroy
UIGhostreconGetBoxRewardView.ReInit = ReInit
UIGhostreconGetBoxRewardView.RefreshRewardItemPanel = RefreshRewardItemPanel
UIGhostreconGetBoxRewardView.SetAllCellDestroy = SetAllCellDestroy
return UIGhostreconGetBoxRewardView
