local base = UIAsyncContainer
local LLRuleStageItem = BaseClass("LLRuleStageItem", UIAsyncContainer)
local Localization = CS.GameEntry.Localization
local KEY1 = "Mjc_huodong_laba_xianshimubiao_icon01.png"
local KEY2 = "Mjc_huodong_laba_xianshimubiao_icon02.png"

function LLRuleStageItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLRuleStageItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLRuleStageItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgIndexBg = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textIndex = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.btn = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.textButton = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compItem = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.imgBgTop = self.viewSkin:AddComponent(self, UIImage, 7)
  self.compBtn = self.viewSkin:AddComponent(self, UIBaseComponent, 8)
end

function LLRuleStageItem:ComponentDestroy()
  self.viewSkin = nil
  self.imgIndexBg = nil
  self.textIndex = nil
  self.btn = nil
  self.textButton = nil
  self.textTitle = nil
  self.compItem = nil
  self.imgBgTop = nil
  self.compBtn = nil
end

function LLRuleStageItem:DataDefine()
  self.compItem:SetActive(false)
  self.compItem.gameObject:GameObjectCreatePool()
  self.items = {}
end

function LLRuleStageItem:DataDestroy()
  if self.items ~= nil then
    for _, v in ipairs(self.items) do
      self:RemoveComponent(v:GetName(), UIBaseContainer)
    end
  end
  self.compItem.gameObject:GameObjectRecycleAll()
  self.ruleConfig = nil
  self.items = nil
end

function LLRuleStageItem:OnAddListener()
  base.OnAddListener(self)
end

function LLRuleStageItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLRuleStageItem:OnBtnClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  local jump = self.ruleConfig ~= nil and self.ruleConfig.jump or 0
  if jump == 6 then
    local param = {
      howToPlayList = {500014}
    }
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
  elseif jump == 2 then
    EventManager:GetInstance():Broadcast(EventId.LandlordRuleTabIndex, {
      tab = LLConst.RuleType.Rule
    })
  elseif jump == 3 then
    EventManager:GetInstance():Broadcast(EventId.LandlordRuleTabIndex, {
      tab = LLConst.RuleType.Build
    })
  elseif jump == 4 then
    EventManager:GetInstance():Broadcast(EventId.LandlordRuleTabIndex, {
      tab = LLConst.RuleType.Battle
    })
  elseif jump == 5 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILLReward)
  end
end

function LLRuleStageItem:SetData(ruleConfig, curIndex)
  self.ruleConfig = ruleConfig
  self.curIndex = curIndex
  self.index = ruleConfig.sequence
  self:RefreshView()
end

function LLRuleStageItem:UpdateData()
  if self.ruleConfig == nil then
    return
  end
  self.textIndex:SetText(self.index)
  local openFlag = self.index <= self.curIndex
  self.imgBgTop:LoadSpriteAuto(string.format(LoadPath.LandlordPath, openFlag and "zxl_shamo_biaoti_huang.png" or "zxl_shamo_biaoti_hui.png"))
  self.imgIndexBg:LoadSpriteAuto(string.format(LoadPath.LandlordPath, openFlag and KEY1 or KEY2))
  local stageInfo = DataCenter.LandlordMgr:GetActStageInfo(self.index)
  local sTime = stageInfo ~= nil and stageInfo.sTime or 0
  local eTime = stageInfo ~= nil and stageInfo.eTime or 0
  self.textTitle:SetText(string.format("%s~%s %s", self:GetTimeToMD(sTime), self:GetTimeToMD(eTime), Localization:GetString(self.ruleConfig.tittle)))
  local descList = string.split(self.ruleConfig.desc, ",")
  for i, descKey in ipairs(descList) do
    local item = self.items[i]
    if item == nil then
      local obj = self.compItem.gameObject:GameObjectSpawn(self.transform)
      obj.name = "Item_" .. i
      item = self:AddComponent(UIBaseContainer, obj.name)
      self.items[i] = item
    end
    local text = item:GetComponent("Desc", UITextMeshProUGUIEx)
    if text == nil then
      text = item:AddComponent(UITextMeshProUGUIEx, "Desc")
    end
    text:SetLocalText(descKey)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(text.transform)
  end
  if 0 < self.ruleConfig.jump then
    self.compBtn:SetAsLastSibling()
    self.compBtn:SetActive(true)
    self.textButton:SetLocalText(self.ruleConfig.button)
  else
    self.compBtn:SetActive(false)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
end

function LLRuleStageItem:GetTimeToMD(second)
  local format = UITimeManager:GetInstance():TimeSecToServerDate(second)
  local format_time = string.format("%0d/%0d", format.month, format.day)
  return format_time
end

return LLRuleStageItem
