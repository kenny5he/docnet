package.path = '/usr/local/openresty/lualib?.lua;/usr/local/openresty/site/lualib/?.lua;'
local header_userid_key = "userid"
local header_deviceid_key = "deviceid"
local checkWhiteList = require("checkWhiteList")
local redisutils = require("redisutils")
local red = redisutils.redisClient()
local headers = ngx.req.get_headers()
local deviceid = headers[header_deviceid_key]
local userId = headers[header_userid_key]


if red then
  local pre_production = checkWhiteList.checkIp(red)
  if not pre_production then
    pre_production = checkWhiteList.checkUserId(red, userId)
  end
  if not pre_production then
    pre_production = checkWhiteList.checkDeviceId(red, deviceid)
  end
  if pre_production then
    ngx.var.proxyName= ngx.var.preProxy
  end
  redisutils.closeRedis(red)
end