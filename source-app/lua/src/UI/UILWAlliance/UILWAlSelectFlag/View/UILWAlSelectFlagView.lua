local UILWAlSelectFlagView = BaseClass("UILWAlSelectFlagView", UIBaseView)
local base = UIBaseView
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UILWAlSelectFlagCell = require("UI.UILWAlliance.UILWAlSelectFlag.Component.UILWAlSelectFlagCell")
local title_txt_path = "Root/TopBar/TextTitle"
local scroll_view_path = "Root/MiddleContentContainer/ScrollView"
local desc_icon_path = "Root/MiddleContentContainer/Down/icon"
local desc_txt_path = "Root/MiddleContentContainer/Down/DescTxt"
local return_btn_path = "Root/BottomBar/BtnBack"
local random_btn_path = "Root/BottomBar/RandomBtn"
local random_name_path = "Root/BottomBar/RandomBtn/RandomText"
local confirm_btn_path = "Root/BottomBar/ConfirmBtn"
local confirm_name_path = "Root/BottomBar/ConfirmBtn/ConfirmText"
local gold_btn_path = "Root/BottomBar/goldBtn"
local gold_text_path = "Root/BottomBar/goldBtn/goldText"
local gold_count_path = "Root/BottomBar/goldBtn/goldCount"
local TITLE_TXT = 391051
local RANDOM_TXT = 393009
local CONFIRM_TXT = 393010
local NO_PROPERTY_TXT = 393020

function UILWAlSelectFlagView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlSelectFlagView:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlSelectFlagView:ComponentDefine()
  self.txt_title = self:AddComponent(UIText, title_txt_path)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCellMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnCellMoveOut(itemObj, index)
  end)
  self.desc_icon = self:AddComponent(UIImage, desc_icon_path)
  self.desc_txt = self:AddComponent(UIText, desc_txt_path)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.random_name = self:AddComponent(UIText, random_name_path)
  self.random_btn = self:AddComponent(UIButton, random_btn_path)
  self.random_btn:SetOnClick(function()
    self:OnRandomBtnClick()
  end)
  self.confirm_name = self:AddComponent(UIText, confirm_name_path)
  self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
  self.confirm_btn:SetOnClick(function()
    self:OnConfirmBtnClick()
  end)
  self.gold_btn = self:AddComponent(UIButton, gold_btn_path)
  self.gold_btn:SetOnClick(function()
    self:OnConfirmBtnClick()
  end)
  self.gold_text = self:AddComponent(UIText, gold_text_path)
  self.gold_count = self:AddComponent(UIText, gold_count_path)
  self.txt_title:SetLocalText(TITLE_TXT)
  self.random_name:SetLocalText(RANDOM_TXT)
  self.confirm_name:SetLocalText(CONFIRM_TXT)
  self.gold_text:SetLocalText(CONFIRM_TXT)
end

function UILWAlSelectFlagView:ComponentDestroy()
  self.txt_title = nil
  self.scroll_view = nil
  self.desc_icon = nil
  self.desc_txt = nil
  self.return_btn = nil
  self.random_name = nil
  self.random_btn = nil
  self.confirm_name = nil
  self.confirm_btn = nil
  self.gold_btn = nil
  self.gold_text = nil
  self.gold_count = nil
end

function UILWAlSelectFlagView:DataDefine()
  self.list = {}
  self.cells = {}
  self.selectIndex = nil
  self.curFlag = nil
  self.curIdx = 0
  self.confirmCallBack = nil
end

function UILWAlSelectFlagView:DataDestroy()
  self.list = nil
  self.cells = nil
  self.selectIndex = nil
  self.curFlag = nil
  self.curIdx = nil
  self.confirmCallBack = nil
end

function UILWAlSelectFlagView:OnEnable()
  base.OnEnable(self)
  self:ReInit()
end

function UILWAlSelectFlagView:OnDisable()
  base.OnDisable(self)
end

function UILWAlSelectFlagView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceFlagChanged, self.OnAllianceFlagChanged)
end

function UILWAlSelectFlagView:OnRemoveListener()
  self:RemoveUIListener(EventId.AllianceFlagChanged, self.OnAllianceFlagChanged)
  base.OnRemoveListener(self)
end

function UILWAlSelectFlagView:OnAllianceFlagChanged(newFlag)
  self.curFlag = newFlag
  CS.UIGray.SetGray(self.gold_btn.transform, true, false)
  if self.cost > LuaEntry.Player.gold then
    self.goldEnough = false
    self.gold_count:SetColor(RedColor)
  else
    self.goldEnough = true
    self.gold_count:SetColor(WhiteColor)
  end
  self:ShowCells()
end

function UILWAlSelectFlagView:ClearScroll()
  self.cells = {}
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UILWAlSelectFlagCell)
end

function UILWAlSelectFlagView:ReInit()
  local param = self:GetUserData()
  self.curFlag = param.curFlag
  self.confirmCallBack = param.callback
  local cost = param.cost and param.cost or 0
  self.cost = cost
  if 0 < cost then
    self.random_btn:SetActive(false)
    self.gold_btn:SetActive(true)
    self.confirm_btn:SetActive(false)
    self.gold_count:SetText(cost)
    if cost > LuaEntry.Player.gold then
      self.goldEnough = false
      self.gold_count:SetColor(RedColor)
    else
      self.goldEnough = true
      self.gold_count:SetColor(WhiteColor)
    end
    CS.UIGray.SetGray(self.gold_btn.transform, true, false)
  else
    self.goldEnough = true
    self.gold_btn:SetActive(false)
    self.confirm_btn:SetActive(true)
  end
  self:ShowCells()
end

function UILWAlSelectFlagView:ShowCells()
  self:ClearScroll()
  self.list = self:GetShowList()
  local tempCount = table.count(self.list)
  if 0 < tempCount then
    self.scroll_view:SetTotalCount(tempCount)
    self.scroll_view:RefillCells()
  end
end

function UILWAlSelectFlagView:GetShowList()
  local list = {}
  for k, v in ipairs(LWAlFlagIcons) do
    table.insert(list, v)
    if v == self.curFlag then
      if self.cost > 0 then
        self.curIdx = k
      end
      self.selectIndex = k
    end
  end
  return list
end

function UILWAlSelectFlagView:OnCellMoveIn(itemObj, index)
  itemObj.name = index
  local cellItem = self.scroll_view:AddComponent(UILWAlSelectFlagCell, itemObj)
  local param = {
    index = index,
    icon = self.list[index],
    isSelect = self.selectIndex == index,
    isCur = self.curIdx == index,
    callBack = function(tempIndex)
      self:CellCallBack(tempIndex)
    end
  }
  cellItem:ReInit(param)
  if param.isSelect then
    self:RefreshDesc(index)
  end
  self.cells[index] = cellItem
end

function UILWAlSelectFlagView:RefreshDesc(index)
  self.desc_icon:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, self.list[index]))
  self.desc_txt:SetLocalText(NO_PROPERTY_TXT)
end

function UILWAlSelectFlagView:CellCallBack(index)
  if self.selectIndex ~= index then
    self:SetCellsSelect(self.selectIndex, false)
    self:SetCellsSelect(index, true)
    self.selectIndex = index
    self:RefreshDesc(index)
    local same = index == self.curIdx
    CS.UIGray.SetGray(self.gold_btn.transform, same, not same)
  end
end

function UILWAlSelectFlagView:SetCellsSelect(index, value)
  local cell = self.cells[index]
  if cell ~= nil then
    cell:SetSelect(value)
  end
end

function UILWAlSelectFlagView:OnCellMoveOut(itemObj, index)
  self.cells[index] = nil
  self.scroll_view:RemoveComponent(itemObj.name, UILWAlSelectFlagCell)
end

function UILWAlSelectFlagView:OnRandomBtnClick()
  local randomIndex = math.random(1, #self.list)
  self:CellCallBack(randomIndex)
end

function UILWAlSelectFlagView:OnConfirmBtnClick()
  if not self.goldEnough then
    UIUtil.ShowTipsId("E100001")
    return
  end
  self.curFlag = self.list[self.selectIndex]
  self.curIdx = self.selectIndex
  CS.UIGray.SetGray(self.gold_btn.transform, true, false)
  if self.confirmCallBack then
    self.confirmCallBack(self.curFlag)
  end
  if self.cost == 0 then
    self.ctrl:CloseSelf()
  end
end

return UILWAlSelectFlagView
