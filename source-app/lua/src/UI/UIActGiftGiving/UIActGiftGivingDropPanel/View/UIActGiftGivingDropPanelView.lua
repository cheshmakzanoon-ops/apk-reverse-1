local UIActGiftGivingDropPanelView = BaseClass("UIActGiftGivingDropPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIActGiftGivingDropPanelItem = require("UI.UIActGiftGiving.UIActGiftGivingDropPanel.Component.UIActGiftGivingDropPanelItem")
local UIGray = CS.UIGray
local panel_path = "UICommonPopUpTitle/panel"
local title_text_path = "UICommonPopUpTitle/Common_bg_orange/Common_img_title/titleText"
local close_btn_path = "UICommonPopUpTitle/Common_bg_orange/CloseBtn"
local cooking_btn_path = "Root/ProductContent/CookingBtn"
local u_i_common_res_item_path = "Root/ProductContent/needContent/UICommonResItem"
local need_num_path = "Root/ProductContent/needContent/needNum"
local scroll_view_path = "Root/CenterGo/ScrollView"
local txt_path = "Root/CenterGo/dropContent/txt"
local target_content_path = "Root/ProductContent/targetContent"
local cooking_btn_txt_path = "Root/ProductContent/CookingBtn/CookingBtnTxt"
local drop_tip_btn_path = "Root/CenterGo/dropContent/txt/dropTipBtn"
local ViewState = {Normal = 1, Cooking = 2}

function UIActGiftGivingDropPanelView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit()
end

function UIActGiftGivingDropPanelView:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActGiftGivingDropPanelView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.title_text:SetLocalText("thxgiv_CookTitle")
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.panel:SetOnClick(function()
    self:TryForcePlaySaveMsgReward()
    self.ctrl:CloseSelf()
  end)
  self.close_btn:SetOnClick(function()
    self:TryForcePlaySaveMsgReward()
    self.ctrl:CloseSelf()
  end)
  self.cooking_btn = self:AddComponent(UIButton, cooking_btn_path)
  self.u_i_common_res_item = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
  self.need_num = self:AddComponent(UITextMeshProUGUIEx, need_num_path)
  self.cooking_btn:SetOnClick(function()
    self:OnCookingBtnClick()
  end)
  self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.txt = self:AddComponent(UITextMeshProUGUIEx, txt_path)
  self.target_content = self:AddComponent(UIAnimator, target_content_path)
  self.cooking_btn_txt = self:AddComponent(UITextMeshProUGUIEx, cooking_btn_txt_path)
  self.drop_tip_btn = self:AddComponent(UIButton, drop_tip_btn_path)
  self.drop_tip_btn:SetOnClick(function()
    self:OnDropTipBtnClick()
  end)
end

function UIActGiftGivingDropPanelView:ComponentDestroy()
  self.panel = nil
  self.title_text = nil
  self.close_btn = nil
  self.cooking_btn = nil
  self.u_i_common_res_item = nil
  self.need_num = nil
  self.scroll_view = nil
  self.txt = nil
  self.target_content = nil
  self.cooking_btn_txt = nil
  self.drop_tip_btn = nil
end

function UIActGiftGivingDropPanelView:OnEnable()
  base.OnEnable(self)
end

function UIActGiftGivingDropPanelView:OnDisable()
  base.OnDisable(self)
end

function UIActGiftGivingDropPanelView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshActivityDetailData, self.OnGetActDropData)
  self:AddUIListener(EventId.ActGiftGivingExchange, self.GetActExchangeMsg)
end

function UIActGiftGivingDropPanelView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshActivityDetailData, self.OnGetActDropData)
  self:RemoveUIListener(EventId.ActGiftGivingExchange, self.GetActExchangeMsg)
end

function UIActGiftGivingDropPanelView:ReInit()
  self:InitData()
  self:TryPlayNormalStateType()
  self:RefreshView()
end

function UIActGiftGivingDropPanelView:InitData()
  self.activityId = self:GetUserData()
  if not self.activityId then
    return
  end
  self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
  if self.activityInfo == nil then
    return
  end
  self.activityDetailData = DataCenter.ActGiftGivingDataManager:GetActData(self.activityId)
  if self.activityDetailData == nil then
    return
  end
  self.activityTemp = DataCenter.ActGiftGivingDataManager:GetTempByActInfo(self.activityInfo)
  self.costItemId = self.activityTemp.merge_cost_item_tab[1]
  self.costItemNum = self.activityTemp.merge_cost_item_tab[2]
  self.targetItemId = self.activityTemp.merge_gain_item_tab[1]
  self.targetItemNum = self.activityTemp.merge_gain_item_tab[2]
  self.actDropId = self.activityTemp.activity_drop
  SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet, tostring(self.actDropId))
  self.curState = ViewState.Normal
  self.curStateEndTime = 0
  self.curCookingMsg = nil
  self:RefreshActLimitedTimeFeastData()
end

function UIActGiftGivingDropPanelView:RefreshActLimitedTimeFeastData()
  self.actDropData = DataCenter.ActivityListDataManager:GetActivityDataById(self.actDropId)
  if self.actDropData == nil then
    return
  end
  self.actDropShowDatalist = self:CreateMethodsData()
end

function UIActGiftGivingDropPanelView:RefreshView()
  self:RefreshTopContent()
  self:RefreshActDropContent()
end

function UIActGiftGivingDropPanelView:RefreshTopContent()
  local curNum = DataCenter.ItemData:GetItemCount(self.costItemId)
  local param = {
    rewardType = RewardType.GOODS,
    itemId = self.costItemId
  }
  self.u_i_common_res_item:ReInit(param)
  self.need_num:SetText(string.format("%s/%s", curNum, self.costItemNum))
end

function UIActGiftGivingDropPanelView:RefreshActDropContent()
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
  local cur, max = DataCenter.ActLimitedTimeFeastData:GetCurAndMax(tonumber(self.actDropId))
  self.txt:SetLocalText("thxgiv_CookTitle2", cur, max)
end

function UIActGiftGivingDropPanelView:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(UIActGiftGivingDropPanelItem, itemObj)
  cellItem:SetData(self.actDropShowDatalist[index], self.actDropId)
end

function UIActGiftGivingDropPanelView:OnItemMoveOut(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UIActGiftGivingDropPanelItem)
end

function UIActGiftGivingDropPanelView:OnCookingBtnClick()
  local curNum = DataCenter.ItemData:GetItemCount(self.costItemId)
  local needNum = self.costItemNum
  if curNum < needNum then
    UIUtil.ShowTipsId("thxgiv_CookLackFood")
  else
    local productNum = math.floor(curNum / needNum)
    SFSNetwork.SendMessage(MsgDefines.ThanksgivingExchange, self.activityId, productNum)
  end
end

function UIActGiftGivingDropPanelView:CreateMethodsData()
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

function UIActGiftGivingDropPanelView:OnGetActDropData()
  self:RefreshActLimitedTimeFeastData()
  self:RefreshActDropContent()
end

function UIActGiftGivingDropPanelView:GetActExchangeMsg(t)
  self:RefreshTopContent()
  self:TryForcePlaySaveMsgReward()
  self:TryPlayCookingStateType(t)
end

function UIActGiftGivingDropPanelView:ClearScroll()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIActGiftGivingDropPanelItem)
  self.actDropShowDatalist = {}
end

function UIActGiftGivingDropPanelView:TryPlayNormalStateType()
  self.curCookingMsg = nil
  self.curState = ViewState.Normal
  self.curStateEndTime = 0
  self.target_content:Play("UIActGiftGivingDropPanelReadyCooking")
  UIGray.SetGray(self.cooking_btn.transform, false, true)
  self.cooking_btn_txt:SetLocalText("thxgiv_CookNow")
end

function UIActGiftGivingDropPanelView:TryPlayCookingStateType(t)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  self.curCookingMsg = t
  self.curState = ViewState.Cooking
  self.curStateEndTime = 0
  local isSuccess, aniTime = self.target_content:PlayAnimationReturnTime("UIActGiftGivingDropPanelCooking")
  if aniTime == nil then
    aniTime = 0
  end
  self.curStateEndTime = curTime + aniTime * 1000
  UIGray.SetGray(self.cooking_btn.transform, true, false)
  self.cooking_btn_txt:SetLocalText("thxgiv_Cooking")
end

function UIActGiftGivingDropPanelView:TryForcePlaySaveMsgReward()
  if self.curCookingMsg then
    DataCenter.RewardManager:ShowCommonReward(self.curCookingMsg)
    self.curCookingMsg = nil
  end
end

function UIActGiftGivingDropPanelView:OnDropTipBtnClick()
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
  local strTip = Localization:GetString("thxgiv_CookTips", dayNum)
  UIUtil.ShowBubbleTips(strTip, self.drop_tip_btn.transform.position, 0, -30, 0, nil, nil)
end

function UIActGiftGivingDropPanelView:Update100MS()
  if self.curState == ViewState.Cooking then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime >= self.curStateEndTime then
      self:TryForcePlaySaveMsgReward()
      self:TryPlayNormalStateType()
    end
  end
end

return UIActGiftGivingDropPanelView
