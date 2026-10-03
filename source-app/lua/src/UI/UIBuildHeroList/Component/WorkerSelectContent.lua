local WorkerSelectContent = BaseClass("WorkerSelectContent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIBuildHeroItem = require("UI.UIBuildHeroList.Component.UIBuildHeroItem")
local u_i_worker_list_cell_path = "UIWorkerListCell"
local content_path = "scrollView/Content"
local scroll_view_path = "scrollView"
local bottom_btn_path = "bottomBtn"
local bottom_btn_text_path = "bottomBtn/bottomBtnText"
local tip_txt_path = "TipTxt"

function WorkerSelectContent:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function WorkerSelectContent:OnDestroy()
  self:ClearScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function WorkerSelectContent:ClearScroll()
  self.scroll_view:RemoveComponents(UIBuildHeroItem)
  self.content:DestroyChildNode()
end

local function OnInitScroll(self, go, index)
  local item = self.scroll_view:AddComponent(UIBuildHeroItem, go)
  self.listGO[go] = item
end

local function OnUpdateScroll(self, go, index)
  local item = self.listGO[go]
  local data = self.heroDatalist[index + 1]
  item:SetActive(true)
  item:ReInit(data, index + 1, self.beSelectIndex, function(beSelectIndex)
    self:OnSelectChange(beSelectIndex)
  end)
end

local function OnDestroyScrollItem(self, go, index)
end

function WorkerSelectContent:ComponentDefine()
  self.u_i_worker_list_cell = self:AddComponent(UIBaseContainer, u_i_worker_list_cell_path)
  self.u_i_worker_list_cell:SetActive(false)
  self.content = self:AddComponent(GridInfinityScrollView, content_path)
  self.scroll_view = self:AddComponent(UIScrollRect, scroll_view_path)
  self.listGO = {}
  local bindFunc1 = BindCallback(self, OnInitScroll)
  local bindFunc2 = BindCallback(self, OnUpdateScroll)
  local bindFunc3 = BindCallback(self, OnDestroyScrollItem)
  self.content:Init(bindFunc1, bindFunc2, bindFunc3)
  self.bottom_btn = self:AddComponent(UIButton, bottom_btn_path)
  self.bottom_btn:SetOnClick(function()
    self:OnBottomBtnClick()
  end)
  self.bottom_btn_text = self:AddComponent(UITextMeshProUGUIEx, bottom_btn_text_path)
  self.tip_txt = self:AddComponent(UITextMeshProUGUIEx, tip_txt_path)
end

function WorkerSelectContent:ComponentDestroy()
end

function WorkerSelectContent:DataDefine()
  self.heroDatalist = nil
  self.curBuildIndex = nil
  self.slot = nil
  self.beSelectIndex = 1
end

function WorkerSelectContent:DataDestroy()
  self.heroDatalist = nil
  self.curBuildIndex = nil
  self.slot = nil
  self.beSelectIndex = nil
end

function WorkerSelectContent:ReInit(heroDatalist, curBuildIndex, slot)
  self.heroDatalist = heroDatalist
  self.curBuildIndex = curBuildIndex
  self.slot = slot
  self.content:SetAnchoredPositionXY(0, 0)
  self:RefreshView()
end

function WorkerSelectContent:RefreshView()
  local dataLen = #self.heroDatalist
  self.content:SetItemCount(dataLen)
  self.content:ForceUpdate()
  self:RefreshBottomBtn()
end

function WorkerSelectContent:RefreshBottomBtn()
  local dataLen = #self.heroDatalist
  if self.beSelectIndex == nil or dataLen < self.beSelectIndex then
    self.bottom_btn:SetActive(false)
    self.tip_txt:SetActive(true)
  else
    local param = self.heroDatalist[self.beSelectIndex]
    if type(param) == "table" then
      if param.grey then
        self.bottom_btn:SetActive(true)
        self.tip_txt:SetActive(false)
        UIGray.SetGray(self.bottom_btn.transform, true, true)
        self.bottom_btn_text:SetLocalText("worker_building_button3")
      elseif param.dispatchingBuildUid then
        self.bottom_btn:SetActive(true)
        self.tip_txt:SetActive(false)
        UIGray.SetGray(self.bottom_btn.transform, false, true)
        self.bottom_btn_text:SetLocalText("worker_building_button2")
      else
        self.bottom_btn:SetActive(true)
        self.tip_txt:SetActive(false)
        UIGray.SetGray(self.bottom_btn.transform, false, true)
        self.bottom_btn_text:SetLocalText("worker_building_button2")
      end
    elseif type(param) == "number" then
      self.bottom_btn:SetActive(true)
      self.tip_txt:SetActive(false)
      UIGray.SetGray(self.bottom_btn.transform, false, true)
      self.bottom_btn_text:SetLocalText("worker_building_button5")
    end
  end
end

function WorkerSelectContent:OnBottomBtnClick()
  local dataLen = #self.heroDatalist
  if self.beSelectIndex == nil or dataLen < self.beSelectIndex then
  else
    local param = self.heroDatalist[self.beSelectIndex]
    if type(param) == "table" then
      if param.grey then
      elseif param.dispatchingBuildUid ~= nil and param.dispatchingBuildUid ~= param.curBuildData.uuid and param.curBuildData.itemId ~= BuildingTypes.LW_BUILD_LIBRARY then
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(param.dispatchingBuildUid)
        local curBuildDataLevel = param.curBuildData.level
        local curBuildDataItemId = param.curBuildData.itemId
        if buildData then
          curBuildDataLevel = buildData.level
          curBuildDataItemId = buildData.itemId
        end
        local buildCurLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(curBuildDataItemId, curBuildDataLevel)
        local buildName = ""
        if buildCurLevelTemplate then
          buildName = Localization:GetString(buildCurLevelTemplate.name)
        end
        UIUtil.ShowMessage(Localization:GetString("worker_change_tips", param:GetName(), curBuildDataLevel, buildName), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          self:DispatchingHero(param)
        end)
      elseif param.dispatchingBuildUid == param.curBuildData.uuid then
        UIManager.Instance:DestroyWindow(UIWindowNames.UIBuildHeroList)
      else
        self:DispatchingHero(param)
      end
    elseif type(param) == "number" then
      UIManager.Instance:OpenWindow(UIWindowNames.UIWorkerOverviewList, {anim = true}, {jumpType = 1, jumpParam = param})
    end
  end
end

function WorkerSelectContent:DispatchingHero(param)
  SFSNetwork.SendMessage(MsgDefines.BuildAssignHeroMessage, param.curBuildData.uuid, self.slot, param.uid)
  local text = ""
  for effectId, effectValue in pairs(param.effectDict) do
    if 0 < effectValue then
      local curTxt = WorkerUtil.GetEffectText(effectId, effectValue)
      text = text .. curTxt .. " "
    end
  end
  if not string.IsNullOrEmpty(text) then
    UIUtil.ShowTips(text)
  end
  UIManager.Instance:DestroyWindow(UIWindowNames.UIBuildHeroList)
end

function WorkerSelectContent:OnSelectChange(beSelectIndex)
  self.beSelectIndex = beSelectIndex
  self:RefreshView()
end

return WorkerSelectContent
