local CommonActivityPopUpBgPart = BaseClass("CommonActivityPopUpBgPart", UIBaseContainer)
local M = CommonActivityPopUpBgPart
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Notifier = require("Common.Notifier")
local bg2DefaultPath = "Assets/Main/Sprites/UI/CommonBG/cfm_tongyon_tanchuang_erjichen.png"
local activityThemPath = "Assets/Main/Sprites/UI/ActivityThemeSkin/%s"
local toggle_path = "Tab/Toggle"
local toggleNum = 2
local tabTextUnselectDefaultColor = Color.New(1.0, 1.0, 1.0, 0.49411764705882355)
local tabTextSelectDefaultColor = Color.white
local tabUnselectBgDefaultPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_yeqian_erji_2.png"
local tabSelectBgDefaultPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_yeqian_erji_1.png"

function M:OnCreate()
  base.OnCreate(self)
  self.callback = nil
  self:ComponentDefine()
  self:DataDefine()
end

function M:OnDestroy()
  self:DestroyRequest()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.compOuterBgOld = self:AddComponent(UIBaseComponent, "OuterBg_Old")
  self.compOuterBgNew = self:AddComponent(UIBaseComponent, "OuterBg_New")
  self.imgOuterBgTop = self:AddComponent(UIImage, "OuterBg_New/OuterBg_Top/OuterBg_Top_Img")
  self.imgOuterBgMiddle = self:AddComponent(UIImage, "OuterBg_New/OuterBg_Middle")
  self.imgOuterBgBottom = self:AddComponent(UIImage, "OuterBg_New/OuterBg_Bottom/OuterBg_Bottom_Img")
  self.compTopBannerEffect = self:AddComponent(UIVfx, "TopBannerEffect")
  self.compBottomBannerEffect = self:AddComponent(UIVfx, "BottomBannerEffect")
  self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "TitlePart/titleText")
  self.imgInnerBg = self:AddComponent(UIImage, "InnerBg")
  self.closeBtn = self:AddComponent(UIButton, "TitlePart/CloseBtn")
  self.closeBtn:SetOnClick(function()
    self:OnBtnClose()
  end)
  self.bottomNode = self:TryAddComponent(UIBaseComponent, "OuterBg_New/OuterBg_Bottom/BottomNode")
  self.toggleList = {}
  for i = 1, toggleNum do
    local root = self:AddComponent(UIButton, toggle_path .. i)
    self.toggleList[i] = {
      root = root,
      tab_text = root:AddComponent(UIText, "tab_text"),
      tab_text2 = root:AddComponent(UIText, "Choose/tab_text2"),
      Choose = root:AddComponent(UIBaseContainer, "Choose"),
      tabUnselectBgImg = root:AddComponent(UIImage, ""),
      tabSelectBgImg = root:AddComponent(UIImage, "Choose")
    }
    root:SetOnClick(function()
      self:OnSelectIndex(i)
    end)
  end
  self.imgOuterBgTop:SetRaycastTarget(true)
  self.imgOuterBgMiddle:SetRaycastTarget(true)
  self.imgOuterBgBottom:SetRaycastTarget(true)
end

function M:ComponentDestroy()
  self.compOuterBgOld = nil
  self.compOuterBgNew = nil
  self.imgOuterBgTop = nil
  self.imgOuterBgMiddle = nil
  self.imgOuterBgBottom = nil
  if self.compTopBannerEffect then
    self.compTopBannerEffect:Remove()
    self.compTopBannerEffect = nil
  end
  if self.compBottomBannerEffect then
    self.compBottomBannerEffect:Remove()
    self.compBottomBannerEffect = nil
  end
  self.textTitle = nil
  self.imgInnerBg = nil
  self.callback = nil
  self.bottomNode = nil
  self.toggleList = nil
end

function M:DataDefine()
  self.uiWindowName = nil
  self.selectCallback = nil
end

function M:DataDestroy()
  self.uiWindowName = nil
  self.selectCallback = nil
end

function M:SetDefaultPacking()
  self.compOuterBgOld:SetActive(true)
  self.compOuterBgNew:SetActive(false)
  self.compTopBannerEffect:Remove()
  self.compTopBannerEffect:SetActive(false)
  self.compBottomBannerEffect:Remove()
  self.compBottomBannerEffect:SetActive(false)
end

function M:InitByActivityId(activityId, UIWindowName)
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  if activityInfo == nil then
    return
  end
  if activityInfo:GetFestivalInterfaceCfgId() then
    local festivalInterfaceCfgId = activityInfo:GetFestivalInterfaceCfgId()
    if not festivalInterfaceCfgId then
      self:SetDefaultPacking()
      return
    end
    local lineData = LocalController:instance():getLine(TableName.Festival_Interface_Config, festivalInterfaceCfgId)
    if lineData == nil then
      self:SetDefaultPacking()
      return
    end
    self:ModifyPanelPacking(lineData, UIWindowName, activityId)
  end
end

function M:SetShowEffect(show)
  self.showEffect = show
end

function M:ModifyPanelPacking(lineData, uiWindowName, activityId)
  self.compOuterBgOld:SetActive(false)
  self.compOuterBgNew:SetActive(true)
  if string.IsNullOrEmpty(lineData.board_di_text) then
    self.imgInnerBg:LoadSpriteAsyncWithCallback(bg2DefaultPath)
  else
    local configList = string.split(lineData.board_di_text, "|")
    self.imgInnerBg:LoadSpriteAsyncWithCallback(string.format(activityThemPath, configList[1]))
  end
  local topLoadFlag = false
  local bottomLoadFlag = false
  
  local function loadMiddleBGFunc()
    self.imgOuterBgMiddle:LoadSpriteAsyncWithCallback(string.format(activityThemPath, lineData.board_di), function()
      self.imgOuterBgMiddle.rectTransform:Set_offsetMin(self.imgOuterBgMiddle.rectTransform.offsetMin.x, self.imgOuterBgBottom.rectTransform.rect.height)
      self.imgOuterBgMiddle.rectTransform:Set_offsetMax(self.imgOuterBgMiddle.rectTransform.offsetMax.x, -1 * self.imgOuterBgTop.rectTransform.rect.height)
    end)
  end
  
  self.imgOuterBgTop:LoadSpriteAsyncWithCallback(string.format(activityThemPath, lineData.top_banner), function()
    self.imgOuterBgTop:SetNativeSize()
    topLoadFlag = true
    if topLoadFlag and bottomLoadFlag then
      loadMiddleBGFunc()
    end
  end)
  self.imgOuterBgBottom:LoadSpriteAsyncWithCallback(string.format(activityThemPath, lineData.bottom_banner), function()
    self.imgOuterBgBottom:SetNativeSize()
    bottomLoadFlag = true
    if topLoadFlag and bottomLoadFlag then
      loadMiddleBGFunc()
    end
  end)
  local showEffect = true
  if not string.IsNullOrEmpty(uiWindowName) and activityId then
    showEffect = DataCenter.ActFestivalPopUpManager:CheckLoadEffect(activityId, uiWindowName)
  end
  local bannerEffect = lineData.top_banner_effect
  if showEffect and not string.IsNullOrEmpty(bannerEffect) then
    local bannerEffArr = string.split(bannerEffect, ";")
    local effName = bannerEffArr[1]
    local showInFront = bannerEffArr[2] and tonumber(bannerEffArr[2]) == 1
    self.compTopBannerEffect:SetActive(true)
    self.compTopBannerEffect:PlayByStay(effName, {isBreak = true})
    if bannerEffArr[2] then
      if showInFront then
        self.compTopBannerEffect.transform:SetAsLastSibling()
      else
        self.compTopBannerEffect.transform:SetAsFirstSibling()
      end
    end
  else
    self.compTopBannerEffect:SetActive(false)
    self.compTopBannerEffect:Remove()
  end
  if string.IsNullOrEmpty(lineData.bottom_banner_effect) then
    self.compBottomBannerEffect:SetActive(false)
    self.compBottomBannerEffect:Remove()
  else
    self.compBottomBannerEffect:SetActive(true)
    self.compBottomBannerEffect:PlayByStay(lineData.bottom_banner_effect, {isBreak = true})
  end
  local showBottomNode = true
  if not string.IsNullOrEmpty(uiWindowName) and activityId then
    showBottomNode = DataCenter.ActFestivalPopUpManager:CheckShowBottomNode(activityId, uiWindowName)
  end
  local bottomNodePath = lineData.board_decoration
  if not self.nodeReq and not string.IsNullOrEmpty(bottomNodePath) and showBottomNode and self.bottomNode then
    self.nodeReq = self:GameObjectInstantiateAsync(bottomNodePath, function(req)
      if req == nil or IsNull(req.gameObject) then
        return
      end
      local nodeObj = req.gameObject
      nodeObj:SetActive(true)
      nodeObj.transform:SetParent(self.bottomNode.transform)
      nodeObj.transform:Set_anchoredPosition(0, 0, 0)
      nodeObj.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local worldPos = nodeObj.transform.position
      nodeObj.transform:SetParent(self.transform.parent)
      nodeObj.transform.position = worldPos
      nodeObj.transform:SetAsLastSibling()
    end)
  end
  if string.IsNullOrEmpty(lineData.board_page) then
    for _, v in pairs(self.toggleList) do
      if v ~= nil then
        v.tab_text:SetColor(tabTextUnselectDefaultColor)
        v.tab_text2:SetColor(tabTextSelectDefaultColor)
        v.tabUnselectBgImg:LoadSpriteAsync(tabUnselectBgDefaultPath)
        v.tabSelectBgImg:LoadSpriteAsync(tabSelectBgDefaultPath)
      end
    end
  else
    local tabCfg = UIActivityCenterCommonUtil.GetActivityTabGroupCfg(activityId)
    for _, v in pairs(self.toggleList) do
      if v ~= nil then
        v.tabSelectBgImg:LoadSpriteAsync(tabCfg.selectPath)
        v.tabUnselectBgImg:LoadSpriteAsync(tabCfg.unSelectPath)
        v.tab_text2:SetColor(tabCfg.selectColor)
        v.tab_text:SetColor(tabCfg.unSelectColor)
      end
    end
  end
end

function M:SetTitle(title)
  self.textTitle:SetLocalText(title or 2000047)
end

function M:SetCloseCallback(callback)
  self.callback = callback
end

function M:OnBtnClose()
  if self.callback then
    self:callback()
  end
end

function M:DestroyRequest()
  if self.nodeReq then
    self:GameObjectDestroy(self.nodeReq)
    self.nodeReq = nil
  end
end

function M:SetSelectCallback(func)
  self.selectCallback = func
end

function M:SetSelectIndex(index)
  self:OnSelectIndex(index)
end

function M:OnSelectIndex(index)
  if self.selectCallback ~= nil then
    self.selectCallback(index)
  end
  for i = 1, toggleNum do
    if self.toggleList and self.toggleList[i] then
      self.toggleList[i].Choose:SetActive(i == index)
    end
  end
end

function M:SetToggleText(index, text)
  if self.toggleList and self.toggleList[index] then
    self.toggleList[index].tab_text:SetText(text)
    self.toggleList[index].tab_text2:SetText(text)
  end
end

return M
