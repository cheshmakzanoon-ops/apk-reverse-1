local ResourceLackItem = require("UI.UIResourceLackNew.Component.ResourceLackItem")
local UIResourceLackNewView = BaseClass("UIResourceLackNewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local title_path = "Root/UICommonMidPopUpTitle/titleText"
local return_btn_path = "panel"
local close_btn_path = "Root/UICommonMidPopUpTitle/CloseBtn"
local content_path = "Root/ImgBg/Common_bg_need_resource/content"
local res_txt_path = "Root/ImgBg/Res_Rect/Res_Obj/Res_Txt"
local res_icon_path = "Root/ImgBg/Res_Rect/Res_Obj/Res_Icon"
local resnum_txt_path = "Root/ImgBg/Res_Rect/Res_Obj/ResNum_Txt"
local res_obj_path = "Root/ImgBg/Res_Rect"
local image_bg_path = "Root/ImgBg"
local slider_path = "Root/ImgBg/SliderGo/Common_bg1/Slider"
local slider_txt_path = "Root/ImgBg/SliderGo/Common_bg1/LeftTime"
local slider_icon_path = "Root/ImgBg/SliderGo/Common_bg1/BuildIcon"
local slider_image_path = "Root/ImgBg/SliderGo/Common_bg1/Slider/Fill Area/Fill"
local root_path = "Root"
local restips_txt_path = "Root/ImgBg/Txt_ResTips"
local animator_path = ""

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit()
end

local function OnDestroy(self)
  DataCenter.ArrowManager:RemoveArrow()
  if self.delayTimer ~= nil then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  if self.delayTime ~= nil then
    self.delayTime:Stop()
    self.delayTime = nil
  end
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.title = self:AddComponent(UIText, title_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.res_txt = self:AddComponent(UIText, res_txt_path)
  self.resnum_txt = self:AddComponent(UIText, resnum_txt_path)
  self.res_img = self:AddComponent(UIImage, res_icon_path)
  self.close_btn = self:AddComponent(UIButton, close_btn_path)
  self.close_btn:SetOnClick(function()
    self:DoClosePanel()
  end)
  self.return_btn = self:AddComponent(UIButton, return_btn_path)
  self.return_btn:SetOnClick(function()
    self:DoClosePanel()
  end)
  self.root = self:AddComponent(UIBaseContainer, root_path)
  local k, v, startPt = self:GetUserData()
  self.root.transform:Set_localPosition(0, 0, 0)
  self.root.transform:Set_localScale(1, 1, 1)
  self.animator = self:AddComponent(UIAnimator, animator_path)
  if startPt ~= nil then
    self.animator:Play("ResourceLackClose", 0, 0)
    local time = 0.4
    self.root.transform:Set_position(startPt.x, startPt.y, startPt.z)
    self.root.transform:Set_localScale(0.1, 0.1, 0.1)
    self.root.transform:DOLocalMove(Vector3.New(0, 0, 0), time)
    self.root.transform:DOScale(Vector3.one, time)
  end
  self.res_obj = self:AddComponent(UIBaseContainer, res_obj_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.slider_icon = self:AddComponent(UIImage, slider_icon_path)
  self.slider_txt = self:AddComponent(UIText, slider_txt_path)
  self.slider_image = self:AddComponent(UIImage, slider_image_path)
  self.restips_txt = self:AddComponent(UIText, restips_txt_path)
  self.toggleList = {}
  for i = 1, 4 do
    self.toggleList[i] = self:AddComponent(UIToggle, "Root/ImgBg/Tab/Toggle" .. i)
    self.toggleList[i].img = self.toggleList[i]:AddComponent(UIImage, "img")
    self.toggleList[i].choose = self.toggleList[i]:AddComponent(UIBaseContainer, "Choose")
    self.toggleList[i].choose_img = self.toggleList[i]:AddComponent(UIImage, "Choose/choose_img")
    self.toggleList[i].red = self.toggleList[i]:AddComponent(UIImage, "Img_Red")
    if i == 1 then
      self.toggleList[i]:SetIsOn(true)
    else
      self.toggleList[i]:SetIsOn(false)
    end
    self.toggleList[i]:SetOnValueChanged(function(tf)
      if tf then
        self:ToggleControlBorS(i)
      end
    end)
  end
end

local function ComponentDestroy(self)
  self:ClearList()
  self.title = nil
  self.content = nil
  self.res_txt = nil
  self.resnum_txt = nil
  self.res_img = nil
  self.close_btn = nil
  self.return_btn = nil
  self.lackResource = nil
  self.distab = nil
  self.img_bg = nil
  self.res_obj = nil
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshResLackList, self.OnRefreshView)
  self:AddUIListener(EventId.UseItemSuccess, self.UseItemSuccessHandle)
  self:AddUIListener(EventId.BuyKonbiniRefresh, self.UseItemSuccessHandle)
  self:AddUIListener(EventId.BuyItemAndRes, self.UseItemSuccessHandle)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshResLackList, self.OnRefreshView)
  self:RemoveUIListener(EventId.UseItemSuccess, self.UseItemSuccessHandle)
  self:RemoveUIListener(EventId.BuyKonbiniRefresh, self.UseItemSuccessHandle)
  self:RemoveUIListener(EventId.BuyItemAndRes, self.UseItemSuccessHandle)
end

local function ReInit(self)
  self.lackResource, self.distab, self.startPt, self.isList, self.isPVESTAMINA = self:GetUserData()
  self.model = {}
  self.restips_txt:SetLocalText(143595)
  if self.isList then
    for i = 1, 4 do
      if i <= #self.lackResource then
        if #self.lackResource ~= 1 then
          self.toggleList[i]:SetActive(true)
          if self.distab[i].isItem then
            self.toggleList[i].img:LoadSprite(string.format(LoadPath.ResourceIcons, "item_unSelect"))
            self.toggleList[i].choose_img:LoadSprite(string.format(LoadPath.ResourceIcons, "item_select"))
          else
            self.toggleList[i].img:LoadSprite(ResourceTabUnSelectImage[self.distab[i].resType])
            self.toggleList[i].choose_img:LoadSprite(ResourceTabSelectImage[self.distab[i].resType])
          end
        else
          self.toggleList[i]:SetActive(false)
        end
        self.toggleList[i].red:SetActive(true)
      else
        self.toggleList[i]:SetActive(false)
      end
      self.toggleIndex = 1
      self:ToggleControlBorS(1)
    end
  end
end

local function ClearList(self)
  self.content:RemoveComponents(ResourceLackItem)
  if next(self.model) then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.needResourceCells = {}
end

local function OnAddClick(self)
  if self.lackResource ~= nil and table.count(self.lackResource) > 0 then
    local resourceType
    for k, v in pairs(self.lackResource) do
      resourceType = k
      break
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceBag, resourceType, self.lackResource)
  end
  self.ctrl:CloseSelf(true)
end

local function CheckShowArrow(self)
  if not DataCenter.GuideManager:InGuide() then
    self.delayTimer = nil
    if DataCenter.ArrowTipTemplateManager:IsCanShowArrow(ArrowType.LackResource) and self.needResourceCells ~= nil and self.needResourceCells[1] ~= nil then
      local param = {}
      param.position = self.needResourceCells[1].transform.position + Vector3.New(0, 80 * self.transform.lossyScale.y, 0)
      param.arrowType = ArrowType.LackResource
      param.positionType = PositionType.Screen
      param.isPanel = false
      DataCenter.ArrowManager:ShowArrow(param)
    end
  end
end

local function ToggleControlBorS(self, index)
  self.restips_txt:SetActive(false)
  self.content:SetAnchoredPosition({x = 0, y = 0})
  self.toggleIndex = index
  for i = 1, #self.lackResource do
    self.toggleList[i].choose:SetActive(self.toggleList[i]:GetIsOn())
    self.toggleList[i]:SetIsOn(index == i)
  end
  if self.distab[index].isItem then
    self.slider_icon:LoadSprite(DataCenter.RewardManager:GetPicByType(RewardType.GOODS, self.distab[index].resType))
  elseif self.distab[index].isResItem then
    local template = DataCenter.ResourceItemDataManager:GetResourceItemTemplate(self.distab[index].resType)
    if template ~= nil and template.show == 1 then
      self.slider_icon:LoadSprite(template:GetIconPath())
    end
  else
    self.slider_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(self.distab[index].resType))
  end
  if self.distab[index].isItem == true and self.distab[index].disNum == 0 then
    self.slider:SetActive(false)
    self.title:SetLocalText(110018)
  else
    if self.isPVESTAMINA then
      self.title:SetLocalText(104223)
    else
      self.title:SetLocalText(120020)
    end
    self.slider:SetActive(true)
    self.slider_txt:SetText(string.GetFormattedSeperatorNum(self.distab[index].needCount - self.distab[index].disNum) .. "/" .. string.GetFormattedSeperatorNum(self.distab[index].needCount))
    self.slider:SetValue((self.distab[index].needCount - self.distab[index].disNum) / self.distab[index].needCount)
  end
  if 1 > table.count(self.lackResource[index]) then
    self.restips_txt:SetActive(true)
  end
  self:ClearList()
  table.walk(self.lackResource[index], function(k, v)
    self.model[k] = self:GameObjectInstantiateAsync(UIAssets.ResourceLackItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.content.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local nameStr = tostring(v:GetTips())
      go.name = nameStr
      self.needResourceCells[k] = self.content:AddComponent(ResourceLackItem, nameStr)
      self.needResourceCells[k]:ReInit(v, self.distab[index])
      if k == 1 then
        self.needResourceCells[k]:ShowRecommend(true)
        self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
          self:CheckShowArrow()
        end, 0.5)
      end
    end)
  end)
end

local function UseItemSuccessHandle(self, itemId)
  if itemId == "200161" then
    return
  end
  self.isNext = false
  local param = DataCenter.ResLackManager:GetRefreshParam()
  if param == nil then
    return
  end
  if self.isList then
    if param.count < 1 then
      self.ctrl:CloseSelf()
      return
    else
      self.distab[self.toggleIndex].disNum = param.count
      self.toggleList[self.toggleIndex].red:SetActive(true)
    end
    if param.tips == ResLackGoToType.ResourceBagUse then
      for i = 1, #self.lackResource[self.toggleIndex] do
        if self.lackResource[self.toggleIndex][i]:GetTips() == param.tips then
          local isNextItem = self.lackResource[self.toggleIndex][i]:CheckIsOk(param.type, self.distab[self.toggleIndex].needCount)
          if isNextItem then
            self.isNext = true
          end
        end
      end
    end
    if param.useCount == 0 then
      for i = #self.lackResource, 1, -1 do
        for k = #self.lackResource[i], 1, -1 do
          if self.lackResource[i][k]:GetTips() == param.tips then
            if param.tips == ResLackGoToType.ResourceBagUse then
              if i == self.toggleIndex and not self.isNext then
                table.remove(self.lackResource[i], k)
                break
              end
            else
              table.remove(self.lackResource[i], k)
              break
            end
          end
        end
      end
    end
    if param.useCount then
      for i = 1, #self.needResourceCells do
        if self.needResourceCells[i].param:GetTips() == param.tips then
          if param.useCount == 0 then
            if param.tips == ResLackGoToType.ResourceBagUse then
              if not self.isNext then
                table.remove(self.needResourceCells, i)
                self:GameObjectDestroy(self.model[i])
                table.remove(self.model, i)
                break
              end
            else
              table.remove(self.needResourceCells, i)
              self:GameObjectDestroy(self.model[i])
              table.remove(self.model, i)
              break
            end
          else
            self.needResourceCells[i]:CreateConsume(param.useCount)
          end
        end
      end
    end
    for i = 1, #self.lackResource[self.toggleIndex] do
      if self.lackResource[self.toggleIndex][i]:GetTips() == ResLackGoToType.ResourceBagUse or self.lackResource[self.toggleIndex][i]:GetTips() == ResLackGoToType.LoesCamp or self.lackResource[self.toggleIndex][i]:GetTips() == ResLackGoToType.ResourceBagBuy or self.lackResource[self.toggleIndex][i]:GetTips() == ResLackGoToType.UseGoods then
        self.lackResource[self.toggleIndex][i]:CheckIsOk(param.type, self.distab[self.toggleIndex].needCount, self.distab[self.toggleIndex].isResItem)
      end
    end
    for i = 1, #self.needResourceCells do
      self.needResourceCells[i]:ReInit(self.lackResource[self.toggleIndex][i], self.distab[self.toggleIndex])
    end
    self.slider_txt:SetText(string.GetFormattedSeperatorNum(self.distab[self.toggleIndex].needCount - self.distab[self.toggleIndex].disNum) .. "/" .. string.GetFormattedSeperatorNum(self.distab[self.toggleIndex].needCount))
    self.delayTime = TimerManager:GetInstance():DelayInvoke(function()
      self.delayTime:Stop()
      self.delayTime = nil
      self.slider:DOValue((self.distab[self.toggleIndex].needCount - self.distab[self.toggleIndex].disNum) / self.distab[self.toggleIndex].needCount, 0.3, function()
        self.slider:SetValue((self.distab[self.toggleIndex].needCount - self.distab[self.toggleIndex].disNum) / self.distab[self.toggleIndex].needCount)
      end)
    end, 0.2)
  end
end

local function OnRefreshView(self, param)
  self.refreshParam = param
end

local function GuidHandle(self, id)
  DataCenter.ArrowManager:RemoveArrow()
  if self.isList then
    for i = 1, #self.distab do
      local list = self.lackResource[i]
      for k = 1, #list do
        if list[k]:GetTips() == id then
          return true
        end
      end
    end
  end
  return false
end

local function DoClosePanel(self)
  local k, v, startPt = self:GetUserData()
  if startPt ~= nil then
    local time = 0.3
    local closeTime = 0.31
    self.root.transform:DOMove(startPt, time)
    self.root.transform:DOScale(Vector3.New(0.1, 0.1, 0.1), time)
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      if self.delayTimer ~= nil then
        self.delayTimer:Stop()
        self.delayTimer = nil
      end
      self.ctrl:CloseSelf(false)
    end, closeTime)
  else
    self.ctrl:CloseSelf(true)
  end
end

UIResourceLackNewView.OnCreate = OnCreate
UIResourceLackNewView.OnDestroy = OnDestroy
UIResourceLackNewView.OnEnable = OnEnable
UIResourceLackNewView.OnDisable = OnDisable
UIResourceLackNewView.ComponentDefine = ComponentDefine
UIResourceLackNewView.ComponentDestroy = ComponentDestroy
UIResourceLackNewView.OnAddListener = OnAddListener
UIResourceLackNewView.OnRemoveListener = OnRemoveListener
UIResourceLackNewView.ReInit = ReInit
UIResourceLackNewView.ClearList = ClearList
UIResourceLackNewView.OnAddClick = OnAddClick
UIResourceLackNewView.CheckShowArrow = CheckShowArrow
UIResourceLackNewView.ToggleControlBorS = ToggleControlBorS
UIResourceLackNewView.UseItemSuccessHandle = UseItemSuccessHandle
UIResourceLackNewView.OnRefreshView = OnRefreshView
UIResourceLackNewView.GuidHandle = GuidHandle
UIResourceLackNewView.DoClosePanel = DoClosePanel
return UIResourceLackNewView
