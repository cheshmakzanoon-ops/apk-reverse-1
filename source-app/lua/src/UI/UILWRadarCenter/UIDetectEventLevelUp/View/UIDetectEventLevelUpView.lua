local UIDetectEventLevelUpView = BaseClass("UIDetectEventLevelUpView", UIBaseView)
local Localization = CS.GameEntry.Localization
local base = UIBaseContainer
local ItemShowNum = 4
local bg = "bg"
local cur_lv_path = "safeArea/levelContent/levelNumContent/levelNumItems/levelNum1"
local next_lv_path = "safeArea/levelContent/levelNumContent/levelNumItems/levelNum2"
local info_content_path = "safeArea/infoAllContent/infoContent"
local info_item_path = "safeArea/infoAllContent/infoContent/infoItem"
local line_content_path = "safeArea/infoAllContent/infoContent/lineContent"
local levelNumItems_path = "safeArea/levelContent/levelNumContent/levelNumItems"
local top_cpntent_path = "safeArea/topCpntent"
local level_content_path = "safeArea/levelContent"
local info_all_content_path = "safeArea/infoAllContent"
local title_path = "safeArea/topCpntent/bg2/title"

local function OnCreate(self)
  base.OnCreate(self)
  local oldLv, curLv = self:GetUserData()
  self.oldLv = oldLv
  self.curLv = curLv
  self.openTime = UITimeManager:GetInstance():GetServerTime()
  self:ComponentDefine()
  self:RefreshView()
end

local function ComponentDefine(self)
  self.bg = self:AddComponent(UIButton, bg)
  self.cur_lv = self:AddComponent(UITextMeshProUGUIEx, cur_lv_path)
  self.next_lv = self:AddComponent(UITextMeshProUGUIEx, next_lv_path)
  self.info_content = self:AddComponent(UIBaseContainer, info_content_path)
  self.bg:SetOnClick(function()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime > self.openTime + 1000 then
      self.ctrl:CloseSelf()
    end
  end)
  self.info_items = {}
  for i = 1, ItemShowNum do
    local root = self:AddComponent(UIBaseContainer, info_item_path .. i)
    self.info_items[i] = {
      root = root,
      name = root:AddComponent(UITextMeshProUGUIEx, "name"),
      curNum = root:AddComponent(UITextMeshProUGUIEx, "curNum"),
      nextNum = root:AddComponent(UITextMeshProUGUIEx, "nextNum")
    }
  end
  self.line_contents = {}
  for i = 1, ItemShowNum do
    local root = self:AddComponent(UIBaseContainer, line_content_path .. i)
    self.line_contents[i] = {root = root}
  end
  self.levelNumItems = self:AddComponent(UIBaseContainer, levelNumItems_path)
  self.top_cpntent = self:AddComponent(UIBaseContainer, top_cpntent_path)
  self.level_content = self:AddComponent(UIBaseContainer, level_content_path)
  self.info_all_content = self:AddComponent(UIBaseContainer, info_all_content_path)
  self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
  self.title:SetLocalText("128027")
end

local function DataDefine(self)
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  self:CloseTweenSeq()
  base.OnDestroy(self)
end

local function CloseTweenSeq(self)
  if self.tweenSeq then
    self.tweenSeq:Kill()
    self.tweenSeq = nil
  end
end

local function ComponentDestroy(self)
  self.bg = nil
  self.cur_lv = nil
  self.next_lv = nil
  self.info_content = nil
  self.info_items = nil
  self.line_contents = nil
  self.levelNumItems = nil
  self.top_cpntent = nil
  self.level_content = nil
  self.info_all_content = nil
  self.title = nil
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshView(self)
  local currentLv = self.oldLv
  local nextLv = self.curLv
  self.cur_lv:SetLocalText(GameDialogDefine.DETECT_POWER, currentLv)
  self.next_lv:SetLocalText(GameDialogDefine.DETECT_POWER, nextLv)
  local curNum = 0
  local nextNum = 0
  local showName = ""
  local showCurTxt = ""
  local showNextTxt = ""
  local showInfoData = {}
  curNum = self.ctrl:GetEventRecoverNum(currentLv)
  nextNum = self.ctrl:GetEventRecoverNum(nextLv)
  if curNum ~= 0 or nextNum ~= 0 then
    showName = Localization:GetString(800804)
    showCurTxt = curNum
    showNextTxt = nextNum
    local showData = {
      showName = showName,
      showCurTxt = showCurTxt,
      showNextTxt = showNextTxt
    }
    table.insert(showInfoData, showData)
  end
  curNum = self.ctrl:GetEventStoreMax(currentLv)
  nextNum = self.ctrl:GetEventStoreMax(nextLv)
  if curNum ~= 0 or nextNum ~= 0 then
    showName = Localization:GetString(140069)
    showCurTxt = curNum
    showNextTxt = nextNum
    local showData = {
      showName = showName,
      showCurTxt = showCurTxt,
      showNextTxt = showNextTxt
    }
    table.insert(showInfoData, showData)
  end
  curNum = self.ctrl:GetDetectEventNum(currentLv)
  nextNum = self.ctrl:GetDetectEventNum(nextLv)
  if curNum ~= 0 or nextNum ~= 0 then
    showName = Localization:GetString(GameDialogDefine.DETECT_EVENT_MAX_NUM)
    showCurTxt = curNum
    showNextTxt = nextNum
    local showData = {
      showName = showName,
      showCurTxt = showCurTxt,
      showNextTxt = showNextTxt
    }
    table.insert(showInfoData, showData)
  end
  curNum = self.ctrl:GetEventResEffect(currentLv)
  nextNum = self.ctrl:GetEventResEffect(nextLv)
  if curNum ~= 0 or nextNum ~= 0 then
    showName = Localization:GetString("effectnumber_name_50206")
    showCurTxt = curNum .. "%"
    showNextTxt = nextNum .. "%"
    local showData = {
      showName = showName,
      showCurTxt = showCurTxt,
      showNextTxt = showNextTxt
    }
    table.insert(showInfoData, showData)
  end
  self.line_contents[ItemShowNum].root:SetActive(false)
  for i = 1, ItemShowNum do
    local showData = showInfoData[i]
    if showData then
      self.info_items[i].root:SetActive(true)
      if 1 < i then
        self.line_contents[i - 1].root:SetActive(true)
      end
      self.info_items[i].name:SetText(showData.showName)
      self.info_items[i].curNum:SetText(showData.showCurTxt)
      self.info_items[i].nextNum:SetText(showData.showNextTxt)
    else
      self.info_items[i].root:SetActive(false)
      if 1 < i then
        self.line_contents[i - 1].root:SetActive(false)
      end
    end
  end
  self:CloseTweenSeq()
  self.levelNumItems.transform.localPosition = Vector3.New(0, -50)
  self.top_cpntent:SetLocalScaleXYZ(0, 0, 0)
  self.level_content:SetLocalScaleXYZ(0, 0, 0)
  self.info_all_content:SetLocalScaleXYZ(0, 0, 0)
  self.tweenSeq = DOTween.Sequence()
  self.tweenSeq:AppendInterval(0.1)
  self.tweenSeq:Append(self.top_cpntent.transform:DOScale(Vector3.one, 0.13))
  self.tweenSeq:Append(self.level_content.transform:DOScale(Vector3.one, 0.13))
  self.tweenSeq:Append(self.levelNumItems.transform:DOLocalMoveY(50, 0.3))
  self.tweenSeq:Append(self.info_all_content.transform:DOScale(Vector3.one, 0.13))
end

UIDetectEventLevelUpView.OnCreate = OnCreate
UIDetectEventLevelUpView.OnDestroy = OnDestroy
UIDetectEventLevelUpView.ComponentDefine = ComponentDefine
UIDetectEventLevelUpView.ComponentDestroy = ComponentDestroy
UIDetectEventLevelUpView.DataDefine = DataDefine
UIDetectEventLevelUpView.DataDestroy = DataDestroy
UIDetectEventLevelUpView.OnDisable = OnDisable
UIDetectEventLevelUpView.OnEnable = OnEnable
UIDetectEventLevelUpView.RefreshView = RefreshView
UIDetectEventLevelUpView.CloseTweenSeq = CloseTweenSeq
return UIDetectEventLevelUpView
