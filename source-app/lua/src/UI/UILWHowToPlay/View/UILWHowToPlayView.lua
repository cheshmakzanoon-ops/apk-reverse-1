local UILWHowToPlayView = BaseClass("UILWHowToPlayView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWHowToPlayTabComponent = require("UI/UILWHowToPlay/Component/UILWHowToPlayTabComponent")
local tolerance = 20
local doubleClickInterval = 0.5

function UILWHowToPlayView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UILWHowToPlayView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWHowToPlayView:ComponentDefine()
  self.btnBlack = self:AddComponent(UIButton, "black")
  self.btnBlack:SetOnClick(function()
    self:OnBtnBlackClick()
  end)
  self.textTxtTitle = self:AddComponent(UITextMeshProUGUIEx, "bg/top/txtTitle")
  self.btnClose = self:AddComponent(UIButton, "bg/top/btnClose")
  self.btnClose:SetOnClick(function()
    self:OnBtnCloseClick()
  end)
  self.btnInfo = self:AddComponent(UIButton, "bg/top/infoBtn")
  self.btnInfo.clickSound = 6100046
  self.btnInfo:SetOnClick(function()
    self:OnInfoBtnClick()
  end)
  self.btnReturn = self:AddComponent(UIButton, "bg/top/returnBtn")
  self.btnReturn.clickSound = 6100046
  self.btnReturn:SetOnClick(function()
    self:OnReturnBtnClick()
  end)
  self.rawImgIcon1 = self:AddComponent(UIRawImage, "bg/bg2/root/icon1")
  self.rawImgIcon2 = self:AddComponent(UIRawImage, "bg/bg2/root/icon2")
  self.rawImgIcon3 = self:AddComponent(UIRawImage, "bg/bg2/root/icon3")
  self.rawImgIcon4 = self:AddComponent(UIRawImage, "bg/bg2/root/icon4")
  self.textContent1 = self:AddComponent(UITextMeshProUGUIEx, "bg/bg2/root/content1")
  self.textContent2 = self:AddComponent(UITextMeshProUGUIEx, "bg/bg2/root/content2")
  self.textContent3 = self:AddComponent(UITextMeshProUGUIEx, "bg/bg2/root/content3")
  self.textContent4 = self:AddComponent(UITextMeshProUGUIEx, "bg/bg2/root/content4")
  self.rawImgIcon4_2 = self:AddComponent(UIRawImage, "bg/bg2/root/icon4_2")
  self.textContent4_2 = self:AddComponent(UITextMeshProUGUIEx, "bg/bg2/root/content4_2")
  self.graphGroup = self:AddComponent(UIBaseContainer, "bg/bg2")
  self.ruleGroup = self:AddComponent(UIBaseContainer, "bg/rules")
  self.ruleTitle = self:AddComponent(UITextMeshProUGUIEx, "bg/rules/ruleTitle")
  self.ruleContent = self:AddComponent(UITextMeshProUGUIEx, "bg/rules/Scroll View/Viewport/ruleContent")
  self.ruleTitle:SetText(Localization:GetString("howtoplay_rulestitle"))
  self.tabs = self:AddComponent(UIBaseContainer, "bg/bg2/tabs")
  self.tab = self:AddComponent(UIBaseContainer, "bg/bg2/tab")
  self.tab_obj = self.tab.transform.gameObject
  self.tab_obj:GameObjectCreatePool()
  self.rightArrow = self:AddComponent(UIButton, "bg/bg2/rightArrow")
  self.leftArrow = self:AddComponent(UIButton, "bg/bg2/leftArrow")
  self.rightArrow:SetOnClick(function()
    self:OnRightArrowClick()
  end)
  self.leftArrow:SetOnClick(function()
    self:OnLeftArrowClick()
  end)
  self.line = self:AddComponent(UIBaseContainer, "bg/bg2/root/line")
  self.line1 = self:AddComponent(UIBaseContainer, "bg/bg2/root/line1")
  self.line2 = self:AddComponent(UIBaseContainer, "bg/bg2/root/line2")
  self.arrow = self:AddComponent(UIBaseContainer, "bg/bg2/root/arrow1")
  self.arrow1 = self:AddComponent(UIBaseContainer, "bg/bg2/root/arrow2")
  self.arrow2 = self:AddComponent(UIBaseContainer, "bg/bg2/root/arrow3")
  self.graphEventTrigger = self:AddComponent(UIEventTrigger, "bg/bg2")
  self.graphEventTrigger:OnPointerDown(function(eventData)
    self:OnPointerDown(eventData)
  end)
  self.graphEventTrigger:OnPointerUp(function(eventData)
    self:OnPointerUp(eventData)
  end)
  self.tab:SetActive(false)
  self.anim = self:AddComponent(UIAnimator, "")
end

function UILWHowToPlayView:ComponentDestroy()
  self.btnBlack = nil
  self.textTxtTitle = nil
  self.btnClose = nil
  self.rawImgIcon1 = nil
  self.rawImgIcon2 = nil
  self.rawImgIcon3 = nil
  self.rawImgIcon4 = nil
  self.textContent1 = nil
  self.textContent2 = nil
  self.textContent3 = nil
  self.textContent4 = nil
  self.rawImgIcon4_2 = nil
  self.textContent4_2 = nil
  if self.tab_obj then
    self.tab_obj:GameObjectRecycleAll()
  end
  self.tabs:RemoveComponents(UILWHowToPlayTabComponent)
  self.tab = nil
  self.tabs = nil
  self.leftArrow = nil
  self.rightArrow = nil
end

function UILWHowToPlayView:DataDefine()
  self.tabCells = nil
  self.isRebuild = false
end

function UILWHowToPlayView:DataDestroy()
  self.tabCells = nil
  self.changing = false
  self.isClick = false
  self.isRebuild = nil
end

function UILWHowToPlayView:OnAddListener()
  base.OnAddListener(self)
end

function UILWHowToPlayView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWHowToPlayView:OnBtnBlackClick()
  self.ctrl:CloseSelf()
end

function UILWHowToPlayView:OnBtnCloseClick()
  self.ctrl:CloseSelf()
end

function UILWHowToPlayView:OnInfoBtnClick()
  self:ShowRules()
  if self.ruleContent and not self.isRebuild then
    self.isRebuild = true
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.ruleContent.rectTransform)
  end
  self.anim:Play("V_ui_HowToPlay_switch", 0, 0)
end

function UILWHowToPlayView:OnReturnBtnClick()
  self:ShowGraph()
  self.anim:Play("V_ui_HowToPlay_switch_back", 0, 0)
end

function UILWHowToPlayView:ReInit()
  self.clickCount = 0
  self.lastClickTime = 0
  local param = self:GetUserData()
  if param == nil then
    self.ctrl:CloseSelf()
    return
  end
  if param.soundId and 0 < param.soundId then
    DataCenter.LWSoundManager:PlaySound(param.soundId)
  end
  if IsNumber(param.howToPlayList) then
    self.idList = {
      tonumber(param.howToPlayList)
    }
  else
    self.idList = param.howToPlayList
  end
  if self.idList == nil then
    self.ctrl:CloseSelf()
    return
  end
  local count = #self.idList
  if count < 1 then
    self.ctrl:CloseSelf()
    return
  end
  self.idIndex = 0
  self.idCount = count
  local story = param.story
  local customRuleStr = param.customRuleStr
  if not string.IsNullOrEmpty(story) then
    self.ruleContent:SetText(Localization:GetString(story))
    self.btnInfo:SetActive(true)
  elseif not string.IsNullOrEmpty(customRuleStr) then
    self.ruleContent:SetText(customRuleStr)
    self.btnInfo:SetActive(true)
  else
    self.ruleContent:SetText(nil)
    self.btnInfo:SetActive(false)
  end
  self.defaultTitle = param.defaultTitle
  self:ShowIndex(1)
  DataCenter.LWSoundManager:PlaySound(6100045, false)
  self:ShowGraph()
end

function UILWHowToPlayView:RefreshArrow()
  self.leftArrow:SetActive(self.idIndex > 1)
  self.rightArrow:SetActive(self.idIndex < self.idCount)
end

function UILWHowToPlayView:ShowTabs()
  if self.tabCells ~= nil then
    for i, tab in ipairs(self.tabCells) do
      tab:SetData(self.idIndex == i)
    end
    return
  end
  self.tabCells = {}
  for i = 1, self.idCount do
    local tab = self.tab_obj:GameObjectSpawn(self.tabs.transform)
    local tabName = "tab_" .. i
    tab.name = tabName
    tab:SetActive(true)
    local comp = self.tabs:AddComponent(UILWHowToPlayTabComponent, tabName)
    comp:SetData(self.idIndex == i)
    self.tabCells[i] = comp
  end
end

function UILWHowToPlayView:ShowIndex(index)
  if self.idIndex == index then
    return
  end
  self.idIndex = index
  local id = self.idList[index]
  if id == nil then
    return
  end
  local cfgData = LocalController:instance():getLine(TableName.LW_HOW_TO_PLAY, id)
  if cfgData == nil then
    return
  end
  local infoKey = cfgData.info
  if not string.IsNullOrEmpty(infoKey) then
    self.ruleContent:SetLocalText(infoKey)
    self.btnInfo:SetActive(true)
    self.isRebuild = false
  end
  local title = cfgData.howtoplaytitle
  if string.IsNullOrEmpty(title) then
    title = self.defaultTitle
    if string.IsNullOrEmpty(title) then
      self.textTxtTitle:SetText(nil)
    else
      self.textTxtTitle:SetText(Localization:GetString(title))
    end
  else
    self.textTxtTitle:SetText(Localization:GetString(title))
  end
  local pic1 = cfgData.pic1_path
  if string.IsNullOrEmpty(pic1) then
    self.rawImgIcon1:SetActive(false)
  else
    self.rawImgIcon1:SetActive(true)
    self.rawImgIcon1:LoadSpriteAsyncWithCallback(pic1, function(texture)
      if self.rawImgIcon1 then
        self.rawImgIcon1:SetNativeSize()
      end
    end)
  end
  local desc1 = cfgData.desc_1
  if string.IsNullOrEmpty(desc1) then
    self.textContent1:SetText(nil)
  else
    self.textContent1:SetText(Localization:GetString(desc1))
  end
  local arrowShow, lineShow
  local pic2 = cfgData.pic2_path
  if string.IsNullOrEmpty(pic2) then
    self.rawImgIcon2:SetActive(false)
  else
    arrowShow = true
    lineShow = true
    self.rawImgIcon2:SetActive(true)
    self.rawImgIcon2:LoadSpriteAsyncWithCallback(pic2, function(texture)
      if self.rawImgIcon2 then
        self.rawImgIcon2:SetNativeSize()
      end
    end)
  end
  local desc2 = cfgData.desc_2
  if string.IsNullOrEmpty(desc2) then
    self.textContent2:SetText(nil)
  else
    lineShow = true
    self.textContent2:SetText(Localization:GetString(desc2))
  end
  self.line:SetActive(lineShow)
  self.arrow:SetActive(arrowShow)
  local pic3 = cfgData.pic3_path
  if string.IsNullOrEmpty(pic3) then
    self.rawImgIcon3:SetActive(false)
  else
    arrowShow = true
    lineShow = true
    self.rawImgIcon3:SetActive(true)
    self.rawImgIcon3:LoadSpriteAsyncWithCallback(pic3, function(texture)
      if self.rawImgIcon3 then
        self.rawImgIcon3:SetNativeSize()
      end
    end)
  end
  local desc3 = cfgData.desc_3
  if string.IsNullOrEmpty(desc3) then
    self.textContent3:SetText(nil)
  else
    lineShow = true
    self.textContent3:SetText(Localization:GetString(desc3))
  end
  self.line1:SetActive(lineShow)
  self.arrow1:SetActive(arrowShow)
  local type = cfgData.type
  if type == 1 then
    self.textContent4_2:SetActive(false)
    self.rawImgIcon4_2:SetActive(false)
    self.textContent4:SetActive(true)
    self.rawImgIcon4:SetActive(true)
    local pic4 = cfgData.pic4_path
    if string.IsNullOrEmpty(pic4) then
      self.rawImgIcon4:SetActive(false)
    else
      arrowShow = true
      lineShow = true
      self.rawImgIcon4:SetActive(true)
      self.rawImgIcon4:LoadSpriteAsyncWithCallback(pic4, function(texture)
        if self.rawImgIcon4 then
          self.rawImgIcon4:SetNativeSize()
        end
      end)
    end
    local desc4 = cfgData.desc_4
    if string.IsNullOrEmpty(desc4) then
      self.textContent4:SetText(nil)
    else
      lineShow = true
      self.textContent4:SetText(Localization:GetString(desc4))
    end
    self.line2:SetActive(lineShow)
    self.arrow2:SetActive(arrowShow)
  elseif type == 2 then
    self.textContent4_2:SetActive(true)
    self.rawImgIcon4_2:SetActive(true)
    self.textContent4:SetActive(false)
    self.rawImgIcon4:SetActive(false)
    local pic4 = cfgData.pic4_path
    if string.IsNullOrEmpty(pic4) then
      self.rawImgIcon4_2:SetActive(false)
    else
      arrowShow = true
      lineShow = true
      self.rawImgIcon4_2:SetActive(true)
      self.rawImgIcon4_2:LoadSpriteAsyncWithCallback(pic4, function(texture)
        if self.rawImgIcon4_2 then
          self.rawImgIcon4_2:SetNativeSize()
        end
      end)
    end
    local desc4 = cfgData.desc_4
    if string.IsNullOrEmpty(desc4) then
      self.textContent4_2:SetText(nil)
    else
      lineShow = true
      self.textContent4_2:SetText(Localization:GetString(desc4))
    end
    self.line2:SetActive(lineShow)
    self.arrow2:SetActive(arrowShow)
  else
    Logger.LogError("HowToPlay invalid type : " .. type .. " . cfg id : " .. id)
    return
  end
  self:ShowTabs()
  self:RefreshArrow()
end

function UILWHowToPlayView:ShowGraph()
  self.btnInfo:SetActive(true)
  self.btnReturn:SetActive(false)
  self.graphGroup:SetActive(true)
  self.ruleGroup:SetActive(false)
  self.tabs:SetActive(true)
  self:RefreshArrow()
end

function UILWHowToPlayView:ShowRules()
  self.btnInfo:SetActive(false)
  self.btnReturn:SetActive(true)
  self.graphGroup:SetActive(false)
  self.ruleGroup:SetActive(true)
  self.tabs:SetActive(false)
  self.leftArrow:SetActive(false)
  self.rightArrow:SetActive(false)
end

function UILWHowToPlayView:OnLeftArrowClick()
  local newIndex = self.idIndex - 1
  if 0 < newIndex then
    self:ShowIndex(newIndex)
    if self.changingAnimLength == nil then
      local ret, length = self.anim:PlayAnimationReturnTime("UILWHowToPlay_change")
      if ret then
        self.changingAnimLength = length
        self.changing = true
        self.changingTime = Time.realtimeSinceStartup
      end
      return
    end
    self.anim:Play("UILWHowToPlay_change", 0, 0)
    self.changing = true
    self.changingTime = Time.realtimeSinceStartup
  end
end

function UILWHowToPlayView:OnRightArrowClick()
  local newIndex = self.idIndex + 1
  if newIndex <= self.idCount then
    self:ShowIndex(newIndex)
    if self.changingAnimLength == nil then
      local ret, length = self.anim:PlayAnimationReturnTime("UILWHowToPlay_change")
      if ret then
        self.changingAnimLength = length
        self.changing = true
        self.changingTime = Time.realtimeSinceStartup
      end
      return
    end
    self.anim:Play("UILWHowToPlay_change", 0, 0)
    self.changing = true
    self.changingTime = Time.realtimeSinceStartup
  end
end

function UILWHowToPlayView:OnPointerDown(eventData)
  self.isClick = true
  local pos = eventData.position
  self.clickX = pos.x
end

function UILWHowToPlayView:OnPointerUp(eventData)
  if self.isClick then
    self.isClick = nil
    local pos = eventData.position
    local curX = pos.x
    if Mathf.Abs(curX - self.clickX) > tolerance then
      if curX < self.clickX then
        self:OnRightArrowClick()
      else
        self:OnLeftArrowClick()
      end
      return
    end
  end
end

return UILWHowToPlayView
