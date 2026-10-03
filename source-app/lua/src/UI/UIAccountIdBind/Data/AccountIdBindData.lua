local AccountIdBindData = BaseClass("AccountIdBindData")

function AccountIdBindData:__init()
  self.firstBindMail = ""
  self.changeMail = ""
end

function AccountIdBindData:__delete()
  self.firstBindMail = nil
  self.changeMail = nil
end

return AccountIdBindData
