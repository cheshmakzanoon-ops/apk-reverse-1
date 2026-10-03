local base = UIBaseContainer
local HistoryRobComponent = BaseClass("HistoryRobComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function HistoryRobComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function HistoryRobComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function HistoryRobComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.imgWinLose = self.viewSkin:AddComponent(self, UIImage, 1)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTime = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnLWInfo = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnLWInfo:SetOnClick(function()
    self:OnBtnLWInfoClick()
  end)
  self.imgHistroyRob = self.viewSkin:AddComponent(self, UIImage, 6)
end

function HistoryRobComponent:ComponentDestroy()
  self.viewSkin = nil
  self.imgWinLose = nil
  self.textTitle = nil
  self.textDesc = nil
  self.textTime = nil
  self.btnLWInfo = nil
  self.imgHistroyRob = nil
end

function HistoryRobComponent:DataDefine()
end

function HistoryRobComponent:DataDestroy()
end

function HistoryRobComponent:OnAddListener()
  base.OnAddListener(self)
end

function HistoryRobComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function HistoryRobComponent:OnBtnLWInfoClick()
end

function HistoryRobComponent:SetData(params)
  self.recordData = params
  if not self.recordData then
    return
  end
  self.mailUid = self.recordData.uid
  if not self.mailUid then
    return
  end
  local mainTitle = MailShowHelper.GetMainTitle(self.recordData)
  self.textTitle:SetText(mainTitle)
  local subTitle = MailShowHelper.GetMailSubTitle(self.recordData)
  self.textDesc:SetText(subTitle)
  local createTime = MailShowHelper.GetRelativeCreateTime(self.recordData)
  self.textTime:SetText(createTime)
  self:RefreshIcon()
  if self.recordData and self.recordData:IsBattleReportMailType() and not self.recordData:IsBattleReportIntegrity() then
    self.recordData:OnMailIntegrityExecute(function(mailInfo)
      if self.view and self.recordData.uid == mailInfo.uid then
        self:SetData(params)
      end
    end)
  end
end

function HistoryRobComponent:RefreshIcon()
  local win_icon_path
  local data = self.recordData:GetMailExt()
  if data.selfWin then
    win_icon_path = "Assets/Main/Sprites/UI/UILWMail/zyf_youjian_victory.png"
  else
    win_icon_path = "Assets/Main/Sprites/UI/UILWMail/zyf_youjian_defeat.png"
  end
  if win_icon_path then
    self.imgWinLose:SetActive(true)
    self.imgWinLose:LoadSprite(win_icon_path)
    self.imgWinLose:SetNativeSize()
  else
    self.imgWinLose:SetActive(false)
  end
end

function HistoryRobComponent:OnBtnLWInfoClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMailMain, {anim = false}, UIMailOpenType.Detail, self.mailUid, "HSRRecord")
end

return HistoryRobComponent
