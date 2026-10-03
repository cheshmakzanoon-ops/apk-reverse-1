local UILWAlHelpItem = BaseClass("UILWAlHelpItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local playerHead = "UIPlayerHead"
local name_txt_path = "NameTxt"
local desc_txt_path = "DescTxt"
local slider_path = "Slider"
local slider_txt_path = "Slider/HelpedTxt"
local reduce_time_txt_path = "Slider/ReduceTxt"
local special_bg = "SpecialBg"

function UILWAlHelpItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlHelpItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlHelpItem:ComponentDefine()
  self.playerHead = self:AddComponent(UICommonHead, playerHead)
  self.nameTxt = self:AddComponent(UIText, name_txt_path)
  self.descTxt = self:AddComponent(UIText, desc_txt_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.sliderProgressTxt = self:AddComponent(UIText, slider_txt_path)
  self.reduceTimeTxt = self:AddComponent(UIText, reduce_time_txt_path)
  self.specialBg = self:AddComponent(UIBaseContainer, special_bg)
  self.sliderProgressCanvas = self.transform:Find(slider_txt_path).gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self.reduceTimeCanvas = self.transform:Find(reduce_time_txt_path).gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
end

function UILWAlHelpItem:ComponentDestroy()
  self.playerHead = nil
  self.nameTxt = nil
  self.descTxt = nil
  self.slider = nil
  self.sliderProgressTxt = nil
  self.reduceTimeTxt = nil
  self.specialBg = nil
  self.sliderProgressCanvas = nil
  self.reduceTimeCanvas = nil
end

function UILWAlHelpItem:DataDefine()
  self.data = {}
end

function UILWAlHelpItem:DataDestroy()
  self.data = nil
end

function UILWAlHelpItem:OnEnable()
  base.OnEnable(self)
end

function UILWAlHelpItem:OnDisable()
  base.OnDisable(self)
end

function UILWAlHelpItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.AllianceHelpUpdateItem, self.RefreshItem)
end

function UILWAlHelpItem:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.AllianceHelpUpdateItem, self.RefreshItem)
end

function UILWAlHelpItem:SetItemShow(data)
  self.data = data
  local playerUuid = LuaEntry.Player:GetUid()
  if self.data.uid == playerUuid then
    local playerPic = LuaEntry.Player:GetPic()
    local playerPicVer = LuaEntry.Player.picVer
    local playerHeadSkinPath = LuaEntry.Player:GetHeadBgImg()
    self.playerHead:SetData(playerUuid, playerPic, playerPicVer, nil, playerHeadSkinPath)
  else
    self.playerHead:SetData(self.data.uid, self.data.pic, self.data.picVer, nil, self.data.headBg)
  end
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.data.uid, self.data.name)
  self.nameTxt:SetText(showName)
  self.descTxt:SetText(self.data.des)
  local strReduce = UITimeManager:GetInstance():MilliSecondToFmtString(self.data.reduceSec * 1000)
  self.reduceTimeTxt:SetLocalText(141084, strReduce)
  self.sliderProgressTxt:SetText(self.data.nowCount .. "/" .. self.data.maxCount)
  local percent = self.data.nowCount / math.max(1, self.data.maxCount)
  self.slider:SetValue(percent)
  self.specialBg:SetActive(false)
  self.slider:SetActive(false)
  if self.data.uid == LuaEntry.Player.uid then
    self.specialBg:SetActive(true)
    self.slider:SetActive(true)
  end
end

function UILWAlHelpItem:SetShowReduce(showReduce, has_duration)
  if not self.reduceTimeTxt then
    return
  end
  if not self.sliderProgressTxt then
    return
  end
  local duration = has_duration and 0.3 or 0
  if showReduce then
    self.reduceTimeCanvas:DOFade(1, duration)
    self.sliderProgressCanvas:DOFade(0, duration)
  else
    self.reduceTimeCanvas:DOFade(0, duration)
    self.sliderProgressCanvas:DOFade(1, duration)
  end
end

local function RefreshItem(self, data)
  if data and self.data and data.helpId == self.data.helpId then
    self.data = data
    local strReduce = UITimeManager:GetInstance():MilliSecondToFmtString(data.reduceSec * 1000)
    self.reduceTimeTxt:SetLocalText(141084, strReduce)
    self.sliderProgressTxt:SetText(data.nowCount .. "/" .. data.maxCount)
    local percent = data.nowCount / math.max(1, data.maxCount)
    self.slider:SetValue(percent)
    self.specialBg:SetActive(false)
    if data.uid == LuaEntry.Player.uid then
      self.specialBg:SetActive(true)
    end
  end
end

UILWAlHelpItem.RefreshItem = RefreshItem
return UILWAlHelpItem
