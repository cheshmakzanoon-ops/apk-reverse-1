local UIActDropPopupPanelView = BaseClass("UIActDropPopupPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIActDropPopupPanelItem = require("UI.UIActDropPopupPanel.Component.UIActDropPopupPanelItem")
local UIGray = CS.UIGray
local panel_path = "UICommonPopUpTitle/panel"
local title_text_path = "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/Common_bg_orange/CloseBtn"
local scroll_view_path = "Root/CenterGo/ScrollView"
local item_name_path = "Root/ResourceInfo/ResourceTitle"
local item_hold_count = "Root/ResourceInfo/ResourceHoldCount"
local item_icon_path = "Root/ResourceInfo/UICommonResItem"
local resource_hold_count_tip_btn_path = "Root/ResourceInfo/ResourceTitle/ResourceHoldCountTipBtn"
local resource_hold_count_tip_btn_icon_path = "Root/ResourceInfo/ResourceTitle/ResourceHoldCountTipBtn/ResourceHoldCountTipBtnIcon"
local CommonActivityPopUpBgPart = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Component.CommonActivityPopUpBgPart")

function UIActDropPopupPanelView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit()
end

function UIActDropPopupPanelView:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActDropPopupPanelView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.title_text:SetLocalText("450012")
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.panel:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.itemName = self:AddComponent(UIText, item_name_path)
  self.itemHoldCount = self:AddComponent(UIText, item_hold_count)
  self.icon = self:AddComponent(UICommonResItem, item_icon_path)
  self.resource_hold_count_tip_btn = self:AddComponent(UIButton, resource_hold_count_tip_btn_path)
  self.resource_hold_count_tip_btn:SetActive(true)
  self.resource_hold_count_tip_btn:SetOnClick(function()
    self:OnResourceHoldCountTipBtnClick()
  end)
  self.resource_hold_count_tip_btn_icon = self:AddComponent(UIImage, resource_hold_count_tip_btn_icon_path)
  self.commonActivityPopUpBgPart = self:AddComponent(CommonActivityPopUpBgPart, "CommonActivityPopUpBgPart")
  self.commonActivityPopUpBgPart:SetTitle("450012")
  self.dropRecordNodeBtn = self:AddComponent(UIButton, "Root/ResourceInfo/dropRecordNode/dropRecordNodeBtn")
  self.dropRecordNodeBtn:SetOnClick(function()
    if not self.actDropId then
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILimitDropHistory, {anim = true}, self.actDropId)
  end)
end

function UIActDropPopupPanelView:ComponentDestroy()
  self.panel = nil
  self.title_text = nil
  self.close_btn = nil
  self.scroll_view = nil
end

function UIActDropPopupPanelView:OnEnable()
  base.OnEnable(self)
end

function UIActDropPopupPanelView:OnDisable()
  base.OnDisable(self)
end

function UIActDropPopupPanelView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshActivityDetailData, self.OnGetActDropData)
end

function UIActDropPopupPanelView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshActivityDetailData, self.OnGetActDropData)
end

function UIActDropPopupPanelView:ReInit()
  self:InitData()
  self:RefreshView()
end

function UIActDropPopupPanelView:InitData()
  self.actDropId = self:GetUserData()
  self.actDropId = tonumber(self.actDropId) or 0
  self.commonActivityPopUpBgPart:InitByActivityId(self.actDropId)
  self.commonActivityPopUpBgPart:SetCloseCallback(function()
    self.ctrl:CloseSelf()
  end)
  SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(self.actDropId))
  self:RefreshActLimitedTimeFeastData()
end

function UIActDropPopupPanelView:RefreshActLimitedTimeFeastData()
  self.actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.actDropId)
  if self.actInfo == nil then
    return
  end
  self.actDropData = DataCenter.ActivityListDataManager:GetActivityDataById(self.actDropId)
  if self.actDropData == nil then
    return
  end
  self.actDropShowDatalist = self:CreateMethodsData()
  self.itemId = 0
  local para_2 = self.actInfo.para_2
  local para_2_num = tonumber(para_2) or 0
  if 0 < para_2_num then
    self.itemId = para_2_num
  end
end

function UIActDropPopupPanelView:RefreshView()
  self:RefreshTopContent()
  self:RefreshActDropContent()
end

function UIActDropPopupPanelView:RefreshTopContent()
  local iconData = {}
  iconData.rewardType = RewardType.GOODS
  iconData.itemId = self.itemId
  local cur, max = DataCenter.ActLimitedTimeFeastData:GetCurAndMax(tonumber(self.actDropId))
  self.itemHoldCount:SetLocalText("activity_99136_28", cur, max)
  local name = DataCenter.RewardManager:GetNameByType(tonumber(iconData.rewardType), tonumber(iconData.itemId))
  self.icon:ReInit(iconData)
  self.itemName:SetText(name)
end

function UIActDropPopupPanelView:RefreshActDropContent()
  if self.actDropShowDatalist == nil then
    return
  end
  if #self.actDropShowDatalist > 0 then
    self.scroll_view:SetActive(true)
    self.scroll_view:SetTotalCount(#self.actDropShowDatalist)
    self.scroll_view:RefillCells()
  else
    self.scroll_view:SetActive(false)
  end
end

function UIActDropPopupPanelView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(UIActDropPopupPanelItem, itemObj)
  cellItem:SetData(self.actDropShowDatalist[index], self.actDropId)
end

function UIActDropPopupPanelView:OnItemMoveOut(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UIActDropPopupPanelItem)
end

function UIActDropPopupPanelView:CreateMethodsData()
  if self.actDropData then
    local dropId = self.actDropData.subType
    local showDatalist = {}
    local methodsData = DataCenter.ActivityDropTemplateManager:GetTemplatesByDropId(dropId)
    for i = 1, #methodsData do
      local dropWayInfo = DataCenter.ActLimitedTimeFeastData:GetDropInfoById(tonumber(self.actDropId), methodsData[i].id)
      if dropWayInfo then
        table.insert(showDatalist, methodsData[i])
      end
    end
    return showDatalist
  end
end

function UIActDropPopupPanelView:OnGetActDropData()
  self:RefreshActLimitedTimeFeastData()
  self:RefreshView()
end

function UIActDropPopupPanelView:ClearScroll()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIActDropPopupPanelItem)
  self.actDropShowDatalist = {}
end

function UIActDropPopupPanelView:OnResourceHoldCountTipBtnClick()
  local dayNum = 0
  local getParaTab = DataCenter.ActLimitedTimeFeastData:GetActDropLimitData(tonumber(self.actDropId))
  local getPara1 = 0
  local getPara2 = 0
  for k, v in pairs(getParaTab) do
    getPara1 = k
    getPara2 = v
    break
  end
  if 0 < getPara1 then
    dayNum = getPara2
  end
  UIUtil.ShowBubbleTips(Localization:GetString("activity_99136_29", dayNum), self.resource_hold_count_tip_btn_icon.transform.position, 0, -20, 0)
end

return UIActDropPopupPanelView
