local base = UIBaseView
local UIFishEatRowCell = require("UI.UIFishing.UIFishEat.Comp.UIFishEatRowCell")
local UIFishEatView = BaseClass("UIFishEatView", UIBaseView)

function UIFishEatView:ComponentDefine()
  local panel_btn_path = "panelBtn"
  local p_text_buff_path = "panel/root/npcImg/Image/ContentScroll/Viewport/p_text_buff"
  local p_list_view_path = "panel/root/p_list_view"
  local p_btn_how_to_play_path = "panel/root/p_btn_how_to_play"
  local p_btn_eat_path = "panel/root/p_btn_eat"
  local close_btn_path = "panel/root/closeBtn"
  self.panel_btn = self:AddComponent(UIButton, panel_btn_path)
  self.panel_btn:SetOnClick(BindCallback(self, self.OnCloseClicked))
  self.p_text_buff = self:AddComponent(UITextMeshProUGUIEx, p_text_buff_path)
  self.p_list_view = self:AddComponent(UILoopListViewSimple, p_list_view_path)
  self.p_btn_how_to_play = self:AddComponent(UIButton, p_btn_how_to_play_path)
  self.p_btn_how_to_play:SetOnClick(BindCallback(self, self.OnHowToPlayClicked))
  self.p_btn_eat = self:AddComponent(UIButton, p_btn_eat_path)
  self.p_btn_eat:SetOnClick(BindCallback(self, self.OnEatClicked))
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(BindCallback(self, self.OnCloseClicked))
end

function UIFishEatView:ComponentDestroy()
  self.panel_btn = nil
  self.p_text_buff = nil
  self.p_list_view = nil
  self.p_btn_how_to_play = nil
  self.p_btn_eat = nil
  self.close_btn = nil
end

function UIFishEatView:DataDefine()
end

function UIFishEatView:DataDestroy()
  self.Data = nil
end

function UIFishEatView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit(self:GetUserData())
end

function UIFishEatView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIFishEatView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.FishEatClickFish, self.OnClickEvt)
  self:AddUIListener(EventId.RefreshMyFishList, self.OnRefresh)
end

function UIFishEatView:OnRemoveListener()
  self:RemoveUIListener(EventId.FishEatClickFish, self.OnClickEvt)
  self:RemoveUIListener(EventId.RefreshMyFishList, self.OnRefresh)
  base.OnRemoveListener(self)
end

function UIFishEatView:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function UIFishEatView:InitData(data)
  self.Fishes = {}
  LocalController:instance():visitTable(TableName.Fish, function(id, cell)
    if cell.use_goods == 1 then
      local camp, level = string.string2_ii(cell.birthplace, ";")
      local fish = {}
      fish.Cell = DeepCopy(cell)
      fish.Num = DataCenter.FishingDataManager:GetMyFishNum(id)
      fish.Camp = camp
      fish.Level = level
      table.insert(self.Fishes, fish)
    end
  end)
  table.sort(self.Fishes, function(a, b)
    if a.Level ~= b.Level then
      return a.Level < b.Level
    end
    if a.Camp ~= b.Camp then
      return a.Camp < b.Camp
    end
    return a.id < b.id
  end)
  return true
end

function UIFishEatView:InitUi()
  SFSNetwork.SendMessage(MsgDefines.SeasonFishGetPlayerFishInfo)
  self.p_list_view:Init(UIFishEatRowCell)
  self.p_list_view:Clear()
  local focusFish
  local lastUseFishId = DataCenter.FishingDataManager:GetLastUseFishId()
  local focusListViewIndex = 0
  local listViewIndex = 0
  if not table.IsNullOrEmpty(self.Fishes) then
    local fishes = {}
    for _, fish in ipairs(self.Fishes) do
      if focusFish == nil then
        focusFish = fish.Cell
        focusListViewIndex = listViewIndex
      end
      if fish.Cell.id == lastUseFishId then
        focusFish = fish.Cell
        focusListViewIndex = listViewIndex
      end
      table.insert(fishes, fish.Cell)
      if table.count(fishes) == 3 then
        local cellData = {}
        cellData.Fishes = fishes
        listViewIndex = self.p_list_view:AddData(cellData)
        fishes = {}
      end
    end
    if 0 < table.count(fishes) then
      local cellData = {}
      cellData.Fishes = fishes
      self.p_list_view:AddData(cellData)
    end
    self.p_list_view:Show()
    focusListViewIndex = Mathf.Max(0, focusListViewIndex - 1)
    self.p_list_view:MovePanelToItemIndex(focusListViewIndex)
  end
  self.CurSelect = nil
  if focusFish ~= nil then
    EventManager:GetInstance():Broadcast(EventId.FishEatClickFish, focusFish)
    self:OnClickEvt(focusFish)
  end
  self.p_btn_how_to_play:SetActive(false)
end

function UIFishEatView:UpdateData()
  return true
end

function UIFishEatView:UpdateUi()
  self:UpdateBuff()
end

function UIFishEatView:UpdateBuff()
  local desc = ""
  if self.CurSelect ~= nil then
    desc = DataCenter.StatusManager:GetDescByStatusId(self.CurSelect.status)
  end
  if string.IsNullOrEmpty(desc) then
    desc = ""
  end
  self.p_text_buff:SetText(desc)
  self:UpdateBtnState()
end

function UIFishEatView:UpdateBtnState()
  if self.CurSelect ~= nil then
    local count = DataCenter.FishingDataManager:GetMyFishNum(self.CurSelect.id)
    CS.UIGray.SetGray(self.p_btn_eat.transform, count <= 0, true)
  end
end

function UIFishEatView:OnHowToPlayClicked()
end

function UIFishEatView:OnEatClicked()
  if self.CurSelect == nil then
    return
  end
  local count = DataCenter.FishingDataManager:GetMyFishNum(self.CurSelect.id)
  if count <= 0 then
    return
  end
  
  local function eatAction()
    local cell = DataCenter.FishMetaManager:GetMeta(self.CurSelect.id)
    if cell ~= nil and cell.use_goods == 1 then
      DataCenter.FishingDataManager:FetchUseOneFish(cell.id)
    end
  end
  
  if DataCenter.FishingDataManager:HasAnyActiveStatus() then
    local tips = CS.GameEntry.Localization:GetString("s6_use_fish_buff_tips")
    
    local function leftCallback()
      eatAction()
    end
    
    UIUtil.ShowMessage(tips, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, leftCallback)
  else
    eatAction()
  end
end

function UIFishEatView:OnClickEvt(evt)
  if evt ~= nil then
    self.CurSelect = evt
    self:UpdateBuff()
  end
end

function UIFishEatView:OnRefresh()
  self:UpdateBtnState()
end

function UIFishEatView:OnCloseClicked()
  self.ctrl:CloseSelf()
end

return UIFishEatView
